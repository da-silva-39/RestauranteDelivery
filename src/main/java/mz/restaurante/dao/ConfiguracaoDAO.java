package mz.restaurante.dao;

import java.sql.*;
import mz.restaurante.util.ConnectionFactory;

public class ConfiguracaoDAO {
	public String getValor(String chave) throws SQLException {
		String sql = "SELECT valor FROM configuracoes WHERE chave = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, chave);
			ResultSet rs = stmt.executeQuery();
			if (rs.next())
				return rs.getString("valor");
		}
		return null;
	}
}