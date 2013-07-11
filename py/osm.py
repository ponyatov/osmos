import os,sys
import cfg
import lxml.etree

def api(type,id):
    F='../tmp/%s.%s.osm'%(type,id) # cache file
    try:
        X=lxml.etree.parse(F)
    except:
        X=lxml.etree.parse('%s/%s/%s/full'%(cfg.api,type,id))
        T=open(F,'w') ; T.write(lxml.etree.tostring(X,xml_declaration=True,encoding='utf8')) ; T.close()
    return X 

class relation:
    def __init__(self,id):
        self.id=id
        self.xml=api('relation',id)
    def __str__(self):
        return '%s: id=%s xml:%s'%(self.__class__,self.id,self.xml)
