# -*- coding: utf8 -*-

# CityGuide/MP file formats

import os,time
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)

class IMGID:
    Id=NOW
    Name=''
    Version=''
    Copyright=''
    def __init__(self):
        pass
    def __str__(self):
        VV,VS=self.Version.split('.')[:2]
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
'''%(self.Id,self.Name,self.Name,VV,VS,self.Copyright)

class POI:
    def __init__(self,type,lat,lon,label=''):
        self.type=type
        self.lat=lat
        self.lon=lon
        self.label=label
    def __str__(self):
        return '''
[POI]
Data0=(%s,%s)
Type=0x%.4X
Label=%s
[END]
'''%(self.lat,self.lon,self.type,self.label)

class MP:
    def __init__(self,FN):
        self.FileName=FN
        self.IMGID=IMGID()
        self.POI=[POI(0x0100,0,0,'Main City')]
    def dump(self):
        F=open(self.FileName,'w') ; F.write(str(self)); F.close()
    def __str__(self):
        S=str(self.IMGID)
        for i in self.POI:
            S+=str(i)
        return S

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


