macro "OvalProfilePlot" {
/*  Make an intensity profile plot on an oval selection.
 *    
 * 
 * Instructions:
 * Install the macro and run it. It will then ask you the folder with the image.
 * The resulting images are found in the folder /StackReg_images
 * 
 * Macro created by Laurent Guerard , Centre for Cellular Imaging 
 * 160215 Version 1.0
 */

//VARIABLE TO CHANGE
 	circleSize = 7;
/////////////////////////

	setBatchMode(true);
	//run("Close All");
	print("\\Clear");
	roiManager("Reset");
	run("Clear Results");
	print("-----------------------------------");
	print("StackReg_Batch macro started");

	//Get the date
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	if ((month>=10) && (dayOfMonth<10)) 
	{
		trueYear = ""+year;
		trueMonth = ""+month+1;
		trueDay = "0"+dayOfMonth;
		print("Date: "+year+"-"+month+1+"-0"+dayOfMonth);
	}
	else if ((month<10) && (dayOfMonth<10)) 
	{
		trueYear = ""+year;
		trueMonth = "0"+month+1;
		trueDay = "0"+dayOfMonth;
		print("Date: "+year+"-0"+month+1+"-0"+dayOfMonth);
	}
	else if ((month<10) && (dayOfMonth>10)) 
	{
		trueYear = ""+year;
		trueMonth = "0"+month+1;
		trueDay = ""+dayOfMonth;
		print("Date: "+year+"-0"+month+1+"-"+dayOfMonth);
	}
	else 
	{
		trueYear = ""+year;
		trueMonth = ""+month+1;
		trueDay = ""+dayOfMonth;
		print("Date: "+year+"-"+month+1+"-"+dayOfMonth);
	}

	//--------------------------------------------------------
	// Initial settings:
	//--------------------------------------------------------
	//Get information about the image
	height = getHeight();
	Folder = getDirectory("image");
	Name = getInfo("image.filename");
	width = getWidth();

	size = nSlices();
	meanArray = newArray(size+1);

	//Make the oval, size needs to be selected before
	setSlice(1);
	makeOval((width/2-circleSize/2),(height/2-circleSize/2),circleSize,circleSize);
	f = File.open(Folder+File.separator+Name+".txt");

	//User selects the position of the circle
	waitForUser("Move the circle with the arrows on the keyboard to the correct position\n then click OK");
	selectWindow(Name);

	//Loop through the slices to get the bleaching values 
	for (i=1;i<=size;i++)
	{
		setSlice(i);
		getStatistics(area, mean, min, max, std);
		meanArray[i] = mean;	
		//print(f,mean);
	}

	setTool("polyline");
	setSlice(1);

	//User selects the background selection
	waitForUser("Select an area that will be considered as background");
	selectWindow(Name);

	//Loop through the slices to get the background values and save them in a text file
	for (i=1;i<=size;i++)
	{
		setSlice(i);
		getStatistics(area, mean2, min, max, std);
		print(f,meanArray[i]+"\t"+mean2);
	}
	
	//Warn when the macro is finished
	showMessage("Values for "+Name+" saved !");
}