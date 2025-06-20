unit untInterfaceGenericDAO;

interface

uses
  System.Generics.Collections ;

type
  IGenericDAO<T: class> = interface
    ['{B13EC0ED-81D9-4EF7-8641-BB48CA187FB6}']
    function GetAll: TObjectList<T> ;
    function GetById(const AId: Integer): T;
    function Insert(const AItem: T): T;
    function Update(const AItem: T): T;
    procedure Delete(const AId: Integer) ;
    function Count(): Integer ;
    function AvgPrioridadePendente(): Double ;
    function CountTarefasConcluida7Dias(): Integer ;
  end;

implementation

end.
