package mz.restaurante.model;

public class ItemCarrinho {
	private int produtoId;
	private String nome;
	private double preco;
	private int quantidade;

	public ItemCarrinho() {
	}

	public ItemCarrinho(int produtoId, String nome, double preco, int quantidade) {
		this.produtoId = produtoId;
		this.nome = nome;
		this.preco = preco;
		this.quantidade = quantidade;
	}

	// getters/setters
	public int getProdutoId() {
		return produtoId;
	}

	public void setProdutoId(int produtoId) {
		this.produtoId = produtoId;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public double getPreco() {
		return preco;
	}

	public void setPreco(double preco) {
		this.preco = preco;
	}

	public int getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(int quantidade) {
		this.quantidade = quantidade;
	}

	public double getSubtotal() {
		return preco * quantidade;
	}
}