include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET_1	60020 //GORODA   60160-STREET   60020-ADRESS    504-$texts    
//const OBJ_CODE_STREET_2 18166
/*const OBJ_CODE_STREET_3	18062
const OBJ_CODE_STREET_4	18044
const OBJ_CODE_STREET_5	18115
const OBJ_CODE_STREET_6	18033
const OBJ_CODE_STREET_7	18045
const OBJ_CODE_STREET_8	18013
const OBJ_CODE_STREET_9	18070 */

const ATTR_CODE_STREET	60030 //LABEL    61063-TWNNAM   1668-txtval



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
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, "  / ", " / ") );
		   contunue;

		   
		
	}

	
	/*
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_2 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, "Населённый пункт ", "") );
		   contunue;

		   
		
	} */
	
/*	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_3 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}
	
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_4 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}
	
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_5 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_6 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_7 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_8 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}
	
	
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_9 )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, " N", " ") );
		   contunue;

		   
		
	}*/
	puts( "Conversion successfully compleated" );
}