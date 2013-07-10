include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET	60160
const ATTR_CODE_STREET	300 //REGNAM
//const OBJ_CODE_STREET - код где нужно убрать инфу после определенного знака.

global main()
{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}
	
	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET )
			continue;

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		pos0 = StrFind( strAttr, "," );
		if ( pos0 > 0)
			chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrLeft(strAttr, pos0-1) );
	}

	puts( "Conversion successfully compleated" );
}