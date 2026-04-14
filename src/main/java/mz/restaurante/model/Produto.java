package mz.restaurante.model;

public class Produto {
	private int id;
	private String nome;
	private String descricao;
	private double preco;
	private String categoria;
	private String imagemUrl;
	private double mediaAvaliacao;

	public Produto() {
	}

	public Produto(int id, String nome, String descricao, double preco, String categoria, String imagemUrl) {
		this.id = id;
		this.nome = nome;
		this.descricao = descricao;
		this.preco = preco;
		this.categoria = categoria;
		this.imagemUrl = imagemUrl;
	}

	// Getters e setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public double getPreco() {
		return preco;
	}

	public void setPreco(double preco) {
		this.preco = preco;
	}

	public String getCategoria() {
		return categoria;
	}

	public void setCategoria(String categoria) {
		this.categoria = categoria;
	}

	public String getImagemUrl() {
		return imagemUrl;
	}

	public void setImagemUrl(String imagemUrl) {
		this.imagemUrl = imagemUrl;
	}

	public double getMediaAvaliacao() {
		return mediaAvaliacao;
	}

	public void setMediaAvaliacao(double mediaAvaliacao) {
		this.mediaAvaliacao = mediaAvaliacao;
	}
}