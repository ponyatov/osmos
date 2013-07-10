include <system.dh>
include <windows.dh>

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( MessageBox("Убедитесь, что активной является карта с покрытием, и остальные карты будут обрезаны по ее границе",MB_ICONINFORMATION|MB_OKCANCEL) == IDCANCEL )
    return;  
  if( chFeatureNum(ch) != 1 || chGetMetricType(ch,1) != M_LINE )
  {
    MessageBox("Активная карта не содержит покрытия",MB_ICONSTOP|MB_OK);
    return;  
  }  
  chSetGeoUnits(1);
  cvr=ArCreate(0);
  sz=chGetFeatureLine(ch,1,0,eg,flag);
  lat0=lon0=0;
  for( i=1; i<=sz; i+=1 )
  {
    chGetFeatureLine(ch,1,i,eg,flag);
    sze=chGetEdgeXY(ch,eg,0,lat,lon);
    if( flag & M_REVERSE )
    {
      for( j=sze-1; j>=0; j-=1 )
      {
        chGetEdgeXY(ch,eg,j,lat,lon);
        if( lat == lat0 && lon == lon0 )
          continue;
        ArAdd(cvr,lat0=lat);
        ArAdd(cvr,lon0=lon);
      }
    }
    else
    {
      for( j=0; j<sze; j+=1 )
      {
        chGetEdgeXY(ch,eg,j,lat,lon);
        if( lat == lat0 && lon == lon0 )
          continue;
        ArAdd(cvr,lat0=lat);
        ArAdd(cvr,lon0=lon);
      }
    }
  }
  if( (i=ArSize(cvr)) < 8 || ArGet(cvr,1) != ArGet(cvr,i-1) || ArGet(cvr,2) != ArGet(cvr,i) )
  {
    ArFree(cvr);
    MessageBox("Некорректное (незамкнутое) покрытие",MB_ICONSTOP|MB_OK);
    return;
  }
  num=i/2;
  for( cs=0; cs=NextDataset(cs); )
  {
    if( cs == ch )
      continue;
    chOpenBorder(cs);  
    if( !(nd=chCrtNode(cs,ArGet(cvr,1),ArGet(cvr,2))) ||
        !(eg=chCrtEdge(cs,nd,nd)) )
    {
      chGetProperty(cs,CH_NAME,name);
      puts("*** cannot create cutter for "+name);
      break;
    }
    for( j=2; j<num; j+=1 )
      chIncEdge(cs,eg,j,ArGet(cvr,j*2-1),ArGet(cvr,j*2));
    cutter=ArCreate(0);
    ArAdd(cutter,eg);
    if( !chCut(cs,cutter,0,1) )
    {
      chGetProperty(cs,CH_NAME,name);
      puts("*** cannot cut "+name);
    }
    ArFree(cutter);  
    chFitBorder(cs);  
    chUpdatePresentation(cs);
  }
  ArFree(cvr);
  Redraw();
}
