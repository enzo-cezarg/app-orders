unit ufrminsert;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, Menus, MaskEdit, j4dl, rr4dl, dc4dl, udmconexao, rxctrls,
  rxlookup, rxdbcomb;

type

  { TFrmInsert }

  TFrmInsert = class(TForm)
    btnSendInsert: TButton;
    bdsCrudPessoas: TBufDataset;
    btnConsultaU: TButton;
    btnSendU: TButton;
    bdsCrudDetails: TBufDataset;
    c_edtEmail: TEdit;
    c_lblTelF: TLabel;
    c_lblTelC: TLabel;
    c_lblObs: TLabel;
    c_lblEmail: TLabel;
    c_edtTelFU: TEdit;
    fo_edtEmailU: TEdit;
    c_edtTelCU: TEdit;
    c_edtEmailU: TEdit;
    fu_edtUserU: TEdit;
    fu_edtSenhaU: TEdit;
    fu_edtEmailU: TEdit;
    fu_edtComU: TEdit;
    fo_edtTelFU: TEdit;
    fo_edtWebsiteU: TEdit;
    fu_edtUser: TEdit;
    fu_edtSenha: TEdit;
    fu_edtEmail: TEdit;
    fu_edtCom: TEdit;
    fo_edtTelF: TEdit;
    fo_edtWebsite: TEdit;
    fo_edtEmail: TEdit;
    fu_lblUser: TLabel;
    fu_lblEmail: TLabel;
    fu_lblSenha: TLabel;
    fu_lblCom: TLabel;
    fo_lblTelF: TLabel;
    fo_lblObs: TLabel;
    fo_lblEmail: TLabel;
    fo_lblWebsite: TLabel;
    c_lblTelFU: TLabel;
    fo_lblObsU: TLabel;
    fo_lblEmailU: TLabel;
    fo_lblWebsiteU: TLabel;
    c_lblObsU: TLabel;
    c_lblEmailU: TLabel;
    c_lblTelCU: TLabel;
    fu_lblUserU: TLabel;
    fu_lblEmailU: TLabel;
    fu_lblSenhaU: TLabel;
    fu_lblComU: TLabel;
    fo_lblTelFU: TLabel;
    lblDetails: TLabel;
    c_mEdtTelF: TMaskEdit;
    c_mEdtTelC: TMaskEdit;
    mEdtCpfCnpj: TMaskEdit;
    detailsTipo: TPageControl;
    c_mmObs: TMemo;
    fo_mmObs: TMemo;
    detailsTipoU: TPageControl;
    c_mmObsU: TMemo;
    fo_mmObsU: TMemo;
    selectTpFunU: TRxRadioGroup;
    selectTpFun: TRxRadioGroup;
    selectTpCad: TRxRadioGroup;
    selectTp: TRxRadioGroup;
    edtID: TEdit;
    edtUFU: TEdit;
    edtNomeU: TEdit;
    edtApelidoU: TEdit;
    edtCpfCnpjU: TEdit;
    edtLogU: TEdit;
    edtNumU: TEdit;
    edtBairroU: TEdit;
    edtCepU: TEdit;
    edtMunU: TEdit;
    edtNome: TEdit;
    edtApelido: TEdit;
    edtLog: TEdit;
    edtNum: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    edtMun: TEdit;
    edtUF: TEdit;
    lblApelidoU: TLabel;
    lblCpfCnpjU: TLabel;
    lblLogU: TLabel;
    lblNumU: TLabel;
    lblBairroU: TLabel;
    lblCepU: TLabel;
    lblMunU: TLabel;
    lblUFU: TLabel;
    lblNomeU: TLabel;
    lblID: TLabel;
    lblNome: TLabel;
    lblApelido: TLabel;
    lblCpfCnpj: TLabel;
    lblLog: TLabel;
    lblNumero: TLabel;
    lblBairro: TLabel;
    lblCep: TLabel;
    lblMun: TLabel;
    lblUF: TLabel;
    lblEndereco: TLabel;
    lblDadosP: TLabel;
    pgcSelectOp: TPageControl;
    pgInsert: TTabSheet;
    pgUpdate: TTabSheet;
    tabCliente: TTabSheet;
    tabFuncionario: TTabSheet;
    tabFornecedor: TTabSheet;
    tabClienteU: TTabSheet;
    tabFuncionarioU: TTabSheet;
    tabFornecedorU: TTabSheet;
    procedure btnConsultaUClick(Sender: TObject);
    procedure btnSendInsertClick(Sender: TObject);
    procedure btnSendUClick(Sender: TObject);
    procedure detailsTipoChanging(Sender: TObject; var AllowChange: Boolean);
    procedure detailsTipoUChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mEdtCpfCnpjMouseEnter(Sender: TObject);
    procedure pgcSelectOpChange(Sender: TObject);
    procedure selectTpCadSelectionChanged(Sender: TObject);
    procedure selectTpClick(Sender: TObject);
  private
    procedure getStructure;
    procedure getDetailStructure(aTpPessoa: integer);
    procedure datasetToView;
    procedure detailDatasetToView(aTpPessoa: integer);
    procedure viewToDataset;
    procedure detailViewToDataset(aID, aTpPessoa: integer);
    function confirmOperation: Boolean;
    procedure onSave(aID: string);
    procedure onSaveDetail(aID: string);
    procedure onAppend(aID: string);
    procedure clearUpdateFields;
    procedure clearAll;
    procedure checkTpCad;
  public

  end;

