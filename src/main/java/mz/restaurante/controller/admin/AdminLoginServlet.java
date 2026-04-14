package mz.restaurante.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mz.restaurante.util.ConnectionFactory;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usuario = request.getParameter("usuario");
        String senha = request.getParameter("senha");

        if (usuario == null || senha == null || usuario.trim().isEmpty() || senha.trim().isEmpty()) {
            request.setAttribute("erro", "Usuário e senha são obrigatórios.");
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
            return;
        }

        // Validar no banco de dados
        boolean autenticado = false;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM administradores WHERE usuario = ? AND senha = ?")) {
            stmt.setString(1, usuario);
            stmt.setString(2, senha);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    autenticado = true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro interno ao validar login.");
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
            return;
        }

        if (autenticado) {
            HttpSession session = request.getSession();
            session.setAttribute("adminLogado", true);
            session.setAttribute("adminUsuario", usuario);
            response.sendRedirect(request.getContextPath() + "/admin/produtos");
        } else {
            request.setAttribute("erro", "Usuário ou senha inválidos.");
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
        }
    }
}