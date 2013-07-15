import os,sys,re
import cfg
import lxml.etree
from idlelib.IOBinding import encoding

def xapi(req):
    S='%s%s'%(cfg.xapi,req)
    print S
#     S=re.sub(r'\[',r'%5B',S)
#     S=re.sub(r'\]',r'%5D',S)
    return lxml.etree.parse(S) 

def api(type,id):
    F='../tmp/%s.%s.osm'%(type,id) # cache file
    try:
        X=lxml.etree.parse(F)
    except:
        try:
            X=lxml.etree.parse('%s/%s/%s/full'%(cfg.api,type,id))
        except:
            X=lxml.etree.parse('%s/%s/%s'%(cfg.api,type,id))
        T=open(F,'w')
        T.write(lxml.etree.tostring(X,xml_declaration=False,encoding='utf8'))
        T.close()
    return X

class osm:
    def __init__(self,id):
        self.id=id
        TP,ID=str(self.__class__).split('.')[-1],id
        self.FileName=F='../tmp/%s.%s.osm'%(TP,ID)
        self.xml=api(TP,ID)
        self.lat =self.xml.xpath('//*[@lat]')[0].attrib['lat']
        self.lon =self.xml.xpath('//*[@lon]')[0].attrib['lon']
#         print '//tag[@id="%s"][@k="name"]'%self.id
        try:
            self.name=self.xml.xpath('//tag[@k="name"]')[0].attrib['v']
        except:
            self.name=self.id
    def xpath(self,xp):
        return self.xml.xpath(xp)
    def __str__(self):
        return '%s: id=%s xml:%s'%(self.__class__,self.id,self.xml)

class relation(osm):
    pass

class node(osm):
    pass 

class way(osm):
    def __init__(self,id):
        osm.__init__(self,id)
        self.nodes={}
        for i in self.xpath('/osm/node'):
            A=i.attrib
            self.nodes[A['id']]=(A['lat'],A['lon'])
        self.poly=[]
        for i in self.xpath('/osm/way/nd'):
            self.poly+=[self.nodes[i.attrib['ref']]]
