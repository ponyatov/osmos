debug off
include <windows.dh>

global main()
{
  if( !(ch=GetEditDataset()) )
  {
    MessageBox("No Active Paper Chart",MB_OK|M_ICONSTOP);
    return;
  }
  chFitBorder(ch);
  Redraw();
}  
