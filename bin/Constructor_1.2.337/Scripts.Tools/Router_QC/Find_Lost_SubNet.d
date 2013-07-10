//Работает на dcf на словаре CityPlan толmrj с объектами StreetCenterLine
include <windows.dh>
include <system.dh>
include <LookUp2DInc.dh>

local egs 0
local frt 0
local ch 0
local cnt 0

/*local isLine(ch,fe)
{
  return( chGetFeatureCode(ch,fe) == FE_LINE &&
          chGetAttrValue(ch,fe,AT_LAYERS,layer) && layer >= 1 && layer <= 3 );
}*/

local _isLine(ch,fe)
{
  return(  (code=chGetFeatureCode(ch,fe)) == 60160 || 60770);                           // Paths
}

local findIn(a,v)
{
  for( i=ArSize(a); i && v!=ArGet(a,i); i-=1 );
  return i;
}

local front()
{
  nd=ArGet(frt,1);
  if( !(es=chGetEdgesOfNode(ch,nd)) )
  {
    ArRemoveAt(frt,1);
    return;
  }
  for( i=ArSize(es); i; i-=1 )
  {
    eg=ArGet(es,i);
    if( !(j=findIn(egs,eg)) )
      continue;
    chGetEdgeBegEnd(ch,eg,beg,end);
    if( beg != nd && !findIn(frt,beg) )
    {
      ArAdd(frt,beg);
      //chHighlightNode(ch,beg);
    }
    if( end != nd && !findIn(frt,end) )
    {
      ArAdd(frt,end);
      //chHighlightNode(ch,end);
    }
    ArRemoveAt(egs,j);
    //chHighlightEdge(ch,eg);
    //if( !((cnt+=1)%100) )
    //  puts(""+ArSize(egs)+" "+ArSize(frt));
  }
  ArFree(es);
  ArRemoveAt(frt,1);
  //chHighlightNode(ch,nd);
} 

global main()
{

 MessageBox("Перед использованем скрипта сделайте \n Compact Chart без объединения объектов \n с одинаковыми атрибутами",MB_OK|MB_ICONINFORMATION);
  if( !(ch=GetEditDataset()) )
    return;
  //if( IDNO == MessageBox("Перед поиском необходим Compact без слияния идентичных атрибутов:\nTools -> Compact Chart\nMerge identical attributes = No\n\nЭто было сделано?",MB_ICONINFORMATION|MB_YESNO) )
  //  return;
  chCompact(ch,0);
  //ArFreeAll();
  egs=ArCreate(0);
  frt=ArCreate(0);
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    if (  (code=chGetFeatureCode(ch,fe)) == 60160 || 60770)//if( isLine(ch,fe) )
    {
      if( chGetAttrText(ch,fe,SORDAT,sordat) )
      {
        MessageBox("Найдены линии с отметкой SORDAT",MB_OK|MB_ICONSTOP);
        ArFreeAll();
        return; 
      }
      sz=chGetFeatureLine(ch,fe,1,eg,flag);
      ArAdd(egs,eg);
      for( i=2; i<=sz; i+=1 )
      {
        chGetFeatureLine(ch,fe,i,eg,flag);
        ArAdd(egs,eg);
      }
    }
  }
  chGetEdgeBegEnd(ch,ArGet(egs,1),beg,end);
  ArAdd(frt,beg);
  while( (k=ArSize(frt)) )
    front();
  //puts("Найдено линий: "+ArSize(egs));
  chHighlightOff(ch);
  tot=0;
  for( i=ArSize(egs); i; i-=1 )
  {
    if( !(fes=chGetFeaturesOfEdge(ch,eg=ArGet(egs,i))) )
    {
      puts("***"+eg);
      chHighlightEdge(ch,eg);
    }
    r=0;
    for( j=ArSize(fes); j; j-=1 )
    {
      if( (code=chGetFeatureCode(ch,fe=ArGet(fes,j))) == 60160 || 60770) //isLine(ch,fe=ArGet(fes,j)) )
      {
        if( !chGetAttrValue(ch,fe,SORDAT,sordat) )
        {
          chSetAttrValue(ch,fe,SORDAT,20000101);
          tot+=1;
        }
        r+=1;
      }
    }
    ArFree(fes);
    if( r > 1 )
      puts("*** shared edge "+eg);
    else if( !r )
    {
      puts("***"+eg);
      chHighlightEdge(ch,eg);
    }
  }
  ArFreeAll();
  if( tot )
    MessageBox("Отмечено SORDAT: "+tot,MB_OK|MB_ICONINFORMATION);
  else
    MessageBox("Потеряных участков не найдено. Рекомедуется снова сделать Compact",MB_OK|MB_ICONINFORMATION);
	
	
	
  puts("Найдено оторваных от дорожного графа объектов: "+tot);
}
