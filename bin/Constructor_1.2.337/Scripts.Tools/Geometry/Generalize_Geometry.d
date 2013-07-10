include <system.dh>
include <windows.dh>


global main()
{

  if( !(ch=GetEditDataset()) )
    return;
  if( !GeneralizeOptDlg() )
    return;
  a=ArCreate(0);
  for( fe=0; fe=chNextFeature(ch,fe); )
    if( IsFeatureQueried(fe) )
      ArAdd(a,fe);
  a2=0;    
  if( ArSize(a) )   
    a2=a;
  else if( MessageBox("Generalize whole dataset?",MB_ICONQUESTION|MB_OKCANCEL) == IDCANCEL )
  {
    ArFree(a);
    return;
  }
  r1=r2=0;
  if( !(ret=chGeneralize(ch,0,a2,r1,r2)) )
    puts("Generalizing: nothing done");
  else
  {
    Redraw();
    puts("Generalizing:  processed edges - "+ret+";  number of vertexes: before - "+r1+"; after - "+r2+";");
  }
  ArFree(a);
  
  
}
