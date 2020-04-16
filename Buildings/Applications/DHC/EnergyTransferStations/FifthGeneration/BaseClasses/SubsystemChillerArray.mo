within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model SubsystemChillerArray "Central subsystem based on heat recovery chiller"
  replaceable package Medium = Buildings.Media.Water
    "Medium model";
  parameter Integer nPorts_aAmbWat = 0
    "Number of fluid connectors for ambient water return"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_bAmbWat = 0
    "Number of fluid connectors for ambient water supply"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_aChiWat = 0
    "Number of fluid connectors for chilled water return"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_bChiWat = 0
    "Number of fluid connectors for chilled water supply"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_aHeaWat = 0
    "Number of fluid connectors for heating water return"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_bHeaWat = 0
    "Number of fluid connectors for heating water supply"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Modelica.SIunits.PressureDifference dpCon_nominal
    "Nominal pressure drop in condenser branch (including valve)"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal
    "Nominal pressure drop in evaporator branch (including valve)"
    annotation (Dialog(group="Chiller"));
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "Chiller performance data"
    annotation (Placement(transformation(extent={{180,-200},{200,-180}})));
  final parameter Modelica.SIunits.PressureDifference dpValAmb_nominal(displayUnit="Pa")=1000
    "Pressure drop at nominal flow rate for the directional two-way valves"
    annotation (Dialog(group="Design Parameter"));
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=
    datChi.mEva_flow_nominal
    "Condenser nominal water flow rate" annotation (Dialog(group="Chiller"));
  final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=
    datChi.mEva_flow_nominal
    "Evaporator nominal water flow rate" annotation (Dialog(group="Chiller"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal"        annotation (Placement(transformation(
          extent={{-300,240},{-260,280}}), iconTransformation(extent={{-180,100},
            {-140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal"        annotation (Placement(transformation(
          extent={{-300,200},{-260,240}}), iconTransformation(extent={{-180,80},
            {-140,120}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nPorts_bHeaWat](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for heating water supply"
    annotation (Placement(transformation(extent={{250,0},{270,80}}),
      iconTransformation(extent={{130,-40},{150,40}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nPorts_aHeaWat](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for heating water return"
    annotation (Placement(transformation(extent={{250,-80},{270,0}}),
      iconTransformation(extent={{130,-134},{150,-54}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aAmbWat[nPorts_aAmbWat](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for ambient water return"
    annotation (Placement(
      transformation(
      extent={{-10,-40},{10,40}},
      rotation=-90,
      origin={-40,-260}), iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=-90,
        origin={-46,-140})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bAmbWat[nPorts_bAmbWat](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for ambient water supply"
    annotation (Placement(
        transformation(
        extent={{-10,-40},{10,40}},
        rotation=-90,
        origin={40,-260}), iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=-90,
        origin={46,-140})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nPorts_aChiWat](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for chilled water return"
    annotation (Placement(
        transformation(
        extent={{-10,-40},{10,40}},
        rotation=0,
        origin={-260,-40}), iconTransformation(extent={{-150,-134},{-130,-54}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nPorts_bChiWat](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for chilled water supply"
    annotation (Placement(
        transformation(
        extent={{-10,-40},{10,40}},
        rotation=0,
        origin={-260,40}), iconTransformation(extent={{-150,-40},{-130,40}})));
  // COMPONENTS
  Fluid.Chillers.ElectricEIR chi(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    from_dp1=true,
    dp1_nominal=dpCon_nominal,
    linearizeFlowResistance1=true,
    from_dp2=true,
    dp2_nominal=dpEva_nominal,
    linearizeFlowResistance2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=datChi,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
    annotation (Placement(transformation(extent={{-10,96},{10,116}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCon(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    per(pressure(dp={dpCon_nominal,0}, V_flow={0,mCon_flow_nominal/1000})),
    allowFlowReversal=false)
    "Condenser pump"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumEva(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    per(pressure(dp={dpEva_nominal,0}, V_flow={0,mEva_flow_nominal/1000})),
    allowFlowReversal=false)
    "Evaporator pump"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-100,60})));
  FifthGeneration.Controls.Chiller conChi "Chiller controller"
    annotation (Placement(transformation(extent={{-220,234},{-200,254}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0) "Condenser water leaving temperature (measured)"
    annotation (Placement(
      transformation(
      extent={{10,10},{-10,-10}},
      rotation=180,
      origin={40,140})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0) "Condenser water entering temperature (measured)"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=0)
    "Evaporator water entering temperature (measured)"
    annotation (Placement(
      transformation(
      extent={{-10,10},{10,-10}},
      rotation=180,
      origin={60,60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Evaporator water leaving temperature (measured)"
    annotation (Placement(transformation(extent={{-50,50},{-70,70}})));
  Junction splEva(
    m_flow_nominal=mEva_flow_nominal .* {1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter for the evaporator water circuit"
    annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={-140,60})));
  Junction splConMix(
    m_flow_nominal=mCon_flow_nominal .* {1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},
      rotation=0,
      origin={120,140})));
  Fluid.Actuators.Valves.TwoWayLinear valConDir(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dpValAmb_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mCon_flow_nominal)
    "Two-way directional valve"
    annotation (Placement(transformation(extent={{130,-90},{110,-70}})));
  Fluid.Actuators.Valves.TwoWayLinear valEvaDir(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dpValAmb_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mEva_flow_nominal)
    "Two-way directional valve"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEvaMix(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mEva_flow_nominal,
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three-way mixing valve controlling evaporator water entering temperature"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={120,60})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valConMix(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mCon_flow_nominal,
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three-way mixing valve to controlling condenser water entering temperature"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-140,140})));
  Junction splEvaSup(
    m_flow_nominal=mEva_flow_nominal .* {1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-180,40})));
  Junction splAmbRet(
    m_flow_nominal=max(mEva_flow_nominal, mCon_flow_nominal) .* {1,1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-80})));
  Junction splConSup(
    m_flow_nominal=mCon_flow_nominal .* {1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={180,40})));
  Junction splAmbSup(
    m_flow_nominal=max(mEva_flow_nominal, mCon_flow_nominal) .* {-1,-1,1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-140})));
  Junction splConRet(
    m_flow_nominal=mCon_flow_nominal .* {1,-1,1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-220,-40})));
  Junction splEvaRet(
    m_flow_nominal=mEva_flow_nominal .* {1,-1,1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={220,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC")
    "Chilled water supply temperature set-point (may be reset down)"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
        iconTransformation(extent={{-180,40},{-140,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Constant speed primary pumps control signal"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-180,60},{-140,100}})));
initial equation
  assert(nPorts_aAmbWat == nPorts_bAmbWat,
    "In " + getInstanceName() +
    ": The numbers of ambient water supply ports (" + String(nPorts_bAmbWat) +
    ") and return ports (" + String(nPorts_aAmbWat) + ") must be equal.");
  assert(nPorts_aChiWat == nPorts_bChiWat,
    "In " + getInstanceName() +
    ": The numbers of chilled water supply ports (" + String(nPorts_bAmbWat) +
    ") and return ports (" + String(nPorts_aAmbWat) + ") must be equal.");
  assert(nPorts_aHeaWat == nPorts_bHeaWat,
    "In " + getInstanceName() +
    ": The numbers of heating water supply ports (" + String(nPorts_bAmbWat) +
    ") and return ports (" + String(nPorts_aAmbWat) + ") must be equal.");
equation
  connect(splConMix.port_3, valConMix.port_3) annotation (Line(points={{120,150},
          {120,180},{-140,180},{-140,150}}, color={0,127,255}));
  connect(senTConLvg.port_b, splConMix.port_1)
    annotation (Line(points={{50,140},{110,140}}, color={0,127,255}));
  connect(chi.port_b1, senTConLvg.port_a) annotation (Line(points={{10,112},{20,
          112},{20,140},{30,140}}, color={0,127,255}));
  connect(valConMix.port_2, pumCon.port_a)
    annotation (Line(points={{-130,140},{-110,140}}, color={0,127,255}));
  connect(pumCon.port_b, senTConEnt.port_a)
    annotation (Line(points={{-90,140},{-50,140}}, color={0,127,255}));
  connect(senTConEnt.port_b, chi.port_a1) annotation (Line(points={{-30,140},{
          -20,140},{-20,112},{-10,112}}, color={0,127,255}));
  connect(valEvaMix.port_2, senTEvaEnt.port_a)
    annotation (Line(points={{110,60},{70,60}}, color={0,127,255}));
  connect(senTEvaEnt.port_b, chi.port_a2) annotation (Line(points={{50,60},{20,
          60},{20,100},{10,100}}, color={0,127,255}));
  connect(chi.port_b2, senTEvaLvg.port_a) annotation (Line(points={{-10,100},{
          -20,100},{-20,60},{-50,60}},
                                   color={0,127,255}));
  connect(senTEvaLvg.port_b, pumEva.port_a)
    annotation (Line(points={{-70,60},{-90,60}}, color={0,127,255}));
  connect(pumEva.port_b, splEva.port_1)
    annotation (Line(points={{-110,60},{-130,60}}, color={0,127,255}));
  connect(splEva.port_3, valEvaMix.port_3) annotation (Line(points={{-140,50},{-140,
          20},{120,20},{120,50}}, color={0,127,255}));
  connect(splEva.port_2, splEvaSup.port_1) annotation (Line(points={{-150,60},{-180,
          60},{-180,50}}, color={0,127,255}));
  connect(splEvaSup.port_2,valEvaDir. port_a) annotation (Line(points={{-180,30},
          {-180,-80},{-110,-80}}, color={0,127,255}));
  connect(conChi.yValEva, valEvaMix.y) annotation (Line(points={{-198,240},{100,
          240},{100,80},{120,80},{120,72}}, color={0,0,127}));
  connect(conChi.yValCon, valConMix.y) annotation (Line(points={{-198,236},{-160,
          236},{-160,120},{-140,120},{-140,128}}, color={0,0,127}));
  connect(valEvaDir.port_b, splAmbRet.port_1)
    annotation (Line(points={{-90,-80},{30,-80}}, color={0,127,255}));
  connect(splAmbRet.port_2,valConDir. port_b)
    annotation (Line(points={{50,-80},{110,-80}}, color={0,127,255}));
  connect(splConMix.port_2, splConSup.port_1) annotation (Line(points={{130,140},
          {180,140},{180,50}}, color={0,127,255}));
  connect(splConSup.port_2,valConDir. port_a) annotation (Line(points={{180,30},
          {180,-80},{130,-80}}, color={0,127,255}));
  connect(conChi.yChi, chi.on) annotation (Line(points={{-198,252},{-60,252},{-60,
          109},{-12,109}}, color={255,0,255}));
  connect(conChi.TChiWatSupSet, chi.TSet) annotation (Line(points={{-198,248},{-64,
          248},{-64,103},{-12,103}},     color={0,0,127}));
  connect(uHea, conChi.uHea) annotation (Line(points={{-280,260},{-240,260},{
          -240,252},{-222,252}},color={255,0,255}));
  connect(uCoo, conChi.uCoo) annotation (Line(points={{-280,220},{-246,220},{
          -246,250},{-222,250}},
                            color={255,0,255}));
  connect(TChiWatSupSet, conChi.TChiWatSupSetMax) annotation (Line(points={{-280,
          140},{-240,140},{-240,246},{-222,246}}, color={0,0,127}));
  connect(splEvaRet.port_2, valEvaMix.port_1)
    annotation (Line(points={{220,-30},{220,60},{130,60}}, color={0,127,255}));
  connect(splAmbSup.port_2, splEvaRet.port_1) annotation (Line(points={{-30,-140},
          {220,-140},{220,-50}}, color={0,127,255}));
  connect(splConRet.port_2, valConMix.port_1) annotation (Line(points={{-220,-30},
          {-220,140},{-150,140}}, color={0,127,255}));
  connect(splAmbSup.port_1, splConRet.port_1) annotation (Line(points={{-50,-140},
          {-220,-140},{-220,-50}}, color={0,127,255}));
  // LOOP OVER ARRAY FLUID CONNECTORS
  for i in 1:nPorts_aAmbWat loop
    connect(splAmbRet.port_3, ports_bAmbWat[i])
      annotation (Line(points={{40,-90},
      {40,-260},{40,-260}}, color={0,127,255}));
    connect(ports_aAmbWat[i], splAmbSup.port_3)
      annotation (Line(points={{-40,-260},{-40,-150}}, color={0,127,255}));
  end for;
  for i in 1:nPorts_aChiWat loop
    connect(splEvaSup.port_3, ports_bChiWat[i])
      annotation (Line(points={{-190,40},{-260,40}}, color={0,127,255}));
    connect(splEvaRet.port_3, ports_aChiWat[i])
      annotation (Line(points={{210,-40},
      {20,-40},{20,-60},{-240,-60},{-240,-40},{-260,-40}}, color={0,127,255}));
  end for;
  for i in 1:nPorts_aHeaWat loop
    connect(splConSup.port_3, ports_bHeaWat[i])
      annotation (Line(points={{190,40},{260,40}}, color={0,127,255}));
    connect(splConRet.port_3, ports_aHeaWat[i])
      annotation (Line(points={{-210,-40},{-20,-40},{-20,-20},{240,-20},{240,-40},
        {260,-40}}, color={0,127,255}));
  end for;
  connect(uHea, booToRea[1].u) annotation (Line(points={{-280,260},{-252,260},{
          -252,200},{-222,200}}, color={255,0,255}));
  connect(uCoo, booToRea[2].u) annotation (Line(points={{-280,220},{-252,220},{
          -252,200},{-222,200}}, color={255,0,255}));
  connect(booToRea[1].y, pumCon.y) annotation (Line(points={{-198,200},{-100,
          200},{-100,152}}, color={0,0,127}));
  connect(booToRea[2].y, pumEva.y) annotation (Line(points={{-198,200},{-120,
          200},{-120,80},{-100,80},{-100,72}}, color={0,0,127}));
  connect(senTConEnt.T, conChi.TConWatEnt) annotation (Line(points={{-40,151},{
          -40,222},{-224,222},{-224,240},{-222,240}}, color={0,0,127}));
  connect(senTEvaEnt.T, conChi.TEvaWatEnt) annotation (Line(points={{60,71},{60,
          220},{-226,220},{-226,242},{-222,242}}, color={0,0,127}));
  connect(THeaWatSupSet, conChi.THeaWatSupSet) annotation (Line(points={{-280,
          180},{-242,180},{-242,248},{-222,248}}, color={0,0,127}));
  connect(senTConLvg.T, conChi.THeaWatSup) annotation (Line(points={{40,151},{
          40,218},{-228,218},{-228,244},{-222,244}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},
            {140,140}}),
  graphics={
    Rectangle(
      extent={{-140,-140},{140,140}},
      lineColor={0,0,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
   Text(
      extent={{-120,180},{120,140}},
      textString="%name",
      lineColor={0,0,255}),
    Rectangle(
      extent={{-60,60},{60,-60}},
      lineColor={27,0,55},
      fillColor={170,213,255},
      fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
              extent={{-260,-260},{260,280}}),
              graphics={Line(
              points={{86,92}},
              color={28,108,200},
              pattern=LinePattern.Dash)}),
    defaultComponentName="chi",
  Documentation(info="<html>
<p>
This models represents an energy transfer station (ETS) for fifth generation
district heating and cooling systems.
The control logic is based on five operating modes:
</p>
<ul>
<li>
heating only,
</li>
<li>
cooling only,
</li>
<li>
simultaneous heating and cooling,
</li>
<li>
part surplus heat or cold rejection,
</li>
<li>
full surplus heat or cold rejection.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image the 5th generation of district heating and cooling substation\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/SubstationModifiedLayout.png\"/>
<p>
The substation layout consists in three water circuits:
</p>
<ol>
<li>
the heating water circuit, which is connected to the building heating water
distribution system,
</li>
<li>
the chilled water circuit, which is connected to the building chilled water
distribution system,
</li>
<li>
the ambient water circuit, which is connected to the district heat exchanger
(and optionally to the geothermal borefield).
</li>
</ol>
<h4>Heating water circuit</h4>
<p>
It satisfies the building heating requirements and consists in:
</p>
<ol>
<li>
the heating/cooling generating source, where the EIR chiller i.e. condenser heat exchanger operates to satisfy the heating setpoint
<code>TSetHea</code>.
</li>
<li>
The constant speed condenser water pump <code>pumCon</code>.
</li>
<li>
The hot buffer tank, is implemented to provide hydraulic decoupling between the primary (the ETS side) and secondary (the building side)
water circulators i.e. pumps and to eliminate the cycling of the heat generating source machine i.e EIR chiller.
</li>
<li>
Modulating mixing three way valve <code>valCon</code> to control the condenser entering water temperature.
</li>
</ol>
<h4>Chilled water circuit</h4>
<p>
It operates to satisfy the building cooling requirements and consists of
</p>
<ol>
<li>
The heating/cooling generating source, where the  EIR chiller i.e evaporator heat
exchanger operates to satisfy the cooling setpoint <code>TSetCoo</code>.
</li>
<li>
The constant speed evaporator water pump <code>pumEva</code>.
</li>
<li>
The chilled water buffer tank, is implemented obviously for the same mentioned reasons of the hot buffer tank.
</li>
<li>
Modulating mixing three way valve <code>valEva</code> to control the evaporator entering water temperature.
</li>
</ol>
<p>
For more detailed description of
</p>
<p>
The controller of heating/cooling generating source, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController.</a>
</p>
<p>
The evaporator pump <code>pumEva</code> and the condenser pump <code>pumCon</code>, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed\">
Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed.</a>
</p>
<h4>Ambient water circuit</h4>
<p>
The ambient water circuit operates to maximize the system exergy by rejecting surplus i.e. heating or cooling energy
first to the borefield system and second to either or both of the borefield and the district systems.
It consists of
</p>
<ol>
<li>
The borefield component model <code>borFie</code>.
</li>
<li>
The borefield pump <code>pumBor</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Modulating mixing three way valve <code>valBor</code> to control the borefield entering water temperature.
</li>
<li>
The heat exchanger component model <code>hex</code>.
</li>
<li>
The heat exchanger district pump <code>pumHexDis</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Two on/off 2-way valves <code> valHea</code>, <code>valCoo</code>
which separates the ambient from the chilled water and heating water circuits.
</ol>
<p>
For more detailed description of the ambient circuit control concept see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController.</a>
</p>
<h4>Notes</h4>
<p>
For more detailed description of the finite state machines which transitions the ETS between
different operational modes, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a> and
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
January 18, 2020, by Hagar Elarga: <br/>
First implementation
</li>
</ul>
</html>"));
end SubsystemChillerArray;
