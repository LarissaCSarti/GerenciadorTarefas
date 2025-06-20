unit untInterfaceTarefaClient;

interface

uses
  System.Generics.Collections, untTarefasDTO ;

type
  ITarefasClient = interface
    ['{2AA8921C-3926-4A58-9181-09640317BDB7}']
    function GetAll: TObjectList<TTarefasDTO> ;
    function GetById(ACodigo: Integer): TTarefasDTO;
    function Post(ATarefa: TTarefasDTO): Boolean;
    function Put(ATarefa: TTarefasDTO): Boolean;
    function Delete(ACodigo: Integer): Boolean;
    function GetTotal: Integer;
    function GetMediaPrioridadePendente: double ;
    function GetTotalTarefasConcluidasSeteDias: Integer;
  end;


implementation

end.