var
  FrmInsert: TFrmInsert;
  _MSG_OPERATION: string;
  _UPDATE_ID: string;

const

  // Definições do formulário
  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 750;
  _FORM_HEIGHT = 600;

implementation

{$R *.lfm}

{ TFrmInsert }

procedure TFrmInsert.FormCreate(Sender: TObject);
begin
  FrmInsert.BorderStyle := _FORM_BORDER_STYLE;
  FrmInsert.Width       := _FORM_WIDTH;
  FrmInsert.Height      := _FORM_HEIGHT;

end;

procedure TFrmInsert.mEdtCpfCnpjMouseEnter(Sender: TObject);
begin
  if not mEdtCpfCnpj.Enabled then
    mEdtCpfCnpj.ShowHint := True
  else
    mEdtCpfCnpj.ShowHint := False;
end;

procedure TFrmInsert.FormActivate(Sender: TObject);
begin
  getStructure;
  datasetToView;
  selectTp.ItemIndex := -1;
end;

procedure TFrmInsert.btnSendInsertClick(Sender: TObject);
begin
  viewToDataset;
  if confirmOperation then
  begin
    onSave('0');

    detailViewToDataSet(DM.GetLastID, bdsCrudPessoas.FieldByName('tipo_pessoa').AsInteger);
    onSaveDetail('0');

    ShowMessage(_MSG_OPERATION);
  end
  else
    ShowMessage('Operação cancelada!');
end;

procedure TFrmInsert.btnConsultaUClick(Sender: TObject);
var
  DM: TDM;
  lTpPessoa: Integer;
begin
  try
    DM := TDM.Create(nil);
    if DM.isExist(StrToInt(edtID.Text)) then
    begin
      onAppend(edtID.Text);
      lTpPessoa := DM.GetTpPessoa(StrToInt(edtID.Text));
      detailsTipoU.Enabled := True;
      detailsTipoU.PageIndex := lTpPessoa;
      datasetToView;
    end
    else
    begin
      clearUpdateFields;
      ShowMessage('ID Inválido!');
    end;
  finally
    FreeAndNil(DM);
  end;

end;

procedure TFrmInsert.btnSendUClick(Sender: TObject);
begin
  viewToDataset;
  if confirmOperation then
  begin
    onSave(edtID.Text);
    ShowMessage(_MSG_OPERATION);
  end
  else
    ShowMessage('Operação cancelada!');
