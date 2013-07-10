include <system.dh>
include <windows.dh>

global main()
{
  if( IDCANCEL == OpenFileDlg(fn,GetStartPath(),"Session file (*.session)|*.session||") )
    return;
  if( StrLwr(StrRight(fn,8)) != ".session" )
    fn+=".session"; 
  if( !(fp=fopen(fn,"r")) )
  {
    MessageBox("Cannot read file "+fn,MB_ICONSTOP|MB_OK);
    return;
  }  
  fgets(header,100,fp);
  if( header != "GISConstructor session file. Do not edit!" )
  {
    fclose(fp);
    MessageBox("Wrong format of "+fn,MB_ICONSTOP|MB_OK);
    return;
  }
  cur=0;
  fgets(scale,100,fp);
  fgets(lat,100,fp);
  fgets(lon,100,fp);
  while( fgets(name,512,fp) )
  {
    //puts(name);
    if( StrLeft(name,1) == "*" )
      cur=LoadDataset(StrMid(name,2));
    else
      LoadDataset(name);
  }
  fclose(fp);
  LoadToEditor(cur);
  SetScaleAndPosition(real(scale),real(lat),real(lon),0,0);
  Redraw();
}
