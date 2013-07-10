debug off
include <system.dh>
include <windows.dh>

local say(msg)
{
  MessageBox(msg,MB_OK|MB_ICONSTOP);
}

global main()
{
  chname="NewMercatorCityPlan";
  scale=100000;
  datum="W84";
  north=0;
  west=0;
  south=0;
  east=0;
  mainlat=0;
  mainlattxt="central";
  relate=1000;
dialog:
  ArFreeAll();
  pars=ArCreate(0);
  ArAdd(pars,"Dataset name|"+chname);
  ArAdd(pars,"Scale|"+int(scale));
  ArAdd(pars,"Datum|"+datum);
  ArAdd(pars,"North|"+lat2txt(north));
  ArAdd(pars,"West|"+lon2txt(west));
  ArAdd(pars,"South|"+lat2txt(south));
  ArAdd(pars,"East|"+lon2txt(east));
  ArAdd(pars,"Main Latitude|"+mainlattxt); 
  ArAdd(pars,"Relate|"+relate);
  if( !ParamsDlg("New Mercator Paper Chart",pars) )
  {
    ArFree(pars);
    return;
  }
  chname=ArGet(pars,1);
  scale=int(ArGet(pars,2));
  datum=ArGet(pars,3);
  north=txt2coo(ArGet(pars,4));
  west=txt2coo(ArGet(pars,5));
  south=txt2coo(ArGet(pars,6));
  east=txt2coo(ArGet(pars,7));
  if( (mainlattxt=StrRTrim(StrLTrim(ArGet(pars,8)))) == "" || !StrICmp(mainlattxt,"central") )
  {
    mainlat=(north+south)*0.5;
    mainlattxt="central";
  }  
  else  
  {
    mainlat=txt2coo(mainlattxt);
    mainlattxt=lat2txt(mainlat);
  }  
  relate=real(ArGet(pars,9));
  if( scale < 1000 || scale > 1000000000 )
  {
    say("Illegal Scale value: "+ArGet(pars,2));
    goto dialog;
  }
  if( fabs(north) > 85 )
  {
    say("Illegal North value: "+ArGet(pars,4));
    goto dialog;
  }
  if( fabs(west) > 180 )
  {
    say("Illegal West value: "+ArGet(pars,5));
    goto dialog;
  }
  if( fabs(south) > 85 )
  {
    say("Illegal South value: "+ArGet(pars,6));
    goto dialog;
  }
  if( east < (-180) || east >= 360 )
  {
    say("Illegal East value: "+ArGet(pars,7));
    goto dialog;
  }
  if( fabs(mainlat) > 85 )
  {
    say("Illegal Main Latitude value: "+ArGet(pars,8));
    goto dialog;
  }
  if( north <= south )
  {
    say("Inconsistent latitudes: "+lat2txt(north)+" <= "+lat2txt(south));
    goto dialog;
  }
  if( east <= west )
  {
    if( east < 0 && west > 0 )
      east+=360;
    else
    {
      say("Inconsistent longitudes: "+lon2txt(east)+" <= "+lon2txt(west));
      goto dialog;
    }
  }
  if( relate < 1 )
  {
    say("Illegal relate: "+relate);
    goto dialog;
  }
  if( !StrICmp(StrRight(chname,3),".pc") )
    chname+=".dcf";
  else if( StrICmp(StrRight(chname,7),".pc.dcf") )
    chname+=".pc.dcf";
  for( ch=0; ch=NextDataset(ch); )
  {
    if( !chGetProperty(ch,CH_NAME,name) )
      continue;
    if( (i=StrRFind(name,"\\")) )
      name=StrMid(name,i+1);
    if( !StrICmp(chname,name) || !StrICmp(chname,name) ) 
    {
      say(name+" is already loaded"); 
      goto dialog;
    }
  }
  if( !(ch=chCrtMercatorDataset(chname,64003,scale,north,west,mainlat,datum,relate)) )
  {
    say("Cannot create dataset, probably illegal datum");
    goto dialog;
  }
  ArFree(pars);
  prev=chSetGeoUnits(1);
  chCrtNode(ch,north,west);
  chCrtNode(ch,north,east);
  chCrtNode(ch,south,east);
  chCrtNode(ch,south,west);
  chSetGeoUnits(prev);
  chFitBorder(ch);
  if( !GetEditDataset() )
    LoadToEditor(ch);
  OverviewDataset(ch);
}