end;

procedure TFrmInsert.detailsTipoChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := False;
end;

procedure TFrmInsert.detailsTipoUChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := False;
end;

procedure TFrmInsert.pgcSelectOpChange(Sender: TObject);
begin

  if selectTp.ItemIndex = -1 then
    detailsTipo.Enabled := False;

  case pgcSelectOp.PageIndex of
    0:
    begin
      mEdtCpfCnpj.EditMask := '';
      datasetToView;
      selectTpCad.ItemIndex := -1;
      selectTp.ItemIndex := -1;
      clearAll;
    end;
    1:
    begin
      mEdtCpfCnpj.EditMask := '';
      datasetToView;
      selectTpCad.ItemIndex := -1;
      selectTp.ItemIndex := -1;
      clearAll;
    end;
  end;
end;

procedure TFrmInsert.selectTpCadSelectionChanged(Sender: TObject);
begin
  checkTpCad;
end;

procedure TFrmInsert.selectTpClick(Sender: TObject);
begin
  detailsTipo.Enabled := True;
  case selectTp.ItemIndex of
    0:
    begin
      detailsTipo.Page[0].Enabled := True;
      detailsTipo.ActivePageIndex := 0;
      detailsTipo.Page[1].Enabled := False;
      detailsTipo.Page[2].Enabled := False;

      getDetailStructure(0);
    end;
    1:
    begin
      detailsTipo.Page[1].Enabled := True;
      detailsTipo.ActivePageIndex := 1;
      detailsTipo.Page[0].Enabled := False;
      detailsTipo.Page[2].Enabled := False;

      getDetailStructure(1);
    end;
    2:
    begin
      detailsTipo.Page[2].Enabled := True;
      detailsTipo.ActivePageIndex := 2;
      detailsTipo.Page[0].Enabled := False;
      detailsTipo.Page[1].Enabled := False;

      getDetailStructure(2);
    end;
  end;
end;

procedure TFrmInsert.getStructure;
var
  lJson: TJSONObject;
  lRes: IResponse;
begin
  try
    lJson := TJSONObject.Create;
    try
      lRes := TRequest.New.BaseURL('http://localhost:9095/pessoa/structure')
                          .ContentType('application/json')
                          .Get;

      if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
      begin
        if not lJson.IsJsonObject(lRes.Content) then
          Raise exception.Create('JSON Invalido!');

        lJson.Parse(lRes.Content);

        if lJson.Values['success'].AsBoolean then
        begin
          bdsCrudPessoas.Close;
          TConverter.New.LoadJson(lJson.Values['structure'].AsArray).ToStructure(bdsCrudPessoas);
          TConverter.New.LoadJson(lJson.Values['data'].AsArray).ToDataSet(bdsCrudPessoas);
          bdsCrudPessoas.Open;
        end;
      end
      else
        Raise Exception.Create(lRes.Content);

    except
      on E: Exception do
        Raise Exception.Create(E.Message);
    end;
  finally
  end;
end;

procedure TFrmInsert.getDetailStructure(aTpPessoa: integer);
var
  lJson: TJSONObject;
  lRes: IResponse;
begin
  try
    lJson := TJSONObject.Create;
    try
      lRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/detail/structure/%s', [IntToStr(aTpPessoa)]))
                          .ContentType('application/json')
                          .Get;

      if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
      begin
        if not lJson.IsJsonObject(lRes.Content) then
          Raise exception.Create('JSON Invalido!');

        lJson.Parse(lRes.Content);

        if lJson.Values['success'].AsBoolean then
        begin
          bdsCrudPessoas.Close;
          TConverter.New.LoadJson(lJson.Values['structure'].AsArray).ToStructure(bdsCrudDetails);
          TConverter.New.LoadJson(lJson.Values['data'].AsArray).ToDataSet(bdsCrudDetails);
          bdsCrudPessoas.Open;
        end;
      end
      else
        Raise Exception.Create(lRes.Content);

    except
      on E: Exception do
        Raise Exception.Create(E.Message);
    end;
  finally
  end;

