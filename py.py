# @ImagePlus(label="Image to process") imp
# @ String(choices={"2", "3","4"}, style="listBox") Scale
# @ String(choices={"1", "2","3", "4","5"}, style="listBox") radius
# @float(label="Unsharp Masking Coeff.: ") coeff
from ij import IJ

IJ.run(imp, "Scale...", "x="+Scale+" y="+Scale+" interpolation=Bicubic average create");
scaledImp = IJ.getImage();		
IJ.run(scaledImp, "Unsharp Mask...", "radius="+radius+" mask="+str(coeff));
scaledImp.show()
