unit untInterfaceAPIClientFactory;

interface

uses Rest.Client, Rest.Types ;

type
  IAPIClientFactory = interface
    ['{D290C57C-0B1F-459D-B539-BA17A89D4318}']
    function CreateClient: TRESTClient ;
    function CreateRequest(const AResource: string; AMethod: TRESTRequestMethod): TRESTRequest ;
  end;

implementation

end.
