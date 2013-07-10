debug off
include <system.dh>
include <windows.dh>
include <LookUp2DInc.dh>

const M_PI2 6.2831853071795864
const deg20 0.6981317007977318

const red 0xFF
const magenta 0xFF00FF
const green 0xFF00
const blue 0xFF0000
const yellow 0xFFFF
const black 0
const white 0xFFFFFF
const trafsignblue 0xFF2020

const AT_ONEWAY 1704

//const strcntr2 "#rffff00"
//const strcntr3 "#rffffff"
const street10 "#rffd700 w180"
const street12 "##rffd700 w180 *#rffff00"
const street13 "##rffd700 w180 *#rffffff"
const street20 "#rffd700 w150"
const street22 "##rffd700 w150 *#rffff00"
const street23 "##rffd700 w150 *#rffffff"
const street30 "#rffd700 w120"
const street32 "##rffd700 w120 *#rffff00"
const street33 "##rffd700 w120 *#rffffff"
const street40 "#rffd700 w90"
const street42 "##rffd700 w90 *#rffff00"
const street43 "##rffd700 w90 *#rffffff"
const strminor "#rffd700 w60"
const strkad "##rffd700 w180 *#rffffff#r808080 y90#r808080 y-90"
//const oneway_f "#fS52-5:12 r00ff00 z1.5 y200 dx500 s108"
//const oneway_b "#fS52-5:12 r00ff00 z1.5 y-200 dx500 s109"

local drawEdge(ch,eg)
{
  sz=chGetEdgeXY(ch,eg,0,x,y);
  Map2Win(x,y,x,y);
  MoveTo(x,y);
  for( i=1; i<sz; i+=1 )
  {
    sz=chGetEdgeXY(ch,eg,i,x,y);
    Map2Win(x,y,x,y);
    LineTo(x,y);
  }
}

local drawSelLine(ch,fe,rgb)
{
  prpen=SelectObject(CreatePen(PS_SOLID,3,rgb));
  sz=chGetFeatureLine(ch,fe,1,eg,flag);
  drawEdge(ch,eg);
  for( i=2; i<=sz; i+=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    drawEdge(ch,eg);
  }
  DeleteObject(SelectObject(prpen));
}

local drawNoTurn(orient,x,y,s1,s2,s3,rgb)
{
  if( !(fnt=CreateFont(-24,0,orient,orient,
      FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,
      CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"S52-6")) )
    return;
  SetTextAlign(TA_LEFT|TA_BASELINE);
  SetBkMode(TRANSPARENT);
  prfnt=SelectObject(fnt);
  SetTextColor(yellow);
  SymbolOut(x,y,s3);
  if( rgb >= 0 )
  {
    SetTextColor(rgb);
    SymbolOut(x,y,s1);
  }
  else
  {
    SetTextColor(black);
    SymbolOut(x,y,s1);
    SetTextColor(red);
  }
  SymbolOut(x,y,s2);
  DeleteObject(SelectObject(prfnt));
}

global noturn(ch,fe,rgb)
{
  num=chGetFeatureLine(ch,fe,0,eg,flag);
  if( num != 2 )
    drawSelLine(ch,fe,magenta);
  if( rgb >= 0 )
    drawSelLine(ch,fe,rgb);
  for( i=1; i<num; i+=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    sz=chGetEdgeXY(ch,eg,0,x2,y2);
    if( flag & M_REVERSE )
      chGetEdgeXY(ch,eg,1,x1,y1);
    else
    {
      chGetEdgeXY(ch,eg,sz-1,x2,y2);
      chGetEdgeXY(ch,eg,sz-2,x1,y1);
    }
    chGetFeatureLine(ch,fe,i+1,eg,flag);
    sz=chGetEdgeXY(ch,eg,1,x3,y3);
    if( flag & M_REVERSE )
    {
      chGetEdgeXY(ch,eg,sz-2,x3,y3);
      chGetEdgeXY(ch,eg,sz-1,x22,y22);
    }
    else
      chGetEdgeXY(ch,eg,0,x22,y22);
    if( x22 != x2 || y22 != y2 )
      continue;
    a1=atan2(y2-y1,x2-x1);
    a2=atan2(y3-y2,x3-x2);
    if( a2 > M_PI )
      da1=a2-M_PI2;
    else
      da1=a2;
    if( a1 > M_PI )
      da2=a1-M_PI2;
    else
      da2=a1;
    da=da1-da2;
    if( da > M_PI )
      da-=M_PI2;
    else if( da < (-M_PI) )
      da+=M_PI2;
    Map2Win(x1,y1,x1,y1);
    Map2Win(x2,y2,x2,y2);
    if( y1 == y2 && x2 == x1 )
      a=0;
    else
      a=atan2(y2-y1,x1-x2);
    orient=int(rad2deg(a)*10);
    x=int(x2);
    y=int(y2);
    if( da > deg20 )
      drawNoTurn(orient,x,y,108,109,110,rgb);
    else if( da < (-deg20) )
      drawNoTurn(orient,x,y,111,112,113,rgb);
    else if( da >= 0 )
      drawNoTurn(orient,x,y,114,109,110,rgb);
    else //if( da < 0 )
      drawNoTurn(orient,x,y,115,112,113,rgb);
  }
  return 0;
}

local drawOneWay(orient,x1,y1,x2,y2,rgb)
{
  Map2Win(x1,y1,x1,y1);
  Map2Win(x2,y2,x2,y2);
  if( y1 == y2 && x2 == x1 )
    a=0;
  else
    a=atan2(y2-y1,x1-x2);
  if( (orient=int(rad2deg(a)*10)) > 3600 )
    orient-=3600;
  x=int(x2);
  y=int(y2);
  if( !(fnt=CreateFont(-24,0,orient,orient,
      FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,
      CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"S52-6")) )
    return;
  SetTextAlign(TA_LEFT|TA_BASELINE);
  SetBkMode(TRANSPARENT);
  prfnt=SelectObject(fnt);
  if( rgb < 0 )
    SetTextColor(blue);
  else
    SetTextColor(rgb);
  SymbolOut(x,y,120);
  SetTextColor(white);
  SymbolOut(x,y,121);
  DeleteObject(SelectObject(prfnt));
}