end;

procedure TFrmInsert.datasetToView;
begin
  try
    case pgcSelectOp.PageIndex of
      0: begin
         with edtNome do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtApelido do
         begin
           Clear;
           MaxLength := 50;
         end;
         with mEdtCpfCnpj do
         begin
           Clear;
           MaxLength := 14;
         end;
         with edtLog do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtNum do
         begin
           Clear;
           MaxLength := 13;
         end;
         with edtBairro do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtCep do
         begin
           Clear;
           MaxLength := 9;
         end;
         with edtMun do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtUF do
         begin
           Clear;
           MaxLength := 2;
         end;

         if (bdsCrudPessoas.Active) and (bdsCrudPessoas.RecordCount > 0 ) then
         begin
           selectTp.ItemIndex := bdsCrudPessoas.FieldByName('tipo_pessoa').AsInteger;
           edtNome.Text       := bdsCrudPessoas.FieldByName('nome_razao').AsString;
           edtApelido.Text    := bdsCrudPessoas.FieldByName('apelido_fantasia').AsString;
           mEdtCpfCnpj.Text   := bdsCrudPessoas.FieldByName('cpf_cnpj').AsString;
           edtLog.Text        := bdsCrudPessoas.FieldByName('logradouro').AsString;
           edtNum.Text        := bdsCrudPessoas.FieldByName('numero').AsString;
           edtBairro.Text     := bdsCrudPessoas.FieldByName('bairro').AsString;
           edtCep.Text        := bdsCrudPessoas.FieldByName('cep').AsString;
           edtMun.Text        := bdsCrudPessoas.FieldByName('municipio').AsString;
           edtUF.Text         := bdsCrudPessoas.FieldByName('uf').AsString;
         end;
      end;
      1: begin
         with edtNomeU do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtApelidoU do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtCpfCnpjU do
         begin
           Clear;
           MaxLength := 14;
         end;
         with edtLogU do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtNumU do
         begin
           Clear;
           MaxLength := 13;
         end;
         with edtBairroU do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtCepU do
         begin
           Clear;
           MaxLength := 9;
         end;
         with edtMunU do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtUFU do
         begin
           Clear;
           MaxLength := 2;
         end;

         if (bdsCrudPessoas.Active) and (bdsCrudPessoas.RecordCount > 0 ) then
         begin
           edtNomeU.Text     := bdsCrudPessoas.FieldByName('nome_razao').AsString;
           edtApelidoU.Text  := bdsCrudPessoas.FieldByName('apelido_fantasia').AsString;
           edtCpfCnpjU.Text  := bdsCrudPessoas.FieldByName('cpf_cnpj').AsString;
           edtLogU.Text      := bdsCrudPessoas.FieldByName('logradouro').AsString;
           edtNumU.Text      := bdsCrudPessoas.FieldByName('numero').AsString;
           edtBairroU.Text   := bdsCrudPessoas.FieldByName('bairro').AsString;
           edtCepU.Text      := bdsCrudPessoas.FieldByName('cep').AsString;
           edtMunU.Text      := bdsCrudPessoas.FieldByName('municipio').AsString;
           edtUFU.Text       := bdsCrudPessoas.FieldByName('uf').AsString;
         end;
      end;
    end;
  except
    on E: Exception do
      Raise Exception.Create(E.Message);
  end;
end;

