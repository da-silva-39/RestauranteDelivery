<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.Map, mz.restaurante.model.ItemCarrinho" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Finalizar Pedido - Cely Sabores</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 800px; margin: 2rem auto; padding: 1rem; background: white; border-radius: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 0.5rem; border-radius: 8px; border: 1px solid #ccc; }
        .btn-primary { background: #d97a2b; color: white; border: none; padding: 0.7rem 1.5rem; border-radius: 40px; cursor: pointer; }
        .btn { background: #8b3c1c; color: white; padding: 0.7rem 1.5rem; text-decoration: none; border-radius: 40px; display: inline-block; margin-right: 1rem; }
        .erro { color: red; margin-bottom: 1rem; }
        .total { font-size: 1.2rem; font-weight: bold; margin-top: 1rem; }
    </style>
    <script>
        function calcularFrete() {
            var bairro = document.getElementById("bairro").value;
            if (bairro) {
                fetch('${pageContext.request.contextPath}/calcularFrete?bairro=' + encodeURIComponent(bairro))
                .then(response => response.json())
                .then(data => {
                    document.getElementById("valorFrete").innerText = data.valor + " MT";
                    document.getElementById("tempoEntrega").innerText = data.tempo;
                    atualizarTotal();
                })
                .catch(err => console.error(err));
            }
        }

        function atualizarTotal() {
            var subtotal = parseFloat(document.getElementById("subtotalValue").innerText);
            var freteText = document.getElementById("valorFrete").innerText;
            var frete = parseFloat(freteText) || 0;
            document.getElementById("totalFinal").innerText = (subtotal + frete).toFixed(2) + " MT";
        }

        window.onload = function() {
            var bairroSelect = document.getElementById("bairro");
            if (bairroSelect) bairroSelect.addEventListener("change", calcularFrete);
            // Inicializar frete se já houver bairro selecionado
            if (bairroSelect && bairroSelect.value) calcularFrete();
        };
    </script>
</head>
<body>
<div class="container">
    <h1>Finalizar Pedido</h1>
    <c:if test="${not empty erro}">
        <div class="erro">${erro}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/finalizarPedido" method="post">
        <div class="form-group">
            <label>Nome completo:</label>
            <input type="text" name="nome" required>
        </div>
        <div class="form-group">
            <label>Telefone (WhatsApp):</label>
            <input type="tel" name="telefone" required>
        </div>
        <div class="form-group">
            <label>Endereço (rua, número):</label>
            <input type="text" name="endereco" required>
        </div>
        <div class="form-group">
            <label>Bairro:</label>
            <select name="bairro" id="bairro" required>
                <option value="">Selecione</option>
                <c:forEach var="b" items="${bairros}">
                    <option value="${b}">${b}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <p>Frete: <span id="valorFrete">--</span></p>
            <p>Tempo estimado: <span id="tempoEntrega">--</span></p>
        </div>

        <c:set var="carrinho" value="${sessionScope.carrinho}" />
        <c:set var="subtotalCalculado" value="0" />
        <c:forEach var="entry" items="${carrinho}">
            <c:set var="item" value="${entry.value}" />
            <c:set var="subtotalCalculado" value="${subtotalCalculado + (item.preco * item.quantidade)}" />
        </c:forEach>
        <span id="subtotalValue" style="display:none;">${subtotalCalculado}</span>

        <p>Subtotal: ${subtotalCalculado} MT</p>
        <p class="total">Total: <span id="totalFinal">${subtotalCalculado} MT</span></p>

        <div style="margin-top: 20px;">
            <button type="submit" class="btn-primary">Confirmar Pedido</button>
            <a href="${pageContext.request.contextPath}/carrinho" class="btn">Voltar ao Carrinho</a>
        </div>
    </form>

    <hr>
    <h3>Consultar pedidos anteriores</h3>
    <form action="${pageContext.request.contextPath}/historico" method="get">
        <div class="form-group">
            <input type="tel" name="telefone" placeholder="Digite seu telefone" required>
        </div>
        <button type="submit" class="btn-primary">Buscar</button>
    </form>
</div>
</body>
</html>