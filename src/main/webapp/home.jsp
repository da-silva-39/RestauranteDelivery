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
    <style>
        .filtros { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; align-items: center; }
        .filtros input, .filtros select, .filtros button { padding: 8px; border-radius: 8px; border: 1px solid #ccc; }
        .carrinho-icon { float: right; background: #8b3c1c; color: white; padding: 5px 12px; border-radius: 30px; text-decoration: none; margin-left: 10px; }
        .avaliacao { margin-top: 8px; font-size: 0.9rem; color: #f5a623; }
        .avaliacao button { background: none; border: none; color: #8b3c1c; cursor: pointer; text-decoration: underline; }
        .modal { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; border-radius: 15px; box-shadow: 0 0 15px rgba(0,0,0,0.3); z-index: 1000; width: 300px; }
        .modal-overlay { display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index: 999; }
        .mensagem-flutuante { position: fixed; bottom: 20px; right: 20px; background: #4caf50; color: white; padding: 10px 20px; border-radius: 8px; z-index: 2000; display: none; }
        .pedido-rapido { margin-top: 40px; padding: 20px; background: #fff3e0; border-radius: 20px; }
    </style>
</head>
<body>
<header>
    <nav class="navbar">
        <div class="logo">Cely Sabores</div>
        <ul class="nav-links">
            <li><a href="#home">Início</a></li>
            <li><a href="#cardapio">Cardápio</a></li>
            <li><a href="#pedidoRapido">Pedido Rápido</a></li>
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
            <a href="#cardapio" class="btn-primary">Peça agora</a>
        </div>
    </section>
    <section id="cardapio" class="menu-section">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h2>Nosso Cardápio</h2>
            <a href="${pageContext.request.contextPath}/carrinho" class="carrinho-icon">🛒 Carrinho (<span id="carrinhoCount">0</span>)</a>
        </div>
        <form method="get" action="${pageContext.request.contextPath}/home" class="filtros">
            <input type="text" name="busca" placeholder="Buscar prato..." value="${param.busca}">
            <select name="categoria">
                <option value="">Todas categorias</option>
                <c:forEach var="cat" items="${categorias}"><option value="${cat}" ${param.categoria == cat ? 'selected' : ''}>${cat}</option></c:forEach>
            </select>
            <input type="number" step="1" name="minPreco" placeholder="Preço mínimo" value="${param.minPreco}">
            <input type="number" step="1" name="maxPreco" placeholder="Preço máximo" value="${param.maxPreco}">
            <button type="submit">Filtrar</button>
        </form>
        <div class="menu-grid">
            <c:forEach var="prod" items="${produtos}">
                <div class="menu-card">
                    <img src="${pageContext.request.contextPath}/${prod.imagemUrl}" alt="${prod.nome}" loading="lazy">
                    <h3>${prod.nome}</h3>
                    <p class="descricao">${prod.descricao}</p>
                    <p class="categoria"><i class="fas fa-tag"></i> ${prod.categoria}</p>
                    <p class="preco">${prod.preco} MT</p>
                    <div class="avaliacao">
                        <c:choose><c:when test="${prod.mediaAvaliacao > 0}">${String.format("%.1f", prod.mediaAvaliacao)} ★</c:when><c:otherwise>Sem avaliações</c:otherwise></c:choose>
                        <button type="button" onclick="abrirModal(${prod.id})">Avaliar</button>
                    </div>
                    <button class="btn-pedido" data-id="${prod.id}">Adicionar ao Carrinho</button>
                </div>
            </c:forEach>
        </div>
    </section>
    <section id="pedidoRapido" class="pedido-rapido">
        <h2>Pedido Rápido (descreva seu pedido)</h2>
        <c:if test="${not empty msgPedido}"><div class="mensagem">${msgPedido}</div></c:if>
        <c:if test="${not empty linkWhatsApp}"><div class="mensagem">Pedido #${pedidoId} confirmado! <a href="${linkWhatsApp}" target="_blank">Abrir WhatsApp</a></div></c:if>
        <form action="${pageContext.request.contextPath}/fazerPedido" method="post" class="pedido-form">
            <input type="text" name="nome" placeholder="Seu nome" required>
            <input type="tel" name="telefone" placeholder="Telefone (WhatsApp)" required>
            <input type="text" name="endereco" placeholder="Endereço de entrega" required>
            <textarea name="itens" rows="4" placeholder="Descreva seu pedido (ex: 1 Pizza Margherita, 1 Suco Natural)" required></textarea>
            <button type="submit" class="btn-primary">Enviar Pedido</button>
        </form>
    </section>
   <!-- Seção Contato / Localização -->
<section id="contato" class="contato-section">
    <h2>📞 Contato & Localização</h2>
    <div class="contato-wrapper">
        <!-- Coluna de informações -->
        <div class="contato-info">
            <div class="info-card">
                <i class="fas fa-map-marker-alt"></i>
                <h3>Endereço</h3>
                <p>Rua de Barue, Chimoio, Manica<br>Moçambique<br><small>(Recinto UCM, Av de Liberdade)</small></p>
            </div>
            <div class="info-card">
                <i class="fab fa-whatsapp"></i>
                <h3>WhatsApp / Telefone</h3>
                <p><a href="https://wa.me/258857096799" target="_blank" class="btn-whatsapp">📞 +258 85 709 6799</a></p>
                <p><small>Clique para falar connosco</small></p>
            </div>
            <div class="info-card">
                <i class="far fa-envelope"></i>
                <h3>E-mail</h3>
                <p><a href="mailto:celysabores.restaurantes@gmail.com">celysabores.restaurantes@gmail.com</a></p>
            </div>
            <div class="info-card">
                <i class="far fa-clock"></i>
                <h3>Horário de funcionamento</h3>
                <p>Segunda a Sábado: 10h às 22h<br>Domingo: Fechado</p>
            </div>
            <div class="info-card social">
                <h3>Siga-nos</h3>
                <div class="social-links">
                    <a href="https://www.instagram.com/cely_sabores_restaurante/" target="_blank" class="social-btn insta"><i class="fab fa-instagram"></i> Instagram</a>
                    <a href="https://www.facebook.com/p/Cely-Sabores-100094013062391/" target="_blank" class="social-btn facebook"><i class="fab fa-facebook-f"></i> Facebook</a>
                    <a href="https://wa.me/258857096799" target="_blank" class="social-btn whatsapp"><i class="fab fa-whatsapp"></i> WhatsApp</a>
                </div>
            </div>
        </div>
        <!-- Coluna do mapa -->
        <div class="contato-mapa">
            <iframe 
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d358.9561941514015!2d33.47456300794679!3d-19.109391383067535!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x192b355c6c93a863%3A0x81139a197433c9b9!2sCely%20Sabores!5e1!3m2!1spt-PT!2smz!4v1776163990798!5m2!1spt-PT!2smz" 
                width="100%" 
                height="350" 
                style="border:0; border-radius: 20px;" 
                allowfullscreen="" 
                loading="lazy" 
                referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </div>
</section>
</main>
<footer><p>&copy; 2025 Cely Sabores - Sabor que encanta</p></footer>

<div id="modalOverlay" class="modal-overlay"></div>
<div id="modalAvaliacao" class="modal">
    <h3>Avaliar Produto</h3>
    <form action="${pageContext.request.contextPath}/avaliar" method="post">
        <input type="hidden" name="produtoId" id="produtoId">
        <input type="text" name="nome" placeholder="Seu nome" required style="width:100%; margin-bottom:8px;">
        <select name="nota" style="width:100%; margin-bottom:8px;">
            <option value="5">5 ★</option><option value="4">4 ★</option><option value="3">3 ★</option><option value="2">2 ★</option><option value="1">1 ★</option>
        </select>
        <textarea name="comentario" placeholder="Comentário" rows="3" style="width:100%; margin-bottom:8px;"></textarea>
        <div style="text-align:right;"><button type="button" onclick="fecharModal()">Cancelar</button><button type="submit">Enviar</button></div>
    </form>
</div>
<div id="toastMsg" class="mensagem-flutuante"></div>
<script>
    function atualizarContadorCarrinho() {
        fetch('${pageContext.request.contextPath}/carrinho?action=contador')
            .then(r=>r.text()).then(c=>document.getElementById('carrinhoCount').innerText=c)
            .catch(()=>document.getElementById('carrinhoCount').innerText='0');
    }
    document.querySelectorAll('.btn-pedido').forEach(btn=>{
        btn.addEventListener('click',function(){
            const id=this.getAttribute('data-id');
            fetch('${pageContext.request.contextPath}/carrinho',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'action=adicionar&id='+id})
            .then(r=>{if(r.ok){mostrarToast('Item adicionado!');atualizarContadorCarrinho();}else mostrarToast('Erro',true);})
            .catch(()=>mostrarToast('Erro de conexão',true));
        });
    });
    function mostrarToast(msg,erro=false){const t=document.getElementById('toastMsg');t.style.backgroundColor=erro?'#f44336':'#4caf50';t.innerText=msg;t.style.display='block';setTimeout(()=>t.style.display='none',3000);}
    function abrirModal(pid){document.getElementById('produtoId').value=pid;document.getElementById('modalOverlay').style.display='block';document.getElementById('modalAvaliacao').style.display='block';}
    function fecharModal(){document.getElementById('modalOverlay').style.display='none';document.getElementById('modalAvaliacao').style.display='none';}
    document.getElementById('modalOverlay').onclick=fecharModal;
    atualizarContadorCarrinho();
</script>
</body>
</html>