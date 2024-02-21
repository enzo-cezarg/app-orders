unit rr4dl.Request.FPHTTPClient;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}

interface

uses Classes, SysUtils, rr4dl.Request.Contract, rr4dl.Response.Contract,
    fphttpclient, openssl, opensslsockets;

type
  TRequestFPHTTPClient = class(TInterfacedObject, IRequest)
  private
    FHeaders: TStrings;
    FParams: TStrings;
    FUrlSegments: TStrings;
    FFPHTTPClient: TFPHTTPClient;
    FBaseURL: string;
    FResource: string;
    FResourceSuffix: string;
    FResponse: IResponse;
    FStreamSend: TStream;
    FStreamResult: TStringStream;
    function AcceptEncoding: string; overload;
    function AcceptEncoding(const AAcceptEncoding: string): IRequest; overload;
    function AcceptCharset: string; overload;
    function AcceptCharset(const AAcceptCharset: string): IRequest; overload;
    function Accept: string; overload;
    function Accept(const AAccept: string): IRequest; overload;
    function Timeout: Integer; overload;
    function Timeout(const ATimeout: Integer): IRequest; overload;
    function BaseURL(const ABaseURL: string): IRequest; overload;
    function BaseURL: string; overload;
    function Resource(const AResource: string): IRequest; overload;
    function RaiseExceptionOn500: Boolean; overload;
    function RaiseExceptionOn500(const ARaiseException: Boolean): IRequest; overload;
    function Resource: string; overload;
    function ResourceSuffix(const AResourceSuffix: string): IRequest; overload;
    function ResourceSuffix: string; overload;
    function Token(const AToken: string): IRequest;
    function BasicAuthentication(const AUsername, APassword: string): IRequest;
    function Get: IResponse;
    function Post: IResponse;
    function Put: IResponse;
    function Delete: IResponse;
    function Patch: IResponse;
    function FullRequestURL(const AIncludeParams: Boolean = True): string;
    function ClearBody: IRequest;
    function AddBody(const AContent: string): IRequest; overload;
    function AddBody(const AContent: TStream; const AOwns: Boolean = False): IRequest; overload;
    function AddUrlSegment(const AName, AValue: string): IRequest;
    function ClearHeaders: IRequest;
    function AddHeader(const AName, AValue: string): IRequest;
    function ClearParams: IRequest;
    function ContentType(const AContentType: string): IRequest;
    function UserAgent(const AName: string): IRequest;
    function AddCookies(const ACookies: TStrings): IRequest;
    function AddParam(const AName, AValue: string): IRequest;
    function AddFile(const AName: string; const AValue: TStream): IRequest;
    function MakeURL(const AIncludeParams: Boolean = True): string;
    function Proxy(const AServer, APassword, AUsername: string; const APort: Integer): IRequest;
    function DeactivateProxy: IRequest;
  protected

  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses rr4dl.Response.FPHTTPClient;

function TRequestFPHTTPClient.AddFile(const AName: string; const AValue: TStream): IRequest;
begin
  Result := Self;
  if (AValue <> Nil) and (AValue.Size > 0) then
  begin
    Self.AddHeader('x-filename', AName);
    AValue.Position := 0;
    FStreamResult.LoadFromStream(AValue);
  end;
end;

function TRequestFPHTTPClient.AddBody(const AContent: TStream; const AOwns: Boolean): IRequest;
begin
  Result := Self;
  try
    if not Assigned(FStreamSend) then
      FStreamSend := TStringStream.Create;
    TStringStream(FStreamSend).CopyFrom(AContent, AContent.Size);
    FStreamSend.Position := 0;
  finally
    if AOwns then
      AContent.Free;
  end;
end;

function TRequestFPHTTPClient.AddCookies(const ACookies: TStrings): IRequest;
//var
//  LURI: TIdURI;
begin
  Result := Self;
  //LURI := TIdURI.Create(MakeURL(False));
  //try
  //  if not Assigned(FIdHTTP.CookieManager) then
  //    FIdHTTP.CookieManager := TIdCookieManager.Create(FIdHTTP);
  //  FIdHTTP.CookieManager.AddServerCookies(ACookies, LURI);
  //finally
  //  ACookies.Free;
  //  LURI.Free;
  //end;
end;

function TRequestFPHTTPClient.RaiseExceptionOn500: Boolean;
begin
  Result := False;
end;

function TRequestFPHTTPClient.RaiseExceptionOn500(const ARaiseException: Boolean): IRequest;
begin
  Result := Self;
  //if ARaiseException then
  //  FIdHTTP.HTTPOptions := FIdHTTP.HTTPOptions - [hoNoProtocolErrorException]
  //else
  //  FIdHTTP.HTTPOptions := FIdHTTP.HTTPOptions + [hoNoProtocolErrorException];
