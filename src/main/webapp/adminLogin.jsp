<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin - Cely Sabores</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
            background: linear-gradient(135deg, #8b3c1c 0%, #5a2a10 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .login-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            overflow: hidden;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            background: #2c1a12;
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .login-header h1 {
            font-size: 1.8rem;
            margin-bottom: 0.3rem;
        }

        .login-header p {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        .login-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2c1a12;
        }

        .form-group input {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-group input:focus {
            border-color: #8b3c1c;
            box-shadow: 0 0 0 3px rgba(139, 60, 28, 0.1);
        }

        .btn-login {
            width: 100%;
            background: #8b3c1c;
            color: white;
            border: none;
            padding: 0.9rem;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top: 0.5rem;
        }

        .btn-login:hover {
            background: #b85e1a;
        }

        .btn-back {
            display: block;
            text-align: center;
            margin-top: 1rem;
            color: #8b3c1c;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .btn-back:hover {
            color: #5a2a10;
            text-decoration: underline;
        }

        .error-message {
            background: #fef2f2;
            border-left: 4px solid #f44336;
            color: #c62828;
            padding: 0.8rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .footer-note {
            text-align: center;
            font-size: 0.75rem;
            color: #999;
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <h1>🍽️ Cely Sabores</h1>
            <p>Área Administrativa</p>
        </div>
        <div class="login-body">
            <c:if test="${not empty erro}">
                <div class="error-message">
                    <strong>⚠️ Erro:</strong> ${erro}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/login" method="post">
                <div class="form-group">
                    <label for="usuario">Usuário</label>
                    <input type="text" id="usuario" name="usuario" placeholder="Digite seu usuário" required autofocus>
                </div>
                <div class="form-group">
                    <label for="senha">Senha</label>
                    <input type="password" id="senha" name="senha" placeholder="Digite sua senha" required>
                </div>
                <button type="submit" class="btn-login">Entrar</button>
                <a href="${pageContext.request.contextPath}/home" class="btn-back">← Voltar para o site</a>
            </form>
            <div class="footer-note">
                Acesso restrito aos administradores
            </div>
        </div>
    </div>
</body>
</html>