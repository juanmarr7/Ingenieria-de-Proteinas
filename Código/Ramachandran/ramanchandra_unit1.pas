unit Ramanchandra_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, Biotools, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ColorDialog1: TColorDialog;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Memo2: TMemo;
    Shape1: TShape;
    Shape3: TShape;
    Shape4: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private

  public

  end;

var
  Form1: TForm1;
  datos: TTablaDatos;
  p: TPDB;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
   image1.Canvas.clear;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Halt;
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if colordialog1.execute then shape1.brush.color:= colordialog1.color;
end;

procedure TForm1.Shape3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if colordialog1.execute then shape3.brush.color:= colordialog1.color;
end;

procedure TForm1.Shape4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if colordialog1.execute then shape4.Brush.color:= colordialog1.color;
end;




procedure TForm1.Button1Click(Sender: TObject);
begin
  //image1.Canvas.Pen.Color:=clyellow;   // trazos y bordes
  //image1.Canvas.Brush.Color:=clblue; // relleno
  //image1.Canvas.Line(100,100,300,300);  // linea con partida y final
  //image1.Canvas.Lineto(20,55);   // linea que empieza en el último punto
  //if opendialog1.execute then image1.picture.loadfromfile(opendialog1.FileName);
  //image1.canvas.Ellipse(200,200,450,450);  // crea una elipse con esas coordenadas
  //image1.canvas.pixels[400,20]:= clwhite;  // ese pixel lo pones de un color
  //micolor:= image1.canvas.pixels[400,20]; //toma el color de ese pixel
  //plotXY(misdatos, image1.Canvas, 0,1, false, false,
  //shape1.brush.color,shape2.brush.color,shape3.brush.color);
  if opendialog1.execute then
  begin
     memo1.clear;
     memo1.lines.loadfromfile(opendialog1.FileName);
     edit1.text:=opendialog1.FileName;
     edit1.text:= extractFileName(opendialog1.filename);
     p:= cargarPDB(memo1.lines);



  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  pluma, relleno, fondo: TColor;
  j, k: integer;
begin
  memo2.clear;
  pluma:= shape1.brush.color;
  relleno:=shape3.brush.color;
  fondo:=shape4.brush.color;
  for j:= 1 to p.NumSubunidades do
  begin
     setlength(datos,2, p.sub[j].resn - p.sub[j].res1 -1);
     memo2.visible:=false;
     for k:=p.sub[j].res1+1 to p.sub[j].resn-1 do
     begin
        datos[0,k - p.sub[j].res1-1]:= p.res[k].phi;
        datos[1,k - p.sub[j].res1-1]:=  p.res[k].psi;
        memo2.lines.add(padright(p.res[k].ID3 + inttostr(p.res[k].NumRes) + p.res[k].subunidad, 10)
                       + padleft(formatfloat('0.00',p.res[k].phi*180/pi),10)
                       + padleft(formatfloat('0.00',p.res[k].psi*180/pi),10));


     end;
     memo2.visible:=true;
     plotXY(datos, image1.canvas, 0, 1, false, false,pluma, relleno, fondo);
  end;
end;

end.

