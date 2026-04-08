package mz.restaurante.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mz.restaurante.model.Pedido;
import mz.restaurante.util.ConnectionFactory;

public class PedidoDAO {

	public void inserir(Pedido p) throws SQLException {
		String sql = "INSERT INTO pedidos (cliente_nome, telefone, endereco, itens, status) VALUES (?,?,?,?,?)";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, p.getClienteNome());
			stmt.setString(2, p.getTelefone());
			stmt.setString(3, p.getEndereco());
			stmt.setString(4, p.getItens());
			stmt.setString(5, p.getStatus());
			stmt.executeUpdate();
		}
	}

	public List<Pedido> listarTodos() throws SQLException {
		List<Pedido> lista = new ArrayList<>();
		String sql = "SELECT * FROM pedidos ORDER BY data_pedido DESC";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Pedido p = new Pedido();
				p.setId(rs.getInt("id"));
				p.setClienteNome(rs.getString("cliente_nome"));
				p.setTelefone(rs.getString("telefone"));
				p.setEndereco(rs.getString("endereco"));
				p.setItens(rs.getString("itens"));
				p.setStatus(rs.getString("status"));
				p.setDataPedido(rs.getTimestamp("data_pedido"));
				lista.add(p);
			}
		}
		return lista;
	}

	public void atualizarStatus(int id, String status) throws SQLException {
		String sql = "UPDATE pedidos SET status=? WHERE id=?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, status);
			stmt.setInt(2, id);
			stmt.executeUpdate();
		}
	}

	public void deletar(int id) throws SQLException {
		String sql = "DELETE FROM pedidos WHERE id=?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			stmt.executeUpdate();
		}
	}
}