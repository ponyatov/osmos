include <system.dh>
include <LookUp2DInc.dh>

const AT_LABELS 17501
/*const AT_PHONES 17502
const AT_FAXNUM 17503
const AT_WEBPGE 17504
const AT_EMAILS 17505
const AT_NUMBER 60040*/
const AT_STRNAM 60030
const AT_DSTNAM 61062
const AT_TWNNAM 61063
const AT_TERNAM 61064
const AT_REGNAM 61065
const AT_ORIEN1 1705
const AT_DISTN1 1706
const AT_ORIEN2 1707
const AT_DISTN2 1708

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
   // if( code >= 18000 && code < 18900 )
	if( code >= 18000 && code < 18937 )
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
	fputs("Название\tШирота\tДолгота\tИнфо\tГород\tРайон\tУлица\tУгол_1\tРасстояние_1\tУгол_2\tРасстояние_2\tКатегория\n",fp);
    for( i=1; i<=ArSize(fen); i+=1 )
    {
      fe=ArGet(fen,i);
      if( !chGetFeatureNode(ch,fe,nd) )
        continue;
      chGetNodeXY(ch,nd,lat,lon);  
     if( !chGetAttrText(ch,fe,AT_LABELS,labels) )
        labels="";
  /*     if( !chGetAttrText(ch,fe,AT_PHONES,phones) )
        phones="";
      if( !chGetAttrText(ch,fe,AT_FAXNUM,faxnum) )
        faxnum="";
      if( !chGetAttrText(ch,fe,AT_WEBPGE,webpge) )
        webpge="";
      if( !chGetAttrText(ch,fe,AT_EMAILS,emails) )
        emails="";
      if( !chGetAttrText(ch,fe,AT_NUMBER,number) )
        number=""; */
      if( !chGetAttrText(ch,fe,AT_STRNAM,strnam) )
        strnam="";
      if( !chGetAttrText(ch,fe,AT_DSTNAM,dstnam) )
        dstnam="";
      if( !chGetAttrText(ch,fe,AT_TWNNAM,twnnam) )
        twnnam="";
      if( !chGetAttrText(ch,fe,AT_TERNAM,ternam) )
        ternam="";
      if( !chGetAttrText(ch,fe,AT_REGNAM,regnam) )
        regnam="";
      if( !chGetAttrText(ch,fe,INFORM,inform) )
        inform="";
	
	// для дорожных знаков
	     if( !chGetAttrValue(ch,fe,1705,orien1) )
        orien1="";
	     if( !chGetAttrValue(ch,fe,1706,distn1) )
        distn1="";		
		if( !chGetAttrValue(ch,fe,1707,orien2) )
        orien2="";
		if( !chGetAttrValue(ch,fe,1708,distn2) )
        distn2="";
		
	//конец для дорожных знаков
	
	
 	 fputs(labels+"\t"+printf("%.6f\t",lat)+printf("%.6f\t",lon)+inform+"\t"+twnnam+"\t"+dstnam+"\t"+strnam+"\t"+orien1+"\t"+distn1+"\t"+orien2+"\t"+distn2+"\t"+acro+"\n",fp);  
   }
    fclose(fp);
    ArFree(fen);
  }
  ArFree(fes);
  FinishIndicator();
}
