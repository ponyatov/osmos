// NOTE: Based on EPSG:3395

// Earth radius, in meters.
var R = 6378137.0;

// Half of equator, in meters;
var Eh = R*Math.PI;

var K = (1 << 30)/Eh; //=53.5865938;

// [private]
function _Merc2GeoX (_x) {
	return (_x/R)*180/Math.PI;
}

// [private]
function _Geo2MercX (_x) {
	return _x*Math.PI/180*R;
}

// [private]
function _Merc2GeoY (_y) {
	var K = 0.003356551468879694;
	var H = 0.00000657187271079536;
	var E = 1.764564338702e-8;
	var J = 5.328478445e-11;
	var D = Math.PI/2 - 2*Math.atan (1/Math.exp (_y/R));
	var latitude = D + K*Math.sin (2*D) + H*Math.sin (4*D) + E*Math.sin (6*D) + J*Math.sin (8*D);

	if (latitude > Math.PI/2)
		latitude = Math.PI/2;
	if (latitude < -Math.PI/2)
		latitude = -Math.PI/2;
	return latitude*180/Math.PI;
}

// [private]
function _Geo2MercY (_y) {
	if (_y >= 85)
		_y = 85;
	if (_y <= -85)
		_y = -85;

	var I = _y*Math.PI/180;
	var G = 0.0818191908426;
	var B = G*Math.sin (I);
	var D = Math.tan (Math.PI/4 + I/2);
	var F = Math.pow (Math.tan (Math.PI/4 + Math.asin (B)/2), G);
	return Math.floor (R*Math.log (D/F));
}

// [private]
function _Merc2TileX (_merc_x) {return Math.floor ((Eh + _merc_x)*K);}
function _Merc2TileY (_merc_y) {return Math.floor ((Eh - _merc_y)*K);}
function _Tile2MercX (_tile_x) {return _tile_x/K - Eh;}
function _Tile2MercY (_tile_y) {return Eh - _tile_y/K;}

function XToLon (_x, _level) {return _Merc2GeoX (_Tile2MercX (_x   * (1 << (23 - _level))));}
function YToLat (_y, _level) {return _Merc2GeoY (_Tile2MercY (_y   * (1 << (23 - _level))));}

function LonToX (_x, _level) {return _Merc2TileX (_Geo2MercX (_x)) / (1 << (23 - _level));}
function LatToY (_y, _level) {return _Merc2TileY (_Geo2MercY (_y)) / (1 << (23 - _level));}
