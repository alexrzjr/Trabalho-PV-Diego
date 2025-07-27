CREATE DATABASE IF NOT EXISTS gestao_logistica;
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE gestao_logistica;

CREATE TABLE Usuario (
    codUsuario INT AUTO_INCREMENT PRIMARY KEY,
    apelido VARCHAR(15),
    senha VARCHAR(10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Endereco (
    codEndereco INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(50),
    cep VARCHAR(9) UNIQUE NOT NULL,
    cidade VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Transportadora (
    codTransportadora INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(15) UNIQUE NOT NULL,
    nome_fantasia VARCHAR(100) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    IE VARCHAR(9) NOT NULL,
    contato VARCHAR(15),
    codEndereco INT NOT NULL,
    FOREIGN KEY (codEndereco) REFERENCES Endereco(codEndereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Motorista (
    codMotorista INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnh VARCHAR(20) NOT NULL,
    telefone VARCHAR(20),
    codTransportadora INT NOT NULL,
    FOREIGN KEY (codTransportadora) REFERENCES Transportadora(codTransportadora)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Veiculo (
    codVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    capacidade_carga DECIMAL(10,2) NOT NULL,
    codMotorista INT NOT NULL,
    codTransportadora INT NOT NULL,
    statusVeiculo ENUM('Disponível', 'Em uso', 'Manutenção') NOT NULL,
    categoriaVeiculo ENUM('VUC', 'Caminhão Toco', 'Truck', 'Bitruck', 'Bitrem', 'Rodotrem', 'Carreta LS', 'Utilitários') NOT NULL,
    FOREIGN KEY (codMotorista) REFERENCES Motorista(codMotorista),
    FOREIGN KEY (codTransportadora) REFERENCES Transportadora(codTransportadora)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Produto (
    codProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoriaProduto ENUM('Carga Geral', 'Carga a Granel', 'Carga Frigorificada', 'Carga Viva', 'Carga Perigosa', 'Carga Frágil', 'Cargas Indivisíveis e Excepcionais de Grande Porte', 'Cargas Específicas') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Armazem (
    codArmazem INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codEndereco INT NOT NULL,
    FOREIGN KEY (codEndereco) REFERENCES Endereco(codEndereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Estoque (
    codEstoque INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    validade DATE,
    codArmazem INT NOT NULL,
    codProduto INT NOT NULL,
    FOREIGN KEY (codProduto) REFERENCES Produto(codProduto),
    FOREIGN KEY (codArmazem) REFERENCES Armazem(codArmazem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Rota (
    codRota INT AUTO_INCREMENT PRIMARY KEY,
    origem INT NOT NULL,
    destino INT NOT NULL,
    distancia_km DECIMAL(10,2) ,
    duracao_prevista VARCHAR(20),
    FOREIGN KEY (origem) REFERENCES Endereco(codEndereco),
    FOREIGN KEY (destino) REFERENCES Endereco(codEndereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Entrega (
    codEntrega INT AUTO_INCREMENT PRIMARY KEY,
    volume DECIMAL(10,2) NOT NULL,
    peso DECIMAL(10,2),
    prazo_entrega DATE NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codVeiculo INT NOT NULL,
    codMotorista INT NOT NULL,
    codTransportadora INT NOT NULL,
    codRota INT NOT NULL,
    codProduto INT NOT NULL,
    statusEntrega ENUM('Pendente', 'Em Andamento', 'Entregue', 'Cancelada') NOT NULL,
    FOREIGN KEY (codVeiculo) REFERENCES Veiculo(codVeiculo),
    FOREIGN KEY (codMotorista) REFERENCES Motorista(codMotorista),
    FOREIGN KEY (codTransportadora) REFERENCES Transportadora(codTransportadora),
    FOREIGN KEY (codRota) REFERENCES Rota(codRota),
    FOREIGN KEY (codProduto) REFERENCES Produto(codProduto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Rastreamento (
    codRastreamento INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    codEntrega INT NOT NULL,
    FOREIGN KEY (codEntrega) REFERENCES Entrega(codEntrega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE NotaFiscal (
    codNFe INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(10),
    valor DECIMAL(10,2),
    data_emissao DATE,
    codXML VARCHAR(44),
    cancelada TINYINT(1),
    codEntrega INT NOT NULL,
    FOREIGN KEY (codEntrega) REFERENCES Entrega(codEntrega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Faturamento (
    codFaturamento INT AUTO_INCREMENT PRIMARY KEY,
    codEntrega INT NOT NULL,
    codNFe INT NOT NULL,
    FOREIGN KEY (codNFe) REFERENCES NotaFiscal(codNFe),
    FOREIGN KEY (codEntrega) REFERENCES Entrega(codEntrega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 

CREATE TABLE IndicadorLogistico (
    codIndicadorLogistico INT AUTO_INCREMENT PRIMARY KEY,
    data_referencia DATE,
    tempo_medio_entrega DECIMAL(5,2),
    taxa_entregas_no_prazo DECIMAL(5,2),
    custo_operacional_rota DECIMAL(10,2),
    eficiencia_transportadora DECIMAL(5,2),
    codTransportadora INT NOT NULL,
    FOREIGN KEY (codTransportadora) REFERENCES Transportadora(codTransportadora)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO Usuario (apelido, senha)
    VALUES ('admin', 'admin');
