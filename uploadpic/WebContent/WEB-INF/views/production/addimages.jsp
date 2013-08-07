<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!--<link rel="stylesheet" type="text/css" href="../../../resources/production.css">-->
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>

<script type="text/javascript"
	src='<c:url value="/resources/uploader.js"/>'></script>
<style type="text/css">
ul {
	list-style: none;
	list-style-type: none;
	margin: 0;
	padding: 0
}

ol {
	list-style: none;
	list-style-type: none
}

li {
	text-align: justify
}

table {
	border: medium;
	border-width: medium
}

#fileList {
	vertical-align: middle;
	margin: 0 auto;
	text-align: right;
}

#fileselect {
	width: auto;
}

#preview_size_fake{ 
    filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);    
    visibility:hidden;
}
</style>
<script language="JavaScript">
	var BlobBuilder = (window.MozBlobBuilder || window.WebKitBlobBuilder || window.BlobBuilder);
	function createObjectURL ( file ) {
	    if ( window.webkitURL ) {
	        return window.webkitURL.createObjectURL( file );
	    } else if ( window.URL && window.URL.createObjectURL ) {
	        return window.URL.createObjectURL( file );
	    } else {
	        return null;
	    }
	}

	var browserVersion= window.navigator.userAgent.toUpperCase();
	fdarray=[];
	var imgs=[];
	var loadelement = document.createElement("p");
	loadelement.innerHTML = "loading...";
	//take ie8 and below
	if(!Array.prototype.indexOf){
	    Array.prototype.indexOf= function(what, i){
	        i= i || 0;
	        var L= this.length;
	        while(i< L){
	            if(this[i]=== what) return i;
	            ++i;
	        }
	        return -1;
	    }
	}
	function donothing(){
		for(var i=0; i<4;i++){}
	}
	
	function removeIndex(array, item){
	    for(var i in array){
	        if(i==item){
	            array.splice(i,1);
	            break;
	            }
	    }
	}
	
	function stopBubble(e) {
		
		var e = e ? e : window.event;
		var browserVersion= window.navigator.userAgent.toUpperCase();
		if (window.event) { // IE  
			e.cancelBubble = true;	
		} else { // FF  
			//e.preventDefault();   
			e.stopPropagation();
		}
		if(browserVersion.indexOf("MSIE 9.0")>-1 || browserVersion.indexOf("MSIE 10.0")>-1){
			e.cancelBubble = true;
			e.stopPropagation();
		}		
		if(browserVersion.indexOf("MSIE 7.0")>-1 || browserVersion.indexOf("MSIE 8.0")>-1){
			e.cancelBubble = true;
		}
	}
	
	Array.fromSequence= function(seq) {
	    var arr= new Array(seq.length);
	    for (var i= seq.length; i-->0;)
	        if (i in seq)
	            arr[i]= seq[i];
	    return arr;
	};
	
	function IsRequestSuccessful (httpRequest) {
        // IE: sometimes 1223 instead of 204
    var success = (httpRequest.status == 0 || 
        (httpRequest.status >= 200 && httpRequest.status < 300) || 
        httpRequest.status == 304 || httpRequest.status == 1223);
    
    return success;
}
	function refreshParent() {
		var URL = unescape(window.opener.location.pathname);
		var PARMS = unescape(window.opener.location.search);

		var ms = new Date().getTime();
		window.opener.location.href = "/TestSession/" + PARMS;
		//window.close();
	}
	
	function clacImgZoomParam( maxWidth, maxHeight, width, height ){  
	    var param = { width:width, height:height, top:0, left:0 };  
	      
	    if( width>maxWidth || height>maxHeight ){  
	        rateWidth = width / maxWidth;  
	        rateHeight = height / maxHeight;  
	          
	        if( rateWidth > rateHeight ){  
	            param.width =  maxWidth;  
	            param.height = height / rateWidth;  
	        }else{  
	            param.width = width / rateHeight;  
	            param.height = maxHeight;  
	        }  
	    }  
	    param.left = (maxWidth - param.width) / 2;  
	    param.top = (maxHeight - param.height) / 2;  
	    return param;  
	}
	
	function autoSizePreview(objPre, originalWidth, originalHeight,maxWidth, maxHeight){
		
	    var zoomParam = clacImgZoomParam( maxWidth, maxHeight, originalWidth, originalHeight );  
	    objPre.style.width = zoomParam.width + 'px';  
	    objPre.style.height = zoomParam.height + 'px';  
	    //objPre.style.marginTop = zoomParam.top + 'px';  
	    //objPre.style.marginLeft = zoomParam.left + 'px';  
	} 

	function changelargepic(event) {
		var imgpre = document.createElement("img");
		imgpre.src = event.data.element.src;

		fileselect.innerHTML = "";
		fileselect.appendChild(imgpre);
		//imgpre.setAttribute("style", event.data.element.style);
		//imgpre.max-width="100%";
		//imgpre.max-height="100%";
		imgpre.setAttribute("style", "max-width:100%; max-height:100%;");
	}
	
	function changelargepicIE(event) {
		var imgpre = document.createElement("img");
		imgpre.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,"
				+"src='"+event.data.element.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src+"')";
		//var imgpre = document.getElementById("fileselect").getElementsByTagName("img");
		//alert($($(event.data.element).style).val());
		//imgpre.css( $(event.data.element.style));
		//imgpre.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src=
		//	event.data.element.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src;
		var widthrate=event.data.element.width/350; 
		var heightrate=event.data.element.height/430;
        if( widthrate > heightrate){  
        	imgpre.style.width =  350+"px";  
        	imgpre.style.height = event.data.element.height / widthrate+"px";  
        }else{  
        	imgpre.style.height =  430+"px";  
        	imgpre.style.width= event.data.element.width / heightrate+"px";   
        }
        imgpre.src="<c:out value="${pathres}"/>/transparent.gif";
		fileselect.innerHTML = "";
		fileselect.appendChild(imgpre);
		//imgpre.setAttribute("style", "max-width:100%; max-height:100%;");
	}

	function GetFileInfo() {
		//var fileInput = document.getElementById("fileinput");

		var message = "";
		if ('files' in fileInput) {
			if (fileInput.files.length == 0) {
				message = "Please browse for one or more files.";
			} else {
				message += "<br /><b>" + fileInput.files.length
						+ " files</b><br />";
				for ( var i = 0; i < fileInput.files.length; i++) {
					message += "<br /><b>" + (i + 1) + ". file</b><br />";
					var file = fileInput.files[i];
					if ('name' in file) {
						message += "name: " + file.name + "<br />";
					} else {
						message += "name: " + file.fileName + "<br />";
					}
					if ('size' in file) {
						message += "size: " + file.size + " bytes <br />";
					} else {
						message += "size: " + file.fileSize + " bytes <br />";
					}
					if ('mediaType' in file) {
						message += "type: " + file.mediaType + "<br />";
					}
				}
			}
		} else {
			if (fileInput.value == "") {
				message += "Please browse for one or more files.";
				message += "<br />Use the Control or Shift key for multiple selection.";
			} else {
				message += "Your browser doesn't support the files property!";
				message += "<br />The path of the selected file: "
						+ fileInput.value;
			}
		}

		alert(message);
	}
	
	function removefilepic(e) {

		stopBubble(e);
		var lis=document.getElementsByTagName("li");
		var object_for_remove = e.data.element.parentNode;
		var tmparr= Array.fromSequence( lis);
		var index= tmparr.indexOf(object_for_remove);
		//alert(objct_for_remove.innerHTML);
		object_for_remove.parentNode.removeChild(object_for_remove);
		fileselect.innerHTML = "<p>No files selected!</p>";
		removeIndex(fdarray, index);
	}

	function loading(node,loadelement) {
		while (node.hasChildNodes()) {
			node.removeChild(node.lastChild);
		}
		node.appendChild(loadelement);
	}

	

	function handleFiles(files) {
		
		if (!files.length) {
			$("#fileList").innerHTML = "";
			$("#fileselect").innerHTML = "<p>No files selected!</p>";
		} else {
			//loading(document.getElementById("fileselect"),loadelement);
			var list = document.createElement("ol");

			for ( var i = 0; i < files.length; i++) {
				//add file to ajax formdata
				var fd = new FormData();
				fd.append("fileinput", files[i]);
				fdarray.push(fd);
				
				var li = document.createElement("li");
				list.appendChild(li);
				var table = document.createElement("table");
				var tr = document.createElement("tr");
				var td = document.createElement("td");
				var img = document.createElement("img");
				img.file=files[i];
				img.src = createObjectURL(files[i]);
				img.setAttribute("alt", files[i].name);
				img.height = 70;
				img.className = "listpic";
				td.appendChild(img);

				tr.appendChild(td);
				td.setAttribute("rowspan", "2");
				$(li).on("click", {element : img}, changelargepic);
				var info = document.createElement("span");

				var sOutput = files[i].size + " bytes";
				// optional code for multiples approximation
				for ( var aMultiples = [ "KiB", "MiB", "GiB" ], nMultiple = 0, nApprox = files[i].size / 1024; nApprox > 1; nApprox /= 1024, nMultiple++) {
					sOutput = nApprox.toFixed(2) + " " + aMultiples[nMultiple];
				}

				table.setAttribute("style", "right:0px; top: 0px;");
				var td1 = document.createElement("td");
				var linked = document.createElement("input");
				linked.setAttribute("type", "button");
				td1.appendChild(linked);
				tr.appendChild(td1);
				table.appendChild(tr);
				linked.setAttribute("style", " right: 5px ;top: 5px;");
				linked.setAttribute("value", "remove me");
				//var linked = document.createElement("a");
				//linked.innerHTML="remove me";
				//linked.ref="#";
				$(linked).on("click", {element : table}, removefilepic);

				info.innerHTML = files[i].name + ": " + sOutput;
				var tr1 = document.createElement("tr");
				var td2 = document.createElement("td");
				td2.appendChild(info);
				tr1.appendChild(td2);
				table.appendChild(tr1);
				li.appendChild(table);
				//var newObject = jQuery.extend(true, {}, element);
			}

			var imgpre = new Image();

			imgpre.src = createObjectURL(files[files.length - 1]);
			imgpre.setAttribute("style","max-width:100%; max-height:100%;margin:auto;");
			document.getElementById("fileselect").innerHTML = "";
			document.getElementById("fileselect").appendChild(imgpre);
			document.getElementById("fileList").appendChild(list);
			
		}

	}
	
	function Validate(image) {
		
		if (image != '') {
			var checkimg = image.toLowerCase();
			if (!checkimg.match(/(\.jpg|\.png|\.JPG|\.PNG|\.jpeg|\.JPEG)$/)) {
				alert("Please enter  Image  File Extensions .jpg,.png,.jpeg");
				document.getElementById("image").focus();
				return false;
			}
		}
		return true;
	}
	
	
	//for ie 7, 8, 9
	function handleSingleFile(ele){
		//var fd = new FormData();
		//fd.append("fileinput", file);
		//fdarray.push(fd);
		
		var list = document.createElement("ol");
		var li = document.createElement("li");
		
		var table = document.createElement("table");
		var tr = document.createElement("tr");
		var td = document.createElement("td");
		img = document.createElement("img");
		
		ele.select();
		ele.blur();
		var source=document.selection.createRange().text;
		var arrayname=source.split('\\');
		
		var style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale', src='file:///"+
		unescape(source)+"')";
		img.setAttribute("style", style);
		img.file=source;
		//img.setAttribute("alt", arrayname[arrayname.length-1]);
		objPreviewSizeFake = document.getElementById( 'preview_size_fake' );
		objPreviewSizeFake.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = source;
		setTimeout("autoSizePreview( img,  objPreviewSizeFake.offsetWidth, objPreviewSizeFake.offsetHeight, 160, 70)", 1000);
		
		autoSizePreview( img,  objPreviewSizeFake.offsetWidth, objPreviewSizeFake.offsetHeight, 160, 70);
		//alert(img.offsetWidth);
		img.className = "listpic";
		td.appendChild(img);
		
		tr.appendChild(td);
		td.setAttribute("rowspan", "2");
		$(li).on("click", {element : img}, changelargepicIE);
		var info = document.createElement("span");
		table.setAttribute("style", "right:0px; top: 0px;");
		var td1 = document.createElement("td");
		
		var linked = document.createElement("input");
		linked.setAttribute("type", "button");
	    ele.setAttribute("style","display:none");
	    td1.appendChild(ele);
		td1.appendChild(linked);
		tr.appendChild(td1);
		table.appendChild(tr);
		linked.setAttribute("style", " right: 5px ;top: 5px;");
		linked.setAttribute("value", "remove me");
		$(linked).on("click", {element : table}, removefilepic);
		
		info.innerHTML = arrayname[arrayname.length-1];
		var tr1 = document.createElement("tr");
		var td2 = document.createElement("td");
		td2.appendChild(info);
		tr1.appendChild(td2);
		table.appendChild(tr1);
		li.appendChild(table);
		list.appendChild(li);
		imgpre = new Image();

		imgpre.setAttribute("style", style);
		imgpre.src="<c:out value="${pathres}"/>/transparent.gif";
		img.src="<c:out value="${pathres}"/>/transparent.gif";
		autoSizePreview( imgpre,  objPreviewSizeFake.offsetWidth, objPreviewSizeFake.offsetHeight, 350, 430);
		setTimeout("autoSizePreview( imgpre,  objPreviewSizeFake.offsetWidth, objPreviewSizeFake.offsetHeight, 350, 430)", 1000);
		document.getElementById("fileselect").innerHTML = "";
		document.getElementById("trigg").innerHTML='<input type="file" name="fileinput" multiple onchange="handleEle(this)" accept="image/*" />';
		document.getElementById("fileselect").appendChild(imgpre);
		document.getElementById("fileList").appendChild(list);
	}
	
	function handleEle(ele){
		
		if(ele.files)
			handleFiles(ele.files);
		else if( browserVersion.indexOf("MSIE 7.0")>-1 || browserVersion.indexOf("MSIE 8.0")>-1 ||
				 browserVersion.indexOf("MSIE 9.0")>-1
		){
			 if( !ele.value.match( /(.jpg|.gif|.png|.bmp|jpeg)$/i) ){  
			        alert('Wrong format picture files!');  
			        return false;  
			    }  
			handleSingleFile(ele);
		}else{
			alert("your brower could not support upload picutres.");
		}
	}

	function dataURItoBlob(dataURI) {
		// convert base64 to raw binary data held in a string
		// doesn't handle URLEncoded DataURIs
		var byteString = atob(dataURI.split(',')[1]);

		// separate out the mime component
		var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

		// write the bytes of the string to an ArrayBuffer
		var ab = new ArrayBuffer(byteString.length);
		var ia = new Uint8Array(ab);
		var result = "";
		for ( var i = 0; i < byteString.length; i++) {
			ia[i] = byteString.charCodeAt(i);
			result = result + String.fromCharCode(byteString.charCodeAt(i));
		}

		// write the ArrayBuffer to a blob, and you're done

		var aFileParts = [ "<a id=\"a\"><b id=\"b\">hey!<\/b><\/a>" ];

		//var oMyBlob = new Blob(aFileParts, { "type" : "text\/xml" });
		//var bb = new Blob([ia], { type : mimeString });
		//bb.append(ab);
		var bb = new MozBlobBuilder();
		bb.append(ab);

		return bb.getBlob(mimeString);
	}

	function Img2canvas(img) {
		var x = img.x;
		var y = img.y;
		alert("x=" + x + "  y=" + y + "height=" + img.naturalWidth);

		var canvas = document.createElement("canvas");
		//preview.appendChild(canvas);
		canvas.width = img.naturalWidth;
		canvas.height = img.naturalHeight;

		var ctx = canvas.getContext("2d");
		ctx.drawImage(img, 0, 0);
		return canvas;
	}

	function getBase64Image(img) {
		// Create an empty canvas element
		var canvas = document.createElement("canvas");
		canvas.width = $(img).prop("naturalWidth");
		canvas.height = $(img).prop("naturalHeight");

		//alert($(img).prop("file").fileName);
		var ctx = canvas.getContext("2d");
		ctx.drawImage(img, 0, 0);

		// Get the data-URL formatted image
		// Firefox supports PNG and JPEG. You could check img.src to
		// guess the original format, but be aware the using "image/jpg"
		// will re-encode the image.
		var tmp = $(img).prop("alt").split(".");
		var sniffix = tmp[tmp.length - 1];
		var dataURL;
		if (sniffix == "jpg" || snifix == "jpeg") {
			dataURL = canvas.toDataURL('image/jpeg');
		} else {
			dataURL = canvas.toDataURL();
		}
		var blob = new Blob([ dataURL ], {
			type : "text/plain"
		});
		return blob;
	}
	
	function refreshAll(){
		window.close();
		if (window.opener && !window.opener.closed) {
			window.opener.location.reload();
			//var herf=window.opener.location.href+"?pbid=<c:out value="${pbid}"/>";
			//window.opener.location.replace(herf);
		}
	}
	

	
	function submitdata() {
		var success=[];
		var imgcollection=document.getElementsByClassName("listpic");
		imgs= Array.prototype.slice.call(imgcollection);
		//alert(imgs.length);
		var length=fdarray.length;
		xhrs=[];
		for(var i=0; i<length; i++){
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "../../production/addimages", true);
			xhr.overrideMimeType("multipart/form-data");
			xhrs.push(xhr);
			xhr.send(fdarray[i]);
			
			xhr.onload=function(e){
				/*
				if(IsRequestSuccessful (xhr) && xhr.readyState==4){
					if(xhr.responseText=="success"){
						//success.push(this.imgs[i].alt.toString());
						success.push(xhr.responseText);
						
					}else {
						
						var filename=imgs[xhrs.indexOf(xhr)].alt.toString();
						alert("your picture "+filename+" do not successful update for "+xhr.responseText);
					}
				}*/
				success.push(xhr.responseText);
				if(success.length===imgs.length){
					alert(success.length.toString()+" picture(s) success uploaded!");
					window.setTimeout(refreshAll,1000);	
				}
					
			}
			window.setTimeout(donothing,500);
		}
		if(success.length===imgs.length){
			alert(success.length.toString()+"picture(s) success uploaded!");
			window.setTimeout(refreshAll,1000);	
		}
		//else{
		//	alert("you only successful submit "+success.toString()+" pics.");
		//	refreshAll();
		//}
		fdarray=[];
		//imgs=[];
	}
	
	function submitdecide(){
		if($.browser.msie &&  $.browser.version < 10.0)
			uploadform.submit();
		else{
			submitdata()
		}
	}
	
