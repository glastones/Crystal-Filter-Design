unit frmAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  fileinfo, winpeimagereader {need this for reading exe Informations}
  , elfreader {needed for reading ELF executables}
  , machoreader;
type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    memoCredits: TMemo;
    MemoInformations: TMemo;
    memoInstructions: TMemo;
    pgPages: TPageControl;
    TabControl1: TTabControl;
    About: TTabSheet;
    Informations: TTabSheet;
    Instructions: TTabSheet;
    TabSheet1: TTabSheet;
    Credits: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure pgPagesChange(Sender: TObject);
  private

  public

  end;

var
  frmAbouts: TfrmAbout;

implementation
 var
   Pages:Integer;
{$R *.lfm}

{ TfrmAbout }

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  FileVerInfo: TFileVersionInfo;
  str:String;
  begin
  pages:=1;
  FileVerInfo:=TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
     pgPages.ActivePage:=About;
    Memo1.Lines.Clear;
    str:='Company: '+(FileVerInfo.VersionStrings.Values['CompanyName']);
    Memo1.Lines.Add(str);
    str:='File description: '+FileVerInfo.VersionStrings.Values['FileDescription'];
    memo1.Lines.Add(str);
    str:='FileVersion'+FileVerInfo.VersionStrings.Values['FileVersion'];
    memo1.Lines.Add(str);
    str:='Internal name: '+FileVerInfo.VersionStrings.Values['InternalName'];
    memo1.Lines.Add(str);
    str:='Legal copyright: '+FileVerInfo.VersionStrings.Values['LegalCopyright'];
    memo1.Lines.Add(str);
    str:='Original filename: '+FileVerInfo.VersionStrings.Values['OriginalFilename'];
    memo1.Lines.Add(str);
    str:='Product name: '+FileVerInfo.VersionStrings.Values['ProductName'];
    memo1.Lines.Add(str);
    str:='Product version: '+FileVerInfo.VersionStrings.Values['ProductVersion'];
    memo1.Lines.Add(str);
  finally
    FileVerInfo.Free;
  end;

end;





procedure TfrmAbout.pgPagesChange(Sender: TObject);

  begin
  pages:=pages+1;
  case pages of
  1:pgPages.ActivePage:=About;
  2:pgPages.ActivePage:=Informations;
  3:pgPages.ActivePage:=Instructions;
  4:pgPages.ActivePage:=TabSheet1;
  end;
  if pages>=4 then pages:=0;
  end;

end.

