package mz.restaurante.controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mz.restaurante.dao.PedidoDAO;
import mz.restaurante.dao.ProdutoDAO;
import mz.restaurante.model.Pedido;

@WebServlet("/fazerPedido")
public class PedidoClienteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String telefone = request.getParameter("telefone");
        String endereco = request.getParameter("endereco");
        String itens = request.getParameter("itens");

        if (nome == null || nome.trim().isEmpty() ||
            telefone == null || telefone.trim().isEmpty() ||
            endereco == null || endereco.trim().isEmpty() ||
            itens == null || itens.trim().isEmpty()) {
            request.setAttribute("msgPedido", "Preencha todos os campos do pedido.");
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
            new PedidoDAO().inserir(pedido);
            request.setAttribute("msgPedido", "Pedido realizado com sucesso! Entraremos em contato.");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("msgPedido", "Erro ao enviar pedido. Tente novamente.");
        }
        carregarProdutos(request);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    private void carregarProdutos(HttpServletRequest request) throws ServletException {
        try {
            request.setAttribute("produtos", new ProdutoDAO().listarTodos());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}