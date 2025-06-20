unit untTarefasDAO;

interface

uses
  untInterfaceGenericDAO, FireDAC.Comp.Client, System.Generics.Collections,
  untModelTarefas, SysUtils, FireDAC.Stan.Param, Data.DB ;

type
  TTarefasDAO = class(TInterfacedObject, IGenericDAO<TTarefas>)
  private
    FConn: TFDConnection ;
  public
    function GetAll: TObjectList<TTarefas> ;
    function GetById(const AId: Integer): TTarefas;
    function Insert(const AItem: TTarefas): TTarefas;
    function Update(const AItem: TTarefas): TTarefas;
    procedure Delete(const AId: Integer) ;
    constructor Create(AConn: TFDConnection) ;
    function Count(): Integer ;
    function AvgPrioridadePendente(): Double ;
    function CountTarefasConcluida7Dias(): Integer ;
  end;

implementation

uses
  variants ;

{ TTarefasDAO }

function TTarefasDAO.AvgPrioridadePendente: Double;
var
  LQry: TFDQuery ;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' select avg(t.prioridade) as media ') ;
    LQry.SQL.Add(' from tarefas t ') ;
    LQry.SQL.Add(' where t.data_hora_conclusao is null ') ;
    LQry.Open;
    Result := LQry.FieldByName('media').AsFloat ;
  finally
    FreeAndNil(LQry) ;
  end;
end;

function TTarefasDAO.Count: Integer;
var
  LQry: TFDQuery ;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' select count(*) as contador ') ;
    LQry.SQL.Add(' from tarefas t ') ;
    LQry.Open;
    Result := LQry.FieldByName('contador').AsInteger ;
  finally
    FreeAndNil(LQry) ;
  end;
end;

function TTarefasDAO.CountTarefasConcluida7Dias: Integer;
var
  LQry: TFDQuery ;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' select count(*) as contador ') ;
    LQry.SQL.Add(' from tarefas t ') ;
    LQry.SQL.Add(' where t.data_hora_conclusao between DATEADD(DAY, -7, GETDATE()) and GETDATE() ') ;
    LQry.Open;
    Result := LQry.FieldByName('contador').AsInteger ;
  finally
    FreeAndNil(LQry) ;
  end;
end;

constructor TTarefasDAO.Create(AConn: TFDConnection);
begin
  FConn := AConn ;
end;

procedure TTarefasDAO.Delete(const AId: Integer);
var
  LQry: TFDQuery ;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' delete ') ;
    LQry.SQL.Add(' from tarefas ') ;
    LQry.SQL.Add(' where codigo = :codigo ') ;
    LQry.ParamByName('codigo').AsInteger := AId ;
    LQry.ExecSQL;
  finally
    FreeAndNil(LQry) ;
  end;
end;

function TTarefasDAO.GetAll: TObjectList<TTarefas>;
var
  LQry: TFDQuery ;
  LTarefas: TTarefas ;
begin
  Result := TObjectList<TTarefas>.Create();
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' select ') ;
    LQry.SQL.Add('   t.codigo, ') ;
    LQry.SQL.Add('   t.descricao, ') ;
    LQry.SQL.Add('   t.data_hora_criacao, ') ;
    LQry.SQL.Add('   t.usuario_criacao, ') ;
    LQry.SQL.Add('   t.prioridade, ') ;
    LQry.SQL.Add('   t.data_hora_conclusao, ') ;
    LQry.SQL.Add('   t.usuario_conclusao, ') ;
    LQry.SQL.Add('   t.observacao ') ;
    LQry.SQL.Add(' from tarefas t ') ;
    LQry.SQL.Add(' order by t.codigo ') ;
    LQry.Open();
    LQry.First ;
    while not LQry.Eof do
    begin
      LTarefas := TTarefas.Create ;
      LTarefas.codigo := LQry.FieldByName('codigo').AsInteger ;
      LTarefas.descricao := LQry.FieldByName('descricao').AsString ;
      LTarefas.data_hora_criacao := LQry.FieldByName('data_hora_criacao').AsDateTime ;
      LTarefas.usuario_criacao := LQry.FieldByName('usuario_criacao').AsString ;
      LTarefas.prioridade := LQry.FieldByName('prioridade').AsInteger ;
      if LQry.FieldByName('data_hora_conclusao').AsDateTime > 0 then
        LTarefas.data_hora_conclusao := LQry.FieldByName('data_hora_conclusao').AsDateTime ;
      LTarefas.usuario_conclusao := LQry.FieldByName('usuario_conclusao').AsString ;
      LTarefas.observacao := LQry.FieldByName('observacao').AsString ;
      Result.Add(LTarefas) ;
      LQry.Next ;
    end;
  finally
    FreeAndNil(LQry) ;
  end;
end;

function TTarefasDAO.GetById(const AId: Integer): TTarefas;
var
  LQry: TFDQuery ;
