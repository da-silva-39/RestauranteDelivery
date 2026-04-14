<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Produtos - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Roboto, sans-serif;
        }
        body {
            background: #f5f0e8;
            padding: 2rem;
        }
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 30px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        h1 {
            color: #8b3c1c;
            margin-bottom: 1.5rem;
            font-size: 2rem;
            border-left: 5px solid #d97a2b;
            padding-left: 1rem;
        }
        .admin-actions {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: flex-end;
        }
        .btn {
            padding: 0.5rem 1.2rem;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-primary {
            background: #d97a2b;
            color: white;
            border: none;
            cursor: pointer;
        }
        .btn-primary:hover { background: #b85e1a; }
        .btn-secondary {
            background: #8b3c1c;
            color: white;
        }
        .btn-secondary:hover { background: #5a2a10; }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover { background: #a71d2a; }
        .logout {
            background: #2c1a12;
        }
        .form-inline {
            background: #f9f5f0;
            padding: 1.5rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
        }
        .form-group {
            flex: 1;
            min-width: 150px;
        }
        .form-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 0.3rem;
            color: #555;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 12px;
            font-size: 0.9rem;
        }
        .image-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid #ddd;
            margin-top: 0.3rem;
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            overflow-x: auto;
            display: block;
        }
        .admin-table th, .admin-table td {
            padding: 0.8rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .admin-table th {
            background: #8b3c1c;
            color: white;
            font-weight: 600;
        }
        .admin-table tr:hover {
            background: #fef8f0;
        }
        .admin-table img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
        }
        .action-icons a {
            margin-right: 0.8rem;
            text-decoration: none;
            font-size: 1.1rem;
        }
        .edit { color: #d97a2b; }
        .delete { color: #dc3545; }
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .form-inline { flex-direction: column; }
            .admin-table th, .admin-table td { padding: 0.5rem; font-size: 0.8rem; }
        }
    </style>
    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('preview').src = e.target.result;
                    document.getElementById('preview').style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</head>
<body>
<div class="admin-container">
    <h1>🍽️ Produtos do Cardápio</h1>
    <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn btn-secondary">📋 Ver Pedidos</a>
        <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-danger logout">🚪 Sair</a>
    </div>

    <!-- Formulário de adicionar/editar -->
    <form action="${pageContext.request.contextPath}/admin/produtos" method="post" enctype="multipart/form-data" class="form-inline">
        <input type="hidden" name="id" value="${produto.id}">
        <div class="form-group">
            <label>Nome</label>
            <input type="text" name="nome" value="${produto.nome}" required>
        </div>
        <div class="form-group">
            <label>Descrição</label>
            <input type="text" name="descricao" value="${produto.descricao}">
        </div>
        <div class="form-group">
            <label>Preço (MT)</label>
            <input type="number" step="0.01" name="preco" value="${produto.preco}" required>
        </div>
        <div class="form-group">
            <label>Categoria</label>
            <input type="text" name="categoria" value="${produto.categoria}">
        </div>
        <div class="form-group">
            <label>Imagem (upload)</label>
            <input type="file" name="imagemFile" accept="image/*" onchange="previewImage(this)">
            <c:if test="${not empty produto.imagemUrl}">
                <img src="${pageContext.request.contextPath}/${produto.imagemUrl}" id="preview" class="image-preview" style="display:block">
                <input type="hidden" name="imagemUrlAntiga" value="${produto.imagemUrl}">
            </c:if>
            <c:if test="${empty produto.imagemUrl}">
                <img id="preview" class="image-preview" style="display:none">
            </c:if>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary">💾 Salvar</button>
        </div>
    </form>

    <!-- Tabela de produtos -->
    <div style="overflow-x: auto;">
        <table class="admin-table">
            <thead>
                <tr><th>ID</th><th>Imagem</th><th>Nome</th><th>Preço</th><th>Categoria</th><th>Ações</th></tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${produtos}">
                    <tr>
                        <td>${p.id}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.imagemUrl}">
                                    <img src="${pageContext.request.contextPath}/${p.imagemUrl}" alt="${p.nome}">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/50?text=Sem+imagem">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${p.nome}</td>
                        <td>${p.preco} MT</td>
                        <td>${p.categoria}</td>
                        <td class="action-icons">
                            <a href="${pageContext.request.contextPath}/admin/produtos?action=editar&id=${p.id}" class="edit" title="Editar">✏️ Editar</a>
                            <a href="${pageContext.request.contextPath}/admin/produtos?action=excluir&id=${p.id}" class="delete" title="Excluir" onclick="return confirm('Remover produto?')">🗑️ Excluir</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>