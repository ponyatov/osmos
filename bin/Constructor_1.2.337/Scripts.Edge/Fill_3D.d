include <windows.dh>
include <system.dh>

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( !GetResource("Edge",eg) )
    return;
  if( !chIsEdge3D(ch,eg) )
    return;
  sz=chGetEdgeXYZ(ch,eg,0,x1,y1,z1);
  i1=0;
  for( i2=1; i2<sz; i2+=1 )
  {
    chGetEdgeXYZ(ch,eg,i2,x2,y2,z2);
    if( z2 == 0 && i2 < sz-1 )
      continue;
    if( i2-i1 > 1 )
    {
//puts(""+i1+" "+i2+" "+z1+" "+z2);
      if( z1 == z2 )
      {
        for( i=i1+1; i<i2; i+=1 )
        {
          chGetEdgeXY(ch,eg,i,x,y);
          chEdiEdge(ch,eg,i,x,y,z1);
        }
      }
      else
      {
        len=0;
        for( i=i1+1; i<=i2; i+=1 )
        {
          chGetEdgeXY(ch,eg,i-1,x1,y1);
          chGetEdgeXY(ch,eg,i,x2,y2);
          dx=x2-x1;
          dy=y2-y1;
          len+=sqrt(dx*dx+dy*dy);
        }
        if( len != 0 )
        {
          dist=0;
          for( i=i1+1; i<i2; i+=1 )
          {
            chGetEdgeXY(ch,eg,i-1,x1,y1);
            chGetEdgeXY(ch,eg,i,x2,y2);
            dx=x2-x1;
            dy=y2-y1;
            dist+=sqrt(dx*dx+dy*dy);
            chEdiEdge(ch,eg,i,x2,y2,z1+(z2-z1)*dist/len);
          }
        }
      }
    }
    i1=i2;
    z1=z2;
  }
  chUpdatePresentation(ch);
  Redraw();
}
