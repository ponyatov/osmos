include <dKart.dh>
include <windows.dh>

global main()
{

	if( !(chIn=GetEditDataset()) )
	{
		puts( "ERROR: Unable to load active chart" );
		return;
	}
	

    puts ( "nodes: " + str(chNodeNum(chIn)) );
    puts ( "edges: " + str(chEdgeNum(chIn)) );
    puts ( "objs: " + str(chFeatureNum(chIn)) );
	}