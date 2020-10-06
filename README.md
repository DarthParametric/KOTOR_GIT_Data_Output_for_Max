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
-------------------- SCRIPTING --------------------
FACING: (Z rotation + 90°): 202.5
-------------------- CREATURE ---------------------
X ORIENTATION ( COS(Z + 90°) ): -0.92388
Y ORIENTATION ( SIN(Z + 90°) ): -0.382683
===================================================
```
If you also want to create triggers, download the second script, KOTOR_GIT_Trigger_Output_for_Max.ms and use in the same manner. This will output the vertex offsets from the parent pivot for the selected object/s. It will skip any object with more than 10 verts (triggers typically only have 4 or 5 verts). You should get an output something like the following:
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

Notes
============
Several modules across both games, notably the Endar Spire's end_m01aa (Command Module) and end_m01ab (Starboard Section) in K1 and the Harbinger's 151HAR (Command Deck) and 152HAR (Crew Quarters) in TSL, rotate the in-game map differently than the majority of other modules. The game takes Max's East as 0°, thus requiring the addition of 90° to certain rotations. However, these modules rotate the in-game map so that in-game North no longer matches North in Max, while still taking Max East as 0°. Thus to face North in these modules would require something other than the typical 90° used in other modules. Generally this shouldn't pose an issue when working exclusively in Max, but users should be cognizant of it when testing in-game, especially when using player postioning/facing as a guide.

Acknowledgements
============
* Unit conversion function taken from a [CG Society forum post](https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100) by martinB.
* Float rounding function taken from a [Scriptspot post](http://www.scriptspot.com/forums/3ds-max/general-scripting/printing-out-float-values-to-a-few-decimal-points) by Guessmyname.
* Thanks to ndix UR for various discussions regarding the arcane mysteries of quaternions and the Byzantine inner workings of the Odyssey engine.
* Origin of the script idea thanks to conversations with Kexikus and JCarter426 on the Deadly Stream Discord.
* Extension of the script from static camera values to also include placeable and creature data thanks to conversations with ebmar/Seth on the Deadly Stream Discord.
* Useful information regarding using trig functions to reverse-engineer Odyssey's X/Y Orientation values derived from [several posts by Vriff](https://deadlystream.com/topic/2901-gitedit-what-do-you-guys-want/?do=findComment&comment=29621) on Deadly Stream.
