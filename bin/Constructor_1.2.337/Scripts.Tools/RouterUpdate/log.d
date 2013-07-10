include <dKart.dh>
include <windows.dh>

const OBJ_CODE_STREET	1652
const ATTR_CODE_INFORM	102
const ATTR_CODE_SORDAT	147
const ATTR_CODE_COLOR	1656
const FIELD_DELIMITER	" "
//const EDGE_MAX_LENGTH	1000
//const MAX_POINTS_DIST	0.01
const MAX_HDOP			50

global main()
{

{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}




















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}


















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}

















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}

















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}



















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}


















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}
















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}













{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}













{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}
















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}














{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}












{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}













{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}











{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}













{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}


















{
	if( !(ch=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );
	filename = "";
	if( OpenFileDlg( filename,"","",-1,"log files (*.log)|*.log|All files  (*.*)|*.*||") != IDOK )
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
	filename = "трек от " + StrLeft( filename, StrRFind(filename, ".") - 1 );
	date = "";
	if ( GetDateTime(Long2DateTime(CurrentTime()), year, month, day, hour, min, sec) )
		date = str(day) + "." + str(month) + "." + str(year);
	
	chOpenBorder( ch );

	str = "";
	edgeSize = 0;
	edge = NULL;
	node = NULL;
//	edgeNum = 1;
	x0 = 0;
	y0 = 0;
//	maxDistQ = MAX_POINTS_DIST*MAX_POINTS_DIST;

	while( fgets( str, 3200, file ) )
	{
		if ( StrFind(str, "#") == 1 )
		{
/*			pos = StrFind( str, "started " );
			if ( pos > 0 )
			{
				str = StrMid( str, pos+8 );
				pos = StrFind( str, "." );
				if ( pos > 0 )
				{
					year = StrLeft( str, pos-1 );
					str = StrMid( str, pos+1 );
					pos = StrFind( str, "." );
					if ( pos > 0 )
					{
						month = StrLeft( str, pos-1 );
						str = StrMid( str, pos+1 );
						pos = StrFind( str, " " );
						if ( pos > 0 )
							date = StrLeft( str, pos-1 ) + "." + month + "." + year;
					}
				}
			}*/

			if ( edgeSize )	
			{
				chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
				chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
				if ( StrLen(date) )
					chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
				node = chCrtNode( ch, x0, y0 );
				chSetEdgeEnd( ch, edge, node );
				chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
//				edgeNum += 1;
				edgeSize = 0;
			}
			continue;
		}

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
		HDOP = real(StrMid( str, pos+1 ));
		if ( HDOP >= MAX_HDOP )
			continue;

		x0 = x;
		y0 = y;

		if ( !edgeSize )
		{
			node = chCrtNode( ch, x, y );
			edge = chCrtEdge( ch, node, node );
//			chIncFeatureLine( ch, chObjStreet, edgeNum, edge, NULL );
//			edgeNum += 1;
			edgeSize = 1;
		}
		else
		{
			edgeSize = chIncEdge( ch, edge, edgeSize, x, y  );
		}
	}

	if ( edgeSize )
	{
//		lastX = 0;
//		lastY = 0;
//		chGetEdgeXY( ch, edge, edgeSize-2, lastX, lastY );
		chObjStreet = chCrtFeature( ch, OBJ_CODE_STREET );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_INFORM, filename );
		chSetAttrText( ch, chObjStreet, ATTR_CODE_COLOR, "#0000FF" );
		if ( StrLen(date) )
			chSetAttrText( ch, chObjStreet, ATTR_CODE_SORDAT, date );
		node = chCrtNode( ch, x0, y0 );
		chSetEdgeEnd( ch, edge, node );
		chIncFeatureLine( ch, chObjStreet, 1, edge, NULL );
	}

	chFitBorder( ch );
	fclose( file );
	puts( "Conversion successfully compleated" );
}


}