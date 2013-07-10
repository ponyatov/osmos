include <LookUp2DInc.dh>
include <dkart.dh>
include <windows.dh>

local error(txt)
{
  MessageBox(txt,MB_OK|MB_ICONSTOP);
  exit(0);
}

global main()
{
  OnError(ERR_IGNORE);
  if( !GetResource("Object",fe) )
    error("Illegal script: object is not defined");
  if( !(ch=GetEditDataset()) )
    return;
  if( chGetFeatureCode(ch,fe) != FE_LINE )
    error("Linear object required");
  if( GetResource("NoTurn",fe1) )
  {
    DeleteResource("NoTurn");
    if( fe1 == fe )
      chDelFeature(ch,fe);
    else
    {
      if( chGetFeatureLine(ch,fe,1,eg2,flag) != 1 )
      {
        SetResource("NoTurn",fe1);
        error("Слишком много ребер. Используйте Scripts->Split Streets.");
      }
      chGetFeatureLine(ch,fe=fe1,1,eg1,flag);
      chGetEdgeBegEnd(ch,eg1,b1,e1);
      chGetEdgeBegEnd(ch,eg2,b2,e2);
      if( e1 == b2 )
        chIncFeatureLine(ch,fe,2,eg2,0);
      else if( e1 == e2 )
        chIncFeatureLine(ch,fe,2,eg2,M_REVERSE);
      else if( b1 == b2 )
      {
        chEdiFeatureLine(ch,fe,eg1,eg1,M_REVERSE);
        chIncFeatureLine(ch,fe,2,eg2,0);
      }
      else if( b1 == e2 )
      {
        chEdiFeatureLine(ch,fe,eg1,eg1,M_REVERSE);
        chIncFeatureLine(ch,fe,2,eg2,M_REVERSE);
      }
      else
        chDelFeature(ch,fe);
    }
  }
  else
  {
    chGetAttrValue(ch,fe,AT_LAYERS,val);
    if( val == 4 )
      chDelFeature(ch,fe);
    else if( chGetFeatureLine(ch,fe,1,eg,flag) != 1 )
      error("Слишком много ребер. Используйте Scripts->Split Streets.");
    else
    {
      fe=chCrtFeature(ch,FE_LINE);
      chSetAttrText(ch,fe,SORIND,str(fe));
      //chSetAttrText(ch,fe,INFORM,"-= No Turn =-");
      chSetAttrText(ch,fe,AT_LAYERS,"4");
      chSetAttrText(ch,fe,AT_NAME,"noturn");
      chIncFeatureLine(ch,fe,1,eg,0);
      SetResource("NoTurn",fe);
    }
  }
  chUpdateFeature(ch,fe);
  chUpdatePresentation(ch);
  Redraw();
}
