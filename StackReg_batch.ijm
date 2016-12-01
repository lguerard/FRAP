macro "StackReg_Batch" {
/*  Batch StackReg. Applies StackReg, which allows a stack to be realigned,
 *  to a folder but only dealing with LSM files.
 *   
 * 
 * Instructions:
 * Install the macro and run it. It will then ask you the folder with the image.
 * The resulting images are found in the folder /StackReg_images
 * 
 * Macro created by Laurent Guerard , Centre for Cellular Imaging 
 * 160215 Version 1.0
 */

	setBatchMode(true);
	run("Close All");
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
	//Get file/folder information:
	Folder = getDirectory("Choose the folder where your images are located");
	OutputFolderName = "StackReg_images";
	Output_Folder = Folder + File.separator+ OutputFolderName;
	File.makeDirectory(Output_Folder);

	Files = getFileList(Folder);
	Array.sort(Files);
	NrOfFiles = Files.length;

	//Loop through the different files
	for (i=0; i<NrOfFiles; i++) {
		showProgress((i+1)/NrOfFiles);
		//Only treat tif files
		if (endsWith(Files[i], ".lsm"))
		{
			ImgName = Files[i];
			StrInd1 = indexOf(ImgName,".lsm");
			//Get the name without the extension
			ShortFileName=substring(ImgName,0, StrInd1);
			FullName = Folder + ImgName;
			open(FullName);

			print("Treating "+ShortFileName);
			run("StackReg", "transformation=[Rigid Body]");
			saveAs("tiff",Output_Folder+File.separator+ShortFileName);
			run("Close All");
		}
	}
	//Warn when the macro is finished
	showMessage("StackReg_Batch macro finished !");
}