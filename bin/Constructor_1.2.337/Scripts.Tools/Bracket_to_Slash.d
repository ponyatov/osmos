include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET_1	60160  //STREET
const OBJ_CODE_STREET_2	60020  //ADRESS
const ATTR_CODE_STREET_1	60030  //Street Name
const ATTR_CODE_STREET_2	60030  //Street Name
const ATTR_CODE_STREET_3	60010   //Proper name  OBNAME


global main()
{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_1 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET_1, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET_1, StrReplace(strAttr, ")", "") );
		   contunue;

		   
		
	}


	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_1 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET_1, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET_1, StrReplace(strAttr, " (", ", ") );
		   contunue;

		   
		
	}

	
	
	
//ProperName	
	
		if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_1 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET_3, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET_3, StrReplace(strAttr, ")", "") );
		   contunue;

		   
		
	}


	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_1 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET_3, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET_3, StrReplace(strAttr, " (", ", ") );
		   contunue;

		   
		
	}
	
	
	
	
	
//Конец ProperName		
	
	
	
	
	
	
		if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_2 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET_2, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET_2, StrReplace(strAttr, ")", "") );
		   contunue;

		   
		
	}


	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_2 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET_2, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET_2, StrReplace(strAttr, " (", ", ") );
		   contunue;

		 
		
	}
	 

	puts( "Conversion successfully compleated" );
}