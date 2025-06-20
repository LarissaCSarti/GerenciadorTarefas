unit untTarefasRestClient;

interface

uses
  untInterfaceTarefaClient, untTarefasDTO, System.JSON, System.Generics.Collections,
  REST.Client, REST.Types, System.SysUtils;

type
  TTarefasRestClient = class(TInterfacedObject, ITarefasClient)
  private
    FBaseURL: string;
    function ParseTarefa(const AJson: TJSONObject): TTarefasDTO;
    function TarefaDTOToJSON(ATarefa: TTarefasDTO): TJSONObject;
    procedure ValidarRegraNegocio(ATarefa: TTarefasDTO);
  public
    constructor Create(const ABaseURL: string);
    function GetAll: TObjectList<TTarefasDTO>;
    function GetById(ACodigo: Integer): TTarefasDTO;
    function Post(ATarefa: TTarefasDTO): Boolean;
    function Put(ATarefa: TTarefasDTO): Boolean;
    function Delete(ACodigo: Integer): Boolean;
    function GetTotal: Integer;
    function GetMediaPrioridadePendente: double ;
    function GetTotalTarefasConcluidasSeteDias: Integer;
  end;

implementation

uses REST.Json, untConstants, System.DateUtils;

{ TTarefasRestClient }

constructor TTarefasRestClient.Create(const ABaseURL: string);
begin
  FBaseURL := ABaseURL;
end;

function TTarefasRestClient.Delete(ACodigo: Integer): Boolean;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
begin
  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas/' + ACodigo.ToString);
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmDELETE;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    Result := LRESTRequest.Response.StatusCode = 200;
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.GetAll: TObjectList<TTarefasDTO>;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LJsonArr: TJSONArray;
  LCnt: Integer;
begin
  Result := TObjectList<TTarefasDTO>.Create;
  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas');
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmGET;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    LJsonArr := LRESTRequest.Response.JSONValue as TJSONArray;
    for LCnt := 0 to LJsonArr.Count - 1 do
      Result.Add(ParseTarefa(LJsonArr.Items[LCnt] as TJSONObject));
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.GetById(ACodigo: Integer): TTarefasDTO;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
begin
  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas/' + ACodigo.ToString);
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmGET;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    Result := ParseTarefa(LRESTRequest.Response.JSONValue as TJSONObject);
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.GetMediaPrioridadePendente: double;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LJSON: TJSONObject;
begin
  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas/media-prioridades-pendentes');
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmGET;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    LJSON := LRESTRequest.Response.JSONValue as TJSONObject;
    Result := LJSON.GetValue<Double>('valor');
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.GetTotal: Integer;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LJSON: TJSONObject;
begin
  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas/total');
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmGET;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    LJSON := LRESTRequest.Response.JSONValue as TJSONObject;
    Result := LJSON.GetValue<Integer>('valor');
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.GetTotalTarefasConcluidasSeteDias: Integer;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LJSON: TJSONObject;
begin
  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas/total-tarefas-concluidas-sete-dias');
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmGET;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    LJSON := LRESTRequest.Response.JSONValue as TJSONObject;
    Result := LJSON.GetValue<Integer>('valor');
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.ParseTarefa(const AJson: TJSONObject): TTarefasDTO;
var
  LDateStr1, LDateStr2: string;
begin
  Result := TTarefasDTO.Create;

  if AJson.TryGetValue<Integer>('codigo', Result.codigo) and
     AJson.TryGetValue<string>('descricao', Result.descricao) and
     AJson.TryGetValue<string>('usuario_criacao', Result.usuario_criacao) and
     AJson.TryGetValue<string>('usuario_conclusao', Result.usuario_conclusao) and
     AJson.TryGetValue<string>('observacao', Result.observacao) and
     AJson.TryGetValue<Integer>('prioridade', Result.prioridade) then
  begin
    if AJson.TryGetValue<string>('data_hora_criacao', LDateStr1) then
      if trim(LDateStr1) <> '' then      
        Result.data_hora_criacao := ISO8601ToDate(LDateStr1);

    if AJson.TryGetValue<string>('data_hora_conclusao', LDateStr2) then
      if trim(LDateStr2) <> '' then
        Result.data_hora_conclusao := ISO8601ToDate(LDateStr2) ;
  end;
