program AppTarefas;

uses
  Vcl.Forms,
  untFrmTarefas in 'Source\View\untFrmTarefas.pas' {FrmTarefas},
  untInterfaceAPIClientFactory in 'Source\Factory\untInterfaceAPIClientFactory.pas',
  untTarefaService in 'Source\Services\untTarefaService.pas',
  untTarefasDTO in 'Source\DTO\untTarefasDTO.pas',
  untInterfaceTarefaClient in 'Source\Interfaces\untInterfaceTarefaClient.pas',
  untTarefasRestClient in 'Source\Services\untTarefasRestClient.pas',
  untConstants in 'Source\Configs\untConstants.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmTarefas, FrmTarefas);
  Application.Run;
end.
