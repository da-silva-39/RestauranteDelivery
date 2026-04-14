package mz.restaurante.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mz.restaurante.model.Avaliacao;
import mz.restaurante.util.ConnectionFactory;

public class AvaliacaoDAO {
	public void inserir(Avaliacao a) throws SQLException {
		String sql = "INSERT INTO avaliacoes (produto_id, cliente_nome, nota, comentario) VALUES (?,?,?,?)";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, a.getProdutoId());
			stmt.setString(2, a.getClienteNome());
			stmt.setInt(3, a.getNota());
			stmt.setString(4, a.getComentario());
			stmt.executeUpdate();
		}
	}

	public List<Avaliacao> listarPorProduto(int produtoId) throws SQLException {
		List<Avaliacao> lista = new ArrayList<>();
		String sql = "SELECT * FROM avaliacoes WHERE produto_id = ? ORDER BY data_avaliacao DESC";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, produtoId);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				Avaliacao a = new Avaliacao();
				a.setId(rs.getInt("id"));
				a.setProdutoId(rs.getInt("produto_id"));
				a.setClienteNome(rs.getString("cliente_nome"));
				a.setNota(rs.getInt("nota"));
				a.setComentario(rs.getString("comentario"));
				a.setDataAvaliacao(rs.getTimestamp("data_avaliacao"));
				lista.add(a);
			}
		}
		return lista;
	}

	public double getMediaNota(int produtoId) throws SQLException {
		String sql = "SELECT AVG(nota) FROM avaliacoes WHERE produto_id = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, produtoId);
			ResultSet rs = stmt.executeQuery();
			if (rs.next())
				return rs.getDouble(1);
		}
		return 0;
	}
}