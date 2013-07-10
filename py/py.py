# -*- coding: utf8 -*-

import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)

import cfg,osm,cgmp

print cfg.user,cfg.passwd


X=osm.relation(id=72194).xml
R=X.getroot()
print X

MP=open('../map/mp.mp','w')

VV,SV=R.attrib['version'].split('.')
CC='(c) '+R.attrib['copyright'].split()[0]+' (gpl) dponyatov@gmail.com'
print >>MP,cgmp.IMGID(Version=VV,SubVersion=SV,Copyright=CC)

print >>MP,cgmp.Map_Coverage_Area

for i in X.findall('node'):
    T=i.attrib
    print >>MP,'; %s\n[POI]\nData0=(%s,%s)\nLabel=%s\n[END]\n'%(T['uid'],T['lat'],T['lon'],T['uid'])

MP.close()

os.system(r'..\bin\MP2CGMap.exe mp:..\map\mp.mp scale:10000')
