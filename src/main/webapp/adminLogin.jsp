<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - Cely Sabores</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
    <div class="login-container">
        <h2>Área Administrativa</h2>
        <c:if test="${not empty erro}"><p class="erro">${erro}</p></c:if>
        <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <input type="text" name="usuario" placeholder="Usuário" required>
            <input type="password" name="senha" placeholder="Senha" required>
            <button type="submit">Entrar</button>
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn logout">Voltar</a>
            
        </form>
    </div>
</body>
</html>