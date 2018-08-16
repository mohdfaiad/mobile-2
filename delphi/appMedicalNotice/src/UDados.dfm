object DtmDados: TDtmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 432
  Width = 560
  object FdSQLiteDriver: TFDPhysSQLiteDriverLink
    Left = 96
    Top = 144
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 96
    Top = 192
  end
  object RESTClientGET: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'identity'
    BaseURL = 
      'http://servicos.hab.org.br/medicalNotice/json/app_especialidade_' +
      'dao.php'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 296
    Top = 104
  end
  object RESTRequestGET: TRESTRequest
    Client = RESTClientGET
    Params = <>
    Resource = 'key=abc'
    Response = RESTResponseGET
    SynchronizedEvents = False
    Left = 296
    Top = 152
  end
  object RESTResponseGET: TRESTResponse
    Left = 296
    Top = 200
  end
  object cnnConexao: TFDConnection
    Params.Strings = (
      'Database=D:\db\mobile\medical_notice.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Transaction = FDTransaction
    UpdateTransaction = FDTransaction
    AfterConnect = cnnConexaoAfterConnect
    BeforeConnect = cnnConexaoBeforeConnect
    Left = 96
    Top = 40
  end
  object FDTransaction: TFDTransaction
    Connection = cnnConexao
    Left = 96
    Top = 88
  end
  object RESTClientPOST: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'identity'
    BaseURL = 
      'http://servicos.hab.org.br/medicalNotice/json/app_especialidade_' +
      'dao.php'
    ContentType = 'application/x-www-form-urlencoded'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 184
    Top = 240
  end
  object RESTRequestPOST: TRESTRequest
    Client = RESTClientPOST
    Method = rmPOST
    Params = <>
    Response = RESTResponsePOST
    SynchronizedEvents = False
    Left = 184
    Top = 288
  end
  object RESTResponsePOST: TRESTResponse
    ContentType = 'application/json'
    Left = 184
    Top = 336
  end
end