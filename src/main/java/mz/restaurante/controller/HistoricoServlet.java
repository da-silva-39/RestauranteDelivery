package mz.restaurante.controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mz.restaurante.dao.PedidoDAO;

@WebServlet("/historico")
public class HistoricoServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String telefone = request.getParameter("telefone");
		if (telefone != null && !telefone.trim().isEmpty()) {
			try {
				request.setAttribute("pedidos", new PedidoDAO().listarPorTelefone(telefone));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		request.getRequestDispatcher("/historico.jsp").forward(request, response);
	}
}