local tooShort(val)
{
  if( val < 0 )
  {
    if( val > (-30) )
      return 1;
  }
  else if( val < 30 )
    return 1;
  return 0;  
}

local drawOneWay2(orient,_x1,_y1,_x2,_y2,rgb)
{
  Map2Win(_x1,_y1,x1,y1);
  Map2Win(_x2,_y2,x2,y2);
  //puts(""+x1+"-"+y1+"  "+x2+"-"+y2);
  if( tooShort(x2-x1) && tooShort(y2-y1) )
    return;
  a=atan2(y2-y1,x1-x2);
  if( (orient=int(rad2deg(a)*10)) > 3600 )
    orient-=3600;
  x=int((x1+x2)/2);
  y=int((y1+y2)/2);
  SetBkMode(TRANSPARENT);
  SetTextAlign(TA_RIGHT|TA_BASELINE);
  if( !(fnt=CreateFont(-14,0,orient,orient,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"S52-6")) )
//  SetTextAlign(TA_CENTER|TA_BASELINE);
//  if( !(fnt=CreateFont(-56,0,orient,orient,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"S52-5")) )
    return;
  prfnt=SelectObject(fnt);
  if( rgb < 0 )
    SetTextColor(blue);
  else
    SetTextColor(rgb);
  SymbolOut(x,y,120);
  SetTextColor(white);
  SymbolOut(x,y,121);
  //SetTextColor(0x00FF00);
  //SymbolOut(x,y,108);
  DeleteObject(SelectObject(prfnt));
}

local draw_oneway_frwd(ch,fe,rgb)
{
  num=chGetFeatureLine(ch,fe,0,eg,flag);
  for( i=1; i<=num; i+=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    if( flag & M_REVERSE )
    {
      n=chGetEdgeXY(ch,eg,0,x1,y1);
      for( chGetEdgeXY(ch,eg,n-=1,x1,y1); n>0; )
      {
        chGetEdgeXY(ch,eg,n-=1,x2,y2);
        drawOneWay2(orient,x2,y2,x1,y1,rgb);
        x1=x2;
        y1=y2;
      } 
    }
    else
    {
      n=chGetEdgeXY(ch,eg,0,x1,y1);
      for( j=1; j<n; j+=1 )
      {
        chGetEdgeXY(ch,eg,j,x2,y2);
        drawOneWay2(orient,x2,y2,x1,y1,rgb);
        x1=x2;
        y1=y2;
      }
    }
  }
}

local draw_oneway_bkwd(ch,fe,rgb)
{
  num=chGetFeatureLine(ch,fe,0,eg,flag);
  for( i=1; i<=num; i+=1 )
  {
    chGetFeatureLine(ch,fe,i,eg,flag);
    if( flag & M_REVERSE )
    {
      n=chGetEdgeXY(ch,eg,0,x1,y1);
      for( chGetEdgeXY(ch,eg,n-=1,x1,y1); n>0; )
      {
        chGetEdgeXY(ch,eg,n-=1,x2,y2);
        drawOneWay2(orient,x1,y1,x2,y2,rgb);
        x1=x2;
        y1=y2;
      } 
    }
    else
    {
      n=chGetEdgeXY(ch,eg,0,x1,y1);
      for( j=1; j<n; j+=1 )
      {
        chGetEdgeXY(ch,eg,j,x2,y2);
        drawOneWay2(orient,x1,y1,x2,y2,rgb);
        x1=x2;
        y1=y2;
      }
    }
  }
}
  
global oneway(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,AT_LAYERS,layer) || layer < 2 )
    return 1;
  if( layer == 2 )
    draw_oneway_frwd(ch,fe,rgb);
  else if( layer == 3 )
    draw_oneway_bkwd(ch,fe,rgb);
  return 1;
}

global street(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,AT_PATOFF,patoff) ||
      !chGetAttrValue(ch,fe,AT_LAYERS,layer) )
    return 0;
  if( patoff == 10 )
    s=street10;
  else if( patoff == 12 )
    s=street12;
  else if( patoff == 13 )
    s=street13;
  else if( patoff == 20 )
    s=street20;
  else if( patoff == 22 )
    s=street22;
  else if( patoff == 23 )
    s=street23;
  else if( patoff == 30 )
    s=street30;
  else if( patoff == 32 )
    s=street32;
  else if( patoff == 33 )
    s=street33;
  else if( patoff == 40 )
    s=street40;
  else if( patoff == 42 )
    s=street42;
  else if( patoff == 43 )
    s=street43;
  else if( patoff == 14 )
    s=strkad;
  else
    s=strminor;
  if( chGetAttrValue(ch,fe,SORIND,sorind) && sorind == "мост" )
  {
    if( layer == 2 )
      return "#"+s+"#fS52-5:12 rffd700 z1.5 y200 dx500 s108#r0000ff y-110#r0000ff y110";
    if( layer == 3 )
      return "#"+s+"#fS52-5:12 rffd700 z1.5 y-200 dx500 s109#r0000ff y-110#r0000ff y110";
    s="#"+s+"#r0000ff y110#r0000ff y-110";
  }
  else if( layer == 2 )
    return "#"+s+"#fS52-5:12 rffd700 z1.5 y200 dx500 s108";
  if( layer == 3 )
    return "#"+s+"#fS52-5:12 rffd700 z1.5 y-200 dx500 s109";
  return s;
}

global ADMDST_area(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,60910,catdst) )
    return 0; //  здесь было значение 1
  if( catdst == 12 ) // "Reservations" 
    return "#rB5C4B5";
  if( catdst == 15 ) // "0x0001"  Large urban area
    return "#rF4EFEC";
  if( catdst == 16 ) // "0x0002" Small urban area
    return "#rF4EFEC";
  if( catdst == 18 ) // "0x0003"  Rural housing area
    return "#rE2DED7";
//puts("["+fe+"] "+materl);    
  return 1;  
}

