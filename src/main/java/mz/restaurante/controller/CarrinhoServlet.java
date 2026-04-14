package mz.restaurante.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mz.restaurante.dao.ProdutoDAO;
import mz.restaurante.model.ItemCarrinho;
import mz.restaurante.model.Produto;

@WebServlet("/carrinho")
public class CarrinhoServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		HttpSession session = request.getSession();
		Map<Integer, ItemCarrinho> carrinho = (Map<Integer, ItemCarrinho>) session.getAttribute("carrinho");
		if (carrinho == null) {
			carrinho = new HashMap<>();
			session.setAttribute("carrinho", carrinho);
		}
		if ("adicionar".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			try {
				Produto p = new ProdutoDAO().buscarPorId(id);
				if (carrinho.containsKey(id))
					carrinho.get(id).setQuantidade(carrinho.get(id).getQuantidade() + 1);
				else
					carrinho.put(id, new ItemCarrinho(id, p.getNome(), p.getPreco(), 1));
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.setContentType("text/plain");
			response.getWriter().write("ok");
		} else if ("remover".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			carrinho.remove(id);
			response.sendRedirect(request.getContextPath() + "/carrinho");
		} else if ("atualizar".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			int qtd = Integer.parseInt(request.getParameter("quantidade"));
			if (qtd <= 0)
				carrinho.remove(id);
			else
				carrinho.get(id).setQuantidade(qtd);
			response.sendRedirect(request.getContextPath() + "/carrinho");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		HttpSession session = request.getSession();
		Map<Integer, ItemCarrinho> carrinho = (Map<Integer, ItemCarrinho>) session.getAttribute("carrinho");
		if (carrinho == null)
			carrinho = new HashMap<>();
		if ("contador".equals(action)) {
			int count = carrinho.values().stream().mapToInt(ItemCarrinho::getQuantidade).sum();
			response.setContentType("text/plain");
			response.getWriter().print(count);
			return;
		}
		request.getRequestDispatcher("/carrinho.jsp").forward(request, response);
	}
}