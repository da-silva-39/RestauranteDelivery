<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedido Confirmado - Cely Sabores</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h1>Pedido Realizado com Sucesso!</h1>
    <p>Número do pedido: <strong>${pedidoId}</strong></p>
    <p>Total: ${total} MT</p>
    <p>Em breve entraremos em contato via WhatsApp para confirmar.</p>
    <a href="${linkWhatsApp}" target="_blank" class="btn-primary">Abrir WhatsApp</a>
    <a href="${pageContext.request.contextPath}/home" class="btn">Voltar ao Cardápio</a>
</div>
</body>
</html>