global BLOCKS_area(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,60710,catblk) )
    return 0;
  if( catblk == 1 ) // Residential area // OBNAME="Res"
    return "#rF5F5F5";
  if( catblk == 2 ) // University/College "Central quarters of city"
    return "#rF8D6AF";	
  if( catblk == 3 ) // Shopping center "Compact planning"
    return "#rD7C9FC"; 
  if( catblk == 5 ) // Quarters in a green zone // OBNAME="Dachi"
    return "#rE5E4E5";  
  if( catblk == 6 ) // Industrial territory // OBNAME="Ind"
    return "#rDDDDDD";  
  if( catblk == 7 ) // Departmental frontage //OBNAME="Adm" 
    return "#rD5CBB0";
  if( catblk == 9 ) //  Sports complex   //Grass vegetation
    return "#rECE2A8";
  if( catblk == 10 ) // Parking lot // "Waste ground"
    return "#rF1E9BD";
  if( catblk == 11 ) // Hospital // "Unknown"
    return "#rF7D2CA";
  return 0;    
}

global BUILDS_area(ch,fe,rgb)
{
  if( !chGetAttrText(ch,fe,60190,bldfnc) )
    return 1;
  if( bldfnc == "1" ) // Inhabited building  0x0013
    return "#rBFBDBE"; //"#rD3DAED";
  if( bldfnc == "3" ) // Industrial 
    return "#r8C8788";
  if( bldfnc == "4" ) // Office build 
    return "#r80ACAC";
 if( bldfnc == "10" ) // Common build 0x6e
    return "#rA8978D";
  if( bldfnc == "21" ) // Garage 
    return "#rDDCDB1";
  if( bldfnc == "50" ) // Sport 
    return "#rCDC6A7";
  return 1;  
}

global CEMTRY_area(ch,fe,rgb)
{
  if( !chGetAttrText(ch,fe,60020,nobnam) )
    return 1;
  if( nobnam == "2" ) // Mosque
    return "##rBDD7AD *#fS52-2:12 r575757 dx500 dy500 s46";
  if( nobnam == "1" ) // Christ
    return "##rbed6ad#fCityPlan01:12 r5c5c5c z0.3 dx800 dy800 s90";
  return 1;  
}

global LTBLDS_area(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,60250,catlbl) )
    return 0;
  if( catlbl == 32 ) // Garage  
    return "#rD3D3D3";  
  return 0;
}    

global SURFCE_area(ch,fe,rgb)
{
  if( !chGetAttrText(ch,fe,60225,natsur) )
    return 0;
  if( natsur == "4" ) // sand  
    return "##rFFF7E7 *#fS52-1:2 rD6CBB5 dx250 dy250 s61";
  if( natsur == "5" ) // stone  
    return "#rE2EFD8";
  if( natsur == "14" ) // ice  
    return "#rCEF0FC";
  if( natsur == "15" ) // sand/mud   
    return "##rB8DEFE *#fS52-2:3 r7D3F00 dx150 dy150 s61";
  return 0;  
}

global VEGCLT_area(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,60760,catclv) )
    return 1;
  if( catclv == 1 || catclv == 2 ) // garden fruit || vineyard
    return "##rB5CAA3 *#fS52-4:4 rffffff dx300 dy300 s61";  
  if( catclv == 3 ) //National park
    return "#rB5CAA3"; 
  if( catclv == 4 ) //City park
    return "#rB5CAA3";  
  return 1;
}    

global VEGTRS_area(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,60770,cattrv) )
    return 1;
  if( cattrv == 7 ) // disafforestation
    return "##rffffff *#fS52-3:12 r000000 dx400 dy400 s85";  
  return 1;
}    

global BLDBND_line(ch,fe,rgb)
{
  if( !chGetAttrText(ch,fe,60190,bldfnc) )
    return 1;
  if( bldfnc == "1" ) // Inhabited building 
    return "#r8B898A";
  if( bldfnc == "3" ) // Industrial 
    return "#r777576";
  if( bldfnc == "4" ) // Office 
    return "#r639696";
  if( bldfnc == "10" ) // Common
    return "#r7D6F54";
  if( bldfnc == "21" ) // Garage 
    return "#rC4AA7A";
  if( bldfnc == "50" ) // Sport 
    return "#rB49456";
  if( bldfnc == "9" ) // Sport 
    return "#rCAB52E"; //#r52726A"
  return 1;  
}

local StreetByROACLS(roacls,res)
{
  if( roacls == 1 )               // "Городская магистраль"          
    res="##r7F7F7F w160#rFFFC8E w100"; //res="##r7F7F7F w160#rFFFB73 w100"; 11.11.11 Vera
  else if( roacls == 2 )          // "Проспект" 
    res="##r7F7F7F w160#rEEEEEE w100";//res="##r7F7F7F w160#rFFFBFF w100"; 11.11.2011 Vera
  else if( roacls == 3 )          // "Улица" 
    res="##r7F7F7F w140#rEEEEEE w80";
  else if( roacls == 4 )          // "Проезд" 
    res="##r7F7F7F w140#rEEEEEE w80"; //res="##r7F7F7F w140#rFFFBFF w80";11.11.11 Vera
  else if( roacls == 5 )          // "Внутридворовый проезд"         
    res="##r678B89 w40"; //res="##r7F7F7F w90#rC1D1E3 w60"; 11.11.11 Vera стали без обводки
  else if( roacls == 6 )          // "Велосипедная дорожка" 
    res="##r7F7F7F w130#rDEDBDE w70";
  else if( roacls == 7 )          // "Пешеходная дорожка" 
    res="##r7F7F7F w100#r7BAE2A w60";
  else if( roacls == 8 )          // "Аллея" 
    res="##r7F7F7F w110#rDEDBDE w50";
  else if( roacls == 9 )          // "Загородная магистраль" 
    res="##r7F7F7F w190#rEABC6D w130"; //res="##r7F7F7F w190#rF7A652 w130"; 11.11.11 Vera
  else if( roacls == 10 )         // "Загородное шоссе"              
    res="##r7F7F7F w180#rFFFC8E w120"; //res="##r7F7F7F w180#rFFFB73 w120"; 11.11.11 Vera
  else if( roacls == 11 )         // "Загородная дорога" 
    res="##r7F7F7F w170#rEEEEEE w110"; //res="##r7F7F7F w170#rFFFBFF w110"; 11.11.11 Vera
  else if( roacls == 12 )         // "Загородная второстепенная дорога" 0x0003
    res="##rBD9E5A w100#rF7EFD6 w65"; // res="##rBD9E5A w160#rF7EFD6 w100";
  else if( roacls == 13 )         // "Лесная/полевая дорога" 
    res="##rBD9E5A w110#rF7EFD6 w50";
  else if( roacls == 14 )         // "Тропа" 
    res="##rBD9E5A w110#rF7EFD6 w50";
  else if( roacls == 15 )         // "Строящаяся дорога" 
    res="#r92A2AB w100 p300:200";
  else if( roacls == 16 )         // "Автомагистраль" 
    res="##r7F7F7F w200#rF7A652 w130#r7F7F7F";
  else
    return 0;
  return 1; 
}

