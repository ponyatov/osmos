// Скрипт-автозамена. Срабатывает толкьо на значение атрибута, независимо от класса объекта

include <dKart.dh>
include <windows.dh>



const ATTR_CODE_STREET	133



global main()
{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
	{
		/*if ( chGetFeatureCode(ch, chObj) != OBJ_CODE_STREET_1 )
			continue; */

		strAttr = "";
		if ( !chGetAttrText(ch, chObj, ATTR_CODE_STREET, strAttr)
			||!StrLen(strAttr) )
			continue;
		chSetAttrText( ch, chObj, ATTR_CODE_STREET, StrReplace(strAttr, "50000000", "20000") );
		   contunue;

		   
		
	}

	

	puts( "Conversion successfully compleated" );
}