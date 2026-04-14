package mz.restaurante.controller.admin;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import mz.restaurante.dao.ProdutoDAO;
import mz.restaurante.model.Produto;

@WebServlet("/admin/produtos")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
		maxFileSize = 1024 * 1024 * 10, // 10 MB
		maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ProdutoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private void checkAdmin(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("adminLogado") == null) {
			response.sendRedirect(request.getContextPath() + "/admin/login");
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		checkAdmin(request, response);
		String action = request.getParameter("action");
		ProdutoDAO dao = new ProdutoDAO();

		try {
			if ("editar".equals(action)) {
				int id = Integer.parseInt(request.getParameter("id"));
				Produto p = dao.buscarPorId(id);
				request.setAttribute("produto", p);
				request.getRequestDispatcher("/adminProdutos.jsp").forward(request, response);
				return;
			} else if ("excluir".equals(action)) {
				int id = Integer.parseInt(request.getParameter("id"));
				// Buscar produto para remover a imagem do disco também
				Produto p = dao.buscarPorId(id);
				if (p != null && p.getImagemUrl() != null && !p.getImagemUrl().isEmpty()) {
					String uploadPath = getServletContext().getRealPath("") + File.separator + p.getImagemUrl();
					File imgFile = new File(uploadPath);
					if (imgFile.exists())
						imgFile.delete();
				}
				dao.deletar(id);
				response.sendRedirect(request.getContextPath() + "/admin/produtos");
				return;
			}
			// Listagem padrão
			List<Produto> produtos = dao.listarComFiltros(null, null, null, null);
			request.setAttribute("produtos", produtos);
			request.getRequestDispatcher("/adminProdutos.jsp").forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500, "Erro ao acessar banco de dados.");
		} catch (NumberFormatException e) {
			response.sendError(400, "ID inválido.");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		checkAdmin(request, response);

		String idParam = request.getParameter("id");
		String nome = request.getParameter("nome");
		String descricao = request.getParameter("descricao");
		String precoStr = request.getParameter("preco");
		String categoria = request.getParameter("categoria");
		String imagemUrlAntiga = request.getParameter("imagemUrlAntiga");

		// Processar upload da imagem
		Part filePart = request.getPart("imagemFile");
		String caminhoImagem = null;

		if (filePart != null && filePart.getSize() > 0) {
			// Gerar nome único para o arquivo
			String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
			String uploadDir = "uploads";
			String uploadPath = getServletContext().getRealPath("") + File.separator + uploadDir;
			File uploadDirFile = new File(uploadPath);
			if (!uploadDirFile.exists())
				uploadDirFile.mkdirs();

			filePart.write(uploadPath + File.separator + fileName);
			caminhoImagem = uploadDir + "/" + fileName;

			// Se existia imagem antiga, deletá-la
			if (imagemUrlAntiga != null && !imagemUrlAntiga.isEmpty()) {
				String oldPath = getServletContext().getRealPath("") + File.separator + imagemUrlAntiga;
				File oldFile = new File(oldPath);
				if (oldFile.exists())
					oldFile.delete();
			}
		} else {
			// Nenhuma nova imagem – manter a antiga
			caminhoImagem = imagemUrlAntiga;
		}

		Produto p = new Produto();
		p.setNome(nome);
		p.setDescricao(descricao);
		p.setPreco(Double.parseDouble(precoStr));
		p.setCategoria(categoria);
		p.setImagemUrl(caminhoImagem); // pode ser null se não tiver imagem

		ProdutoDAO dao = new ProdutoDAO();
		try {
			if (idParam != null && !idParam.isEmpty()) {
				p.setId(Integer.parseInt(idParam));
				dao.atualizar(p);
			} else {
				dao.inserir(p);
			}
			response.sendRedirect(request.getContextPath() + "/admin/produtos");
		} catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500, "Erro ao salvar produto.");
		} catch (NumberFormatException e) {
			response.sendError(400, "Preço inválido.");
		}
	}
}