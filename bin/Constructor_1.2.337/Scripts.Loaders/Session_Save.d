include <system.dh>
include <windows.dh>

global main()
{
  if( IDCANCEL == SaveFileDlg(fn,"session",GetStartPath()+"*.session",-1,"Session file (*.session)|*.session||") )
    return;
  if( StrLwr(StrRight(fn,8)) != ".session" )
    fn+=".session"; 
  if( !(fp=fopen(fn,"w")) )
  {
    MessageBox("Cannot create file "+fn,MB_ICONSTOP|MB_OK);
    return;
  }  
  scale=GetCurScale();
  Win2Geo(0,0,lat,lon);
  fputs("GISConstructor session file. Do not edit!\n",fp);
  fputs(printf("%.15g\n",scale),fp);
  fputs(printf("%.15g\n",lat),fp);
  fputs(printf("%.15g\n",lon),fp);
  cha=GetEditDataset();
  for( ch=0; ch=NextDataset(ch); )
  {
    chGetProperty(ch,CH_NAME,name);
    if( ch == cha )
      name="*"+name;
    fputs(name+"\n",fp);
  }
  fclose(fp);
}
