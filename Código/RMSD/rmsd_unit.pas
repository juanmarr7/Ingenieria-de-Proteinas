unit RMSD_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  p:TPDB;
  datos:TTablaDatos;
implementation

{$R *.lfm}

{ TForm1 }

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
n: integer;
j: integer;
k: integer;
begin
  for n:=0 to p.NumResiduos-1 do
  begin


    if (p.res[n].ID3='CYS') and (memo2.lines[2] = '') then
    begin
    memo2.lines.add((inttostr(p.res[n].NumRes)));


end;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
  var
h, j, k, m, n: integer;
d: real;

begin
  for h:=0 to 2 do
  begin
  d:=0;
  m:=0;
  n:=0;
  setlength(datos,6,6);
  for j:=p.res[strtoint(memo2.lines[h])].Atm1 to p.res[strtoint(memo2.lines[h])].AtmN do
  begin
  for k:=p.res[strtoint(memo2.lines[h])].Atm1 to p.res[strtoint(memo2.lines[h])].AtmN do
  begin
  datos[m,n]:= distancia(p.atm[j].coor, p.atm[k].coor);
  d:=d + datos[m,n];
  memo3.visible:=false;
  memo3.lines.add(floattostr(d));



  n:=n+1;
  end;
  m:=m+1;
end;

end;
  memo4.lines.add('RMSD 1-2: ' + floattostr(sqrt(sqr((strtofloat(memo3.lines[35])-(strtofloat(memo3.lines[71])))))/6));
  memo4.lines.add('RMSD 1-3: ' + floattostr(sqrt(sqr((strtofloat(memo3.lines[35])-(strtofloat(memo3.lines[107])))))/6));
  memo4.lines.add('RMSD 2-3: ' + floattostr(sqrt(sqr((strtofloat(memo3.lines[71])-(strtofloat(memo3.lines[107])))))/6));

end;

end.
end;

procedure TForm1.Memo3Change(Sender: TObject);
begin

end;



