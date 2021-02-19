unit Distancia_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  x1, x2, y1, y2, z1, z2: real;
  distancia: real;

begin
  x1:= strtofloat(edit1.text);
  x2:= strtofloat(edit2.text);
  y1:= strtofloat(edit3.text);
  y2:= strtofloat(edit4.text);
  z1:= strtofloat(edit5.text);
  z2:= strtofloat(edit6.text);
  distancia:= sqrt(sqr(x1-x2)+sqr(y1-y2)+sqr(z1-z2));
  label6.caption:= label6.caption + floattostr(distancia);

end;

end.