local StreetByNOBJNM(nobjnm)
{
  if( nobjnm == 10 ) //
    return "##r7f7f7f w160#rFCFA74 w120"; // oneway: "##r7f7f7f w100#rF5A555 w70"; 
  if( nobjnm == 13 ) //
    return "##r7f7f7f w220#rF5A555 w180#rffffe0";  
  if( nobjnm == 777 ) //
    return "##rF5A555 w100#r7f7f7f";  // w80#rffffe0
  if( nobjnm == 15 ) // x0049 Транзитные дороги через город
    return "##r7f7f7f w280#rF5A555 w240#rffffe0"; 
  if( nobjnm == 20 )        // главная улица 
    return "##r787878 w140#rffffe0 w100";  
  if( nobjnm == 30 )        // простая улица
    return "##r787878 w140#rffffe0 w100";  
  if( nobjnm == 32 )        // 22?
    return "##rE9BE93 w120 *#r993333 w20 y60 #r993333 w20 y-60";  
  if( nobjnm == 35 )        //
    return "##r787878 w90#rd9d9d9 w60";  
  if( nobjnm == 40 )        // мелкая улица
    return "##rB99C58 w100#rF0ECD3 w60"; //"##rB99C58 w150 #rF0ECD3w190" ;  //"##r787878 w80#rffffe0 w60"
  //if( nobjnm == 43 ) // --
  //  return 0;//"##r7f7f7f w80#rffffe0 w60";  
  if( nobjnm == 50 )        // грунтовая улучшенная
    return "##rB99C58 w100#rF0ECD3 w60"; //"##rF0ECD3 w100#rB99C58 w10 y35 p500:200 n16#rB99C58 w10 y-35 p500:200 n16";
	//return "##r787878 w110#rF0ECD3 w70";  
  if( nobjnm == 60 )        // грунтовая
    return "##r787878 w100#rF0ECD3 w60";  
  if( nobjnm == 17 ) // 70?
    return "##r787878 w100#rd9d9d9 w70";  
  if( nobjnm == 77 ) // съезд
    return "##r787878 w140#rffffe0 w100";  
  if( nobjnm == 80 )        // пешеходная дорога
    return "##rd9d9d9 w100 *#r0 w10 y50 p30:180 n16#r0 w10 y-50 p30:180 n16";  
  //if( nobjnm == 90 ) // ferry
  //  return "#r1e90ff w20 p300:100";  
  
  if( nobjnm == 14 )        // КАД
    return "##r787878 w180#rF5A555 w140#rffffe0";  
  if( nobjnm == 114 )       // КАД
    return "##r787878 w240#rF5A555 w200#rffffe0";  
  if( nobjnm == 9 )         // КАД строится
    return "#rB2BEB2 w140 p300:200";  
  if( nobjnm == 109 )       // КАД строится
    return "#rB2BEB2 w140 p300:200";  
  if( nobjnm == 220 )       // главная улица 
    return "##r787878 w180#rffffe0 w140";  
  if( nobjnm == 120 )       // главная улица 
    return "##r787878 w220#rffffe0 w180";  
  if( nobjnm == 2120 )      // главная улица 
    return "##r787878 w240#rF5A555 w200";  
  if( nobjnm == 21 )        // мост на главной улице
    return "##r669933 w240#rffffe0 w200";  
  if( nobjnm == 121 )       // мост на главной улице
    return "##r669933 w240#rffffe0 w200";  
  if( nobjnm == 2121 )      // мост на главной улице
    return "##r669933 w260#rF5A555 w220";  
  if( nobjnm == 23 )        // шоссе с разделительной
    return "##r787878 w240#rffffe0 w200#r787878";  
  if( nobjnm == 123 )       // шоссе с разделительной
    return "##r787878 w240#rffffe0 w200#r787878";  
  if( nobjnm == 223 )       // шоссе с разделительной
    return "##r787878 w260#rffffe0 w220#r787878";  
  if( nobjnm == 2123 )      // шоссе с разделительной
    return "##r787878 w260#rF5A555 w220#r787878";  
  if( nobjnm == 73 )        // мост на шоссе
    return "##r787878 w240#rffffe0 w200";  
  if( nobjnm == 173 )       // мост на шоссе
    return "##r787878 w240#rffffe0 w200";  
  if( nobjnm == 2173 )      // мост на шоссе
    return "##r787878 w260#rF5A555 w220";  
  if( nobjnm == 273 )       // мост на шоссе
    return "##r787878 w260#rF5A555 w220";  
  if( nobjnm == 24 )        // тоннель на главной улице
    return "##rd9d9d9 w180#r808080 w20 y90 p600:180 n16#r808080 w20 y-90 p600:180 n16";  
  if( nobjnm == 124 )       // тоннель на главной улице
    return "##rd9d9d9 w180#r808080 w20 y90 p600:180 n16#r808080 w20 y-90 p600:180 n16";  
  if( nobjnm == 230 )       // простая улица
    return "##r787878 w210#rF5A555 w170";  
  if( nobjnm == 130 )       // простая улица
    return "##r787878 w190#rffffe0 w150";  
  if( nobjnm == 2130 )      // простая улица
    return "##r787878 w210#rF5A555 w170";  
  if( nobjnm == 230 )       // простая улица
    return "##r787878 w210#rF5A555 w170";  
  if( nobjnm == 31 )        // мост на простой улице
    return "##r669933 w200#rffffe0 w160";  
  if( nobjnm == 131 )       // мост на простой улице
    return "##r669933 w200#rffffe0 w160";  
  if( nobjnm == 2131 )      // мост на простой улице
    return "##r669933 w200#rF5A555 w160";  
  if( nobjnm == 74 )        // мост на простой улице
    return "##r787878 w210#rffffe0 w170";  
  if( nobjnm == 274 )       // мост на простой улице
    return "##r787878 w210#rF5A555 w170";  
  if( nobjnm == 2174 )      // мост на простой улице
    return "##r787878 w210#rF5A555 w170";  
  if( nobjnm == 140 )       // мелкая улица
    return "##r787878 w130#rffffe0 w90";  
  if( nobjnm == 240 )       // мелкая улица
    return "##r787878 w130#rF5A555 w90";  
  if( nobjnm == 2140 )      // мелкая улица
    return "##r787878 w130#rF5A555 w90";  
  if( nobjnm == 42 )        // мелкая улица (с разделительной?)
    return "##r787878 w160#rffffe0 w120";  
  if( nobjnm == 142 )       // мелкая улица (с разделительной?)
    return "##r787878 w160#rffffe0 w120";  
  if( nobjnm == 242 )       // мелкая улица (с разделительной?)
    return "##r787878 w160#rF5A555 w120";  
  if( nobjnm == 2142 )      // мелкая улица (с разделительной?)
    return "##r787878 w160#rF5A555 w120";  
  if( nobjnm == 43 )        // улица строится
    return "#rb2beb2 w120 p300:200";  
  if( nobjnm == 143 )       // улица строится
    return "#rb2beb2 w120 p300:200";  
  if( nobjnm == 70 )        // карман
    return "##r787878 w130#rd9d9d9 w90";  
  if( nobjnm == 170 )       // карман
    return "##r787878 w130#rd9d9d9 w90";  
  if( nobjnm == 72 )        // разворот
    return "##r787878 w130#rf0ecd3 w90";  
  if( nobjnm == 172 )       // разворот
    return "##r787878 w130#rf0ecd3 w90";  
  if( nobjnm == 177 )       // съезд
    return "##r787878 w190#rffffe0 w150";  
  if( nobjnm == 2177 )      // съезд
    return "##r787878 w190#rF5A555 w150";  
  if( nobjnm == 277 )       // съезд
    return "##r787878 w190#rF5A555 w150";  
  if( nobjnm == 81 )        // пешеходный мост
    return "##rd9d9d9 w150#r0 w10 y75 p30:180 n16#r0 w10 y-75 p30:180 n16";  
  if( nobjnm == 95 )        // круг
    return "##r787878 w190#rffffe0 w150";  
  if( nobjnm == 195 )       // круг
    return "##r787878 w190#rffffe0 w150";  
  if( nobjnm == 2195 )      // круг
    return "##r787878 w190#rF5A555 w150";  
  return 1;  
}

