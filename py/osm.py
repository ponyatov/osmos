import os,sys
# import cfg
import http
from lxml import etree

class relation:
    def __init__(self):
        pass
    def __init__(self,id):
        self.id=id
        F='../tmp/rel_%s.xml'%id
        if not os.path.exists(F):
            http.get('relation/%s/full'%id,F)
        self.xml=etree.parse(F)
#         self.xml = minidom.parse(F)
#         print self.xml.getUserData(key)
    def __str__(self):
        return '%s: id=%s xml:%s'%(self.__class__,self.id,self.xml)

def download():
    pass
