// NOTE: Based on EPSG:3857

// Earth radius, in meters.
var R = 6378137.0;

// [private]
function _LonToMercX (_x) {return _x*Math.PI/180*R;}

// [private]
function _LatToMercY (_y) {
	var z = Math.sin (_y*Math.PI/180);
	if (z == -1)
		z = -0.99999;
	else if (z == 1)
		z = 0.99999;
	return .5*Math.log ((1 + z)/(1 - z))*R;
}