global STREET_line(ch,fe,rgb)
{
  if( chGetAttrValue(ch,fe,17508,roacls) && StreetByROACLS(roacls,res) )
    return res;
  if( !chGetAttrText(ch,fe,301,nobjnm) )
    return 1;
  return StreetByNOBJNM(int(nobjnm));
}

global STREET_oneway(ch,fe,rgb)
{
  if( GetCurScale() > 25000 )
    return;
  if( !chGetAttrValue(ch,fe,AT_ONEWAY,oneway) )
    return;
  if( oneway == 1 )
    draw_oneway_frwd(ch,fe,rgb);
  else // if( oneway == 2 )
    draw_oneway_bkwd(ch,fe,rgb);
}

global BUILDS_pnt(ch,fe,rgb)
{
  if( !chGetAttrText(ch,fe,60190,bldfnc) )
  {
    if( !chGetAttrText(ch,fe,61068,poicat) )
      return 0;
    if( poicat == "amuspark" || poicat == "bowling" || poicat == "entertainment" )
      return "#fCityPlan01:12 s50 r8A5C8A z0.9"; 
    if( poicat == "atelier" || poicat == "beauty" || poicat == "laundry" || poicat == "photo" || 
        poicat == "repair" || poicat == "repaircomputer" || poicat == "repairdevice" || poicat == "repairfurniture" ||
        poicat == "repairshoes" || poicat == "service" || poicat == "tradefirm" || poicat == "xerox" )
      return "#fCityPlan01:12 s61 rDDA0DD z0.9";
    if( poicat == "ATM" || poicat == "bank" )
      return "#fCityPlan01:12 s117 r009240 z0.9"; 
    if( poicat == "autoclub" )
      return "#fCityPlan01:12 s108 rA0522D z0.9"; 
    if( poicat == "bar" || poicat == "casino" || poicat == "wine" )
      return "#fCityPlan01:12 s98 r4682B4 z0.9"; 
    if( poicat == "business" || poicat == "firm" || poicat == "insurance" ||
        poicat == "lawoffice" || poicat == "notary" || poicat == "realestate" || poicat == "travelagency" )
      return "#fCityPlan01:12 s118 r7F7F7F z0.9";
   if( poicat == "camping" )
      return "#fCityPlan01:12 s120 r8A8A8A z0.9"; 
    if( poicat == "carwash" )
      return "#fCityPlan01:12 s106 r8A8A8A z0.9"; 
    if( poicat == "circus" )
      return "#fCityPlan01:12 s52 r483D8B z0.9"; 
    if( poicat == "communication" )
      return "#fCityPlan01:12 s104 r7DA8FF z0.9"; 
    if( poicat == "court" )
      return "#fCityPlan01:12 s58 r8C8C27 z0.7"; 
    if( poicat == "custom" )
      return "#fCityPlan01:12 s100 r5C5C5C z0.9"; 
    if( poicat == "inetcafe" || poicat == "wifi" )
      return "#fCityPlan01:12 s121 r009240 z0.9"; 
    if( poicat == "information" )
      return "#fCityPlan01:12 s74 r6495ED z0.9"; 
    if( poicat == "kindergarden" ) 
      return "#fCityPlan01:12 s78 rFF7800 z0.9"; 
    if( poicat == "publisher" )
      return "#fCityPlan01:12 s67 rD889A7 z0.7";
    if( poicat == "repairboat" )
      return "#fCityPlan01:12 s79 r1E90FF z0.9";
    if( poicat == "sauna" || poicat == "shower" )
      return "#fCityPlan01:12 s39 r00BFFF z0.7";
    if( poicat == "ticket" )
      return "#fCityPlan01:12 s74 r7DA8FF z0.9";
    if( poicat == "utility" )
      return "#fCityPlan01:12 s57 r8B008B z0.9";
    if( poicat == "zoo" ) 
      return "#fCityPlan01:12 s52 rADA136 z0.9"; 
    return 0;
  }
  if( bldfnc == "2" ) // Airport 
    return "#fCityPlan01:12 s76 r7DA8FF z0.9";
  if( bldfnc == "4" ) // Building of public and state organizations 
    return "#fCityPlan01:12 s118 r7F7F7F z0.9";
  if( bldfnc == "5" ) // Bus station 
    return "#fCityPlan01:12 s63 r797AFF z0.9";
  if( bldfnc == "6" ) // Cafe 
    return "#fCityPlan01:12 s115 r4682B4 z0.9";
/*  if( bldfnc == "7" ) // Camping 
  {
    if( chGetAttrText(ch,fe,61068,poicat) && poicat == "camping" )
      return "#fCityPlan01:12 s118 r7F7F7F z0.9";
    return "#fCityPlan01:12 s120 r2E8B57 z0.9";
  }  */
  if( bldfnc == "8" ) // Church 
    return "#fCityPlan01:12 s53 rFF8686 z0.9";
  if( bldfnc == "9" ) // Cinema 
    return "#fCityPlan01:12 s71 rA52A2A z0.9";
  if( bldfnc == "12" ) // College 
    return "#fCityPlan01:12 s72 r2EB82E z0.9";
  if( bldfnc == "13" ) // Concert hall 
    return "#fCityPlan01:12 s52 r483D8B z0.9"; 
  if( bldfnc == "15" ) // Department store 
    return "#fCityPlan01:12 s122 rA0522D z0.9";
  if( bldfnc == "18" ) // Exhibition hall 
    return "#fCityPlan01:12 s52 rADA136 z0.9"; 
  if( bldfnc == "19" ) // Factory 
    return 0; // !!! Prochee
  if( bldfnc == "20" ) // Filling station 
    return "#fCityPlan01:12 s55 r8B008B z0.9";
  if( bldfnc == "21" ) // Garage 
    return "#fCityPlan01:12 s118 rE4CD65 z0.9";
  if( bldfnc == "24" ) // Hospital 
    return "#fCityPlan01:12 s59 rF55200 z0.9";
  if( bldfnc == "25" ) // Hotel 
    return "#fCityPlan01:12 s69 r7E007E z0.9";
  if( bldfnc == "31" ) // Library 
    return "#fCityPlan01:12 s67 rD2691E z0.9";
  if( bldfnc == "32" ) // Market 
    return "#fCityPlan01:12 s97 rA0522D z0.9";
  if( bldfnc == "33" ) // Municipality 
    return "#fCityPlan01:12 s57 r8B008B z0.9";
  if( bldfnc == "34" ) // Museum 
    return "#fCityPlan01:12 s52 rADA136 z0.9"; 
  if( bldfnc == "38" ) // Police 
  {
    if( chGetAttrText(ch,fe,61068,poicat) && poicat == "trafficpolice" )
      return "#fCityPlan01:12 s110 r4000FF z0.9";
    return "#fCityPlan01:12 s65 r4000FF z0.9";
  }
  if( bldfnc == "39" ) // Pharmacy/Polyclinic 
    return "#fCityPlan01:12 s60 r009240 z0.9";
  if( bldfnc == "40" ) // Pool 
    return "#fCityPlan01:12 s51 r00008B z0.9";
  if( bldfnc == "41" ) // Port, quay 
    return "#fCityPlan01:12 s79 r1E90FF z0.9";
  if( bldfnc == "42" ) // Post office 
    return "#fCityPlan01:12 s56 r9A65CC z0.9";
  if( bldfnc == "43" ) // Restaurant 
    return "#fCityPlan01:12 s113 r4682B4 z0.9";
  if( bldfnc == "45" ) // School 
    return "#fCityPlan01:12 s72 r2EB82E z0.9";
  if( bldfnc == "48" ) // Shop 
    return "#fCityPlan01:12 s122 rA0522D z0.9";
  if( bldfnc == "49" ) // Social aid organisation 
    return "#fCityPlan01:12 s57 r8B008B z0.9";
  if( bldfnc == "50" ) // Sport building, construction 
    return "#fCityPlan01:12 s51 r009240 z0.9";
  if( bldfnc == "51" ) // Stadium 
    return "#fCityPlan01:12 s51 r009240 z0.9";
  if( bldfnc == "55" ) // Supermarket 
    return "#fCityPlan01:12 s97 rA0522D z0.9";
  if( bldfnc == "57" ) // Theatre 
    return "#fCityPlan01:12 s70 r994779 z0.9";
  if( bldfnc == "59" ) // University 
    return "#fCityPlan01:12 s73 r0099D4 z0.9";
  if( bldfnc == "61" ) // Yacht-club 
    return "#fCityPlan01:12 s79 r1E90FF z0.9";
  if( bldfnc == "65" ) // Railway station 
    return "#fCityPlan01:12 s77 r858585 z0.9";
  if( bldfnc == "68" ) // Metro 
    return "#fCityPlan01:12 s103 r994779 z0.9";
  if( bldfnc == "69" ) // Mosque 
    return "#fCityPlan01:12 s46 r009240 z0.9";
  if( bldfnc == "70" ) // Pagoda 
    return "#fCityPlan01:12 s66 rFF8686 z0.9";
  if( bldfnc == "71" ) // Chapel 
    return "#fCityPlan01:12 s52 rFF8686 z0.9";
  if( bldfnc == "72" ) // Synagogue 
    return "#fCityPlan01:12 s54 rFF8686 z0.9";
  return 0;  
}