procedure TFrmInsert.detailDatasetToView(aTpPessoa: integer);
begin
  try
    case pgcSelectOp.PageIndex of
      0:
      begin
        case aTpPessoa of
          0: // CLIENTE -----------------------------------------------------------------
          begin
            with c_mEdtTelF do
            begin
              Clear;
              MaxLength := 14;
            end;
            with c_mEdtTelC do
            begin
              Clear;
              MaxLength := 15;
            end;
            with c_mmObs do
            begin
              Clear;
            end;
            with c_edtEmail do
            begin
              Clear;
              MaxLength := 100;
            end;

            if (bdsCrudDetails.Active) and (bdsCrudDetails.RecordCount > 0 ) then
            begin
              c_mEdtTelF.Text    := bdsCrudDetails.FieldByName('telefone_fixo').AsString;
              c_mEdtTelC.Text    := bdsCrudDetails.FieldByName('telefone_celular').AsString;
              c_edtEmail.Text    := bdsCrudDetails.FieldByName('email').AsString;
              c_mmObs.Append(bdsCrudDetails.FieldByName('obs').AsString);
            end;
          end;
          1: // FUNCIONÁRIO -----------------------------------------------------------------
          begin
            with fu_edtUser do
            begin
              Clear;
              MaxLength := 35;
            end;
            with fu_edtSenha do
            begin
              Clear;
              MaxLength := 35;
            end;
            with fu_edtEmail do
            begin
              Clear;
              MaxLength := 100;
            end;
            with fu_edtCom do
            begin
              Clear;
              MaxLength := 15;
            end;
            with selectTpFun do
            begin
              ItemIndex := -1;
            end;

            if (bdsCrudDetails.Active) and (bdsCrudDetails.RecordCount > 0 ) then
            begin
              fu_edtUser.Text            := bdsCrudDetails.FieldByName('login').AsString;
              fu_edtSenha.Text           := bdsCrudDetails.FieldByName('senha').AsString;
              fu_edtEmail.Text           := bdsCrudDetails.FieldByName('email').AsString;
              fu_edtCom.Text             := bdsCrudDetails.FieldByName('comissao').AsString;
              selectTpFun.ItemIndex      := bdsCrudDetails.FieldByName('master').AsInteger;
            end;
          end;
          2: // FORNECEDOR -----------------------------------------------------------------
          begin
            with fo_mmObs do
            begin
              Clear;
            end;
            with fo_edtTelF do
            begin
              Clear;
              MaxLength := 14;
            end;
            with fo_edtWebsite do
            begin
              Clear;
              MaxLength := 100;
            end;
            with fo_edtEmail do
            begin
              Clear;
              MaxLength := 100;
            end;

            if (bdsCrudDetails.Active) and (bdsCrudDetails.RecordCount > 0 ) then
            begin
              fo_edtTelF.Text      := bdsCrudDetails.FieldByName('telefone').AsString;
              fo_edtWebsite.Text   := bdsCrudDetails.FieldByName('website').AsString;
              fo_edtEmail.Text     := bdsCrudDetails.FieldByName('email').AsString;
              fo_mmObs.Append(bdsCrudDetails.FieldByName('obs').AsString);
            end;
          end;
        end; // ----------------------------------------------------------------------------
      end;
      1:
      begin
        //
      end;
    end;
  except
    on E: Exception do
      Raise Exception.Create(E.Message);
  end;
end;

