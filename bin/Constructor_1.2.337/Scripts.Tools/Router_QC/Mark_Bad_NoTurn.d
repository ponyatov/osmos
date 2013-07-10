include <windows.dh>
include <system.dh>
include <LookUp2DInc.dh>

local isPC 0

const FE_NOTURN 1666
const FE_STREET 60160
const AT_SCALVL 1703
const AT_ONEWAY 1704

local getTurnID(ch,fe)
{
  if( isPC )
  {
    if( chGetFeatureCode(ch,fe) != FE_LINE )
      return 0;
    if( !chGetAttrText(ch,fe,AT_LAYERS,layer) || layer != "4" )
      return 0;
    if( chGetAttrText(ch,fe,AT_PATOFF,patoff) )
      return 0;
  }
  else // CP
  {
    if( chGetFeatureCode(ch,fe) != FE_NOTURN || chGetAttrText(ch,fe,NINFOM,ninfom) )
      return 0;
  }    
  if( chGetFeatureLine(ch,fe,1,eg1,flag1) != 2 )
    return 0;
  chGetFeatureLine(ch,fe,2,eg2,flag2);
  ret=eg2*50000+eg1;
  if( flag2 & M_REVERSE )
    ret=-ret;
  return ret;
}

local sameAttrs(ch,f1,f2,at)
{
  if( !chGetAttrText(ch,f1,at,v1) )
    v1="";
  if( !chGetAttrText(ch,f2,at,v2) )
    v2="";
  return v1 == v2;
}

local sameStreets(ch,f1,f2)
{
  if( f1 == f2 )
    return 1;
  return
    sameAttrs(ch,f1,f2,INFORM) &&
    sameAttrs(ch,f1,f2,SORIND) && 
    sameAttrs(ch,f1,f2,AT_MARKER);
    //sameAttrs(ch,f1,f2,AT_PRIORT) &&
    //sameAttrs(ch,f1,f2,AT_LAYERS);
}

