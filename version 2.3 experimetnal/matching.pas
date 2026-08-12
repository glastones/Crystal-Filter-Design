unit matching;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons,Math;

type

  { TfrmMatching }

  TfrmMatching = class(TForm)
    btnCalculateC: TBitBtn;
    btnExit: TButton;
    cboUnits: TComboBox;
    cboUnitsL: TComboBox;
    cboStepUp: TComboBox;
    cboStepDown: TComboBox;
    txtNotice: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Lin: TEdit;
    txtStepupSec: TEdit;
    txtStepDownPri: TEdit;
    txtPri: TEdit;
    txtSec: TEdit;
    Lout: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label20: TLabel;
    Label21: TLabel;
    txtStepDown: TEdit;
    txtStepDownZS: TEdit;
    txtStepDownZL: TEdit;
    txtCFStepup: TEdit;
    txtStepupZL: TEdit;
    txtStepUpZS: TEdit;
    ImageCmatching: TImage;
    imgLmatching: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    txtCResult: TEdit;
    txtLResult: TEdit;
    txtLResultL: TEdit;
    txtCResultL: TEdit;
    txtFreq: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    txtCP: TEdit;
    txtFreqL: TEdit;
    txtLRL: TEdit;
    txtSL: TEdit;
    txtLR: TEdit;
    txtSLL: TEdit;
    procedure btnCalculateCClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure cboStepDownChange(Sender: TObject);
    procedure cboStepUpChange(Sender: TObject);
    procedure cboUnitsChange(Sender: TObject);
    procedure cboUnitsLChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure txtCFStepupChange(Sender: TObject);
    procedure txtFreqChange(Sender: TObject);
    procedure txtFreqLChange(Sender: TObject);
    procedure txtLRChange(Sender: TObject);
    procedure txtLRLChange(Sender: TObject);
    procedure txtPriChange(Sender: TObject);
    procedure txtSecChange(Sender: TObject);
    procedure txtSLChange(Sender: TObject);
    procedure txtSLLChange(Sender: TObject);
    procedure txtStepDownChange(Sender: TObject);
    procedure txtStepDownZLChange(Sender: TObject);
    procedure txtStepDownZSChange(Sender: TObject);
    procedure txtStepupZLChange(Sender: TObject);
    procedure txtStepUpZSChange(Sender: TObject);
  private
   var calc:Boolean;
  public

  end;

var
  frmMatching: TfrmMatching;
  procedure Reset_form;
 Procedure Step_Down(Zout,Zin,f:Real);
 Procedure Step_Up(Zout,Zin,f:Real);
implementation
uses Filter;
{$R *.lfm}

{ TfrmMatching }
procedure Reset_form;

begin

    with frmMatching do
begin
 txtStepDownZL.Text:='';
 txtStepDownZS.Text:='';
 txtStepDown.Text:='';
 txtStepDownZS.Text:='';
 txtCP.Text:='';
 Lin.Text:='';
 Lout.Text:='';
 txtCFStepup.Text:='';
 txtStepUpZL.Text:='';
 txtStepupZS.Text:='';
 txtSL.Text:='';
 txtLR.Text:='';
 txtSLL.Text:='';
 txtLRL.Text:='';
 //txtFreqL.Text:='';
 txtCResult.Text:='';
 txtCResultL.Text:='';
 txtLResultL.Text:='';
 txtLResult.Text:='';
 txtStepDownPri.Text:='';
 txtstepupSec.Text:='';
 cbounits.ItemIndex:=0;
 cboUnitsL.ItemIndex:=0;
 cboStepUp.ItemIndex:=0;
 cboStepDown.ItemIndex:=0;
 txtPri.Text:='20';
 txtSec.Text:='20';
 calc:=False;
    //transfer center frequency from the main form
    if length(Filter.Form1.txtCF.Text)<> 0 then
frmMatching.txtFreq.Text:=Filter.Form1.txtCF.Text
else
Form1.txtcf.Text:='';