procedure TFrmInsert.viewToDataset;
begin
  if bdsCrudPessoas.Active then
  begin
    case pgcSelectOp.PageIndex of
      0:
      begin
        bdsCrudPessoas.Append;
      end;
      1:
        bdsCrudPessoas.Edit;
    end;

    case pgcSelectOp.PageIndex of
      0:
      begin
        if (Trim(edtNome.Text) <> '') then
          bdsCrudPessoas.FieldByName('nome_razao').AsString := Trim(edtNome.Text);

        if (Trim(edtApelido.Text) <> '') then
          bdsCrudPessoas.FieldByName('apelido_fantasia').AsString := Trim(edtApelido.Text);

        if (Trim(mEdtCpfCnpj.EditText) <> '') then
          bdsCrudPessoas.FieldByName('cpf_cnpj').AsString := Trim(mEdtCpfCnpj.EditText);

        if (Trim(edtLog.Text) <> '') then
          bdsCrudPessoas.FieldByName('logradouro').AsString := Trim(edtLog.Text);

        if (Trim(edtNum.Text) <> '') then
          bdsCrudPessoas.FieldByName('numero').AsString := Trim(edtNum.Text);

        if (Trim(edtBairro.Text) <> '') then
          bdsCrudPessoas.FieldByName('bairro').AsString := Trim(edtBairro.Text);

        if (Trim(edtCep.Text) <> '') then
          bdsCrudPessoas.FieldByName('cep').AsString := Trim(edtCep.Text);

        if (Trim(edtMun.Text) <> '') then
          bdsCrudPessoas.FieldByName('municipio').AsString := Trim(edtMun.Text);

        if (Trim(edtUF.Text) <> '') then
          bdsCrudPessoas.FieldByName('uf').AsString := Trim(edtUF.Text);

        case selectTp.ItemIndex of
          0: bdsCrudPessoas.FieldByName('tipo_pessoa').AsInteger := 0;

          1: bdsCrudPessoas.FieldByName('tipo_pessoa').AsInteger := 1;

          2: bdsCrudPessoas.FieldByName('tipo_pessoa').AsInteger := 2;
        end;
      end;
      1:
      begin
        if (Trim(edtID.Text) <> '') then
          bdsCrudPessoas.FieldByName('id').AsString := Trim(edtID.Text);

        if (Trim(edtNomeU.Text) <> '') then
          bdsCrudPessoas.FieldByName('nome_razao').AsString := Trim(edtNomeU.Text);

        if (Trim(edtApelidoU.Text) <> '') then
          bdsCrudPessoas.FieldByName('apelido_fantasia').AsString := Trim(edtApelidoU.Text);

        if (Trim(edtCpfCnpjU.Text) <> '') then
          bdsCrudPessoas.FieldByName('cpf_cnpj').AsString := Trim(edtCpfCnpjU.Text);

        if (Trim(edtLogU.Text) <> '') then
          bdsCrudPessoas.FieldByName('logradouro').AsString := Trim(edtLogU.Text);

        if (Trim(edtNumU.Text) <> '') then
          bdsCrudPessoas.FieldByName('numero').AsString := Trim(edtNumU.Text);

        if (Trim(edtBairroU.Text) <> '') then
          bdsCrudPessoas.FieldByName('bairro').AsString := Trim(edtBairroU.Text);

        if (Trim(edtCepU.Text) <> '') then
          bdsCrudPessoas.FieldByName('cep').AsString := Trim(edtCepU.Text);

        if (Trim(edtMunU.Text) <> '') then
          bdsCrudPessoas.FieldByName('municipio').AsString := Trim(edtMunU.Text);

        if (Trim(edtUFU.Text) <> '') then
          bdsCrudPessoas.FieldByName('uf').AsString := Trim(edtUFU.Text);
      end;
    end;
  end;
end;

