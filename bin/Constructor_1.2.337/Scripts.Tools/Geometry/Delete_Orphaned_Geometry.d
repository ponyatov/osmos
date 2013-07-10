global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  nr=er=sr=lr=fr=0;
  for( fc=chNextArea(ch,0); fc; )
  {
    fc=chNextArea(ch,todel=fc);
    if( chDelArea(ch,todel) )
    {
      //chUpdateArea(ch,todel);
      fr+=1;
    }
  }
  for( ln=chNextLine(ch,0); ln; )
  {
    ln=chNextLine(ch,todel=ln);
    if( chDelLine(ch,todel) )
    {
      //chUpdateLine(ch,todel);
      lr+=1;
    }
  }
  for( eg=chNextEdge(ch,0); eg; )
  {
    eg=chNextEdge(ch,todel=eg);
    if( chDelEdge(ch,todel) )
    {
      //chUpdateEdge(ch,todel);
      er+=1;
    }
  }
  for( eg=chNextEdge3D(ch,0); eg; )
  {
    eg=chNextEdge3D(ch,todel=eg);
    if( chDelEdge(ch,todel) )
    {
      //chUpdateEdge(ch,todel);
      sr+=1;
    }
  }
  for( nd=chNextNode(ch,0); nd; )
  {
    nd=chNextNode(ch,todel=nd);
    if( chDelNode(ch,todel) )
    {
      //chUpdateNode(ch,todel);
      nr+=1;
    }
  }
  chUpdatePresentation(ch);
  Redraw();
  puts("Deleted:  "+nr+" node(s)  "+er+" edge(s)  "+sr+" sounding(s)  "+lr+" contour(s)  "+fr+" area(s)");
}