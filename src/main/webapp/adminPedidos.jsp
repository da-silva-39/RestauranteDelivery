<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Pedidos - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-container">
    <h1>Pedidos dos Clientes</h1>
    <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/produtos" class="btn">Voltar para Produtos</a>
        <a href="${pageContext.request.contextPath}/admin/logout" class="btn logout">Sair</a>
    </div>
    <table class="admin-table">
        <tr><th>ID</th><th>Cliente</th><th>Telefone</th><th>Endereço</th><th>Itens</th><th>Status</th><th>Data</th><th>Ações</th></tr>
        <c:forEach var="ped" items="${pedidos}">
            <tr>
                <td>${ped.id}</td>
                <td>${ped.clienteNome}</td>
                <td>${ped.telefone}</td>
                <td>${ped.endereco}</td>
                <td>${ped.itens}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/pedidos" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="atualizarStatus">
                        <input type="hidden" name="id" value="${ped.id}">
                        <select name="status" onchange="this.form.submit()">
                            <option ${ped.status == 'Pendente' ? 'selected' : ''}>Pendente</option>
                            <option ${ped.status == 'Em preparo' ? 'selected' : ''}>Em preparo</option>
                            <option ${ped.status == 'Entregue' ? 'selected' : ''}>Entregue</option>
                            <option ${ped.status == 'Cancelado' ? 'selected' : ''}>Cancelado</option>
                        </select>
                    </form>
                 </td>
                <td>${ped.dataPedido}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/pedidos?action=excluir&id=${ped.id}" onclick="return confirm('Excluir pedido?')">Excluir</a>
                 </td>
             </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>