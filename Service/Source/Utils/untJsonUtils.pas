unit untJsonUtils;

interface

uses
  System.SysUtils, System.JSON, System.DateUtils ;

  function TrataJsonDate(const AValor: String): TJSONValue ; overload ;
  function TrataJsonDate(const AValor: TDateTime): TJSONValue ; overload ;
  function TrataDateToStr(const AValor: TDateTime): String ;
  function TrataStrToDate(const AValor: String): TDateTime ;
  function TrataJsonString(const AValor: String): TJSONValue ;

implementation

  function TrataJsonDate(const AValor: String): TJSONValue ;
  begin
    if trim(AValor) = '' then
      Result := TJSONNull.Create
    else
      Result := TJSONString.Create(AValor) ;
  end;

  function TrataJsonDate(const AValor: TDateTime): TJSONValue ;
  begin
    if AValor = 0 then
      Result := TJSONNull.Create
    else
      Result := TJSONString.Create(DateToISO8601(AValor, True)) ;
  end;

  function TrataDateToStr(const AValor: TDateTime): String ;
  begin
    if AValor = 0 then
      Result := ''
    else
      Result := DateToISO8601(AValor, True) ;
  end;

  function TrataStrToDate(const AValor: String): TDateTime ;
  begin
    if trim(AValor) = '' then
      Result := 0
    else
      Result := ISO8601ToDate(AValor) ;
  end;

  function TrataJsonString(const AValor: String): TJSONValue ;
  begin
    if trim(AValor) = '' then
      Result := TJSONNull.Create
    else
      Result := TJSONString.Create(AValor) ;
  end;

end.
