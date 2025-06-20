unit untFrmTarefas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untInterfaceTarefaClient, untTarefasDTO,
  Vcl.StdCtrls, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, System.Generics.Collections,
  Vcl.ComCtrls;

type
  TFrmTarefas = class(TForm)
    memTarefas: TFDMemTable;
    dsTarefas: TDataSource;
    pnlBotoes: TPanel;
    pnlCampos: TPanel;
    pnlGrid: TPanel;
    btnIncluir: TBitBtn;
    memTarefascodigo: TIntegerField;
    memTarefasdescricao: TStringField;
    memTarefasdata_hora_criacao: TDateTimeField;
    memTarefasusuario_criacao: TStringField;
    memTarefasprioridade: TIntegerField;
    memTarefasdata_hora_conclusao: TDateTimeField;
    memTarefasusuario_conclusao: TStringField;
    memTarefasobservacao: TStringField;
    GridTarefas: TDBGrid;
    btnEditar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSalvar: TBitBtn;
    btnExcluir: TBitBtn;
    edtcodigo: TEdit;
    edtdescricao: TEdit;
    edtusuario_criacao: TEdit;
    edtprioridade: TEdit;
    edtusuario_conclusao: TEdit;
    edtdata_hora_criacao: TDateTimePicker;
    edtconcluir: TCheckBox;
    edtobservacao: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    gbEstatisticas: TGroupBox;
    lblTotal: TLabel;
    lblMedia: TLabel;
    lblTotalConcluido: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure memTarefasAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    FTarefasClient: ITarefasClient;
    FModoInclusao: Boolean ;
    procedure PreencherMemTableComTarefas(const ALista: TObjectList<TTarefasDTO>; AMemTable: TFDMemTable);
    procedure CarregaTarefas ;
    procedure ColocarEmEdicao(const AEmEdicao: Boolean) ;
    procedure SincronizaDadosCampos ;
    procedure LimpaDadosCampos ;
    function IncluirRegistro: Boolean ;
    function EditarRegistro: Boolean ;
    function ExcluirRegitro: Boolean ;
    function SalvarRegistro: Boolean ;
    procedure AtualizaEstatisticas ;
  public
    { Public declarations }
  end;

var
  FrmTarefas: TFrmTarefas;

implementation

uses
  untTarefasRestClient, untConstants, System.UITypes ;

const
  MSG_TOTAL = 'Total de Tarefas: %d' ;
  MSG_PENDENTE = 'Média de Prioridade Tarefas Pendêntes: %.2f' ;
  MSG_CONCLUIDAS = 'Qtd. Tarefas Concluídas Ultimos 7 Dias: %d' ;

{$R *.dfm}

{ TFrmTarefas }

procedure TFrmTarefas.AtualizaEstatisticas;
var
  LTotalTarefas: Integer ;
  LPrioridadeTarefaPendente: Double ;
  LTotalTarefasConcluidas: Integer ;
begin
  LTotalTarefas := FTarefasClient.GetTotal ;
  lblTotal.Caption := Format(MSG_TOTAL, [LTotalTarefas]) ;
  LPrioridadeTarefaPendente := FTarefasClient.GetMediaPrioridadePendente ;
  lblMedia.Caption := Format(MSG_PENDENTE, [LPrioridadeTarefaPendente]) ;
  LTotalTarefasConcluidas := FTarefasClient.GetTotalTarefasConcluidasSeteDias ;
  lblTotalConcluido.Caption := Format(MSG_CONCLUIDAS, [LTotalTarefasConcluidas]) ;
end;

procedure TFrmTarefas.btnCancelarClick(Sender: TObject);
begin
  ColocarEmEdicao(False) ;
  LimpaDadosCampos ;
  SincronizaDadosCampos ;
  FModoInclusao := False ;
  edtdescricao.SetFocus ;
end;

procedure TFrmTarefas.btnEditarClick(Sender: TObject);
begin
  if memTarefas.IsEmpty then
    exit ;

  ColocarEmEdicao(True) ;
  edtdescricao.SetFocus ;
end;

