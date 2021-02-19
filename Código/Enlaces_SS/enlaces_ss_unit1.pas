unit Enlaces_SS_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  Biotools, StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p: TPDB;


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
 listaSG: array of integer; // lista ABIERTA de átomos SG
 tabla: TTablaDatos;        // tabla con las distancias
 numSG: integer;            // número total de SG
 umbral:real;

  procedure buscar_SG;
  var
   j: integer;  // para recorrer p
  begin
    numSG:=0;
    setlength(listaSG, p.NumFichas);  // arreglamos la matriz abierta
   for j:=1 to p.NumFichas do if p.atm[j].ID='SG' then
   begin
     inc(numSG); // incrementa nº de SG
     listaSG[numSG]:= j;
   end;
  setlength(listaSG, numSG+1); // por haber obviado la posición 0
  end;

  procedure calcular_distancias;
  var
   j, k: integer;
  begin
    setlength(tabla, numSG+1, numSG+1);  // +1 para ignorar el 0 como en la lista
    for j:=1 to numSG do
        for k:=1 to numSG do
            tabla[j,k]:=distancia(p.atm[listaSG[j]].coor,p.atm[listaSG[k]].coor);
  end;

  procedure mostrar_resultados;
  var
   j,k: integer;
   aa1, aa2: string;
  begin

    memo2.clear;
    memo2.lines.add('---------------------------------');
    memo2.lines.add(' Predicción de enlaces disulfuro');
    memo2.lines.add('---------------------------------');
    memo2.lines.add('');
    memo2.lines.add(padright('Cisteína 1',15)+ padright('Cisteína 2',15) + padright('Distancia',15));
    for j:=1 to numSG do       // igual que en calcular_distancias
        for k:=1 to numSG do
            if (tabla[j,k]<= umbral) and (j<k) then // si la distancia es menor al umbral
            begin                       // j<k para que no salgan duplicados los datos en la tabla
               aa1:='CYS'+ inttostr(p.atm[listaSG[j]].NumRes) + p.atm[listaSG[j]].Subunidad;
               aa2:='CYS'+ inttostr(p.atm[listaSG[k]].NumRes) + p.atm[listaSG[k]].Subunidad;
               memo2.lines.add(padright(aa1,15) + padright(aa2,15)+ padright(formatfloat('0.00',(tabla[j,k])),15)); // rellenamos el memo2

            end;
  end;
  begin
     umbral:= floatSpinEdit1.Value;  // el valor del spin
     buscar_SG;
     calcular_distancias;
     mostrar_resultados;

 end;

end.

