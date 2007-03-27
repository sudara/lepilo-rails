<!-- use this comment tag to hide the enclosed code from old browsers.

var debug = false;
var overrideFlash = false;

// These Variables can be used in the outside world as indicators of various plugins
var hasSWDirector = false; // has the Shockwave Director
var versionSWDirector = ""; // version of the Shockwave Director - 7.0 or up
var hasFlash = false; // has Macromedia Flash
var versionFlash = ""; // version of the Shockwave Director - 5.0 or up

//***************************
// A few variables to help figure out what platform we're on

var allPlugins = navigator.plugins;
var arraylength = allPlugins.length;

var ie  = (navigator.appName.toLowerCase().indexOf("microsoft") != -1);
var ns  = (navigator.appName.toLowerCase().indexOf("netscape") != -1);
var win = (navigator.platform.toLowerCase().indexOf("win") != -1);
var mac = (navigator.platform.toLowerCase().indexOf("mac") != -1);
var browserVer = parseFloat(ie ? navigator.appVersion.substring(navigator.appVersion.toLowerCase().indexOf("msie") + 4) : navigator.appVersion);


//***************************
// For detecting the shockwave plugin for Netscape.
// This function can return a boolean or a floating point value.
// If you supply a reqVer value (number) it will return true or false
// depending on if that version or higher was found.
// If you don't supply a parameter it will return the found version number.

function detectNsVer() {
  // This function returns a floating point value which should be the version of the Shockwave plugin or 0.0
  // This function only returns useful information if called from Netscape or IE Mac 5.0+

  if (!navigator.plugins) return (""); // IE Mac 4.5 and lower don't have a plugins array.

  // Set these local variables to avoid the Netscape 4 crashing bug.
  thearray = navigator.plugins
  arraylen = thearray.length

	if (debug)  alert ("Plugins found - " + arraylen);
  // Step through each plugin in the array.
  for (i=0; i < arraylen; i++) {
    // Set these local variables to avoid the Netscape 4 crashing bug.
    theplugin = thearray[i]
    thename   = theplugin.name
    thedesc   = theplugin.description

	if (debug)  alert ("detectNsVer: Name - " + thename + "; Desc - " + thedesc);
	// If the plugin is Shockwav.fragments..
    if (thename.indexOf("Shockwave") != -1 && thename.indexOf("Director") != -1) {
      // ...extract the version information
      versionString = thedesc.substring(thedesc.indexOf("version ") + 8);
      if (versionString.indexOf(".") > 0) {
        versionMajor = versionString.substring(0,versionString.indexOf("."));
        versionMinor = versionString.substring(versionString.indexOf(".") + 1);
        if (versionMinor.indexOf(".") > 0)
          versionMinor = versionMinor.substring(0,versionString.indexOf("."))
                         + versionMinor.substring(versionMinor.indexOf(".") + 1);   
        versionString = parseInt(versionMajor) + "." + versionMinor;
      }
      versionSWDirector = versionString;
    } 
    if (thename.indexOf("Shockwave") != -1 && thename.indexOf("Flash") != -1) {
      // ...extract the version information
	  versionFlash = thedesc.substring(thedesc.indexOf(".") - 1);
    } 
  }
  return ("");
}

//***************************
// For detecting the ActiveX for ie win.
// Requires vbscript function (VBGetShockwaveVer) above to be included on
// the page to do the actual checking.
// Returns version found or "" (blank string).
// This function will return String version value.

function shockwaveDetectAxVer() {
  // this function returns a floating point value which should be the version of the Shockwave control or 0.0
  // this function should only be called from Internet Explorer for Windows

  if (ie && win) {
    // loop backwards through the versions until we get a bite
    for (i=8;i>0;i--) {
      versionString = VBGetShockwaveVer(i);
      if (versionString != "0.0") {
        // if we get 1.0 we assume it is actually 6.0
        versionNumStr = (versionString == "1.0" ? "6.0" : versionString)
        return (versionNumStr);
      }
    }
  }
  return ("");
}

//***************************
// For detecting the ActiveX for ie win.
// Requires vbscript function (VBGetShockwaveVer) above to be included on
// the page to do the actual checking.
// Returns version found or "" (blank string).
// This function will return String version value.

function flashDetectAxVer() {
  // this function should only be called from Internet Explorer for Windows

  if (ie && win) {
    // loop backwards through the versions until we get a bite
    for (i=9;i>0;i--) {
      versionString = VBGetFlashVer(i);
      if (versionString != "0.0") {
        return (versionString);
      }
    }
  }
  return ("");
}

function canDetectShockwave() {
  // Determine the browser version
  var browserVer = parseFloat(ie ?
                     navigator.appVersion.substring(navigator.appVersion.toLowerCase().indexOf("msie") + 4) :
                     navigator.appVersion);

	if (debug)  alert ("Browser Version : " + browserVer + ",  " + ie  + ",  " + win  + ",  " + ns  + ",  " + mac );

  // Return the appropriate value based on the browser, version and platform
  if (ie && win) return (browserVer >= 4.0) // Works in Windows IE 4.0 and better
  if (ie && mac) return (browserVer >= 5.0) // Works in Mac IE 5.0 and better 
  if (ns)        return (browserVer >= 3.0) // Works in Netscape 3.0 and better

  // If none of the above conditions matched, the browser is
  // unknown and likely doesn't support detection
  return false;
}

if (canDetectShockwave()) {
	document.write('<SCRIPT LANGUAGE=VBScript\> \n');

	document.write('Function VBGetShockwaveVer(i) \n');
	document.write('  on error resume next \n');
	document.write('  Dim swControl, swVersion \n');
	document.write('  swVersion = "0.0" \n');
  
	document.write('  set swControl = CreateObject("SWCtl.SWCtl." + CStr(i)) \n');
	document.write('  if (IsObject(swControl)) then \n');
	document.write('    swVersion = CStr(i) + ".0" \n');
	document.write('    swVersion = CStr(swControl.ShockwaveVersion("")) \n');
	document.write('  end if \n');

	document.write('  VBGetShockwaveVer = swVersion \n');
	document.write('End Function \n');

	document.write('Function VBGetFlashVer(i) \n');
	document.write('	on error resume next \n');
	document.write('	Dim flashVersion, flashControl \n');
	document.write('	flashVersion = "0.0" \n');
  
	document.write('	set flashControl = CreateObject("ShockwaveFlash.ShockwaveFlash." + CStr(i)) \n');
	document.write('	if (IsObject(flashControl)) then \n');
	document.write('		flashVersion = CStr(i) + ".0" \n');
	document.write('	end if \n');

	document.write('  VBGetFlashVer = flashVersion \n');
	document.write('End Function \n');

	document.write('</SCRIPT\> \n');

	if (debug)  alert ("In for detecting SW");
	if (ie && win) {
		versionSWDirector = shockwaveDetectAxVer();
		versionFlash = flashDetectAxVer();
	} else {
		detectNsVer();
	}

	hasSWDirector = (versionSWDirector.length > 0 && (parseFloat(versionSWDirector) >= 7.0));
	hasFlash = (versionFlash.length > 0 && (parseFloat(versionFlash) >= 5.0));
	
	if (overrideFlash == true) {
		if (debug)  alert ("Overriding Flash - assuming HTML version.");
		hasFlash = false;
		hasSWDirector = false;
	}
}


// Close the comment tag. -->
