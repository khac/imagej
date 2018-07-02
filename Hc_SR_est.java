import ij.*;
import ij.process.*;
import ij.gui.*;
import java.awt.*;
import ij.plugin.*;

public class Forensic_SR implements PlugIn {

	public void run(String arg) {
		ImagePlus imp = IJ.getImage();
		IJ.run(imp, "Scale...", "x=3 y=3 interpolation=Bicubic average create");
		ImagePlus scaledImp = IJ.getImage();		
		IJ.run(scaledImp, "Unsharp Mask...", "radius=1 mask=0.90");
		imp.show();
	}

}
