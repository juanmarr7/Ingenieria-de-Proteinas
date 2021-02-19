unit Alinear_Z_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, Biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p:TPDB;
  CAI, CAT: TPuntos;  // conjuntos de puntos sin transformar y transformados
  CA1, CAN: integer;  // números del CA inicial y CA final
  datos: TTablaDatos;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.canvas.clear;
  image2.canvas.clear;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  nomfi: string;
begin
  nomfi:= cargarPDB(p);
  if nomfi <>'' then
  begin
  edit1.text:= nomfi;
  memo1.lines.LoadFromFile(edit1.text);
  spinedit1.maxvalue:= p.NumResiduos;  // valor máximo es igual a num res
  spinedit2.maxvalue:= p.NumResiduos;
  spinedit1.minvalue:= 1;
  spinedit2.minvalue:= 1;
  CA1:= 1; CAN:= p.NumResiduos; // van a ser cambiados, esto es por defecto

  end else
  begin
    edit1.text:='';
    memo1.clear;

  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  j: integer;
begin
  CA1:= Spinedit1.Value;   // es número, así que no hace falta pasar a integer
  CAN:= Spinedit2.Value;
        if CA1>CAN then  // si los valores están invertidos los cambiamos
        begin
          j:= CA1; CA1:= CAN; CAN:= j; // así se realiza el cambio
        end;
 setlength(CAI, CAN-CA1+1); // la longitud necesaria es el conjunto de puntos
 setlength(datos,2, CAN-CA1+1); // misma longitud para los datos pero con dos columnas
 for j:= CA1 to CAN do CAI[j-CA1]:= p.atm[p.res[j].CA].coor; // datos de los CA de cada residuo
 // cuidado porque no se puede poner "j" pues hay que empezar por 0, no por el nº de CA1
 // si CA1 es 10 tenemos que empezar en 0, por eso ponemos j-CA1
 // con este vector inicial de los TPuntos ya podemos dibujar el primero
 for j:= 0 to high(CAI) do // recorre todos los TPuntos
 begin
   datos[0,j]:= CAI[j].X;    //los datos para cada Tpunto en la x
   datos[1,j]:= CAI[j].Y;   // para la y
 end;
 plotxy(datos, image1.Canvas, 0, 1, true, true);
 // queremos que borrar sea true, por lo que tenemos que poner todos
 // los datos al menos hasta ahí. lo mismo para línea.
 CAT:= alinear_ejeZ(CAI); // los datos transformados se obtienen alineando los iniciales
 for j:= 0 to high(CAI) do
 begin
 datos[0,j]:= CAT[j].X;
 datos[1,j]:= CAT[j].Y;
 end;
 plotxy(datos, image2.canvas, 0, 1, true, true,clyellow,clyellow,clblack,3,40,true,clred); // plot del segundo ya transformado
end;


end.

