# -*- coding: utf8 -*-

import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)

import cfg,osm

print cfg.user,cfg.passwd

X=osm.relation(id=72194).xml
R=X.getroot()
print X

MP=open('../map/mp.mp','w')
print >>MP,'[IMG ID]\n'
print >>MP,'ID=%s'%NOW
print >>MP,'Name=%s'%('Samara Globe (c) osm.org'[:32])
print >>MP,'LocalName=%s'%('глобус Самары (c) osm.org'[:32])
VV,VS=R.attrib['version'].split('.')
print >>MP,'Version=%s'%VV
print >>MP,'VersionSub=%s'%VS
print >>MP,'Copyright=(gpl) dponyatov@gmail.com (c) %s'%R.attrib['copyright']
print >>MP,'''
Datum=W84
Elevation=m

LblCoding=9
CodePage=65001

Levels=1
Level0=26

Preprocess=F
POIIndex=Y

[END]

'''

for i in X.findall('node'):
    T=i.attrib
    print >>MP,'; %s\n[POI]\nData0=(%s,%s)\nLabel=%s\n[END]\n'%(T['uid'],T['lat'],T['lon'],T['uid'])

MP.close()

os.system(r'..\bin\MP2CGMap.exe mp:..\map\mp.mp scale:10000')
