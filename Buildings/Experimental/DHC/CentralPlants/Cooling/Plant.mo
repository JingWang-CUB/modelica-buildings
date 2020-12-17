within Buildings.Experimental.DHC.CentralPlants.Cooling;
model Plant "District cooling plant model"
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Integer numChi(
    min=1,
    max=2)=2
    "Number of chillers, maximum is 2";
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced",group="Diagnostics"));
  // chiller parameters
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi
    "Performance data of chiller"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,Placement(transformation(extent={{98,82},{112,96}})));
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal chilled water mass flow rate"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.Pressure dpCHW_nominal
    "Pressure difference at the chilled water side"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.HeatFlowRate QEva_nominal
    "Nominal cooling capacity of single chiller (negative means cooling)"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller"
    annotation (Dialog(group="Chiller"));
  // cooling tower parameters
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal condenser water mass flow rate"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Pressure dpCW_nominal
    "Pressure difference at the condenser water side"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal air wetbulb temperature"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TCW_nominal
    "Nominal condenser water temperature at tower inlet"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TMin
    "Minimum allowed water temperature entering chiller"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Power PFan_nominal
    "Fan power"
    annotation (Dialog(group="Cooling Tower"));
  // pump parameters
  parameter Buildings.Fluid.Movers.Data.Generic perCHWPum
    "Performance data of chilled water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,Placement(transformation(extent={{120,82},{134,96}})));
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum
    "Performance data of condenser water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,Placement(transformation(extent={{142,82},{156,96}})));
  parameter Modelica.SIunits.Pressure dpCHWPum_nominal
    "Nominal pressure drop of chilled water pumps"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Pressure dpCWPum_nominal
    "Nominal pressure drop of condenser water pumps"
    annotation (Dialog(group="Pump"));
  // control settings
  parameter Modelica.SIunits.Time tWai
    "Waiting time"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.SIunits.PressureDifference dpSetPoi(
    displayUnit="Pa")
    "Demand side pressure difference setpoint"
    annotation (Dialog(group="Control Settings"));
  // dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  Medium.ThermodynamicState sta_a(
    T(start=273.15+16))=Medium.setState_phX(
    port_a.p,
    noEvent(
      actualStream(
        port_a.h_outflow)),
    noEvent(
      actualStream(
        port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";
  Medium.ThermodynamicState sta_b(
    T(start=273.15+7))=Medium.setState_phX(
    port_b.p,
    noEvent(
      actualStream(
        port_b.h_outflow)),
    noEvent(
      actualStream(
        port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium,
    m_flow(
      start=mCHW_flow_nominal))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,40},{170,60}}),iconTransformation(extent={{90,40},{110,60}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium,
    m_flow(
      start=-mCHW_flow_nominal))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,-60},{170,-40}}),iconTransformation(extent={{90,-60},{110,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final unit="K",
    displayUnit="degC")
    "Set point for chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),iconTransformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
    "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput dpMea(
    final unit="Pa")
    "Measured pressure difference"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Fluid.Chillers.ElectricEIR mulChiSys[numChi](
    each final per=perChi,
    each final m1_flow_nominal=mCHW_flow_nominal,
    each final m2_flow_nominal=mCW_flow_nominal,
    each final dp1_nominal=dpCHW_nominal,
    each final dp2_nominal=dpCW_nominal,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare each final package Medium1 = Medium,
    redeclare each final package Medium2 = Medium) "Chillers connected in parallel"
    annotation (Placement(transformation(extent={{10,20},{-10,0}})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass cooTowWitByp(
    redeclare final package Medium=Medium,
    final num=numChi,
    final use_inputFilter=false,
    final m_flow_nominal=mCW_flow_nominal,
    final dp_nominal=dpCW_nominal,
    final TAirInWB_nominal=TAirInWB_nominal,
    final TWatIn_nominal=TCW_nominal,
    final dT_nominal=dT_nominal,
    final PFan_nominal=PFan_nominal,
    final TMin=TMin,
    final energyDynamics=energyDynamics)
    "Cooling towers with bypass valve"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCHW[numChi](
    redeclare each final package Medium = Medium,
    each final per=perCHWPum,
    each final addPowerToMedium=false,
    each final use_inputFilter=false,
    each init=Modelica.Blocks.Types.Init.InitialOutput,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each y_start=1)
    "Chilled water pumps"
    annotation (Placement(transformation(extent={{10,40},{-10,60}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m pumCW(
    redeclare final package Medium=Medium,
    final per=fill(
      perCWPum,
      numChi),
    final use_inputFilter=false,
    final yValve_start=fill(1, numChi),
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mCW_flow_nominal,
    final dpValve_nominal=dpCWPum_nominal,
    final num=numChi)
    "Condenser water pumps"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare final package Medium=Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=mCHW_flow_nominal*0.05,
    final dpValve_nominal=dpCHW_nominal,
    final use_inputFilter=false)
    "Chilled water bypass valve"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={80,0})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(
    redeclare final package Medium=Medium)
    "Chilled water bypass valve mass flow meter"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,origin={80,-30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={130,-50})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChilledWaterPumpSpeed
    chiWatPumCon(
    tWai=0,
    final m_flow_nominal=mCHW_flow_nominal,
    final dpSetPoi=dpSetPoi) "Chilled water pump controller"
    annotation (Placement(transformation(extent={{-120,-26},{-100,-6}})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChillerStage chiStaCon(
    final tWai=tWai,
    final QEva_nominal=QEva_nominal)
    "Chiller staging controller"
    annotation (Placement(transformation(extent={{-120,46},{-100,66}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(final y=pumCHW[1].port_b.m_flow
         + pumCHW[2].port_b.m_flow)
    "Total chilled water pump mass flow rate"
    annotation (Placement(transformation(extent={{-100,-2},{-120,18}})));
  Modelica.Blocks.Sources.RealExpression mValByp_flow(
    final y=valByp.port_a.m_flow/(
      if chiStaCon.y[numChi] then
        numChi*mMin_flow
      else
        mMin_flow))
    "Chilled water bypass valve mass flow rate"
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Buildings.Controls.Continuous.LimPID bypValCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Chilled water bypass valve controller"
    annotation (Placement(transformation(extent={{140,-10},{120,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,50})));
  Modelica.Blocks.Math.Add dT(
    final k1=-1,
    final k2=+1)
    "Temperature difference"
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{40,70},{20,90}})));
  Modelica.Blocks.Math.Gain cp(
    final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{0,70},{-20,90}})));
  Buildings.Fluid.Sources.Boundary_pT expTanCW(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Condenser water expansion tank"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Fluid.Sources.Boundary_pT expTanCHW(
    redeclare final package Medium=Medium,
    final nPorts=1)
    "Chilled water expansion tank"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium)
    "Chilled water return mass flow"
    annotation (Placement(transformation(extent={{50,40},{30,60}})));
  Modelica.Blocks.Sources.Constant mSetSca_flow(
    final k=1)
    "Scaled bypass valve mass flow setpoint"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal chiOn[numChi]
    "Convert chiller on signal from boolean to real"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=Medium.specificHeatCapacityCp(
    sta_default)
    "Specific heat capacity of the fluid";
initial equation
  Modelica.Utilities.Streams.print(
    "Warning:\n  In "+getInstanceName()+": This model is a beta version and is not fully validated yet.");
equation
  connect(senTCHWSup.port_b,port_b)
    annotation (Line(points={{140,-50},{160,-50}},color={0,127,255}));
  connect(senMasFloByp.port_b,valByp.port_a)
    annotation (Line(points={{80,-20},{80,-10}},color={0,127,255}));
  connect(senMasFloByp.port_a,senTCHWSup.port_a)
    annotation (Line(points={{80,-40},{80,-50},{120,-50}},color={0,127,255}));
  connect(cooTowWitByp.port_b,pumCW.port_a)
    annotation (Line(points={{-40,-50},{-10,-50}},color={0,127,255}));
  connect(on,chiStaCon.on)
    annotation (Line(points={{-160,60},{-122,60}},color={255,0,255}));
  connect(TWetBul,cooTowWitByp.TWetBul)
    annotation (Line(points={{-160,-60},{-76,-60},{-76,-52},{-62,-52}},color={0,0,127}));
  connect(chiWatPumCon.dpMea, dpMea)
    annotation (Line(points={{-122,-20},{-160,-20}}, color={0,0,127}));
  connect(mPum_flow.y, chiWatPumCon.masFloPum) annotation (Line(points={{-121,8},
          {-132,8},{-132,-12},{-122,-12}}, color={0,0,127}));
  connect(bypValCon.y,valByp.y)
    annotation (Line(points={{119,0},{92,0}},color={0,0,127}));
  connect(mValByp_flow.y,bypValCon.u_m)
    annotation (Line(points={{139,-30},{130,-30},{130,-12}},color={0,0,127}));
  connect(port_a,senTCHWRet.port_a)
    annotation (Line(points={{160,50},{140,50}},color={0,127,255}));
  connect(senTCHWSup.T,dT.u2)
    annotation (Line(points={{130,-39},{130,-32},{116,-32},{116,74},{82,74}},color={0,0,127}));
  connect(senTCHWRet.T,dT.u1)
    annotation (Line(points={{130,61},{130,78},{88,78},{88,86},{82,86}},color={0,0,127}));
  connect(dT.y,pro.u1)
    annotation (Line(points={{59,80},{54,80},{54,86},{42,86}},color={0,0,127}));
  connect(cp.u,pro.y)
    annotation (Line(points={{2,80},{19,80}},color={0,0,127}));
  connect(cp.y,chiStaCon.QLoa)
    annotation (Line(points={{-21,80},{-130,80},{-130,52},{-122,52}},color={0,0,127}));
  connect(pumCHW.port_b,mulChiSys.port_a2)
    annotation (Line(points={{-10,50},{-20,50},{-20,16},{-10,16}},color={0,127,255}));
  connect(expTanCW.ports[1],pumCW.port_a)
    annotation (Line(points={{-30,-20},{-26,-20},{-26,-50},{-10,-50}},color={0,127,255}));
  connect(senTCHWRet.port_b,senMasFlo.port_a)
    annotation (Line(points={{120,50},{50,50}},color={0,127,255}));
  connect(senMasFlo.m_flow,pro.u2)
    annotation (Line(points={{40,61},{40,66},{54,66},{54,74},{42,74}},color={0,0,127}));
  connect(expTanCHW.ports[1],senMasFlo.port_a)
    annotation (Line(points={{70,30},{80,30},{80,50},{50,50}},color={0,127,255}));
  connect(valByp.port_b,senMasFlo.port_a)
    annotation (Line(points={{80,10},{80,50},{50,50}},color={0,127,255}));
  connect(mSetSca_flow.y,bypValCon.u_s)
    annotation (Line(points={{111,20},{150,20},{150,0},{142,0}},color={0,0,127}));
  connect(chiStaCon.y,mulChiSys.on)
    annotation (Line(points={{-99,56},{-92,56},{-92,24},{24,24},{24,7},{12,7}},color={255,0,255}));
  connect(chiStaCon.y[1],bypValCon.trigger)
    annotation (Line(points={{-99,55.5},{-92,55.5},{-92,24},{40,24},{40,-18},{138,-18},{138,-12}},color={255,0,255}));
  connect(chiStaCon.y,chiOn.u)
    annotation (Line(points={{-99,56},{-92,56},{-92,50},{-82,50}},color={255,0,255}));
  connect(chiOn.y,pumCW.u)
    annotation (Line(points={{-58,50},{-22,50},{-22,-46},{-12,-46}},color={0,0,127}));
  connect(chiStaCon.y,cooTowWitByp.on)
    annotation (Line(points={{-99,56},{-92,56},{-92,-46},{-62,-46}},color={255,0,255}));
  connect(chiWatPumCon.y, pumCHW.y) annotation (Line(points={{-99,-16},{-80,-16},
          {-80,10},{-40,10},{-40,66},{0,66},{0,62}}, color={0,0,127}));
  connect(mulChiSys[1].port_b1, cooTowWitByp.port_a) annotation (Line(points={{-10,
          4},{-72,4},{-72,-50},{-60,-50}}, color={0,127,255}));
  connect(mulChiSys[2].port_b1, cooTowWitByp.port_a) annotation (Line(points={{-10,
          4},{-72,4},{-72,-50},{-60,-50}}, color={0,127,255}));
  connect(pumCW.port_b, mulChiSys[1].port_a1) annotation (Line(points={{10,-50},
          {20,-50},{20,4},{10,4}}, color={0,127,255}));
  connect(pumCW.port_b, mulChiSys[2].port_a1) annotation (Line(points={{10,-50},
          {20,-50},{20,4},{10,4}}, color={0,127,255}));
  connect(mulChiSys[1].port_b2, senTCHWSup.port_a) annotation (Line(points={{10,
          16},{34,16},{34,-50},{120,-50}}, color={0,127,255}));
  connect(mulChiSys[2].port_b2, senTCHWSup.port_a) annotation (Line(points={{10,
          16},{34,16},{34,-50},{120,-50}}, color={0,127,255}));
  connect(pumCHW[1].port_a, senMasFlo.port_b)
    annotation (Line(points={{10,50},{30,50}}, color={0,127,255}));
  connect(pumCHW[2].port_a, senMasFlo.port_b)
    annotation (Line(points={{10,50},{30,50}}, color={0,127,255}));
  connect(TCHWSupSet, mulChiSys[1].TSet) annotation (Line(points={{-160,20},{20,
          20},{20,13},{12,13}}, color={0,0,127}));
  connect(TCHWSupSet, mulChiSys[2].TSet) annotation (Line(points={{-160,20},{20,
          20},{20,13},{12,13}}, color={0,0,127}));
  annotation (
    defaultComponentName="pla",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-80},{160,100}})),
    Documentation(
      info="<html>
<p>
This model showcases a generic district central cooling plant with two chillers as the cooling source.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation. 
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-14},{-62,-14}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,-60},{-80,-60},{-80,60},{-60,60},{-60,0},{-40,0},{-40,20},{0,0},{0,20},{40,0},{40,20},{80,0},{80,-60}},
          lineColor={95,95,95},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,-38},{58,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{62,-38},{74,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{62,-54},{74,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,-54},{58,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-54},{34,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-54},{18,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-38},{18,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-38},{34,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-54},{-6,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-54},{-22,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-38},{-22,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-38},{-6,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}));
end Plant;
