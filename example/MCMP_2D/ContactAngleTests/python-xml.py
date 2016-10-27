# -*- coding: utf-8 -*-
"""
Created on Thu Dec 17 20:26:07 2015

@author: michal
"""

import bearded_octo_wookie.CLB.CLBXMLWriter as CLBXML

def createConfig( G, prefix ):
    NX = int( 200 )
    NY = int( 100 )
    
    CLBc = CLBXML.CLBConfigWriter( \
    "ContactAngle-G" + str(G)
    )
    fname = prefix+"ContactAngle_"+str(G)
    CLBc.addGeomParam('nx', NX)
    CLBc.addGeomParam('ny', NY)   
    
    CLBc.addBGK()
    CLBc.addBox()
    
    # Add liquid drop
    CLBc.addZoneBlock(name='zdrop')
    CLBc.addBox( dx=80, fx=121, dy=0, fy=23 )
    # Add in Walls
    CLBc.addWall(name="zwall")
    CLBc.addBox(ny=1)   

    params = {
    'omega':"1",
    'omega_g':"1",
    'Density':"0.06",
    'Density_dry':"2.0",
    'Density-zdrop':"2.0",
    'Density_dry-zdrop':"0.06",
    
    'GravitationY':"0.0",
    'GravitationX':"0.0",

    'Gc':0.9,
    'Gad1':G,
    'Gad2':-G    
    }
    
    for n in params:
        CLBc.addModelParam(n, params[n])
    CLBc.addSolve(iterations=5000, vtk=100)          
    #CLBc.dump()
    #f = file('/tmp/list.txt', 'a')
    print fname+'_VTK_P00_%.8d.vti'%int(1000*NX+1)
    CLBc.write(fname+'.xml')
    #for l in file('/tmp/a.xml'):
    #    print l
    
    
########################################################
#createConfig( NX, NY, rho_wet, rho_dry, nbubbles, nsize, prefix ):
prefix    = '/home/uqtmitc3/TCLB/example/ContactAngleTests/' 
Values = [-0.3, -0.2, -0.1, 0.0, 0.1, 0.2, 0.3]
for G in Values:
    createConfig(G,prefix)
#for R in [256]: 
#  for rhoW in [0.5, 1.5]:
#      H = 2 * R
      #print "XXXXXXXXXXXXXXXXXXXXXXXXXx"
#      for LdoR in range(1,30):
#          LdoR = float(LdoR) / 30. * 0.6
          #for V in [0.0025]:
#          for V in [0.005]:
#              hdoR = V / LdoR
       #       print hdoR
#              createConfig(R,H,LdoR,hdoR,rhoW, '/tmp/y/matrix3.2-')
          #for hdoR in [0.05, 0.2]:            

              #createConfig(R,H,LdoR,hdoR,rhoW, '/home/michal/tach-17/mnt/fhgfs/users/mdzikowski/yang-laplace-sphere-matrix/matrix-')
