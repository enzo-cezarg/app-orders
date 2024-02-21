unit rr4dl.Response.FPHTTPClient;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}

interface

uses Classes, SysUtils, rr4dl.Response.Contract, fphttpclient, openssl, opensslsockets;

type

  { TResponseFpHTTPClient }

  TResponseFpHTTPClient = class(TInterfacedObject, IResponse)
  private
    FFPHTTPClient: TFPHTTPClient;
    FStreamResult: TStringStream;
    function Content: string;
    function ContentLength: Cardinal;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentStream: TStream;
    function StatusCode: Integer;
    function StatusText: string;
    function RawBytes: TBytes;
    function Headers: TStrings;
    function StreamResult: TStringStream;
  public
    constructor Create(const AFPHTTPClient: TFPHTTPClient);
    destructor Destroy; override;
  end;

implementation

function TResponseFpHTTPClient.RawBytes: TBytes;
begin
  Result := FStreamResult.Bytes;
end;

function TResponseFpHTTPClient.Content: string;
begin
  Result := FStreamResult.DataString;
end;

function TResponseFpHTTPClient.Headers: TStrings;
begin
  Result := FFPHTTPClient.ResponseHeaders;
end;

function TResponseFpHTTPClient.StreamResult: TStringStream;
begin
  Result := FStreamResult;
end;

function TResponseFpHTTPClient.ContentEncoding: string;
begin
  Result := FFPHTTPClient.GetHeader('Content-Encoding');
end;

function TResponseFpHTTPClient.ContentLength: Cardinal;
begin
  Result := StrToInt( FFPHTTPClient.GetHeader('Content-Length') );
end;

function TResponseFpHTTPClient.ContentStream: TStream;
begin
  Result := FStreamResult;
  Result.Position := 0;
end;

function TResponseFpHTTPClient.ContentType: string;
begin
  Result := FFPHTTPClient.GetHeader('Content-Type');
end;

constructor TResponseFpHTTPClient.Create(const AFPHTTPClient: TFPHTTPClient);
begin
  FFPHTTPClient := AFPHTTPClient;
  FStreamResult := TStringStream.Create;
end;

destructor TResponseFpHTTPClient.Destroy;
begin
  FreeAndNil(FStreamResult);
  inherited;
end;

function TResponseFpHTTPClient.StatusCode: Integer;
begin
  Result := FFPHTTPClient.ResponseStatusCode;
end;

function TResponseFpHTTPClient.StatusText: string;
begin
  Result := FFPHTTPClient.ResponseStatusText;
end;

end.


