// NOTE: Based on EPSG:3857

function LonToX (_x, _level) {
	var nBitmapSize = 256 << _level;
	return Math.floor (nBitmapSize/2 + _x*nBitmapSize/360. + .5);
}

function LatToY (_y, _level) {
	var nBitmapSize = 256 << _level;

	var z = Math.sin (_y*Math.PI/180);
	if (z == -1)
		z = -0.99999;
	else if (z == 1)
		z = 0.99999;
	return Math.floor (nBitmapSize/2 - .5*Math.log ((1 + z)/(1 - z))*nBitmapSize/(2*Math.PI) + .5);
}

function XToLon (_x, _level) {
	var nBitmapSize = 256 << _level;
	return (_x - nBitmapSize/2)/(nBitmapSize/360.);
}

function YToLat (_y, _level) {
	var nBitmapSize = 256 << _level;
	var z = (_y - nBitmapSize/2)/(-nBitmapSize/(2*Math.PI));
	return (2*Math.atan (Math.exp (z)) - Math.PI/2)*180/Math.PI;
}
