// [private]
function _Log2 (_dw) {
	if (_dw <= 0)
		return 0;

	var log2 = 0;
	while (_dw != 0) {
		++ log2;
		_dw >>= 1;
	}
	return log2;
}

//
// _y     - is in degrees
// _scale - is in meters per pixel
//
function GetStdLevel (_y, _scale) {
	var fCosY = Math.cos (_y*Math.PI/180);
	return _Log2 (Math.floor (40e6*fCosY/_scale)) - 8 - 1;
}
