include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET	1652
const ATTR_CODE_COLOR	1656
const ATTR_CODE_INFORM	102
const ATTR_CODE_SORDAT	147
const FIELD_DELIMITER	","
const START_LINE	7
const EDGE_MAX_LENGTH	1000
const MAX_POINTS_DIST	0.01

global main()
{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"PLT files (*.plt)|*.plt|All files  (*.*)|*.*||") != IDOK )
	{
		puts( "ERROR: Output file not found" );
		return;
	}

	if ( !(file = fopen( filename, "r" )) )
	{
		puts( "ERROR: Unable to open file" );
		return;
	}

	filename = StrRight( filename, StrLen(filename) - StrRFind(filename, "\\") );
	filename = "терк от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);

	chOpenBorder( ch );

	chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
	chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
	chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
	if ( StrLen(date) )
		chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
	edgeNum = 1;
	x0 = 0;
	y0 = 0;
	strVal0 = "";
	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;
	for ( i=1; i<START_LINE; i+=1 )
		if ( !fgets( str, 3200, file ) )
			break;
	while( fgets( str, 3200, file ) )
	{
		pos = StrFind( str, FIELD_DELIMITER );
		if ( pos == 0 )
		{
			puts( "ERROR: uncorrect format" );
			continue;
		}
		strVal = StrLeft( str, pos-1 );
		x = real(strVal);
		str = StrMid( str, pos+1 );
		pos = StrFind( str, FIELD_DELIMITER );
		if ( pos == 0 )
		{
			puts( "ERROR: uncorrect format" );
			continue;
		}
		strVal = StrLeft( str, pos-1 );
		y = real(strVal);
		for ( i=0; i<4; i+= 1 )
		{
			str = StrMid( str, pos+1 );
			pos = StrFind( str, FIELD_DELIMITER );
			if ( pos == 0 )
			{
				puts( "ERROR: uncorrect format" );
				continue;
			}
		}
		strVal = StrLeft( str, pos-1 );

		dX = x - x0;
		dY = y - y0;
		if ( (dX*dX + dY*dY >=  maxDistQ)
			||(StrICmp(strVal, strVal0) != 0 ) )
		{
			if ( edgeSize )	
			{
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				node = chCrtNode( ch, x, y );
				edge = chCrtEdge( ch, node, node );
				chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
				edgeNum += 1;
				edgeSize = 1;
			}
			x0 = x;
			y0 = y;
			strVal0 = strVal;
			continue;
		}
		x0 = x;
		y0 = y;
		strVal0 = strVal;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
			edgeNum += 1;
			edgeSize = 1;
		}
		else if ( edgeSize == EDGE_MAX_LENGTH )
		{
			node = chCrtNode( ch, x, y );
			chSetEdgeEnd( ch, edge, node );
			edge = chCrtEdge( ch, node, node );
			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize < EDGE_MAX_LENGTH )
	{
		lastX = 0;
		lastY = 0;
		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		node = chCrtNode( ch, lastX, lastY );
		chSetEdgeEnd( ch, edge, node );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}