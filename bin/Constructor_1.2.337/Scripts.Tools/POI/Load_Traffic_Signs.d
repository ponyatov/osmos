include <windows.dh>
include <system.dh>

local nextToken(src,tok)
{
  if( (k=StrFind(src,"|")) <= 0 )
  {
    tok=src;
    src="";
    return 0;
  }
  tok=StrLeft(src,k-1);
  src=StrMid(src,k+1);
  return 1;
}

global main()
{
  OnError(ERR_IGNORE);
  if( IDOK != OpenFileDlg(fname,"","BKM files (*.bkm)|*.bkm|All files (*.*)|*.*||") )
    return;
  if( (k=StrRFind(fname,"\\")) > 0 )
    chname=StrMid(fname,k+1);
  else
    chname=fname;
  if( (k=StrRFind(chname,".")) > 0 )
    chname=StrLeft(chname,k-1);
  if( !(fp=fopen(fname,"r")) )
  {
    puts("*** cannot open file "+fname);
    return;
  }
  ea=no=-360;
  we=so=360;
  ln=1;  
  fgets(s,512,fp);
  while( fgets(s,512,fp) )
  {
    ln+=1;
    if( !StrLen(s) || StrLeft(s,1) == "#" )
      continue;
    ss=s;  
    if( !nextToken(ss,obcode) || !nextToken(ss,null) || !nextToken(ss,lat) )
    {
      puts("["+ln+"] cannot parse: "+s);
      break; //continue;
    }
    nextToken(ss,lon);
    lat=real(lat);
    lon=real(lon);
    if( lat == 0 || lat > 85 || lat < (-85) || lon == 0 || lon > 180 || lon < (-180) )
    {
      puts("["+ln+"] suspicious coordinate: "+s);
      continue;
    }
    if( no < lat )
      no=lat;
    if( so > lat )
      so=lat;
    if( we > lon )
      we=lon;
    if( ea < lon )
      ea=lon;      
  }  
  
  fclose(fp);
  
  if( !(ver=dsLoad(GetStartPath()+"city_plan")) )
  {
    puts("*** cannot load dictionary city_plan.dic");
    return;
  }
  
  chSetGeoUnits(1);  
  
  if( !(ch=chCrtMercatorDataset(chname+".dcf",ver,10000,no,we,int((no+so)/2),"W84",1000)) )
  {
    puts("*** cannot create chart "+chname+".dcf");
    return;
  }  
  
  StartIndicator("Loading...",ln);
  if( !(fp=fopen(fname,"r")) )
  {
    puts("*** cannot open file "+fname);
    return;
  }
  
  /*
  fe=chCrtFeature(ch,60870);                              // chdesc
  chSetAttrText(ch,fe,60010,chname+" Traffic signs");     // obname
  chSetAttrText(ch,fe,60020,chname+" Дорожные знаки");    // nobnam
  chSetAttrText(ch,fe,61140,"1");                         // chvers
  chSetAttrText(ch,fe,61150,"0");                         // subver
  chSetAttrText(ch,fe,61070,"db");                        // copyrt
  chSetAttrText(ch,fe,61069,"3");                         // codepg
  */
  
  ln=1;  
  fgets(s,512,fp);
  StepIndicator();
  while( fgets(s,512,fp) )
  {
    ln+=1;
    StepIndicator();
    if( !StrLen(s) || StrLeft(s,1) == "#" )
      continue;
    ss=StrRTrim(s);  
    if( !nextToken(ss,obcode) || !nextToken(ss,label) || !nextToken(ss,lat) )
    {
      puts("["+ln+"] cannot parse: "+s);
      continue;
    }
    nextToken(ss,lon);
    lat=real(lat);
    lon=real(lon);
    if( lat == 0 || lat > 85 || lat < (-85) || lon == 0 || lon > 180 || lon < (-180) )
      continue;
      
    if( !(fe=chCrtFeature(ch,int(obcode))) )
    {
      puts("["+ln+"] cannot create sign: "+s);
      continue;
    }
    if( !(nd=chCrtNode(ch,lat,lon)) )
    {
      puts("["+ln+"] cannot set node: "+s);
      continue;
    }
    chSetFeatureNode(ch,fe,nd);
    chSetAttrText(ch,fe,1703,"26");       // scalvl
    chSetAttrText(ch,fe,1653,"906");      // priort
    chSetAttrText(ch,fe,148,""+ln);       // sorind
    chSetAttrText(ch,fe,17501,label);     // labels
    
    while( ss )
    {
      if( !nextToken(ss,atcode) )
      {
        puts("["+ln+"] cannot parse: "+s);
        break;
      }
      nextToken(ss,atval);
      chSetAttrText(ch,fe,int(atcode),atval);
    }
  }  
  fclose(fp);  
  chFitBorder(ch);
  Load2Editor(ch);
  OverviewDataset(ch);
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
}
