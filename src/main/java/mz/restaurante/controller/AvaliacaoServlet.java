package mz.restaurante.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mz.restaurante.dao.AvaliacaoDAO;
import mz.restaurante.model.Avaliacao;

@WebServlet("/avaliar")
public class AvaliacaoServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int produtoId = Integer.parseInt(request.getParameter("produtoId"));
		String nome = request.getParameter("nome");
		int nota = Integer.parseInt(request.getParameter("nota"));
		String comentario = request.getParameter("comentario");
		Avaliacao a = new Avaliacao();
		a.setProdutoId(produtoId);
		a.setClienteNome(nome);
		a.setNota(nota);
		a.setComentario(comentario);
		try {
			new AvaliacaoDAO().inserir(a);
			response.sendRedirect(request.getContextPath() + "/home?avaliacao=sucesso");
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/home?avaliacao=erro");
		}
	}
}