global POIGEN_pnt(ch,fe,rgb)
{
  if( !chGetFeatureNode(ch,fe,nd) )
    return 0;
  chSetGeoUnits(0);  
  if( !chGetNodeXY(ch,nd,x,y) )
    return 0;
  if( !chMap2Win(ch,x,y,x1,y1) )
    return 0;
  prpen=SelectObject(GetStockObject(BLACK_PEN));
  prbrush=SelectObject(GetStockObject(GRAY_BRUSH));
  Ellipse(x1-4,y1-4,x1+4,y1+4);
  SelectObject(prbrush);
  SelectObject(prpen);
  return 0;  
}

global LTBLDS_pnt(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,60250,catlbl) )
  {
    if( !chGetAttrText(ch,fe,61068,poicat) )
      return 0;
    if( poicat == "firehouse" )
      return "#fCityPlan01:12 s65 rE60039 z0.9"; 
    if( poicat == "parking" || poicat == "trackparking" )
      return "#fCityPlan01:12 s119 r4000FF z0.9"; 
    return 0;
  }
  if( catlbl == 1 ) // Monument  
    return "#fCityPlan01:12 s33 r009933 z0.7"; 
  if( catlbl == 5 ) // Telephone box  
    return "#fCityPlan01:12 s104 r7DA8FF z0.9"; 
  if( catlbl == 7 ) // Fire tower  
    return "#fCityPlan01:12 s65 rE60039 z0.9"; 
  if( catlbl == 20 ) // Toilet  
    return 0;
  if( catlbl == 22 ) // Car repair  
    return "#fCityPlan01:12 s114 r8A8A8A z0.9";
  if( catlbl == 27 ) // Bus stop  
    return "#fCityPlan01:12 s102 r797AFF z0.9";
  return 0;
}

