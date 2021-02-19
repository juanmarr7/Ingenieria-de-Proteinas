unit Biotools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Graphics, Dialogs, Forms;       // librerias cargadas

type

  TPunto = record
    X,Y,Z: real;
    end;

  TPuntos = array of TPunto;    // array con un conjunto de puntos




  TAtomPDB = record        // con los átomos
    NumAtom: integer;
    ID: string;
    Residuo: string;
    Subunidad: char;
    NumRes: integer;
    coor: TPunto;
    AltLoc: char;
    Temp: real;
    end;

  TResiduoPDB = record        // con los residuos
    phi,psi: real;
    NumRes: integer;
    subunidad: char;
    ID3: string;
    ID1: char;
    Atm1, AtmN: integer;
    N, CA, C, O: integer;
    end;

  TsubunidadPDB = record      // con las subunidades
    ID: char;
    Atm1, AtmN, res1, resN: integer;
    AtomCount, ResCount: integer;

    ResIndex: array of integer;
    end;


  TPDB = record             // la proteína
       header: string;
       atm: array of TAtomPDB;
       res: array of TResiduoPDB;
       sub: array of TsubunidadPDB;
       NumFichas, NumResiduos, NumSubunidades : integer;
       subs, secuencia : string;

       AtomIndex: array of integer;
       end;
  TTablaDatos = array of array of real;
  TEscala = array ['A'..'Z'] of real;
  const
  AA = '***ALA=A#ARG=R#ASN=N#ASP=D'
     + '#CYS=C#GLN=Q#GLU=E#GLY=G#HIS=H'
     + '#ILE=I#LEU=L#LYS=K#MET=M#PHE=F'
     + '#PRO=P#SER=S#THR=T#TRP=W#TYR=Y'
     + '#VAL=V';

  // para el cambio de código de 3 letras a 1 y viceversa


 function distancia (x1,y1,z1,x2,y2,z2:real): real;           // hay que publicar las funciones
 function distancia(punto1,punto2:TPunto): real;   overload;
 function cargarPDB (var p: TPDB): string;
 function cargarPDB (texto: Tstrings): TPDB; overload;
 function sumaV (A,B: TPunto): TPunto;
 function diferenciaV (A,B: TPunto): TPunto;
 function moduloV( A: TPunto): real;
 function escalarV(k:real; V: TPunto) : TPunto;
 function prodEscalar(A, B: TPunto): real;
 function angulo (A, B: Tpunto): real;
 function angulo(A, B, C: TPunto):real; overload;
 function torsion ( A, B, C, D: TPunto): real;
 function prodVectorial(p1,p2: TPunto): Tpunto;
 function AA3TO1 (aa3: string): char;

 function giroOX(rad: real; v: TPunto): TPunto;
 function giroOX(rad: real; puntos: TPuntos): TPuntos; overload;
 function giroOY(rad: real; v: TPunto): TPunto;
 function giroOY(rad: real; puntos: TPuntos): TPuntos; overload;
 function giroOZ(rad: real; v: TPunto): TPunto;
 function giroOZ(rad: real; puntos: TPuntos): TPuntos; overload;

 function traslacion(dx, dy, dz: real; v: TPunto): TPunto;
 function traslacion(dx, dy, dz: real; puntos: TPuntos): TPuntos; overload;

 function plotXY(datos: TTablaDatos; im: TCanvas; OX: integer = 0; OY: integer =1;
                  borrar: boolean = false; linea: boolean =false; clpluma: TColor= clyellow;
                  clRelleno: TColor= clyellow; clFondo: TColor= clblack; radio: integer= 3;
                  borde: integer= 40; marcafin: boolean= false; clfin: TColor= clred): boolean;
 function CargarEscala( var escala: TEscala): string;
 function alinear_ejeZ(puntos:TPuntos):TPuntos ;

 function Ind_Der(long_max, long: integer; var cadena: string): string;
 function Ind_Izq(long_max, long: integer; var cadena: string): string;
 function writePDB(atm: TAtomPDB): string;
implementation  // tras esto se definen las funciones

function CargarEscala( var escala: TEscala): string;
var
   texto: TStrings;
   dial: TOpenDialog;
   j: integer;
   linea: string;
   residuo: char;
