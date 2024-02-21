unit rr4dl;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses rr4dl.Request.Contract, rr4dl.Response.Contract;

type
  IRequest = rr4dl.Request.Contract.IRequest;
  IResponse = rr4dl.Response.Contract.IResponse;

  TRequest = class
  public
    class function New: IRequest;
  end;

implementation

uses
 {$IF DEFINED(FPC)}
  rr4dl.Request.FPHTTPClient;
{$ELSEIF DEFINED(RR4D_INDY)}
  rr4dl.Request.Indy;
{$ELSEIF DEFINED(RR4D_NETHTTP)}
  rr4dl.Request.NetHTTP;
{$ELSE}
  rr4dl.Request.Client;
{$ENDIF}

class function TRequest.New: IRequest;
begin
 {$IF DEFINED(FPC)}
  Result := TRequestFPHTTPClient.Create;
{$ELSEIF DEFINED(RR4D_INDY)}
  Result := TRequestIndy.Create;
{$ELSEIF DEFINED(RR4D_NETHTTP)}
  Result := TRequestNetHTTP.Create;
{$ELSE}
  Result := TRequestClient.Create;
{$ENDIF}
end;

end.
