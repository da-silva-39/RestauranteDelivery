package mz.restaurante.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mz.restaurante.model.Produto;
import mz.restaurante.util.ConnectionFactory;

public class ProdutoDAO {
	public void inserir(Produto p) throws SQLException {
		String sql = "INSERT INTO produtos (nome, descricao, preco, categoria, imagem_url) VALUES (?,?,?,?,?)";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, p.getNome());
			stmt.setString(2, p.getDescricao());
			stmt.setDouble(3, p.getPreco());
			stmt.setString(4, p.getCategoria());
			stmt.setString(5, p.getImagemUrl());
			stmt.executeUpdate();
		}
	}

	public List<Produto> listarComFiltros(String nomeBusca, String categoria, Double minPreco, Double maxPreco)
			throws SQLException {
		List<Produto> lista = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT * FROM produtos WHERE 1=1");
		List<Object> params = new ArrayList<>();
		if (nomeBusca != null && !nomeBusca.trim().isEmpty()) {
			sql.append(" AND nome LIKE ?");
			params.add("%" + nomeBusca.trim() + "%");
		}
		if (categoria != null && !categoria.trim().isEmpty()) {
			sql.append(" AND categoria = ?");
			params.add(categoria.trim());
		}
		if (minPreco != null) {
			sql.append(" AND preco >= ?");
			params.add(minPreco);
		}
		if (maxPreco != null) {
			sql.append(" AND preco <= ?");
			params.add(maxPreco);
		}
		sql.append(" ORDER BY id");
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++)
				stmt.setObject(i + 1, params.get(i));
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				Produto p = new Produto();
				p.setId(rs.getInt("id"));
				p.setNome(rs.getString("nome"));
				p.setDescricao(rs.getString("descricao"));
				p.setPreco(rs.getDouble("preco"));
				p.setCategoria(rs.getString("categoria"));
				p.setImagemUrl(rs.getString("imagem_url"));
				lista.add(p);
			}
		}
		return lista;
	}

	public List<String> listarCategorias() throws SQLException {
		List<String> categorias = new ArrayList<>();
		String sql = "SELECT DISTINCT categoria FROM produtos WHERE categoria IS NOT NULL AND categoria != '' ORDER BY categoria";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next())
				categorias.add(rs.getString("categoria"));
		}
		return categorias;
	}

	public Produto buscarPorId(int id) throws SQLException {
		String sql = "SELECT * FROM produtos WHERE id = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				Produto p = new Produto();
				p.setId(rs.getInt("id"));
				p.setNome(rs.getString("nome"));
				p.setDescricao(rs.getString("descricao"));
				p.setPreco(rs.getDouble("preco"));
				p.setCategoria(rs.getString("categoria"));
				p.setImagemUrl(rs.getString("imagem_url"));
				return p;
			}
		}
		return null;
	}

	public void atualizar(Produto p) throws SQLException {
		String sql = "UPDATE produtos SET nome=?, descricao=?, preco=?, categoria=?, imagem_url=? WHERE id=?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, p.getNome());
			stmt.setString(2, p.getDescricao());
			stmt.setDouble(3, p.getPreco());
			stmt.setString(4, p.getCategoria());
			stmt.setString(5, p.getImagemUrl());
			stmt.setInt(6, p.getId());
			stmt.executeUpdate();
		}
	}

	public void deletar(int id) throws SQLException {
		String sql = "DELETE FROM produtos WHERE id = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			stmt.executeUpdate();
		}
	}
}