'# MWS Version: Version 2017.0 - Jan 13 2017 - ACIS 26.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2 fmax = 3
'# created = '[VERSION]2017.0|26.0.1|20170113[/VERSION]


'@ use template: Antenna - Planar.cfg

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With
'----------------------------------------------------------------------------
Plot.DrawBox True
With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With
' optimize mesh settings for planar structures
With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With
With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With
With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With
' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"
' switch on FD-TET setting for accurate farfields
FDSolver.ExtrudeOpenBC "True"
PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"
With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With
'----------------------------------------------------------------------------
'set the frequency range
Solver.FrequencyRange "2", "3"
Dim sDefineAt As String
sDefineAt = "2;2.4;3"
Dim sDefineAtName As String
sDefineAtName = "2;2.4;3"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")
Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)
Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)
' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .Frequency zz_val
    .ExportFarfieldSource "False"
    .Create
End With
Next
'----------------------------------------------------------------------------
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")

'@ define material: FR-4 (lossy)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.025"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.3"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With

'@ new component: Substrate

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Component.New "Substrate"

'@ define brick: Substrate:Substrate

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Substrate" 
     .Component "Substrate" 
     .Material "FR-4 (lossy)" 
     .Xrange "-Lsubs/2", "Lsubs/2" 
     .Yrange "-Wsubs/2", "Wsubs/2" 
     .Zrange "-Tsubs", "0" 
     .Create
End With

'@ define material: Copper (annealed)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "5.8e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "Nth Order"
.DispersiveFittingSchemeMu "Nth Order"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.SetMaterialUnit "GHz", "mm"
.Mu "1.0"
.Kappa "5.8e+007"
.Rho "8930.0"
.ThermalType "Normal"
.ThermalConductivity "401.0"
.HeatCapacity "0.39"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "120"
.PoissonsRatio "0.33"
.ThermalExpansionRate "17"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With

'@ new component: Ground_Plane

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Component.New "Ground_Plane"

'@ define brick: Ground_Plane:Ground_Plane

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Ground_Plane" 
     .Component "Ground_Plane" 
     .Material "Copper (annealed)" 
     .Xrange "-Lsubs/2", "Lsubs/2" 
     .Yrange "-Wsubs/2", "Wsubs/2" 
     .Zrange "-Tsubs - Tpatch", "-Tsubs" 
     .Create
End With

'@ new component: Antenna

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Component.New "Antenna"

'@ define brick: Antenna:Patch

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Patch" 
     .Component "Antenna" 
     .Material "Copper (annealed)" 
     .Xrange "-Lpatch/2", "Lpatch/2" 
     .Yrange "-Wpatch/2", "Wpatch/2" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ clear picks

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Pick.ClearAllPicks

'@ define discrete port: 1

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Label "Input" 
     .Impedance "50.0" 
     .VoltagePortImpedance "0.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .SetP1 "False", "Lpatch/2", "0.0", "-Tsubs" 
     .SetP2 "False", "Lpatch/2", "0.0", "0.0" 
     .InvertDirection "False" 
     .LocalCoordinates "False" 
     .Monitor "True" 
     .Radius "0.0" 
     .Wire "" 
     .Position "end1" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ farfield plot options

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "180" 
     .Phi "180" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "2.4" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .ShowStructureProfile "True" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Realized Gain" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0.000000e+000", "1.000000e+000", "0.000000e+000" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+000 
     .Origin "free" 
     .Userorigin "0.000000e+000", "0.000000e+000", "5.000000e+001" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+000" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+001" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  
     .StoreSettings
End With

'@ delete monitors

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Monitor.Delete "farfield (f=2)" 
Monitor.Delete "farfield (f=3)"

'@ switch working plane

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Plot.DrawWorkplane "false"

'@ farfield plot options

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "0" 
     .Phi "0" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "2.4" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0.000000e+000", "1.000000e+000", "0.000000e+000" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+000 
     .Origin "free" 
     .Userorigin "0.000000e+000", "0.000000e+000", "4.000000e+001" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+000" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+001" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  
     .StoreSettings
End With

'@ new component: Align_Edges

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Component.New "Align_Edges"

'@ define brick: Align_Edges:Align_Edge_01

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_01" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "-Lsubs/2", "-Lsubs/2 + AlignWS" 
     .Yrange "-Wsubs/2", "-Wsubs/2 + 3*AlignWS" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ define brick: Align_Edges:Align_Edge_01b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_01b" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "-Lsubs/2", "-Lsubs/2 + 3*AlignWS" 
     .Yrange "-Wsubs/2", "-Wsubs/2 + AlignWS" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ boolean add shapes: Align_Edges:Align_Edge_01, Align_Edges:Align_Edge_01b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Add "Align_Edges:Align_Edge_01", "Align_Edges:Align_Edge_01b"

