include <system.dh>
include <LookUp2DInc.dh>

local SelectDataset()
{
  init="";
  arr=ArCreate(0);
  ch=0;
  while( (ch=NextDataset(ch)) )
  {
    if( ch == GetEditDataset() )
      continue;
    if( chGetProperty(ch,CH_NAME,name) )
    {
      init+="|"+name;
      ArAdd(arr,ch);
    }
  }
  if( !(i=ArSize(arr)) )
  {
    ArFree(arr);
    return 0;
  }
  /*if( i == 1 )
  {
    ch=ArGet(arr,1);
    ArFree(arr);
    return ch;
  }*/
  if( !(ret=ListDlg("Select Destination",StrMid(init,2))) )
  {
    ArFree(arr);
    return 0;
  }
  ch=ArGet(arr,ret);
  ArFree(arr);
  return ch;
}

/*local crtEmptyChartBy(chSrc)
{
  if( GetDataset("~~~WorkChart~~~") )
    return 0;
  prev=chSetGeoUnits(1);
  chGetProperty(chSrc,CH_DICT1,ds);
  chGetProperty(chSrc,GEO_PROJECTION,projection);
  if( projection != 1 ) // Mercator
    return 0;
  chGetProperty(chSrc,GEO_SCALE,scale);
  chGetProperty(chSrc,GEO_DATUM,datum);
  chGetProperty(chSrc,GEO_RELATE,relate);
  chGetProperty(chSrc,GEO_NORTH,north);
  chGetProperty(chSrc,GEO_WEST,west);
  //chGetProperty(chSrc,GEO_SOUTH,south);
  //chGetProperty(chSrc,GEO_EAST,east);
  chGetProperty(chSrc,GEO_MAINLAT,mainlat);
  chDst=chCrtMercatorDataset("~~~WorkChart~~~",ds,scale,north,west,mainlat,datum,relate);
  chSetGeoUnits(prev);
  return chDst;
}*/ 

local collectMetric(chSrc,nds,egs)
{
  for( fe=0; fe=chNextFeature(chSrc,fe); )
  {
    if( !IsFeatureQueried(fe) )
      continue;
    if( (type=chGetMetricType(chSrc,fe)) == M_POINT )
    {
      if( chGetFeatureNode(chSrc,fe,nd) )
        ArAdd(nds,nd);
    }  
    else if( type == M_LINE )
    {
      for( i=chGetFeatureLine(chSrc,fe,1,eg,flag); i; i-=1 )
      {
        chGetFeatureLine(chSrc,fe,i,eg,flag);
        ArAdd(egs,eg);
        chGetEdgeBegEnd(chSrc,eg,beg,end);
        ArAdd(nds,beg);
        ArAdd(nds,end);
      }
    }  
    else if( type == M_AREA )
    {
      for( i=chGetFeatureArea(chSrc,fe,0,1,eg,flag); i; i-=1 )
      {
        chGetFeatureArea(chSrc,fe,0,i,eg,flag);
        ArAdd(egs,eg);
        chGetEdgeBegEnd(chSrc,eg,beg,end);
        ArAdd(nds,beg);
        ArAdd(nds,end);
      }
    }  
  }
  if( ArSize(nds) )
  {
    ArSort(nds,nds);
    for( i=ArSize(nds)-1; i; i-=1 )
      if( ArGet(nds,i) == ArGet(nds,i+1) )
        ArRemoveAt(nds,i);
  }      
  if( ArSize(egs) )
  {
    ArSort(egs,egs);
    for( i=ArSize(egs)-1; i; i-=1 )
      if( ArGet(egs,i) == ArGet(egs,i+1) )
        ArRemoveAt(egs,i);
  }      
}

