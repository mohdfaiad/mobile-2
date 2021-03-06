USE [venda_simples_server]
GO

CREATE OR ALTER VIEW dbo.vw_guid_id
AS
  SELECT '{' + CAST(NEWID() AS varchar(38)) + '}' AS guid_id
GO

IF OBJECT_ID (N'dbo.ufnGetGuidID', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.ufnGetGuidID;  
GO  
CREATE OR ALTER FUNCTION dbo.ufnGetGuidID()
RETURNS varchar(38)
AS   
BEGIN  
  DECLARE @ret varchar(38);  
  SELECT @ret = guid_id from dbo.vw_guid_id;
  RETURN @ret;  
END;
GO

/*Excluir Tabelas*/

IF OBJECT_ID (N'dbo.tb_pedido_item') IS NOT NULL  
    DROP TABLE dbo.tb_pedido_item;  
GO
IF OBJECT_ID (N'dbo.tb_pedido') IS NOT NULL  
    DROP TABLE dbo.tb_pedido;  
GO
IF OBJECT_ID (N'dbo.tb_produto_empresa') IS NOT NULL  
    DROP TABLE dbo.tb_produto_empresa;  
GO
IF OBJECT_ID (N'dbo.tb_produto') IS NOT NULL  
    DROP TABLE dbo.tb_produto;  
GO
IF OBJECT_ID (N'dbo.tb_cliente_empresa') IS NOT NULL  
	DROP TABLE dbo.tb_cliente_empresa;  
GO
IF OBJECT_ID (N'dbo.tb_cliente') IS NOT NULL  
    DROP TABLE dbo.tb_cliente;  
GO
IF OBJECT_ID (N'dbo.tb_notificacao') IS NOT NULL  
	DROP TABLE dbo.tb_notificacao;  
GO
IF OBJECT_ID (N'dbo.sys_usuario_empresa') IS NOT NULL  
	DROP TABLE dbo.sys_usuario_empresa;  
GO
IF OBJECT_ID (N'dbo.sys_usuario') IS NOT NULL  
	DROP TABLE dbo.sys_usuario;  
GO
IF OBJECT_ID (N'dbo.sys_empresa') IS NOT NULL  
    DROP TABLE dbo.sys_empresa;  
GO

/*Criar Tabelas*/

CREATE TABLE dbo.sys_empresa (
    id_empresa	VARCHAR(38) PRIMARY KEY 
  , cd_empresa	INT IDENTITY(1,1) NOT NULL UNIQUE
  , nm_empresa	VARCHAR(250)
  , nm_fantasia	VARCHAR(150)
  , nr_cnpj_cpf	VARCHAR(25) UNIQUE
)
GO

CREATE TABLE dbo.sys_usuario (
    id_usuario		VARCHAR(38) PRIMARY KEY 
  , cd_usuario		INT IDENTITY(1,1) NOT NULL UNIQUE
  , nm_usuario		VARCHAR(150)
  , ds_email		VARCHAR(150) UNIQUE NOT NULL
  , ds_senha		VARCHAR(40)
  , id_token		VARCHAR(200)
  , tp_plataforma	SMALLINT DEFAULT 0 NOT NULL
)
GO

CREATE TABLE dbo.sys_usuario_empresa (
    id_usuario		VARCHAR(38) NOT NULL
  , id_empresa		VARCHAR(38) NOT NULL
  , sn_ativo		SMALLINT DEFAULT 0 NOT NULL
)
GO

ALTER TABLE dbo.sys_usuario_empresa ADD PRIMARY KEY (id_usuario, id_empresa)
GO

ALTER TABLE dbo.sys_usuario_empresa ADD FOREIGN KEY (id_usuario)
	REFERENCES dbo.sys_usuario (id_usuario)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO
ALTER TABLE dbo.sys_usuario_empresa ADD FOREIGN KEY (id_empresa)
	REFERENCES dbo.sys_empresa (id_empresa)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO

CREATE TABLE dbo.tb_notificacao (
    id_notificacao	VARCHAR(38) PRIMARY KEY
  , id_empresa		VARCHAR(38) NOT NULL
  , id_usuario		VARCHAR(38) NOT NULL
  , cd_notificacao	INT IDENTITY(1,1)
  , dt_notificacao	DATETIME
  , ds_notificacao	VARCHAR(100)
  , tx_notificacao	VARCHAR(500)
  , sn_lida			SMALLINT DEFAULT 0 NOT NULL
  , sn_destacada	SMALLINT DEFAULT 0 NOT NULL
)
GO

ALTER TABLE dbo.tb_notificacao ADD FOREIGN KEY (id_empresa)
	REFERENCES dbo.sys_empresa (id_empresa)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO
ALTER TABLE dbo.tb_notificacao ADD FOREIGN KEY (id_usuario)
	REFERENCES dbo.sys_usuario (id_usuario)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO

CREATE TABLE dbo.tb_produto (
    id_produto		VARCHAR(38) PRIMARY KEY 
  , cd_produto		INT IDENTITY(1,1) NOT NULL UNIQUE
  , ds_produto		VARCHAR(200)
  , vl_produto		NUMERIC(18,2)
)
GO

CREATE TABLE dbo.tb_produto_empresa (
    id_produto		VARCHAR(38) NOT NULL
  , id_empresa		VARCHAR(38) NOT NULL
  , br_produto		VARCHAR(38) 
  , ft_produto		VARCHAR(MAX)
  , sn_ativo		SMALLINT DEFAULT 0 NOT NULL
)
GO

ALTER TABLE dbo.tb_produto_empresa ADD PRIMARY KEY (id_produto, id_empresa)
GO

ALTER TABLE dbo.tb_produto_empresa ADD FOREIGN KEY (id_produto)
	REFERENCES dbo.tb_produto (id_produto)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO
ALTER TABLE dbo.tb_produto_empresa ADD FOREIGN KEY (id_empresa)
	REFERENCES dbo.sys_empresa (id_empresa)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO

CREATE TABLE dbo.tb_cliente (
    id_cliente		VARCHAR(38) PRIMARY KEY 
  , cd_ciente		INT IDENTITY(1,1) NOT NULL UNIQUE
  , nm_cliente		VARCHAR(250)
  , nr_cnpj_cpf		VARCHAR(25)
  , nr_telefone		VARCHAR(25)
  , ds_email		VARCHAR(150)
  , ds_endereco		VARCHAR(500)
  , ds_observacao	VARCHAR(500)
  , dt_ult_compra	DATETIME
  , vl_ult_compra	NUMERIC(18,2)
)
GO

CREATE TABLE dbo.tb_cliente_empresa (
    id_cliente		VARCHAR(38) NOT NULL
  , id_empresa		VARCHAR(38) NOT NULL
)
GO

ALTER TABLE dbo.tb_cliente_empresa ADD PRIMARY KEY (id_cliente, id_empresa)
GO

ALTER TABLE dbo.tb_cliente_empresa ADD FOREIGN KEY (id_cliente)
	REFERENCES dbo.tb_cliente (id_cliente)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO
ALTER TABLE dbo.tb_cliente_empresa ADD FOREIGN KEY (id_empresa)
	REFERENCES dbo.sys_empresa (id_empresa)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO

CREATE TABLE dbo.tb_pedido (
    id_pedido		VARCHAR(38) PRIMARY KEY 
  , cd_pedido		INT IDENTITY(1,1) NOT NULL UNIQUE
  , id_empresa		VARCHAR(38) NOT NULL
  , id_cliente		VARCHAR(38) NOT NULL
  , tp_pedido		SMALLINT DEFAULT 0 NOT NULL
  , dt_pedido		DATETIME
  , ds_contato		VARCHAR(150)
  , ds_observacao	VARCHAR(500)
  , vl_total_bruto		NUMERIC(18,2)
  , vl_total_desconto	NUMERIC(18,2)
  , vl_total_pedido		NUMERIC(18,2)
  , sn_entregue			SMALLINT DEFAULT 0 NOT NULL
  , id_usuario		VARCHAR(38) NOT NULL
)
GO

ALTER TABLE dbo.tb_pedido ADD FOREIGN KEY (id_empresa)
	REFERENCES dbo.sys_empresa (id_empresa)     
GO
ALTER TABLE dbo.tb_pedido ADD FOREIGN KEY (id_cliente)
	REFERENCES dbo.tb_cliente (id_cliente)     
GO
ALTER TABLE dbo.tb_pedido ADD FOREIGN KEY (id_usuario)
	REFERENCES dbo.sys_usuario (id_usuario)     
GO

CREATE TABLE dbo.tb_pedido_item (
    id_item				VARCHAR(38) PRIMARY KEY 
  , cd_item				INT NOT NULL 
  , id_pedido			VARCHAR(38) NOT NULL
  , id_produto			VARCHAR(38) NOT NULL
  , qt_produto			NUMERIC(18,3) DEFAULT 1 NOT NULL
  , vl_produto			NUMERIC(18,3) DEFAULT 0.0 NOT NULL
  , vl_total_bruto		NUMERIC(18,2) DEFAULT 0.0 NOT NULL
  , vl_total_desconto	NUMERIC(18,2) DEFAULT 0.0 NOT NULL
  , vl_total_produto	NUMERIC(18,2) DEFAULT 0.0 NOT NULL
)
GO

ALTER TABLE dbo.tb_pedido_item ADD FOREIGN KEY (id_pedido)
	REFERENCES dbo.tb_pedido (id_pedido)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE
GO
ALTER TABLE dbo.tb_pedido_item ADD FOREIGN KEY (id_produto)
	REFERENCES dbo.tb_produto (id_produto)     
GO
