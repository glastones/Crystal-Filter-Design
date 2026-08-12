unit Filter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Menus, PrintersDlgs,IniFiles,Math,Unit1,Unit2,Printers,frmAbout,
  matching,Filter_8pole,Misc_Functions,Filter_6poles,Order,osprinters,Convert,
  filter_3poles,process;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCalculate: TButton;
    btnExit: TButton;
    btnTest: TButton;
    btnOptimizer: TButton;
    cboHarmonic: TComboBox;
    cboOrder: TComboBox;
    cboUnits: TComboBox;
    cboBWUnits: TComboBox;
    cboType: TComboBox;
    Label1: TLabel;
    lblOrder: TStaticText;
    MainMenu1: TMainMenu;
    Help: TMenuItem;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    mmuOrder: TMenuItem;
    mnmMatching: TMenuItem;
    mnmHelp: TMenuItem;
    mnmFile: TMenuItem;
    mnmOpen: TMenuItem;
    mnmSave: TMenuItem;
    mnmPrint: TMenuItem;
    mnmExit: TMenuItem;
    OpenDialog: TOpenDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrnDialog: TPrintDialog;
    PrinterDialog: TPrinterSetupDialog;
    SaveDialog1: TSaveDialog;
    lblBW: TStaticText;
    lblFilterType: TStaticText;
    lblCP: TStaticText;
    txtBW2: TStaticText;
    lblCrystalHarmonic: TStaticText;
    lblQ: TStaticText;
    txtCF: TEdit;
    Image1: TImage;
    lblCF: TStaticText;
    txtBW: TEdit;
    txtCi: TEdit;
    txtQ: TEdit;
    procedure btnCalculateClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnOptimizerClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure mmuOrderClick(Sender: TObject);
    procedure mnmMatchingClick(Sender: TObject);
    procedure mnmExitClick(Sender: TObject);
    procedure mnmHelpClick(Sender: TObject);
    procedure mnmOpenClick(Sender: TObject);
    procedure mnmPrintClick(Sender: TObject);
    procedure mnmSaveClick(Sender: TObject);

    procedure txtCiKeyPress(Sender: TObject; var Key: char);

  private

  public


  end;

var
  Form1: TForm1;

implementation
 Procedure cheby_1;  forward;
 Procedure cheby_2;  forward;
 Procedure cheby_3;  forward;
 Procedure butter_1; forward;
 Procedure Max_Flatness;  forward;
Procedure Linear_phase;   forward;
 Procedure Gaussian;      forward;
 Procedure Gaussian_6db;  forward;
Procedure Gaussian_12db;  forward;
Procedure Legrande;       forward;
Procedure Check_information;  forward;
 Procedure Caluclate_2_pole_Filter(fc,q1,q2,K12,Q,Bw,Cmotional:Real); forward;
 Procedure Caluclate_3_pole_Filter(fc,q1,q2,K12,K23,Q,Bw,Cmotional:Real); forward;
 Procedure Caluclate_4_pole_Filter(fc,q1,q4,K12,K23,K34,Q,Bw,Cmotional:Real); forward;
 Procedure Calculate_6_Pole_Filter(fc,q1,q4,K12,K23,K34,K45,K56,Q,Bw,Cmotional:Real);forward;
 Procedure Caluclate_8_pole_Filter(fc,q1,q8,K12,K23,K34,K45,K56, K67, K78,Q,Bw,Cmotional:Real); forward;
  procedure not_implement; forward;
 var    {Global unit variables}
