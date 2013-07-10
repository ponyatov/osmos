include <windows.dh>

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( !GetResource("Node",nd) )
    MessageBox("Illegal script: node is not defined",MB_OK|MB_ICONSTOP);
  else
    SetFinishNode(nd);
}