local drawBearing(ch,fe,ornt,dist,style,x,y,x1,y1)
{
  //chGetProperty(ch,GEO_RELATE,relate);
  chGetProperty(ch,GEO_SCALE,scale);
  dist*=1000000/scale;  // meters2dist=1000*relate/scale;
  if( !chMap2Win(ch,x+dist*sind(ornt),y-dist*cosd(ornt),x2,y2) )
    return;
  dx=x1-x2;
  if( dx < 0 )
    dx=0-dx;
  dy=y1-y2;  
  if( dy < 0 )
    dy=0-dy;
  if( dx < 6 && dy < 6 )
    return;  
  pen=CreatePen(style,1,0);    
  prpen=SelectObject(pen);
  MoveTo(x1,y1);
  LineTo(x2,y2);
  SelectObject(prpen);
  DeleteObject(pen);
  prpen=SelectObject(GetStockObject(BLACK_PEN));
  prbrush=SelectObject(GetStockObject(GRAY_BRUSH));
  Ellipse(x2-3,y2-3,x2+3,y2+3);
  SelectObject(prbrush);
  SelectObject(prpen);
}

local drawBothBearings(ch,fe,x1,y1)
{
  if( !chGetFeatureNode(ch,fe,nd) )
    return 1;
  chSetGeoUnits(0);  
  if( !chGetNodeXY(ch,nd,x,y) )
    return 1;
  if( !chMap2Win(ch,x,y,x1,y1) )
    return 1;
  if( chGetAttrValue(ch,fe,1705,orient) && chGetAttrValue(ch,fe,1706,dist) )
    drawBearing(ch,fe,orient,dist,PS_DASHDOT,x,y,x1,y1);
  if( chGetAttrValue(ch,fe,1707,orient) && chGetAttrValue(ch,fe,1708,dist) ) 
    drawBearing(ch,fe,orient,dist,PS_DASHDOTDOT,x,y,x1,y1);
  return 0;  
}

global RADARS_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  prpen=SelectObject(GetStockObject(BLACK_PEN));
  prbrush=SelectObject(GetStockObject(GRAY_BRUSH));
  Rectangle(x1-4,y1-4,x1+4,y1+4);
  SelectObject(prbrush);
  SelectObject(prpen);
  return 0;  
}

local drawSpeedLimit(ch,fe,rgb,spdlmt)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,2,red);
  prpen=SelectObject(pen);
  prbrush=SelectObject(GetStockObject(WHITE_BRUSH));
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(pen);
  fnt=CreateFont(10,0,0,0,"Arial");
  SetTextColor(black);
  SetTextAlign(TA_CENTER|TA_BASELINE);
  prfnt=SelectObject(fnt);
  TextOut(x1,y1+3,spdlmt);
  SelectObject(prfnt);
  DeleteObject(fnt);
  return 0;
}

global SPD005_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"5"); } 
global SPD010_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"10"); } 
global SPD015_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"15"); } 
global SPD020_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"20"); } 
global SPD025_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"25"); } 
global SPD030_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"30"); } 
global SPD035_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"35"); } 
global SPD040_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"40"); } 
global SPD045_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"45"); } 
global SPD050_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"50"); } 
global SPD060_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"60"); } 
global SPD070_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"70"); } 
global SPD080_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"80"); } 
global SPD090_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"90"); } 
global SPD100_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"100"); } 
global SPD110_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"110"); } 
global SPD120_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"120"); } 
global SPD130_pnt(ch,fe,rgb) { drawSpeedLimit(ch,fe,rgb,"130"); } 


global PROHIBITION_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,2,red);
  prpen=SelectObject(pen);
  prbrush=SelectObject(GetStockObject(WHITE_BRUSH));
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(pen);
  return 0;
}

global ENDLIM_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,2,red);
  prpen=SelectObject(pen);
  prbrush=SelectObject(GetStockObject(WHITE_BRUSH));
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(prbrush);
  SelectObject(GetStockObject(BLACK_PEN));
  MoveTo(x1-7,y1-7);
  LineTo(x1+8,y1+8);
  MoveTo(x1-7,y1+7);
  LineTo(x1+8,y1-8);
  SelectObject(prpen);
  DeleteObject(pen);
  return 0;
}

