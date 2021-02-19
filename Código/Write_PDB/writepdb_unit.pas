unit WritePDB_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p:TPDB;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  nomfi: string;
begin
  nomfi:= cargarPDB(p);
  if nomfi <>'' then
  begin
  edit1.text:= nomfi;
  memo1.lines.LoadFromFile(edit1.text);
  end else
  begin
    edit1.text:='';
    memo1.clear;

  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
n:integer;
begin
  memo2.clear;
  memo2.visible:=false;
for n:=1 to p.NumFichas do
begin
if p.atm[n].ID='CA' then memo2.lines.add(writePDB(p.atm[n]));
end;
memo2.visible:=true;
  if SaveDialog1.execute then
    memo2.lines.SaveToFile(SaveDialog1.FileName);
end;

end.

