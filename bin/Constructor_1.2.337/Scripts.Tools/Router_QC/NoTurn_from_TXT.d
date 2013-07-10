/* Скрипт подливает запреты поворот из текстового файла в dcf на СитиПлане 
Уникальные номера рёбер на должны быть указаны в объектах Street Center Line в атрибуте Recording Indication
Текстовый файл должне содержать 2 колонки с номерами. Первая - начальное ребро, вторая - конечное.
*/

include <dKart.dh>
include <windows.dh>

const OBJ_CODE_SREET		60160 //Street central line
const OBJ_CODE_SREET_2		1666  //no passage
const ATTR_CODE_ID			129   //148
const ATTR_CODE_DIR			1703  //102
const ATTR_CODE_ID2			129   //148



local GetNextToken( str, pos, strDel, bEnd )
{
	strVal = "";
	pos = StrFind( str, strDel );
	if ( pos == 0 )
	{
		strVal = StrMid( str, pos+1 );
        bEnd = 1;
	}
	else
	{
		strVal = StrLeft( str, pos-1 );
        bEnd = 0;
	}
	str = StrMid( str, pos+1 );
	return strVal;
}


global main()
{

	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	filename = "";
	if( OpenFileDlg( filename,"","",-1,"TXT files (*.txt)|*.txt|All files  (*.*)|*.*||") != IDOK )
	{
		puts( "ERROR: Input file not found" );
		return;
	}

	if ( !(file = fopen( filename, "r" )) )
	{
		puts( "ERROR: Unable to open file" );
		return;
	}

//	counter = 0;//!!
	while( fgets( str, 3200, file ) )
	{
//        counter += 1;//!!
//        if ( counter > 10 )//!!
//            break;//!!

		strVal = "";
		pos = 0;
        bEnd = 0;
/*        if ( !StrLen(GetNextToken(str, pos, "\t", bEnd)) )
            continue;
		pos += 1;
        if ( !StrLen(GetNextToken(str, pos, "\t", bEnd)) )
            continue;
		pos += 1;*/

		id1 = int(GetNextToken( str, pos, "\t", bEnd));
		pos += 1;

/*        if ( !StrLen(GetNextToken(str, pos, "\t", bEnd)) )
            continue;
		pos += 1;*/

        ArID2 = ArCreate( 0 );
        strID = GetNextToken( str, pos, "\t", bEnd );
        pos1 = 0;
        strID2 = StrReplace( GetNextToken(strID, pos1, "-", bEnd), "\"", "" );
        pos1 += 1;
        while ( !bEnd )
        {
            ArAdd( ArID2, int(strID2) );
            strID2 = GetNextToken( strID, pos1, "-", bEnd );
            pos1 += 1;
        }
        if ( StrLen(strID2) > 0 )
            ArAdd( ArID2, int(strID2) );
        
        if ( !ArSize(ArID2) )
        {
			puts( "ERROR: Unable get EdgeT ID-s" );
            ArFreeAll();
			continue;
        }

		edge1 = 0;
        ArEgde2 = ArCreate( 0 );
		for ( chObj = chNextFeature( ch, NULL ); chObj; chObj = chNextFeature( ch, chObj ) )
		{
			if ( (chGetFeatureCode(ch, chObj) != OBJ_CODE_SREET)
				||(chGetMetricType( ch, chObj ) != M_LINE) )
				continue;

			attrVal = "";
			chGetAttrText( ch, chObj, ATTR_CODE_ID, attrVal );
			if ( int(attrVal) == id1)
            {
			    edge = NULL;
			    flag = NULL;
			    if  ( chGetFeatureLine(ch, chObj, 0, edge, flag ) != 1 )
			    {
				    puts( "ERROR: Uncorrect street: line #" + str(chObj-1) );
				    continue;
			    }
				edge1 = edge;
				continue;
            }

            bAdd = 0;
            for ( i=0; i<ArSize(ArID2); i+=1 )
            {
                if ( ArGet(ArID2, i+1) == int(attrVal) )
                {
			        edge = NULL;
			        flag = NULL;
			        if  ( chGetFeatureLine(ch, chObj, 0, edge, flag ) != 1 )
			        {
				        puts( "ERROR: Uncorrect street: line #" + str(chObj-1) );
				        continue;
			        }
				    ArAdd( ArEgde2, edge );
                    bAdd = 1;
				    break;
                }
            }
            if ( bAdd )
                continue;

			if ( (edge1 != 0)
				&&(ArSize(ArEgde2) == ArSize(ArID2)) )
				break;
		}
		
		if ( (edge1 == 0)
			||(ArSize(ArEgde2) == 0) )
		{
            puts( "ERROR: Unable to find same id :" + str(id1) );
            ArFreeAll();
			continue;
		}

        for ( i=0; i<ArSize(ArEgde2); i+=1 )
        {
            if ( !(chOutObjStreet = chCrtFeature( ch, OBJ_CODE_SREET_2 )) )
		    {
			    puts( "ERROR: Unable to create street obj" );
                ArFreeAll();
			    continue;
		    }
		   // chSetAttrText( ch, chOutObjStreet, ATTR_CODE_DIR, "4" );
		    chSetAttrText( ch, chOutObjStreet, ATTR_CODE_ID2, str(id1) + " -> " + str(ArGet(ArEgde2, i+1)) );
			chSetAttrText( ch,chOutObjStreet,ATTR_CODE_DIR,"26");

            beg0 = NULL;
            end0 = NULL;
            chGetEdgeBegEnd( ch, edge1, beg0, end0 );
            beg1 = NULL;
            end1 = NULL;
            chGetEdgeBegEnd( ch, ArGet(ArEgde2, i+1), beg1, end1 );
            rev0 = 0;
            rev1 = 0;
            if ( beg0 == beg1 )
            {
                rev0 = M_REVERSE;
                rev1 = 0;
            }
            else if ( beg0 == end1 )
            {
                rev0 = M_REVERSE;
                rev1 = M_REVERSE;
            }
            else if ( end0 == beg1 )
            {
                rev0 = 0;
                rev1 = 0;
            }
            else if ( end0 == end1 )
            {
                rev0 = 0;
                rev1 = M_REVERSE;
            }

/*            puts( str(edge1) + " " + str(beg0) + " " + str(end0) );
            puts( str(ArGet(ArEgde2, i+1)) + " " + str(beg1) + " " + str(end1) );
            puts( str(rev0) + " " + str(rev1) );
            puts( "==================" );*/
		    chIncFeatureLine( ch, chOutObjStreet, 1, edge1, rev0 );
		    chIncFeatureLine( ch, chOutObjStreet, 2, ArGet(ArEgde2, i+1), rev1 );
        }

        ArFreeAll();
	}


//	CloseDataset( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}