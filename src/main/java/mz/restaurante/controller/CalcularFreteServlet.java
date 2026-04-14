package mz.restaurante.controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mz.restaurante.dao.FreteDAO;

@WebServlet("/calcularFrete")
public class CalcularFreteServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String bairro = request.getParameter("bairro");
		if (bairro == null || bairro.isEmpty()) {
			response.getWriter().print("{\"valor\":0,\"tempo\":\"\"}");
			return;
		}
		try {
			FreteDAO dao = new FreteDAO();
			double valor = dao.getValorFrete(bairro);
			String tempo = dao.getTempoEntrega(bairro);
			response.setContentType("application/json");
			response.getWriter().print("{\"valor\":" + valor + ",\"tempo\":\"" + tempo + "\"}");
		} catch (SQLException e) {
			response.getWriter().print("{\"valor\":0,\"tempo\":\"Erro\"}");
		}
	}
}