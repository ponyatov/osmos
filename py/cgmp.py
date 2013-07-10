# -*- coding: utf8 -*-

# CityGuide/MP file formats

import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)

class IMGID:
    def __init__(self,\
                 ID=NOW,Name='Samara Globe (c) osm.org',LocalName='глобус Самары (c) osm.org',\
                 Version=0,SubVersion=1,Copyright='(gpl) dponyatov@gmail.com (c) osm.org'):
        self.ID=ID
        self.Name=Name
        self.LocalName=LocalName
        self.Version=Version
        self.VersionSub=SubVersion
        self.Copyright=Copyright
    def __str__(self):
        return '''
[IMG ID]
ID=%s
Name=%s
LocalName=%s
Version=%s
VersionSub=%s
Copyright=%s

Datum=W84
Elevation=m

LblCoding=9
CodePage=65001

Levels=1
Level0=26

Preprocess=F
POIIndex=Y

[END]

'''%(self.ID,self.Name,self.LocalName,self.Version,self.VersionSub,self.Copyright)

class POI:
    pass

class POLY:
    def __init__(self,type):
        self.type=type
    def __str__(self):
        return '[POI]\nData0=...\nType=0x%.4X\n[END]\n'%self.type

Map_Coverage_Area = POLY(0x004b)
