/***=========================================================
	KOTOR GIT Data Output for Max
	
	A script for Max/GMax that will output a summary of the
	relevant data of the selected object/s to the Listener
	window that is required for injecting into a GIT, used
	in KOTOR.
	
	DP 2020-10-03
=========================================================***/

-- Unit conversion function created by martinB. Converts the value in unitVal into metres, taking into account the current system units.
-- Source: https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100
fn toMetres unitVal = (
scaleFactor = units.decodeValue "1m" -- This many system units make up one metre.
unitVal/scaleFactor 
)

for obj in selection do 
(
objName = obj.name -- Selected object's name.
objPos = obj.pos -- Object position.
xRot = obj.rotation.X_rotation -- Object X orientation.
yRot = obj.rotation.Y_rotation -- Object Y orientation.
zRot = obj.rotation.Z_rotation -- Object Z orientation.
zRads = degToRad zRot -- Derive Z rotation in radians for placeable bearing.
zCos = cos (radToDeg zRot) -- Derive creature XOrientation. Despite the help page saying trig functions work in degrees, they use radians, so force back to degrees.
zSin = sin (radToDeg zRot) -- Derive creature YOrientation.
local zRot2
if zRot < 0 then zRot2 = abs zRot else zRot2 = 0 - zRot -- To account for apparent sign flipping, flip the sign before converting to a quat.
objzRot = eulerAngles 0 0 zRot2 -- Create a dummy rotation with zeroed out X and Y values.
objzRot2 = objzRot as quat -- Convert dummy rotation to a quaternion.
quatW = objzRot2.w -- Separate out quaternion components to reorder as WXYZ (Max default is XYZW).
quatX = objzRot2.x
quatY = objzRot2.y
quatZ = objzRot2.z
format "=================================================\n"
format "Object data formatted for KOTOR GIT injection\n"
format "-------------------- GENERIC --------------------\n"
format "SELECTED OBJECT: %\n" objName
format "POSITION (in metres): %, %, %\n" (toMetres objPos.x) (toMetres objPos.y) (toMetres objPos.z) -- Use unit conversion function to ensure position is in metres regardless of system units.
format "ROTATION (in degrees): %, %, %\n" xRot yRot zRot
format "----------------- STATIC CAMERA -----------------\n"
format "PITCH (X rotation in degrees): %\n" xRot
format "ORIENTATION (Z rotation as a WXYZ quaternion):\n%, %, %, %\n" quatW quatX quatY quatZ
format "------------------- PLACEABLE -------------------\n"
format "BEARING (Z rotation in radians): %\n" zRads
format "------------------- CREATURE --------------------\n"
format "X ORIENTATION ( COS(Z°) ): %\n" zCos
format "Y ORIENTATION ( SIN(Z°) ): %\n" zSin
format "=================================================\n"
format "\n"
)
