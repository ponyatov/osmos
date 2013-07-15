# -*- coding: utf8 -*-

# CityGuide/MP file formats

import os,time,re
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
 
# TYPE={
#       'Coverage':0x004B
# }

class IMGID:
    ID=NOW
    Name=LocalName=''
    Version='0.1'
    Copyright=''
    MainTown=''
    PointView='0 0'
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
Levels=2
Level0=24
Level1=23
PointView=%s
MainTown=%s
[END]
'''%(self.ID,self.Name,self.LocalName,VV,VS,self.Copyright,self.PointView,self.MainTown)

class mpobj:
    def label2mp(self):
        if self.name:
            return 'Label=%s'%self.name
        else:
            return ''
    def __init__(self,id,lat,lon,name):
        self.id=id
        self.lat=lat ; self.lon=lon
        self.name=name
 
class POI(mpobj):
    type=0x0000
    def __str__(self):
        return '''
; %s osm_id:%s
[POI]
Data0=(%s,%s)
Label=%s
Type=0x%.4X
[END]
'''%(self.__class__,self.id,self.lat,self.lon,self.name,self.type)

class AdminCenter(POI):
    type=0x1500
    
class MainCity(POI):
    type=0x0100
# 'City=Y
# CityName=Самара

class PolyLine(mpobj):
    type=0x0000
    def __init__(self,id,poly,name):
        self.poly=poly
        A,O=poly[0]
        mpobj.__init__(self, id, A, O, name)
    def poly2mp(self):
        S=''
        for i in self.poly:
            S+='(%s,%s),'%(i[0],i[1])
        return S[:-1]
    def __str__(self):
        return '''
; %s osm_id:%s
[POLYLINE]
Data0=%s
%s
Type=0x%.4X
[END]
'''%(self.__class__,self.id,self.poly2mp(),self.label2mp(),self.type)

class RegionOutline(PolyLine):
    type=0x001C
    def __init__(self,id,poly,name):
        PolyLine.__init__(self, id, poly, name)
        self.name=''
 
class MP:
    dat=[]
    def add(self,obj):
        self.dat+=[obj]
    def __init__(self,FN):
        self.FileName=FN
        self.IMGID=IMGID()

    extra=''
    def write(self,s):
        self.extra+=s
    def dump(self):
        F=open(self.FileName,'w') ;
        F.write(self.extra) 
        F.write(str(self)); 
        F.close()
    def __str__(self):
        S=str(self.IMGID)
        for i in self.dat:
            S+=str(i)
        return S
