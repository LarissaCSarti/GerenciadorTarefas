unit untInterfaceDBConnFactory;

interface

uses
  FireDAC.Comp.Client ;

type
  IDBConnFactory = interface
    ['{923C4484-873D-43DE-BAE9-4B9BD6AF22D8}']
    function CreateConnection: TFDConnection ;
  end;

implementation

end.
