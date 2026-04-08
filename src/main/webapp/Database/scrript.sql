-- Criar banco de dados (se não existir)
CREATE DATABASE IF NOT EXISTS restaurante_db;
USE restaurante_db;

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50),
    imagem_url VARCHAR(255) DEFAULT 'https://via.placeholder.com/300x200?text=Prato'
);

-- Tabela de pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    itens TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Pendente',
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir alguns produtos de exemplo
INSERT INTO produtos (nome, descricao, preco, categoria, imagem_url) VALUES
('Pizza Margherita', 'Molho de tomate, mussarela, manjericão', 450.00, 'Pizza', 'https://images.pexels.com/photos/2147485/pexels-photo-2147485.jpeg'),
('Pizza de Camarão', 'Camarão salteado, catupiry, azeitonas', 650.00, 'Pizza', 'https://images.pexels.com/photos/1351238/pexels-photo-1351238.jpeg'),
('Hambúrguer Artesanal', 'Pão brioche, 180g de carne, queijo cheddar, alface, tomate', 320.00, 'Fast Food', 'https://images.pexels.com/photos/1633578/pexels-photo-1633578.jpeg'),
('Batata Frita', 'Batata crocante com sal e alecrim', 120.00, 'Acompanhamento', 'https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg'),
('Suco Natural', 'Laranja, maracujá ou manga', 80.00, 'Bebida', 'https://images.pexels.com/photos/327142/pexels-photo-327142.jpeg');