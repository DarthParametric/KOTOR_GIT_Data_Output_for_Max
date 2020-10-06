/***=========================================================
	KOTOR GIT Trigger Output for Max
	
	A script for Max/GMax that will output the vertex position
	offsets from a trigger's pivot to the Listener window that
	is required for injecting into a GIT, used in KOTOR.
	
	DP 2020-10-06
=========================================================***/

-- Unit conversion function created by martinB. Converts the value in unitVal into metres, taking into account the current system units.
-- Source: https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100

fn toMetres unitVal = (
	scaleFactor = units.decodeValue "1m" -- This many system units make up one metre.
	unitVal/scaleFactor 
)

-- Rounding function created by Guessmyname. Rounds a float to a set number of decimal places.
-- Source: http://www.scriptspot.com/forums/3ds-max/general-scripting/printing-out-float-values-to-a-few-decimal-points

fn roundFloat val dp = (
	a = val * (10^dp)
	b = a as integer
	a = b as float / (10^dp)
	return a
)

global vertLimit = 10 -- This is max number of verts the script will address. Objects with a higher vert count will be skipped. Adjust as needed but use high values at your own risk.

for obj in selection do (
	
	objName = obj.name -- Selected object's name.
	objPos = obj.pos -- Object position.
	
	local objTrigger = snapshotAsMesh obj
	
	vertCount = getNumVerts objTrigger
	
	format "===================================================\n"
	format "Trigger data formatted for KOTOR GIT injection\n"
	format "---------------------------------------------------\n"
	format "SELECTED OBJECT: %\n" objName
	format "POSITION (in metres): %, %, %\n" (toMetres objPos.x) (toMetres objPos.y) (roundFloat (toMetres objPos.z) 5) -- Use unit conversion function to ensure position is in metres regardless of system units.
	format "----------------- VERTEX OFFSETS ------------------\n"
	
    if vertCount > vertLimit then -- Skip any mesh with more than 10 verts (by default) to prevent excessive memory use, since a trigger usually only needs 4.
		(
			format "Mesh has more than % verts, skipping.\n" vertLimit
		)
		else 
			(
				for v = 1 to vertCount do -- For anything else, loop through all vertices.
					(
						vert = getVert objTrigger v -- Get the v-th vertex.
						vertX = vert.x - objPos.x -- Derive vert's X offset from object pivot
						vertY = vert.y - objPos.y -- Derive vert's Y offset from object pivot
						vertZ = vert.z - objPos.z -- Derive vert's Z offset from object pivot
						
						-- Output position for the selected vertex in metres. Since GMax apparently has less float precision than modern Max, cap values to 5 decimal places to eliminate unwieldy exponentials.
						format "Vert %: %, %, %\n" v (roundFloat (toMetres vertX) 5) (roundFloat (toMetres vertY) 5) (roundFloat (toMetres vertZ) 5)
					)
			)
	
	delete objTrigger
	
	format "===================================================\n"
	format "\n"
)

			format "Mesh has more than 10 verts, skipping.\n"
		)

	if vertCount <= 10 then for v = 1 to vertCount do -- For anything else, loop through all vertices.
		(
			vert = getVert objTrigger v -- Get the v-th vertex.
			vertX = vert.x - objPos.x -- Derive vert's X offset from object pivot
			vertY = vert.y - objPos.y -- Derive vert's Y offset from object pivot
			vertZ = vert.z - objPos.z -- Derive vert's Z offset from object pivot
			
			-- Output position for the selected vertex in metres. Since GMax apparently has less float precision than modern Max, cap values to 5 decimal places to eliminate unwieldy exponentials.
			format "Vert %: %, %, %\n" v (roundFloat (toMetres vertX) 5) (roundFloat (toMetres vertY) 5) (roundFloat (toMetres vertZ) 5)
		)
	
	delete objTrigger
	
	format "===================================================\n"
	format "\n"
)
