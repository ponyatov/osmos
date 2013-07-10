const ATTR_CODE_STREET	61062 //Proper name //60030
const ATTR_CODE_TOWN	61065 //RECIND  //102

global main()
{

  if( !(chDst=GetEditDataset()) )
    {
       puts( "No active dataset" );
       return "No dst";
    }

    strname = "";
    townname = "";

  for( fe=0; fe=chNextFeature(chDst,fe); )
  {
      	if( !chGetAttrText(chDst,fe,ATTR_CODE_STREET,strname) )
		strname = "";
      	if( !chGetAttrText(chDst,fe,ATTR_CODE_TOWN,townname) )
		townname = "";
	//finalstr = strname+" ("+townname+")";

	if ( strname != "" && townname != "" && townname != "street" )
	{
	//	chSetAttrText(chDst,fe,ATTR_CODE_STREET,"~[0x02]"+townname );
		chSetAttrText(chDst,fe,ATTR_CODE_TOWN,strname);
	}
	strname = "";
	townname="";
  }
  puts("OK");
}
