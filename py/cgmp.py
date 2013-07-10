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
LblCoding=9
CodePage=65001
ID=%s
Name=%s
LocalName=%s
Version=%s
VersionSub=%s
Copyright=%s
Datum=W84
Elevation=m
Levels=1
Level0=26
[END]
'''%(self.ID,self.Name,self.LocalName,self.Version,self.VersionSub,self.Copyright)

class POI:
    def __init__(self,type,point,label=''):
        self.type=type
        self.lat=point[0]
        self.lon=point[1]
        self.label=label
    def __str__(self):
        return '[POI]\nData0=(%s,%s)\nType=0x%.4X\nLabel=%s\n[END]\n'%(self.lat,self.lon,self.type,self.label)
    
class POLY:
    def __init__(self,type,points,label=[]):
        self.points=points
        self.type=type
        self.label=label
    def pntstr(self):
        T=''
        for i in self.points:
            T+='%s,'%str(i)
        if T:
            return T[:-1]
        else:
            return ''
    def __str__(self):
        return '[POLY]\nData0=%s\nType=0x%.4X\nLabel=%s\n[END]\n'%(self.pntstr(),self.type,self.label)

Map_Coverage_Area = POLY(0x004b,[(-1,-1),(+1,-1),(+1,+1),(-1,+1)],'Map Coverage')

Main_City = POI(0x0100,(0,0),'Main City')

