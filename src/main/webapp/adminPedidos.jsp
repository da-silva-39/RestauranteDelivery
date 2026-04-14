<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Pedidos - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
        .btn-secondary {
            background: #8b3c1c;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a2a10;
        }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background: #a71d2a;
        }
        .pedidos-table {
            width: 100%;
            border-collapse: collapse;
            overflow-x: auto;
            display: block;
        }
        .pedidos-table th, .pedidos-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        .pedidos-table th {
            background: #8b3c1c;
            color: white;
            font-weight: 600;
        }
        .pedidos-table tr:hover {
            background: #fef8f0;
        }
        .status-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            text-align: center;
        }
        .status-pendente { background: #ffc107; color: #856404; }
        .status-preparo { background: #17a2b8; color: white; }
        .status-entregue { background: #28a745; color: white; }
        .status-cancelado { background: #dc3545; color: white; }
        .status-select {
            padding: 0.3rem 0.5rem;
            border-radius: 20px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
        }
        .action-icons a {
            margin-right: 0.8rem;
            text-decoration: none;
            font-size: 1.2rem;
        }
        .delete { color: #dc3545; }
        .delete:hover { color: #a71d2a; }
        .whatsapp-link {
            color: #25d366;
            font-size: 1.2rem;
            margin-left: 0.5rem;
            text-decoration: none;
        }
        .whatsapp-link:hover { color: #128c7e; }
        .empty-message {
            text-align: center;
            padding: 3rem;
            color: #888;
            font-size: 1.1rem;
        }
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .pedidos-table th, .pedidos-table td { padding: 0.5rem; font-size: 0.8rem; }
            .status-select { font-size: 0.7rem; }
        }
    </style>
    <script>
        function confirmarExclusao(id) {
            if (confirm('Tem certeza que deseja excluir o pedido #' + id + '?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/pedidos?action=excluir&id=' + id;
            }
        }
        function alterarStatus(id, select) {
            var novoStatus = select.value;
            window.location.href = '${pageContext.request.contextPath}/admin/pedidos?action=atualizarStatus&id=' + id + '&status=' + encodeURIComponent(novoStatus);
        }
    </script>
</head>
<body>
<div class="admin-container">
    <h1>
        📦 Pedidos dos Clientes
    </h1>
    <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/produtos" class="btn btn-secondary">← Voltar para Produtos</a>
        <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-danger">🚪 Sair</a>
    </div>

    <c:choose>
        <c:when test="${empty pedidos}">
            <div class="empty-message">
                Nenhum pedido encontrado.
            </div>
        </c:when>
        <c:otherwise>
            <div style="overflow-x: auto;">
                <table class="pedidos-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Cliente</th>
                            <th>Telefone</th>
                            <th>Endereço</th>
                            <th>Itens</th>
                            <th>Status</th>
                            <th>Data</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ped" items="${pedidos}">
                            <tr>
                                <td>${ped.id}</td>
                                <td>
                                    ${ped.clienteNome}
                                    <a href="https://wa.me/258${ped.telefone}?text=Olá ${ped.clienteNome}, seu pedido #${ped.id} está ${ped.status}" 
                                       target="_blank" class="whatsapp-link" title="WhatsApp">
                                        💬
                                    </a>
                                </td>
                                <td>${ped.telefone}</td>
                                <td>${ped.endereco}</td>
                                <td style="max-width: 300px; white-space: normal; word-break: break-word;">${ped.itens}</td>
                                <td>
                                    <select class="status-select" onchange="alterarStatus(${ped.id}, this)">
                                        <option value="Pendente" ${ped.status == 'Pendente' ? 'selected' : ''}>🟡 Pendente</option>
                                        <option value="Em preparo" ${ped.status == 'Em preparo' ? 'selected' : ''}>🔵 Em preparo</option>
                                        <option value="Entregue" ${ped.status == 'Entregue' ? 'selected' : ''}>🟢 Entregue</option>
                                        <option value="Cancelado" ${ped.status == 'Cancelado' ? 'selected' : ''}>🔴 Cancelado</option>
                                    </select>
                                </td>
                                <td>${ped.dataPedido}</td>
                                <td class="action-icons">
                                    <a href="#" onclick="confirmarExclusao(${ped.id})" class="delete" title="Excluir">🗑️ Apagar Pedido</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>