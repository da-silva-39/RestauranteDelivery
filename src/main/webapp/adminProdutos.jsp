<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Produtos - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-container">
    <h1>Produtos do Cardápio</h1>
    <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn">Ver Pedidos</a>
        <a href="${pageContext.request.contextPath}/admin/logout" class="btn logout">Sair</a>
    </div>

    <form action="${pageContext.request.contextPath}/admin/produtos" method="post" class="form-inline">
        <input type="hidden" name="id" value="${produto.id}">
        <input type="text" name="nome" placeholder="Nome" value="${produto.nome}" required>
        <input type="text" name="descricao" placeholder="Descrição" value="${produto.descricao}">
        <input type="number" step="0.01" name="preco" placeholder="Preço" value="${produto.preco}" required>
        <input type="text" name="categoria" placeholder="Categoria" value="${produto.categoria}">
        <input type="text" name="imagemUrl" placeholder="URL da imagem" value="${produto.imagemUrl}">
        <button type="submit">Salvar</button>
    </form>

    <table class="admin-table">
        <tr><th>ID</th><th>Nome</th><th>Preço</th><th>Categoria</th><th>Ações</th></tr>
        <c:forEach var="p" items="${produtos}">
            <tr>
                <td>${p.id}</td>
                <td>${p.nome}</td>
                <td>${p.preco} MT</td>
                <td>${p.categoria}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/produtos?action=editar&id=${p.id}">Editar</a> |
                    <a href="${pageContext.request.contextPath}/admin/produtos?action=excluir&id=${p.id}" onclick="return confirm('Remover produto?')">Excluir</a>
                 </td>
             </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>