begin
   texto:= TStringList.create;
   dial:= TOPenDialog.create(application);
   if dial.execute then
   begin
       texto.loadfromfile(dial.FileName);
       result:= dial.Filename;
       for j:=0 to texto.count-1 do
       begin
          linea:= trim(texto[j]);
          residuo:= linea[1]; // posición 1 de la línea
          delete(linea,1,1); // borra en línea desde 1 con ancho de 1, es decir, solo el primero
          escala[residuo]:= strtofloat(trim(linea));
       end;
   end else result:='';
    dial.free; // libera la memoria, es decir, destruye el objeto
    texto.free;
end;

function alinear_ejeZ(puntos: Tpuntos): Tpuntos;
var
  salida: TPuntos;
  a, b, c, d1, d2, alfa, fi, senofi, senoalfa: real;
  p1, p2: TPunto;
begin
  setlength(salida, high(puntos)+1);
  p1:= puntos [0];
  salida:= traslacion(-p1.X, -p1.Y, -p1.Z, puntos);
  p2:= salida[high(salida)];

  a:= p2.X; b:= p2.Y; c:= p2.Z;

  d1:= sqrt(sqr(b)+sqr(c));
  d2:= sqrt(sqr(a)+sqr(b)+sqr(c));
  senofi:= b/d1;
  senoalfa:= a/d2;

  fi:= arcsin(senofi);
  alfa:= arcsin(senoalfa);
  if c<0 then fi:= -fi else alfa:= -alfa; //esto recoge los cambios de signos de todos los cuadrantes

  salida:= GiroOX(fi, salida);
  salida:= GiroOY(alfa, salida);
  result:= salida;
