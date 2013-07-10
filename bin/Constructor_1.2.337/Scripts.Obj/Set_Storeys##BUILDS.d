include <system.dh>
include <windows.dh>

const FE_BUILDS 60060
const AT_STRYNM 17516

local error(txt)
{
  MessageBox(txt,MB_OK|MB_ICONSTOP);
  exit(0);
}

global main()
{
  OnError(ERR_IGNORE);
  if( !GetResource("Object",fe) )
    error("Illegal script: object is not defined");
  if( !(ch=GetEditDataset()) )
    return;
  if( FE_BUILDS != chGetFeatureCode(ch,fe) )
    return;
  chHighlightFeature(ch,fe);  
  lst="|1|2|3|4|5|6|7|8|9|10|12|16|18|20|22|24|25";
  if( GetResource("RecentStoreys",last) )
    nlst=StrReplace(lst,"|"+last,"|~~init~~"+last);
  else
    nlst=lst;
  nlst=StrMid(nlst,2);
  if( chGetAttrText(ch,fe,AT_STRYNM,prev) )    
  {
    ttl="Storeys: "+prev;
    prev=int(prev);
  }
  else  
  {
    ttl="Storeys: none";
    prev=0;
  }  
  num=ListDlg(ttl,nlst);
  chHighlightFeature(ch,fe);  
  if( !num )
    return;
  for( ; num; num-=1 )
  {  
    if( !(k=StrFind(lst,"|")) )
      error("assert");  
    lst=StrMid(lst,k+1);
  }  
  num=int(lst);
  if( num != prev && !chSetAttrText(ch,fe,AT_STRYNM,""+num) )
    error("Cannot set storeys");
  SetResource("RecentStoreys",num);
  //puts(""+num);  
  //chUpdateFeature(ch,fe);
  //chUpdatePresentation(ch);
  //Redraw();
}
