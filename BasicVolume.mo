within ;
model BasicVolume
 connector FlowConnector
    import Modelica.SIunits.*;
                            //
  Pressure P;
  SpecificEnthalpy h;
  flow MassFlowRate mdot;
 end FlowConnector;

  model IdealGas
    import Modelica.SIunits.*;
                            //
  parameter SpecificInternalEnergy u_0=209058;
  parameter SpecificHeatCapacity c_v=717;
  parameter SpecificHeatCapacity R=287;
  parameter Temperature T_0=293;
  Pressure P;
  SpecificVolume v;
  Temperature T;
  SpecificInternalEnergy u;
  equation
  u=u_0+c_v*(T-T_0);
  P*v=R*T;
  end IdealGas;

  model BasicVolume
    import Modelica.SIunits.*;
  extends IdealGas;
  FlowConnector inlet;
  FlowConnector outlet;
  parameter Mass m_0=0.00119;
  Mass m(start=m_0);
  Volume V;
  MassFlowRate mdot_in;
  MassFlowRate mdot_out;
  SpecificEnthalpy h_in;
  SpecificEnthalpy h_out;     //??????
  SpecificEnthalpy h;//????????
  Enthalpy H;//????????
  SpecificInternalEnergy u;//?????????
  InternalEnergy U(start=u_0*m_0);//????????
  HeatFlowRate Qdot;//???
  Power Wdot_e;
  Power Wdot_s;       //????????????
  equation
  mdot_in =inlet.mdot;
  h_in=inlet.h;
  P=inlet.P;
  mdot_out=-outlet.mdot;
  h_out=outlet.h;
  P=outlet.P;
  h=h_out;
  der(m)=mdot_in-mdot_out;
  der(U)=h_in*mdot_in-h_out*mdot_out+Qdot-Wdot_e;
  Wdot_e=P*der(V)+Wdot_s;
  H=U+P*V;
  u=U/m;
  v=V/m;
  h=H/m;
  //this is a change
  u=V;
  end BasicVolume;

 extends BasicVolume;

equation
 inlet.h=300190;
  V=1e-3+0.1e-3*(if time >0.5 then time-0.5 else 0);
  Qdot=0;
  Wdot_s=0;

  annotation (uses(Modelica(version="3.1")));
end BasicVolume;
