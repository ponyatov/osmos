include <LookUp2DInc.dh>
include <dkart.dh>
include <windows.dh>

local getLineBegEnd(ch,fe,n1,n2)
{
  if( chGetFeatureCode(ch,fe) == FE_PARENT ||
      chGetMetricType(ch,fe) != M_LINE )
    return 0;
  sz=chGetFeatureLine(ch,fe,1,eg,flag);
  chGetEdgeBegEnd(ch,eg,b,e);
  if( flag & M_REVERSE )
    n1=e;
  else
    n1=b;
  chGetFeatureLine(ch,fe,sz,eg,flag);
  chGetEdgeBegEnd(ch,eg,b,e);
  if( flag & M_REVERSE )
    n2=b;
  else
    n2=e;
  return 1;
}

local split(ch,fe,nd)
{
  sz=chGetFeatureLine(ch,fe,1,eg,flag);
  ln=chCrtLine(ch);
  for( i=1; i<=sz; i+=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    chIncLine(ch,ln,i,eg,flag);
  }
  chSetFeatureLine(ch,fe,ln);
  for( i=1; i<sz; i+=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    chGetEdgeBegEnd(ch,eg,b,e);
    if( flag & M_REVERSE )
      e=b;
    if( e == nd )
      break;
  }
  if( i >= sz )
    return 0;
  if( !(ln=chCrtLine(ch)) )
    return 0;
  for( j=i+1; j<=sz; j+=1 )
  {
    chGetFeatureLine(ch,fe,j,eg,flag);
    chIncLine(ch,ln,-1,eg,flag);
  }
  while( chGetFeatureLine(ch,fe,i+1,eg,flag) > i )
    chEdiFeatureLine(ch,fe,eg,0,0);
  code=chGetFeatureCode(ch,fe);
  ds=chGetFeatureDictionary(ch,fe);
  if( !(fe2=chCrtFeature(ch,code,ds)) )
  {
    chDelLine(ch,ln);
    return 0;
  }
  chSetFeatureLine(ch,fe2,ln);
  for( i=dsObjAttr(ds,code,0); i; i-=1 )
    if( chGetAttrText(ch,fe,att=dsObjAttr(ds,code,i),txt) )
      chSetAttrText(ch,fe2,att,txt);
  return fe2;
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( !GetResource("Node",nd) )
  {
    MessageBox("Illegal script: node is not defined",MB_OK|MB_ICONSTOP);
    return;
  }
  if( !(egs=chGetEdgesOfNode(ch,nd)) )
    return;  
  fes=ArCreate(0);
  for( i=ArSize(egs); i; i-=1 )
  {
    if( !(a=chGetFeaturesOfEdge(ch,ArGet(egs,i))) )
      continue;
    for( j=ArSize(a); j; j-=1 )
    {
      if( !getLineBegEnd(ch,fe=ArGet(a,j),n1,n2) || n1 == nd || n2 == nd )
        continue; 
      for( r=ArSize(fes); r && ArGet(fes,r)!=fe; r-=1 );
      if( !r )
        ArAdd(fes,fe);
    }
    ArFree(a);
  }
  ArFree(egs);
  if( !ArSize(fes) )
  {
    ArFree(fes);
    return;
  }
  if( ArSize(fes) == 1 )
    i=1;
  else
  {
    lst="";
    for( i=1; i<=ArSize(fes); i+=1 )
    {
      lst+="|";
      fe=ArGet(fes,i);
      ds=chGetFeatureDictionary(ch,fe);
      if( dsObjTitle(ds,chGetFeatureCode(ch,fe),ttl) )
        lst+=ttl;
      lst+="["+ArGet(fes,i)+"]";
    }
    if( !(i=ListDlg("Select linear to split",StrMid(lst,2))) )
    {
      ArFree(fes);
      return;
    }   
  }
  if( (fe2=split(ch,fe1=ArGet(fes,i),nd)) )
  {
    chUpdateFeature(ch,fe1);
    chUpdateFeature(ch,fe2);
    chUpdatePresentation(ch);
    Redraw();
  }
  ArFree(fes);
  if( (txt=ArReport()) )
  {
    puts("*** "+txt);
    ArFreeAll();
  }
}
