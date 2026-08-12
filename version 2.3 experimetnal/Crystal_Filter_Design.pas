program Crystal_Filter_Design;


{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, Filter, Unit1, Unit2, frmAbout, matching,
  Filter_8pole, SimFunctions, Misc_Functions, Filter_6poles, Order,LCLType,
  printers, Convert, filter_3poles, Graph_Result, tachartlazaruspkg
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TfrmAbout, frmAbouts);
  Application.CreateForm(TfrmMatching, frmMatching);
  Application.CreateForm(Tfrm8pole, frm8pole);
  Application.CreateForm(Tfrm6Pole, frm6Pole);
  Application.CreateForm(TfrmOrder, frmOrder);
  Application.CreateForm(TfrmConvert, frmConvert);
  Application.CreateForm(TFiter_3pole, Fiter_3pole);
  Application.CreateForm(TGraph_Results, Graph_Results);
  Application.Run;
end.

