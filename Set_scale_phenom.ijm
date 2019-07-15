// This very simple macro was created by shamelessly editing a
// preexisting macro for the Zeiss SmartSEM which can be found here:
// https://wsr.imagej.net/macros/SetScaleFromTiffTag.txtsets 

// The purpose is to import the scale for SEM images taken 
// with the Phenom Pharos program. It requires the tiff_tags 
// plugin written by Joachim Wesner. It can be downloaded from
// http://rsbweb.nih.gov/ij/plugins/tiff-tags.html

// There is an example image available at
// http://rsbweb.nih.gov/ij/images/SmartSEMSample.tif

// This is the number of the VERY long tag 
// that stores all the SEM information
tagnum=34683;

//Gets the path+name of the active image
path = getDirectory("image");
if (path=="") exit ("path not available");
name = getInfo("image.filename");
if (name=="") exit ("name not available");
path = path + name;

//Gets the tag, and parses it to get the pixel size information
tag = call("TIFF_Tags.getTag", path,tagnum);
String.show(tag);
i0 = indexOf(tag, "pixelHeight unit=");
if (i0==-1) exit ("Scale information not found");
unit=substring(tag,i0+18,i0+20);
//String.show(unit);
i1 = indexOf(tag, ">", i0);
i2 = indexOf(tag, "</", i1);
if (i1==-1 || i2==-1 || i2 <= i1+4)
   exit ("Parsing error! Maybe the file structure changed?");
text = substring(tag,i1+1,i2);
i0 = indexOf(tag, "<detectors>");
if (i0==-1) exit ("Detector information not found");
detector=substring(tag,i0+17,i0+22);
if (detector=="A=\"+\""){
	detector="BSD";}
else{
	detector="SED";}
i0 = indexOf(tag, "</highVoltage>");
i1 = indexOf(tag, "<highVoltage");
voltage=substring(tag,i1+23,i0);
i1 = indexOf(tag, "<filamentPower unit=\"W\">");
i0 = indexOf(tag, "</filamentPower>");
power=substring(tag,i1+24,i0-3);
//String.show(detector);
//Splits the pixel size in number+unit
//and sets the scale of the active image
pixelSize = text;
setVoxelSize(pixelSize, pixelSize, 1, unit);
//Optional display detector information (uncomment to include)
setFont("SansSerif", 40, " antialiased");
makeText("Detector: "+detector+" Voltage: "+voltage+"kV"+" Power: "+power+" W", getWidth()-830, getHeight()-50);
//makeText(voltage, getWidth()-50, getHeight()-50);