procedure TFrmTarefas.btnExcluirClick(Sender: TObject);
begin
  if memTarefas.IsEmpty then
    exit ;

  if MessageDlg('Deseja realmente excluir a tarefa?', mtConfirmation, [mbYes, mbNo], 1) = mrYes then
  begin
    if ExcluirRegitro then
    begin
      memTarefas.Delete ;
      LimpaDadosCampos ;
      SincronizaDadosCampos ;
      AtualizaEstatisticas ;
      edtdescricao.SetFocus ;
    end;
  end ;
end;

procedure TFrmTarefas.btnIncluirClick(Sender: TObject);
begin
  ColocarEmEdicao(True) ;
  LimpaDadosCampos ;
  FModoInclusao := True ;
  edtdescricao.SetFocus ;
end;

procedure TFrmTarefas.btnSalvarClick(Sender: TObject);
begin
  if SalvarRegistro then
  begin
    SincronizaDadosCampos ;
    ColocarEmEdicao(False) ;
    FModoInclusao := False ;
    edtdescricao.SetFocus ;
    AtualizaEstatisticas ;
  end ;
end;

procedure TFrmTarefas.CarregaTarefas;
var
  Tarefas: TObjectList<TTarefasDTO>;
begin
  Tarefas := FTarefasClient.GetAll;
  try
    PreencherMemTableComTarefas(Tarefas, memTarefas) ;
  finally
    FreeAndNil(Tarefas) ;
  end;
end;

procedure TFrmTarefas.ColocarEmEdicao(const AEmEdicao: Boolean);
begin
  btnIncluir.Enabled := not AEmEdicao ;
  btnEditar.Enabled  := not AEmEdicao ;
  btnCancelar.Enabled := AEmEdicao ;
  btnSalvar.Enabled := AEmEdicao ;
  btnExcluir.Enabled := not AEmEdicao ;

  edtdescricao.ReadOnly := not AEmEdicao ;
  edtdescricao.ReadOnly := not AEmEdicao ;
  edtusuario_criacao.ReadOnly := not AEmEdicao ;
  edtprioridade.ReadOnly := not AEmEdicao ;
  edtconcluir.Enabled := AEmEdicao ;
  edtusuario_conclusao.ReadOnly := not AEmEdicao ;
  edtobservacao.ReadOnly := not AEmEdicao ;

  GridTarefas.Enabled := not AEmEdicao ;

end;

function TFrmTarefas.EditarRegistro: Boolean;
var
  LTarefa: TTarefasDTO;
begin
  LTarefa := TTarefasDTO.Create;
  try
    LTarefa.codigo := StrToInt(edtcodigo.Text) ;
    LTarefa.descricao := edtdescricao.Text ;
    LTarefa.data_hora_criacao := edtdata_hora_criacao.DateTime ;
    LTarefa.usuario_criacao := edtusuario_criacao.Text ;
    LTarefa.prioridade := StrToIntDef(edtprioridade.Text, 1) ;
    if edtconcluir.Checked then
      LTarefa.data_hora_conclusao := Now ;
    LTarefa.usuario_conclusao := edtusuario_conclusao.Text ;
    LTarefa.observacao := edtobservacao.Text ;

    Result := FTarefasClient.Put(LTarefa);

  finally
    FreeAndNil(LTarefa);
  end;
end;

function TFrmTarefas.ExcluirRegitro: Boolean;
begin
  result := FTarefasClient.Delete(StrToInt(edtcodigo.Text)) ;
end;

procedure TFrmTarefas.FormCreate(Sender: TObject);
begin
  FTarefasClient := TTarefasRestClient.Create(URL_API);
  memTarefas.CreateDataSet ;
  FModoInclusao := False ;
end;

procedure TFrmTarefas.FormShow(Sender: TObject);
begin
  CarregaTarefas ;
  ColocarEmEdicao(False) ;
  SincronizaDadosCampos ;
  AtualizaEstatisticas ;
end;

function TFrmTarefas.IncluirRegistro: Boolean;
var
  LTarefa: TTarefasDTO;
