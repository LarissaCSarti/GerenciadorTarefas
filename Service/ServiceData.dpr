program ServiceData;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  untConstants in 'Source\Configs\untConstants.pas',
  untAuth in 'Source\Security\untAuth.pas',
  System.SysUtils,
  untInterfaceDBConnFactory in 'Source\Factory\untInterfaceDBConnFactory.pas',
  untSqlServerDBConnFactory in 'Source\Factory\untSqlServerDBConnFactory.pas',
  untInterfaceGenericDAO in 'Source\DAO\untInterfaceGenericDAO.pas',
  untTarefasDAO in 'Source\DAO\untTarefasDAO.pas',
  untModelTarefas in 'Source\Model\untModelTarefas.pas',
  untTarefasRoutes in 'Source\Routes\untTarefasRoutes.pas',
  untTarefasService in 'Source\Service\untTarefasService.pas',
  untJsonUtils in 'Source\Utils\untJsonUtils.pas',
  untExceptions in 'Source\Utils\untExceptions.pas';

begin
  try
    var Factory: IDBConnFactory;
    Factory := TSqlServerDBConnFactory.Create;
    RegisterRoutes(Factory);
    THorse.Listen(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
