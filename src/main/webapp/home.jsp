<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cely Sabores - Restaurante & Delivery</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="logo">Cely Sabores</div>
            <ul class="nav-links">
                <li><a href="#home">Início</a></li>
                <li><a href="#cardapio">Cardápio</a></li>
                <li><a href="#pedido">Pedido Online</a></li>
                <li><a href="#contato">Contato</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/login" class="admin-link"><i class="fas fa-user-shield"></i> Admin</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section id="home" class="hero">
            <div class="hero-content">
                <h1>Cely Sabores</h1>
                <p>Sabor, qualidade e carinho em cada prato. Delivery e catering.</p>
                <a href="#pedido" class="btn-primary">Peça agora</a>
            </div>
        </section>

        <section id="cardapio" class="menu-section">
            <h2>Nosso Cardápio</h2>
            <div class="menu-grid">
                <c:forEach var="prod" items="${produtos}">
                    <div class="menu-card">
                        <img src="${prod.imagemUrl}" alt="${prod.nome}">
                        <h3>${prod.nome}</h3>
                        <p class="descricao">${prod.descricao}</p>
                        <p class="categoria"><i class="fas fa-tag"></i> ${prod.categoria}</p>
                        <p class="preco">${prod.preco} MT</p>
                        <button class="btn-pedido" data-nome="${prod.nome}">Adicionar ao Pedido</button>
                    </div>
                </c:forEach>
            </div>
        </section>

        <section id="pedido" class="pedido-section">
            <h2>Faça seu Pedido</h2>
            <c:if test="${not empty msgPedido}">
                <div class="mensagem">${msgPedido}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/fazerPedido" method="post" class="pedido-form">
                <input type="text" name="nome" placeholder="Seu nome" required>
                <input type="tel" name="telefone" placeholder="Telefone (WhatsApp)" required>
                <input type="text" name="endereco" placeholder="Endereço de entrega" required>
                <textarea name="itens" rows="4" placeholder="Descreva seu pedido (ex: 1 Pizza Margherita, 1 Suco Natural)" required></textarea>
                <button type="submit" class="btn-primary">Enviar Pedido</button>
            </form>
        </section>

        <section id="contato" class="contato-section">
            <h2>Contato & Localização</h2>
            <div class="contato-info">
                <div>
                    <i class="fas fa-map-marker-alt"></i>
                    <p>Av de Liberdade, Recinto UCM, Chimoio</p>
                    <i class="fab fa-whatsapp"></i>
                    <p><a href="https://wa.me/258857096799" target="_blank">+258 85 709 6799</a></p>
                    <i class="far fa-envelope"></i>
                    <p>contato@celysabores.co.mz</p>
                </div>
                <div class="mapa-fake">
                    <iframe src="https://maps.google.com/maps?q=Chimoio&t=&z=13&ie=UTF8&iwloc=&output=embed" width="100%" height="200" style="border:0;" allowfullscreen></iframe>
                </div>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 Cely Sabores - Sabor que encanta</p>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>