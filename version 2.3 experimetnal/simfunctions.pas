unit SimFunctions;

{$mode objfpc}{$H+}

interface


 uses
   Classes, SysUtils,Math,iniFiles;

 Function ChebyBPGain(f,fl,fU,N,Ripple:Real):Real;
 Function ButterBandpassGain(f,fL,fU,N:Real):Real;

implementation



  Function ChebyBPGain(f,fl,fU,N,Ripple:Real):Real;
var
fRel,esqr,Cn,fo,BW:Real;
begin

  fo := Sqrt(fU * fL);

  BW := (fU - fL) / fo;

  fRel := Abs(((f / fo) - (fo / f)) / BW);

  esqr := Power(10,(Ripple / 10)) - 1;

  If (f<fl) Or (f > fU) Then     {Out-of-band}

    Cn := Cosh(N * ArcCosH(fRel))

  Else     {In-band}
     if fRel>1 then
       begin
         Cn:=1;
         end
   Else
    Cn := Cos(N *ArcCos(fRel));
     ChebyBPGain := -10 * Log10(1 + esqr * Power(Cn,2));

  end;
  Function ButterBandpassGain(f,fL,fU,N:Real):Real;
var
  fRel,fo,BW:Float;
  begin

  fo := Sqrt((fU * fL));

  BW := (fU - fL) / fo;

  fRel :=Abs( ((f / fo) - (fo / f)) / BW);

  ButterBandpassGain := -10 * Log10(1 + Power(fRel,(2 * N)));
  end;

End.