end;

function TTarefasRestClient.Post(ATarefa: TTarefasDTO): Boolean;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LJso: TJSONObject;
begin

  ValidarRegraNegocio(ATarefa) ;

  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas');
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmPOST;
    LJso := TarefaDTOToJSON(ATarefa);
    try
      LRESTRequest.AddBody(LJso.ToJSON, ctAPPLICATION_JSON);
    finally
      FreeAndNil(LJso) ;
    end;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    Result := LRESTRequest.Response.StatusCode = 201;
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.Put(ATarefa: TTarefasDTO): Boolean;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LJso: TJSONObject;
begin

  ValidarRegraNegocio(ATarefa) ;

  LRESTClient := TRESTClient.Create(FBaseURL + '/tarefas/' + ATarefa.codigo.ToString);
  LRESTRequest := TRESTRequest.Create(nil);
  try
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Method := rmPUT;
    LJso := TarefaDTOToJSON(ATarefa);
    try
      LRESTRequest.AddBody(LJso.ToJSON, ctAPPLICATION_JSON);
    finally
      FreeAndNil(LJso) ;
    end;
    LRESTRequest.AddParameter('Authorization', 'Bearer ' + TOKEN_AUTH, pkHTTPHEADER, [poDoNotEncode]);
    LRESTRequest.Execute;
    Result := LRESTRequest.Response.StatusCode = 200;
  finally
    LRESTRequest.Free;
    LRESTClient.Free;
  end;
end;

function TTarefasRestClient.TarefaDTOToJSON(ATarefa: TTarefasDTO): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('codigo', TJSONNumber.Create(ATarefa.codigo));
    Result.AddPair('descricao', ATarefa.descricao);
    Result.AddPair('usuario_criacao', ATarefa.usuario_criacao);
    Result.AddPair('prioridade', TJSONNumber.Create(ATarefa.prioridade));
    Result.AddPair('data_hora_criacao', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', ATarefa.data_hora_criacao));
    Result.AddPair('usuario_conclusao', ATarefa.usuario_conclusao);
    if ATarefa.data_hora_conclusao > 0 then
      Result.AddPair('data_hora_conclusao', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', ATarefa.data_hora_conclusao))
    else
      Result.AddPair('data_hora_conclusao', TJSONNull.Create) ;
    Result.AddPair('observacao', ATarefa.observacao);
  except
    Result.Free;
    raise;
  end;  
end;

procedure TTarefasRestClient.ValidarRegraNegocio(ATarefa: TTarefasDTO);
begin
  if ATarefa.data_hora_conclusao <> 0 then
  begin
    if trim(ATarefa.usuario_conclusao) = '' then
      raise Exception.Create('Usuário de conclusão deve ser informado quando a data de conclusão estiver informada!');

    if trim(ATarefa.observacao) = '' then
      raise Exception.Create('Observação deve ser informada quando a data de conclusão estiver informada!');

    if ATarefa.data_hora_conclusao < ATarefa.data_hora_criacao then
      raise Exception.Create('Data de conclusão deve ser maior que a data de criação!');

  end;

  if (trim(ATarefa.observacao) <> '') and (ATarefa.data_hora_conclusao = 0) then
    raise Exception.Create('Informar a data de conclusão quando a observação estiver informada!');

  if (trim(ATarefa.usuario_conclusao) <> '') and (ATarefa.data_hora_conclusao = 0) then
    raise Exception.Create('Informar a data de conclusão quando o usuário de conclusão estiver informado!');

  if trim(ATarefa.descricao) = '' then
    raise Exception.Create('Informe a descricão!');

  if trim(ATarefa.usuario_criacao) = '' then
    raise Exception.Create('Informe a usuario de criação!');

  if ATarefa.prioridade <= 0 then
    raise Exception.Create('Informe a prioridade!');
end;

end.
