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

-- Add a single notice block about module map orientation at output start rather than spamming it in every object sub-block.
	format "===================================================\n"
	format "--------------------- NOTICE ----------------------\n"
	format "N.B.: Some modules rotate the in-game map so that\n"
	format "north doesn't match Max's north, as is usually the\n"
	format "case. Trying to determine the required orientation\n"
	format "in-game may result in some confusion in these cases.\n"
	format "Refer to the readme for further details.\n"
	format "===================================================\n"
	format "\n"

for obj in selection do (
	
	objName = obj.name -- Selected object's name.
	objPos = obj.pos -- Object position.
	xRot = obj.rotation.X_rotation -- Object X orientation.
	yRot = obj.rotation.Y_rotation -- Object Y orientation.
	zRot = obj.rotation.Z_rotation -- Object Z orientation.
	zRads = degToRad zRot -- Derive Z rotation in radians for placeable bearing.
	zRotKTR = zRot + 90 -- Since KOTOR modules use East as 0 degrees, we need to add an extra 90 degrees to calculate certain in-engine facings.
	zCos = cos zRotKTR -- Derive creature XOrientation (cosine of adjusted rotation in radians).
	zSin = sin zRotKTR -- Derive creature YOrientation (sine of adjusted rotation in radians).
	local zRot2
	
	if zRot < 0 then zRot2 = abs zRot else zRot2 = 0 - zRot -- To account for apparent sign flipping, flip the sign before converting to a quat.
	
	objzRot = eulerAngles 0 0 zRot2 -- Create a dummy rotation with zeroed out X and Y values for deriving the camera quat.
	objzRot2 = objzRot as quat -- Convert dummy rotation to a quaternion.
	
	format "===================================================\n"
	format "Object data formatted for KOTOR GIT injection\n"
	format "--------------------- GENERIC ---------------------\n"
	format "SELECTED OBJECT: %\n" objName
	format "POSITION (in metres): %, %, %\n" (toMetres objPos.x) (toMetres objPos.y) (toMetres objPos.z) -- Use unit conversion function to ensure position is in metres regardless of system units.
	format "ROTATION (in degrees): %, %, %\n" xRot yRot zRot
	format "------------------ STATIC CAMERA ------------------\n"
	format "PITCH (X rotation in degrees): %\n" xRot
	format "ORIENTATION (Z rotation as a WXYZ quaternion):\n%, %, %, %\n" objzRot2.w objzRot2.x objzRot2.y objzRot2.z -- Separate out quaternion components to reorder as WXYZ (Max default is XYZW).
	format "-------------------- PLACEABLE --------------------\n"
	format "BEARING (Z rotation in radians): %\n" zRads
	format "-------------------- SCRIPTING --------------------\n"
	format "Location(Vector(%,%,%), %)\n" (toMetres objPos.x) (toMetres objPos.y) (toMetres objPos.z) zRotKTR
	format "-------------------- CREATURE ---------------------\n"
	format "X ORIENTATION ( COS(Z + 90°) ): %\n" zCos
	format "Y ORIENTATION ( SIN(Z + 90°) ): %\n" zSin
	format "===================================================\n"
	format "\n"
)