Center_Frequency:Real;
BandWidth:Real;
Cmotional:Real;
Crystal_Q:Real;
c0:Real;
f:Text;
All_info:boolean;
{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

    cbounits.ItemIndex:=2;
    cbobwunits.ItemIndex:=0;
    cboharmonic.ItemIndex:=0;
    cbotype.itemIndex:=0;
    cboOrder.itemIndex:=0;
    txtCF.Text:='';
    memo1.Clear;
    btnOptimizer.Caption:='Crystal '+LineEnding+'Optimizer';

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
frmConvert.indexing:=1;
frmConvert.ShowModal;


end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
frmConvert.indexing:=2;
frmConvert.ShowModal;

end;

procedure TForm1.mmuOrderClick(Sender: TObject);
begin
 Order.frmOrder.ShowModal;
end;

procedure TForm1.mnmMatchingClick(Sender: TObject);
begin
  frmMatching.ShowModal;
end;



procedure TForm1.mnmExitClick(Sender: TObject);
begin

 Application.Terminate;

end;

procedure TForm1.mnmHelpClick(Sender: TObject);
begin
    frmAbout.frmabouts.Show;
end;

procedure TForm1.mnmOpenClick(Sender: TObject);
var
      INI: TINIFile;
begin
    OpenDialog.Filter := 'Filter Files|*.inf' ;
    OpenDialog.FilterIndex := 1 ;
    OpenDialog.Execute;
   cbounits.ItemIndex:=2;
    cbobwunits.ItemIndex:=0;
    cboharmonic.ItemIndex:=0;
    cbotype.itemIndex:=0;
    cboOrder.itemIndex:=0;
    txtCF.Text:='';
 INI:=TINIFile.Create(OpenDialog.FileName);
 try
   cboUnits.ItemIndex:=StrToInt(INI.ReadString('Centrer Frequency','Units',''));
   txtCF.text:=INI.ReadString('Centrer Frequency','Freq',txtCF.text);
   cbobwUnits.ItemIndex:=StrToInt(INI.ReadString('BandWidth','Units',''));
   txtBW.text:=INI.ReadString('BandWidth','Freq','');
   txtCi.text:=INI.ReadString('Motional','Cap','');
   txtQ.text:=INI.ReadString('Crystal','Q','');
   cboHarmonic.ItemIndex:=StrToInt(INI.ReadString('Harmonic','Units',''));
   cboOrder.ItemIndex:=StrToInt(INI.ReadString('Type','Filter Order',''));
   cboType.ItemIndex:=StrToInt(INI.ReadString('Type','Filter Type',''));
 finally
 ini.free;
 end;

end;

procedure TForm1.mnmPrintClick(Sender: TObject);
var
  Prn: TPrinter;
  Y, X: Integer;
  LineHeight: Integer;
  S: String;
  SL: TStringList;
  i: Integer;
  ActiveImg: TImage;

  procedure PrintText(const Text: string; Bold: Boolean = False; Underline: Boolean = False);
  begin
    if Bold then
      Prn.Canvas.Font.Style := Prn.Canvas.Font.Style + [fsBold]
    else
      Prn.Canvas.Font.Style := Prn.Canvas.Font.Style - [fsBold];

    if Underline then
      Prn.Canvas.Font.Style := Prn.Canvas.Font.Style + [fsUnderline]
    else
      Prn.Canvas.Font.Style := Prn.Canvas.Font.Style - [fsUnderline];

    Prn.Canvas.TextOut(X, Y, Text);
    Inc(Y, LineHeight);
    
    if Y > Prn.PaperSize.Height - 100 then
    begin
      Prn.NewPage;
      Y := 100;
    end;
  end;

begin
  if not PrnDialog.Execute then exit;

  Prn := Printer;
  Prn.BeginDoc;
  try
    Prn.Canvas.Font.Name := 'Courier New';
    Prn.Canvas.Font.Size := 12;
    LineHeight := Prn.Canvas.TextHeight('Wy') + 5;
    X := 100;
    Y := 100;

    // Header
    PrintText('Crystal Filter Design - Design Report', True, True);
    PrintText('Date: ' + DateTimeToStr(Now));
    Inc(Y, LineHeight);

    // Filter Parameters from Main Form
    PrintText('Filter Input Parameters:', True);
    PrintText('Center Frequency: ' + txtCF.Text + ' ' + cboUnits.Text);
    PrintText('Bandwidth: ' + txtBW.Text + ' ' + cbobwUnits.Text);
    PrintText('Motional Capacitance: ' + txtCi.Text + ' fF');
    PrintText('Crystal Q: ' + txtQ.Text);
    PrintText('Harmonic: ' + cboHarmonic.Text);
    PrintText('Order: ' + cboOrder.Text);
    PrintText('Type: ' + cboType.Text);
    Inc(Y, LineHeight);

    // Manufacture Data from file
    if FileExists('Manufacture_Data.txt') then
    begin
      SL := TStringList.Create;
      try
        SL.LoadFromFile('Manufacture_Data.txt');
        PrintText('Detailed Manufacture Data:', True);
        for i := 0 to SL.Count - 1 do
          PrintText(SL[i]);
      finally
        SL.Free;
      end;
      Inc(Y, LineHeight);
    end;

    // Circuit Image
    ActiveImg := nil;
    case cboOrder.ItemIndex of
      0: if Assigned(Unit1.Form2) then ActiveImg := Unit1.Form2.Image1;
      1: if Assigned(filter_3poles.Fiter_3pole) then ActiveImg := filter_3poles.Fiter_3pole.img3pole;
      2: if Assigned(Unit2.Form3) then ActiveImg := Unit2.Form3.Image1;
      3: if Assigned(Filter_6poles.frm6Pole) then ActiveImg := Filter_6poles.frm6Pole.Image1;
      4: if Assigned(Filter_8pole.frm8pole) then ActiveImg := Filter_8pole.frm8pole.Image1;
    end;

    if Assigned(ActiveImg) and Assigned(ActiveImg.Picture.Graphic) and (not ActiveImg.Picture.Graphic.Empty) then
    begin
       PrintText('Circuit Diagram:', True);
       // Scaling image to fit page width
       Prn.Canvas.StretchDraw(Rect(X, Y, X + (Prn.PaperSize.Width div 2), Y + (Prn.PaperSize.Height div 4)), ActiveImg.Picture.Graphic);
       Inc(Y, (Prn.PaperSize.Height div 4) + LineHeight);
    end;

    // Simulation Data (Summary)
    S := '';
    case cboOrder.ItemIndex of
       0: S := '2_Pole_Response.csv';
       2: S := '4_Pole_Response.csv';
       3: S := '6_Pole_Response.csv';
       4: S := '8_Pole_Response.csv';
    end;
    
    if (S <> '') and FileExists(S) then
    begin
       SL := TStringList.Create;
       try
         SL.LoadFromFile(S);
         PrintText('Simulation Data Summary:', True);
         // Print first 30 points
         for i := 0 to Min(30, SL.Count - 1) do
           PrintText(SL[i]);
         if SL.Count > 31 then
           PrintText('... (more simulation points available in ' + S + ')');
       finally
         SL.Free;
       end;
       Inc(Y, LineHeight);
    end;

    // Matching Data if frmMatching was used
    if Assigned(frmMatching) and (frmMatching.txtCResult.Text <> '') then
    begin
       if Y > Prn.PaperSize.Height div 2 then
       begin
         Prn.NewPage;
         Y := 100;
       end;
       PrintText('Matching Network Data:', True);
       PrintText('Frequency: ' + frmMatching.txtFreq.Text + ' ' + frmMatching.cboUnits.Text);
       PrintText('C Result: ' + frmMatching.txtCResult.Text + ' pF');
       PrintText('L Result: ' + frmMatching.txtLResult.Text + ' uH');
       
       if Assigned(frmMatching.Image1) and Assigned(frmMatching.Image1.Picture.Graphic) and (not frmMatching.Image1.Picture.Graphic.Empty) then
       begin
         Prn.Canvas.StretchDraw(Rect(X, Y, X + (Prn.PaperSize.Width div 3), Y + (Prn.PaperSize.Height div 6)), frmMatching.Image1.Picture.Graphic);
         Inc(Y, (Prn.PaperSize.Height div 6) + LineHeight);
       end;
    end;

  finally
    Prn.EndDoc;
  end;
end;



procedure TForm1.mnmSaveClick(Sender: TObject);
var
      INI: TINIFile;
begin
    SaveDialog1.Filter := 'Filter Files|*.inf' ;
     SaveDialog1.FilterIndex := 1 ;
     SaveDialog1.Execute;
 INI := TINIFile.Create(SaveDialog1.FileName);
 try
   INI.WriteString('Centrer Frequency','Units',IntToStr(cboUnits.ItemIndex));
   INI.WriteString('Centrer Frequency','Freq',txtCF.text);
   INI.WriteString('BandWidth','Units',IntToStr(cbobwUnits.ItemIndex));
   INI.WriteString('BandWidth','Freq',txtBW.text);
   INI.WriteString('Motional','Cap',txtCi.text);
   INI.WriteString('Crystal','Q',txtQ.text);
   INI.WriteString('Harmonic','Units',IntToStr(cboHarmonic.ItemIndex));
   INI.WriteString('Type','Filter Order',IntToStr(cboOrder.ItemIndex));
   INI.WriteString('Type','Filter Type',IntToStr(cboType.ItemIndex));
 finally
 ini.free;
 end;
end;

 procedure TForm1.txtCiKeyPress(Sender: TObject; var Key: char);
begin

  if not (Key in ['0'..'9','.',#8,#9])or (Key = '.') and (pos('.',TEdit(Sender).Text)>0)
  then Key := Char(0);
end;


procedure TForm1.btnCalculateClick(Sender: TObject);

begin
   Check_information();
   if (All_Info) then
   begin
  case Form1.cbotype.ItemIndex of
      0:cheby_1; {chebycev 0.01 db}
      1:cheby_2; {chebycev 0.1 db}
      2:cheby_3; {chebycev 0.5 db}
      3:butter_1; {Butterworth }
      4:Max_flatness; {maximum Flatness}
      5:Linear_Phase;
      6:Gaussian; {Simple Gaussian Design}
      7:Gaussian_6db;
      8:Gaussian_12db;
      9:Legrande;
        end;
        end;
       end;



procedure TForm1.btnExitClick(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TForm1.btnOptimizerClick(Sender: TObject);
var
  AProcess: TProcess;
  path:String;
begin
 Path:=ExtractFilePath(ParamStr(0));
   AProcess := TProcess.Create(nil);

     AProcess.Executable := path+'crystalcalccli.exe';
    // Run the command
    AProcess.Execute;

      AProcess.Free;
end;



procedure TForm1.btnTestClick(Sender: TObject);
begin
  Check_information();
end;


Procedure cheby_1; {chebycev 0.01 db}
begin

 case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
   0:Caluclate_2_pole_Filter(Center_Frequency,1.4829,1.4829,0.7075,Crystal_Q,Bandwidth,Cmotional); {q1=1.4829,qn=1.4829,K12=0.7075 2}
   1:Caluclate_3_pole_Filter(Center_Frequency,1.1811,1.1811,0.6818,0.6818,Crystal_Q,Bandwidth,Cmotional);{q1=1.1811,qn=1.811,K12=0.6818,K23=0.6818}
   2:Caluclate_4_pole_Filter(Center_Frequency,1.0457,1.0457,0.7369,0.5413,0.7369,Crystal_Q,Bandwidth,Cmotional);    {q1=1.0457,qn=1.0457,K12=0.7369,K23=0.5413,K34=0.7369 4}
   3:Calculate_6_Pole_Filter(Center_Frequency,0.9372,0.9372,0.8088,0.55,0.5177,0.55,0.8088,Crystal_Q,Bandwidth,Cmotional);
   4:Caluclate_8_pole_Filter(Center_Frequency,0.8966,0.8966,0.843,0.5673,0.5198,0.5098,0.5198,0.5763,0.843,Crystal_Q,Bandwidth,Cmotional); {q1=0.8966,qn=0,8966,K12=0.843,K23=0.5673,K34=0.5198 Κ45=0,5098 Κ56=0,5198 K67=0.5673 Κ78=0,843 8}

 end;
end;
Procedure cheby_2;  {chebycev 0.1 db}
begin

 case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
   0:Caluclate_2_pole_Filter(Center_Frequency,1.6382,1.6382,0.7106,Crystal_Q,Bandwidth,Cmotional);
   1:Caluclate_3_pole_Filter(Center_Frequency,1.4328,1.4328,0.6818,0.6818,Crystal_Q,Bandwidth,Cmotional);
   2:Caluclate_4_pole_Filter(Center_Frequency,1.3451,1.3451,0.6850,0.5421,0.6850,Crystal_Q,Bandwidth,Cmotional);
   3:Calculate_6_Pole_Filter(Center_Frequency,1.2767,1.2767,0.7145,0.5385,0.5180,0.5385,0.7145,Crystal_Q,Bandwidth,Cmotional);
   4:Caluclate_8_pole_Filter(Center_Frequency,1.2515,1.2515,0.7276,0.5451,0.5160,0.5100,0.5160,0.5451,0.7276,Crystal_Q,Bandwidth,Cmotional);
 end;
end;
Procedure cheby_3;    {chebycev 0.5 db}
begin

 case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
  0:Caluclate_2_pole_Filter(Center_Frequency,1.9497,1.9497,0.7225,Crystal_Q,Bandwidth,Cmotional);
  1:Caluclate_3_pole_Filter(Center_Frequency,1.8636,1.8636,0.6474,0.6474,Crystal_Q,Bandwidth,Cmotional);
  2:Caluclate_4_pole_Filter(Center_Frequency,1.8258,1.8258,0.6482,0.5446,0.6482,Crystal_Q,Bandwidth,Cmotional);
  3:Calculate_6_Pole_Filter(Center_Frequency,1.7962,1.7962,0.6547,0.5326,0.5191,0.5326,0.6547,Crystal_Q,Bandwidth,Cmotional);
  4:Caluclate_8_pole_Filter(Center_Frequency,1.7852,1.7852,0.6580,0.5333,0.5145,0.5106,0.5145,0.5333,0.6580,Crystal_Q,Bandwidth,Cmotional);

 end;
end;
Procedure butter_1;       {Butterworth }
begin

  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
  0:Caluclate_2_pole_Filter(Center_Frequency,1.4142,1.4142,0.7071,Crystal_Q,Bandwidth,Cmotional);
  1:Caluclate_3_pole_Filter(Center_Frequency,1,1,0.7071,0.7071,Crystal_Q,Bandwidth,Cmotional);
  2:Caluclate_4_pole_Filter(Center_Frequency,0.7654,0.7654,0.8409,0.5412,0.8409,Crystal_Q,Bandwidth,Cmotional);
  3:Calculate_6_Pole_Filter(Center_Frequency,0.5176,0.5176,1.1688,0.60505,0.5176,0.6050,1.1688,Crystal_Q,Bandwidth,Cmotional);
  4:Caluclate_8_pole_Filter(Center_Frequency,0.3902,0.3902,1.5187,0.7357,0.5537,0.5098,0.5537,0.7357,1.5187,Crystal_Q,Bandwidth,Cmotional);
  end;
end;
 Procedure Max_Flatness;        {Max Flatness }
  begin

  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
    0:Caluclate_2_pole_Filter(Center_Frequency,0.5755,2.1479,0.8995,Crystal_Q,Bandwidth,Cmotional);
    1:Caluclate_3_pole_Filter(Center_Frequency,0.3374,2.2034,1.7475,0.6868,Crystal_Q,Bandwidth,Cmotional);{q1=0.3374,qn=2.2034,K12=1.7475,K23=0.6868}
    2:Caluclate_4_pole_Filter(Center_Frequency,0.2334,2.2404,2.5239,1.1725,0.6424,Crystal_Q,Bandwidth,Cmotional);
    3:Calculate_6_Pole_Filter(Center_Frequency,0.4145,1.8647,1.9999,0.8105,0.6006,1.2525,3.0377,Crystal_Q,Bandwidth,Cmotional);
    4:Caluclate_8_pole_Filter(Center_Frequency,0.6591,0.2371,2.2644,1.2996,0.6187,0.8859,1.1297,1.4686,2.7026,Crystal_Q,Bandwidth,Cmotional);
    end;
 end;
 Procedure Linear_phase;
  begin
  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
    0:Caluclate_2_pole_Filter(Center_Frequency,0.6480,2.1085,0.8555,Crystal_Q,Bandwidth,Cmotional);
    1:Caluclate_3_pole_Filter(Center_Frequency,0.4328,2.2542,1.4886,0.65232,Crystal_Q,Bandwidth,Cmotional);{q1=0.4328,qn=2.2542,K12=1.4886,K23=0.6523}
    2:Caluclate_4_pole_Filter(Center_Frequency,0.4934,0.7182,1.6320,0.7181,0.7391,Crystal_Q,Bandwidth,Cmotional);
    3:Calculate_6_Pole_Filter(Center_Frequency,0.5898,0.3376,1.9556,1.0009,0.5777,0.9428,1.8719,Crystal_Q,Bandwidth,Cmotional);
    4:Caluclate_8_pole_Filter(Center_Frequency,0.4420,0.1104,2.1899,0.9390,0.5850,1.0006,1.4723,2.3156,5.2219,Crystal_Q,Bandwidth,Cmotional);
    end;
 end;
 Procedure Gaussian;
  begin

  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
    0:Caluclate_2_pole_Filter(Center_Frequency,0.4738,2.1850,0.9828,Crystal_Q,Bandwidth,Cmotional);
    1:Caluclate_3_pole_Filter(Center_Frequency,0.5534,2.4250,1.3299,0.6353,Crystal_Q,Bandwidth,Cmotional);{q1=0.5534,qn=2.4250,K12=1.3299,K23=0.6353}
    2:Caluclate_4_pole_Filter(Center_Frequency,0.2747,0.4083,2.2792,0.7553,0.9896,Crystal_Q,Bandwidth,Cmotional);
    3:Calculate_6_Pole_Filter(Center_Frequency,0.2908,0.1481,2.5283,0.8608,0.6600,1.5303,3.8038,Crystal_Q,Bandwidth,Cmotional);
    4:Caluclate_8_pole_Filter(Center_Frequency,0.2926,0.0876,2.8076,0.9715,0.6274,1.1913,1.8036,2.8842,6.5640,Crystal_Q,Bandwidth,Cmotional);
    end;
 end;
 Procedure Gaussian_6db;
  begin

  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
    0:not_implement;{not defined not_implement}
    1:Caluclate_3_pole_Filter(Center_Frequency,0.4042,2.3380,1.6622,0.6911,Crystal_Q,Bandwidth,Cmotional);
    2:Caluclate_4_pole_Filter(Center_Frequency,0.5700,0.9137,1.6232,0.7984,0.9816,Crystal_Q,Bandwidth,Cmotional);
    3:Calculate_6_Pole_Filter(Center_Frequency,1.0982,0.6446,1.2072,0.9523,0.5502,0.6743,1.1490,Crystal_Q,Bandwidth,Cmotional);
    4:Caluclate_8_pole_Filter(Center_Frequency,1.3602,0.5967,0.9906,1.0245,0.6263,0.6068,0.7151,0.7993,1.2740,Crystal_Q,Bandwidth,Cmotional);
    end;
 end;
 Procedure Gaussian_12db;
  begin

  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
    0:not_implement;{not defined}
    1:Caluclate_3_pole_Filter(Center_Frequency,0.4152,2.3452,1.6314,0.6864,Crystal_Q,Bandwidth,Cmotional);
    2:Caluclate_4_pole_Filter(Center_Frequency,0.4188,0.7657,1.9888,0.8329,0.7396,Crystal_Q,Bandwidth,Cmotional);
    3:Calculate_6_Pole_Filter(Center_Frequency,0.7280,0.4426,1.9169,1.1881,0.6051,0.8844,1.5958,Crystal_Q,Bandwidth,Cmotional);
    4:Caluclate_8_pole_Filter(Center_Frequency,1.1363,0.3993,1.5295,1.3873,0.6744,0.7699,0.9408,1.1096,1.8132,Crystal_Q,Bandwidth,Cmotional);
    end;
 end;
  Procedure Legrande;
  begin

  case Form1.cboOrder.ItemIndex of   {Anatol Sverev k q values}
    0:not_implement;{Not defined}
    1:Caluclate_3_pole_Filter(Center_Frequency,1.1737,2.1801,0.7933,0.5821,Crystal_Q,Bandwidth,Cmotional);{q1=1.1737,qn=2.1801,K12=0.7933,K23=0.5821}
    2:Caluclate_4_pole_Filter(Center_Frequency,1.0828,1.5642,0.7908,0.5880,0.5713,Crystal_Q,Bandwidth,Cmotional);
    3:Calculate_6_Pole_Filter(Center_Frequency,1.2732,1.0631,0.7271,0.6070,0.4925,0.5097,0.7426,Crystal_Q,Bandwidth,Cmotional);
    4:Caluclate_8_pole_Filter(Center_Frequency,1.3603,0.8879,0.6912,0.6034,0.5128,0.4966,0.5031,0.5512,0.8428,Crystal_Q,Bandwidth,Cmotional);
    end;
 end;
 Procedure Caluclate_2_pole_Filter(fc,q1,q2,K12,Q,Bw,Cmotional:Real);
var
f1,f2,fm,Qinf,wmega,fa1,fa2,L1,L2,L,Rtemp,Ctemp,Rin,Cint,R,Rcrystal1,Rcrystal2
:Real;
begin

f1:=fc-(Bw/2);
f2:=fc+(Bw/2);
fm:=Sqrt(f1*f2);
wmega:=fc/Bw; {Alpha=wmega}
Qinf:=Q/wmega;
fa1:=fm-((Bw/2)*((1/q1)-(1/Qinf)+K12));
Unit1.Form2.txtCrystal1.text:=FloatToStr(Round(fa1));
fa2:=fm-((Bw/2)*((1/q1)-(1/Qinf)-K12));
Unit1.Form2.txtCrystal2.text:=FloatToStr(Round(fa2));
L1:=1/(4*Power(3.14,2)*Power(fa1,2)*Cmotional);{Crystal Measurements}
L2:=1/(4*Power(3.14,2)*Power(fa2,2)*Cmotional);{Crystal Measurements}
L:=(L1+L2)/2; {seems more accurate}
Rtemp:=2*3.14*Bw*L;
Ctemp:=1/(2*Power(3.14,2)*Bw*fm*L);
Rin:=2*Rtemp*((1/q1)-(1/Qinf));
Cint:=Ctemp/(2*((1/q1)-(1/Qinf)));{Cin = Cout}
R:=Rin/2; {input and output impedance correction}
//crystal measurements}
Rcrystal1:=(2*3.14*fm*L1)/Q;
Rcrystal2:=(2*3.14*fm*L2)/Q;
AssignFile(f,'Manufacture_Data.txt');
try
Append(f);
try
Writeln(f,'Crystal 1 Frequency = '+FloatToStr(Round(fa1))+' in Hz');
Writeln(f,'Crystal 2 Frequency = '+FloatToStr(Round(fa2))+' in Hz');
Writeln(f,'Crystal Resistalnce = '+FloatToStr(Round(Rcrystal1))+' in Ohm');
finally
Close(f);
end;
except
   on E:Exception do
     ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;

Unit1.Form2.txtCrystal5.Text:=FloatToStr(round(RCrystal2));
Unit1.Form2.txtCrystal6.Text:=FloatToStr(Round(R));

Unit1.Form2.ShowModal;
end;
  Procedure Caluclate_3_pole_Filter(fc,q1,q2,K12,K23,Q,Bw,Cmotional:Real);
var
f1,f2,f3,fm,Qinf,wmega,fa1,fa2,fa3,L1,L2,L3,L,Rtemp,Ctemp,Rin,Cint,R,Rcrystal1,
Rcrystal2,Rcrystal3:Real;
begin

f1:=fc-(Bw/2);
f2:=fc+(Bw/2);
fm:=Sqrt(f1*f2);
wmega:=fc/Bw; {Alpha=wmega}
Qinf:=Q/wmega;
fa1:=fm-((Bw/2)*((Sqrt(2)*K23)+K12));
filter_3poles.Fiter_3pole.txtCrystal_1_Frequency.Text:=FloatToStr(Round(fa1));
fa2:=fm-((Bw/2)*((Sqrt(2)*K23)-K12));
filter_3poles.Fiter_3pole.txtCrystal_2_Frequency.Text:=FloatToStr(Round(fa2));
fa3:=fm-((Bw/2)*(Sqrt(2)*K23));
filter_3poles.Fiter_3pole.txtCrystal_3_Frequency.Text:=FloatToStr(Round(fa3));
L1:=1/(4*Power(3.14,2)*Power(fa1,2)*Cmotional);{Crystal Measurements}
L2:=1/(4*Power(3.14,2)*Power(fa2,2)*Cmotional);{Crystal Measurements}
L3:=1/(4*Power(3.14,2)*Power(fa3,2)*Cmotional);{Crystal Measurements}
L:=(L1+L2+L3)/3; {seems more accurate}
Rtemp:=2*3.14*Bw*L;
Ctemp:=1/(2*Power(3.14,2)*Bw*fm*L);
Rin:=Rtemp*(2*power(K23,2)+((1/q1)-(1/Qinf)))/(1/q1-1/Qinf);
{Cin=Cout}
Cint:=(Ctemp*Sqrt(2)*K23)/(2*Power(K23,2)*Power((1/q1-1/Qinf),2));

R:=Rin/2; {input and output impedance correction}
//crystal measurements}
Rcrystal1:=(2*3.14*fm*L1)/Q;
Rcrystal2:=(2*3.14*fm*L2)/Q;
Rcrystal3:=(2*3.14*fm*L3)/Q;
AssignFile(f,'Manufacture_Data.txt');
try
Append(f);
try
Writeln(f,'Crystal 1 Frequency = '+FloatToStr(Round(fa1))+' in Hz');
Writeln(f,'Crystal 2 Frequency = '+FloatToStr(Round(fa2))+' in Hz');
Writeln(f,'Crystal 3 Frequency = '+FloatToStr(Round(fa3))+' in Hz');
Writeln(f,'Crystal Resistalnce = '+FloatToStr(Round(Rcrystal1))+' in Ohm');
finally
Close(f);
end;
except
   on E:Exception do
     ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;
filter_3poles.Fiter_3pole.txtCrystal_Resistanse.Text:=FloatToStr(Round((Rcrystal1+Rcrystal2+Rcrystal3)/3));
filter_3poles.Fiter_3pole.txtFilter_Impedance.Text:=FloatToStr(Round(R));
filter_3poles.Fiter_3pole.ShowModal;

end;
 Procedure Caluclate_4_pole_Filter(fc,q1,q4,K12,K23,K34,Q,Bw,Cmotional:Real);
var
fa1,fa2,fa3,fa4,Qinf,fm,L1,L2,L3,L4,L,Rtemp,Ctemp,Rout,Cin,
cs2,cp1,cp2,a,Cout,C23,cap_between,f1,f2:Real;
Rcrystal2,Rcrystal3,Rcrystal4,ctin,ctout,wmega,Rin,Rcrystal1,cs1:Real;
begin
f1 := fc - (Bw/2);
f2 := fc + (Bw/2);
fm := Sqrt(f1*f2);
a := fc/Bw;
Qinf := Q/a;
wmega := fc/Bw;
{For manufacture data}
fa1 := fm - (Bw/2)*(K23 + K12);
fa2 := fm - (Bw/2)*(K23 - K12);
fa3 := fm - (Bw/2)*(K23 + K34);
fa4 := fm - (Bw/2)*(K23 - K34);
Unit2.Form3.txtCrystal_1_Frequency.Text:=FloatToStr(Round(fa1));
Unit2.Form3.txtCrystal_2_Frequency.Text:=FloatToStr(Round(fa2));
L1 := 1/(4*Power(3.14,2)*Power(fa1,2)*Cmotional);
L2 := 1/(4*Power(3.14,2)*Power(fa2,2)*Cmotional);
L3 := 1/(4*Power(3.14,2)*Power(fa3,2)*Cmotional);
L4 := 1/(4*Power(3.14,2)*Power(fa4,2)*Cmotional);
{For manufacture data}
L  := (L1 + L2+ L3 + L4 ) / 4;
Rtemp := 3.14*Bw*L;
Ctemp := 1/(2*Power(3.14,2)*Bw*fm*L);
Rin := Rtemp*(Power(K23,2) + Power((1/q1 - 1/Qinf),2))/(1/q1 - 1/Qinf);
Rout := Rtemp*(Power(K23,2) +Power( (1/q4 - 1/Qinf),2))/(1/q4 - 1/Qinf);
Cin := (Ctemp*K23)/(Power(K23,2) + Power((1/q1 - 1/Qinf),2));
Cout := (Ctemp*K23)/(Power(K23,2) + Power((1/q4 - 1/Qinf),2));
C23 := Ctemp/K23;
Rcrystal1 := (2*3.14*fm*L)/Q;
cs1 := 1/(4*Power(3.14,2)*Power(fa1,2)*L1);
cs2 := 1/(4*Power(3.14,2)*Power(fa3,2)*L2);
cp1 := c0;{(cs1*fm)/(2*Bw); Approximations Cs1 Cs2 Cp1 Cp2. Must contatct with manufacture for C0}
cp2 :=c0;{ (cs2*fm)/(2*Bw);}
ctin:=Cin - (2*cp1);
ctout:=Cout - (2*cp2);
cap_between:=C23 - (2*cp1) - (2*cp2);
AssignFile(f,'Manufacture_Data.txt');
try
append(f);
try
Writeln(f,'Crystal 1 Frequency = '+FloatToStr(Round(fa1))+' in Hz');
Writeln(f,'Crystal 2 Frequency = '+FloatToStr(Round(fa2))+' in Hz');
Writeln(f,'Crystal Resistalnce = '+FloatToStr(Round(Rcrystal1))+' in Ohm');
finally
Close(f);
end;
except
   on E:Exception do
     ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;
Unit2.Form3.txtFilter_Impedance.Text:=FloatToStr(Round(Rout));
Unit2.Form3.txtCap_between_Crystal.Text:=FloatToStr(Round(cap_between*Power(10,12)*Power(10,5))/Power(10,5));
Unit2.Form3.txtCrystal_Resistanse.Text:=FloatToStr(Round(Rcrystal1));
Unit2.Form3.ShowModal;
end;
 Procedure Caluclate_8_pole_Filter(fc,q1,q8,K12,K23,K34,K45,K56, K67, K78,Q,Bw,Cmotional:Real);
 var
 fa1,fa2,fa3,fa4,fa5,fa6,fa7,fa8,Qinf,wmega,f1,f2,fm,L1,L2,L3,L4,L5,L6,L7,L8,L,Rtemp,Ctemp,Rout,Cin,Rin,Rcrystal1,Rcrystal2,Rcrystal3,
Rcrystal4,Rcrystal,cp1,cp2,a,Cout,C23,C67,cap_between,Ws:Real;
 begin
f1 := fc - (Bw/2);
f2 := fc + (Bw/2);
fm := Sqrt(f1*f2);
a := fc/Bw;
Qinf := Q/a;
wmega := fc/Bw;
Ws := a/(10*wmega); {for nomograph}
fa1:=  fm - (Bw/2)*(K23 + K12);
fa2 := fm - (Bw/2)*(K23 - K12);
fa3 := fm - (Bw/2)*(K23 + K34);
fa4 := fm - (Bw/2)*(K23 - K34);
fa5 := fm - (Bw/2)*(K45 + K56);
fa6 := fm - (Bw/2)*(K45 - K56);
fa7 := fm - (Bw/2)*(K45 + K67);
fa8 := fm - (Bw/2)*(K45 - K67);
Filter_8pole.frm8pole.txtCrystal_1_Frequency.text:=FloatToStr(Round(fa1));
Filter_8pole.frm8pole.txtCrystal_2_Frequency.text:=FloatToStr(Round(fa2));
Filter_8pole.frm8pole.txtCrystal_3_Frequency.text:=FloatToStr(Round(fa3));
Filter_8pole.frm8pole.txtCrystal_4_Frequency.text:=FloatToStr(Round(fa4));
L1 := 1/(4*Power(3.14,2)*Power(fa1,2)*Cmotional);
L2 := 1/(4*Power(3.14,2)*Power(fa2,2)*Cmotional);
L3 := 1/(4*Power(3.14,2)*Power(fa3,2)*Cmotional);
L4 := 1/(4*Power(3.14,2)*Power(fa4,2)*Cmotional);
L5 := 1/(4*Power(3.14,2)*Power(fa5,2)*Cmotional);
L6 := 1/(4*Power(3.14,2)*Power(fa6,2)*Cmotional);
L7 := 1/(4*Power(3.14,2)*Power(fa7,2)*Cmotional);
L8 := 1/(4*Power(3.14,2)*Power(fa8,2)*Cmotional);
L := (L1 + L2 + L3 + L4 + L5 + L6 + L7 + L8)/8;
Rtemp := 2*3.14*Bw*L;
Ctemp := 1/(2*Power(3.14,2)*Bw*fm*L);
Rin := Rtemp*(Power(K78,2) + Power((1/q1 - 1/Qinf),2))/(1/q1 - 1/Qinf);
Rout := Rtemp*(Power(K78,2) + Power((1/q8 - 1/Qinf),2))/(1/q8 - 1/Qinf);  {Rin=Rout}

Cin := (Ctemp*K23)/(Power(K23,2) + Power((1/q1 - 1/Qinf),2));  {Capacitance in parallel with filter Impedance for in/out.}
Cout := (Ctemp*K23)/(Power(K23,2) + Power((1/q8 - 1/Qinf),2)); {too small to consider. Matching network will take it out.}
C23 := Ctemp/K23;
C67 := Ctemp/K67;

Rcrystal1 := (2*3.14*fm*L1)/Q;
Rcrystal2 := (2*3.14*fm*L2)/Q;
Rcrystal3 := (2*3.14*fm*L3)/Q;
Rcrystal4 := (2*3.14*fm*L4)/Q;
Rcrystal:=Round((Rcrystal1+Rcrystal2+Rcrystal3+Rcrystal4)/4) ;

{Approximations Cs1 Cs2 Cp1 Cp2. Must contatct with manufacture for C0}
cp1 :=c0;
cp2:=c0;
cap_between:=C23 - 2*cp1 - 2*cp2;
AssignFile(f,'Manufacture_Data.txt');
try
Append(f);
try
Writeln(f,'Crystal 1 Frequency = '+FloatToStr(Round(fa1))+' in Hz');
Writeln(f,'Crystal 2 Frequency = '+FloatToStr(Round(fa2))+' in Hz');
Writeln(f,'Crystal 3 Frequency = '+FloatToStr(Round(fa3))+' in Hz');
Writeln(f,'Crystal 4 Frequency = '+FloatToStr(Round(fa4))+' in Hz');
Writeln(f,'Crystal Resistalnce = '+FloatToStr(Round(Rcrystal1))+' in Ohm');
finally
Close(f);
  end;
except
   on E:Exception do
     ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;
Filter_8pole.frm8pole.txtFilter_Impedance.Text:=FloatToStr(Round(Rout));
Filter_8pole.frm8pole.txtCrystal_Resistanse.Text:=FloatToStr(Rcrystal);
Filter_8pole.frm8pole.txtCap_Between_Crystal.Text:=FloatToStr(Round(Cap_between*Power(10,12)*Power(10,3))/Power(10,3));
Filter_8pole.frm8pole.ShowModal;

 end;
Procedure Caluclate_5_pole_Filter(fc,q1,q5,K12,K23,K34,K45,Q,Bw,Cmotional:Real);{must be checked and corrected}
 var
 fa1,fa2,fa3,fa4,fa5,Qinf,wmega,f1,f2,fs,fm,L1,L2,L3,L4,L5,L,Rtemp,Ctemp,Rout,Cin,Rin,Rcrystal1
 ,Ca,Cb,Cout,a,q23,C67,cap_between,Ws,Lmotional:Real;
 begin
f1 := fc - (Bw/2);
f2 := fc + (Bw/2);
fm := Sqrt(f1*f2);
a := fc/Bw;
Qinf := Q/a;
wmega := fc/Bw;
Ws := a/(10*wmega);
a := fc/Bw;

fa1 := fm - (Bw/2*(K23*Sqrt(2) + K12));
fa2 := fm - (Bw/2*(K23*Sqrt(2) - K12));
fa3 := fm - (Bw/Sqrt(2))*K23;
fa4 := fm - (Bw/2)*(K23*Sqrt(2) + K45);
fa5 := fm - (Bw/2)*(K23*Sqrt(2) - K45);

L1 :=1/(4*Power(3.14,2)*Power(fa1,2)*Cmotional);
L2 := 1/(4*Power(3.14,2)*Power(fa2,2)*Cmotional);
L3 :=1/(4*Power(3.14,2)*Power(fa3,2)*Cmotional);
L4 :=1/(4*Power(3.14,2)*Power(fa4,2)*Cmotional);
L5 :=1/(4*Power(3.14,2)*Power(fa5,2)*Cmotional);
Lmotional := (L1+L2+L3+L4+L5)/5;{Maybe better Results}
{Lmotional := 1/(4*Power(3.14,2)*Power(fc,2)*Cmotional);Not So accurate}
q23 := 1/(2*3.14*Bw*Lmotional);
Rtemp:= 3.14*Lmotional*Bw;
Ctemp := 1/(2*Power(3.14,2)*Bw*fm*Lmotional);
RCrystal1:=(2*3.14*fm*Lmotional)/Q;
Cin :=Ctemp *(K23*Sqrt(2)/(2*Power(K23,2) + (1/q1) - (1/Qinf)));
Cout:= Ctemp *(K23*Sqrt(2)/(2*Power(K23,2) + (1/q5) - (1/Qinf)));
Ca := Ctemp*(1/Sqrt(2))/(K23 + K34);{between cystal capacitance}
{Cb := Ctemp*(K34/Sqrt(2))/(Power(K23,2) - Power(K34,2));
Shunt  capacitance for Pi network.Must be replaces with LC}
Rin :=Rtemp*(2*Power(K23,2) + Power((1/q1) - (1/Qinf),2))/((1/q1) - (1/Qinf));
Rout :=Rtemp*(2*Power(K23,2) + Power((1/q5) - (1/Qinf),2))/((1/q5) - (1/Qinf));
{$I-}
AssignFile(f,'Manufacture_Data.txt');
{$I+}
try
Append(f);
try
Writeln(f,'Crystal 1 Frequency = '+FloatToStr(Round(fa1))+' in Hz');
Writeln(f,'Crystal 2 Frequency = '+FloatToStr(Round(fa2))+' in Hz');
Writeln(f,'Crystal 3 Frequency = '+FloatToStr(Round(fa3))+' in Hz');
Writeln(f,'Crystal Resistalnce = '+FloatToStr(Round(Rcrystal1))+' in Ohm');
finally
Close(f);

 end;
  except
    on E:Exception do
      ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
       end;
end;
  Procedure Calculate_6_Pole_Filter(fc,q1,q4,K12,K23,K34,K45,K56,Q,Bw,Cmotional:Real);{Tp be corrected and checked}
  var
  fm, wmega, Ws, L, fa1,f1,f2,C23,C45,Rcrystal1,Rcrystal2,Rcrystal3,
  Rcrystal4,cs1,cs2,cs5,cs6,cp1,cp2,cp3,cp4,cp5,cp6,Ctot,Couttot,CBetween_Crystals,
  fa2, fa3, fa4,fa5,fa6, L1, L2, L3, L4,L5,L6, a, Qinf, Rtemp, Ctemp, Cin, Cout,
  Rin, Rout:Real;
  begin

f1 := fc - (Bw/2);
f2 := fc + (Bw/2);
fm := Sqrt(f1*f2);
a := fc/Bw;
Qinf := Q/a;
wmega := fc/Bw;

fa1 := fm - (Bw/2)*(K23 + K12);
fa2 := fm - (Bw/2)*(K23 - K12);
fa3 := fm - (Bw/2)*(K23 + K34);
fa4 := fm - (Bw/2)*(K23 - K34);
fa5 := fm - (Bw/2)*(K45 + K56);
fa6 := fm - (Bw/2)*(K45 - K56);
Filter_6poles.frm6Pole.txtCrystal_1_Frequency.Text:= FloatToStr(Round(fa1));
Filter_6poles.frm6Pole.txtCrystal_2_Frequency.Text:= FloatToStr(Round(fa2));
Filter_6poles.frm6Pole.txtCrystal_3_Frequency.Text:= FloatToStr(Round(fa3));
Filter_6poles.frm6Pole.txtCrystal_4_Frequency.Text:= FloatToStr(Round(fa4));


L1:= 1/(4*Power(3.14,2)*Power(fa1,2)*Cmotional);
L2 := 1/(4*Power(3.14,2)*Power(fa2,2)*Cmotional);
L3 := 1/(4*Power(3.14,2)*Power(fa3,2)*Cmotional);
L4 := 1/(4*Power(3.14,2)*Power(fa4,2)*Cmotional);
L5 := 1/(4*Power(3.14,2)*Power(fa5,2)*Cmotional);
L6 := 1/(4*Power(3.14,2)*Power(fa6,2)*Cmotional);
L := (L1 + L2 + L3 + L4 +L5 + L6 )/6;
Rtemp := 2*3.14*Bw*L;
Ctemp := 1/(2*Power(3.14,2)*Bw*fm*L);
Rin := Rtemp*(Power(K23,2) + Power((1/q1 - 1/Qinf),2))/(1/q1 - 1/Qinf);
Rout := Rtemp*(Power(K23,2) + Power((1/q4 - 1/Qinf),2))/(1/q4 - 1/Qinf);
Cin := (Ctemp*K23)/(Power(K23,2) + Power((1/q1 - 1/Qinf),2));
Cout := (Ctemp*K23)/(Power(K23,2) + Power((1/q4 - 1/Qinf),2));
C23 := Ctemp/K23; {sverev circuit only 4 pole}
C45 := Ctemp/K45; {sverev circuit only 2 pole}
Rcrystal1 := (2*3.14*fm*L)/Q;
Filter_6poles.frm6Pole.txtCrystal_Resistanse.text:=FloatToStr(Round(Rcrystal1));
Ctot:=Cin - (2*c0);
Couttot:=Cout - (2*c0);
Cbetween_Crystals :=C23 - 2*c0 - 2*c0; {in case you have crystals and does not have the same electrode you must change this}
 Filter_6poles.frm6Pole.txtCap_Between_Crystal.Text:=FloatToStr(Round(Cbetween_Crystals*Power(10,12)*Power(10,3))/Power(10,3));
 Filter_6Poles.frm6Pole.txtFilter_Impedance.Text:=FloatToStr(Round(Rout));
C45 :=C45 - 2*c0 - 2*c0;
{$I-}
AssignFile(f,'Manufacture_Data.txt');
{$I+}
try
append(f);
try
Writeln(f,'Crystal 1 Frequency = '+FloatToStr(Round(fa1))+' in Hz');
Writeln(f,'Crystal 2 Frequency = '+FloatToStr(Round(fa2))+' in Hz');
Writeln(f,'Crystal 3 Frequency = '+FloatToStr(Round(fa3))+' in Hz');
Writeln(f,'Crystal 4 Frequency = '+FloatToStr(Round(fa4))+' in Hz');
Writeln(f,'Crystal Resistalnce = '+FloatToStr(Round(Rcrystal1))+' in Ohm');
finally
Close(f);
end;
except
   on E:Exception do
     ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;
Filter_6poles.frm6Pole.ShowModal;
  end;
Procedure Check_information; {Here make checks for all input and make the computation for manufacture data}
{All calculation is approximation. It is up to manufacture to confirm the manufacturability of the component}
var
INI:TINIFile;
 Electrode_Diameter,Electrode_Area,Diameter,PlateBack,temp:Real;
 ButtonSelect,Harmonic:integer;
 fs: TFormatSettings;
flag:Boolean;
begin
fs := DefaultFormatSettings;
fs.DecimalSeparator := '.';
flag:=False;
all_info:=True;
 Form1.Memo1.Clear;

  if Form1.txtcf.Text ='' then
   begin
   showmessage('Enter Center Frequency');
   flag:=True;
   Form1.txtcf.setfocus;
   Exit;
   end;

   if Form1.txtBW.text ='' then
   begin
   ShowMessage('Enter Bandwidth');
    flag:=True;
   Form1.txtbw.setfocus;
    Exit;
   end;

   if Form1.txtCi.text ='' then
   begin
     ShowMessage('Enter Motional Capacitance');
     flag:=True;
   Form1.txtCi.setfocus;
   Exit;
   end;

   if Form1.txtQ.text ='' then
   begin
    ShowMessage('Enter Crystal Q ');
    flag:=True;
   Form1.txtQ.setfocus;
    Exit;
   end;



    if flag=False then
    begin
    if not TryStrToFloat(Form1.txtBw.Text, BandWidth, fs) then
    begin
       fs.DecimalSeparator := ',';
       if not TryStrToFloat(Form1.txtBw.Text, BandWidth, fs) then
       begin
         ShowMessage('Invalid Bandwidth format');
         Exit;
       end;
    end;

    fs.DecimalSeparator := '.';
    if not TryStrToFloat(Form1.txtcf.Text, Center_Frequency, fs) then
    begin
       fs.DecimalSeparator := ',';
       if not TryStrToFloat(Form1.txtcf.Text, Center_Frequency, fs) then
       begin
         ShowMessage('Invalid Center Frequency format');
         Exit;
       end;
    end;

    fs.DecimalSeparator := '.';
    if not TryStrToFloat(Form1.txtQ.Text, Crystal_Q, fs) then
    begin
       fs.DecimalSeparator := ',';
       if not TryStrToFloat(Form1.txtQ.Text, Crystal_Q, fs) then
       begin
         ShowMessage('Invalid Crystal Q format');
         Exit;
       end;
    end;

    fs.DecimalSeparator := '.';
    if not TryStrToFloat(Form1.txtCi.Text, Cmotional, fs) then
    begin
       fs.DecimalSeparator := ',';
       if not TryStrToFloat(Form1.txtCi.Text, Cmotional, fs) then
       begin
         ShowMessage('Invalid Motional Capacitance format');
         Exit;
       end;
    end;

    Cmotional:=Cmotional*Power(10,-15);
    Harmonic:=Form1.cboHarmonic.ItemIndex;
    end;
    case Form1.cboHarmonic.ItemIndex of
    0: Harmonic:=1;
    1:Harmonic:=3;
    2:Harmonic:=5;
    end;
   case Form1.cboBwunits.ItemIndex of
         0: BandWidth:=BandWidth*1;
         1: BandWidth:=BandWidth*1000;
         2:BandWidth:=BandWidth*1000000;
    end;
      case Form1.cbounits.ItemIndex of
         0: Center_Frequency:=Center_Frequency*1;
         1: Center_Frequency:=Center_Frequency*1000;
         2:Center_Frequency:=Center_Frequency*1000000;
    end;
   if BandWidth > Center_Frequency then
   begin
   Form1.txtBw.text:='';
   ShowMessage('Bandwidth could not be larger than center Frequency.Please enter again both');
   Form1.txtBw.setfocus;
   exit;
    end;
   if Bandwidth>(0.1*Center_Frequency) then
   begin
    ButtonSelect := Messagedlg('Question','The Bandwidth exceed the therotically 10%. All filter characterictis may be inaccurate. Do you Want to contiune?',mtError, mbOKCancel, 0);
    if ButtonSelect=mrCancel then exit;
   end;

    if (Form1.txtQ.Text<>'') and (flag=False) then
    begin
    { Crystal_Q is already parsed as Real above }
       Crystal_Q:=Crystal_Q*1000;
       if  (Crystal_Q<=60000) then
    if  (Form1.cboharmonic.ItemIndex>=1) then
       begin
    Form1.txtQ.text:='';
    Form1.txtQ.SetFocus;
    ShowMessage('Crystal Q for Fundamental from 1.000 - 50.000 , 3rd-5th overtone from 60.000 to 150.000 ');
     Exit;
      end ;
  if flag then all_info:=False;

    if (Crystal_Q>=51000) then
       if (Form1.cboharmonic.ItemIndex=0) then
          begin
          Form1.txtQ.text:='';
    Form1.txtQ.SetFocus;
    ShowMessage(FloatToStr(Crystal_Q));
    ShowMessage('Crystal Q for Fundamental from 1.000 - 50.000 , 3rd-5th overtone from 60.000 to 150.000 ');
     Exit;
    end;
       end;

    if (Form1.cbotype.ItemIndex>=7) and ( Form1.cboorder.ItemIndex=0) then
     begin
     Form1.cboorder.SetFocus;
     Form1.cboorder.ItemIndex:=1;
     ShowMessage('For Gaussian -6db , Gaussian 12db , Legrand does not defined the 2th order filter. Please select higher order');
     Exit;
     end;

    INI := TINIFile.Create('Temp.ini');
     try
  INI.WriteString('Centrer Frequency','Units',IntToStr(Form1.cboUnits.ItemIndex));
  INI.WriteString('Centrer Frequency','Freq',Form1.txtCF.text);
  INI.WriteString('BandWidth','Units',IntToStr(Form1.cbobwUnits.ItemIndex));
  INI.WriteString('BandWidth','Freq',Form1.txtBW.text);
  INI.WriteString('Motional','Cap',Form1.txtCi.text);
  INI.WriteString('Crystal','Q',Form1.txtQ.text);
  INI.WriteString('Harmonic','Units',IntToStr(Form1.cboHarmonic.ItemIndex));
  INI.WriteString('Type','Filter Order',IntToStr(Form1.cboOrder.ItemIndex));
  INI.WriteString('Type','Filter Type',IntToStr(Form1.cboType.ItemIndex));
finally
ini.free;
end;
    if flag=False then begin
      Form1.memo1.Lines.Add('Center Frequency '+FloatToStr(Center_Frequency));
      Form1.memo1.Lines.Add('Ci = '+Form1.txtCi.text+' fP');
      Electrode_Diameter:=Electrode(Center_Frequency/Power(10,6),Cmotional*Power(10,15));
      Electrode_Area:=Electrode_Diameter;{need for C0 Calculations}
      Form1.memo1.Lines.Add('Electrode = '+FloatToStr(Electrode_Diameter));  {Here is electrode Area}
      Electrode_Diameter:=Sqrt(Electrode_Diameter/3.14);{Radius of circle}
      Electrode_Diameter:=Electrode_Diameter*2;{Actual diameter}
      Diameter:=Electrode_Diameter*100;{Make it in Cm}
      Form1.memo1.Lines.Add('Electrode diameter (in mm) = '+(FloatToStr(Electrode_Diameter*1000)));
      Electrode_Diameter:=Electrode_Diameter* 39370.078740157;
      Form1.memo1.Lines.Add('Electrode diameter (in mils) = '+FloatToStr(Electrode_Diameter)); {This value must be round it to be manufacturable}
      c0:=Calculate_C0(Center_Frequency,Electrode_Area,Harmonic);
      Form1.memo1.Lines.Add('C0 = '+FloatToStr(C0));
      PlateBack:=(Center_Frequency*2.98)/Power(Harmonic,2);{Approximation type is center_frequency(Hz)*2.98*(blank thickness(cm)/electrode diameter (cm))}
      Temp:=(1660/Center_Frequency)*10;{from mm to cm}
      PlateBack:=PlateBack*Power((Temp/(Diameter)),2);
      PlateBack:=Round((Plateback/Power(10,3))*100); {Result in KHz}
      Form1.memo1.Lines.Add('Maximum Plateback = '+FloatToStr(PlateBack)+'KHz');
     if form1.cboOrder.ItemIndex=1 then form1.Memo1.lines.add('Center Crystal Ci = '+floatToStr(StrTofloat(Form1.txtCi.text)*1.5)+'  Center crystal must have different mask about 1.5 bigger up to 2.2');

      try

        {$I-}
      AssignFile(f,'Manufacture_Data.txt');
        {$I+}
      Rewrite(f);
      try
      Writeln(f,'Manufacture Data ');
      Writeln(f,'Center Frequency = '+FloatToStr(Center_Frequency)+' in Hz');
      Writeln(f,'Bandwidth (-3d) = '+FloatToStr(Bandwidth)+' in Hz');
      Writeln(f,'Crytsal Harmonic = '+Form1.cboharmonic.Text);
      {Writeln(f,'Motional Capacitance = '+FloatToStr(Cmotional));}
      Writeln(f,'Electrode Diameter = '+FloatToStr(Electrode_Diameter)+' in mils');
      Writeln(f,'Recommented PlateBack = ',FloatToStr(PlateBack));
      finally
      CloseFile(f);
      end;
        except
   on E:Exception do
     ShowMessage('File Manufacture_Data.txt could not be read or written because: '+E.ClassName+' / '+ E.Message);
      end;


end;
end; procedure not_implement;


 begin
    with  Form1 do
    begin
    cbounits.ItemIndex:=2;
    cbobwunits.ItemIndex:=0;
    cboharmonic.ItemIndex:=0;
    cbotype.itemIndex:=0;
    cboOrder.itemIndex:=0;
    txtCF.Text:='';
    txtBW.Text:='';
    txtCi.Text:='';
    txtQ.Text:='';
    cboOrder.setfocus;
 end;
    ShowMessage('This feauture has not implement yet');
    end;
End.