end;





  function giroOX(rad: real; v: TPunto): TPunto;   // preguntar por los signos
  var
     seno, coseno: real;
  begin
     seno:= sin(rad);
     coseno:= cos(rad);
     GiroOX.X:= v.X;
     GiroOX.Y:= v.Y*coseno - v.Z*seno;
     GiroOX.Z:= v.Y*seno + v.Z*coseno;
  end;

  function giroOX(rad: real; puntos: TPuntos): TPuntos; overload;   // hecho

  var
     seno, coseno:real;
     salida:TPuntos;
     j:integer;

  begin
       seno:= sin(rad);
     coseno:= cos(rad);
     setlength(salida, high(puntos)+1);
     for j:=0 to high(puntos) do
     begin
         salida[j].X:= puntos[j].X;
         salida[j].Y:= puntos[j].Y*coseno - puntos[j].Z*seno;
         salida[j].Z:= puntos[j].Y*seno + puntos[j].Z*coseno;
     end;
     result:= salida;
      end;
  procedure giroOX (rad: real; var p:TPDB) overload; // hecho
    var
   seno, coseno:real;
   j:integer;
    begin
        seno:= sin(rad);
        coseno:= cos(rad);
       for j:= 1 to p.NumFichas do
       begin
       p.atm[j].coor.X:= p.atm[j].coor.X;
       p.atm[j].coor.Y:=  p.atm[j].coor.Y*coseno - p.atm[j].coor.Z*seno;
       p.atm[j].coor.Z:= p.atm[j].coor.Y*seno + p.atm[j].coor.Z*coseno;

       end;
       end;

  function giroOY(rad: real; v: TPunto): TPunto;
  var
     seno, coseno: real;
  begin
     seno:= sin(rad);
     coseno:= cos(rad);
     GiroOY.X:= v.X*coseno + v.Z*seno;
     GiroOY.Y:= v.Y;
     GiroOY.Z:= -v.X*seno + v.Z*coseno;
     end;

  function giroOY(rad: real; puntos: TPuntos): TPuntos; overload;
       var
     seno, coseno:real;
     salida:TPuntos;
     j:integer;

  begin
       seno:= sin(rad);
     coseno:= cos(rad);
     setlength(salida, high(puntos)+1);
     for j:=0 to high(puntos) do
     begin
         salida[j].X:= puntos[j].X*coseno + puntos[j].Z*seno;
         salida[j].Y:= puntos[j].Y;
         salida[j].Z:= -puntos[j].X*seno + puntos[j].Z*coseno;
     end;
     result:= salida;
      end;

  procedure giroOY (rad: real; var p:TPDB) overload;
  var
   seno, coseno:real;
   j:integer;
    begin
        seno:= sin(rad);
        coseno:= cos(rad);
       for j:= 1 to p.NumFichas do
       begin
       p.atm[j].coor.X:= p.atm[j].coor.X*coseno + p.atm[j].coor.Z*seno;
       p.atm[j].coor.Y:=  p.atm[j].coor.Y;
       p.atm[j].coor.Z:= -p.atm[j].coor.X*seno +p.atm[j].coor.Z*coseno;

       end;
       end;

  function giroOZ(rad: real; v: TPunto): TPunto;
  var
     seno, coseno: real;
  begin
     seno:= sin(rad);
     coseno:= cos(rad);
     GiroOZ.X:= v.X*coseno - v.Y*seno;
     GiroOZ.Y:= v.X*seno + v.Y*coseno;
     GiroOZ.Z:= v.Z;
  end;
  function giroOZ(rad: real; puntos: TPuntos): TPuntos; overload;//hay que hacerlo
     var
     seno, coseno:real;
     salida:TPuntos;
     j:integer;

  begin
       seno:= sin(rad);
     coseno:= cos(rad);
     setlength(salida, high(puntos)+1);
     for j:=0 to high(puntos) do
     begin
         salida[j].X:= puntos[j].X*coseno - puntos[j].Y*seno;
         salida[j].Y:= puntos[j].X*seno + puntos[j].Y*coseno;
         salida[j].Z:= puntos[j].Z;
     end;
     result:= salida;
      end;

  procedure giroOZ (rad: real; var p:TPDB) overload; //también hay que hacerlo
  var
   seno, coseno:real;
   j:integer;
    begin
        seno:= sin(rad);
        coseno:= cos(rad);
       for j:= 1 to p.NumFichas do
       begin
       p.atm[j].coor.X:= p.atm[j].coor.X*coseno - p.atm[j].coor.Y*seno;
       p.atm[j].coor.Y:= p.atm[j].coor.X*seno + p.atm[j].coor.Y*coseno;
       p.atm[j].coor.Z:= p.atm[j].coor.Z;

       end;
       end;

  function traslacion(dx, dy, dz: real; v: TPunto): TPunto; // traslaciones
  begin
     traslacion.X:= v.X + dx;
     traslacion.Y:= v.Y + dy;
     traslacion.Z:= v.Z + dz;
   end;



  function traslacion(dx, dy, dz: real; puntos: TPuntos): TPuntos; overload;
  var
     salida: TPuntos;
     j: integer;
  begin
    setlength(salida, high(puntos)+1);
    for j:=0 to high(puntos) do
    begin
       salida[j].X:=puntos[j].X + dx;
       salida[j].Y:=puntos[j].Y + dy;
       salida[j].Z:=puntos[j].Z + dz;
    end;
    result:= salida;
  end;
  procedure traslacion(dx, dy, dz: real; var p: TPDB);  overload;
  var
     j: integer;
  begin
    for j:= 1  to p.NumFichas do
    begin
       p.atm[j].coor.X:= p.atm[j].coor.X + dx;
       p.atm[j].coor.Y:= p.atm[j].coor.Y + dy;
       p.atm[j].coor.Z:= p.atm[j].coor.Z + dz;

       end;

    end;



  function plotXY(datos: TTablaDatos; im: TCanvas; OX: integer = 0; OY: integer =1;
                  borrar: boolean = false; linea: boolean =false; clpluma: TColor= clyellow;
                  clRelleno: TColor= clyellow; clFondo: TColor= clblack; radio: integer= 3;
                  borde: integer= 40; marcafin: boolean= false; clfin: TColor= clred): boolean;
  var
     xmin, xmax, ymin, ymax, rangox, rangoy: real;
     ancho, alto,Xp, Yp, j: integer;
     OK: boolean;

     function Xpixel (x:real): integer ;
     begin
          result:= round(((ancho-2*borde)*(x-xmin)/rangoX)+borde);
        end;

     function Ypixel (y:real):integer;
     begin
           result:= round(alto-(((alto-2*borde)*(y-ymin)/rangoY)+borde));
        end;

  begin
     OK:= true;
     xmin:= minvalue(datos[OX]);
     xmax:= maxvalue(datos[OX]);
     ymin:= minvalue(datos[OY]);
     ymax:= maxvalue(datos[OY]);
     rangox:= xmax-xmin;
     rangoy:= ymax-ymin;
     ancho:= im.width;
     alto:=  im.height;
     if (rangox=0) or (rangoy=0) then OK:= false;
     if borrar then
     begin
         im.brush.color:= clFondo;
         im.clear;

     end;
     if OK then
     begin
         im.Pen.Color:= clpluma;
         im.brush.color:= clrelleno;
         Xp:= xpixel(datos[OX,0]);
         Yp:= ypixel(datos[OY,0]);
         im.MoveTo (Xp, Yp);
         for j:=0 to high(datos[0]) do
         begin
            Xp:= xpixel(datos[OX,j]);
            Yp:= ypixel(datos[OY,j]);
            im.ellipse(Xp-radio, Yp-radio, Xp+radio, Yp+radio);
            if linea then im.lineto(Xp,Yp);
         end;
         if marcafin then
         begin
         im.pen.Color:= clfin;
         im.brush.color:=clfin;
         im.ellipse(Xp-radio-2, Yp-radio-2, Xp+radio+2, Yp+radio+2);
         end;
     end;
     result:= OK;
     end;


  function AA3TO1(aa3: string):char;
  begin
    result:= AA[pos(aa3,AA)+4];
    end;
  function AA1TO3 (aa1:char):string ;    // comprobar que sea válida
  begin
  result:= copy(AA, pos(AA1, AA)-4, 2);
  end;

  function sumaV (A,B: TPunto): TPunto;
  var
     V: TPunto;
  begin
    V.X:= A.X + B.X;
    V.Y:= A.Y + B.Y;
    V.Z:= A.Z + B.Z;
    result:=V;
 end;
  function diferenciaV (A,B: TPunto): TPunto;
  var
     V: TPunto;
  begin
    V.X:= A.X - B.X;
    V.Y:= A.Y - B.Y;
    V.Z:= A.Z - B.Z;
    result:=V;
 end;
  function moduloV( A: TPunto): real;
  begin
    result:=sqrt(sqr(A.X)+sqr(A.Y)+sqr(A.Z));
  end;


  function escalarV(k:real; V: TPunto) :TPunto;
  begin
    result.X:= k*V.X;
    result.Y:= k*V.Y;
    result.Z:= k*V.Z;
    end;
 function prodEscalar(A, B: TPunto): real;