end;

function TRequestFPHTTPClient.Patch: IResponse;
begin
  Result := FResponse;
  //FFPHTTPClient.RequestBody := FStreamSend;
  //FFPHTTPClient.Patch;

  //FIdHTTP.Patch(TIdURI.URLEncode(MakeURL), FStreamSend, FStreamResult);
  //Self.DoAfterExecute;
end;

function TRequestFPHTTPClient.Put: IResponse;
begin
  Result := FResponse;
  FFPHTTPClient.RequestBody := FStreamSend;
  FFPHTTPClient.Put(MakeURL, FStreamResult);
end;

function TRequestFPHTTPClient.Post: IResponse;
begin
  Result := FResponse;
  FFPHTTPClient.RequestBody := FStreamSend;
  FFPHTTPClient.Post(MakeURL, FStreamResult);
end;

function TRequestFPHTTPClient.Proxy(const AServer, APassword, AUsername: string; const APort: Integer): IRequest;
begin
  Result := Self;
  //FIdHTTP.ProxyParams.ProxyServer := AServer;
  //FIdHTTP.ProxyParams.ProxyPassword := APassword;
  //FIdHTTP.ProxyParams.ProxyUsername := AUsername;
  //FIdHTTP.ProxyParams.ProxyPort := APort;
end;

function TRequestFPHTTPClient.Get: IResponse;
begin
  Result := FResponse;
  FFPHTTPClient.Get(MakeURL, FStreamResult);
end;

function TRequestFPHTTPClient.DeactivateProxy: IRequest;
begin
  Result := Self;
  //FIdHTTP.ProxyParams.ProxyServer := EmptyStr;
  //FIdHTTP.ProxyParams.ProxyPassword := EmptyStr;
  //FIdHTTP.ProxyParams.ProxyUsername := EmptyStr;
  //FIdHTTP.ProxyParams.ProxyPort := 0;
end;

function TRequestFPHTTPClient.Delete: IResponse;
begin
  Result := FResponse;
  FFPHTTPClient.Delete(MakeURL, FStreamResult);
end;

function TRequestFPHTTPClient.AddBody(const AContent: string): IRequest;
begin
  Result := Self;
  if not Assigned(FStreamSend) then
    FStreamSend := TStringStream.Create(AContent, TEncoding.UTF8)
  else
    TStringStream(FStreamSend).WriteString(AContent);
  FStreamSend.Position := 0;
end;

function TRequestFPHTTPClient.AddHeader(const AName, AValue: string): IRequest;
begin
  Result := Self;
  if AName.Trim.IsEmpty or AValue.Trim.IsEmpty then
    Exit;
  if FHeaders.IndexOf(AName) < 0 then
    FHeaders.Add(AName);

  FFPHTTPClient.AddHeader(AName, AValue);
end;

function TRequestFPHTTPClient.Token(const AToken: string): IRequest;
begin
  Result := Self;
  Self.AddHeader('Authorization', AToken);
end;

function TRequestFPHTTPClient.FullRequestURL(const AIncludeParams: Boolean): string;
begin
  Result := Self.MakeURL(AIncludeParams);
end;

function TRequestFPHTTPClient.MakeURL(const AIncludeParams: Boolean): string;
var
  I: Integer;
