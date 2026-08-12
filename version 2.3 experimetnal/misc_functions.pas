unit Misc_Functions;
{
Reference for caluclations: Introduction to quartz crystal unit design (Van Nostrand Reinhold)
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Math;
Function Determine_Order(cheby:boolean;Pass_Frequency,Stop_Frequency,Stop_Atten,Pass_Atten:Real):Integer;
Function Electrode(Center_Frequency,Ci:real):Real;
Function Calculate_C0(Center_Frequency,Electrode_Diameter:Real;Harmonic:Integer):Real;
function  dbm_to_volt(z,dbm:real):real;
function  volt_to_dbm(v,z:real):real;
implementation


Function Determine_Order(cheby:boolean;Pass_Frequency,Stop_Frequency,Stop_Atten,Pass_Atten:Real):Integer;


begin
  {Stopband attenuation. i.e 60db}
  {Passband ripple i.e 0.01db}
 // Pass_Frequency := Pass_Frequency*Power(10,6);{make them in MHz}
//Stop_frequency := Stop_Frequency*Power(10,6);{make them in MHz}

if (cheby=True) then
{cheby}

Determine_Order := Round(ArcCosh(Sqrt(Power(10,Stop_Atten/10)-1)/Sqrt(Power(10,Pass_Atten/10)-1))/ArcCosh((2*3.14*Stop_frequency)/(2*3.14*Pass_Frequency)))+1
Else
{butterworth}
Determine_Order  := Round(Log10(Sqrt(Power(10,Stop_Atten/10)-1)/(Power(10,Pass_Atten/10)-1))/Log10((2*3.14*Stop_frequency)/(2*3.14*Pass_Frequency)));
end;

Function Electrode(Center_Frequency,Ci:Real):Real;
{
This procedure suppose that the crystal has been orderd as AT-Cut
with angle of 35+1/4. if other angle has been taken into account is far out.
For correction must recalculate the C and e cosntant.
To do that need the new angle
S:=Sin(angle);c_temp:=Cos(angle); so e:=(e14*s-e11*c)*c This is the new e26
and C=C44*s^2+2*C14*s*c+c66*c^2. This is the new c66.
More information to introduction to Quartz crystal unit design
d=blank thickness for At-Cut 1660KHz/Frequency in MHz and the result is in mm.
}
var
e,c,d,A,Ci_temp:real;
begin
e:=9.65*Power(10,-2);
d:=1660/(Center_Frequency*Power(10,6));
c:=29.3*Power(10,9);
Ci_temp:=Ci*Power(10,-15);{must be in fF 10^-15f}
Result:=(Power(3.14,2)*d*c*Ci_temp)/(8*Power(e,2));{Electrode Area}
{Result:=Sqrt((4*Power(3.14,2)*d*c*Ci_temp)/(8*Power(e,2))/3.14)); electrode diameter}


end;
Function Calculate_C0(Center_Frequency,Electrode_Diameter:Real;Harmonic:Integer):Real;
var
d,k,e0:Real;
begin
d:=1660/Center_Frequency;
e0:=8.85*Power(10,-12);
k:=4.5;{Quartz crystal dielectric constant}
if harmonic>1 then Result:=k*e0*Electrode_diameter*Power(Harmonic,2)
Else
Result:= (k*e0*Electrode_Diameter)/d;
end;
 function  dbm_to_volt(z,dbm:real):real;
begin
Result:=sqrt(z/1000)*power(10,dbm/20);
end;

function  volt_to_dbm(v,z:real):real;
begin
Result:=10*Log10(power(v,2)*1000/z);
end;

end.

