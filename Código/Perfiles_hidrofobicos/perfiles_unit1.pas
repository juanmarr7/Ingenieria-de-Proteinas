unit Perfiles_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, Biotools, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p:TPDB;
  pdb:  string;
  resini, resfin, numresini, numresfin: integer;
  escalaH: string;
  h: TEscala;
  subini, subfin: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
    image1.canvas.clear;
    image2.canvas.clear;
    image3.canvas.clear;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  j: integer;
begin
    pdb:= cargarPDB(p);
    if pdb <>'' then
    begin
      edit1.text:= extractFileName(pdb);
      combobox1.clear;
      combobox2.clear;
      for j:= 1 to p.NumSubunidades do
      begin
          Combobox1.items.add(p.subs[j]);
          Combobox2.items.add(p.subs[j]);
      end;
       Combobox1.ItemIndex:=0;
       Combobox2.ItemIndex:=p.NumSubunidades-1;
       numresini:= p.res[p.sub[1].res1].Numres;
       numresfin:= p.res[p.sub[p.NumSubunidades].resN].Numres;
       spinedit3.MaxValue:=p.res[p.sub[1].resN].NumRes;
       spinedit3.value:=numresini;
       spinedit4.MaxValue:=numresfin;
       spinedit4.value:=numresfin;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  datos : TTablaDatos;
  semiV, sw, j, k, ndatos: integer;
  suma: real;
begin
    if (pdb<>'') and (escalaH<>'') then
    begin
         subini:=combobox1.itemindex + 1;
         subfin:=combobox2.itemindex + 1;
         numresini:=spinedit3.value;   // cuidado porque en las subunidades todos empiezan por 1
         numresfin:=spinedit4.value;
         resini:= p.sub[subini].resindex[numresini] ;
         resfin:= p.sub[subfin].resindex[numresfin] ;
         setlength(datos,2, resfin-resini+1);
         semiV:= spinedit1.value; // dos filas, y de máximo
         // en pdb no se tiene en cuenta a qué subunidad pertenece cada residuo
         // hay que pasarlo al res correspondiente, que es lo que hemos hecho
         if resfin<resini then
         begin
         sw:= resfin;
         resfin:= resini;
         resini:= sw;
         end;
         for j:= resini to resfin do
          begin
          suma:=0; ndatos:=0;
          for k:= max(j-semiV,1) to min(j+semiV,p.NumResiduos) do //creando ventanas flexibles
           begin
           suma:= suma + h[p.secuencia[k]];
           ndatos:= ndatos+1;
           end;
           datos[0,j-resini]:=j;
           datos[1,j-resini]:=suma/ndatos;
          end;
          plotxy(datos, image1.canvas,0,1,true,true);
    end;
end;
procedure TForm1.Button3Click(Sender: TObject);
begin
   escalaH:=cargarEscala(H);
   edit2.text:= extractFileName(escalaH);
end;

procedure TForm1.Button4Click(Sender: TObject);
  var
  datos : TTablaDatos;
  semiV, sw, j, k, ndatos: integer;
  suma1, suma2: real;
  delta: real;
begin
    if (pdb<>'') and (escalaH<>'') then
    begin
         subini:=combobox1.itemindex + 1;
         subfin:=combobox2.itemindex + 1;
         numresini:=spinedit3.value;   // cuidado porque en las subunidades todos empiezan por 1
         numresfin:=spinedit4.value;
         resini:= p.sub[subini].resindex[numresini] ;
         resfin:= p.sub[subfin].resindex[numresfin] ;
         setlength(datos,2, resfin-resini+1);
         semiV:= spinedit1.value; // dos filas, y de máximo
         // en pdb no se tiene en cuenta a qué subunidad pertenece cada residuo
         // hay que pasarlo al res correspondiente, que es lo que hemos hecho
         delta:= spinedit2.value*pi/180;
         if resfin<resini then
         begin
         sw:= resfin;
         resfin:= resini;
         resini:= sw;
         end;
         for j:= resini to resfin do
          begin
          for k:= max(j-semiV,1) to min(j+semiV,p.NumResiduos) do //creando ventanas flexibles
          suma1:=0; suma2:=0; ndatos:=0;
          for k:= max(j-semiV,1) to min(j+semiV,p.NumResiduos) do //creando ventanas flexibles
           begin
           suma1:= suma1 + h[p.secuencia[k]]*sin(delta*k);
           suma2:= suma2 + h[p.secuencia[k]]*cos(delta*k);
           end;
           datos[0,j-resini]:=j;
           datos[1,j-resini]:= sqrt(sqr(suma1) + sqr(suma2));
          end;
          plotxy(datos, image2.canvas,0,1,true,true);
    end;
end;

procedure TForm1.Button5Click(Sender: TObject);
  var
  datos : TTablaDatos;
  semiV, sw, j, k, ndatos: integer;
  suma, suma1, suma2: real;
  delta, h_media: real;
begin
    if (pdb<>'') and (escalaH<>'') then
    begin
         subini:=combobox1.itemindex + 1;
         subfin:=combobox2.itemindex + 1;
         numresini:=spinedit3.value;   // cuidado porque en las subunidades todos empiezan por 1
         numresfin:=spinedit4.value;
         resini:= p.sub[subini].resindex[numresini] ;
         resfin:= p.sub[subfin].resindex[numresfin] ;
         setlength(datos,2, resfin-resini+1);
         semiV:= spinedit1.value; // dos filas, y de máximo
         // en pdb no se tiene en cuenta a qué subunidad pertenece cada residuo
         // hay que pasarlo al res correspondiente, que es lo que hemos hecho
         delta:= spinedit2.value*pi/180;
         if resfin<resini then
         begin
         sw:= resfin;
         resfin:= resini;
         resini:= sw;
         end;
          begin
           suma:= suma + h[p.secuencia[k]];
           ndatos:= ndatos+1;
           end;
          h_media:= suma/ndatos;
         for j:= resini to resfin do
          begin
          suma1:=0; suma2:=0; ndatos:=0;
          for k:= max(j-semiV,1) to min(j+semiV,p.NumResiduos) do //creando ventanas flexibles
           begin
           suma1:= suma1 + (h[p.secuencia[k]] - h_media)*sin(delta*k);
           suma2:= suma2 + (h[p.secuencia[k]] - h_media)*cos(delta*k);
           end;
           datos[0,j-resini]:=j;
           datos[1,j-resini]:=sqr(suma1) + sqr(suma2);
          end;
          plotxy(datos, image3.canvas,0,1,true,true);
    end;
end;

end.

