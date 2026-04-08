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
import mz.restaurante.dao.ProdutoDAO;
import mz.restaurante.model.Produto;

@WebServlet("/admin/produtos")
public class ProdutoServlet extends HttpServlet {

    private void checkAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
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
        ProdutoDAO dao = new ProdutoDAO();

        try {
            if ("editar".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Produto p = dao.buscarPorId(id);
                request.setAttribute("produto", p);
                request.getRequestDispatcher("/adminProdutos.jsp").forward(request, response);
                return;
            } else if ("excluir".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deletar(id);
                response.sendRedirect(request.getContextPath() + "/admin/produtos");
                return;
            }
            List<Produto> produtos = dao.listarTodos();
            request.setAttribute("produtos", produtos);
            request.getRequestDispatcher("/adminProdutos.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        checkAdmin(request, response);
        String idParam = request.getParameter("id");
        String nome = request.getParameter("nome");
        String descricao = request.getParameter("descricao");
        String precoStr = request.getParameter("preco");
        String categoria = request.getParameter("categoria");
        String imagemUrl = request.getParameter("imagemUrl");

        Produto p = new Produto();
        p.setNome(nome);
        p.setDescricao(descricao);
        p.setPreco(Double.parseDouble(precoStr));
        p.setCategoria(categoria);
        p.setImagemUrl(imagemUrl != null && !imagemUrl.isEmpty() ? imagemUrl : "https://via.placeholder.com/300x200?text=Prato");

        ProdutoDAO dao = new ProdutoDAO();
        try {
            if (idParam != null && !idParam.isEmpty()) {
                p.setId(Integer.parseInt(idParam));
                dao.atualizar(p);
            } else {
                dao.inserir(p);
            }
            response.sendRedirect(request.getContextPath() + "/admin/produtos");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}