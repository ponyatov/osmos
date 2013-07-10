include <system.dh>
include <LookUp2DInc.dh>

const TYPE_STR 8

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  StartIndicator("Processing...",chFeatureNum(ch));
  tot=0;
  null=EmptyValue();
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    ds=chGetFeatureDictionary(ch,fe);
    obcode=chGetFeatureCode(ch,fe);
    for( i=dsObjAttr(ds,obcode,0); i; i-=1 )
    {
      atcode=dsObjAttr(ds,obcode,i);
      if( dsAttrType(ds,atcode) == TYPE_STR && chGetAttrText(ch,fe,atcode,s1) )
      {
        s2=StrRTrim(StrLTrim(s1));
        while( StrFind(s2,"  ") > 0 )
          s2=StrReplace(s2,"  "," ");
        if( s2 == "" )
        {
          tot+=1;
          chSetAttrValue(ch,fe,atcode,null);
        }
        else if( s1 != s2 )
        {
          tot+=1;
          //chSetAttrValue(ch,fe,atcode,s2);
          chSetAttrText(ch,fe,atcode,s2);
        }
      }
    }
  }
  puts("Total attributes fixed: "+tot);
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
}
