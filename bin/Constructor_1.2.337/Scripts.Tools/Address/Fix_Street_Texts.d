include <system.dh>
include <LookUp2DInc.dh>

const FE_STREET 60160
const FE_GRTEXT 504
const AT_STRNAM 60030
const AT_OBNAME 60010
const AT_SCALVL 1703
const AT_SCAMIN 133


local isEqualLinear(ch,fe1,fe2)
{
  if( !chGetFeatureLine(ch,fe1,ln1) || !chGetFeatureLine(ch,fe2,ln2) )
    return 0;
  if( ln1 == ln2 )
    return 1;
  sz1=chGetLine(ch,ln1,1,eg1,flag1);
  sz2=chGetLine(ch,ln2,1,eg2,flag2);
  if( sz1 != sz2 || eg1 != eg2 )
    return 0;
  for( i=2; i<=sz1; i+=1 )
  {
    chGetLine(ch,ln1,i,eg1,flag1);
    chGetLine(ch,ln2,i,eg2,flag2);
    if( sz1 != sz2 || eg1 != eg2 )
      return 0;
  }
  return 0;
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  tottxt=totnam=0;  
  StartIndicator("Processing...",chFeatureNum(ch));
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( chGetFeatureCode(ch,fe) != FE_STREET )
      continue;
    if( !chGetFeatureLine(ch,fe,1,eg,flag) )
      continue;
    if( !(fes=chGetFeaturesOfEdge(ch,eg)) )
      continue;
    if( !chGetAttrText(ch,fe,AT_OBNAME,obname) )
      obname="";
    if( !chGetAttrText(ch,fe,AT_STRNAM,strnam) )
    {
      if( obname == "" )
        continue;
      puts("strnam["+fe+"] <- obname["+fe+"]"+obname); 
      chSetAttrText(ch,fe,AT_STRNAM,strnam=obname);  
      totnam+=1;
    } 
    else if( obname != strnam )
    {
      puts("obname["+fe+"]"+obname+" <- strnam["+fe+"]"+strnam); 
      chSetAttrText(ch,fe,AT_OBNAME,obname=strnam);  
      totnam+=1;
    }
    if( !chGetAttrValue(ch,fe,AT_SCALVL,scalvl) )
      scalvl=0;
    for( i=ArSize(fes); i; i-=1 )
    {
      fe2=ArGet(fes,i);
      if( fe2 == fe )
        continue;
      if( chGetFeatureCode(ch,fe2) != FE_GRTEXT ) 
        continue; 
      if( !chGetAttrValue(ch,fe2,AT_SCALVL,scalvl2) )
        scalvl2=0;	
      if( scalvl != scalvl2 )
        continue;  
		
		
		
		//масштаб SCAMIN
	//	    if( !chGetAttrValue(ch,fe,AT_SCAMIN,scamin) )
   //   scamin=0;
  //  for( i=ArSize(fes); i; i-=1 )
  //  {
  //    fe2=ArGet(fes,i);
    //  if( fe2 == fe )
    //    continue;
    //  if( chGetFeatureCode(ch,fe2) != FE_GRTEXT ) 
     //   continue; 
     // if( !chGetAttrValue(ch,fe2,AT_SCAMIN,scamin2) )
    //    scamin2=0;	
    //  if( scalvl != scamin2 )
      //  continue; 
		
		
		// конец масштаба
      if( !isEqualLinear(ch,fe,fe2) )
        continue;  
      if( !chGetAttrText(ch,fe2,AT_TXTVAL,txt) )
        txt="";
      if( txt != strnam )
      {
        puts("text["+fe2+"]"+txt+" <- strnam["+fe+"]"+strnam); 
        chSetAttrText(ch,fe2,AT_TXTVAL,strnam);
        tottxt+=1;
      }
    }  
    ArFree(fes);     
  }
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
  puts("Total fixed: "+totnam+" names; "+tottxt+" texts;");
}