procedure TFrmInsert.detailViewToDataset(aID, aTpPessoa: integer);
begin
  if bdsCrudDetails.Active then
  begin
    case pgcSelectOp.PageIndex of
      0:
      begin
        bdsCrudDetails.Append;
      end;
      1:
        bdsCrudDetails.Edit;
    end;
  end;

  case pgcSelectOp.PageIndex of
    0:
    begin

      bdsCrudDetails.FieldByName('id').AsInteger := aID;

      case aTpPessoa of
        0: // CLIENTE ---------------------------------------------------------------------
        begin
          if (Trim(c_mEdtTelF.Text) <> '') then
          bdsCrudDetails.FieldByName('telefone_fixo').AsString := Trim(c_mEdtTelF.Text);

          if (Trim(c_mEdtTelC.Text) <> '') then
          bdsCrudDetails.FieldByName('telefone_celular').AsString := Trim(c_mEdtTelC.Text);

          if (Trim(c_mmObs.Text) <> '') then
          bdsCrudDetails.FieldByName('obs').AsString := Trim(c_mmObs.Text);

          if (Trim(c_edtEmail.Text) <> '') then
          bdsCrudDetails.FieldByName('email').AsString := Trim(c_edtEmail.Text);
        end;
        1: // FUNCIONÁRIO -----------------------------------------------------------------
        begin
          if (Trim(fu_edtUser.Text) <> '') then
            bdsCrudDetails.FieldByName('login').AsString := Trim(fu_edtUser.Text);

          if (Trim(fu_edtSenha.Text) <> '') then
            bdsCrudDetails.FieldByName('senha').AsString := Trim(fu_edtUser.Text);

          if (Trim(fu_edtEmail.Text) <> '') then
            bdsCrudDetails.FieldByName('email').AsString := Trim(fu_edtEmail.Text);

          if (Trim(fu_edtCom.Text) <> '') then
            bdsCrudDetails.FieldByName('comissao').AsInteger := StrToInt(Trim(fu_edtCom.Text));

          if selectTpFun.ItemIndex = 0 then
            bdsCrudDetails.FieldByName('master').AsInteger := 0
          else if selectTpFun.ItemIndex = 1 then
            bdsCrudDetails.FieldByName('master').AsInteger := 1;
        end;
        2: // FORNECEDOR ------------------------------------------------------------------
        begin
          if (Trim(fo_edtTelF.Text) <> '') then
          bdsCrudDetails.FieldByName('telefone').AsString := Trim(fo_edtTelF.Text);

          if (Trim(fo_edtWebsite.Text) <> '') then
          bdsCrudDetails.FieldByName('website').AsString := Trim(fo_edtWebsite.Text);

          if (Trim(fo_edtEmail.Text) <> '') then
          bdsCrudDetails.FieldByName('email').AsString := Trim(fo_edtEmail.Text);

          if (Trim(fo_mmObs.Text) <> '') then
          bdsCrudDetails.FieldByName('obs').AsString := Trim(fo_mmObs.Text);
        end;
      end; // -----------------------------------------------------------------------------
    end;
    1:
    begin
      //
    end;
  end;
end;