begin
  Result := FBaseURL;
  if not FResource.Trim.IsEmpty then
  begin
    if not Result.EndsWith('/') then
      Result := Result + '/';
    Result := Result + FResource;
  end;
  if not FResourceSuffix.Trim.IsEmpty then
  begin
    if not Result.EndsWith('/') then
      Result := Result + '/';
    Result := Result + FResourceSuffix;
  end;
  if FUrlSegments.Count > 0 then
  begin
    for I := 0 to Pred(FUrlSegments.Count) do
    begin
      Result := StringReplace(Result, Format('{%s}', [FUrlSegments.Names[I]]), FUrlSegments.ValueFromIndex[I], [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, Format(':%s', [FUrlSegments.Names[I]]), FUrlSegments.ValueFromIndex[I], [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
  if not AIncludeParams then
    Exit;
  if FParams.Count > 0 then
  begin
    Result := Result + '?';
    for I := 0 to Pred(FParams.Count) do
    begin
      if I > 0 then
        Result := Result + '&';
      Result := Result + FParams.Strings[I];
    end;
  end;
end;

function TRequestFPHTTPClient.AddParam(const AName, AValue: string): IRequest;
begin
  Result := Self;
  if (not AName.Trim.IsEmpty) and (not AValue.Trim.IsEmpty) then
    FParams.Add(AName + '=' + AValue);
end;

function TRequestFPHTTPClient.AddUrlSegment(const AName, AValue: string): IRequest;
begin
  Result := Self;
  if AName.Trim.IsEmpty or AValue.Trim.IsEmpty then
    Exit;
  if FUrlSegments.IndexOf(AName) < 0 then
    FUrlSegments.Add(Format('%s=%s', [AName, AValue]));
end;

function TRequestFPHTTPClient.ClearParams: IRequest;
begin
  Result := Self;
  FParams.Clear;
end;

function TRequestFPHTTPClient.ContentType(const AContentType: string): IRequest;
begin
  Result := Self;
  Self.AddHeader('Content-Type', AContentType);
end;

function TRequestFPHTTPClient.ClearBody: IRequest;
begin
  Result := Self;
  if Assigned(FStreamSend) then
    FreeAndNil(FStreamSend);
end;

function TRequestFPHTTPClient.ClearHeaders: IRequest;
var
  I: Integer;
begin
  Result := Self;
  FFPHTTPClient.RequestHeaders.Clear;
end;

function TRequestFPHTTPClient.Accept: string;
begin
  Result := FFPHTTPClient.GetHeader('Accept');
end;

function TRequestFPHTTPClient.Accept(const AAccept: string): IRequest;
begin
  Result := Self;
  FFPHTTPClient.AddHeader('Accept', AAccept);
end;

function TRequestFPHTTPClient.AcceptCharset(const AAcceptCharset: string): IRequest;
begin
  Result := Self;
  FFPHTTPClient.AddHeader('Accept-Charset', AAcceptCharset);
end;

function TRequestFPHTTPClient.AcceptCharset: string;
begin
  Result := FFPHTTPClient.GetHeader('Accept-Charset');
end;

function TRequestFPHTTPClient.AcceptEncoding(const AAcceptEncoding: string): IRequest;
begin
  Result := Self;
  FFPHTTPClient.AddHeader('Accept-Encoding', AAcceptEncoding);
end;

function TRequestFPHTTPClient.AcceptEncoding: string;
begin
  Result := FFPHTTPClient.GetHeader('Accept-Encoding');
end;

function TRequestFPHTTPClient.BaseURL: string;
begin
  Result := FBaseURL;
end;

function TRequestFPHTTPClient.BaseURL(const ABaseURL: string): IRequest;
begin
  Result := Self;
  FBaseURL := ABaseURL;
end;

function TRequestFPHTTPClient.BasicAuthentication(const AUsername, APassword: string): IRequest;
begin
  Result := Self;
  FFPHTTPClient.UserName := AUsername;
  FFPHTTPClient.Password := APassword;
end;

constructor TRequestFPHTTPClient.Create;
begin
  FFPHTTPClient := TFPHTTPClient.Create(nil);
  FFPHTTPClient.KeepConnection := True;
  FFPHTTPClient.AddHeader('User-Agent','Mozilla/5.0 (compatible; fpweb)');
  FFPHTTPClient.AllowRedirect := True;

  FHeaders     := TStringList.Create;
  FResponse    := TResponseFpHTTPClient.Create(FFPHTTPClient);
  FParams      := TStringList.Create;
  FUrlSegments := TStringList.Create;

  FStreamResult := FResponse.StreamResult;
end;

destructor TRequestFPHTTPClient.Destroy;
begin
  if Assigned(FStreamSend) then
    FreeAndNil(FStreamSend);
  FreeAndNil(FHeaders);
  FreeAndNil(FParams);
  FreeAndNil(FUrlSegments);
  FreeAndNil(FFPHTTPClient);
  inherited Destroy;
end;

function TRequestFPHTTPClient.Resource: string;
begin
  Result := FResource;
end;

function TRequestFPHTTPClient.Resource(const AResource: string): IRequest;
begin
  Result := Self;
  FResource := AResource;
end;

function TRequestFPHTTPClient.ResourceSuffix(const AResourceSuffix: string): IRequest;
begin
  Result := Self;
  FResourceSuffix := AResourceSuffix;
end;

function TRequestFPHTTPClient.ResourceSuffix: string;
begin
  Result := FResourceSuffix;
end;

function TRequestFPHTTPClient.Timeout: Integer;
begin
  Result := FFPHTTPClient.ConnectTimeout;
end;

function TRequestFPHTTPClient.Timeout(const ATimeout: Integer): IRequest;
begin
  Result := Self;
  FFPHTTPClient.ConnectTimeout := ATimeout;
end;

function TRequestFPHTTPClient.UserAgent(const AName: string): IRequest;
begin
  Result := Self;
  FFPHTTPClient.AddHeader('User-Agent', AName);
end;

end.


