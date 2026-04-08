package mz.restaurante.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
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
        if ("admin".equals(usuario) && "admin123".equals(senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("adminLogado", true);
            response.sendRedirect(request.getContextPath() + "/admin/produtos");
        } else {
            request.setAttribute("erro", "Usuário ou senha inválidos.");
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
        }
    }
}