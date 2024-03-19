unit viacep.router;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse, rr4dl, j4dl;

type

  { TBase }

  TViaCep = class
  public
    class procedure Router;
  end;

implementation

{ TBase }

procedure OnViaCep(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lRes: IResponse;
  lCep: string;
begin
  if not aReq.Params.TryGetValue('cep', lCep) then
    lCep := '00000000';

  lRes := TRequest.New.BaseURL(Format('http://viacep.com.br/ws/%s/json/', [lCep]))
  .ContentType('application/json')
  .Get;
  // Pega os dados da API e armazena na variável lRes



  if (lRes.StatusCode = 200) then
    aRes.ContentType('application/json').Send( lJsonTmp.Items[0].Stringify )
  else
    aRes.ContentType('application/json').Status( lRes.StatusCode ).Send( 'Error!' );
    Raise Exception.Create(lJsonTmp.Items[0].Stringify);
  // Envia o conteúdo do json como response, ou envia um erro caso a requisição falhe
end;

class procedure TViaCep.Router;
begin
  THorse.Get('/cep/:cep', OnViaCep);
  // Retorna o objeto correspondente ao parâmetro :cep
end;

end.

