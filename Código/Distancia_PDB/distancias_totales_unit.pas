unit Distancias_totales_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, Biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p1: TPDB;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    memo1.clear;
    memo1.lines.loadfromfile(opendialog1.filename);
    edit1.text:=opendialog1.filename;
    p1:= CargarPDB(memo1.lines);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  j:integer;
  linea:string;
begin
  memo2.clear;
  memo2.visible:=False;
  for j:= 0 to memo1.lines.count-1 do
  begin
    linea:= memo1.lines[j];
    if (copy(linea,1,6)='ATOM  ') and ( copy(linea,14,4)='CA  ')
      then memo2.lines.add(linea);
  end;
  memo2.visible:=True;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  atom1, atom2: string;
  num1, num2: string;
  linea: string;
  j: integer;
  x1, x2, y1, y2, z1, z2, resultado: real;
  atom1OK, atom2OK: boolean;
  p1,p2:TPunto;



begin
  atom1OK:=false;
  atom2OK:=false;
  num1:=inttostr(spinedit1.value);
  num2:=inttostr(spinedit2.value);
  for j:= 0 to memo1.lines.count-1 do
  begin
    linea:=memo1.lines[j];
    if (copy(linea,1,6)='ATOM  ')
      and (trim(copy(linea,7,5))=num1) then
      begin
        atom1:=linea;
        atom1OK:=true;

      end;
    if (copy(linea,1,6)='ATOM  ')
      and (trim(copy(linea,7,5))=num2) then
        begin
          atom2:=linea;
          atom2OK:=true;

        end;

  end;
  if atom1OK and atom2OK then
      begin
        decimalseparator:='.' ;
        p1.x:=strtofloat(trim(copy(atom1,31,8)));
        p2.x:=strtofloat(trim(copy(atom2,31,8)));
        p1.y:=strtofloat(trim(copy(atom1,39,8)));
        p2.y:=strtofloat(trim(copy(atom2,39,8)));
        p1.z:=strtofloat(trim(copy(atom1,47,8)));
        p2.z:=strtofloat(trim(copy(atom2,47,8)));

        resultado:= distancia (p1,p2);
        label3.caption:=label3.caption + floattostr(resultado);
      end else showmessage('Uno o mas atomos son erroneos');




end;

procedure TForm1.Button4Click(Sender: TObject);
var
  atm1: integer;

begin
  atm1:= spinedit1.value;
  memo2.clear;
  memo2.lines.add('----------------------------');
  memo2.lines.add('     Datos del átomo: ' + inttostr(atm1));
  memo2.lines.add('----------------------------');
  memo2.lines.add('');
  memo2.lines.add(' Número de serie del átomo: '    + inttostr(p1.atm[atm1].NumAtom));
  memo2.lines.add(' Símbolo PDB del átomo: '        + p1.atm[atm1].ID);
  memo2.lines.add(' Aminoácido al que pertenece: '  + p1.atm[atm1].Residuo);
  memo2.lines.add(' Subunidad a la que pertenece: ' + p1.atm[atm1].Subunidad);
  memo2.lines.add(' Número del residuo: '           + inttostr(p1.atm[atm1].NumRes));
  memo2.lines.add(' Coordenada X del átomo: '       + floattostr(p1.atm[atm1].coor.X));
  memo2.lines.add(' Coordenada Y del átomo: '       + floattostr(p1.atm[atm1].coor.Y));
  memo2.lines.add(' Coordenada Z del átomo: '       + floattostr(p1.atm[atm1].coor.Z));
  memo2.lines.add(' Localización alternativa: '     + p1.atm[atm1].AltLoc);

end;

end.