end;
   end;

procedure TfrmMatching.FormCreate(Sender: TObject);
begin
Reset_form;
 end;



procedure TfrmMatching.txtCFStepupChange(Sender: TObject);
begin
 txtFreqL.Text:=txtCFStepup.Text;
 txtStepDown.Text:=txtCFStepup.Text;
 txtFreq.Text:=txtCFStepup.Text;
end;

procedure TfrmMatching.cboUnitsChange(Sender: TObject);
begin
  cboUnitsL.ItemIndex:=cboUnits.ItemIndex;
  cboStepUp.ItemIndex :=cboUnits.ItemIndex;
  cboStepDown.ItemIndex:=cboUnits.ItemIndex;
end;

procedure TfrmMatching.btnCalculateCClick(Sender: TObject);
  var
    Q,f,Cp,C,L,Load_Impedance,Source_Impedance,Xs,Xp,n,Lini:Real;
    Louts,Zin,Zout:Real;
    flag:boolean;
    fs: TFormatSettings;
    begin
      fs := DefaultFormatSettings;
      fs.DecimalSeparator := '.';
      flag:=False;
      if length(txtCP.Text)=0 then begin Flag:=True; txtCP.Text:='1';end;
      if length(txtSL.Text)=0  then begin flag:=True ;txtSL.Text:='50' ; end;
      if length(txtLR.Text) =0 then begin flag:=True;txtLR.Text:='1';end;
      if length(txtFreq.Text)=0 then begin flag:=True; txtFreq.text:='1'; end;
      if (flag)then
      begin
      ShowMessage('Please correct the values. Defaults has been loaded');
      exit;
      end;

   if not TryStrToFloat(txtFreq.Text, f, fs) then
   begin
     fs.DecimalSeparator := ',';
     if not TryStrToFloat(txtFreq.Text, f, fs) then
     begin
       ShowMessage('Invalid Frequency format');
       Exit;
     end;
   end;

   fs.DecimalSeparator := '.';
   if not TryStrToFloat(txtCP.Text, Cp, fs) then
   begin
     fs.DecimalSeparator := ',';
     if not TryStrToFloat(txtCP.Text, Cp, fs) then
     begin
       ShowMessage('Invalid Cp format');
       Exit;
     end;
   end;

   fs.DecimalSeparator := '.';
   if not TryStrToFloat(txtLR.Text, Load_impedance, fs) then
   begin
     fs.DecimalSeparator := ',';
     if not TryStrToFloat(txtLR.Text, Load_impedance, fs) then
     begin
       ShowMessage('Invalid Load Impedance format');
       Exit;
     end;
   end;

   fs.DecimalSeparator := '.';
   if not TryStrToFloat(txtSL.Text, Source_Impedance, fs) then
   begin
     fs.DecimalSeparator := ',';
     if not TryStrToFloat(txtSL.Text, Source_Impedance, fs) then
     begin
       ShowMessage('Invalid Source Impedance format');
       Exit;
     end;
   end;

   case cboUnits.itemIndex of
      0:f:=f*Power(10,6);
      1:f:=f*Power(10,3);
      2:f:=f*1;
   end;
   if Load_impedance<=Source_impedance then
   begin
     ShowMessage('Error. Load Impendance must be biggrer than Source Impendance');
     txtLR.SetFocus;
     exit; // Fixed: should exit here
   end;

   Q:=Sqrt((Load_impedance/Source_impedance)-1);
   Xs:=Source_impedance*Q;
   Xp:=Load_impedance/Q;
   C:=1/(2*3.14*f*Xs);
   txtCResult.Text:=FloatToStr(Round(C*Power(10,12)));
   L:=1/(4*Power(3.14,2)*Power(f,2)*(C-(Cp*Power(10,-12))));
   txtLResult.Text:=FloatToStr(L*Power(10,6));
   txtLResultL.Text:=FloatToStr(Q*Source_impedance/(2*3.14*f));
   txtCResultL.Text:=FloatToStr((Q/(2*3.14*f*Load_Impedance))*Power(10,12));

     fs.DecimalSeparator := '.';
     if not TryStrToFloat(txtStepUpZs.Text, Load_Impedance, fs) then
     begin
       fs.DecimalSeparator := ',';
       TryStrToFloat(txtStepUpZs.Text, Load_Impedance, fs);
     end;

     fs.DecimalSeparator := '.';
     if not TryStrToFloat(txtStepupZL.Text, Source_Impedance, fs) then
     begin
       fs.DecimalSeparator := ',';
       TryStrToFloat(txtStepupZL.Text, Source_Impedance, fs);
     end;

     if (Source_Impedance > 0) and (Load_Impedance > 0) then
     begin
       n:=Sqrt(Load_Impedance/Source_Impedance);
       {rule of thumb Lin*wmega=4*Zin}
        Lini:=(4*Source_Impedance)/(2*3.14*f);
        Louts:=n*Lini;
        Lin.Text:=FloatToStr(Round(Lini*Power(10,6)));
        n:=Sqrt(Source_Impedance/Load_Impedance);
        Lini:=(4*Load_Impedance)/(2*3.14*f);
        Lout.Text:=FloattoStr(Round(Lini*Power(10,6)));
     end;

      Zin:=StrToFloatDef(txtSL.Text, 50);
      Zout:=StrToFloatDef(txtLR.text, 50);
      Step_Up(Zin,Zout,f / Power(10, (2-cboUnits.ItemIndex)*3)); // Adjust f back to display units if needed, or pass absolute f
      Step_Down(Zin,Zout, f / Power(10, (2-cboUnits.ItemIndex)*3));
      calc:=True;

     end;