begin
  result:= A.X*B.X + A.Y*B.Y + A.Z*B.Z;

end;

function angulo (A, B: Tpunto): real;
var
   denominador: real;
begin
  denominador:= moduloV(A)*moduloV(B);
if denominador > 0
 then  result:= arccos(prodEscalar(A,B)/denominador)
 else  result:=  maxfloat;
end;

function angulo(A, B, C: TPunto):real; overload;
var
   BA,BC: TPunto;
begin
   BA:= diferenciaV( A,B);
   BC:= diferenciaV(C,B);
   result:= angulo( BA, BC);

end;
function prodVectorial(p1,p2: TPunto): Tpunto;
var
   V:TPunto;
begin
   V.X:=p1.Y*p2.Z - p1.Z*p2.Y;
   V.Y:=P1.Z*P2.X - P1.X*P2.Z;
   V.Z:=p1.X*p2.Y - p1.Y*p2.X;
   result:= V;
   end;
function torsion ( A, B, C, D: TPunto): real;
var
   BA, BC, CB, CD, V1, V2, P: TPunto;
   diedro, diedro_IUPAC, denominador, cosenoGamma: real;
begin
     diedro_IUPAC:=0;
   BA:= diferenciaV(A, B);
   BC:= diferenciaV(C, B);
   CB:= diferenciaV(B, C);
   CD:= diferenciaV(D, C);
   V1:= prodVectorial(BC, BA);
   V2:= prodVectorial(CD, CB);
   diedro:= angulo(V1, V2);
   P:= prodVectorial(V2, V1);
   denominador:= moduloV(P)* moduloV(CB);
   if denominador >0 then
   begin
    cosenoGamma:= prodEscalar(P, CB)/ denominador;
    if cosenoGamma >0 then cosenoGamma:=1 else cosenoGamma:=-1;
   end else diedro_IUPAC:= maxfloat;
   if diedro_IUPAC < maxfloat then diedro_IUPAC:= diedro*cosenoGamma;
   result:=diedro_IUPAC;