begin
  Result := Nil;
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' select ') ;
    LQry.SQL.Add('   t.codigo, ') ;
    LQry.SQL.Add('   t.descricao, ') ;
    LQry.SQL.Add('   t.data_hora_criacao, ') ;
    LQry.SQL.Add('   t.usuario_criacao, ') ;
    LQry.SQL.Add('   t.prioridade, ') ;
    LQry.SQL.Add('   t.data_hora_conclusao, ') ;
    LQry.SQL.Add('   t.usuario_conclusao, ') ;
    LQry.SQL.Add('   t.observacao ') ;
    LQry.SQL.Add(' from tarefas t ') ;
    LQry.SQL.Add(' where t.codigo = :codigo ') ;
    LQry.ParamByName('codigo').AsInteger := AId ;
    LQry.Open();
    if not LQry.IsEmpty then
    begin
      Result := TTarefas.Create ;
      Result.codigo := LQry.FieldByName('codigo').AsInteger ;
      Result.descricao := LQry.FieldByName('descricao').AsString ;
      Result.data_hora_criacao := LQry.FieldByName('data_hora_criacao').AsDateTime ;
      Result.usuario_criacao := LQry.FieldByName('usuario_criacao').AsString ;
      Result.prioridade := LQry.FieldByName('prioridade').AsInteger ;
      if LQry.FieldByName('data_hora_conclusao').AsDateTime > 0 then
        Result.data_hora_conclusao := LQry.FieldByName('data_hora_conclusao').AsDateTime ;
      Result.usuario_conclusao := LQry.FieldByName('usuario_conclusao').AsString ;
      Result.observacao := LQry.FieldByName('observacao').AsString ;
    end;
  finally
    FreeAndNil(LQry) ;
  end;
end;

function TTarefasDAO.Insert(const AItem: TTarefas): TTarefas;
var
  LQry: TFDQuery ;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' insert into tarefas ') ;
    LQry.SQL.Add(' (descricao, data_hora_criacao, usuario_criacao, prioridade, data_hora_conclusao, usuario_conclusao, observacao) ') ;
    LQry.SQL.Add(' output inserted.codigo values ') ;
    LQry.SQL.Add(' (:descricao, :data_hora_criacao, :usuario_criacao, :prioridade, :data_hora_conclusao, :usuario_conclusao, :observacao) ; ') ;
    LQry.ParamByName('descricao').AsString := AItem.descricao ;
    LQry.ParamByName('data_hora_criacao').AsDate := AItem.data_hora_criacao ;
    LQry.ParamByName('usuario_criacao').AsString := AItem.usuario_criacao ;
    LQry.ParamByName('prioridade').AsInteger := AItem.prioridade ;
    if AItem.data_hora_conclusao > 0 then
      LQry.ParamByName('data_hora_conclusao').AsDate := AItem.data_hora_conclusao
    else
    begin
      LQry.ParamByName('data_hora_conclusao').DataType := ftDateTime ;
      LQry.ParamByName('data_hora_conclusao').Clear ;
    end;
    if trim(AItem.usuario_conclusao) <> '' then
      LQry.ParamByName('usuario_conclusao').AsString := AItem.usuario_conclusao
    else
    begin
      LQry.ParamByName('usuario_conclusao').DataType := ftString ;
      LQry.ParamByName('usuario_conclusao').Clear ;
    end;
    if trim(AItem.observacao) <> '' then
      LQry.ParamByName('observacao').AsString := AItem.observacao
    else
    begin
      LQry.ParamByName('observacao').DataType := ftString ;
      LQry.ParamByName('observacao').Clear ;
    end;
    LQry.Open;
    if not LQry.IsEmpty then
      AItem.codigo := LQry.FieldByName('codigo').AsInteger ;
    Result := AItem ;
  finally
    FreeAndNil(LQry) ;
  end;
end;

function TTarefasDAO.Update(const AItem: TTarefas): TTarefas;
var
  LQry: TFDQuery ;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConn ;
    LQry.SQL.Clear ;
    LQry.SQL.Add(' update tarefas set ') ;
    LQry.SQL.Add(' descricao = :descricao,') ;
    LQry.SQL.Add(' data_hora_criacao = :data_hora_criacao,') ;
    LQry.SQL.Add(' usuario_criacao = :usuario_criacao,') ;
    LQry.SQL.Add(' prioridade = :prioridade,') ;
    LQry.SQL.Add(' data_hora_conclusao = :data_hora_conclusao,') ;
    LQry.SQL.Add(' usuario_conclusao = :usuario_conclusao,') ;
    LQry.SQL.Add(' observacao = :observacao ') ;
    LQry.SQL.Add(' where codigo = :codigo ') ;
    LQry.ParamByName('codigo').AsInteger := AItem.codigo ;
    LQry.ParamByName('descricao').AsString := AItem.descricao ;
    LQry.ParamByName('data_hora_criacao').AsDate := AItem.data_hora_criacao ;
    LQry.ParamByName('usuario_criacao').AsString := AItem.usuario_criacao ;
    LQry.ParamByName('prioridade').AsInteger := AItem.prioridade ;
    if AItem.data_hora_conclusao > 0 then
      LQry.ParamByName('data_hora_conclusao').AsDate := AItem.data_hora_conclusao
    else
    begin
      LQry.ParamByName('data_hora_conclusao').DataType := ftDateTime ;
      LQry.ParamByName('data_hora_conclusao').Clear ;
    end;
    if trim(AItem.usuario_conclusao) <> '' then
      LQry.ParamByName('usuario_conclusao').AsString := AItem.usuario_conclusao
    else
    begin
      LQry.ParamByName('usuario_conclusao').DataType := ftString ;
      LQry.ParamByName('usuario_conclusao').Clear ;
    end;
    if trim(AItem.observacao) <> '' then
      LQry.ParamByName('observacao').AsString := AItem.observacao
    else
    begin
      LQry.ParamByName('observacao').DataType := ftString ;
      LQry.ParamByName('observacao').Clear ;
    end;
    LQry.ExecSQL;
    Result := AItem ;
  finally
    FreeAndNil(LQry) ;
  end;
end;

end.
