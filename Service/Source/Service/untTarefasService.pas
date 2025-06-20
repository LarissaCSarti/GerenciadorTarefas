unit untTarefasService;

interface

uses
  System.Generics.Collections, untModelTarefas, untInterfaceGenericDAO;

type
  TTarefasService = class
  private
    FTarefasDAO: IGenericDAO<TTarefas> ;
    procedure ValidarRegraNegocio(const AItem: TTarefas) ;
  public
    constructor Create(const AItem: IGenericDAO<TTarefas>) ;
    function GetAllTarefas: TObjectList<TTarefas> ;
    function GetByIdTarefas(const AId: Integer): TTarefas;
    function InsertTarefas(const AItem: TTarefas): TTarefas;
    function UpdateTarefas(const AItem: TTarefas): TTarefas;
    procedure DeleteTarefas(const AId: Integer) ;
    function CountTarefas: Integer ;
    function AvgPrioridadePendenteTarefas: Double ;
    function CountTarefasConcluida7DiasTarefas: Integer ;
  end;

implementation

uses
  untExceptions, SysUtils ;

{ TTarefasService }

function TTarefasService.AvgPrioridadePendenteTarefas: Double;
begin
  Result := FTarefasDAO.AvgPrioridadePendente ;
end;

function TTarefasService.CountTarefas: Integer;
begin
  Result := FTarefasDAO.Count ;
end;

function TTarefasService.CountTarefasConcluida7DiasTarefas: Integer;
begin
  Result := FTarefasDAO.CountTarefasConcluida7Dias ;
end;

constructor TTarefasService.Create(const AItem: IGenericDAO<TTarefas>);
begin
  FTarefasDAO := AItem ;
end;

procedure TTarefasService.DeleteTarefas(const AId: Integer);
begin
  FTarefasDAO.Delete(AId);
end;

function TTarefasService.GetAllTarefas: TObjectList<TTarefas>;
begin
  Result := FTarefasDAO.GetAll ;
end;

function TTarefasService.GetByIdTarefas(const AId: Integer): TTarefas;
begin
  Result := FTarefasDAO.GetById(AId) ;
end;

function TTarefasService.InsertTarefas(const AItem: TTarefas): TTarefas;
begin
  ValidarRegraNegocio(AItem) ;
  Result := FTarefasDAO.Insert(AItem) ;
end;

function TTarefasService.UpdateTarefas(const AItem: TTarefas): TTarefas;
begin
  ValidarRegraNegocio(AItem) ;
  Result := FTarefasDAO.Update(AItem) ;
end;

procedure TTarefasService.ValidarRegraNegocio(const AItem: TTarefas);
begin
  if AItem.data_hora_conclusao <> 0 then
  begin
    if trim(AItem.usuario_conclusao) = '' then
      raise ERegraNegocioValidacao.Create('Usuario de conclusao deve ser informado quando a data de conclusao estiver informada!');

    if trim(AItem.observacao) = '' then
      raise ERegraNegocioValidacao.Create('Observacao deve ser informada quando a data de conclusao estiver informada!');

    if AItem.data_hora_conclusao < AItem.data_hora_criacao then
      raise ERegraNegocioValidacao.Create('Data de conclusao deve ser maior que a data de criacao!');

  end;

  if (trim(AItem.observacao) <> '') and (AItem.data_hora_conclusao = 0) then
    raise ERegraNegocioValidacao.Create('Informar a data de conclusao quando a observacao estiver informada!');

  if (trim(AItem.usuario_conclusao) <> '') and (AItem.data_hora_conclusao = 0) then
    raise ERegraNegocioValidacao.Create('Informar a data de conclusao quando o usuario de conclusao estiver informado!');

  if trim(AItem.descricao) = '' then
    raise ERegraNegocioValidacao.Create('Informe a descricao!');

  if AItem.data_hora_criacao = 0 then
    AItem.data_hora_criacao := Now;

  if trim(AItem.usuario_criacao) = '' then
    raise ERegraNegocioValidacao.Create('Informe a usuario de criacao!');

  if AItem.prioridade <= 0 then
    raise ERegraNegocioValidacao.Create('Informe a prioridade!');

end;

end.