end;


  function distancia (x1,y1,z1,x2,y2,z2:real): real;
 begin
   result:=sqrt(sqr(x1-x2) + sqr(y1-y2) + sqr(z1-z2));
 end;
  function distancia(punto1,punto2:TPunto): real;   overload;
  begin
    result:= sqrt(sqr( punto1.X - punto2.X) + sqr(punto1.Y - punto2.Y) + sqr(punto1.Z - punto2.Z));
  end;

  function cargarPDB (var p: TPDB): string;
  var
     dialogo: TOpenDialog;
     textoPDB: TStrings;
  begin
     dialogo:= TOpenDialog.create(application);
     textoPDB:= TStringlist.create;

     if dialogo.execute then
     begin
      textoPDB.loadfromfile(dialogo.filename);
      p:=cargarPDB(textoPDB);
      result:= dialogo.filename;

     end else result:= '';

     dialogo.free;
     textoPDB.free;
  end;

  function writePDB(atm: TAtomPDB): string;
var
  n: integer;
  pdb: TStrings;
  linea, atom, res, coorX, coorY, coorZ, temp: String;
  s: string;
begin
    atom:= inttostr(atm.Numatom);
    res := inttostr(atm.NumRes);
    coorX  := formatfloat('0.000', atm.coor.X);
    coorY  := formatfloat('0.000', atm.coor.Y);
    coorZ  := formatfloat('0.000', atm.coor.Z);
    temp   := formatfloat('0.00', atm.Temp);

    linea:= 'ATOM'+ '  ' + ind_der(5,atom.Length,atom) + '  ' + ind_izq(3,atm.ID.length, atm.ID) +
            ' ' + atm.Residuo + ' ' + atm.subunidad + ' ' + ind_der(3,res.length,res) +
            '     ' + ind_der(7, coorX.Length, coorX)+ ' ' +  ind_der(7, coorY.length, coorY) + ' ' +
            ind_der(7, coorZ.Length, coorZ) + '  1.00 ' + ind_der(5, temp.length, temp);
    result:= linea;   // funciones Ind para evitar hacerlo todo manualmente
  end;

  function Ind_Der(long_max, long: integer; var cadena: string): string;
var
n:integer;
espacio: string;
begin
  espacio:=' ';
   if long_max > long then
      for n:=1 to long_max-long do insert(espacio,cadena,n);   // inserta un espacio por cada uno que falte
   result:= cadena;
end;

function Ind_Izq(long_max, long: integer; var cadena: string): string;
var
n:integer;
espacio: string;
begin
  espacio:=' ';
   if long_max > long then
      for n:=1 to long_max-long do
      begin
        cadena:= cadena+espacio; // igual pero por el final
      end;
   result:= cadena;
