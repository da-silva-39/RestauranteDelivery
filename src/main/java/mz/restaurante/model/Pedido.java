package mz.restaurante.model;

import java.sql.Timestamp;

public class Pedido {
	private int id;
	private String clienteNome;
	private String telefone;
	private String endereco;
	private String itens;
	private String status;
	private Timestamp dataPedido;

	// getters/setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getClienteNome() {
		return clienteNome;
	}

	public void setClienteNome(String clienteNome) {
		this.clienteNome = clienteNome;
	}

	public String getTelefone() {
		return telefone;
	}

	public void setTelefone(String telefone) {
		this.telefone = telefone;
	}

	public String getEndereco() {
		return endereco;
	}

	public void setEndereco(String endereco) {
		this.endereco = endereco;
	}

	public String getItens() {
		return itens;
	}

	public void setItens(String itens) {
		this.itens = itens;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getDataPedido() {
		return dataPedido;
	}

	public void setDataPedido(Timestamp dataPedido) {
		this.dataPedido = dataPedido;
	}
}