function TFrmInsert.confirmOperation: Boolean;
begin
  Result := MessageDlg('Deseja confirmar?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TFrmInsert.onSave(aID: string);
var
  lRes: IResponse;
  lJson: TJSONObject;
begin

    case pgcSelectOp.PageIndex of
      0:
      begin
        if selectTp.ItemIndex = -1 then
        begin
          _MSG_OPERATION := 'Selecione o tipo antes de prosseguir!';
          Exit;
        end;

        try
          lJson := TJSONObject.Create(nil);
            try

              lJson.Assign(TConverter.New.LoadDataSet(bdsCrudPessoas).ToJSONObject);

              lRes := TRequest.New.BaseURL('http://localhost:9095/pessoa')
                              .ContentType('application/json')
                              .AddBody(lJson.Stringify)
                              .Post;

              if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
                _MSG_OPERATION := 'INCLUÍDO com sucesso!';

            except
              on E: exception do
                Raise Exception.Create(E.Message);
            end;
        finally
          FreeAndNil(lJson);
        end;
      end;

      1:
      begin
        try
          lJson := TJSONObject.Create(nil);
            try

              lJson.Assign(TConverter.New.LoadDataSet(bdsCrudPessoas).ToJSONObject);

              lRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/%s', [aID]))
                              .ContentType('application/json')
                              .AddBody(lJson.Stringify)
                              .Put;

              if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
                _MSG_OPERATION := 'ALTERADO com sucesso!'
              else
                raise exception.create(lJson.Stringify);

            except
              on E: exception do
                Raise Exception.Create(E.Message);
            end;
        finally
          FreeAndNil(lJson);
        end;
      end;
    end;
  end;

procedure TFrmInsert.onSaveDetail(aID: string);
var
  lRes: IResponse;
  lJson: TJSONObject;
begin
  case pgcSelectOp.PageIndex of
    0:
    begin
      if selectTp.ItemIndex = -1 then
        Exit;

      try
        lJson := TJSONObject.Create(nil);

        try
          lJson.Assign(TConverter.New.LoadDataSet(bdsCrudDetails).ToJSONObject);
          lJson.Put('tipo_operacao', pgcSelectOp.PageIndex);
          lJson.Put('id', bdsCrudDetails.FieldByName('id').AsInteger);
          lJson.Put('tipo_pessoa', bdsCrudPessoas.FieldByName('tipo_pessoa').AsInteger);

          lRes := TRequest.New.BaseURL('http://localhost:9095/pessoa/detail/0')
                              .ContentType('application/json')
                              .AddBody(lJson.Stringify)
                              .Put;    ;

        except
          on E: exception do
            Raise Exception.Create(E.Message);
        end;
      finally
        FreeAndNil(lJson);
      end;
    end;
    1:
    begin
      //
    end;
  end;
end;

procedure TFrmInsert.onAppend(aID: string);
var
  lRes: IResponse;
  lJson: TJSONObject;
begin
  try
    lJson := TJSONObject.Create(nil);

    try

      lRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/%s', [aID]))
                          .ContentType('application/json')
                          .Get;

      if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
      begin
        if not lJson.IsJsonObject(lRes.Content) then
          Raise Exception.Create('JSON Inválido!');

        lJson.Parse(lRes.Content);

        if lJson.Values['success'].AsBoolean then
        begin
          bdsCrudPessoas.Close;
          TConverter.New.LoadJson(lJson.Values['structure'].AsArray).ToStructure(bdsCrudPessoas);
          TConverter.New.LoadJson(lJson.Values['data'].AsArray).ToDataSet(bdsCrudPessoas);
          bdsCrudPessoas.Open;
        end
        else
          Raise Exception.Create(lJson.Values['message'].AsString);
      end;
    except
      on E: Exception do
        Raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lJson);
  end;
end;

procedure TFrmInsert.clearUpdateFields;
begin
  edtID.Clear;
  edtNomeU.Clear;
  edtApelidoU.Clear;
  edtCpfCnpjU.Clear;
  edtLogU.Clear;
  edtNumU.Clear;
  edtBairroU.Clear;
  edtCepU.Clear;
  edtMunU.Clear;
  edtUFU.Clear;
end;

procedure TFrmInsert.clearAll;
begin
  edtNome.Clear;
  edtApelido.Clear;
  mEdtCpfCnpj.Clear;
  edtLog.Clear;
  edtNum.Clear;
  edtBairro.Clear;
  edtCep.Clear;
  edtMun.Clear;
  edtUF.Clear;

  edtID.Clear;
  edtNomeU.Clear;
  edtApelidoU.Clear;
  edtCpfCnpjU.Clear;
  edtLogU.Clear;
  edtNumU.Clear;
  edtBairroU.Clear;
  edtCepU.Clear;
  edtMunU.Clear;
  edtUFU.Clear;
end;

procedure TFrmInsert.checkTpCad;
begin
  case selectTpCad.ItemIndex of
      -1: mEdtCpfCnpj.Enabled := False;
      0:
      begin
        mEdtCpfCnpj.EditMask := '999.999.999-99;0';
        mEdtCpfCnpj.Enabled := True;
        mEdtCpfCnpj.MaxLength := 11;
      end;
      1:
      begin
        mEdtCpfCnpj.EditMask := '99.999.999/9999-99;0';
        mEdtCpfCnpj.Enabled := True;
        mEdtCpfCnpj.MaxLength := 18;
      end;
  end;
end;

end.

