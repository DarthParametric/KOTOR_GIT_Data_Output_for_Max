/***=========================================================
	KOTOR GIT Trigger Output for Max
	
	A script for Max/GMax that will output the vertex position
	offsets from a trigger's pivot to the Listener window that
	is required for injecting into a GIT, used in KOTOR.
	
	DP 2020-10-06
=========================================================***/

-- Unit conversion function created by martinB. Converts the value in unitVal into metres, taking into account the current system units.
-- Source: https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100

fn toMetres unitVal =
(
	scaleFactor = units.decodeValue "1m" -- This many system units make up one metre.
	unitVal/scaleFactor 
)

-- Rounding function created by Guessmyname. Rounds a float to a set number of decimal places.
-- Source: http://www.scriptspot.com/forums/3ds-max/general-scripting/printing-out-float-values-to-a-few-decimal-points

fn roundFloat val dp =
(
	a = val * (10^dp)
	b = a as integer
	a = b as float / (10^dp)
	return a
)


for obj in selection do 
(
	objName = obj.name -- Selected object's name.
	objPos = obj.pos -- Object position.
	
	local objTrigger = snapshotAsMesh obj
	
	vertCount = getNumVerts objTrigger
	
	format "===================================================\n"
	format "Trigger data formatted for KOTOR GIT injection\n"
	format "\n"
	format "SELECTED OBJECT: %\n" objName
	format "----------------- VERTEX OFFSETS ------------------\n"
	
    if vertCount > 10 do -- Skip any mesh with more than 10 verts to prevent excessive memory use, since a trigger usually only needs 4.
	(
		format "Mesh has more than 10 verts, skipping.\n"
	)

	if vertCount <= 10 then for v = 1 to vertCount do -- For anything else, loop through all vertices.
	(
		vert = getVert objTrigger v -- Get the v-th vertex.
		vertX = vert.x - objPos.x -- Derive vert's X offset from object pivot
		vertY = vert.y - objPos.y -- Derive vert's Y offset from object pivot
		vertZ = vert.z - objPos.z -- Derive vert's Z offset from object pivot
		
		format "Vert %: %, %, %\n" v (toMetres vertX) (toMetres vertY) (roundFloat (toMetres vertZ) 6) -- Output position for selected vertex in metres. Cap Z co-ord to 6 decimal places to eliminate unwieldy exponentials.
	)
	
	delete objTrigger
	
	format "===================================================\n"
	format "\n"
)
