# -*- coding: utf8 -*-

import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
 
import cfg,osm,cgmp,lxml

SAMARA_OBL = osm.relation(id=72194)
OSM        = SAMARA_OBL.xml.xpath('//osm')[0]

MP=cgmp.MP('../map/mp.mp')

MP.IMGID.Name='Samara globe (c) osm.org'
MP.IMGID.Version=OSM.attrib['version']
MP.IMGID.Copyright=OSM.attrib['copyright']

NODES={}
for i in SAMARA_OBL.xml.xpath('//node'):
    T=i.attrib
    ID=T['id'] ; LAT=float(T['lat']) ; LON=float(T['lon'])
    MP.addPOI(ID,0,LAT,LON,'')
    NODES[ID]=(LAT,LON) #; print UID,NODES[UID]
    
WAYS={}
for i in SAMARA_OBL.xml.xpath("//way[@visible='true']"):
    T=i.attrib
    ID=T['id']
    ND=[]
    for j in i.xpath("//nd"):
        ND+=[NODES[j.attrib['ref']]]
    MP.addPLINE(ID,0x22,ND,'')

RegionCapital = SAMARA_OBL.xml.xpath("/osm/node[tag[@k='capital']]")[0]    
id,lat,lon = RegionCapital.attrib['id'],RegionCapital.attrib['lat'],RegionCapital.attrib['lon']
name = RegionCapital.xpath("tag[@k='name:ru']")[0].attrib['v']
MP.addPOI(id,cgmp.TYPE['MainCity'],lat,lon,name)
MP.IMGID.MainTown=name

RegionCenter = SAMARA_OBL.xml.xpath("/osm/node[tag[@k='place'][@v='state']]")[0]
lat,lon = RegionCenter.attrib['lat'],RegionCenter.attrib['lon']
MP.IMGID.PointView='%s %s'%(lat,lon)

MP.dump()
                     
os.system(r'..\bin\MP2CGMap.exe mp:..\map\mp.mp scale:10000')
