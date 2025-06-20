unit untAuth;

interface

uses
  Horse ;

function CheckAuth(Req: THorseRequest; Res: THorseResponse): Boolean ;

implementation

uses untConstants, SysUtils, Horse.Exception ;

function CheckAuth(Req: THorseRequest; Res: THorseResponse): Boolean ;
var
  LToken: String ;
begin
  LToken := Req.Headers['Authorization'] ;

  if not LToken.StartsWith('Bearer ') then
  begin
    Res.Status(401).Send('Token ausente ou mal formatado');
    Exit(False) ;
  end ;

  LToken := LToken.Substring(7) ;

  if not SameText(LToken, AUTH_TOKEN) then
  begin
    Res.Status(401).Send('Token inválido');
    Exit(False) ;
  end ;

  Result := True;
end;

end.
