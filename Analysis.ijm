//Name: Nrushanth Suthaharan
//Date: 04-17-2025
//Description: Take an image containing elliptical objects and return key parameters
// including area, perimeter, circularity, maxFeret, minFeret, orthogonal Diamgeter
//get orthogonal diameter
function getOrthogonal() { 
	n = roiManager("count");
	for (i=0; i<n; i++) {
		// Get FeretAngle of the current ROI
		feretAngle = getResult("FeretAngle", i);
		roiManager("Select", i);
		RoiManager.rotate(feretAngle);
		roiManager("Select", i);
		roiManager("measure");
		// Calculate orthogonal direction range (feretAngle +90° ±10°)
		ortho = getResult("Height",nResults-1);
		// Save the result
		setResult("Orthogonal", i, ortho);
		
		//delete extra row from table
		Table.setSelection(nResults-1, nResults-1);
		String.copyResults;
		Table.deleteRows(nResults-1, nResults-1);
	}
}

minSize = getNumber("Enter expected ABSOLUTE MINIMUM area of samples in mm^2:", 1);
maxSize = getNumber("Enter expected ABSOLUTE MAXIMUM area of samples in mm^2:", 10);

imagePath = File.openDialog("Select image to analyse");
output = getDirectory("output folder to store results");
open(imagePath);
imageTitle = getTitle();

//allow user to input scale
waitForUser("Insert circular or linear reference, then click 'OK' here to proceed.");

if(selectionType() == 1){ //circular reference
	diameter = getNumber("Enter known diameter in mm:", 0);
	run("Measure");
	perimeter = getResult("Perim.", nResults-1);
	Table.deleteRows(nResults-1, nResults-1);
	calcDiameter = perimeter/PI;
	run("Set Scale...","distance="+calcDiameter+" known="+ diameter+" unit=mm");
}
else if(selectionType() == 5){ //linear reference
	knownScale = getNumber("Enter known length in mm:", 0);
	run("Measure");
	calcLength = getResult("Length", 0);
	Table.deleteRows(nResults-1, nResults-1);
	run("Set Scale...", "distance="+calcLength+" known="+ knownScale+" unit=mm");
}
else{
	exit("Unrecognised reference type! Use only oval or straight line tool");
}
close("Results");

//Apply Crop
waitForUser("Use oval or rectangle tool to make a crop around your samples only, then click 'OK' here to proceed.");
if(selectionType() !=0 && selectionType() !=1){
	exit("Unrecognised crop type! Use only rectangle or oval tool");
}
run("Crop");
//Thresholding
run("8-bit");
run("Threshold...");
waitForUser("Adjust the threshold sliders (OTSU method preferred), press 'Apply', then click 'OK' here to proceed.");
close("Threshold");
run("Convert to Mask");
run("Watershed");
//noise clearing and separating
print("Turn on preview and remove outliers using radius. Click 'OK' to apply");

run("Remove Outliers...");
close("Log");
//waitForUser("Click 'OK' here to proceed.");

//run analysis
run("Set Measurements...", "area perimeter bounding fit shape feret's display redirect=None decimal=3");
run("Analyze Particles...", "size=" + minSize + "-" + maxSize + " display add");

//run orthogonal function
getOrthogonal();
//Save Results
saveAs("Results", output+"results.csv");
roiManager("Save", output+"rois.zip");
//confirmation
print("Double check the analysed image. Outlines may appear slightly rotated.");
print("Results and ROIs saved!");

close("Results");