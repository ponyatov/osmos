# -*- coding: utf8 -*-
 
import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
  
import cfg,osm,cgmp,lxml
 
SAMARA_OBL = osm.relation(id=72194)

def lxm(xxx):
    return lxml.etree.tostring(xxx)

OSM = SAMARA_OBL.xpath('/osm')[0]

MP=cgmp.MP('../map/mp.mp')

MP.IMGID.Name='Samara globe (c) osm.org'
MP.IMGID.LocalName='глобус Самары (c) osm.org'
MP.IMGID.Version=OSM.attrib['version']
MP.IMGID.Copyright=OSM.attrib['copyright']
 
# NODES={}
# for i in SAMARA_OBL.xml.xpath('//node'):
#     T=i.attrib
#     ID=T['id'] ; LAT=float(T['lat']) ; LON=float(T['lon'])
#     MP.addPOI(ID,0,LAT,LON,'')
#     NODES[ID]=(LAT,LON) #; print UID,NODES[UID]
#     
# WAYS={}
# for i in SAMARA_OBL.xml.xpath("//way[@visible='true']"):
#     T=i.attrib
#     ID=T['id']
#     ND=[]
#     for j in i.xpath("//nd"):
#         ND+=[NODES[j.attrib['ref']]]
#     MP.addPLINE(ID,0x22,ND,'')

# RegionCapital = SAMARA_OBL.xpath("/osm/node[tag[@k='capital']]")[0]    
# id,lat,lon = RegionCapital.attrib['id'],RegionCapital.attrib['lat'],RegionCapital.attrib['lon']
# name = RegionCapital.xpath("tag[@k='name:ru']")[0].attrib['v']
# MP.addPOI(id,cgmp.TYPE['MainCity'],lat,lon,name)
# MP.IMGID.MainTown=RegionCapital
 
# RegionCenter = SAMARA_OBL.xml.xpath("/osm/node[tag[@k='place'][@v='state']]")[0]
# lat,lon = RegionCenter.attrib['lat'],RegionCenter.attrib['lon']
# MP.IMGID.PointView='%s %s'%(lat,lon)
 
# os.system(r'..\bin\MP2CGMap.exe mp:..\map\mp.mp scale:10000')

# os.chdir(r'..\bin\osm2mp')
# os.system(r'osm2mp32.exe %s > ..\map\mp.mp'%SAMARA_OBL.FileName)

# SAMARA_OBL_CENTER= osm.node(id=SAMARA_OBL.xpath('/osm/relation/member[@type="node"][@role="label"]')[0].attrib['ref'])
# print SAMARA_OBL_CENTER.xpath('/osm/node')
# 
# # for i in SAMARA_OBL.xpath('/osm/relation/member[@type="node"][@role="label"]'):
# for i in SAMARA_OBL_CENTER.xpath('/*'):
#     print
#     print lxml.etree.tostring(i)

R=SAMARA_OBL.xpath('/osm/relation/member[@type="node"][@role="label"]')[0].attrib['ref']
C=SAMARA_OBL_CENTER=osm.node(R)
print C.id,C.lat,C.lon,C.name
MP.IMGID.PointView='%s %s'%(C.lat,C.lon)
MP.add(cgmp.AdminCenter(C.id,C.lat,C.lon,C.name))

X=open('../tmp/xml.xml','w')
# # for i in SAMARA_OBL.xpath('/osm/relation/member[@role="label"]'):
for i in SAMARA_OBL_CENTER.xpath('*'):
    print >>X,lxml.etree.tostring(i)
X.close()

MP.dump()
                      