local copyQueried(chDst,chSrc)
{
  for( max=nd=0; (nd=chNextNode(chSrc,nd)); )
    if( max < nd )
      max=nd;
  cvrtNd=ArCreate(max);
  for( nd=1; nd<=max; nd+=1 )
    ArSetAt(cvrtNd,nd,0);
  for( max=eg=0; (eg=chNextEdge(chSrc,eg)); )
    if( max < eg )
      max=eg;
  cvrtEg=ArCreate(max);
  for( eg=1; eg<=max; eg+=1 )
    ArSetAt(cvrtEg,eg,0);
  nds=ArCreate(0);  
  egs=ArCreate(0);  
  collectMetric(chSrc,nds,egs);
  num=ArSize(nds);
  if( !num )//|| !(chDst=crtEmptyChartBy(chSrc)) )
  {
    ArFree(cvrtEg);
    ArFree(cvrtNd);
    ArFree(egs);
    ArFree(nds);
    return 0;
  }  
  chOpenBorder(chDst);
  prev=chSetGeoUnits(1);
  for( j=1; j<=num; j+=1 )
  {
    if( chGetNodeXY(chSrc,nd=ArGet(nds,j),lat,lon) )
      ArSetAt(cvrtNd,nd,chCrtNode(chDst,lat,lon));
  }    
  num=ArSize(egs);
  for( j=1; j<=num; j+=1 )
  {
    if( (sz=chGetEdgeBegEnd(chSrc,eg=ArGet(egs,j),beg,end)-2) >= 0 )
    {
      beg=ArGet(cvrtNd,beg);
      end=ArGet(cvrtNd,end);
      ArSetAt(cvrtEg,eg,egdst=chCrtEdge(chDst,beg,end));
      for( i=1; i<=sz; i+=1 )
        if( chGetEdgeXY(chSrc,eg,i,lat,lon) )
          chIncEdge(chDst,egdst,i,lat,lon);
      if( (sz+=2) == chGetEdgeXYZ(chSrc,eg,0,lat,lon,hei) && chToggle2D3D(chDst,egdst) )
      {
        chEdiEdge(chDst,egdst,0,lat,lon,hei);
        for( i=1; i<sz; i+=1 )
          if( chGetEdgeXYZ(chSrc,eg,i,lat,lon,hei) )
            chEdiEdge(chDst,egdst,i,lat,lon,hei);
      }    
    }
  }
  ArFree(egs);
  ArFree(nds);
  for( max=feSrc=0; (feSrc=chNextFeature(chSrc,feSrc)); )
    if( max < feSrc )
      max=feSrc;
  cvrtFe=ArCreate(max);
  for( feSrc=0; (feSrc=chNextFeature(chSrc,feSrc)); )
  {
    if( !IsFeatureQueried(feSrc) )
      continue;
    fecode=chGetFeatureCode(chSrc,feSrc);
    feDst=chCrtFeature(chDst,fecode,chGetFeatureDictionary(chSrc,feSrc));
    ArSetAt(cvrtFe,feSrc,feDst);
    for( i=chGetAttrsNum(chSrc,feSrc); i; i-=1 ) 
    {
      atcode=chGetAttrCode(chSrc,feSrc,i);
      if( chGetAttrText(chSrc,feSrc,atcode,txt) )
        chSetAttrText(chDst,feDst,atcode,txt);
    }
    if( (type=chGetMetricType(chSrc,feSrc)) == M_POINT )
    {
      if( chGetFeatureNode(chSrc,feSrc,nd) )
        chSetFeatureNode(chDst,feDst,ArGet(cvrtNd,nd));
    }
    else if( type == M_LINE )
    {
      if( (sz=chGetFeatureLine(chSrc,feSrc,1,eg,flag)) )
        chIncFeatureLine(chDst,feDst,1,ArGet(cvrtEg,eg),flag);
      for( i=2; i<=sz; i+=1 )
      {
        chGetFeatureLine(chSrc,feSrc,i,eg,flag);
        chIncFeatureLine(chDst,feDst,i,ArGet(cvrtEg,eg),flag);
      }
    }
    else if( type == M_AREA )
    {
      cntnum=chGetFeatureArea(chSrc,feSrc,0,0,eg,flag);
      for( i=1; i<=cntnum; i+=1 )
      {
        sz=chGetFeatureArea(chSrc,feSrc,i,1,eg,flag);
        for( j=1; j<=sz; j+=1 )
        {
          chGetFeatureArea(chSrc,feSrc,i,j,eg,flag);
          chIncFeatureArea(chDst,feDst,i,j,ArGet(cvrtEg,eg),flag);
        }
      }
      chTestMetric(chDst,feDst);
    }
  }    
  chSetGeoUnits(prev);
  ArFree(cvrtFe);
  ArFree(cvrtEg);
  ArFree(cvrtNd);
  chFitBorder(chDst);
  chUpdatePresentation(chDst);
  return chDst;
}

global main()
{
  if( !(chSrc=GetEditDataset()) )
    return;
  if( !(chDst=SelectDataset()) )
    return;  
  copyQueried(chDst,chSrc);
  Redraw();
  if( (rep=ArReport()) )
    puts("arrays!!!\r\n"+rep);
}
