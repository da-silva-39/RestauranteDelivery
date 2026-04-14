package mz.restaurante.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mz.restaurante.dao.AvaliacaoDAO;
import mz.restaurante.dao.ProdutoDAO;
import mz.restaurante.model.Produto;

@WebServlet("/home")
public class IndexServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String busca = request.getParameter("busca");
		String categoria = request.getParameter("categoria");
		String minPrecoStr = request.getParameter("minPreco");
		String maxPrecoStr = request.getParameter("maxPreco");
		Double minPreco = null, maxPreco = null;
		if (minPrecoStr != null && !minPrecoStr.isEmpty())
			minPreco = Double.parseDouble(minPrecoStr);
		if (maxPrecoStr != null && !maxPrecoStr.isEmpty())
			maxPreco = Double.parseDouble(maxPrecoStr);

		try {
			ProdutoDAO produtoDAO = new ProdutoDAO();
			List<Produto> produtos = produtoDAO.listarComFiltros(busca, categoria, minPreco, maxPreco);
			AvaliacaoDAO avDAO = new AvaliacaoDAO();
			for (Produto p : produtos) {
				p.setMediaAvaliacao(avDAO.getMediaNota(p.getId()));
			}
			request.setAttribute("produtos", produtos);
			request.setAttribute("categorias", produtoDAO.listarCategorias());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		request.getRequestDispatcher("/home.jsp").forward(request, response);
	}
}