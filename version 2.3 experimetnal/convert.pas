unit Convert;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  Misc_functions;

type

  { TfrmConvert }

  TfrmConvert = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    Label1: TLabel;
    lblFirst: TLabel;
    lblSecond: TLabel;
    lblThird: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);

  private

  public
  indexing:Integer;
  end;

var
  frmConvert: TfrmConvert;

implementation
   var
     Types,Order,BWUnits:Integer;
     BandWidth:Real;
{$R *.lfm}

{ TfrmConvert }

procedure TfrmConvert.FormCreate(Sender: TObject);
begin
    FloatSpinEdit1.Value:=1;
    FloatSpinEdit2.Value:=50;
    Edit3.Text:=' ';

  if indexing=1 then
    begin
    lblFirst.Caption:='dbm';
    lblSecond.Caption:='Impedance';
    lblThird.Caption:='Volt';
    end;
  if indexing=2 then
    begin
    lblFirst.Caption:='Volt';
    lblSecond.Caption:='Impedance';
    lblThird.Caption:='dbm';
    end;

end;

procedure TfrmConvert.FormPaint(Sender: TObject);
begin
   if indexing=1 then
    begin
    lblFirst.Caption:='dbm';
    lblSecond.Caption:='Impedance';
    lblThird.Caption:='Volt';
    end;
  if indexing=2 then
    begin
    lblFirst.Caption:='Volt';
    lblSecond.Caption:='Impedance';
    lblThird.Caption:='dbm';
    end;
end;

procedure TfrmConvert.Button2Click(Sender: TObject);
begin
  close;
end;



procedure TfrmConvert.Button1Click(Sender: TObject);

begin

  if indexing=1 then
    begin
    Edit3.Text:=FloatToStr(Misc_Functions.dbm_to_volt(FloatSpinEdit2.Value,FloatSpinEdit1.Value));
    end;
  if indexing=2 then
    begin
    Edit3.Text:=FloatToStr(Misc_Functions.volt_to_dbm(FloatSpinEdit1.value,FloatSpinEdit2.value));
    end;
end;

end.

