include <system.dh>
include <windows.dh>
include <LookUp2DInc.dh>

const n360 0 //360

global main()
{
  //ArFreeAll();
  t0=CurrentTime();
  if( !(chDst=GetEditDataset()) )
    return;
    
  init="";
  arr=ArCreate(0);
  for( ch=0; ch=NextDataset(ch); )
  {
    if( ch == chDst )
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
    return;
  }
  if( !(ret=MultiListDlg("Select datasets to embed",StrMid(init,2))) )
  {
    ArFree(arr);
    return;
  }
  if( !(k=ArSize(ret)) )
  {
    ArFree(arr);
    ArFree(ret);
    return;
  }
  chOpenBorder(chDst);
  chSetGeoUnits(2);
  
  for( ; k; k-=1 )
  {
    chSrc=ArGet(arr,ArGet(ret,k));
    
    if( FindNativeCall("chPrealloc*6") > 0 )
      chPrealloc(chDst,chNodeNum(chSrc),chEdgeNum(chSrc),chLineNum(chSrc),chAreaNum(chSrc),chFeatureNum(chSrc));
  
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
    for( nd=0; (nd=chNextNode(chSrc,nd)); )
      if( chGetNodeXY(chSrc,nd,lat,lon) )
        ArSetAt(cvrtNd,nd,chCrtNode(chDst,lat,lon+n360));
    for( eg=0; (eg=chNextEdge(chSrc,eg)); )
    {
      if( (sz=chGetEdgeBegEnd(chSrc,eg,beg,end)-2) >= 0 )
      {
        beg=ArGet(cvrtNd,beg);
        end=ArGet(cvrtNd,end);
        ArSetAt(cvrtEg,eg,egdst=chCrtEdge(chDst,beg,end));
        for( i=1; i<=sz; i+=1 )
          if( chGetEdgeXY(chSrc,eg,i,lat,lon) )
            chIncEdge(chDst,egdst,i,lat,lon+n360);
        if( (sz+=2) == chGetEdgeXYZ(chSrc,eg,0,lat,lon,hei) && chToggle2D3D(chDst,egdst) )
        {
          chEdiEdge(chDst,egdst,0,lat,lon+n360,hei);
          for( i=1; i<sz; i+=1 )
            if( chGetEdgeXYZ(chSrc,eg,i,lat,lon,hei) )
              chEdiEdge(chDst,egdst,i,lat,lon+n360,hei);
        }    
      }
    }
    for( max=feSrc=0; (feSrc=chNextFeature(chSrc,feSrc)); )
      if( max < feSrc )
        max=feSrc;
    cvrtFe=ArCreate(max);
    for( feSrc=0; (feSrc=chNextFeature(chSrc,feSrc)); )
    {
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
        cntnum=chGetFeatureArea(chSrc,feSrc,0,0,null,null);
        for( i=1; i<=cntnum; i+=1 )
        {
          sz=chGetFeatureArea(chSrc,feSrc,i,1,eg,flag);
          for( j=1; j<=sz; j+=1 )
          {
            chGetFeatureArea(chSrc,feSrc,i,j,eg,flag);
            chIncFeatureArea(chDst,feDst,i,j,ArGet(cvrtEg,eg),flag);
          }
        }
      }
    }    
    for( feSrc=0; (feSrc=chNextFeature(chSrc,feSrc)); )
    {
      feDst=ArGet(cvrtFe,feSrc);
      sz=chGetSlaves(chSrc,feSrc,0); 
      for( i=1; i<=sz; i+=1 )
        chLinkM2S(chDst,feDst,ArGet(cvrtFe,chGetSlaves(chSrc,feSrc,i)));
      sz=chGetPeers(chSrc,feSrc,0); 
      for( i=1; i<=sz; i+=1 )
        if( (fe=chGetPeers(chSrc,feSrc,i)) > feSrc )
          chLinkP2P(chDst,feDst,ArGet(cvrtFe,fe));
    }
    ArFree(cvrtFe);
    ArFree(cvrtEg);
    ArFree(cvrtNd);
  }
  
  ArFree(arr);
  ArFree(ret);
  if( FindNativeCall("chPrealloc*1") > 0 )
    chPrealloc(chDst);
  chFitBorder(chDst);
  chUpdatePresentation(chDst);
  Redraw();
  puts("Embedding time: "+(CurrentTime()-t0)+" s");
  /*if( (rep=ArReport()) )
  {
    puts("!!!!!!!!!!!!!!!!!!");
    puts("unclosed arrays: "+rep);
    ArFreeAll();
  }*/
}
