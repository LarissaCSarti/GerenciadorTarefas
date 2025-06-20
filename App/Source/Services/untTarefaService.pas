unit untTarefaService;

interface

uses
  untInterfaceAPIClientFactory ;

type
  TTarefasService = class
  private
    FFactory: IAPIClientFactory;
  public
    constructor Create(const AFactory: IAPIClientFactory);
  end;

implementation

{ TTarefasService }

constructor TTarefasService.Create(const AFactory: IAPIClientFactory);
begin
  FFactory := AFactory ;
end;

end.
