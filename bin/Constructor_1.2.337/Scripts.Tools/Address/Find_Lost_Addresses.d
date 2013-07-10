include <system.dh>
include <LookUp2DInc.dh>

const FE_ADRESS 60020
const FE_STREET 60160
const AT_OBNAME 60010
const AT_STRNAM 60030
const AT_DSTNAM 61062
const AT_TWNNAM 61063
const AT_TERNAM 61064
const AT_REGNAM 61065

local ArSearch(a,val)
{
  j=ArSize(a);
  i=1;
  while( i < j )
  {
    r=int((i+j)/2);
    c=ArGet(a,r);
    if( val > c )
      i=r+1;
    else if( val < c )
      j=r-1;
    else
      return r;
  }
  if( i == j && ArGet(a,i) == val )
    return i;
  return 0;
}

local addTownName(ch,fe,strnam)
{
  if( !chGetAttrText(ch,fe,AT_TWNNAM,twnnam) )
    twnnam="";
  if( chGetAttrText(ch,fe,AT_REGNAM,extnam) || chGetAttrText(ch,fe,AT_DSTNAM,extnam) || chGetAttrText(ch,fe,AT_TERNAM,extnam) )
    twnnam+=" "+extnam;
  if( twnnam )
    strnam+=" ("+twnnam+")";  
  return strnam;  
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  ClearQuery();  
  StartIndicator("Processing I...",chFeatureNum(ch));
  sts=ArCreate(0);
  ads=ArCreate(0);
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( (code=chGetFeatureCode(ch,fe)) == FE_STREET )
    {
      if( chGetAttrText(ch,fe,AT_STRNAM,strnam) || chGetAttrText(ch,fe,AT_OBNAME,strnam) )
        ArAdd(sts,addTownName(ch,fe,strnam));
    }
    else if( code == FE_ADRESS )
      ArAdd(ads,fe);
  }
  ArSort(sts,sts);
  for( i=ArSize(sts); i > 1; i-=1 )
    if( ArGet(sts,i-1) == ArGet(sts,i) )
      ArRemoveAt(sts,i);
  //for( i=1; i<=ArSize(sts); i+=1 ) puts(ArGet(sts,i));      
  StartIndicator("Processing II...",ArSize(ads));
  nostsnum=0;
  for( i=ArSize(ads); i; i-=1 )
  {
    StepIndicator();
    if( !chGetAttrText(ch,fe=ArGet(ads,i),AT_STRNAM,strnam) )
    {
      ArRemoveAt(ads,i);
      //puts("*** address["+fe+"] has no street name"); 
      nostsnum+=1;
    }
    else 
    {
      addTownName(ch,fe,strnam);
      if( ArSearch(sts,strnam) )
        ArRemoveAt(ads,i);
    }  
  }
  ArFree(sts);
  if( nostsnum )
    puts("*** Addresses without street name: "+nostsnum); 
  if( ArSize(ads) )
  {  
    StartIndicator("Processing III...",ArSize(ads)*2);
    for( i=1; i<=ArSize(ads); i+=1 )
    {
      StepIndicator();
      QueryFeature(ArGet(ads,i));
    }
    ans=ArCreate(0);
    for( i=1; i<=ArSize(ads); i+=1 )
    {
      chGetAttrText(ch,fe=ArGet(ads,i),AT_STRNAM,strnam);
      addTownName(ch,fe,strnam);
      ArAdd(ans,strnam);
    }
    ArSort(ans,ans);
    for( i=ArSize(ans); i > 1; i-=1 )
    {
      StepIndicator();
      if( ArGet(ans,i-1) == ArGet(ans,i) )
        ArRemoveAt(ans,i);
    }   
    puts("Lost addresses street names total: "+ArSize(ans));
    for( i=1; i<=ArSize(ans); i+=1 )
      puts(ArGet(ans,i));
    ArFree(ans);
  }  
  ArFree(ads);
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
}
