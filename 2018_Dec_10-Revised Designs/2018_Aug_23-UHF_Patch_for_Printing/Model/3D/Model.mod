'# MWS Version: Version 2017.0 - Jan 13 2017 - ACIS 26.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0 fmax = 3
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

'@ define frequency range

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solver.FrequencyRange "0", "3"

'@ define pml specials

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Boundary
     .ReflectionLevel "0.0001" 
     .MinimumDistanceType "Fraction" 
     .MinimumDistancePerWavelengthNewMeshEngine "4" 
     .MinimumDistanceReferenceFrequencyType "CenterNMonitors" 
     .FrequencyForMinimumDistance "1.5" 
     .SetAbsoluteDistance "0.0" 
End With

'@ define boundaries

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
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
     .ApplyInAllDirections "True"
End With

'@ switch working plane

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Plot.DrawWorkplane "false"

'@ delete monitor: farfield (f=2)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Monitor.Delete "farfield (f=2)"

'@ delete monitor: farfield (f=3)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Monitor.Delete "farfield (f=3)"

'@ define farfield monitor: farfield (f=0.915)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Monitor 
     .Delete "farfield (f=2.4)" 
End With 
With Monitor 
     .Reset 
     .Name "farfield (f=0.915)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "0.915" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffsetType "Absolute" 
     .Create 
End With

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
     .Yrange "-Wsubs/2 + B", "Wsubs/2 - A" 
     .Zrange "-Tsubs", "0" 
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
     .Yrange "-Wsubs/2 + B", "Wsubs/2 - A" 
     .Zrange "-Tsubs - Tpatch", "-Tsubs" 
     .Create
End With

'@ new component: UHF_Antenna

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Component.New "UHF_Antenna"

'@ define brick: UHF_Antenna:Patch

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Patch" 
     .Component "UHF_Antenna" 
     .Material "Copper (annealed)" 
     .Xrange "-Lpatch/2", "Lpatch/2" 
     .Yrange "-Wpatch/2", "Wpatch/2" 
     .Zrange "0", "tpatch" 
     .Create
End With

'@ define brick: UHF_Antenna:Feed_Strip

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Feed_Strip" 
     .Component "UHF_Antenna" 
     .Material "Copper (annealed)" 
     .Xrange "-Wstrip/2", "Wstrip/2" 
     .Yrange "-Wpatch/2 + B", "-Wpatch/2 + y0" 
     .Zrange "0", "tpatch" 
     .Create
End With

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
     .SetP1 "False", "0.0", "-Wpatch/2 + B", "-Tsubs" 
     .SetP2 "False", "0.0", "-Wpatch/2 + B", "0.0" 
     .InvertDirection "False" 
     .LocalCoordinates "False" 
     .Monitor "True" 
     .Radius "0.0" 
     .Wire "" 
     .Position "end1" 
     .Create 
End With

'@ define brick: UHF_Antenna:Inset_Gap_01

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Inset_Gap_01" 
     .Component "UHF_Antenna" 
     .Material "Copper (annealed)" 
     .Xrange "-Wstrip/2 - x0", "-Wstrip/2" 
     .Yrange "-Wpatch/2", "-Wpatch/2 + y0" 
     .Zrange "0", "tpatch" 
     .Create
End With

'@ define brick: UHF_Antenna:Inset_Gap_02

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Inset_Gap_02" 
     .Component "UHF_Antenna" 
     .Material "Copper (annealed)" 
     .Xrange "Wstrip/2", "Wstrip/2 + x0" 
     .Yrange "-Wpatch/2", "-Wpatch/2 + y0" 
     .Zrange "0", "tpatch" 
     .Create
End With

'@ boolean subtract shapes: UHF_Antenna:Patch, UHF_Antenna:Inset_Gap_01

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Subtract "UHF_Antenna:Patch", "UHF_Antenna:Inset_Gap_01"

'@ boolean subtract shapes: UHF_Antenna:Patch, UHF_Antenna:Inset_Gap_02

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Subtract "UHF_Antenna:Patch", "UHF_Antenna:Inset_Gap_02"

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
     .Theta "90" 
     .Phi "90" 
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
     .SetFrequency "0.915" 
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

'@ pick end point

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Pick.PickEndpointFromId "Ground_Plane:Ground_Plane", "4"

'@ pick end point

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Pick.PickEndpointFromId "Ground_Plane:Ground_Plane", "2"

'@ define farfield monitor: farfield (f=2.655)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.655)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "2.655" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Picks" 
     .SetSubvolume "-42.5", "42.5", "-44.125", "44.125", "-1.6", "-1.6" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With

'@ clear picks

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Pick.ClearAllPicks

'@ farfield plot options

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle2" 
     .Theta "90" 
     .Phi "90" 
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
     .SetFrequency "0.915" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
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

'@ new component: Align_Edges

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Component.New "Align_Edges"

'@ define brick: Align_Edges:Align_Edge_01a

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Brick
     .Reset 
     .Name "Align_Edge_01a" 
     .Component "Align_Edges" 
     .Material "Copper (annealed)" 
     .Xrange "-Lsubs/2", "-Lsubs/2 + Wstrip/2" 
     .Yrange "-Wsubs/2 + B", "-Wsubs/2 + B + Lstrip" 
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
     .Xrange "-Lsubs/2", "-Lsubs/2 + Lstrip" 
     .Yrange "-Wsubs/2 + B", "-Wsubs/2 + B + Wstrip/2" 
     .Zrange "0", "Tpatch" 
     .Create
End With

'@ boolean add shapes: Align_Edges:Align_Edge_01a, Align_Edges:Align_Edge_01b

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
Solid.Add "Align_Edges:Align_Edge_01a", "Align_Edges:Align_Edge_01b"

'@ transform: mirror Align_Edges

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Transform 
     .Reset 
     .Name "Align_Edges" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror Align_Edges

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Transform 
     .Reset 
     .Name "Align_Edges" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ define farfield monitor: farfield (f=0.921)

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With Monitor 
     .Delete "farfield (f=2.655)" 
End With 
With Monitor 
     .Reset 
     .Name "farfield (f=0.921)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "0.921" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "-42.5", "42.5", "-45", "45", "-1.6", "-1.6" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2017.0|26.0.1|20170113[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle2" 
     .Theta "90" 
     .Phi "90" 
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
     .SetFrequency "0.915" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
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
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "free" 
     .Userorigin "0.000000e+00", "0.000000e+00", "5.000000e+01" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With 


