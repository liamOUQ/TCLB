# Density - table of variables of LB Node to stream
#  name - variable name to stream
#  dx,dy,dz - direction of streaming
#  comment - additional comment
#	Pressure Evolution:
U = expand.grid(-1:1,-1:1,-1:1)

AddDensity(
	name = paste("g",1:27-1,sep=""),
	dx   = U[,1],
	dy   = U[,2],
	dz   = U[,3],
	comment=paste("Pressure Evolution",1:27-1),
	group="g"
)
AddDensity(
	name = paste("h",1:27-1,sep=""),
	dx   = U[,1],
	dy   = U[,2],
	dz   = U[,3],
	comment=paste("Density Evolution",1:27-1),
	group="h"
)
AddField('PhaseF'   ,stencil3d=1, group="phi")
# Stages - processes to run for initialisation and each iteration
AddStage("PhaseInit"    , "Init"		      , 
	save=Fields$group=="phi" )
AddStage("BaseInit"     , "Init_distributions", 
	save=Fields$group=="g" | Fields$group=="h")
AddStage("calcPhase"	, "calcPhaseF"        , 
	save=Fields$group=="phi"                  , 
	load=DensityAll$group=="h")
AddStage("BaseIter"     , "Run"			      , 
	save=Fields$group=="g" | Fields$group=="h", 
	load=DensityAll$group=="g" | DensityAll$group=="h")

AddAction("Iteration", c("BaseIter", "calcPhase"))
AddAction("Init"     , c("PhaseInit", "BaseInit","calcPhase"))

# 	Outputs:
AddQuantity(name="Density",	  unit="kg/m3")
AddQuantity(name="PhaseField",unit="1")
AddQuantity(name="U",	  unit="m/s",vector=T)
AddQuantity(name="P",	  unit="Pa")
#	Inputs: For phasefield evolution
AddSetting(name="Density_h", comment='High density')
AddSetting(name="Density_l", comment='Low  density')
AddSetting(name="PhaseField", comment='Initial PhaseField distribution (0 or 1)', zonal=T)
AddSetting(name="contactAngle", default=90)
AddSetting(name="W", default=4,    comment='Anti-diffusivity coeff')
AddSetting(name="M", default=0.05, comment='Mobility')
AddSetting(name="sigma", 		   comment='surface tension')
# 	Inputs: Fluid Properties
AddSetting(name="omega_l", comment='one over relaxation time (low density fluid)')
AddSetting(name="omega_h", comment='one over relaxation time (high density fluid)')
AddSetting(name="Viscosity_l", omega_l='1.0/(3*Viscosity_l)', default=0.33333333, comment='kinematic viscosity')
AddSetting(name="Viscosity_h", omega_h='1.0/(3*Viscosity_h)', default=0.33333333, comment='kinematic viscosity')
AddSetting(name="S0", default=1.0, comment='Relaxation Param')
AddSetting(name="S1", default=1.0, comment='Relaxation Param')
AddSetting(name="S2", default=1.0, comment='Relaxation Param')
AddSetting(name="S3", default=1.0, comment='Relaxation Param')
AddSetting(name="S4", default=1.0, comment='Relaxation Param')
AddSetting(name="S5", default=1.0, comment='Relaxation Param')
AddSetting(name="S6", default=1.0, comment='Relaxation Param')
AddSetting(name="S7", default=1.0, comment='Relaxation Param')
AddSetting(name="S8", default=1.0, comment='Relaxation Param')
AddSetting(name="S9", default=1.0, comment='Relaxation Param')
AddSetting(name="S10", default=1.0, comment='Relaxation Param')
AddSetting(name="S11", default=1.0, comment='Relaxation Param')
AddSetting(name="S12", default=1.0, comment='Relaxation Param')
AddSetting(name="S13", default=1.0, comment='Relaxation Param')
AddSetting(name="S14", default=1.0, comment='Relaxation Param')
AddSetting(name="S15", default=1.0, comment='Relaxation Param')
AddSetting(name="S16", default=1.0, comment='Relaxation Param')
AddSetting(name="S17", default=1.0, comment='Relaxation Param')
AddSetting(name="S18", default=1.0, comment='Relaxation Param')
AddSetting(name="S19", default=1.0, comment='Relaxation Param')
AddSetting(name="S20", default=1.0, comment='Relaxation Param')
AddSetting(name="S21", default=1.0, comment='Relaxation Param')
AddSetting(name="S22", default=1.0, comment='Relaxation Param')
AddSetting(name="S23", default=1.0, comment='Relaxation Param')
AddSetting(name="S24", default=1.0, comment='Relaxation Param')
AddSetting(name="S25", default=1.0, comment='Relaxation Param')
AddSetting(name="S26", default=1.0, comment='Relaxation Param')
#	Inputs: Flow Properties
AddSetting(name="VelocityX", default=0.0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="VelocityY", default=0.0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="VelocityZ", default=0.0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="Pressure" , default=0.0, comment='inlet/outlet/init density', zonal=T)
AddSetting(name="GravitationX", default=0.0, comment='applied (rho)*GravitationX')
AddSetting(name="GravitationY", default=0.0, comment='applied (rho)*GravitationY')
AddSetting(name="GravitationZ", default=0.0, comment='applied (rho)*GravitationZ')
AddSetting(name="BuoyancyX", default=0.0, comment='applied (rho-rho_h)*BuoyancyX')
AddSetting(name="BuoyancyY", default=0.0, comment='applied (rho-rho_h)*BuoyancyY')
AddSetting(name="BuoyancyZ", default=0.0, comment='applied (rho-rho_h)*BuoyancyZ')
# 	NodeTypes for finite difference at boundaries.

# Globals - table of global integrals that can be monitored and optimized
AddGlobal(name="PressureLoss", comment='pressure loss', unit="1mPa")
AddGlobal(name="OutletFlux", comment='pressure loss', unit="1m2/s")
AddGlobal(name="InletFlux", comment='pressure loss', unit="1m2/s")
AddGlobal(name="TotalDensity", comment='Mass conservation check', unit="1kg/m3")
