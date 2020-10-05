# KOTOR GIT Data Output for Max
This is a simple script that will derive the relevant data from an object (or objects) in 3DS Max/GMax needed to be added to a KOTOR GIT when creating new static camera, placeable, or creature entries and output it to the Listener window. 

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
------------------- SCRIPTING * -------------------
FACING: (Z rotation + 90°): 202.5
-------------------- CREATURE * -------------------
X ORIENTATION ( COS(Z + 90°) ): -0.92388
Y ORIENTATION ( SIN(Z + 90°) ): -0.382683
---------------------- NOTES ----------------------
N.B.: The Endar Spire (and possibly other modules)
rotate the in-game map so that north doesn't match
Max's north. This may cause confusion when trying to
determine the required orientation. See the readme
for further details.
===================================================
```
Notes
============
At least two modules, the Endar Spire's end_m01aa (Command Module) and end_m01ab (Starboard Section), rotate the in-game map differently than the majority of other modules. Typically the game takes East as 0°, thus requiring the addition of 90° to certain rotations. However, these two modules rotate the in-game map so that in-game North is actually West in Max, while still taking Max East as 0°. Thus to face North would require a scripted facing of 180° in these modules, not 90° as would typically be the case. Generally this shouldn't pose an issue when working exclusively in Max, but users should be cognizant of it when testing in-game.

Acknowledgements
============
* Unit conversion function taken from a [CG Society forum post](https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100) by martinB.
* Thanks to ndix UR for various discussions regarding the arcane mysteries of quaternions.
* Origin of the script idea thanks to conversations with Kexikus and JCarter426 on the Deadly Stream Discord.
* Extension of the script from static camera values to also include placeable and creature data thanks to conversations with ebmar/Seth on the Deadly Stream Discord.
* Useful information regarding using trig functions to reverse-engineer Odyssey's X/Y Orientation values derived from [several posts by Vriff](https://deadlystream.com/topic/2901-gitedit-what-do-you-guys-want/?do=findComment&comment=29621) on Deadly Stream.