procedure TfrmMatching.btnExitClick(Sender: TObject);
   begin
     Close;
end;

procedure TfrmMatching.cboStepDownChange(Sender: TObject);
begin
  cboStepUp.ItemIndex:=cboStepDown.ItemIndex;
  cboUnits.ItemIndex:=cboStepDown.ItemIndex;
  cboUnitsL.ItemIndex:=cboStepDown.ItemIndex;
end;

procedure TfrmMatching.cboStepUpChange(Sender: TObject);
begin
  cboStepDown.ItemIndex:=cboStepUp.ItemIndex;
  cboUnitsL.ItemIndex:=cboStepUp.ItemIndex;
  cboUnits.ItemIndex:=cboStepUp.ItemIndex;
end;

procedure TfrmMatching.cboUnitsLChange(Sender: TObject);
begin
cboUnits.ItemIndex:=cboUnitsL.ItemIndex;
cboStepDown.ItemIndex :=cboUnitsL.ItemIndex;
cboStepUp.ItemIndex:=cboUnitsL.ItemIndex;
end;

procedure TfrmMatching.FormActivate(Sender: TObject);
begin
  Reset_form;
end;

procedure TfrmMatching.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
 Reset_form;

end;

procedure TfrmMatching.txtFreqChange(Sender: TObject);
begin
  txtfreqL.Text:=txtFreq.Text;
  txtCFStepup.Text:=txtFreq.Text;
  txtStepDown.Text:=txtFreq.Text;

end;

procedure TfrmMatching.txtFreqLChange(Sender: TObject);
begin
  txtFreq.Text:=txtFreqL.Text;
  txtCFStepup.Text:=txtFreqL.Text;
  txtStepDown.Text:=txtFreqL.Text;
end;

procedure TfrmMatching.txtLRChange(Sender: TObject);
begin
txtLRL.Text:=txtLR.Text;
txtStepupZL.Text:=txtLR.Text;
txtStepDownZL.Text:=txtLR.Text;
end;

procedure TfrmMatching.txtLRLChange(Sender: TObject);
begin
txtStepupZL.Text:=txtLRL.Text;
txtStepDownZL.Text:=txtLRL.Text;
txtLR.Text:=txtLRL.Text;
end;

