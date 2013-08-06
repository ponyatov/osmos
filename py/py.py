# -*- coding: utf8 -*-
 
import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
  
import cfg,osm,cgmp,lxml
 
SAMARA_OBL = osm.relation(id=72194)#osm.xapi('relation[id=72194]')#osm.relation(id=72194)
print SAMARA_OBL.lat,SAMARA_OBL.lon

def lxm(xxx):
    return lxml.etree.tostring(xxx)

OSM = SAMARA_OBL.xpath('/osm')[0]

MP=cgmp.MP('../map/mp.mp')

MP.IMGID.Name='Samara globe (c) osm.org'
MP.IMGID.LocalName='глобус Самары (c) osm.org'
MP.IMGID.Version=OSM.attrib['version']
MP.IMGID.Copyright='(c) osm.org & dponyatov@gmail.com'#OSM.attrib['copyright']
 
R=SAMARA_OBL.xpath('/osm/relation[@id=72194]/member[@type="node"][@role="label"]')[0].attrib['ref']
C=SAMARA_OBL_CENTER=osm.node(R)
print C.id,C.lat,C.lon,C.name
MP.IMGID.PointView='%s %s'%(C.lat,C.lon)
MP.add(cgmp.AdminCenter(C.id,C.lat,C.lon,C.name))

R=SAMARA_OBL.xpath('/osm/relation[@id=72194]/member[@type="node"][@role="admin_centre"]')[0].attrib['ref']
C=osm.node(R)
print C.id,C.lat,C.lon,C.name
MP.IMGID.MainTown=C.name
MP.add(cgmp.MainCity(C.id,C.lat,C.lon,C.name))

print SAMARA_OBL.name,'outline:',
for i in SAMARA_OBL.xpath('//relation[@id=72194]/member[@type="way"][@role="outer"]'):
    W=osm.way(i.attrib['ref']) ; print W.id,
    MP.add(cgmp.StateBoundary(W.id,W.poly,W.name))
print

X=open('../tmp/xml.xml','w')
# # for i in SAMARA_OBL.xpath('/osm/relation/member[@role="label"]'):
# for i in SAMARA_OBL.xpath('//relation[@id=72194]'):
for i in SAMARA_OBL.xpath('//relation[@id=72194]/member[@type="way"][@role="outer"]')[:5]:
    print >>X,lxml.etree.tostring(i)
X.close()

MP.dump()
os.system(r'..\bin\mp2cgmap\MP2CGMap.exe mp:..\map\mp.mp')
