unit dc4dl.util;

{$IFDEF FPC}
{$MODE Delphi}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  SysUtils,
  DateUtils,
  DB,
  {$ELSE}
  System.SysUtils,
  System.DateUtils,
  Data.DB,
  {$ENDIF}
  dc4dl.contrato;

const
  _CAMEL_CASE = False;
  _DATE_TIME_ISO = True;

type
  TDC4DUtil = class
  public
    class function ToLowerCamelCase(const aValue: string): string;
    class function DateTimeToISOTimeStamp(const aDateTime: TDateTime): string;
    class function DateToISODate(const aDate: TDateTime): string;
    class function TimeToISOTime(const aTime: TTime): string;
    class function ISOTimeStampToDateTime(const aDateTime: string): TDateTime;
    class function ISODateToDate(const aDate: string): TDate;
    class function ISOTimeToTime(const aTime: string): TTime;
    class function NewDataSetField(aDataSet: TDataSet;
                                   const aFieldType: TFieldType;
                                   const aFieldName: string;
                                   const aSize: Integer = 0;
                                   const aOrigin: string = '';
                                   const aDisplaylabel: string = ''): TField;

    {$IFNDEF FPC}
    class function DataSetFieldToType(const aDataSetField: TDataSetField): TDataSetFieldType;
    {$ENDIF}
    class function MakeValidIdent(const aValue: string): string;
  end;

implementation

{ TDC4DUtil }

class function TDC4DUtil.DateTimeToISOTimeStamp(const aDateTime: TDateTime): string;
var
  lFormat: TFormatSettings;
begin
  if _DATE_TIME_ISO then
  begin
    Result := DateToISO8601(aDateTime);
  end
  else
  begin
    {$ifdef fpc}
    lFormat := DefaultFormatSettings;
    {$else}
    lFormat.TimeSeparator := ':';
    {$endif}
    Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', aDateTime, lFormat);
  end;
end;

class function TDC4DUtil.DateToISODate(const aDate: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD', aDate);
end;

class function TDC4DUtil.TimeToISOTime(const aTime: TTime): string;
var
  lFormat: TFormatSettings;
begin
  lFormat.TimeSeparator := ':';
  Result := FormatDateTime('hh:nn:ss', aTime, lFormat);
end;

class function TDC4DUtil.ToLowerCamelCase(const aValue: string): string;
var
  I: Integer;
  lValue: TArray<Char>;
begin
  Result := EmptyStr;
  if not _CAMEL_CASE then
    Exit(aValue.ToLower);

  lValue := aValue.ToCharArray;
  I := Low(lValue);

  While I <= High(lValue) do
  begin
    if (lValue[I] = '_') then
    begin
      Inc(I);
      Result := Result + UpperCase(lValue[I]);
    end
    else
      Result := Result + LowerCase(lValue[I]);

    Inc(I);
  end;

  if Result.IsEmpty then
    Result := aValue;
end;

class function TDC4DUtil.ISOTimeStampToDateTime(const aDateTime: string): TDateTime;
begin
  if _DATE_TIME_ISO then
    Result := ISO8601ToDate(aDateTime)
  else
    Result := EncodeDateTime(StrToInt(Copy(aDateTime, 1, 4)),
                             StrToInt(Copy(aDateTime, 6, 2)),
                             StrToInt(Copy(aDateTime, 9, 2)),
                             StrToInt(Copy(aDateTime, 12, 2)),
                             StrToInt(Copy(aDateTime, 15, 2)),
                             StrToInt(Copy(aDateTime, 18, 2)),
                             0);
end;

class function TDC4DUtil.ISODateToDate(const aDate: string): TDate;
begin
  Result := EncodeDate(StrToInt(Copy(aDate, 1, 4)),
                       StrToInt(Copy(aDate, 6, 2)),
                       StrToInt(Copy(aDate, 9, 2)));
end;

class function TDC4DUtil.ISOTimeToTime(const aTime: string): TTime;
begin
  Result := EncodeTime(StrToInt(Copy(aTime, 1, 2)),
                       StrToInt(Copy(aTime, 4, 2)),
                       StrToInt(Copy(aTime, 7, 2)),
                       0);
end;

class function TDC4DUtil.NewDataSetField(aDataSet: TDataSet;
                                         const aFieldType: TFieldType;
                                         const aFieldName: string;
                                         const aSize: Integer = 0;
                                         const aOrigin: string = '';
                                         const aDisplaylabel: string = ''): TField;
begin
  Result := DefaultFieldClasses[aFieldType].Create(aDataSet);
  Result.FieldName := aFieldName;
  if (Result.FieldName = '') then
    Result.FieldName := 'Field' + IntToStr(aDataSet.FieldCount + 1);
  Result.FieldKind := fkData;
  Result.DataSet := aDataSet;
  Result.Name := MakeValidIdent(aDataSet.Name + Result.FieldName);
  Result.Size := aSize;
  Result.Origin := aOrigin;
  if not(aDisplaylabel.IsEmpty) then
    Result.Displaylabel := aDisplaylabel;
  if (aFieldType in [ftString, ftWideString]) and (aSize <= 0) then
    raise EDataSetConverterException.CreateFmt('Size not defined for field "%s".', [aFieldName]);
end;

{$IFNDEF FPC}
class function TDC4DUtil.DataSetFieldToType(const aDataSetField: TDataSetField): TDataSetFieldType;
const
  DESC_DATASET_FIELD_TYPE: array [TDataSetFieldType] of string = ('Unknown', 'JSONObject', 'JSONArray');
var
  index: Integer;
  origin: string;
begin
  Result := dfUnknown;
  origin := Trim(aDataSetField.Origin);
  for index := Ord(Low(TDataSetFieldType)) to Ord(High(TDataSetFieldType)) do
    if (LowerCase(DESC_DATASET_FIELD_TYPE[TDataSetFieldType(index)]) = LowerCase(origin)) then
      Exit(TDataSetFieldType(index));
end;
{$ENDIF}

class function TDC4DUtil.MakeValidIdent(const aValue: string): string;
var
  x: Integer;
  lChar: Char;
begin
  SetLength(Result, Length(aValue));
  x := 0;
  for lChar in aValue do
  begin
    if CharInSet(lChar, ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
    begin
      Inc(x);
      Result[x] := lChar;
    end;
  end;
  SetLength(Result, x);
  if x = 0 then
    Result := '_'
  else if CharInSet(Result[1], ['0'..'9']) then
    Result := '_' + Result;
end;

end.
