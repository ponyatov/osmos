function _ExtractScripts (_pHTMLDocument2) {
	if (_pHTMLDocument2 == null)
		return "";

	var strScripts = "";
	var pScripts = _pHTMLDocument2.scripts;
	var lScripts = pScripts.length;
	for (var lScript = 0; lScript < lScripts; ++ lScript) {
	//for (pElement in pScripts) {
		var pElement = pScripts.item (lScript, 0);
		if (! pElement)
			continue;

		strScripts += pElement.innerHTML;
	}
	return strScripts;
}