</script>
<title>Addd production pictures</title>

</head>
<body>

	<c:if test="${not empty content}">
		<script language="JavaScript">
			this.refreshParent();
		</script>
	</c:if>
	
	<fieldset>
		<H3>Select pictures for upload</H3>

        <div id="info" style="color:red;">
        
        
        </div>
<script type="text/javascript">
if($.browser.msie &&  $.browser.version < 8.0){
	
	var infomation="Your brower is ie"+$.browser.version+", You may not brower and upload your image properly.\n"+
	"if you are already using ie 8.0 or above please press f12 and select standard IE9 brower mode(not IE9 Compatibility mode)";
	$(" <span >"+infomation+"</span>").
	appendTo( $("#info"));
;

}else if($.browser.msie &&  $.browser.version < 10.0){
	$("<span >Please update your browser to full support HTML5 browser like Firefox or Chrome to support full features of this program.</span>")
	.appendTo( $("#info"));
}

</script>
        <hr>
        <p style="font-family: Arial, Helvetica, sans-serif;">add up to 12
			pictures</p>
		<p>
			<span id="trigg">Files: 
			<input type="file" name="fileinput" multiple onchange="handleEle(this)"
				accept="image/*" /> 
			</span>
			<input type="button" value="Upload pictures"
				onclick="submitdecide()" />
				
	</fieldset>

	<c:if test="${not empty content}">
		<p>
			The content uploaded: <br />${content}
		</p>
	</c:if>
	<form:form method="post" modelAttribute="MultiPartFileList"
		id="uploadform" action="../ieaddimages" enctype="multipart/form-data">
		<table>
			<tr>
				<td style="height: 430px; width: 350px; max-width: 350px">
					<div id="fileList"
						style="height: 100%; overflow-y: scroll; overflow:scroll; list-style: none; background-color:rgb(210,210,210)">
					</div>
				</td>
				<td
					style="text-align: center; height: 430px; width: 350px; max-width: 350px;">
					<div id="fileselect" align="center"
						style="height: 100%; width: 100%; left: auto; top: auto; vertical-align: middle;text-align: center;">
						<p>No files selected!</p>
					</div>
				</td>
			</tr>
		</table>
	</form:form>
	<div id="result"></div>
	<img id="preview_size_fake"/>
</body>


<script type="text/javascript">



</script>
</html>