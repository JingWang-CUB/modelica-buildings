within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconDamperPositionLimitsSingleZone_Disable
  "Validation model for the Single zone VAV AHU minimum outdoor air control - damper position limits"
  extends Modelica.Icons.Example;

  parameter Real minFanSpe=0.1 "Minimum supply fan operation speed";
  parameter Real maxFanSpe=0.9 "Maximum supply fan operation speed";
  parameter Real delFanSpe = maxFanSpe - minFanSpe "Delta between the min and max supply fan speed";
  parameter Modelica.SIunits.VolumeFlowRate desVOut_flow=2.0 "Calculated design outdoor airflow rate";
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=1.0 "Calculated minimum outdoor airflow rate";
  parameter Modelica.SIunits.VolumeFlowRate delVOut_flow = desVOut_flow - minVOut_flow
    "Delta between minimum and design outdoor airflow rate";
  parameter Types.FreezeProtectionStage freProStage1 = Types.FreezeProtectionStage.stage1
    "Freeze protection stage 1";
  parameter Types.FreezeProtectionStage freProStage2 = Types.FreezeProtectionStage.stage2
    "Freeze protection stage 2";
  parameter Integer freProStage1Num = Integer(freProStage1)-1
    "Numerical value for freeze protection stage 1";
  parameter Integer freProStage2Num = Integer(freProStage2)-1
    "Numerical value for freeze protection stage 2";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "AHU operation mode is Occupied";
  parameter Types.OperationMode warmUp = Types.OperationMode.warmUp
    "AHU operation mode is \"Warmup\"";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for AHU operation mode Occupied";
  parameter Integer warmUpNum = Integer(warmUp)
    "Numerical value for AHU operation mode \"WarmUp\"";
  parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.61
    "Volumetric airflow sensor output, minimum value in the example";
  parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=0.2
    "Maximum increase in airflow volume during the example simulation";

  Modelica.Blocks.Sources.Ramp SupFanSpeSig(
    duration=1800,
    offset=minFanSpe,
    height=delFanSpe) "Supply fan speed signal" annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  EconDamperPositionLimitsSingleZone ecoDamLim1(
    minFanSpe=minFanSpe,
    maxFanSpe=maxFanSpe,
    minVOut_flow=minVOut_flow,
    desVOut_flow=desVOut_flow) "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

public
  Modelica.Blocks.Sources.Ramp VOutMinSetSig(
    duration=1800,
    offset=minVOut_flow,
    height=delVOut_flow) "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  EconDamperPositionLimitsSingleZone ecoDamLim2(
    minFanSpe=minFanSpe,
    maxFanSpe=maxFanSpe,
    minVOut_flow=minVOut_flow,
    desVOut_flow=desVOut_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  CDL.Logical.Sources.Constant fanStatus1(
                                 k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  CDL.Integers.Sources.Constant freProSta1(
                                  k=freProStage1Num) "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  CDL.Integers.Sources.Constant operationMode1(
                                      k=occupiedNum) "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  CDL.Logical.Sources.Constant fanStatus2(k=true)  "Fan is on"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  CDL.Integers.Sources.Constant freProSta2(k=freProStage1Num) "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  CDL.Integers.Sources.Constant operationMode2(k=warmUpNum)
    "AHU operation mode is NOT Occupied"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  CDL.Logical.Sources.Constant fanStatus3(k=true)  "Fan is on"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  CDL.Integers.Sources.Constant freProSta3(k=freProStage2Num)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  CDL.Integers.Sources.Constant operationMode3(k=occupiedNum) "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  EconDamperPositionLimitsSingleZone ecoDamLim3 annotation (Placement(transformation(extent={{140,-20},{160,0}})));
equation
  connect(SupFanSpeSig.y, ecoDamLim1.uSupFanSpe)
    annotation (Line(points={{-139,30},{-120,30},{-120,-6},{-120,-6.2},{-110,-6.2},{-101,-6.2}}, color={0,0,127}));
  connect(VOutMinSetSig.y, ecoDamLim2.uVOutMinSet_flow)
    annotation (Line(points={{-139,70},{-10,70},{-10,-3},{6,-3},{19,-3}}, color={0,0,127}));
  connect(fanStatus1.y, ecoDamLim1.uSupFan)
    annotation (Line(points={{-139,-30},{-130,-30},{-130,-12},{-130,-12},{-102,-12},{-101,-12}}, color={255,0,255}));
  connect(freProSta1.y, ecoDamLim1.uFreProSta)
    annotation (Line(points={{-139,-90},{-110,-90},{-110,-18},{-101,-18}}, color={255,127,0}));
  connect(operationMode1.y, ecoDamLim1.uOpeMod)
    annotation (Line(points={{-139,-60},{-120,-60},{-120,-15},{-101,-15}}, color={255,127,0}));
  connect(fanStatus2.y,ecoDamLim2. uSupFan) annotation (Line(points={{-19,-30},{-10,-30},{-10,-12},{19,-12}},
                               color={255,0,255}));
  connect(freProSta2.y,ecoDamLim2. uFreProSta) annotation (Line(points={{-19,-90},{10,-90},{10,-18},{19,-18}},
                                              color={255,127,0}));
  connect(operationMode2.y,ecoDamLim2. uOpeMod)
    annotation (Line(points={{-19,-60},{0,-60},{0,-58},{0,-15},{10,-15},{19,-15}},
                                                                      color={255,127,0}));
  connect(fanStatus3.y,ecoDamLim3. uSupFan) annotation (Line(points={{101,-30},{102,-30},{102,-30},{102,-30},{110,-30},{
          110,-12},{139,-12}},  color={255,0,255}));
  connect(freProSta3.y,ecoDamLim3. uFreProSta) annotation (Line(points={{101,-90},{130,-90},{130,-18},{139,-18}},
                                               color={255,127,0}));
  connect(operationMode3.y,ecoDamLim3. uOpeMod)
    annotation (Line(points={{101,-60},{120,-60},{120,-16},{120,-15},{130,-15},{139,-15}},
                                                                       color={255,127,0}));
  connect(VOutMinSetSig.y, ecoDamLim3.uVOutMinSet_flow)
    annotation (Line(points={{-139,70},{130,70},{130,40},{130,-3},{134,-3},{139,-3}}, color={0,0,127}));
  connect(VOutMinSetSig.y, ecoDamLim1.uVOutMinSet_flow)
    annotation (Line(points={{-139,70},{-110,70},{-110,14},{-110,-3},{-104,-3},{-101,-3}}, color={0,0,127}));
  connect(SupFanSpeSig.y, ecoDamLim2.uSupFanSpe)
    annotation (Line(points={{-139,30},{-20,30},{-20,-6},{0,-6},{0,-6.2},{19,-6.2}}, color={0,0,127}));
  connect(SupFanSpeSig.y, ecoDamLim3.uSupFanSpe)
    annotation (Line(points={{-139,30},{120,30},{120,-6},{130,-6},{130,-6.2},{139,-6.2}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsSingleZone_Disable.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}), graphics={
        Text(
          extent={{-160,112},{-126,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Fan status"),
        Text(
          extent={{-40,112},{-6,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Operation mode"),
        Text(
          extent={{80,112},{114,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Freeze protection stage")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsSingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsSingleZone</a>
for the following control signals: <code>VOut_flow</code>, <code>VOutMinSet_flow</code>. The control loop is always enabled in this
example.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamperPositionLimitsSingleZone_Disable;