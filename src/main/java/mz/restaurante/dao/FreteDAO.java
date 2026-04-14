package mz.restaurante.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mz.restaurante.util.ConnectionFactory;

public class FreteDAO {
	public List<String> listarBairros() throws SQLException {
		List<String> bairros = new ArrayList<>();
		String sql = "SELECT bairro FROM taxas_frete ORDER BY bairro";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next())
				bairros.add(rs.getString("bairro"));
		}
		return bairros;
	}

	public double getValorFrete(String bairro) throws SQLException {
		String sql = "SELECT valor FROM taxas_frete WHERE bairro = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, bairro);
			ResultSet rs = stmt.executeQuery();
			if (rs.next())
				return rs.getDouble("valor");
		}
		return 0;
	}

	public String getTempoEntrega(String bairro) throws SQLException {
		String sql = "SELECT tempo_estimado FROM taxas_frete WHERE bairro = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, bairro);
			ResultSet rs = stmt.executeQuery();
			if (rs.next())
				return rs.getString("tempo_estimado");
		}
		return "Não disponível";
	}
}