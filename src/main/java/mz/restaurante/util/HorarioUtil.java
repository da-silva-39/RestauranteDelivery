package mz.restaurante.util;

import java.time.LocalTime;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import mz.restaurante.dao.ConfiguracaoDAO;

public class HorarioUtil {
	public static boolean isFuncionando() {
		try {
			ConfiguracaoDAO dao = new ConfiguracaoDAO();
			String abertura = dao.getValor("abertura_hora");
			String fechamento = dao.getValor("fechamento_hora");
			String dias = dao.getValor("dias_funcionamento");
			if (abertura == null || fechamento == null || dias == null)
				return true;

			LocalTime agora = LocalTime.now();
			LocalTime inicio = LocalTime.parse(abertura);
			LocalTime fim = LocalTime.parse(fechamento);

			DayOfWeek hoje = LocalDateTime.now().getDayOfWeek();
			int diaNum = hoje.getValue();
			String[] diasFunc = dias.split(",");
			boolean diaValido = false;
			for (String d : diasFunc) {
				if (Integer.parseInt(d) == diaNum)
					diaValido = true;
			}
			return diaValido && !agora.isBefore(inicio) && !agora.isAfter(fim);
		} catch (Exception e) {
			return true;
		}
	}
}