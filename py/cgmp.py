# -*- coding: utf8 -*-

# CityGuide/MP file formats

import os,time,re
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)
 
# TYPE={
#       'MainCity':0x0100,
#       'Coverage':0x004B
# }
# 
# def nosp(str):
#     return re.sub(r'\s+',r'',str)
# 
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
Levels=1
Level0=26
PointView=%s
[END]
'''%(self.ID,self.Name,self.LocalName,VV,VS,self.Copyright,self.PointView)
# MainTown=%s

class mpobj:
    def __init__(self,id,lat,lon,name):
        self.id=id
        self.lat=lat ; self.lon=lon
        self.name=name
 
class POI(mpobj):
    type=0x0000
    def __str__(self):
        return '''
; %s %s
[POI]
Data0=(%s,%s)
Label=%s
Type=0x%.4X
[END]
'''%(self.__class__,self.id,self.lat,self.lon,self.name,self.type)
#     def __init__(self,id,type,lat,lon,label=''):
#         self.id=id
#         self.type=type
#         self.lat=lat
#         self.lon=lon
#         self.label=label
#     def __str__(self):
#         return '''
# [POI] ; id:%s
# Data0=(%s,%s)
# Type=0x%x
# Label=%s
# [END]
# '''%(self.id,self.lat,self.lon,self.type,self.label)
# 
# class PLINE:
#     def __init__(self,id,type,coords,label=''):
#         self.id=id
#         self.type=type
#         self.coords=coords
#         self.label=label
#     def __str__(self):
#         return '''
# ; id:%s
# [POLYGON] 
# Data0=%s
# Type=0x%x
# Label=%s
# [END]
# '''%(self.id,nosp(str(self.coords)[1:-1]),self.type,self.label)

class AdminCenter(POI):
    type=0x1500
 
class MP:
# #     lats=[]
# #     lons=[]
    dat=[]
    def add(self,obj):
        self.dat+=[obj]
    def __init__(self,FN):
        self.FileName=FN
        self.IMGID=IMGID()
#         self.POI=[]
#         self.PLINE=[]
#     def addPOI(self,id,type,lat,lon,label=''):
#         self.POI+=[POI(id,type,lat,lon,label)]
#     def addPLINE(self,id,type,coords,label=''):
#         self.PLINE+=[PLINE(id,type,coords,label)]

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
