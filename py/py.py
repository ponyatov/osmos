# -*- coding: utf8 -*-
 
import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
  
import cfg,osm,cgmp,lxml
 
SAMARA_OBL = osm.relation(id=72194)#osm.xapi('relation[id=72194]')#osm.relation(id=72194)

def lxm(xxx):
    return lxml.etree.tostring(xxx)

OSM = SAMARA_OBL.xpath('/osm')[0]

MP=cgmp.MP('../map/mp.mp')

MP.IMGID.Name='Samara globe (c) osm.org'
MP.IMGID.LocalName='глобус Самары (c) osm.org'
MP.IMGID.Version=OSM.attrib['version']
MP.IMGID.Copyright=OSM.attrib['copyright']
 
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
                      
