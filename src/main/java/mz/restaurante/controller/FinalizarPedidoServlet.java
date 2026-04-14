package mz.restaurante.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mz.restaurante.dao.FreteDAO;
import mz.restaurante.dao.PedidoDAO;
import mz.restaurante.model.ItemCarrinho;
import mz.restaurante.model.Pedido;
import mz.restaurante.util.HorarioUtil;

@WebServlet("/finalizarPedido")
public class FinalizarPedidoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Map<Integer, ItemCarrinho> carrinho = (Map<Integer, ItemCarrinho>) session.getAttribute("carrinho");
		if (carrinho == null || carrinho.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/carrinho");
			return;
		}

		// Calcular subtotal e total (sem frete ainda)
		double subtotal = 0;
		for (ItemCarrinho item : carrinho.values()) {
			subtotal += item.getSubtotal();
		}
		request.setAttribute("subtotal", subtotal);

		try {
			FreteDAO freteDAO = new FreteDAO();
			request.setAttribute("bairros", freteDAO.listarBairros());
		} catch (SQLException e) {
			e.printStackTrace();
		}

		request.getRequestDispatcher("/finalizar.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Map<Integer, ItemCarrinho> carrinho = (Map<Integer, ItemCarrinho>) session.getAttribute("carrinho");
		if (carrinho == null || carrinho.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/carrinho");
			return;
		}

		// Verificar horário de funcionamento
		if (!HorarioUtil.isFuncionando()) {
			request.setAttribute("erro",
					"Restaurante fechado no momento. Pedidos apenas das 10h às 22h (segunda a sábado).");
			doGet(request, response);
			return;
		}

		String nome = request.getParameter("nome");
		String telefone = request.getParameter("telefone");
		String endereco = request.getParameter("endereco");
		String bairro = request.getParameter("bairro");

		if (nome == null || telefone == null || endereco == null || bairro == null || nome.trim().isEmpty()
				|| telefone.trim().isEmpty() || endereco.trim().isEmpty()) {
			request.setAttribute("erro", "Preencha todos os campos.");
			doGet(request, response);
			return;
		}

		// Calcular subtotal e montar string de itens
		double subtotal = 0;
		StringBuilder itensStr = new StringBuilder();
		for (ItemCarrinho item : carrinho.values()) {
			subtotal += item.getSubtotal();
			itensStr.append(item.getQuantidade()).append("x ").append(item.getNome()).append(" (")
					.append(item.getPreco()).append(" MT)\n");
		}

		// Calcular frete
		double frete = 0;
		String tempoEntrega = "";
		try {
			FreteDAO freteDAO = new FreteDAO();
			frete = freteDAO.getValorFrete(bairro);
			tempoEntrega = freteDAO.getTempoEntrega(bairro);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		double total = subtotal + frete;

		Pedido pedido = new Pedido();
		pedido.setClienteNome(nome);
		pedido.setTelefone(telefone);
		pedido.setEndereco(endereco + " - " + bairro);
		pedido.setItens(itensStr.toString() + "\nSubtotal: " + subtotal + " MT\nFrete: " + frete + " MT\nTotal: "
				+ total + " MT");
		pedido.setStatus("Pendente");

		try {
			PedidoDAO dao = new PedidoDAO();
			dao.inserir(pedido);
			session.removeAttribute("carrinho");

			// Notificação WhatsApp
			String numeroCliente = telefone.replaceAll("\\D", "");
			if (!numeroCliente.startsWith("258"))
				numeroCliente = "258" + numeroCliente;
			String msg = "Olá " + nome + ", seu pedido #" + pedido.getId() + " foi recebido! Total: " + total
					+ " MT. Tempo estimado: " + tempoEntrega;
			String linkWhatsApp = "https://wa.me/" + numeroCliente + "?text="
					+ URLEncoder.encode(msg, StandardCharsets.UTF_8);

			request.setAttribute("pedidoId", pedido.getId());
			request.setAttribute("linkWhatsApp", linkWhatsApp);
			request.setAttribute("total", total);
			request.getRequestDispatcher("/confirmacao.jsp").forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("erro", "Erro ao salvar pedido. Tente novamente.");
			doGet(request, response);
		}
	}
}