import ij.*;
import ij.process.*;
import ij.gui.*;
import java.awt.*;
import ij.plugin.*;

public class SR_Forensic implements PlugIn {

	public void run(String arg) {
		ImagePlus imp = IJ.getImage();
		IJ.run(imp, "Scale...", "");
		ImagePlus scaledImp = IJ.getImage();		
		IJ.run(scaledImp, "Unsharp Mask...", "");
		imp.show();
	}
}
