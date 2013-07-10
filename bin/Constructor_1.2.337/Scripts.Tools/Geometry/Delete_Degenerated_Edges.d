include <dkart.dh>

local say(ch,fe,eg)
{
  title="";
  dsObjTitle(chGetFeatureDictionary(ch,fe),chGetFeatureCode(ch,fe),title);
  puts("cannot deleted edge #"+eg+" because of "+title+" #"+fe);
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  todel=ArCreate(0);
  for( eg=0; (eg=chNextEdge(ch,eg)); )
  {
    if( !chEdgeBorder(ch,eg,x1,y1,x2,y2) || x1 != x2 || y1 != y2 )
      continue;
    chGetEdgeBegEnd(ch,eg,beg,end);
    if( beg != end )
    {
      for( eg2=0; (eg2=chNextEdge(ch,eg2)); )
      {
        chGetEdgeBegEnd(ch,eg2,beg2,end2);
        if( beg2 == end )
          chSetEdgeBeg(ch,eg2,beg);
        if( end2 == end )
          chSetEdgeEnd(ch,eg2,beg);
      }
      chDelNode(ch,end);
    }
    ignored=0;
    if( (fes=chGetFeaturesOfEdge(ch,eg)) )
    {
      for( i=ArSize(fes); i; i-=1 )
      {
         type=chGetMetricType(ch,fe=ArGet(fes,i));
         if( type == M_LINE )
         {
           if( chGetFeatureLine(ch,fe,0,null,null) == 1 )
           {
             ignored+=1;
             say(ch,fe,eg);
           }
           else
             chEdiFeatureLine(ch,fe,eg,0,0);
         }
         else if( type == M_AREA )
         {
           if( chGetFeatureArea(ch,fe,0,0,null,null) == 1 &&
               chGetFeatureArea(ch,fe,1,0,null,null) == 1 )
           {
             ignored+=1;
             say(ch,fe,eg);
           }
           else
             chEdiFeatureArea(ch,fe,eg,0,0);
         }
      }
      ArFree(fes);
    }
    if( !ignored )
      ArAdd(todel,eg);
  }
  for( i=ArSize(todel); i; i-=1 )
  {
    chGetEdgeBegEnd(ch,eg=ArGet(todel,i),beg,end);
    if( !chDelEdge(ch,eg) )
      puts("*** cannot delete edge #"+eg);
    else 
    {
      chDelNode(ch,beg);
      if( beg != end )
        chDelNode(ch,end);
    }
  }
  puts("deleted: "+ArSize(todel)+" degenerated edge(s)");
  ArFree(todel);
  chUpdatePresentation(ch);
  Redraw();
}