begin
  LTarefa := TTarefasDTO.Create;
  try
    LTarefa.descricao := edtdescricao.Text ;
    LTarefa.data_hora_criacao := edtdata_hora_criacao.DateTime ;
    LTarefa.usuario_criacao := edtusuario_criacao.Text ;
    LTarefa.prioridade := StrToIntDef(edtprioridade.Text, 1) ;
    if edtconcluir.Checked then
      LTarefa.data_hora_conclusao := Now ;
    LTarefa.usuario_conclusao := edtusuario_conclusao.Text ;
    LTarefa.observacao := edtobservacao.Text ;

    Result := FTarefasClient.Post(LTarefa);

  finally
    FreeAndNil(LTarefa);
  end;
end;

procedure TFrmTarefas.LimpaDadosCampos;
begin
  edtcodigo.Clear ;
  edtdescricao.Clear ;
  edtdata_hora_criacao.DateTime := Now ;
  edtusuario_criacao.Clear ;
  edtprioridade.Text := '1' ;
  edtconcluir.Checked := False ;
  edtusuario_conclusao.Clear ;
  edtobservacao.Clear ;
end;

procedure TFrmTarefas.memTarefasAfterScroll(DataSet: TDataSet);
begin
  SincronizaDadosCampos ;
end;

procedure TFrmTarefas.PreencherMemTableComTarefas(
  const ALista: TObjectList<TTarefasDTO>; AMemTable: TFDMemTable);
var
  Tarefa: TTarefasDTO;
begin
  AMemTable.DisableControls;
  AMemTable.AfterScroll := nil ;
  try
    AMemTable.EmptyDataSet;

    for Tarefa in ALista do
    begin
      AMemTable.Append;
      AMemTable.FieldByName('codigo').AsInteger := Tarefa.Codigo;
      AMemTable.FieldByName('descricao').AsString := Tarefa.Descricao;
      AMemTable.FieldByName('data_hora_criacao').AsDateTime := Tarefa.data_hora_criacao;
      AMemTable.FieldByName('usuario_criacao').AsString := Tarefa.usuario_criacao;
      AMemTable.FieldByName('prioridade').AsInteger := Tarefa.Prioridade;
      if Tarefa.data_hora_conclusao > 0 then
        AMemTable.FieldByName('data_hora_conclusao').AsDateTime := Tarefa.data_hora_conclusao;
      AMemTable.FieldByName('usuario_conclusao').AsString := Tarefa.usuario_conclusao;
      AMemTable.FieldByName('observacao').AsString := Tarefa.observacao;
      AMemTable.Post;
    end;
  finally
    AMemTable.EnableControls;
    AMemTable.AfterScroll := memTarefasAfterScroll ;
  end;
end;

function TFrmTarefas.SalvarRegistro: Boolean;
var
  LCodigo: Integer ;
begin
  try
    if FModoInclusao then
    begin
      Result := IncluirRegistro ;
      if Result then
        CarregaTarefas ;
    end
    else
    begin
      LCodigo := memTarefas.FieldByName('codigo').AsInteger ;
      Result := EditarRegistro ;
      if Result then
      begin
        CarregaTarefas ;
        memTarefas.Locate('codigo', LCodigo, [loCaseInsensitive]) ;
      end;
    end;
  except
    on E: Exception do
    begin
      MessageDlg('Erro ao salvar os dados!'+#13+#10+E.Message, mtError, [mbOK], 0);
      Result := False ;
      edtdescricao.SetFocus ;
    end;
  end;
end;

procedure TFrmTarefas.SincronizaDadosCampos;
begin
  LimpaDadosCampos ;
  if memTarefas.IsEmpty then
    Exit ;

  edtcodigo.Text := memTarefas.FieldByName('codigo').AsString ;
  edtdescricao.Text := memTarefas.FieldByName('descricao').AsString ;
  edtdata_hora_criacao.DateTime := memTarefas.FieldByName('data_hora_criacao').AsDateTime ;
  edtusuario_criacao.Text := memTarefas.FieldByName('usuario_criacao').AsString ;
  edtprioridade.Text := memTarefas.FieldByName('prioridade').AsString ;
  edtconcluir.Checked := not memTarefas.FieldByName('data_hora_conclusao').IsNull ;
  edtusuario_conclusao.Text := memTarefas.FieldByName('usuario_conclusao').AsString ;
  edtobservacao.Text := memTarefas.FieldByName('observacao').AsString ;
end;

end.
