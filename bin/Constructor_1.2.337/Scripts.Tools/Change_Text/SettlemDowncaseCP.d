include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET	504 //18108
const ATTR_CODE_NAME_1	1668 //17501



local StrDowncase( str )
{
		strTail = str;
		strTail = StrLwr( strTail );
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		return strTail;
}

local StrUppercase( str )
{
		strTail = str;
		strTail = StrUpr( strTail );
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		strTail = StrReplace( strTail, "�", "�");
		return strTail;
}

local GetNextToken( str )
{
	strVal = "";
	pos = StrFind( str, " " );
	pos1 = StrFind( str, "(" );
	pos2 = StrFind( str, ")" );
	pos3 = StrFind( str, "." );
    if ( (pos3 > 0)
        &&(pos3 < pos ) )
        pos = pos3;

	if ( pos == 0 )
		pos = pos1;
	if ( pos == 0 )
		pos = pos2;
	
	if ( (pos1 > 0)
		&&(pos1 < pos) )
		pos = pos1;
	if ( (pos2 > 0)
		&&(pos2 < pos) )
		pos = pos2;

	if ( pos == 0 )
	{
		strVal = str;
		str = "";
	}
	else
	{
		strVal = StrLeft( str, pos-1 );
		str = StrRight( str, StrLen(str)-pos+1 );
	}
	return strVal;
}

local ChangeStr( strAttr )
{
	strNewAttr = "";
	while ( StrLen(strAttr) > 0 )
	{
		strToken = GetNextToken( strAttr );
		if ( (StrLen(strToken) > 0) )
		{
			strNewAttr += StrUppercase(StrLeft(strToken,1)) + StrDowncase(StrRight(strToken, StrLen(strToken)-1));
			if ( StrLen(strAttr) > 0 )
			{
				strNewAttr += StrLeft(strAttr,1);
				strAttr = StrRight(strAttr, StrLen(strAttr)-1);
			}
		}
		else
		{
			if ( StrLen(strAttr) > 0 )
			{
				strNewAttr += StrLeft(strAttr,1);
				strAttr = StrRight(strAttr, StrLen(strAttr)-1);
			}
		}
	}

    return strNewAttr;
}

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
		if ( chGetAttrText(ch, chObj, ATTR_CODE_NAME_1, strAttr)
			&&(StrLen(strAttr) > 0) )
        {
    		chSetAttrText( ch, chObj, ATTR_CODE_NAME_1, ChangeStr(strAttr) );
        }
	/*	strAttr = "";
		if ( chGetAttrText(ch, chObj, ATTR_CODE_NAME_2, strAttr)
			&&(StrLen(strAttr) > 0) )
        {
    		chSetAttrText( ch, chObj, ATTR_CODE_NAME_2, ChangeStr(strAttr) );
        }
		strAttr = "";
		if ( chGetAttrText(ch, chObj, ATTR_CODE_NAME_3, strAttr)
			&&(StrLen(strAttr) > 0) )
        {
    		chSetAttrText( ch, chObj, ATTR_CODE_NAME_3, ChangeStr(strAttr) );
        }*/

/*		iPos = StrFind( strAttr, "(" );
		if ( iPos > 0 )
		{
			strTail1 = StrMid( strAttr, 2, iPos - 1 );
			strTail2 = StrRight( strAttr, StrLen(strAttr)-iPos-1 );
			strAttr = StrUpr(StrLeft(strAttr,1)) + StrDowncase(strTail1) 
					+ StrUpr(StrMid(strAttr, iPos+1, 1)) + StrDowncase(strTail2);
		}
		else
		{
	 		strTail = StrRight(strAttr,StrLen(strAttr)-1);
			strAttr = StrUpr(StrLeft(strAttr,1)) + StrDowncase(strTail);
		}*/

	}

	puts( "Conversion successfully compleated" );
}