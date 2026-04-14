<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.Map, mz.restaurante.model.ItemCarrinho" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meu Carrinho - Cely Sabores</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .carrinho-table { width:100%; border-collapse:collapse; margin:20px 0; }
        .carrinho-table th, .carrinho-table td { border:1px solid #ddd; padding:8px; text-align:center; }
        .total { font-weight:bold; background:#f2f2f2; }
        .container { max-width:1200px; margin:2rem auto; padding:1rem; }
        .btn { background:#8b3c1c; color:white; padding:0.5rem 1rem; text-decoration:none; border-radius:8px; display:inline-block; margin-top:1rem; margin-right:0.5rem; }
        .btn-primary { background:#d97a2b; }
        .quantidade-input { width:60px; text-align:center; }
    </style>
</head>
<body>
<div class="container">
    <h1>Meu Carrinho</h1>
    <c:set var="carrinho" value="${sessionScope.carrinho}" />
    <c:choose>
        <c:when test="${empty carrinho or carrinho.isEmpty()}">
            <p>Carrinho vazio. <a href="${pageContext.request.contextPath}/home">Voltar ao cardápio</a></p>
        </c:when>
        <c:otherwise>
            <c:set var="totalGeral" value="0" />
            <table class="carrinho-table">
                <tr><th>Produto</th><th>Preço unit.</th><th>Quantidade</th><th>Subtotal</th><th>Ações</th></tr>
                <c:forEach var="entry" items="${carrinho}">
                    <c:set var="item" value="${entry.value}" />
                    <c:set var="subtotal" value="${item.preco * item.quantidade}" />
                    <c:set var="totalGeral" value="${totalGeral + subtotal}" />
                    <form action="${pageContext.request.contextPath}/carrinho" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="atualizar">
                        <input type="hidden" name="id" value="${item.produtoId}">
                        <tr>
                            <td>${item.nome}</td>
                            <td>${item.preco} MT</td>
                            <td>
                                <input type="number" name="quantidade" value="${item.quantidade}" min="1" class="quantidade-input" onchange="this.form.submit()">
                            </td>
                            <td>${subtotal} MT</td>
                            <td>
                                <button type="button" onclick="removerItem(${item.produtoId})">Remover</button>
                            </td>
                        </tr>
                    </form>
                </c:forEach>
                <tr class="total">
                    <td colspan="3"><strong>Total</strong></td>
                    <td colspan="2"><strong>${totalGeral} MT</strong></td>
                </tr>
            </table>
            <div>
                <a href="${pageContext.request.contextPath}/home" class="btn">Continuar comprando</a>
                <a href="${pageContext.request.contextPath}/finalizarPedido" class="btn btn-primary">Finalizar Pedido</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script>
    function removerItem(id) {
        if(confirm('Remover este item do carrinho?')) {
            fetch('${pageContext.request.contextPath}/carrinho', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=remover&id=' + id
            }).then(() => location.reload());
        }
    }
</script>
</body>
</html>