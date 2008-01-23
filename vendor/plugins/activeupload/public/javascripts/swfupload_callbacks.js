var MM_contentVersion = 6;
var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"]) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
if ( plugin ) {
var words = navigator.plugins["Shockwave Flash"].description.split(" ");
for (var i = 0; i < words.length; ++i)
{
if (isNaN(parseInt(words[i])))
continue;
var MM_PluginVersion = words[i];
}
var MM_FlashCanPlay = MM_PluginVersion >= MM_contentVersion;
}
else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0
&& (navigator.appVersion.indexOf("Win") != -1)) {
document.write('<SCR' + 'IPT LANGUAGE=VBScript\> \n'); //FS hide this from IE4.5 Mac by splitting the tag
document.write('on error resume next \n');
document.write('MM_FlashCanPlay = ( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash." & MM_contentVersion)))\n');
document.write('</SCR' + 'IPT\> \n');
}


function fileQueued(file, queuelength) {
	var listingfiles = document.getElementById("SWFUploadFileListingFiles");

	if(!listingfiles.getElementsByTagName("ul")[0]) {
		
		var info = document.createElement("h4");
		info.appendChild(document.createTextNode("File queue"));
		
		listingfiles.appendChild(info);
		
		var ul = document.createElement("ul")
		listingfiles.appendChild(ul);
	}
	
	listingfiles = listingfiles.getElementsByTagName("ul")[0];
	
	var li = document.createElement("li");
	li.id = file.id;
	li.className = "SWFUploadFileItem";
	li.innerHTML = file.name + " <span class='progressBar' id='" + file.id + "progress'></span><a id='" + file.id + "deletebtn' class='cancelbtn' href='javascript:swfu.cancelFile(\"" + file.id + "\");'><!-- IE --></a>";

	listingfiles.appendChild(li);
	
	var queueinfo = document.getElementById("queueinfo");
	queueinfo.innerHTML = queuelength + " files queued";
	document.getElementById(swfu.movieName + "UploadBtn").style.display = "block";
	document.getElementById("cancelqueuebtn").style.display = "block";
}

function uploadFileCancelled(file, queuelength) {
	var li = document.getElementById(file.id);
	li.innerHTML = file.name + " - cancelled";
	li.className = "SWFUploadFileItem uploadCancelled";
	var queueinfo = document.getElementById("queueinfo");
	queueinfo.innerHTML = queuelength + " files queued";
}

function uploadFileStart(file, position, queuelength) {
	var div = document.getElementById("queueinfo");
	div.innerHTML = "Uploading file " + position + " of " + queuelength;

	var li = document.getElementById(file.id);
	li.className += " fileUploading";

	var id;
	var url = '/attachments/create';
	new Ajax.Request(url, {
		asynchronous: false,
		onComplete: function(transport) {
			id = transport.responseText;
		}
	});

	$('_object_attachment_id').value += ","+id;

	return "?id="+id;
}

function uploadProgress(file, bytesLoaded) {

	var progress = document.getElementById(file.id + "progress");
	var percent = Math.ceil((bytesLoaded / file.size) * 200)
	progress.style.background = "#f0f0f0 url(/images/progressbar.png) no-repeat -" + (200 - percent) + "px 0";
}

function uploadError(errno) {
	// SWFUpload.debug(errno);
}

function uploadFileComplete(file) {
	var li = document.getElementById(file.id);
	result = file;
	li.className = "SWFUploadFileItem uploadCompleted";
}

function cancelQueue() {
	swfu.cancelQueue();
	document.getElementById(swfu.movieName + "UploadBtn").style.display = "none";
	document.getElementById("cancelqueuebtn").style.display = "none";
}

function uploadQueueComplete(file) {
	var div = document.getElementById("queueinfo");
	div.innerHTML = "All files uploaded..."
	document.getElementById("cancelqueuebtn").style.display = "none";
}

function removeAttachment(inputId, attachmentId, containerId) {
        ids = $(inputId).value.split(",");
        for(i=0; i<ids.length; i++) {
                if(ids[i] == attachmentId) {
                        ids.splice(i,1);
                        $(inputId).value = ids.join(",");
                        //$(containerId).className = "removed-attachment";
                        new Effect.DropOut($(containerId));
                        return;
                }
        }
}
