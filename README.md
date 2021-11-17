# KOTOR GIT Data Output for Max
This is a simple script that will derive the relevant data from an object (or objects) in 3DS Max/GMax needed to be added to a KOTOR GIT when creating new static camera, placeable, or creature entries and output it to the Listener window. Now expanded with some additional supplementary scripts.

Instructions
============
Download the script and put it in your Scripts folder, or some other convenient location. In Max, select the object/s of interest, hit F11 to open the Listener window, then hit CTRL+R or go to File -> Run Script and select KOTOR_GIT_Data_Output_for_Max.ms and hit enter. You should get an output something like the following:
```
===================================================
Object data formatted for KOTOR GIT injection
--------------------- GENERIC ---------------------
SELECTED OBJECT: PMBIM
POSITION (in metres): 106.526, 33.619, 4.21
ROTATION (in degrees): 0.0, 0.0, 112.5
------------------ STATIC CAMERA ------------------
PITCH (X rotation in degrees): 0.0
ORIENTATION (Z rotation as a WXYZ quaternion):
0.55557, 0.0, 0.0, 0.83147
-------------------- PLACEABLE --------------------
BEARING (Z rotation in radians): 1.9635
-------------------- SCRIPTING --------------------
FACING: (Z rotation + 90°): 202.5
-------------------- CREATURE ---------------------
X ORIENTATION ( COS(Z + 90°) ): -0.92388
Y ORIENTATION ( SIN(Z + 90°) ): -0.382683
===================================================
```

If you also need to derive the geometry struct values to create a new GIT trigger entry, download the second script, KOTOR_GIT_Trigger_Output_for_Max.ms and use in the same manner as above. This will output the vertex offsets from the parent pivot for the selected object/s. It will skip any object with more than 10 verts (triggers typically only have 4 or 5 verts). You should get an output something like the following:
```
===================================================
Trigger data formatted for KOTOR GIT injection
---------------------------------------------------
SELECTED OBJECT: Trigger01
POSITION (in metres): -1.45, 3.85, 2.0
----------------- VERTEX OFFSETS ------------------
Vert 1: -0.85827, -0.42217, 0.0
Vert 2: 0.85827, -0.42217, 0.0
Vert 3: -0.85827, 0.42217, 0.0
Vert 4: 0.85827, 0.42217, 0.0
===================================================
```

If you would like to recreate creature or waypoint positioning inside Max using data from a module's GIT, a third script now converts from X/Y Orientation to a Z rotation in degrees. Download and run KOTOR_GIT_Orientation_Converter.ms, as above. A pop-window will allow you to enter the values:

![](https://github.com/DarthParametric/KOTOR_GIT_Data_Output_for_Max/blob/main/img/GIT_XYOri_Converter.png?raw=true)

Note that in Max the text fields are filtered to prevent the entry of extraneous characters, but this feature is disabled for GMax. Hit the Convert button and the conversion results will be output to the Listener window. You should get an output something like the following:
```
===================================================
KOTOR Creature X\Y Orientation Converter for Max
---------------------------------------------------
X ORIENTATION: -0.92388
Y ORIENTATION: -0.382683
------------------- CONVERSION --------------------
IN-GAME FACING (in °): 202.5
MAX Z ORIENTATION (in °): 112.5
===================================================
```
Additionally, this script now also converts the orientation field for static cameras, which defines the camera's Z rotation (X rotation is defined in the Pitch field, already in degrees):

![](https://github.com/DarthParametric/KOTOR_GIT_Data_Output_for_Max/blob/main/img/GIT_CamOri_Converter.png?raw=true)

Note that in Max the text fields are filtered to prevent the entry of extraneous characters, but this feature is disabled for GMax. Hit the Convert button and the conversion results will be output to the Listener window. You should get an output something like the following:
```
===================================================
KOTOR Static Camera Orientation Converter for Max
---------------------------------------------------
W: 0.743146
X: 0
Y: 0
Z: 0.66913
------------------- CONVERSION --------------------
MAX Z ORIENTATION (in °): 83.9999
===================================================
```

Acknowledgements
============
* Unit conversion function taken from a [CG Society forum post](https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100/2) by martinB.
* Float rounding function taken from a [Scriptspot post](http://www.scriptspot.com/forums/3ds-max/general-scripting/printing-out-float-values-to-a-few-decimal-points) by Guessmyname.
* Bad characters filter function taken from a [CG Society forum post](https://forums.cgsociety.org/t/limit-an-edit-box-to-integer-float-value/1299552/3) by thatoneguy.
* Max version check idea taken from [KOTORMax](https://deadlystream.com/files/file/1151-kotormax/) by bead-v.
* Thanks to ndix UR for various discussions regarding the arcane mysteries of quaternions and the Byzantine inner workings of the Odyssey engine. Also for providing a much simpler method of convertion X/Y orientations to Euler angles.
* Origin of the script idea thanks to conversations with Kexikus and JCarter426 on the Deadly Stream Discord.
* Extension of the script from static camera values to also include placeable and creature data thanks to conversations with ebmar/Seth on the Deadly Stream Discord.
* Useful information regarding using trig functions to reverse-engineer Odyssey's X/Y Orientation values derived from [several posts by Vriff](https://deadlystream.com/topic/2901-gitedit-what-do-you-guys-want/?do=findComment&comment=29621) on Deadly Stream.
