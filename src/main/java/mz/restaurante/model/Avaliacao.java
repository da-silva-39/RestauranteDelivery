package mz.restaurante.model;

import java.sql.Timestamp;

public class Avaliacao {
	private int id;
	private int produtoId;
	private String clienteNome;
	private int nota;
	private String comentario;
	private Timestamp dataAvaliacao;

	// getters/setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getProdutoId() {
		return produtoId;
	}

	public void setProdutoId(int produtoId) {
		this.produtoId = produtoId;
	}

	public String getClienteNome() {
		return clienteNome;
	}

	public void setClienteNome(String clienteNome) {
		this.clienteNome = clienteNome;
	}

	public int getNota() {
		return nota;
	}

	public void setNota(int nota) {
		this.nota = nota;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public Timestamp getDataAvaliacao() {
		return dataAvaliacao;
	}

	public void setDataAvaliacao(Timestamp dataAvaliacao) {
		this.dataAvaliacao = dataAvaliacao;
	}
}