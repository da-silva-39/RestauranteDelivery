package mz.restaurante.controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mz.restaurante.dao.PedidoDAO;
import mz.restaurante.model.Pedido;

@WebServlet("/admin/pedidos")
public class PedidoAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private void checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("adminLogado") == null) {
			response.sendRedirect(request.getContextPath() + "/admin/login");
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		checkAdmin(request, response);
		String action = request.getParameter("action");
		PedidoDAO dao = new PedidoDAO();

		try {
			if ("excluir".equals(action)) {
				int id = Integer.parseInt(request.getParameter("id"));
				dao.deletar(id);
				response.sendRedirect(request.getContextPath() + "/admin/pedidos");
				return;
			} else if ("atualizarStatus".equals(action)) {
				int id = Integer.parseInt(request.getParameter("id"));
				String status = request.getParameter("status");
				dao.atualizarStatus(id, status);
				response.sendRedirect(request.getContextPath() + "/admin/pedidos");
				return;
			}
			// Listagem normal
			List<Pedido> pedidos = dao.listarTodos();
			request.setAttribute("pedidos", pedidos);
			request.getRequestDispatcher("/adminPedidos.jsp").forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500, "Erro ao acessar banco de dados.");
		} catch (NumberFormatException e) {
			response.sendError(400, "ID inválido.");
		}
	}
}