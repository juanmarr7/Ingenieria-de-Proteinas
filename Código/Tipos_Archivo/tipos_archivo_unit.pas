unit Tipos_archivo_unit;

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
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p1:TPDB;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    memo1.clear;
    memo1.lines.loadfromfile(opendialog1.filename);
    edit2.text:=opendialog1.filename;
    p1:= CargarPDB(memo1.lines);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
tipo: string;
secuencia: string;
p:TPDB;
linea:string;
n, primera, ultima: integer;

begin
tipo:='No se detecta el tipo de archivo';
if (copy(memo1.lines[0],0,6)='HEADER') then tipo:= 'PDB'
else if  (copy(memo1.lines[0],0,5)='LOCUS') then tipo:= 'GenBank'
else if  (copy(memo1.lines[1],0,2)='AC') then tipo:= 'Uniprot'
else if  (copy(memo1.lines[1],0,2)='XX')then tipo:='Emsemble';
edit1.caption:= tipo;

if tipo='PDB' then
begin
  secuencia:=p1.secuencia;
  memo2.lines[0]:= secuencia;

end else if tipo='GenBank' then
begin
for n:= 0 to memo1.lines.count-1 do
begin
 if copy(memo1.lines[n],22,13)= '/translation=' then primera:=n;
 if copy(memo1.lines[n],0,6)= 'ORIGIN' then ultima:=n;
end;
for n:= primera to ultima-1 do
secuencia:= secuencia + trim(memo1.lines[n]);
secuencia:= copy(secuencia,15,length(secuencia)-14);
memo2.lines[0]:= secuencia;
end  else if tipo='Uniprot' then
begin
  for n:= 0 to memo1.lines.count-1 do
  begin
  if copy(memo1.lines[n],0,2)= 'SQ' then primera:=n+1;
  end;
for n:=primera to (memo1.lines.count-2) do
secuencia:=secuencia+trim(memo1.lines[n]);
memo2.lines[0]:= secuencia;


end;
end;
end.
