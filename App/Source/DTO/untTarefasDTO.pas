unit untTarefasDTO;

interface

type
  TTarefasDTO = class
  public
    codigo: integer ;
    descricao: String ;
    usuario_criacao: String ;
    prioridade: integer ;
    data_hora_criacao: TDateTime ;
    usuario_conclusao: String ;
    data_hora_conclusao: TDateTime ;
    observacao: String ;
  end;

implementation

end.
