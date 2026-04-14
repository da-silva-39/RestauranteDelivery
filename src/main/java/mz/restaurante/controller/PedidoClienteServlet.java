package mz.restaurante.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mz.restaurante.dao.PedidoDAO;
import mz.restaurante.dao.ProdutoDAO;
import mz.restaurante.model.Pedido;
import mz.restaurante.util.HorarioUtil;

@WebServlet("/fazerPedido")
public class PedidoClienteServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!HorarioUtil.isFuncionando()) {
			request.setAttribute("msgPedido",
					"Restaurante fechado no momento. Pedidos apenas das 10h às 22h (segunda a sábado).");
			carregarProdutos(request);
			request.getRequestDispatcher("/home.jsp").forward(request, response);
			return;
		}
		String nome = request.getParameter("nome");
		String telefone = request.getParameter("telefone");
		String endereco = request.getParameter("endereco");
		String itens = request.getParameter("itens");
		if (nome == null || telefone == null || endereco == null || itens == null || nome.trim().isEmpty()) {
			request.setAttribute("msgPedido", "Preencha todos os campos.");
			carregarProdutos(request);
			request.getRequestDispatcher("/home.jsp").forward(request, response);
			return;
		}
		Pedido pedido = new Pedido();
		pedido.setClienteNome(nome);
		pedido.setTelefone(telefone);
		pedido.setEndereco(endereco);
		pedido.setItens(itens);
		pedido.setStatus("Pendente");
		try {
			PedidoDAO dao = new PedidoDAO();
			dao.inserir(pedido);
			String numeroCliente = telefone.replaceAll("\\D", "");
			if (!numeroCliente.startsWith("258"))
				numeroCliente = "258" + numeroCliente;
			String msg = "Olá " + nome + ", seu pedido #" + pedido.getId() + " foi recebido! Obrigado.";
			String link = "https://wa.me/" + numeroCliente + "?text=" + URLEncoder.encode(msg, StandardCharsets.UTF_8);
			request.setAttribute("linkWhatsApp", link);
			request.setAttribute("pedidoId", pedido.getId());
			request.setAttribute("msgPedido",
					"Pedido realizado com sucesso! Clique no link para ser notificado via WhatsApp.");
		} catch (SQLException e) {
			request.setAttribute("msgPedido", "Erro ao enviar pedido. Tente novamente.");
		}
		carregarProdutos(request);
		request.getRequestDispatcher("/home.jsp").forward(request, response);
	}

	private void carregarProdutos(HttpServletRequest request) throws ServletException {
		try {
			request.setAttribute("produtos", new ProdutoDAO().listarComFiltros(null, null, null, null));
			request.setAttribute("categorias", new ProdutoDAO().listarCategorias());
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}