end;

  function CargarPDB(texto: TStrings): TPDB;    overload;
  var
    p: TPDB;                           //proteína , El TPDB de salida de la función
    linea: string;
    j, k, F, R, S: integer;//contador de ficha, residuo, subunidad
    resno: integer;

  begin

    p.secuencia:='';
    F:=0; R:=0; S:=0;                   //para asegurarse de que el contador es 0 al inicio
    setlength(p.atm, texto.count);     // como no tenemos suficiente info todavía, establecemos el máximo posible,
                                       //que sería el número de líneas total del memo(texto). Estimamos por alto
    setlength(p.res, texto.count);
    setlength(p.sub, texto.count);



    for j:=0 to texto.count-1 do
    begin
      linea:= texto[j];
      if (copy(linea,1,6)='ATOM  ')then
      begin
        F:= F+1;//No podemos usar j como contador de átomos ya que cuando llegue a ATOM, valdrá mucho,
               //necesitamos un contador de fichas a parte
      //Atomos
        p.atm[F].NumAtom :=strtoint(trim(copy(linea,7,5)));
        p.atm[F].ID:= trim(copy(linea, 13, 4));
        p.atm[F].Residuo:= copy(linea, 18,3); //Aquí no hace falta trim porque siempre son los 3 caracteres
        p.atm[F].Subunidad:=linea[22]; //Introduce el caracter 22 del string linea, aunque puede que no tengamos subunidades.
        p.atm[F].NumRes:= strtoint(trim(copy(linea,23,4)));
        p.atm[F].coor.X:= strtofloat(trim(copy(linea,31,8)));
        p.atm[F].coor.Y:= strtofloat(trim(copy(linea,39,8)));
        p.atm[F].coor.Z:= strtofloat(trim(copy(linea,47,8)));
        p.atm[F].AltLoc:=linea[17];
        p.atm[F].Temp:= strtofloat(trim(copy(linea, 61,6)));

      //Residuo
        if p.atm[F].ID = 'N' then
        begin
          R:= R+1;
          p.res[R].Atm1:= F;
          p.res[R].ID3:=p.atm[F].Residuo;
          p.res[R].ID1:=AA3to1(p.res[R].ID3);
          p.res[R].N:= F;
          p.res[R].NumRes:= p.atm[F].NumRes;
          p.res[R].Subunidad:= p.atm[F].Subunidad;
          p.secuencia:= p.secuencia + p.res[R].ID1;

        //Subunidad
          if pos(p.atm[F].Subunidad, p.subs)=0 then   //Si es cabeza de subunidad (la letra no estaba en subs), se inicia.
          begin
            S:= S+1;
            p.subs:= p.subs + p.atm[F].Subunidad;
            p.sub[S].ID:=p.atm[F].Subunidad;
            p.sub[S].atm1:=F;
            p.sub[S].res1:=R;
          end;
        end;
        if p.atm[F].ID='CA' then p.res[R].CA:= F;
        if p.atm[F].ID='C' then p.res[R].C:= F;
        if p.atm[F].ID='O' then p.res[R].O:= F;
        p.res[R].AtmN:= F; //Se va a ir cambiando en cada bucle, pero cuando termine se quedará con la del número del último átomo que se lea dentro del R en cuestión
        p.sub[S].atmN:= F;
        p.sub[S].resN:= R;  //Pasa lo mismo pero con la subunidad


      end;
    end;
    setlength(p.atm, F+1);  //Debido a que es una matriz dinamica, hay que dimensionarla.
    setlength(p.res, R+1);
    setlength(p.sub, S+1);
    p.NumFichas:= F;
    p.NumResiduos:= R;
    p.NumSubunidades:= S;

    setlength(p.atomindex, p.atm[p.NumFichas].NumAtom + 1);     //Dimensionamos el vector.
    //Es NumAtom porque buscamos el último número de átomos que tenemos. Suponiendo que no hay huecos, coincidiría con la numeración.
    //Como el 0 lo ignoramos siempre, pues tenemos que sumar 1 pa las dimensiones.
    //Hay que ir asignando el subíndice con el numatom y rellenar con el numero de ficha:
    for j:=1 to p.NumFichas do p.atomindex[p.atm[j].NumAtom]:= j; //Elegimos el elemento NumaTOM DEL ELEMENTO J-ÉSIMO DE MI PROTEÍNA.
                                                                 //y lo asignamos al subíndice de nuestra ficha.

    for j:=1 to p.NumSubunidades do with p.sub[j] do  //Para no tener que ponerlo todo el rato (peligroso)
    begin
      AtomCount:= atmN - atm1 + 1;
      ResCount:= resN - res1 + 1;
      for k:=p.sub[j].res1 + 1 to p.sub[j].resn - 1 do //Así eliminamos los extremos
      begin
        p.res[k].phi:=torsion(p.atm[p.res[k-1].C].coor,
                              p.atm[p.res[k].N].coor,
                              p.atm[p.res[k].CA].coor,
                              p.atm[p.res[k].C].coor); //Llamada a la función de torsión. //Se usa el p.atm porque buscamos la información
                                                         //del átomo que tiene ese número de residuo, para abrir la ficha y así acceder a las coordenadas.

        p.res[k].psi:=torsion(p.atm[p.res[k].N].coor,
                              p.atm[p.res[k].CA].coor,
                              p.atm[p.res[k].C].coor,         //El orden es muy importante.
                              p.atm[p.res[k+1].N].coor);

      end;

      setlength(p.sub[j].resindex, p.NumResiduos + 1); //Estamos recorriendo las subunidades de j.
      for k:=1 to p.sub[j].ResCount do
      begin
        resno:= p.sub[j].res1 + k - 1;   //resno es j, nuestra numeración en mi fichero. Restamos 1 porque las matrices abiertas acaban en n-1.
        p.sub[j].resindex[p.res[resno].numres]:= resno;  //Numres no es mio, es de PDB.
      end;

    end;

    result:=p;
  end;

  end.
