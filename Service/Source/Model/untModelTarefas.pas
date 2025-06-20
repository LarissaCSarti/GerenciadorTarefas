unit untModelTarefas;

interface

type
  TTarefas = class
  public
    codigo: Integer;
    descricao: String;
    data_hora_criacao: TDateTime ;
    usuario_criacao: String ;
    prioridade: Integer ;
    data_hora_conclusao: TDateTime ;
    usuario_conclusao: String ;
    observacao: String ;
  end;

implementation

end.