local onStreet(ch,nd)
{
  if( !(egs=chGetEdgesOfNode(ch,nd)) )
    return 0;
  s=ArCreate(0);
  for( i=ArSize(egs); i; i-=1 )
  {
    if( !(fes=chGetFeaturesOfEdge(ch,eg=ArGet(egs,i))) )
      continue;
    for( j=ArSize(fes); j; j-=1 )
    {
      if( chGetMetricType(ch,fe=ArGet(fes,j)) == M_LINE &&
          chGetFeatureCode(ch,fe) == FE_LINE &&
          chGetAttrValue(ch,fe,AT_LAYERS,layer) && layer >= 1 && layer <= 3 )
        ArAdd(s,fe);
    }
    ArFree(fes);
  }
  ArFree(egs);
  ret=( ArSize(s) == 2 && sameStreets(ch,ArGet(s,1),ArGet(s,2)) );
  ArFree(s);
  return ret;
}

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( !(fe=chNextFeature(ch,0)) )
    return;
  ds=chGetFeatureDictionary(ch,fe);
  if( ds == 1650 )
    isPC=1;
  else if( ds != 64003 )
    return;
  tot1=tot2=tot3=tot4=tot5=tot6=tot7=tot8=tot9=0;
  StartIndicator("Processing...",chFeatureNum(ch));
  if( isPC )
  {
    chCompact(ch,0);
    for( fe=0; fe=chNextFeature(ch,fe); )
      if( chGetAttrText(ch,fe,AT_LAYERS,layer) && layer == "4" && chGetAttrText(ch,fe,AT_PATOFF,patoff) )
        break;
    if( fe )
    {
      FinishIndicator();
      MessageBox("Карта уже содержит запреты поворотов с PATOFF",MB_ICONSTOP|MB_OK);
      return;
    }
    marker=AT_PATOFF;
  }  
  else // CP
  {
    for( fe=0; fe=chNextFeature(ch,fe); )
      if( chGetFeatureCode(ch,fe) == FE_NOTURN && chGetAttrText(ch,fe,NINFOM,ninfom) )
        break;
    if( fe )
    {
      FinishIndicator();
      MessageBox("Карта уже содержит запреты поворотов с NINFOM",MB_ICONSTOP|MB_OK);
      return;
    }
    marker=NINFOM;
  }
  StartIndicator("Processing...",chFeatureNum(ch));
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( isPC )
    {  
      if( chGetFeatureCode(ch,fe) != FE_LINE )
        continue;
      if( !chGetAttrText(ch,fe,AT_LAYERS,layer) || layer != "4" )
        continue;
      if( chGetAttrText(ch,fe,INFORM,inform) && inform != "-= No Turn =-" )
      {
        chSetAttrText(ch,fe,SORIND,""+fe);
        chSetAttrText(ch,fe,INFORM,"-= No Turn =-");
        //tot+=1;
      }
      else if( !chGetAttrText(ch,fe,SORIND,sorind) || sorind != str(fe) )
      {
        chSetAttrText(ch,fe,SORIND,""+fe);
        //tot+=1;
      }
    } 
    else if( chGetFeatureCode(ch,fe) == FE_NOTURN )
    {
      if( !chGetAttrText(ch,fe,SORIND,sorind) || sorind != str(fe) )
        chSetAttrText(ch,fe,SORIND,""+fe);
      if( !chGetAttrText(ch,fe,AT_SCALVL,scalvl) )
      {
        chSetAttrText(ch,fe,marker,"-9");
        tot9+=1;
        continue;
      }
    }
    else
      continue; 
    if( (sz=chGetFeatureLine(ch,fe,1,eg1,flag1)) != 2 )
    {
      chSetAttrText(ch,fe,marker,"-1");
      tot1+=1;
    }
    else
    {
      err=0;
      chGetFeatureLine(ch,fe,2,eg2,flag2);
      chGetEdgeBegEnd(ch,eg1,b1,e1);
      if( flag1 & M_REVERSE )
      {
        swap=e1;
        e1=b1;
        b1=swap;
      }
      chGetEdgeBegEnd(ch,eg2,b2,e2);
      if( flag2 & M_REVERSE )
      {
        swap=b2;
        b2=e2;
        e2=swap;
      }
      if( e1 != b2 )
      {
        chSetAttrText(ch,fe,marker,"-2"); // разрыв
        tot2+=1;
        continue;
      }
      if( isPC )
      {
        if( onStreet(ch,b1) )
          err=-6; // начало посреди улицы
        if( onStreet(ch,e2) )
          err=-7; // конец посреди улицы
      }    
      fes=chGetFeaturesOfEdge(ch,eg1);
      nn=0;
      for( i=ArSize(fes); i; i-=1 )
      {
        if( isPC )
        {
          if( !chGetAttrValue(ch,fe3=ArGet(fes,i),AT_LAYERS,layer) )
            continue;
          if( layer >= 1 && layer <= 3 )
            nn+=1;
          if( layer == 2 || layer == 3 )
          {
            for( j=chGetFeatureLine(ch,fe3,0,eg3,flag3); j; j-=1 )
            {
              chGetFeatureLine(ch,fe3,j,eg3,flag3);
              if( eg3 == eg1 )
              {
                if( layer == 3 )
                {
                  if( flag3 & M_REVERSE )
                    flag3=0;
                  else
                    flag3=M_REVERSE;
                }
                if( flag1 != flag3 )
                  err=-3; // начинается против хода движения 
                break;
              }  
            }
          }
        }
        else // CP
        {
          if( chGetFeatureCode(ch,fe3=ArGet(fes,i)) != FE_STREET )
            continue;
          nn+=1;  
          if( chGetAttrValue(ch,fe3,AT_ONEWAY,oneway) )
          {
            for( j=chGetFeatureLine(ch,fe3,0,eg3,flag3); j; j-=1 )
            {
              chGetFeatureLine(ch,fe3,j,eg3,flag3);
              if( eg3 == eg1 )
              {
                if( oneway == 2 )
                {
                  if( flag3 & M_REVERSE )
                    flag3=0;
                  else
                    flag3=M_REVERSE;
                }
                if( flag1 != flag3 )
                  err=-3; // начинается против хода движения 
                break;
              }  
            }
          }
        }
      }
      ArFree(fes);
      if( nn != 1 )
        err=-5; // оторван от дороги
      fes=chGetFeaturesOfEdge(ch,eg2);
      nn=0;
      for( i=ArSize(fes); i; i-=1 )
      {
        if( isPC )
        {
          if( !chGetAttrValue(ch,fe3=ArGet(fes,i),AT_LAYERS,layer) )
            continue;
          if( layer >= 1 && layer <= 3 )
            nn+=1;
          if( layer == 2 || layer == 3 )
          {
            for( j=chGetFeatureLine(ch,fe3,0,eg3,flag3); j; j-=1 )
            {
              chGetFeatureLine(ch,fe3,j,eg3,flag3);
              if( eg3 == eg2 )
              {
                if( layer == 3 )
                {
                  if( flag3 & M_REVERSE )
                    flag3=0;
                  else
                    flag3=M_REVERSE;
                }
                if( flag2 != flag3 )
                  err=-4; // завершается против хода движения
                break;
              }  
            }
          }
        }
        else // CP
        {
          if( chGetFeatureCode(ch,fe3=ArGet(fes,i)) != FE_STREET )
            continue;
          nn+=1;  
          if( chGetAttrValue(ch,fe3,AT_ONEWAY,oneway) )
          {
            for( j=chGetFeatureLine(ch,fe3,0,eg3,flag3); j; j-=1 )
            {
              chGetFeatureLine(ch,fe3,j,eg3,flag3);
              if( eg3 == eg2 )
              {
                if( oneway == 2 )
                {
                  if( flag3 & M_REVERSE )
                    flag3=0;
                  else
                    flag3=M_REVERSE;
                }
                if( flag2 != flag3 )
                  err=-4; // завершается против хода движения
                break;
              }  
            }
          }
        }
      }
      ArFree(fes);
      if( nn != 1 )
        err=-5; // оторван от дороги
      if( err )
      {
        if( ( err == (-6) || err == (-7) ) && chGetAttrText(ch,fe,marker,patoff) && int(patoff) < 0 )
          continue;
        chSetAttrText(ch,fe,marker,str(err));
        if( err == (-3) )      // начинается против хода движения 
          tot3+=1;
        else if( err == (-4) ) // завершается против хода движения
          tot4+=1;
        else if( err == (-5) ) // оторван от дороги
          tot5+=1;
        else if( err == (-6) ) // начало посреди улицы
          tot6+=1;
        else if( err == (-7) ) // конец посреди улицы
          tot7+=1;
      }
    }
  }
  a=ArCreate(0);
  StartIndicator("Processing...",chFeatureNum(ch));
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( (id=getTurnID(ch,fe)) )
      ArAdd(a,id);
  }
  ArSort(a,a);
  for( i=ArSize(a); i>1; i-=1 )
  {
    if( ArGet(a,i) != ArGet(a,i-1) )
      ArRemoveAt(a,i);
  }
  if( ArSize(a) )
    ArRemoveAt(a,1);
  if( ArSize(a) )
  {
    StartIndicator("Processing...",chFeatureNum(ch));
    for( fe=0; fe=chNextFeature(ch,fe); )
    {
      StepIndicator();
      if( (id=getTurnID(ch,fe)) )
      {
        for( i=ArSize(a); i; i-=1 )
        {
          if( ArGet(a,i) == id )
          {
            chSetAttrText(ch,fe,marker,"-8");
            ArRemoveAt(a,i);
            tot8+=1;
            break;
          }
        }
      }
    }
    for( i=ArSize(a); i; i-=1 )
      puts("*** cannot find turn "+ArGet(a,i));
  }
  ArFree(a);
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
  if( isPC )
    marker="PATOFF";
  else  
    marker="NINFOM";
  if( tot1 )
    puts(marker+"=[-1] не 2 ребра: "+tot1);
  if( tot2 )
    puts(marker+"=[-2] разрыв: "+tot2);
  if( tot3 )
    puts(marker+"=[-3] начинается против хода движения: "+tot3);
  if( tot4 )
    puts(marker+"=[-4] завершается против хода движения: "+tot4);
  if( tot5 )
    puts(marker+"=[-5] оторван от дороги: "+tot5);
  if( tot6 )
    puts(marker+"=[-6] начало посреди улицы: "+tot6);
  if( tot7 )
    puts(marker+"=[-7] конец посреди улицы: "+tot7);
  if( tot8 )
    puts(marker+"=[-8] дубликат: "+tot8);
  if( tot9 )
    puts(marker+"=[-9] не установлен SCALVL: "+tot9);
}
