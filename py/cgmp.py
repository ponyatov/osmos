# -*- coding: utf8 -*-

# CityGuide/MP file formats

import os,time,re
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)

TYPE={
      'MainCity':0x0100,
      'Coverage':0x004B
}

def nosp(str):
    return re.sub(r'\s+',r'',str)

class IMGID:
    ID=NOW
    Name=''
    Version=''
    Copyright=''
    MainTown=''
    PointView='0 0'
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
MainTown=%s
PointView=%s
Version=%s
VersionSub=%s
Copyright=%s
Datum=W84
Elevation=m
Levels=1
Level0=26
[END]
'''%(self.ID,self.Name,self.Name,self.MainTown,self.PointView,VV,VS,self.Copyright)

class POI:
    def __init__(self,id,type,lat,lon,label=''):
        self.id=id
        self.type=type
        self.lat=lat
        self.lon=lon
        self.label=label
    def __str__(self):
        return '''
[POI] ; id:%s
Data0=(%s,%s)
Type=0x%x
Label=%s
[END]
'''%(self.id,self.lat,self.lon,self.type,self.label)

class PLINE:
    def __init__(self,id,type,coords,label=''):
        self.id=id
        self.type=type
        self.coords=coords
        self.label=label
    def __str__(self):
        return '''
; id:%s
[POLYGON] 
Data0=%s
Type=0x%x
Label=%s
[END]
'''%(self.id,nosp(str(self.coords)[1:-1]),self.type,self.label)

class MP:
#     lats=[]
#     lons=[]
    def __init__(self,FN):
        self.FileName=FN
        self.IMGID=IMGID()
        self.POI=[]
        self.PLINE=[]
    def addPOI(self,id,type,lat,lon,label=''):
        self.POI+=[POI(id,type,lat,lon,label)]
    def addPLINE(self,id,type,coords,label=''):
        self.PLINE+=[PLINE(id,type,coords,label)]
    def dump(self):
        F=open(self.FileName,'w') ; 
        F.write(str(self)); 
        F.close()
    def __str__(self):
        S=str(self.IMGID)
        for i in self.POI:
            S+=str(i)
        for i in self.PLINE[:1]:
            S+=str(i)
        return S
    