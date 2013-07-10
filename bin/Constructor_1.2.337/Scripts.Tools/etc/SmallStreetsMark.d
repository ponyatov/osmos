include <dKart.dh>
include <windows.dh>

const OBJ_CODE_SREET		1652
const ATTR_CODE_NAME		102
const ATTR_CODE_MARK		148

const LEN_METERS	300
const HAS_NAME      0

global main()
{

	if( !(chIn=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}

	chSetGeoUnits( 1 );

	chObj = NULL;
	rightTurns = 0;
	errTurns = 0;
	editedTurns = 0;
    chCompact( chIn, 0 );
	for ( chObj = chNextFeature( chIn, NULL ); chObj; chObj = chNextFeature( chIn, chObj ) )
	{
		if ( (chGetFeatureCode(chIn, chObj) != OBJ_CODE_SREET)
			||(chGetMetricType( chIn, chObj ) != M_LINE) )
			continue;

        if ( HAS_NAME == 1 )
        {
            attrVal = "";
		    chGetAttrText( chIn, chObj, ATTR_CODE_NAME, attrVal );
		    if ( StrLen(attrVal) > 0 )
                continue;
        }

		
		edge = NULL;
		flag = NULL;
		if  ( chGetFeatureLine(chIn, chObj, 0, edge, flag) != 1 )
            continue;
		nodeBeg = NULL;
		nodeEnd = NULL;
		chGetEdgeBegEnd( chIn, edge, nodeBeg, nodeEnd );
		arEdges = chGetEdgesOfNode( chIn, nodeBeg );
        sz1 = ArSize(arEdges);
		arEdges = chGetEdgesOfNode( chIn, nodeEnd );
        sz2 = ArSize(arEdges);
		
        if ( !((sz1 == 1)&&(sz2 > 2)
            ||(sz2 == 1)&&(sz1 > 2)) )
            continue;

	    x=0;
	    y=0;
    	num = chGetEdgeXY( chIn, edge, 0, x, y );
        if ( num < 2 )
            continue;

	    x1=0;
	    y1=0;
        dist = 0.;
        for ( i=1; i<num; i+=1 )
        {
            chGetEdgeXY( chIn, edge, i, x1, y1 );
            dx = x1-x;
            dy = y1-y;
            dist += sqrt(dx*dx + dy*dy);
            x = x1;
            y = y1;
        }
        
        if ( dist*111120 > LEN_METERS )
            continue;


        puts( "LINE# " + str(chObj-1) + " marked as 'del'" );
	    chSetAttrText( chIn, chObj, ATTR_CODE_MARK, "del" );
	}

    puts( "Conversion successfully compleated" );
}