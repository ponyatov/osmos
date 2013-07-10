include <system.dh>
include <LookUp2DInc.dh>

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
  if( !GetResource("ObjectList",fes) )
    error("Illegal script: object list is not defined");
  if( !(ch=GetEditDataset()) )
    return;
  chHighlightOff(ch);  
  for( i=ArSize(fes); i; i-=1 )
  {  
    fe=ArGet(fes,i);
    if( FE_BUILDS != chGetFeatureCode(ch,fe) || chGetAttrValue(ch,fe,AT_STRYNM,strynm) )
      ArRemoveAt(fes,i);
    else
      chHighlightObject(ch,fe);  
  }
  if( !(i=ArSize(fes)) )
    return;
  
  lst="|1|2|3|4|5|6|7|8|9|10|12|16|18|20|22|24|25";
  if( GetResource("RecentStoreys",last) )
    nlst=StrReplace(lst,"|"+last,"|~~init~~"+last);
  else
    nlst=lst;
  nlst=StrMid(nlst,2);
  num=ListDlg("Set Storeys",nlst);
  if( !num )
    return;
  for( ; num; num-=1 )
  {  
    if( !(k=StrFind(lst,"|")) )
      error("assert");  
    lst=StrMid(lst,k+1);
  }  
  num=int(lst);
  SetResource("RecentStoreys",num);
  num=str(num);
  for( ; i; i-=1 )
    if( !chSetAttrText(ch,fe=ArGet(fes,i),AT_STRYNM,num) )
      error("Cannot set storeys");
  /*chUpdatePresentation(ch);
  Redraw();*/
}
