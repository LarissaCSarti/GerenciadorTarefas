unit untTarefasRoutes;

interface

uses
  Horse, untInterfaceGenericDAO, System.JSON,
  System.Generics.Collections, untModelTarefas, Horse.Request, Horse.Response,
  FireDAC.Comp.Client, untInterfaceDBConnFactory ;

procedure RegisterRoutes(AFactory: IDBConnFactory) ;

implementation

uses
  SysUtils, untTarefasDAO, untTarefasService, untJsonUtils, untExceptions, untAuth ;


procedure RegisterRoutes(AFactory: IDBConnFactory) ;
begin
  // get all
  THorse.Get('/tarefas', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LTarefas: TObjectList<TTarefas> ;
    LJArray: TJSONArray ;
    LTarefa: TTarefas ;
    LJsonObject: TJSONObject ;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      LDAO := TTarefasDAO.Create(LConn) ;
      LService := TTarefasService.Create(LDAO);
      LTarefas := LService.GetAllTarefas ;

      LJArray := TJSONArray.Create ;
      for LTarefa in LTarefas do
      begin
        LJsonObject := TJSONObject.Create;
        LJsonObject.AddPair('codigo', TJSONNumber.Create(LTarefa.codigo)) ;
        LJsonObject.AddPair('descricao', TJSONString.Create(LTarefa.descricao)) ;
        LjsonObject.AddPair('data_hora_criacao', TrataJsonDate(LTarefa.data_hora_criacao)) ;
        LJsonObject.AddPair('usuario_criacao', TJSONString.Create(LTarefa.usuario_criacao)) ;
        LJsonObject.AddPair('prioridade', TJSONNumber.Create(LTarefa.prioridade)) ;
        LjsonObject.AddPair('data_hora_conclusao', TrataJsonDate(LTarefa.data_hora_conclusao)) ;
        LJsonObject.AddPair('usuario_conclusao', TrataJsonString(LTarefa.usuario_conclusao)) ;
        LJsonObject.AddPair('observacao', TrataJsonString(LTarefa.observacao)) ;
        LJArray.AddElement(LJsonObject);
      end;
      Res.ContentType('application/json; charset=utf-8');
      Res.Send(LJArray.ToJSON) ;
    finally
      FreeAndNil(LConn) ;
    end;
  end
  ) ;

  // post
  THorse.Post('/tarefas', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LTarefa: TTarefas ;
    LBody: TJSONObject ;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      try
        LDAO := TTarefasDAO.Create(LConn) ;
        LService := TTarefasService.Create(LDAO);

        LBody := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));

        LTarefa := TTarefas.Create ;
        LTarefa.descricao := LBody.GetValue<string>('descricao');
        LTarefa.data_hora_criacao := TrataStrToDate(LBody.GetValue<string>('data_hora_criacao')) ;
        LTarefa.usuario_criacao := LBody.GetValue<string>('usuario_criacao');
        LTarefa.prioridade := LBody.GetValue<Integer>('prioridade');
        LTarefa.data_hora_conclusao := TrataStrToDate(LBody.GetValue<string>('data_hora_conclusao')) ;
        LTarefa.usuario_conclusao := LBody.GetValue<string>('usuario_conclusao');
        LTarefa.observacao := LBody.GetValue<string>('observacao');

        LTarefa := LService.InsertTarefas(LTarefa) ;

        Res.ContentType('application/json; charset=utf-8');
        Res.Status(201).Send(TJSONObject.Create
                             .AddPair('codigo', TJSONNumber.Create(LTarefa.codigo))
                             .AddPair('descricao', TJSONString.Create(LTarefa.descricao))
                             .AddPair('data_hora_criacao', TrataJsonDate(LTarefa.data_hora_criacao))
                             .AddPair('usuario_criacao', TJSONString.Create(LTarefa.usuario_criacao))
                             .AddPair('prioridade', TJSONNumber.Create(LTarefa.prioridade))
                             .AddPair('data_hora_conclusao', TrataJsonDate(LTarefa.data_hora_conclusao))
                             .AddPair('usuario_conclusao', TrataJsonString(LTarefa.usuario_conclusao))
                             .AddPair('observacao', TrataJsonString(LTarefa.observacao)).ToJSON
                 ) ;
      finally
        FreeAndNil(LConn) ;
      end;
    except
      on E: ERegraNegocioValidacao do
        Res.Status(400).Send(TJSONObject.Create.AddPair('error', e.Message).ToJSON) ;
      on E: Exception do
        Res.Status(500).Send(TJSONObject.Create.AddPair('error', e.Message).ToJSON) ;
    end ;
  end
  ) ;


  // get by codigo
  THorse.Get('/tarefas/:id', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LTarefa: TTarefas ;
    LJsonObject: TJSONObject ;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      LDAO := TTarefasDAO.Create(LConn) ;
      LService := TTarefasService.Create(LDAO);
      LTarefa := LService.GetByIdTarefas(Req.Params['id'].ToInteger) ;

      if Assigned(LTarefa) then
      begin
        LJsonObject := TJSONObject.Create;
        LJsonObject.AddPair('codigo', TJSONNumber.Create(LTarefa.codigo)) ;
        LJsonObject.AddPair('descricao', TJSONString.Create(LTarefa.descricao)) ;
        LjsonObject.AddPair('data_hora_criacao', TrataJsonDate(LTarefa.data_hora_criacao)) ;
        LJsonObject.AddPair('usuario_criacao', TJSONString.Create(LTarefa.usuario_criacao)) ;
        LJsonObject.AddPair('prioridade', TJSONNumber.Create(LTarefa.prioridade)) ;
        LjsonObject.AddPair('data_hora_conclusao', TrataJsonDate(LTarefa.data_hora_conclusao)) ;
        LJsonObject.AddPair('usuario_conclusao', TrataJsonString(LTarefa.usuario_conclusao)) ;
        LJsonObject.AddPair('observacao', TrataJsonString(LTarefa.observacao)) ;

        Res.ContentType('application/json; charset=utf-8');
        Res.Send(LJsonObject.ToJSON) ;
      end
      else
        Res.Status(404).Send('Tarefa não encontrada');

    finally
      FreeAndNil(LConn) ;
    end;
  end
  ) ;

  // Put
  THorse.Put('/tarefas/:id', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LTarefa: TTarefas ;
    LBody: TJSONObject ;
    LCodigo: Integer;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      try
        LDAO := TTarefasDAO.Create(LConn) ;
        LService := TTarefasService.Create(LDAO);

        LCodigo := Req.Params['id'].ToInteger ;
        LBody := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));
        LTarefa := TTarefas.Create ;
        LTarefa.codigo := LCodigo ;
        LTarefa.descricao := LBody.GetValue<string>('descricao');
        LTarefa.data_hora_criacao := TrataStrToDate(LBody.GetValue<string>('data_hora_criacao'));
        LTarefa.usuario_criacao := LBody.GetValue<string>('usuario_criacao');
        LTarefa.prioridade := LBody.GetValue<Integer>('prioridade');
        LTarefa.data_hora_conclusao := TrataStrToDate(LBody.GetValue<string>('data_hora_conclusao'));
        LTarefa.usuario_conclusao := LBody.GetValue<string>('usuario_conclusao');
        LTarefa.observacao := LBody.GetValue<string>('observacao');

        LTarefa := LService.UpdateTarefas(LTarefa) ;

        Res.ContentType('application/json; charset=utf-8');
        Res.Send(TJSONObject.Create
                  .AddPair('codigo', TJSONNumber.Create(LTarefa.codigo))
                  .AddPair('descricao', TJSONString.Create(LTarefa.descricao))
                  .AddPair('data_hora_criacao', TrataJsonDate(LTarefa.data_hora_criacao))
                  .AddPair('usuario_criacao', TJSONString.Create(LTarefa.usuario_criacao))
                  .AddPair('prioridade', TJSONNumber.Create(LTarefa.prioridade))
                  .AddPair('data_hora_conclusao', TrataJsonDate(LTarefa.data_hora_conclusao))
                  .AddPair('usuario_conclusao', TrataJsonString(LTarefa.usuario_conclusao))
                  .AddPair('observacao', TrataJsonString(LTarefa.observacao)).ToJSON
                 ) ;

      finally
        FreeAndNil(LConn) ;
      end;
    except
      on E: ERegraNegocioValidacao do
        Res.Status(400).Send(TJSONObject.Create.AddPair('error', e.Message).ToJSON) ;
      on E: Exception do
        Res.Status(500).Send(TJSONObject.Create.AddPair('error', e.Message).ToJSON) ;
    end ;
  end
  ) ;

  // Delete
  THorse.Delete('/tarefas/:id', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LCodigo: Integer;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      LDAO := TTarefasDAO.Create(LConn) ;
      LService := TTarefasService.Create(LDAO);
      LCodigo := Req.Params['id'].ToInteger ;
      LService.DeleteTarefas(LCodigo) ;

      Res.ContentType('application/json; charset=utf-8');
      Res.Send('Sucesso') ;

    finally
      FreeAndNil(LConn) ;
    end;
  end
  ) ;

  // total tarefas
  THorse.Get('/tarefas/total', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LTotal: Integer ;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      LDAO := TTarefasDAO.Create(LConn) ;
      LService := TTarefasService.Create(LDAO);
      LTotal := LService.CountTarefas ;

      Res.Send(TJSONObject.Create.AddPair('valor', TJSONNumber.Create(LTotal)).ToJSON);

    finally
      FreeAndNil(LConn) ;
    end;
  end
  ) ;

  // Media Prioridades Pendentes
  THorse.Get('/tarefas/media-prioridades-pendentes', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LMedia: Double ;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      LDAO := TTarefasDAO.Create(LConn) ;
      LService := TTarefasService.Create(LDAO);
      LMedia := LService.AvgPrioridadePendenteTarefas ;

      Res.Send(TJSONObject.Create.AddPair('valor', TJSONNumber.Create(LMedia)).ToJSON);

    finally
      FreeAndNil(LConn) ;
    end;
  end
  ) ;

  // total tarefas
  THorse.Get('/tarefas/total-tarefas-concluidas-sete-dias', procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    LConn: TFDConnection ;
    LDAO: IGenericDAO<TTarefas> ;
    LService: TTarefasService ;
    LTotal: Integer ;
  begin
    if not CheckAuth(Req, Res) then
      Exit;

    LConn := AFactory.CreateConnection ;
    try
      LDAO := TTarefasDAO.Create(LConn) ;
      LService := TTarefasService.Create(LDAO);
      LTotal := LService.CountTarefasConcluida7DiasTarefas ;

      Res.Send(TJSONObject.Create.AddPair('valor', TJSONNumber.Create(LTotal)).ToJSON);

    finally
      FreeAndNil(LConn) ;
    end;
  end
  ) ;

end ;

end.