'@ define brick: Align_Edges:Align_Edge_02

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_02" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "Lsubs/2 - 3*AlignWS", "Lsubs/2" 
     .Yrange "-Wsubs/2", "-Wsubs/2 + AlignWS" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ define brick: Align_Edges:Align_Edge_02b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_02b" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "Lsubs/2 - AlignWS", "Lsubs/2" 
     .Yrange "-Wsubs/2", "-Wsubs/2 + 3*AlignWS" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ boolean add shapes: Align_Edges:Align_Edge_02, Align_Edges:Align_Edge_02b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Add "Align_Edges:Align_Edge_02", "Align_Edges:Align_Edge_02b"

'@ define brick: Align_Edges:Align_Edge_03

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_03" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "-Lsubs/2", "-Lsubs/2 + AlignWS" 
     .Yrange "Wsubs/2", "Wsubs/2 - 3*AlignWS" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ define brick: Align_Edges:Align_Edge_03b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_03b" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "-Lsubs/2", "-Lsubs/2 + 3*AlignWS" 
     .Yrange "Wsubs/2", "Wsubs/2 - AlignWS" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ boolean add shapes: Align_Edges:Align_Edge_03, Align_Edges:Align_Edge_03b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Add "Align_Edges:Align_Edge_03", "Align_Edges:Align_Edge_03b"

'@ define brick: Align_Edges:Align_Edge_04

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_04" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "Lsubs/2 - 3*AlignWS", "Lsubs/2" 
     .Yrange "Wsubs/2 - AlignWS", "Wsubs/2" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ define brick: Align_Edges:Align_Edge_04b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_04b" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "Lsubs/2 - AlignWS", "Lsubs/2" 
     .Yrange "Wsubs/2 - 3*AlignWS", "Wsubs/2" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ boolean add shapes: Align_Edges:Align_Edge_04, Align_Edges:Align_Edge_04b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Add "Align_Edges:Align_Edge_04", "Align_Edges:Align_Edge_04b"

'@ execute macro: File\Import\ADS Model...

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Dim sProjectName As String
Dim sSimplifyAngle As String
Dim sSimplifyAdjacentTol As String
Dim sSimplifyRadiusTol As String
Dim sSimplifyMinPointsArc As String
Dim sSimplifyMinPointsCircle As String
Dim sSimplifyAngleTang As String
Dim sSimplifyEdgeLength As String
Dim sMinimumMetalThickness As String
Dim bUseSheets As Boolean
Dim bUseSimplification As Boolean
Dim bCopyFileToProject As Boolean
Dim bUseWaveguidePorts As Boolean
    
    
If (sProjectName <> "") Then
    
    StoreGlobalDataValue "Macros\ADS Import\FileName", sProjectName
    StoreGlobalDataValue "Macros\ADS Import\SimplifyAngle", sSimplifyAngle
    StoreGlobalDataValue "Macros\ADS Import\SimplifyAdjacentTol", sSimplifyAdjacentTol
    StoreGlobalDataValue "Macros\ADS Import\SimplifyRadiusTol", sSimplifyRadiusTol
    StoreGlobalDataValue "Macros\ADS Import\SimplifyMinPointsArc", sSimplifyMinPointsArc
    StoreGlobalDataValue "Macros\ADS Import\SimplifyMinPointsCircle", sSimplifyMinPointsCircle
    StoreGlobalDataValue "Macros\ADS Import\SimplifyAngleTang", sSimplifyAngleTang
    StoreGlobalDataValue "Macros\ADS Import\SimplifyEdgeLength", sSimplifyEdgeLength
    StoreGlobalDataValue "Macros\ADS Import\MinimumMetalThickness", sMinimumMetalThickness
    StoreGlobalDataValue "Macros\ADS Import\UseSheets", bUseSheets
    StoreGlobalDataValue "Macros\ADS Import\UseSimplification", bUseSimplification
    StoreGlobalDataValue "Macros\ADS Import\UseWaveguidePorts", bUseWaveguidePorts
    RunScript GetInstallPath + "\Library\Macros\Converter\ADS Converter 1.bas"
    
End If

'@ switch bounding box

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Plot.DrawBox "False" 


