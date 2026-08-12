unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,IniFiles,
  Grids,simFunctions,Math,Graph_Result;

type

  { TForm2 }

  TForm2 = class(TForm)
    btnExit: TButton;
    btnResult: TButton;
    cboSimCFUnits: TComboBox;
    cboSimSpanUnits: TComboBox;
    cboSimStepUnits: TComboBox;
    Image1: TImage;
    lblSimCF: TStaticText;
    lblSimCF1: TStaticText;
    lblSimSpan: TStaticText;
    lblCrystal1: TLabel;
    lblCrystal2: TLabel;
    lblResistanse: TLabel;
    lblResistanse1: TLabel;
    lblResult: TLabel;
    lblSimSpan1: TStaticText;
    StringGrid1: TStringGrid;
    txtSimCF: TEdit;
    txtSimSpan: TEdit;
    txtCrystal1: TEdit;
    txtCrystal2: TEdit;
    txtCrystal5: TEdit;
    txtCrystal6: TEdit;
    txtSimStep: TEdit;
    procedure btnExitClick(Sender: TObject);
    procedure btnResultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private

  public

  end;

var
  Form2: TForm2;

implementation
 var
     Types,Order,BWUnits:Integer;
     BandWidth:Real;

{$R *.lfm}

{ TForm2 }

procedure TForm2.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.btnResultClick(Sender: TObject);
var
  cheby:boolean;
  Center_Frequency,Span,Ripple,fl,fu,Step,Counter,BandWidth_Temp,Temp_Result:Real;
  Count,sizefix:Integer;
  f:TextFile;
 begin
   if (txtSimCF.Text = '') or (txtSimSpan.Text = '') or (txtSimStep.Text = '') then
   begin
     ShowMessage('Please enter Center Frequency, Span, and Step.');
     exit;
   end;

   AssignFile(f,'2_Pole_Response.csv');
  BandWidth_temp:=BandWidth;
  cheby:=False;
Case Types of
0:begin cheby:=True;Ripple:=0.01; end;
1:begin cheby:=True;Ripple:=0.1; end;
2:begin cheby:=True;Ripple:=0.5;end;
3:Cheby:=False;
end;

Center_Frequency:=StrToFloat(txtSimCF.Text);
case cboSimCFUnits.ItemIndex of
  0:Center_Frequency:=Center_Frequency*Power(10,1);
  1:Center_Frequency:=Center_Frequency*Power(10,3);
  2:Center_Frequency:=Center_Frequency*Power(10,6);
  end;

Span:=StrToFloat(txtSimSpan.Text);
case cboSimSpanUnits.ItemIndex of
    0:Span:=Span*Power(10,1);
    1:Span:=Span*Power(10,3);
    2:Span:=Span*Power(10,6);
end;
Step:=StrToFloat(txtSimStep.Text);

   case cboSimStepUnits.ItemIndex of
    0:Step:=Step*Power(10,1);
    1:Step:=Step*Power(10,3);
    2:Step:=Step*Power(10,6);
    end;
case BWUnits of
    0:BandWidth_Temp:=BandWidth_Temp*Power(10,1);
    1:BandWidth_Temp:=BandWidth_Temp*Power(10,3);
    2:BandWidth_Temp:=BandWidth_Temp*Power(10,6);
end;

StringGrid1.RowCount:=Trunc(Span/Step)+2;
StringGrid1.Cells[0,0]:='Measurement Number';
 StringGrid1.Cells[1,0]:='Frequency';
 StringGrid1.Cells[2,0]:='Gain';
 try
  ReWrite(f);
  try
  writeln(f,'Measurement,Frequency,Gain');
  finally
    CloseFile(f);
  end;
  except
   on E:Exception do
     ShowMessage('File 2_pole_Response.csv could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;
 count:=1;
 fl:=Center_Frequency-(BandWidth_Temp/2);
 fu:=Center_Frequency+(BandWidth_Temp/2);
 Counter:=Trunc(Center_Frequency-(Span/2));
  try
  Append(f);
  except
   on E:Exception do
     ShowMessage('File 2_pole_Response.csv could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;
 while( Counter<((Center_Frequency+(Span/2))+1)) do
begin

StringGrid1.Cells[0,Count]:=FloatToStr(Count);
StringGrid1.Cells[1,Count]:=FloatToStr(Counter);
if cheby=True then

   Temp_Result:= ChebyBPGain(Counter,fl,fu,2,Ripple){calculate response}
Else
Temp_Result:= ButterBandpassGain(Counter,fL,fU,2);


StringGrid1.Cells[2,count]:=FloatToStr(Temp_Result);
writeln(f,FloatToStr(count)+','+FloatToStr(Counter)+','+FloatToStr(Temp_Result));


Count:=Count+1;
Counter:=Counter+Step;
end;
 CloseFile(f);
 for sizefix:=0 to 2 do
 begin
 StringGrid1.ColWidths[sizefix] := StringGrid1.ClientWidth - StringGrid1.ColWidths[0] - 2 * StringGrid1.GridLineWidth;

 end;
 Graph_Result.Graph_Results.Show;
end;
procedure TForm2.FormCreate(Sender: TObject);

begin
  txtSimCF.Text:='';
  txtSimSpan.Text:='';
  txtSimStep.Text:='';
  cboSimCFUnits.ItemIndex:=2;
  cboSimSpanUnits.ItemIndex:=1;
  cboSimStepUnits.ItemIndex:=1;

end;

procedure TForm2.FormShow(Sender: TObject);
  var
   INI : TINIFile;

begin

  INI := TINIFile.Create('Temp.Ini');
 try
  cboSimCFUnits.ItemIndex:=StrToInt(INI.ReadString('Centrer Frequency','Units',''));
  txtSimCF.Text:=INI.ReadString('Centrer Frequency','Freq','');
  Order:=StrToInt(INI.ReadString('Type','Filter Order',''));
  Types:=StrToInt(INI.ReadString('Type','Filter Type',''));
  Bandwidth:=StrToFloat(INI.ReadString('BandWidth','Freq',''));
  BwUnits:=StrToInt(INI.ReadString('BandWidth','Units',''));
  finally
 ini.free;
end;

end;
 End.
