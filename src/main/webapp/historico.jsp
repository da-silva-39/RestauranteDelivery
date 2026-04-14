<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Histórico de Pedidos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h1>Histórico de Pedidos</h1>
    <form method="get">
        <input type="tel" name="telefone" placeholder="Digite seu telefone" value="${param.telefone}">
        <button type="submit">Buscar</button>
    </form>
    <c:if test="${not empty pedidos}">
        <table class="admin-table">
            <tr><th>ID</th><th>Data</th><th>Itens</th><th>Status</th><th>Total (aproximado)</th></tr>
            <c:forEach var="ped" items="${pedidos}">
                <tr>
                    <td>${ped.id}</td>
                    <td>${ped.dataPedido}</td>
                    <td>${ped.itens}</td>
                    <td>${ped.status}</td>
                    <td>--</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <a href="${pageContext.request.contextPath}/home" class="btn">Voltar</a>
</div>
</body>
</html>