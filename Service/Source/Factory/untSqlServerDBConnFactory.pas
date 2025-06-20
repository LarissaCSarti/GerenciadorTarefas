unit untSqlServerDBConnFactory;

interface

uses
  untInterfaceDBConnFactory, FireDAC.Comp.Client, SysUtils ;

type
  TSqlServerDBConnFactory = class(TInterfacedObject, IDBConnFactory)
  public
    function CreateConnection: TFDConnection ;
  end;

implementation

uses
  FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBC, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBCWrapper;

{ TSqlServerDBConnFactory }

function TSqlServerDBConnFactory.CreateConnection: TFDConnection;
begin
  TFDPhysODBCDriverLink.Create(nil);

  Result := TFDConnection.Create(nil);
  Result.Params.Clear ;
  Result.DriverName := 'ODBC' ;
  Result.Params.Values['ODBCDriver'] := 'ODBC Driver 18 for SQL Server' ;
  Result.Params.Values['ODBCAdvanced'] := 'Server=127.0.0.1;Database=projeto;UID=projeto;PWD=pr0j3to@Ywt;Encrypt=Optional;TrustServerCertificate=No' ;
  Result.Connected := True ;
end;

end.
