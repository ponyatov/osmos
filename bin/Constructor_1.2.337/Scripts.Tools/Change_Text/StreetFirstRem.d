include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET	60160
const ATTR_CODE_STREET	60020

//town name 61063
//region name	61065

//Это скрипт позволяет убирать надпись до какого-то знака.

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
		str2find = "," ;
		pos0 = StrFind( strAttr, str2find);
		if ( pos0 > 0 )
			chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrRight(strAttr, StrLen(strAttr)-StrLen(str2find)-pos0+1) );
	}

	puts( "Conversion successfully compleated" );
}