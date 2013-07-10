include <dkart.dh>
include <LookUp2DInc.dh>

/*local hasOtherStreets(ch,nd,fe)
{
  if( !(egs=chGetEdgesOfNode(ch,nd)) )
    return 0;
  for( i=ArSize(egs); i; i-=1 )
  {
    if( !(fes=chGetFeaturesOfEdge(ch,ArGet(egs,i))) )
      continue;
    for( j=ArSize(fes); j; j-=1 )
    {
      if( (f=ArGet(fes,j)) != fe && chGetFeatureCode(ch,f) == 60410 )
      {
        ArFree(fes);
        ArFree(egs);
        return 1;
      } 
    }
    ArFree(fes);
  }
  ArFree(egs);
  return 0;  
}*/

local copy(ch,fe)
{
  code=chGetFeatureCode(ch,fe);
  ds=chGetFeatureDictionary(ch,fe);
  fe2=chCrtFeature(ch,code,ds);
  for( i=dsObjAttr(ds,code,0); i; i-=1 )
  {
    atcode=dsObjAttr(ds,code,i);
    if( chGetAttrText(ch,fe,atcode,val) )
      chSetAttrText(ch,fe2,atcode,val);
  }
  return fe2;
}

local SplitLine(ch,fe)
{
  for( i=chGetFeatureLine(ch,fe,0,null,null); i>1; i-=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    fe2=copy(ch,fe);
    chIncFeatureLine(ch,fe2,1,eg,flag);
    chEdiFeatureLine(ch,fe,eg,0,0);
  }
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  a=ArCreate(0);
  for( fe=0; fe=chNextFeature(ch,fe); )
    if( chGetMetricType(ch,fe) == M_LINE &&
        //chGetFeatureCode(ch,fe) == 60160 // Street central line
        chGetFeatureCode(ch,fe) == FE_LINE &&
        chGetAttrValue(ch,fe,AT_LAYERS,layer) && layer >= 1 && layer <= 3  )
      ArAdd(a,fe);
  StartIndicator("Processing...",ArSize(a));
  for( i=ArSize(a); i; i-=1 )
  {
    StepIndicator();
    SplitLine(ch,ArGet(a,i));
  }
  ArFreeAll();
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
}
