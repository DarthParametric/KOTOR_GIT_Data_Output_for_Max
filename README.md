# KOTOR GIT Data Output for Max
This is a simple script that will derive the relevant data from an object (or objects) in 3DS Max/GMax needed to be added to a KOTOR GIT when creating new static camera, placeable, or creature entries and output it to the Listener window. 

Instructions
============
Download the script and put it in your Scripts folder, or some other convenient location. In Max, select the object/s of interest, hit F11 to open the Listener window, then hit CTRL+R or go to File -> Run Script and select KOTOR_GIT_Data_Output_for_Max.ms and hit enter. You should get an output something like the following:
```
=================================================
Object data formatted for KOTOR GIT injection
-------------------- GENERIC --------------------
SELECTED OBJECT: TestObject01
POSITION (in metres): -10.629, 2.145, 1.56
ROTATION (in degrees): 84.5, 0.0, 85.217
----------------- STATIC CAMERA -----------------
PITCH (X rotation in degrees): 84.5
ORIENTATION (Z rotation as a WXYZ quaternion):
0.735997, 0.0, 0.0, 0.676985
------------------- PLACEABLE -------------------
BEARING (Z rotation in radians): 1.48732
------------------- CREATURE --------------------
X ORIENTATION ( COS(Z°) ): -0.923378
Y ORIENTATION ( SIN(Z°) ): -0.383893
=================================================
```
Acknowledgements
============
* Unit conversion function taken from a [CG Society forum post](https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100) by martinB.
* Thanks to ndix UR for various discussions regarding the arcane mysteries of quaternions.
* Origin of the script idea thanks to conversations with Kexikus and JCarter426 on the Deadly Stream Discord.
* Extension of the script from static camera values to also include placeable and creature data thanks to conversations with ebmar/Seth on the Deadly Stream Discord.
