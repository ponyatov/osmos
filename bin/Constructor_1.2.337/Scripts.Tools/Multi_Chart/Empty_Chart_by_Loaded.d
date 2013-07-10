include <dkart.dh>
include <windows.dh>

local dsver 64003  //CityPlan
//local dsver 1650  //PaperChart

local say(msg)
{
  MessageBox(msg,MB_OK|MB_ICONSTOP);
}

local error(msg)
{
  ArFreeAll();
  say(msg);
  exit(0);
}

local SelectDataset()
{
  init="";
  arr=ArCreate(0);
  ch=0;
  while( (ch=NextDataset(ch)) )
  {
    dsn=0;
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
  if( i == 1 )
  {
    ch=ArGet(arr,1);
    ArFree(arr);
    return ch;
  }
  if( !(ret=ListDlg("Select dataset",StrMid(init,2))) )
    {
    ArFree(arr);
    return 0;
  }
  ch=ArGet(arr,ret);
  ArFree(arr);
  return ch;
}

global main()
{
  ArFreeAll();
  if( !(chSrc=SelectDataset()) )
    return;
  if( GetDataset("NewChart") )
  {
    puts("NewChart already exists");
    return;  
  }
  prev=chSetGeoUnits(1);
  chGetProperty(chSrc,CH_DICT1,ds);
  chGetProperty(chSrc,GEO_PROJECTION,projection);
  chGetProperty(chSrc,GEO_SCALE,scale);
  chGetProperty(chSrc,GEO_DATUM,datum);
  chGetProperty(chSrc,GEO_RELATE,relate);
  if( projection == 1 || // Mercator
      projection == 2 )  //DSCU
  { 
    chGetProperty(chSrc,GEO_NORTH,north);
    chGetProperty(chSrc,GEO_WEST,west);
    chGetProperty(chSrc,GEO_SOUTH,south);
    chGetProperty(chSrc,GEO_EAST,east);
    if( projection == 1 )
      chGetProperty(chSrc,GEO_MAINLAT,mainlat);
    else
      mainlat=0.5*(north+south);
    chDst=chCrtMercatorDataset("NewChart",dsver,scale,north,west,mainlat,datum,relate);
    if( !chDst )
    {
      puts("cannot create chart");
      return;
    }
    chCrtNode(chDst,north,west);
    chCrtNode(chDst,north,east);
    chCrtNode(chDst,south,east);
    chCrtNode(chDst,south,west);
    chFitBorder(chDst);
  }
  else if( projection == 4 || // Gauss
           projection == 5 )  // UTM
  {
    chSetGeoUnits(0);
    chGetProperty(chSrc,GEO_NORTH,miny);
    chGetProperty(chSrc,GEO_WEST,minx);
    chGetProperty(chSrc,GEO_SOUTH,maxy);
    chGetProperty(chSrc,GEO_EAST,maxx);
    chSetGeoUnits(1);
    chGetProperty(chSrc,GEO_MAINLON,olon);
    chMap2Geo(chSrc,minx,miny,nwlat,nwlon);
    chMap2Geo(chSrc,maxx,maxy,selat,selon);
    chMap2Geo(chSrc,minx,maxy,swlat,swlon);
    chMap2Geo(chSrc,maxx,miny,nelat,nelon);
    if( projection == 4 )
      chDst=chCrtGaussDataset("NewChart",dsver,scale,nwlat,nwlon,olon,6,500000,datum,relate);
    else
      chDst=chCrtUTMDataset("NewChart",dsver,scale,nwlat,nwlon,olon,6,500000,datum,relate);
    if( !chDst )
    {
      say("Cannot create dataset, probably illegal datum");
      goto dialog;
    }
    chCrtNode(chDst,nwlat,nwlon);
    chCrtNode(chDst,nelat,nelon);
    chCrtNode(chDst,selat,selon);
    chCrtNode(chDst,swlat,swlon);
  }
  else
  {
    chGetProperty(chSrc,GEO_NORTH,north);
    chGetProperty(chSrc,GEO_WEST,west);
    chGetProperty(chSrc,GEO_SOUTH,south);
    chGetProperty(chSrc,GEO_EAST,east);
    if( !(chDst=chCrtPaperChart("NewChart",chSrc)) )
    {
      puts("cannot create paper chart");
      return;
    }
    chCrtNode(chDst,north,west);
    chCrtNode(chDst,north,east);
    chCrtNode(chDst,south,east);
    chCrtNode(chDst,south,west);
  }
  chFitBorder(chDst);
  chSetGeoUnits(prev);
  if( !GetEditDataset() )
    LoadToEditor(chDst);
  OverviewDataset(chDst);
}  