global KIRPCH_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,1,red);
  prpen=SelectObject(pen);
  brush=CreateSolidBrush(red);
  prbrush=SelectObject(brush);
  Ellipse(x1-9,y1-9,x1+9,y1+9);
  SelectObject(GetStockObject(WHITE_PEN));
  SelectObject(GetStockObject(WHITE_BRUSH));
  Rectangle(x1-5,y1-2,x1+5,y1+2);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global ROUNDB_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  SelectObject(GetStockObject(NULL_BRUSH));
  Ellipse(x1-6,y1-6,x1+6,y1+6);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global LEFTTT_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  x1+=1;
  y1+=1;
  MoveTo(x1-3,y1+3);
  LineTo(x1-3,y1-3);
  LineTo(x1+3,y1-3);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global RIGHTT_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  x1-=1;
  y1+=1;
  MoveTo(x1+3,y1+3);
  LineTo(x1+3,y1-3);
  LineTo(x1-3,y1-3);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global LEFRIG_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  y1+=1;
  MoveTo(x1,y1+3);
  LineTo(x1,y1-2);
  LineTo(x1+5,y1-3);
  MoveTo(x1,y1-2);
  LineTo(x1-5,y1-3);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global STRGHT_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  MoveTo(x1,y1+5);
  LineTo(x1,y1-6);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global LFTSTR_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  x1+=1;
  MoveTo(x1,y1+5);
  LineTo(x1,y1-6);
  MoveTo(x1,y1);
  LineTo(x1-6,y1);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global RIGSTR_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Ellipse(x1-8,y1-8,x1+8,y1+8);
  SelectObject(GetStockObject(WHITE_PEN));
  x1-=1;
  MoveTo(x1,y1+5);
  LineTo(x1,y1-6);
  MoveTo(x1,y1);
  LineTo(x1+6,y1);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global PASPAS_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  x1=int(x1+0.5);  
  y1=int(y1+0.5);  
  pen=CreatePen(PS_SOLID,0,trafsignblue);
  brush=CreateSolidBrush(trafsignblue);
  prpen=SelectObject(pen);
  prbrush=SelectObject(brush);
  Rectangle(x1-7,y1-7,x1+7,y1+7);
  SelectObject(GetStockObject(WHITE_BRUSH));
  SelectObject(GetStockObject(WHITE_PEN));
  xy=ArCreate(6);
  ArSetAt(xy,1,x1);     ArSetAt(xy,2,y1-6);
  ArSetAt(xy,3,x1-6);   ArSetAt(xy,4,y1+4);
  ArSetAt(xy,5,x1+5);   ArSetAt(xy,6,y1+4);
  Polygon(xy);
  ArFree(xy);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  return 0;
}

global WARNINGSIGN_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  x1=int(x1+0.5);  
  y1=int(y1+0.5);  
  pen=CreatePen(PS_SOLID,2,red);
  prpen=SelectObject(pen);
  prbrush=SelectObject(GetStockObject(WHITE_BRUSH));
  MoveTo(x1,y1-4);
  xy=ArCreate(6);
  ArSetAt(xy,1,x1);     ArSetAt(xy,2,y1-10);
  ArSetAt(xy,3,x1-8);   ArSetAt(xy,4,y1+4);
  ArSetAt(xy,5,x1+8);   ArSetAt(xy,6,y1+4);
  Polygon(xy);
  ArFree(xy);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(pen);
  return 0;
}

global GIVWAY_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  x1=int(x1+0.5);  
  y1=int(y1+0.5);  
  pen=CreatePen(PS_SOLID,2,red);
  prpen=SelectObject(pen);
  prbrush=SelectObject(GetStockObject(WHITE_BRUSH));
  MoveTo(x1,y1-4);
  xy=ArCreate(6);
  ArSetAt(xy,1,x1);     ArSetAt(xy,2,y1+10);
  ArSetAt(xy,3,x1-8);   ArSetAt(xy,4,y1-4);
  ArSetAt(xy,5,x1+8);   ArSetAt(xy,6,y1-4);
  Polygon(xy);
  ArFree(xy);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(pen);
  return 0;
}

global DNGCRS_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  x1=int(x1+0.5);  
  y1=int(y1+0.5);  
  pen=CreatePen(PS_SOLID,2,red);
  prpen=SelectObject(pen);
  prbrush=SelectObject(GetStockObject(WHITE_BRUSH));
  MoveTo(x1,y1-4);
  xy=ArCreate(6);
  ArSetAt(xy,1,x1);     ArSetAt(xy,2,y1-10);
  ArSetAt(xy,3,x1-8);   ArSetAt(xy,4,y1+4);
  ArSetAt(xy,5,x1+8);   ArSetAt(xy,6,y1+4);
  Polygon(xy);
  ArFree(xy);
  SelectObject(GetStockObject(BLACK_PEN));
  MoveTo(x1-2,y1-2);
  LineTo(x1+3,y1+3);
  MoveTo(x1-2,y1+2);
  LineTo(x1+3,y1-3);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(pen);
  return 0;
}

global SNSTOP_pnt(ch,fe,rgb)
{
  if( drawBothBearings(ch,fe,x1,y1) )
    return 0;
  x1=int(x1+0.5);  
  y1=int(y1+0.5);  
  pen=CreatePen(PS_SOLID,1,red);
  prpen=SelectObject(pen);
  brush=CreateSolidBrush(red);
  prbrush=SelectObject(brush);
  MoveTo(x1,y1-4);
  xy=ArCreate(16);
  ArSetAt(xy,1,x1-8);     ArSetAt(xy,2,y1-4);
  ArSetAt(xy,3,x1-4);     ArSetAt(xy,4,y1-8);
  ArSetAt(xy,5,x1+4);     ArSetAt(xy,6,y1-8);
  ArSetAt(xy,7,x1+8);     ArSetAt(xy,8,y1-4);
  ArSetAt(xy,9,x1+8);     ArSetAt(xy,10,y1+4);
  ArSetAt(xy,11,x1+4);    ArSetAt(xy,12,y1+8);
  ArSetAt(xy,13,x1-4);    ArSetAt(xy,14,y1+8);
  ArSetAt(xy,15,x1-8);    ArSetAt(xy,16,y1+4);
  Polygon(xy);
  ArFree(xy);
  SelectObject(prbrush);
  SelectObject(prpen);
  DeleteObject(brush);
  DeleteObject(pen);
  fnt=CreateFont(7,0,0,0,"Arial");
  SetTextColor(white);
  SetTextAlign(TA_CENTER|TA_BASELINE);
  prfnt=SelectObject(fnt);
  TextOut(x1+1,y1+3,"STOP");
  SelectObject(prfnt);
  DeleteObject(fnt);
  return 0;
}

global SPORTS_pnt(ch,fe,rgb)
{
  if( chGetAttrText(ch,fe,61068,poicat) && ( poicat == "pool" || poicat == "diving" ) )
    return "#fCityPlan01:12 s51 r00008B z0.9";
  return 1;  
}



