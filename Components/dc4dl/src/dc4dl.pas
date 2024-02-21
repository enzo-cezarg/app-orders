unit dc4dl;

{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  {$ifdef fpc}
  SysUtils,
  Classes,
  DateUtils,
  base64,
  TypInfo,
  FmtBcd,
  DB,
  BufDataset,
  {$else}
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.NetEncoding,
  Soap.EncdDecd,
  System.TypInfo,
  Data.SqlTimSt,
  Data.DB,
 {$endif}
  j4dl,
  dc4dl.contrato,
  dc4dl.util;

type
  TDataSetConverter = class(TInterfacedObject, IDataSetConverter)
  private
    FDataSet: TDataSet;
    FJsonObject: TJsonObject;
    FJsonArray: TJsonArray;
  protected
    function GetDataSet: TDataSet;
    function DataSetToJsonObject(aDataSet: TDataSet): TJsonObject;
    function DataSetToJsonArray(aDataSet: TDataSet): TJsonArray;
    function StructureToJson(aDataSet: TDataSet): TJsonArray;
    function Source(aDataSet: TDataSet): IDataSetConverter;
    function ToJSONObject: TJsonObject;
    function ToJSONArray: TJsonArray;
    function ToJSONStructure: TJsonArray;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDataSetConverter; static;
  end;

  TJsonConverter = class(TInterfacedObject, IJsonConverter)
  private
    FJson: TJson;
    FJsonObject: TJsonObject;
    FJsonArray: TJsonArray;
    FIsRecord: Boolean;
  protected
    procedure JSONObjectToDataSet(aJson: TJsonObject;
                                  aDataSet: TDataSet;
                                  const aRecNo: Integer;
                                  const isRecord: Boolean);
    procedure JSONArrayToDataSet(aJson: TJsonArray;
                                 aDataSet: TDataSet;
                                 const isRecord: Boolean);
    procedure JSONToStructure(aJson: TJsonArray;
                              aDataSet: TDataSet);
    function Source(aJson: TJsonObject): IJsonConverter; overload;
    function Source(aJson: TJsonArray): IJsonConverter; overload;
    function Source(aJson: string): IJsonConverter; overload;
    procedure ToDataSet(aDataSet: TDataSet);
    procedure ToRecord(aDataSet: TDataSet);
    procedure ToStructure(aDataSet: TDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IJsonConverter; static;
  end;

  TConverter = class(TInterfacedObject, IConverter)
  private
    { private declarations }
  protected
    function LoadDataSet: IDataSetConverter; overload;
    function LoadDataSet(aDataSet: TDataSet): IDataSetConverter; overload;
    function LoadJson: IJsonConverter; overload;
    function LoadJson(aJson: TJsonObject): IJsonConverter; overload;
    function LoadJson(aJson: TJsonArray): IJsonConverter; overload;
    function LoadJson(aJsonStr: string): IJsonConverter; overload;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IConverter; static;
  end;

implementation

{ TDataSetConverter }

function TDataSetConverter.ToJSONArray: TJsonArray;
begin
  Result := DataSetToJsonArray(GetDataSet);
end;

function TDataSetConverter.ToJSONObject: TJsonObject;
begin
  Result := DataSetToJsonObject(GetDataSet);
end;

constructor TDataSetConverter.Create;
begin
  inherited Create;
  FDataSet := nil;
  FJsonObject := TJsonObject.Create();
  FJsonArray  := TJsonArray.Create();
end;

function TDataSetConverter.DataSetToJsonArray(aDataSet: TDataSet): TJsonArray;
var
  lBookMark: TBookmark;
begin
  FJsonArray.Clear;
  Result := FJsonArray;
  if Assigned(aDataSet) and (not aDataSet.IsEmpty) then
  begin
    lBookMark := aDataSet.BookMark;
    aDataSet.DisableControls;
    try
      aDataSet.First;
      while not aDataSet.Eof do
      begin
        FJsonArray.Put(DataSetToJsonObject(aDataSet));
        aDataSet.Next;
      end;
    finally
      aDataSet.EnableControls;
      if aDataSet.BookmarkValid(lBookMark) then
      begin
        aDataSet.GotoBookmark(lBookMark);
        aDataSet.FreeBookmark(lBookMark);
      end;
    end;
  end;
end;

function TDataSetConverter.DataSetToJsonObject(aDataSet: TDataSet): TJsonObject;
var
  I: Integer;
  lKey: string;
  lNestedDataSet: TDataSet;
  lDsFt: TDataSetFieldType;
  lMemoryStream: TMemoryStream;
  lStringStream: TStringStream;
begin
  FJsonObject.Clear;
  Result := FJsonObject;
  if Assigned(aDataSet) and (not aDataSet.IsEmpty) then
  begin
    for I := 0 to Pred(aDataSet.FieldCount) do
    begin
      if aDataSet.Fields[I].Visible then
      begin
        lKey := TDC4DUtil.ToLowerCamelCase( aDataSet.Fields[I].FieldName );
        case aDataSet.Fields[I].DataType of
          TFieldType.ftBoolean:
              FJsonObject.Put(lKey, aDataSet.Fields[I].AsBoolean);
          TFieldType.ftInteger, TFieldType.ftSmallint{$ifndef fpc}, TFieldType.ftShortint{$endif}:
            FJsonObject.Put(lKey, aDataSet.Fields[I].AsInteger);
          {$ifndef fpc}TFieldType.ftLongWord,{$endif} TFieldType.ftAutoInc:
            begin
              if not aDataSet.Fields[I].IsNull then
                FJsonObject.Put(lKey, aDataSet.Fields[I].AsWideString)
              else
                FJsonObject.Put(lKey, null);
            end;
          TFieldType.ftLargeint:
            FJsonObject.Put(lKey, aDataSet.Fields[I].AsLargeInt);
          ftString, ftWideString, ftMemo, ftWideMemo:
            begin
              if not aDataSet.Fields[I].IsNull then
                FJsonObject.Put(lKey, aDataSet.Fields[I].AsWideString)
              else
                FJsonObject.Put(lKey, null);
            end;
          TFieldType.ftDate:
            begin
              if not aDataSet.Fields[I].IsNull then
                FJsonObject.Put(lKey, TDC4DUtil.DateToISODate(aDataSet.Fields[I].AsDateTime))
              else
                FJsonObject.Put(lKey, null);
            end;
          TFieldType.ftTimeStamp, TFieldType.ftDateTime:
            begin
              if not aDataSet.Fields[I].IsNull then
                FJsonObject.Put(lKey, TDC4DUtil.DateTimeToISOTimeStamp(aDataSet.Fields[I].AsDateTime))
              else
                FJsonObject.Put(lKey, null);
            end;
          TFieldType.ftTime:
            begin
              if not aDataSet.Fields[I].IsNull then
                FJsonObject.Put(lKey, TDC4DUtil.TimeToISOTime(aDataSet.Fields[I].AsDateTime))
              else
                FJsonObject.Put(lKey, null);
            end;
          TFieldType.ftCurrency:
            begin
              if not aDataSet.Fields[I].IsNull then
                FJsonObject.Put(lKey, aDataSet.Fields[I].AsCurrency)
              else
                FJsonObject.Put(lKey, null);
            end;
          TFieldType.ftFloat{$ifndef fpc}, TFieldType.ftSingle{$endif}:
            FJsonObject.Put(lKey, aDataSet.Fields[I].AsFloat);
          {$ifndef fpc}
          TFieldType.ftExtended:
            FJsonObject.Put(lKey, aDataSet.Fields[I].AsExtended);
          {$endif}
          TFieldType.ftFMTBcd, TFieldType.ftBCD:
            FJsonObject.Put(lKey, aDataSet.Fields[I].AsFloat);
          {$ifndef fpc}
          TFieldType.ftDataSet:
            begin
              lDsFt := TDC4DUtil.DataSetFieldToType(TDataSetField(aDataSet.Fields[I]));
              lNestedDataSet := TDataSetField(aDataSet.Fields[I]).NestedDataSet;
              case lDsFt of
                dfJSONObject:
                  FJsonObject.Put(lKey, DataSetToJsonObject(lNestedDataSet));
                dfJSONArray:
                  FJsonObject.Put(lKey, DataSetToJsonArray(lNestedDataSet));
              end;
            end;
          {$endif}
          TFieldType.ftGraphic, TFieldType.ftBlob{$ifndef fpc}, TFieldType.ftStream{$endif}:
            begin
              lMemoryStream := TMemoryStream.Create;
              try
                TBlobField(aDataSet.Fields[I]).SaveToStream( lMemoryStream );
                lMemoryStream.Position := 0;
                lStringStream := TStringStream.Create;
                try
                  {$ifdef fpc}
                  lStringStream.LoadFromStream(lMemoryStream);
                  FJsonObject.Put(lKey, EncodeStringBase64(LStringStream.DataString));
                  {$else}
                  EncodeStream(lMemoryStream, lStringStream);
                  lStringStream.Position := 0;
                  FJsonObject.Put(lKey, lStringStream.DataString);
                  {$endif}
                finally
                  FreeAndNil( lStringStream );
                end;
              finally
                FreeAndNil( lMemoryStream );
              end;
            end;
        else
          raise EDataSetConverterException.CreateFmt('Cannot find type for field "%s"', [lKey]);
        end;
      end;
    end;
  end;
end;

destructor TDataSetConverter.Destroy;
begin
  FreeAndNil(FJsonObject);
  FreeAndNil(FJsonArray);
  inherited Destroy;
end;

function TDataSetConverter.GetDataSet: TDataSet;
begin
  if (FDataSet = nil) then
    raise EDataSetConverterException.Create('DataSet Uninformed.');
  Result := FDataSet;
end;

class function TDataSetConverter.New: IDataSetConverter;
begin
  Result := TDataSetConverter.Create;
end;

function TDataSetConverter.ToJSONStructure: TJsonArray;
begin
  Result := StructureToJson(GetDataSet);
end;

function TDataSetConverter.StructureToJson(aDataSet: TDataSet): TJsonArray;
var
  I: Integer;
begin
  FJsonArray.Clear;
  Result := FJsonArray;
  if Assigned(aDataSet) and (aDataSet.FieldCount > 0) then
  begin
    for I := 0 to Pred(aDataSet.FieldCount) do
    begin
      with FJsonArray.Put(empty).AsObject do
      begin
        put('fieldName', TDC4DUtil.ToLowerCamelCase(aDataSet.Fields[I].FieldName));
        Put('dataType', GetEnumName(TypeInfo(TFieldType), Integer(aDataSet.Fields[I].DataType)));
        Put('size', aDataSet.Fields[I].Size);
      end;
    end;
  end;
end;

function TDataSetConverter.Source(aDataSet: TDataSet): IDataSetConverter;
begin
  FDataSet := aDataSet;
  Result := Self;
end;

{ TJsonConverter }

constructor TJsonConverter.Create;
begin
  inherited Create;
  FIsRecord := False;
end;

destructor TJsonConverter.Destroy;
begin
  if Assigned(FJson) then
    FJson.Free;
  inherited Destroy;
end;

procedure TJsonConverter.JSONArrayToDataSet(aJson: TJsonArray;
                                            aDataSet: TDataSet;
                                            const isRecord: Boolean);
var
  lRecNo: Integer;
  I: Integer;
begin
  if Assigned(aJson) and Assigned(aDataSet) then
  begin
    lRecNo := 0;
    for I := 0 to aJson.Count -1 do
    begin
      if not aDataSet.IsEmpty then
        Inc(lRecNo);
      if ( aJson[I].ValueType = jvArray ) then
        JSONArrayToDataSet(aJson[I].AsArray, aDataSet, isRecord)
      else
        JSONObjectToDataSet(aJson[I].AsObject, aDataSet, lRecNo, isRecord);
    end;
  end;
end;

procedure TJsonConverter.JSONObjectToDataSet(aJson: TJsonObject;
                                             aDataSet: TDataSet;
                                             const aRecNo: Integer;
                                             const isRecord: Boolean);
var
  lField: TField;
  lDsFt: TDataSetFieldType;
  lNestedDataSet: TDataSet;
  lStringStream,
  lTmpStringStream  : TStringStream;
  lMemoryStream: TMemoryStream;
begin
  if Assigned(aJson) and Assigned(aDataSet) then
  begin
    if (aRecNo > 0) and (aDataSet.RecordCount > 1) then
      aDataSet.RecNo := aRecNo;
    if isRecord then
      aDataSet.Edit
    else
      aDataSet.Append;
    for lField in aDataSet.Fields do
    begin
      if lField.ReadOnly then
        Continue;
      case lField.DataType of
        TFieldType.ftBoolean:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsBoolean := aJson.Values[lField.FieldName].AsBoolean;
          end;
        TFieldType.ftInteger, TFieldType.ftSmallint{$ifndef fpc}, TFieldType.ftShortint, TFieldType.ftLongWord{$endif}:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsInteger := aJson.Values[lField.FieldName].AsInteger;
          end;
        TFieldType.ftLargeint, TFieldType.ftAutoInc:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsLargeInt := aJson.Values[lField.FieldName].AsInteger;
          end;
        TFieldType.ftCurrency:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsCurrency := aJson.Values[lField.FieldName].AsNumber;
          end;
        TFieldType.ftFloat,{$IFNDEF FPC}TFieldType.ftExtended,{$ENDIF}
        TFieldType.ftFMTBcd, TFieldType.ftBCD{$IFNDEF FPC}, TFieldType.ftSingle{$ENDIF}:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsFloat := aJson.Values[lField.FieldName].AsNumber;
          end;
        ftString, ftWideString, ftMemo, ftWideMemo:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsString := aJson.Values[lField.FieldName].AsString;
          end;
        TFieldType.ftDate:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsDateTime := TDC4DUtil.ISODateToDate(aJson.Values[lField.FieldName].AsString);
          end;
        TFieldType.ftTimeStamp, TFieldType.ftDateTime:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsDateTime := TDC4DUtil.ISOTimeStampToDateTime(aJson.Values[lField.FieldName].AsString);
          end;
        TFieldType.ftTime:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
              lField.AsDateTime := TDC4DUtil.ISOTimeToTime(aJson.Values[lField.FieldName].AsString);
          end;
        {$IFNDEF FPC}
        TFieldType.ftDataSet:
          begin
            lDsFt := TDC4DUtil.DataSetFieldToType(TDataSetField(lField));
            lNestedDataSet := TDataSetField(lField).NestedDataSet;
            case lDsFt of
              dfJSONObject:
                JSONObjectToDataSet(aJson.Values[lField.FieldName].AsObject, lNestedDataSet, 0, True);
              dfJSONArray:
                begin
                  lNestedDataSet.First;
                  while not lNestedDataSet.Eof do
                    lNestedDataSet.Delete;
                  JSONArrayToDataSet(aJson.Values[lField.FieldName].AsArray, lNestedDataSet, False);
                end;
            end;
          end;
        {$ENDIF}
        TFieldType.ftGraphic, TFieldType.ftBlob{$IFNDEF FPC}, TFieldType.ftStream{$ENDIF}:
          begin
            if aJson.Values[lField.FieldName].IsNull then
              lField.Clear
            else
            begin
              lStringStream := TStringStream.Create(aJson.Values[lField.FieldName].AsString); //, TEncoding.ASCII);
              try
                lStringStream.Position := 0;
                {$IFDEF FPC}
                TBlobField(lField).AsString := DecodeStringBase64(lStringStream.DataString);
                {$ELSE}
                lMemoryStream := TMemoryStream.Create;
                try
                  //TNetEncoding.Base64.Decode(lStringStream, lMemoryStream);
                  DecodeStream(lStringStream, lMemoryStream);
                  lMemoryStream.Position := 0;
                  TBlobField(lField).LoadFromStream(lMemoryStream);
                finally
                  lMemoryStream.Free;
                end;
                {$ENDIF}
              finally
                lStringStream.Free;
              end;
            end;
          end;
      else
        raise EDataSetConverterException.CreateFmt('Cannot find type for field "%s"', [lField.FieldName]);
      end;
    end;
    aDataSet.Post;
  end;
end;

procedure TJsonConverter.JSONToStructure(aJson: TJsonArray;
                                         aDataSet: TDataSet);
var
  I: Integer;
begin
  if Assigned(aJson) and Assigned(aDataSet) then
  begin
    if not (aJson.Count > 0) then
      raise EDataSetConverterException.Create('The JSON is Empty.');
    if aDataSet.Active then
      raise EDataSetConverterException.Create('The DataSet can not be active.');
    if (aDataSet.FieldCount > 0) then
      raise EDataSetConverterException.Create('The DataSet can not have predefined Fields.');
    for I := 0 to aJson.Count -1 do
    begin
      TDC4DUtil.NewDataSetField(aDataSet,
        TFieldType(GetEnumValue(TypeInfo(TFieldType), aJson[I].AsObject.Values['dataType'].AsString)),
        aJson[I].AsObject.Values['fieldName'].AsString,
        aJson[I].AsObject.Values['size'].AsInteger
        );
    end;
  end;
end;

class function TJsonConverter.New: IJsonConverter;
begin
  Result := TJsonConverter.Create;
end;

function TJsonConverter.Source(aJson: string): IJsonConverter;
begin
  Result := Self;

  if aJson.IsEmpty then
    raise Exception.Create('JSON string Uninformed.');

  FJson := TJson.Create;
  FJson.Parse(aJson);

  if FJson.IsJsonObject(aJson) then
    FJsonObject := FJson.JsonObject;

  if FJson.IsJsonArray(aJson) then
    FJsonArray := FJson.JsonArray;
end;

function TJsonConverter.Source(aJson: TJsonObject): IJsonConverter;
begin
  Result := Self;
  FJsonObject := aJson;
end;

function TJsonConverter.Source(aJson: TJsonArray): IJsonConverter;
begin
  Result := Self;
  FJsonArray := aJson;
end;

procedure TJsonConverter.ToDataSet(aDataSet: TDataSet);
var
  lOk: Boolean;
begin
  if not (aDataSet.FieldDefs.Count > 0) and
     not (aDataSet.Fields.Count > 0) then
    raise EDataSetConverterException.Create('DataSet without Fields.');
  if not aDataSet.Active then
  begin
    {$ifdef fpc}
    if aDataSet is TBufDataset then
    begin
      if (TBufDataset(aDataSet).FieldDefs.Count > 0) then
        TBufDataset(aDataSet).FieldDefs.Clear;
      TBufDataset(aDataSet).CreateDataset;
    end;
    {$endif}

    aDataSet.Open;
  end;
  aDataSet.DisableControls;
  try
    if Assigned(FJsonObject) then
      JSONObjectToDataSet(FJsonObject, aDataSet, 0, FIsRecord)
    else if Assigned(FJsonArray) then
      JSONArrayToDataSet(FJsonArray, aDataSet, FIsRecord)
    else
      raise EDataSetConverterException.Create('JSON Value Uninformed.');
  finally
    aDataSet.EnableControls;
  end;
end;

procedure TJsonConverter.ToRecord(aDataSet: TDataSet);
begin
  FIsRecord := True;
  try
    ToDataSet(aDataSet);
  finally
    FIsRecord := False;
  end;
end;

procedure TJsonConverter.ToStructure(aDataSet: TDataSet);
begin
  if Assigned(FJsonObject) then
    raise EDataSetConverterException.Create('To convert a structure only JSONArray is allowed.')
  else if Assigned(FJsonArray) then
  begin
    if aDataSet.Active then
      aDataSet.Close;
    if (aDataSet.FieldCount > 0) then
      aDataSet.Fields.Clear;
    if (aDataSet.FieldDefs.Count > 0) then
      aDataSet.FieldDefs.Clear;

    JSONToStructure(FJsonArray, aDataSet);
  end
  else
    raise EDataSetConverterException.Create('JSON Value Uninformed.');
end;

{ TConverter }

function TConverter.LoadDataSet: IDataSetConverter;
begin
  Result := TDataSetConverter.New;
end;

function TConverter.LoadDataSet(aDataSet: TDataSet): IDataSetConverter;
begin
  Result := Self.LoadDataSet.Source(aDataSet);
end;

constructor TConverter.Create;
begin

end;

destructor TConverter.Destroy;
begin
  inherited;
end;

function TConverter.LoadJson(aJson: TJsonObject): IJsonConverter;
begin
  Result := Self.LoadJson.Source(aJson);
end;

function TConverter.LoadJson: IJsonConverter;
begin
  Result := TJsonConverter.New;
end;

function TConverter.LoadJson(aJson: TJsonArray): IJsonConverter;
begin
  Result := Self.LoadJson.Source(aJson);
end;

class function TConverter.New: IConverter;
begin
  Result := TConverter.Create;
end;

function TConverter.LoadJson(aJsonStr: string): IJsonConverter;
begin
  Result := Self.LoadJson.Source(aJsonStr);
end;

end.
