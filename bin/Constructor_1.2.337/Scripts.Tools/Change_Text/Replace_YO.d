local remove(ch,fe,attr)
{
  if( !chGetAttrText(ch,fe,attr,s) )
    return;
  d=StrReplace(s,"¸","å");
  d=StrReplace(d,"¨","Å");
  d=StrReplace(d,"¹","N");
  if( d != s )
  {
//    puts(s+" -> "+d);
    chSetAttrText(ch,fe,attr,d);
    return 1;
  }
  return 0;
}
 
global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  tot=0;
  StartIndicator("Processing...",chFeatureNum(ch));
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    for( i=chGetAttrsNum(ch,fe); i; i-=1 ) 
      if( remove(ch,fe,chGetAttrCode(ch,fe,i)) )
        tot+=1;
  }
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
  puts("Attributes fixed: "+tot);
}
