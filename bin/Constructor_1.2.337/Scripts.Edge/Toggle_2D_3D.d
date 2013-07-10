include <windows.dh>
include <system.dh>

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( !GetResource("Edge",eg) )
    return;
  if( chIsEdge3D(ch,eg) )
  {
    if( MessageBox("3D values will be lost. Continue?",MB_ICONEXCLAMATION|MB_YESNO) == IDNO )
      return;
  }
  else
  {
    if( MessageBox("Add 3D values to this edge?",MB_ICONQUESTION|MB_OKCANCEL) == IDCANCEL )
      return;
  }
  chToggle2D3D(ch,eg);
  chUpdatePresentation(ch);
  Redraw();
}
