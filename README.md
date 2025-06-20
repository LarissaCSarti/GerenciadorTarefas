# GerenciadorTarefas

**GerenciadorTarefas** é uma aplicação desenvolvida em Delphi que permite o gerenciamento completo de tarefas, incluindo criação, listagem, atualização, exclusão e exibição de estatísticas com base em dados armazenados em SQL Server.
 
O projeto é dividivo em duas partes:
- Um **serviço backend** utilizando framework **Horse**, que expõe APIs REST.
- Uma **aplicação cliente VCL** que consome as APIs via chamadas HTTP.
 
O objetivo é demonstrar boas práticas de deenvolvimento Delphi, uso de design patterns (Abstract Factory), consumo de APIs REST, integração com banco de dados relacional apresentação de estatíscas.

---

## Tecnologias Utilizadas

- **Delphi**
- **Horse Framework** 
- **Biblioteca REST do Delphi**
- **SQL Server**
- **Design Pattern: Abstract Factory**

---

## Estrutura do Banco de Dados

**Tabela: tarefas**

| Campo        | Tipo         | Descrição                   |
|--------------|--------------|-------------------------------|
| codigo           | INT IDENTITY(1,1) PRIMARY KEY     | Identificador da tarefa       |
| descricao       | VARCHAR(255) NOT NULL | Detalhes da tarefa             |
| data_hora_criacao    | DATETIME DEFAULT GETDATE() NOT NULL         | Data/Hora de criação da tarefa            |
| usuario_criacao       | VARCHAR(45) NOT NULL  | Responsável pela criação da tarefa        |
| prioridade   | INT NOT NULL          | Grau de prioridade     |
| data_hora_conclusao | DATETIME     | Data/Hora de conclusão (quando houver)            |
| usuario_conclusao | VARCHAR(45)   | Responsável pela conclusão da tarefa |
| observacao | NVARCHAR(MAX) | Resumo sobre as atividades desempenhadas na tarefa |


**Driver odbc: para o firedac do delphi acessar o SQL Server**
[Driver](https://learn.microsoft.com/pt-br/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver17)

**Docker: subir o sqlserver com o docker**

- **Comando:** docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=projeto@1234" -p 1433:1433 --name sqlserver-projeto -d mcr.microsoft.com/mssql/server:2022-latest

**Logar usando a ferramenta Azure Data Studio**
- **Servidor:** localhost
- **Porta:** 1433
- **Usuário:** sa
- **Senha:** projeto@1234

**Depois de logado no Azure Data Studio, execute os seguintes comandos para criar um usuário e senha e o banco de dados do projeto**
```sql
CREATE DATABASE projeto;
GO

CREATE LOGIN projeto WITH PASSWORD = 'pr0j3to@Ywt';
GO

USE projeto;
GO
CREATE USER projeto FOR LOGIN projeto;
GO

ALTER ROLE db_owner ADD MEMBER projeto;
GO
``` 
---

## Funcionalidades Cliente VCL

- Exibir lista completa das tarefas
- Adicionar nova tarefa via formulário
- Atualizar tarefas
- Remover tarefas
- Visualizar estatíscias fornecidas pela API

---

## Documentação (Postman)

Um arquivo `.json`do Postman está incluído no repositório, permitindo importar a coleção de testes para execução direta das rotas da API (pasta POSTMAN)

---

## Considerações Finais

Este projeto demonstra conhecimentos práticos em:
- Arquitetura de sistemas Delphi com backend + frontend
- Integração com banco de dados SQL Server
- Consumo e Exposição de APIs Rest
- Aplicação de padrões de projeto como Abstract Factory

