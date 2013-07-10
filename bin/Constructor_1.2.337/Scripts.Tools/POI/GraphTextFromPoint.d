include <dKart.dh>

const OBJ_CODE			60020 //18007
const OBJ_CODE_TEXT		504
const ATTR_CODE_TEXT_IN		1668
const ATTR_CODE_TEXT_OUT	1668
//const ATTR_CODE_POICAT_IN  61068
//const ATTR_CODE_POICAT_OUT  61068

const ATTR_CODE_COLOR_IN 1656
const ATTR_CODE_COLOR_OUT 1656

global main()
{
    if( !(chDst=GetEditDataset()) )
    {
       puts( "No active dataset" );
       return "No dst";
    }

    for( fe=0; fe=chNextFeature(chDst,fe); )
    {
	if (chGetFeatureCode(chDst,fe) != OBJ_CODE ) //закомментировано, чтобы срабатывал на все категории пои
		continue;

	strAttr = "";
      chGetAttrText(chDst,fe,ATTR_CODE_TEXT_IN,strAttr);
	
	if ( !StrLen(strAttr) )
		continue;

	mType = chGetMetricType( chDst, fe );
	feText = NULL;
	if ( mType == M_POINT )
	{
		node = NULL;
		if ( chGetFeatureNode(chDst, fe, node) )
		{
			feText = chCrtFeature( chDst, OBJ_CODE_TEXT );
			chSetFeatureNode( chDst, feText, node );
		}
	}
	
	if ( !feText )
		continue;
/* атрибуты для пои
	chSetAttrText( chDst,feText, ATTR_CODE_TEXT_OUT, strAttr );
	
	chSetAttrText( chDst,feText, 1661,"7");//chSetAttrText(ch,fe,1661,"7");	       //font heigh
	chSetAttrText( chDst,feText, 1671,"2,5");	       //fntstl
	chSetAttrText( chDst,feText, 1659,"-300");	       //shiftx
    chSetAttrText( chDst,feText, 1666,"3");	       //justh
	chSetAttrText( chDst,feText, 1656,"#A0522D");	       //color
    chSetAttrText( chDst,feText, 1703,"26");       // scalvl
    chSetAttrText( chDst,feText, 1653,"909");      // priort
	chSetAttrText( chDst,feText, 133,"40000");      // scale minimum
*/

//  атрибуты для номеров домиков из класса Address. Нужны в тех случаях, когда адреска из польского линейная, 
// но есть данные по номерам домов из полигонов, которые в поиске не участвуют, только отрисовка. Как в Молдове.
	chSetAttrText( chDst,feText, ATTR_CODE_TEXT_OUT, strAttr );
	
	chSetAttrText( chDst,feText, 1661,"7");//chSetAttrText(ch,fe,1661,"7");	       //font heigh
	chSetAttrText( chDst,feText, 1656,"#000000");	       //color
    chSetAttrText( chDst,feText, 1703,"26");       // scalvl
    chSetAttrText( chDst,feText, 1653,"909");      // priort
	chSetAttrText( chDst,feText, 133,"20000");      // scale minimum

	
/*
	// условие для переноса POI category name из точек в тексты	
	strAttr2 = "";
      chGetAttrText(chDst,fe,ATTR_CODE_POICAT_IN,strAttr2);
	
	if ( !StrLen(strAttr2) )
		continue;
	
	chSetAttrText( chDst,feText, ATTR_CODE_POICAT_OUT, strAttr2 );      // POI category name
// конец условия

*/

   }
    puts("OK");
}
