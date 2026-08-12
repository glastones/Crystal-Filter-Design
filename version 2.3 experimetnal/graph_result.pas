unit Graph_Result;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, TAGraph,
  TASeries;

type

  { TGraph_Results }

  TGraph_Results = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;


    procedure Button1Click(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Graph_Results: TGraph_Results;
  filename:String;

implementation
 uses Filter;
{$R *.lfm}

{ TGraph_Results }

procedure TGraph_Results.FormCreate(Sender: TObject);
var
  f:TextFile;
  temp_String:String;
  sa:TstringArray;
  count:ShortInt;

  x,y:real;
begin
filename:='';
chart1.Color:=clSilver;
chart1.AllowZoom:=True;
chart1.AxisVisible:=True;
chart1.Height:=Round(Graph_Results.Height-10);
chart1.Width:=Round( Graph_Results.width-10);
case Filter.Form1.cboOrder.ItemIndex of
       0: filename := '2_Pole_Response.csv';
       2: filename := '4_Pole_Response.csv';
       3: filename := '6_Pole_Response.csv';
       4: filename := '8_Pole_Response.csv';
end;
 if ((not FileExists(filename)) or (filename.IsEmpty)) then begin
 showmessage ('Not simulation data. You must run the simulation First');
 exit();
 end
 else
 begin
   assignFile(f,filename);
   reset(f);
    while not eof(f) do
   begin
     ReadLn(f, temp_string);
     sa := temp_string.Split([',',' ']);

     count := 1;
     while count < Length(sa) - 1 do
     begin
       if not TryStrToFloat(sa[count], x) then break;
       if not TryStrToFloat(sa[count+1], y) then break;


       Chart1LineSeries1.AddXY(x, y);

       Inc(count, 2);  // move to next pair
     end;
   end;
    end;
   closeFile(f);

end;



procedure TGraph_Results.FormChangeBounds(Sender: TObject);
begin
 chart1.Height:=Round(Graph_Results.Height div 2);
chart1.Width:=Round( Graph_Results.width div 2);
chart1.Height:=Round(Graph_Results.Height div 2);
chart1.Width:=Round( Graph_Results.width div 2);
chart1.Left:=Round((Graph_Results.width - chart1.width) div 2);
chart1.Top:=Round((Graph_Results.height-chart1.height) div 2);
end;

procedure TGraph_Results.Button1Click(Sender: TObject);
begin
    end;



end.

