# Density - table of variables of LB Node to stream
U = expand.grid(-1:1,-1:1,-1:1)

AddDensity(
	name = paste("f",1:27-1,sep=""),
	dx   = U[,1],
	dy   = U[,2],
	dz   = U[,3],
	comment=paste("density F",1:27-1),
	group="f"
)
AddDensity(
	name = paste("g",1:27-1,sep=""),
	dx   = U[,1],
	dy   = U[,2],
	dz   = U[,3],
	comment=paste("density G",1:27-1),
	group="g"
)
AddField(name="psi_g",  stencil3d=1)
AddField(name="psi_f",  stencil3d=1)
#AddField(name="psi_solid", stencil3d=1)

# Stages - processes to run for initialisation and each iteration
AddStage("BaseIteration", "Run",  save=Fields$group=="f" | Fields$group=="g", load=DensityAll$group=="f" | DensityAll$group =="g")
AddStage("CalcPsi_f"    , save="psi_f", load=DensityAll$group == "f" )
AddStage("CalcPsi_g"    , save="psi_g", load=DensityAll$group == "g" )
AddStage("BaseInit"     , "Init", save=Fields$group=="f" | Fields$group=="g", load=DensityAll$group=="f" | DensityAll$group =="g")
AddAction("Iteration", c("BaseIteration","CalcPsi_f","CalcPsi_g"))
AddAction("Init"     , c("BaseInit",     "CalcPsi_f","CalcPsi_g"))

# Quantities - table of fields that can be exported from the LB lattice
AddQuantity(name="Rho", unit="kg/m3")
AddQuantity(name="Rhof",unit="kg/m3")
AddQuantity(name="Rhog",unit="kg/m3")
AddQuantity(name="P",   unit="Pa")
AddQuantity(name="U",   unit="m/s",vector=T)
AddQuantity(name="A",   unit="1",vector=T)
AddQuantity(name="Ff",  unit="N",vector=T)
AddQuantity(name="Fg",  unit="N",vector=T)

# Settings - table of settings (constants) that are taken from a .xml file
# Viscosity Settings:
AddSetting(name="omega", comment='one over relaxation time-wet')
AddSetting(name="omega_g", comment='one over relaxation time-dry')
AddSetting(name="nu", omega='1.0/(3*nu + 0.5)', default=.16666666, comment='viscosity-wet')
AddSetting(name="nu_g", omega_g='1.0/(3*nu_g + 0.5)', default=.16666666, comment='viscosity-dry')
# Boundary Settings:
AddSetting(name="Velocity_f", default=0, comment='inlet/outlet/init velocity 1st pop', zonal=T)
AddSetting(name="Pressure_f", default=0, comment='inlet/outlet/init density 1st pop', zonal=T)
AddSetting(name="Velocity_g", default=0, comment='inlet/outlet/init velocity 2nd pop', zonal=T)
AddSetting(name="Pressure_g", default=0, comment='inlet/outlet/init density 2nd pop', zonal=T)
# Density Settings:
AddSetting(name="Density", comment='higher density fluid - multiphase capable', zonal=T)
AddSetting(name="Density_dry", comment='lower density fluid  - ideal gas assumption' , zonal=T)
# MultiComponent Settings:
AddSetting(name="G11", default=0.0, comment='fluid 1 on 1 interaction')
AddSetting(name="G12", default=0.0, comment='fluid 1 on 2 interaction (getFg)')
AddSetting(name="G21", default=0.0, comment='fluid 2 on 1 interaction (getFf)')
AddSetting(name="G22", default=0.0, comment='fluid 2 on 2 interaction')
AddSetting(name="Gad1", default=0.0, comment='fluid1-wall interation')
AddSetting(name="Gad2", default=0.0, comment='fluid2-wall interation')
# MultiPhase Settings:
AddSetting(name="R", default=1.0, comment='EoS gas const')
AddSetting(name="T", default=1.0, comment='EoS reduced temp')
AddSetting(name="a", default=1.0, comment='EoS a')
AddSetting(name="b", default=4.0, comment='EoS b')
AddSetting(name="beta",default=1.0, comment='beta forcing scheme')
AddSetting(name="kappa",default=1.0, comment='pressure altering term')
# Turbulence Settings:
AddSetting(name="Smag", comment='Smagorinsky constant')
AddSetting(name="SL_U", comment='Shear Layer velocity')
AddSetting(name="SL_lambda", comment='Shear Layer lambda')
AddSetting(name="SL_delta", comment='Shear Layer disturbance')
AddSetting(name="SL_L", comment='Shear Layer length scale')
# Body Force Settings:
AddSetting(name="GravitationX", default=0.0, comment='Body Force')
AddSetting(name="GravitationY", default=0.0, comment='Body Force')

# Globals - table of global integrals that can be monitored and optimized
AddGlobal(name="TotalDensity1", comment='quantity of fluid-1', unit='kg/m3')
AddGlobal(name="TotalDensity2", comment='quantity of fluid-2', unit='kg/m3')
AddGlobal(name="PressureLoss", comment='pressure loss', unit="1mPa")
AddGlobal(name="OutletFlux", comment='pressure loss', unit="1m2/s")
AddGlobal(name="InletFlux", comment='pressure loss', unit="1m2/s")

# Node Types
AddNodeType("Smagorinsky", "LES")
AddNodeType("Stab", "ENTROPIC")