procedure TfrmMatching.txtPriChange(Sender: TObject);
var
  Zin,Zout:Real;
begin
if (calc) and (txtpri.Text <>'') then
begin
Zin:=StrToFloat(txtSL.Text);
      Zout:=StrToFloat(txtLR.text);
      Step_Up(Zin,Zout,StrToFloat(txtFreq.Text));
end;
     end;

procedure TfrmMatching.txtSecChange(Sender: TObject);
var
  Zin,Zout:Real;
begin
if (calc) and (txtpri.Text <>'') then
begin
Zin:=StrToFloat(txtSL.Text);
      Zout:=StrToFloat(txtLR.text);
      Step_Down(Zin,Zout,StrToFloat(txtFreq.Text));
end;

end;




procedure TfrmMatching.txtSLChange(Sender: TObject);
begin
txtSLL.Text:=txtSL.Text;
txtStepUpZS.Text:=txtSL.Text;
txtStepDownZS.Text:=txtSL.Text;
 end;

procedure TfrmMatching.txtSLLChange(Sender: TObject);
begin
  txtSL.Text:=txtSLL.Text;
txtStepUpZS.Text:=txtSLL.Text;
txtStepDownZS.Text:=txtSLL.Text;
end;

procedure TfrmMatching.txtStepDownChange(Sender: TObject);
begin
 txtFreq.Text:=txtStepDown.Text;
 txtFreqL.Text:=txtStepDown.Text;
 txtCFStepup.Text:=txtStepDown.Text;
end;

procedure TfrmMatching.txtStepDownZLChange(Sender: TObject);
begin
  txtLRL.Text:=txtStepDownZL.Text;
 txtStepupZL.Text:=txtStepDownZL.Text;
 txtLR.Text:=txtStepDownZL.Text;
 end;
procedure TfrmMatching.txtStepDownZSChange(Sender: TObject);
begin
  txtSL.Text:=txtStepDownZS.Text;
txtSLL.Text:=txtStepDownZS.Text;
txtStepUpZS.Text:=txtStepDownZS.Text;

end;

procedure TfrmMatching.txtStepupZLChange(Sender: TObject);
begin
txtLRL.Text:=txtStepupZL.Text;
txtStepDownZL.Text:=txtStepupZL.Text;
txtLR.Text:=txtStepupZL.Text;

end;

procedure TfrmMatching.txtStepUpZSChange(Sender: TObject);
begin
  txtSL.Text:=txtStepUpZS.Text;
txtSLL.Text:=txtStepUpZS.Text;
txtStepDownZS.Text:=txtStepUpZS.Text;
end;

Procedure Step_Down(Zout,Zin,f:Real);
var
Np, Ns, Lp, Ls:Real;
begin
Ns := 20; //rule of thumb
try
  Ns:=StrToInt(frmMatching.txtSec.text);
   except
    On E : EConvertError do
      ShowMessage ('Invalid number encountered');
end;
Np:=Round(Sqrt(Zout/Zin)*Ns); {Primary turns}
frmMatching.txtStepDownPri.Text:=FloatToStr(Np);
Ls:=Sqrt(Zout)/(2*3.14*f);
{"Possible Inductance of Secondary = "}
end;

Procedure Step_Up(Zout,Zin,f:Real);
var
 Np, Ns, Lp, Ls,Zs:Real;
begin
Np:=20; //rule of thumb
try
  Np:=StrToInt(frmMatching.txtPri.text);
   except
    On E : EConvertError do
      ShowMessage ('Invalid number encountered');

end;
Ns := Round(Sqrt(Zout/Zin)*Np);

{turns on Seconday =  Ns}
Zs := Sqrt(Zout);
frmMatching.txtStepupSec.Text:=FloatToStr(Ns);
Ls :=(Zs/(2*3.14*f));
{Print["Possible Inductance of Secondary = ", Ls]}
end;

end.

