debug off
include <dkart.dh>
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

global oneway(ch,fe,rgb)
{
  if( !chGetAttrValue(ch,fe,AT_LAYERS,layer) || layer < 2 )
    return 1;
  num=chGetFeatureLine(ch,fe,0,eg,flag);
  if( layer == 2 )
  {
    for( i=1; i<=num; i+=1 )
    {
      chGetFeatureLine(ch,fe,i,eg,flag);
      if( flag & M_REVERSE )
      {
        sz=chGetEdgeXY(ch,eg,0,x1,y1);
        chGetEdgeXY(ch,eg,sz-1,x2,y2);
        chGetEdgeXY(ch,eg,sz-2,x1,y1);
      }
      else
      {
        chGetEdgeXY(ch,eg,0,x2,y2);
        chGetEdgeXY(ch,eg,1,x1,y1);
      }
      drawOneWay(orient,x1,y1,x2,y2,rgb);
    }
  }
  else if( layer == 3 )
  {
    for( i=1; i<=num; i+=1 )
    {
      chGetFeatureLine(ch,fe,i,eg,flag);
      if( flag & M_REVERSE )
      {
        chGetEdgeXY(ch,eg,0,x2,y2);
        chGetEdgeXY(ch,eg,1,x1,y1);
      }
      else
      {
        sz=chGetEdgeXY(ch,eg,0,x1,y1);
        chGetEdgeXY(ch,eg,sz-1,x2,y2);
        chGetEdgeXY(ch,eg,sz-2,x1,y1);
      }
      drawOneWay(orient,x1,y1,x2,y2,rgb);
    }
  }
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


