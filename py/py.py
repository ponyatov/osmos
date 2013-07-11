# -*- coding: utf8 -*-

import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
 
import cfg,osm,cgmp

SAMARA_OBL = osm.relation(id=72194)
OSM        = SAMARA_OBL.xml.xpath('//osm')[0]

MP=cgmp.MP('../map/mp.mp')

MP.IMGID.Name='Samara globe (c) osm.org'
MP.IMGID.Version=OSM.attrib['version']
MP.IMGID.Copyright=OSM.attrib['copyright']

NODES={}
for i in SAMARA_OBL.xml.xpath('//node'):
    T=i.attrib
    UID=T['uid'] ; LAT=T['lat'] ; LON=T['lon']
    NODES[UID]=(LAT,LON) #; print UID,NODES[UID]
    
print SAMARA_OBL.xml.xpath("//*['capital'='yes']")

# for i in NODES:
#     MP.addPOI()
#     print i,NODES[i]
    
MP.dump()
                     
# VV,SV=R.attrib['version'].split('.')
# CC='(c) '+R.attrib['copyright'].split()[0]+' (gpl) dponyatov@gmail.com'
# print >>MP,cgmp.IMGID(Version=VV,SubVersion=SV,Copyright=CC)
# 
# print >>MP,cgmp.Map_Coverage_Area
# print >>MP,cgmp.Main_City
# 
# for i in X.findall('node'):
#     T=i.attrib
#     print >>MP,cgmp.POI(0,(T['lat'],T['lon']),T['uid'])
#     #'; %s\n[POI]\nData0=(%s,%s)\nLabel=%s\n[END]\n'%(,,T['uid'])

os.system(r'..\bin\MP2CGMap.exe mp:..\map\mp.mp scale:10000')
