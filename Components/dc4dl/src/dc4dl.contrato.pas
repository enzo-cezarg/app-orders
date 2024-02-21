unit dc4dl.contrato;

{$IFDEF FPC}
{$MODE Delphi}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  SysUtils,
  DB,
  {$ELSE}
  System.SysUtils,
  Data.DB,
  {$ENDIF}
  j4dl;

type
  EDataSetConverterException = class(Exception);
  TDataSetFieldType = (dfUnknown, dfJSONObject, dfJSONArray);
  IDataSetConverter = interface
    ['{8D995E50-A1DC-4426-A603-762E1387E691}']
    function Source(aDataSet: TDataSet): IDataSetConverter;
    function ToJSONObject: TJsonObject;
    function ToJSONArray: TJsonArray;
    function ToJSONStructure: TJsonArray;
  end;
  IJsonConverter = interface
    ['{1B020937-438E-483F-ACB1-44B8B2707500}']
    function Source(aJson: TJsonObject): IJsonConverter; overload;
    function Source(aJson: TJsonArray): IJsonConverter; overload;
    function Source(aJson: string): IJsonConverter; overload;
    procedure ToDataSet(aDataSet: TDataSet);
    procedure ToRecord(aDataSet: TDataSet);
    procedure ToStructure(aDataSet: TDataSet);
  end;
  IConverter = interface
    ['{52A3BE1E-5116-4A9A-A7B6-3AF0FCEB1D8E}']
    function LoadDataSet: IDataSetConverter; overload;
    function LoadDataSet(aDataSet: TDataSet): IDataSetConverter; overload;
    function LoadJson: IJsonConverter; overload;
    function LoadJson(aJson: TJsonObject): IJsonConverter; overload;
    function LoadJson(aJson: TJsonArray): IJsonConverter; overload;
    function LoadJson(aJsonStr: string): IJsonConverter; overload;
  end;

implementation

end.
