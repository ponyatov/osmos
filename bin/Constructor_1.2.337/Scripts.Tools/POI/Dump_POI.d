include <system.dh>
include <LookUp2DInc.dh>

const AT_LABELS 17501
const AT_FULNAM 17506
const AT_STRNAM 60030
const AT_NUMBER 60040

const AT_DSTNAM 61062
const AT_TWNNAM 61063
const AT_REGNAM 61065
const AT_TERNAM 61064

const AT_PHONES 17502
const AT_FAXNUM 17503
const AT_WEBPGE 17504
const AT_EMAILS 17505
const AT_PAIDES 17507
const AT_OPTIME 17519
const AT_BEGDAT 17520
const AT_ENDDAT 17521

const AT_INFORM 102
//const AT_NINFOM 300

const AT_SORIND 148
const AT_RECIND 129

global main()
{
  if( !(ch=GetEditDataset()) )
    return;
  if( !chGetProperty(ch,CH_NAME,fname) )
    return;
  chSetGeoUnits(1);  
  if( !StrICmp(StrRight(fname,4),".dcf") )
    fname=StrLeft(fname,StrLen(fname)-4);   
  StartIndicator("Processing I ...",chFeatureNum(ch));
  fes=ArCreate(0);
  for( fe=0; fe=chNextFeature(ch,fe); )
  {
    StepIndicator();
    if( chGetFeatureDictionary(ch,fe) != 64003 || !chGetFeatureNode(ch,fe,nd) )
      continue;
    code=chGetFeatureCode(ch,fe);
    if( code >= 18000 && code < 18900 )
      ArAdd(fes,fe);
  }
  StartIndicator("Processing II ...",ArSize(fes));
  while( ArSize(fes) )
  {
    fen=ArCreate(0);
    code=chGetFeatureCode(ch,ArGet(fes,1));
    for( i=ArSize(fes); i; i-=1 )
    {
      fe=ArGet(fes,i);
      if( code == chGetFeatureCode(ch,fe) )
      {
        StepIndicator();
        ArRemoveAt(fes,i);
        ArAdd(fen,fe);
      }
    }
    dsObjAcroByCode(64003,code,acro);
    if( !(fp=fopen(fname+"."+acro+".txt","w")) )
    {
      puts("*** cannot create file "+fname+"."+acro+".txt");
      ArFree(fen);
      continue;
    }
    puts(fname+"."+acro+".txt: "+ArSize(fen));
    fputs("Название\tШирота\tДолгота\tПолное название\tГород\tРайон\tУлица\tНомер дома\tТелефон\tСайт\tЭлектронная Почта\tВремя работы\tИнформация\tКласс объекта\tКомментарий 1\tКомментарий 2\tДата начала рекламы\tДата окончания рекламы\tКоммерческое\n",fp);
    for( i=1; i<=ArSize(fen); i+=1 )
    {
      fe=ArGet(fen,i);
      if( !chGetFeatureNode(ch,fe,nd) )
        continue;
      chGetNodeXY(ch,nd,lat,lon);  
      if( !chGetAttrText(ch,fe,AT_LABELS,labels) )
        labels="";
      if( !chGetAttrText(ch,fe,AT_FULNAM,fulnam) )
        fulnam="";
    
      if( !chGetAttrText(ch,fe,AT_STRNAM,strnam) )
        strnam="";
      if( !chGetAttrText(ch,fe,AT_NUMBER,number) )
        number="";
    
      if( !chGetAttrText(ch,fe,AT_DSTNAM,dstnam) )
        dstnam="";
      if( !chGetAttrText(ch,fe,AT_TWNNAM,twnnam) )
        twnnam="";
      if( !chGetAttrText(ch,fe,AT_REGNAM,regnam) )
        regnam="";
      if( !chGetAttrText(ch,fe,AT_TERNAM,ternam) )
        ternam="";
    
      if( !chGetAttrText(ch,fe,AT_PHONES,phones) )
        phones="";
      if( !chGetAttrText(ch,fe,AT_FAXNUM,faxnum) )
        faxnum="";
      if( !chGetAttrText(ch,fe,AT_WEBPGE,webpge) )
        webpge="";
      if( !chGetAttrText(ch,fe,AT_EMAILS,emails) )
        emails="";
      if( !chGetAttrText(ch,fe,AT_PAIDES,paides) )
        paides="";
      else if( paides == "1"  )
        paides="1"; 
      if( !chGetAttrText(ch,fe,AT_OPTIME,optime) )
        optime="";
      if( !chGetAttrText(ch,fe,AT_BEGDAT,begdat) )
        begdat="";
      if( !chGetAttrText(ch,fe,AT_ENDDAT,enddat) )
        enddat="";
      
      if( !chGetAttrText(ch,fe,INFORM,inform) )
        inform="";
  
      if( !chGetAttrText(ch,fe,RECIND,recind) )
        recind="";
      if( !chGetAttrText(ch,fe,SORIND,sorind) )
        sorind="";
      //puts(labels+"^"+printf("%.6f^",lat)+printf("%.6f^",lon)+"^"+twnnam+"^"+dstnam+"^"+strnam+"^"+number+"^"+phones+"^"+webpge+"^^"+inform+"^"+acro+"^^");
     // fputs(labels+"^"+printf("%.6f^",lat)+printf("%.6f^",lon)+"^"+twnnam+"^"+dstnam+"^"+strnam+"^"+number+"^"+phones+"^"+webpge+"^^"+inform+"^"+acro+"^^^^^\n",fp);
      fputs(labels+"\t"+printf("%.6f\t",lat)+printf("%.6f\t",lon)+fulnam+"\t"+twnnam+"\t"+dstnam+"\t"+strnam+"\t"+number+"\t"+phones+"\t"+webpge+"\t"+emails+"\t"+optime+"\t"+inform+"\t"+acro+"\t"+recind+"\t"+sorind+"\t"+begdat+"\t"+enddat+"\t"+paides+"\t\n",fp);
    }
    fclose(fp);
    ArFree(fen);
  }
  ArFree(fes);
  FinishIndicator();
}
