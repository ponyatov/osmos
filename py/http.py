import os,sys
from cfg import api,wget,http_auth
import log

def get(req,targfile):
    C='%s %s -O %s %s/%s'%(wget,http_auth,targfile,api,req)
    log.log(C)
    os.system(C)
