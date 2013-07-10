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
  if( !(ch=GetEditDataset()) ||
      MessageBox("Do you really want to delete this object?",MB_YESNO|MB_ICONEXCLAMATION) == IDNO )
    return;
  if( !chDelFeature(ch,fe) )
  {
    MessageBox("Cannot delete object",MB_OK|MB_ICONSTOP);
    return;
  }
  chUpdateFeature(ch,fe);
  chUpdatePresentation(ch);
  Redraw();
}