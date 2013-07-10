include <windows.dh>
include <system.dh>
include <LookUp2DInc.dh>

const OBJ_CODE_STREET_1 60160 //Street central line



	  
	  
local dist 0 // meters

local ifDeadEnd(ch,nd)
{
  if( !(egs=chGetEdgesOfNode(ch,nd)) )
    return 0;
  ret=ArSize(egs);
  ArFree(egs);
  return ret == 1;
}

global main()
{
 MessageBox("Помните, в файле должны присутствовать только объекты                                     Street center line",MB_ICONEXCLAMATION|MB_OKCANCEL);
  if( !(ch=GetEditDataset()) )
    return;
  StartIndicator("Scanning symbols...",chFeatureNum(ch));
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( chGetFeatureCode(ch,fe) == 502 )//FE_SYMBOL )
    {
      FinishIndicator();
      MessageBox("Карта уже содержит Graphical symbol!",MB_ICONSTOP|MB_OK);
      return;
    }
  }
  
      //условие, чтобы скрипт срабатывал только на STREET
 	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	 
  		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_1 )
			continue;
			
// конец условия			
  
  
  
  
  {
  
  FinishIndicator();
  pars=ArCreate(0);
  ArAdd(pars,"Дистанция в метрах:|0");
  if( !ParamsDlg("Set distance in meters",pars) )
  {
    ArFree(pars);
    return;
  }
  
  
 
  dist=ArGet(pars,1);
  ArFree(pars);
  dist=StrLTrim(dist);
  dist=StrRTrim(dist);
  if( dist == "" )
    return;
  dist=real(dist);
  tot=0;
  StartIndicator("Processing in "+dist+" meters...",chNodeNum(ch));
  for( nd=0; nd=chNextNode(ch,nd); )
  {
    StepIndicator();
    chGetNodeXY(ch,nd,x,y);
    chMap2Geo(ch,x,y,lat,lon);
    chGeo2Map(ch,lat+dist/111120.,lon,x1,y1);
    dx=x-x1;
    dy=y-y1;
    d=sqrt(dx*dx+dy*dy);
    if( !(nds=chFindMetric(ch,M_NODE,x-d,y-d,x+d,y+d)) )
      continue;
    if( !ifDeadEnd(ch,nd) )
      continue;
    for( i=ArSize(nds); i; i-=1 )
    {
      if( (n=ArGet(nds,i)) == nd )
        continue;
      if( (fes=chGetFeaturesOfNode(ch,n)) )
      {
        ArFree(fes);
        continue;
      }
      break;
    }
    ArFree(nds);
    if( i )
    {
      tot+=1;
      fe=chCrtFeature (ch,502);//(ch,FE_SYMBOL); изменено на Графический символ под СитиПлан
      chSetAttrText(ch,fe,SCAMIN,"1");
      chSetFeatureNode(ch,fe,nd);
      continue;
    }
    if( !(egs=chFindMetric(ch,M_EDGE,x-d,y-d,x+d,y+d)) )
      continue;
    sz=ArSize(egs);
    ArFree(egs);
    if( !(egs=chGetEdgesOfNode(ch,nd))  )
      continue;
    ArSort(egs,egs);
    for( i=ArSize(egs); i>1; i-=1 )
    {
      if( ArGet(egs,i) == ArGet(egs,i-1) )
        ArRemoveAt(egs,i);
    } 
    lkn=ArSize(egs);
    ArFree(egs);
    if( lkn != sz )
    {
      tot+=1;
      fe=chCrtFeature (ch,502);//(ch,FE_SYMBOL);
      chSetAttrText(ch,fe,SCAMIN,"2");
      chSetFeatureNode(ch,fe,nd);
      chUpdateFeature(ch,fe);
    }
  }
  
 }
  
  
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
  puts("Найдено на дистанции "+dist+" м: "+tot);
}
