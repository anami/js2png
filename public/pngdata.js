function loadPNGData(strFilename, fncCallback) {
	// test for canvas and getImageData
	var bCanvas = false;
	var oCanvas = document.createElement("canvas");
	if (oCanvas.getContext) {
		var oCtx = oCanvas.getContext("2d");
		if (oCtx.getImageData) {
			bCanvas = true;
		}
	}
	if (bCanvas) {
		var oImg = new Image();
		oImg.style.position = "absolute";
		oImg.style.left = "-10000px";
		document.body.appendChild(oImg);
		oImg.onload = function() {
			var iWidth = this.offsetWidth;
			var iHeight = this.offsetHeight;
			oCanvas.width = iWidth;
			oCanvas.height = iHeight;
			oCanvas.style.width = iWidth+"px";
			oCanvas.style.height = iHeight+"px";
			var oText = document.getElementById("output");
			oCtx.drawImage(this,0,0);
			var oData = oCtx.getImageData(0,0,iWidth,iHeight).data;
			var a = [];
			var len = oData.length;
			var p = -1;
			for (var i=0;i<len;i+=4) {
				if (oData[i] > 0)
					a[++p] = String.fromCharCode(oData[i]);
			};
			var strData = a.join("");
			if (fncCallback) {
				fncCallback(strData);
			}
			document.body.removeChild(oImg);
		}
		oImg.src = strFilename;
		return true;
	} else {
		return false;
	}
}
