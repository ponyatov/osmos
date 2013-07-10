include <system.dh>
include <LookUp2DInc.dh>

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  show=1;
  tot=0;
  StartIndicator("Processing...",chEdgeNum(ch));
  for( eg=0; eg=chNextEdge(ch,eg); )
  {
    StepIndicator();
    if( !(fes=chGetFeaturesOfEdge(ch,eg)) )
      continue;
    n=0;
    for( i=ArSize(fes); i; i-=1 )
    {
      fe=ArGet(fes,i);
      //if( chGetAttrValue(ch,fe,AT_WIDTH,wid) && wid == 10 )
      //  continue;
      //if( chGetAttrValue(ch,fe,AT_SHIFTX,shift) && shift > 0 )
      //  continue;
	  
	  
   //   if( !chGetAttrValue(ch,fe,AT_LAYERS,layer) || layer < 1 || layer > 3 ) закоментировано, что работало на СитиПлане
    //    continue;
      n+=1;
    }
    if( n > 1 )
    { 
      tot+=1;
      //QueryFeature(ArGet(fes,1));
      if( show )
      {
        show=0;
        chOverviewEdge(ch,eg);
        chHighlightEdge(ch,eg);
      }
      //ArFree(fes);
      //return;
    } 
    ArFree(fes);
  }
  FinishIndicator();
  puts("Total: "+tot);
}
