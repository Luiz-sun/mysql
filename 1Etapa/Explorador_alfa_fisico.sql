Create database ExploradorAlfa;
use ExploradorAlfa;

CREATE TABLE Jogador (
    idJogador INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    Senha VARCHAR(100),
    Classificacao_etaria INT
);

CREATE TABLE Avatares (
    idAvatares INT PRIMARY KEY AUTO_INCREMENT,
    Aparencia INT,
    Inventario INT,
    Atributos INT,
    Jogar_idJogar INT,
    FOREIGN KEY (Jogar_idJogar) REFERENCES Jogar(idJogar)
);

CREATE TABLE Jogar (
    idJogar INT PRIMARY KEY AUTO_INCREMENT,
    Regras_idRegras INT,
    Jogador_idJogador INT,
    Explorador_Alfa_idExplorador_Alfa INT,
    FOREIGN KEY (Regras_idRegras) REFERENCES Regras(idRegras),
    FOREIGN KEY (Jogador_idJogador) REFERENCES Jogador(idJogador),
    FOREIGN KEY (Explorador_Alfa_idExplorador_Alfa) REFERENCES Explorador_Alfa(idExplorador_Alfa)
);

CREATE TABLE Regras (
    idRegras INT PRIMARY KEY AUTO_INCREMENT,
    Regras_jogo VARCHAR(150),
    Regras_nivel VARCHAR(150),
    Niveis_idNiveis INT,
    Jogar_idJogar INT,
    FOREIGN KEY (Niveis_idNiveis) REFERENCES Niveis(idNiveis),
    FOREIGN KEY (Jogar_idJogar) REFERENCES Jogar(idJogar)
);

CREATE TABLE Explorador_Alfa (
    idExplorador_Alfa INT PRIMARY KEY AUTO_INCREMENT,
    Niveis_idNiveis INT,
    FOREIGN KEY (Niveis_idNiveis) REFERENCES Niveis(idNiveis)
);

CREATE TABLE Niveis (
    idNiveis INT PRIMARY KEY AUTO_INCREMENT,
    cenario VARCHAR(100),
    pontuacao INT,
    check_point INT
);

CREATE TABLE Desafio (
    idDesafio INT PRIMARY KEY AUTO_INCREMENT,
    Progresso INT,
    Regresso INT,
    Charadas VARCHAR(65),
    Obstaculo INT,
    Armadilhas INT,
    Niveis_idNiveis INT,
    FOREIGN KEY (Niveis_idNiveis) REFERENCES Niveis(idNiveis)
);

CREATE TABLE Acessori_avatar (
    Habilidade INT,
    Aparencia INT,
    Peso INT,
    Aparencia_VARCHAR VARCHAR(45),
    Avatares_idAvatares INT,
    FOREIGN KEY (Avatares_idAvatares) REFERENCES Avatares(idAvatares)
);

CREATE TABLE Acessorios (
    idAcessorios INT PRIMARY KEY AUTO_INCREMENT,
    Habilidade INT,
    Aparencia INT,
    Peso INT,
    Niveis_idNiveis INT,
    FOREIGN KEY (Niveis_idNiveis) REFERENCES Niveis(idNiveis)
);