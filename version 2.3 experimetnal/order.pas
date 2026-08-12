unit Order;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Misc_Functions,
  Math;

type

  { TfrmOrder }

  TfrmOrder = class(TForm)
    btnResult: TButton;
    btnExit: TButton;
    cboBWUnits: TComboBox;
    cboOrderUnits: TComboBox;
    cboOrderAttenUnits: TComboBox;
    txtCF: TEdit;
    txtBW: TEdit;
    lblSimSpan3: TStaticText;
    lblSimSpan4: TStaticText;
    lblSimSpan5: TStaticText;
    txtOrder: TEdit;
    txtStbFreq: TEdit;
    lblSimCF: TStaticText;
    lblSimCF1: TStaticText;
    lblSimSpan: TStaticText;
    lblSimSpan1: TStaticText;
    lblSimSpan2: TStaticText;
    txtRipple: TEdit;
    txtPass: TEdit;
    txtAtten: TEdit;
    procedure btnExitClick(Sender: TObject);
    procedure btnResultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtAttenChange(Sender: TObject);
    procedure txtRippleChange(Sender: TObject);
    procedure txtPassChange(Sender: TObject);
    procedure txtStbFreqChange(Sender: TObject);

  private

  public

  end;

var
  frmOrder: TfrmOrder;

implementation

{$R *.lfm}

{ TfrmOrder }

procedure TfrmOrder.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrder.btnResultClick(Sender: TObject);
Var
Center_Frequency,BandWidth,Attenuation,Stop_Bandwidth,Pass_Bandwidth:Real;
Cheby:Boolean;
begin
  if (txtRipple.Text='') Or (txtRipple.Text='0') then
   Cheby:=False //ButterWorth
  Else
  Cheby:=True; //Chebycev
 Center_Frequency:=StrToFloat(txtCF.Text);
 case cboOrderUnits.ItemIndex of
 0:Center_Frequency:=Center_Frequency;
  1:Center_Frequency:=Center_Frequency*Power(10,3);//KHz
  2:Center_Frequency:=Center_Frequency*Power(10,6);//MHz
  end;
  BandWidth:=StrToFloat(txtBw.Text);
 case cboBwUnits.ItemIndex of
  0:BandWidth:=BandWidth;//Hz
  1:BandWidth:=BandWidth*Power(10,3);//KHz
  2:BandWidth:=BandWidth*Power(10,6);//MHz
  end;
  Attenuation:=StrToFloat(txtAtten.Text);
   case cboOrderAttenUnits.ItemIndex of
  0:Attenuation:=Attenuation;//Hz
  1:Attenuation:=Attenuation*Power(10,3);//KHz
  2:Attenuation:=Attenuation*Power(10,6);//MHz
  end;
  Pass_Bandwidth:=BandWidth; {fm/df}
 Stop_Bandwidth:=((Attenuation-Center_Frequency)*2);
   txtOrder.Text:=IntToStr(Misc_Functions.Determine_Order(Cheby,(Pass_Bandwidth),Stop_Bandwidth,StrToFloat(txtStbFreq.Text),StrToFloat(txtPass.Text)));
end;

procedure TfrmOrder.FormCreate(Sender: TObject);
begin
  cboOrderUnits.ItemIndex:=0;
  cboOrderAttenUnits.ItemIndex:=0;
  cboBWUnits.ItemIndex:=0;

  txtAtten.Text:='';
  txtStbFreq.Text:='';
  txtPass.Text:='';
   txtCF.Text:='';
   txtBW.Text:='';
   txtOrder.Text:='';


end;

procedure TfrmOrder.txtAttenChange(Sender: TObject);
var
  x:integer;
begin
 x:=Pos(',',txtAtten.Text);
 if x<>0 then
  txtAtten.Text:=StringReplace(txtAtten.Text, ',', '.',
                          [rfReplaceAll, rfIgnoreCase]);

end;

procedure TfrmOrder.txtRippleChange(Sender: TObject);
var
  x:integer;
begin
 x:=Pos(',',txtRipple.Text);
 if x<>0 then
  begin
  txtRipple.Text:=StringReplace(txtRipple.Text, ',', '.',
                          [rfReplaceAll, rfIgnoreCase]);
 ShowMessage('Only . Allowed not , Try Again');
 end;

end;

procedure TfrmOrder.txtPassChange(Sender: TObject);
var
  x:integer;
begin
 x:=Pos(',',txtPass.Text);
 if x<>0 then
  txtPass.Text:=StringReplace(txtPass.Text, ',', '.',
                          [rfReplaceAll, rfIgnoreCase]);

end;

procedure TfrmOrder.txtStbFreqChange(Sender: TObject);
var
  x:integer;
begin
 x:=Pos(',',txtStbFreq.Text);
 if x<>0 then
  txtStbFreq.Text:=StringReplace(txtStbFreq.Text, ',', '.',
                          [rfReplaceAll, rfIgnoreCase]);

end;



end.

