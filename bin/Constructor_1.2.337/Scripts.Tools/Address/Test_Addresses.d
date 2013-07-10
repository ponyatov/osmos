include <system.dh>
include <LookUp2DInc.dh>

const FE_STREET 60160
const FE_GRTEXT 504
const FE_ADRESS 60020
const AT_STRNAM 60030
const AT_TWNNAM 61063
const AT_OBNAME 60010
const AT_SCALVL 1703

local findIn(ar,key)
{
  for( i=ArSize(ar); i; i-=1 )
  {
    if( ArGet(ar,i) == key )
      return i;
  }
  return 0;
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  StartIndicator("Processing...",chFeatureNum(ch)*3);
  max_scalvl=0;
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( chGetFeatureCode(ch,fe) == FE_STREET && chGetAttrValue(ch,fe,AT_SCALVL,scalvl) && max_scalvl < scalvl )
      max_scalvl=scalvl;
  }
  strs=ArCreate(0);
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( chGetFeatureCode(ch,fe) == FE_STREET && chGetAttrValue(ch,fe,AT_SCALVL,scalvl) && max_scalvl == scalvl )
    {
      if( !chGetAttrText(ch,fe,AT_STRNAM,strnam) && !chGetAttrText(ch,fe,AT_OBNAME,strnam) )
        continue;
      if( chGetAttrText(ch,fe,AT_TWNNAM,twnnam) )
        strnam+=" ("+twnnam+")";
      ArAdd(strs,strnam);  
    }
  }
  if( !ArSize(strs) )
  {
    ArFree(strs);
    puts("No streets");
    return;
  } 
  ArSort(strs,strs);
  for( i=ArSize(strs); i>1; i-=1 )
    if( ArGet(strs,i-1) == ArGet(strs,i) )
      ArRemoveAt(strs,i);
  ClearQuery();    
  nfnd=ArCreate(0);
  numa=numn=0;    
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( chGetFeatureCode(ch,fe) == FE_ADRESS && chGetAttrValue(ch,fe,AT_SCALVL,scalvl) && max_scalvl == scalvl )
    {
      numa+=1;
      if( !chGetAttrText(ch,fe,AT_STRNAM,strnam) )
      {
        numn+=1;
        continue;
      }  
      if( chGetAttrText(ch,fe,AT_TWNNAM,twnnam) )
        strnam+=" ("+twnnam+")";
      if( !findIn(strs,strnam) )
      {
        QueryFeature(fe);  
        ArAdd(nfnd,strnam);
      }
    }
  }
  ArFree(strs);
  if( numn )
    puts("Addresses without street name: "+numn);
  if( !ArSize(nfnd) )
  {
    if( !numa )
      puts("No addresses at all");
    else  
      puts("No orphaned addresses");
    ArFree(nfnd);
    return 0;
  }
  ArSort(nfnd,nfnd);
  n=1;
  tot=0;
  puts("Orphaned addresses (see query for details):");
  for( i=ArSize(nfnd); i>1; i-=1 )
  {
    if( ArGet(nfnd,i-1) == ArGet(nfnd,i) )
      n+=1;
    else
    {
      puts(ArGet(nfnd,i)+": "+n);
      n=1;
      tot+=1;
    }
  }   
  if( ArSize(nfnd) > 1 && ArGet(nfnd,1) != ArGet(nfnd,2) )
  {
    puts(ArGet(nfnd,1)+": 1");
    tot+=1;
  }  
  //for( i=1; i<=ArSize(nfnd); i+=1 )
  //  puts(ArGet(nfnd,i));
  //puts("Total street names: "+tot);  
  FinishIndicator();
  ArFree(nfnd);
  //chUpdatePresentation(ch);
  //Redraw();
}
