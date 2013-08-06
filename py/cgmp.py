# -*- coding: utf8 -*-

# CityGuide/MP file formats

import os,time,re
yy,mm,dd,hh=time.localtime()[:4]
NOW='%.2i%.2i%.2i%.2i'%(yy%100,mm,dd,hh)

class BBox:
    def __init__(self,id,A,B,C,D,name):
        self.id=id
        self.A=A
        self.B=B
        self.C=C
        self.D=D
        self.name=name
    def __add__(self,Y):
        X=self
        AA=min(X.A,Y.A)
        BB=min(X.B,Y.B)
        CC=max(X.C,Y.C)
        DD=max(X.D,Y.D)
        ID=X.id+'+'+Y.id
        NN=X.name+'+'+Y.name
        NN=re.sub(r'\++',r'+',NN)
        NN=re.sub(r'\+$',r'',NN)
        return self.__class__(ID,AA,BB,CC,DD,NN)
    def __str__(self):
        (id,A,B,C,D,name)=(self.id,self.A,self.B,self.C,self.D,self.name)
        return str(MapCoverage(id,((A,B),(A,D),(C,D),(C,B)),name))
 
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
Level1=1
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
        self.lat=float(lat) ; self.lon=float(lon)
        self.name=name
 
class POI(mpobj):
    type=0x0000
    def bbox(self):
        return BBox(self.id,self.lat,self.lon,self.lat,self.lon,self.name)
    def __str__(self):
        return '''
; %s osm_id:%s
[POI]
Data0=(%s,%s)
Label=%s
Type=0x%x
EndLevel=1
[END]
'''%(self.__class__,self.id,self.lat,self.lon,self.name,self.type)

class AdminCenter(POI):
    type=0x1500
    
class MainCity(POI):
    type=0x0200

class PolyLine(mpobj):
    type=0x0000
    def bbox(self):
        MA=MB=1e6 ; XA=XB=-1e6 
        for i in self.poly:
            (A,B)=i
            MA=min(MA,A) ; MB=min(MB,B)
            XA=max(XA,A) ; XB=max(XB,B)
        return BBox(self.id,MA,MB,XA,XB,self.name)
    def __init__(self,id,poly,name):
        self.poly=map(lambda x:(float(x[0]),float(x[1])),poly)
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
Label=%s
Type=0x%x
EndLevel=1
[END]
'''%(self.__class__,self.id,self.poly2mp(),self.name,self.type)

class Polygon(PolyLine):
    def __str__(self):
        return '''
; %s osm_id:%s
[POLYGON]
Data0=%s
Label=%s
Type=0x%x
EndLevel=1
[END]
'''%(self.__class__,self.id,self.poly2mp(),self.name,self.type)

class StateBoundary(PolyLine):
    type=0x1C
    def __init__(self,id,poly,name):
        PolyLine.__init__(self, id, poly, name)
        self.name=''

class InternationalBoundary(PolyLine):
    type=0x1E
    def __init__(self,id,poly,name):
        PolyLine.__init__(self, id, poly, name)
        self.name=''

class MapCoverage(Polygon):
    type=0x4b
    def __init__(self,id,poly,name):
        PolyLine.__init__(self, id, poly, name)
        self.name=''
 
class MP:
    dat=[]
    def bbox(self):
        return reduce(
                      lambda x,y: x+y,
                      map(
                          lambda z:z.bbox(), 
                          self.dat
                          )
                      )
    def add(self,obj):
        self.dat+=[obj]
    def __init__(self,FN):
        self.FileName=FN
        self.IMGID=IMGID()

    extra=''
    def write(self,s):
        self.extra+=s
    def dump(self):
        F=open(self.FileName,'w')
        F.write(self.extra) 
        F.write(str(self))
        F.close()
    def __str__(self):
        S=str(self.IMGID)
        CVR=self.bbox();CVR.id='non-osm data';CVR.name=''
        CVR.A-=.1;CVR.B-=.1;CVR.C+=.1;CVR.D+=.1
        S+=str(CVR)
        for i in self.dat:
            S+=str(i)
        return S
