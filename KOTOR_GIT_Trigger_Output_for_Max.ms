/***=========================================================
	KOTOR GIT Trigger Output for Max
	
	A script for Max/GMax that will output the vertex position
	offsets from a trigger's pivot to the Listener window that
	is required for injecting into a GIT, used in KOTOR.
	
	DP 2020-10-06
=========================================================***/

-- Unit conversion function created by martinB. Converts the value in unitVal into metres, taking into account the current system units.
-- Source: https://forums.cgsociety.org/t/get-vertex-position-by-coordinate-and-format-the-string/1836100/2
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

-- This is the maximum number of vertices in an object that the script will address. Objects with a higher vert count will be skipped. Adjust as needed but use high values at your own risk.
global vertLimit = 15

-- Account for multiple selected objects.
for obj in (selection as array) do (
	
	-- Add a prefix to the selected object's name for use in the next step.
	newObject = "shape_"+obj.name
	
	-- Make sure the selected object is an Editable Poly.
	convertToPoly obj
	
	-- Grab the boundary edges of the object.
	openedges = polyop.getopenedges obj
	
	-- Create a new Editable Spline from the object's boundary edges. We do this in order to create sequential vertex indices.
	polyop.createshape obj openedges smooth:false name:newObject
	
	-- Select the newly created Editable Spline.
	select (getNodeByName newObject)
	
	for s in selection do
		(
			-- Convert the Editable Spline to an Editable Patch in order to create a triangulated mesh.
			convertTo s Editable_Patch
			
			-- Convert it to an Editable Mesh for the next step.
			convertToMesh s
			
			-- Rename it to have the same name as the original object.
			s.name = substring s.name 7 -1
			
			-- Grab the new object's pivot position.
			objPos = s.pos 
			
			-- Count the number of vertices it has.
			vertCount = getNumVerts s
			
			format "===================================================\n"
			format "Trigger data formatted for KOTOR GIT injection\n"
			format "---------------------------------------------------\n"
			format "SELECTED OBJECT: %\n" s.name
			format "POSITION (in metres): %, %, %\n" (toMetres objPos.x) (toMetres objPos.y) (roundFloat (toMetres objPos.z) 5) -- Use unit conversion function to ensure position is in metres regardless of system units.
			format "----------------- VERTEX OFFSETS ------------------\n"
			
			-- Skip any mesh with more than 15 verts (by default) to prevent excessive memory use, since a trigger typically only needs 4-6.
			if vertCount > vertLimit then
				(
					format "Mesh has more than % verts, skipping offset list.\n" vertLimit
				)
				else 
					(
						for v = 1 to vertCount do -- For anything else, loop through all vertices.
							(
								vert = getVert s v -- Get the v-th vertex.
								vertX = vert.x - objPos.x -- Derive vert's X offset from object pivot.
								vertY = vert.y - objPos.y -- Derive vert's Y offset from object pivot.
								vertZ = vert.z - objPos.z -- Derive vert's Z offset from object pivot.
								
								-- Output position for the selected vertex in metres. Since GMax apparently has less float precision than modern Max, cap values to 5 decimal places to eliminate unwieldy exponentials.
								format "Vert %: %, %, %\n" v (roundFloat (toMetres vertX) 5) (roundFloat (toMetres vertY) 5) (roundFloat (toMetres vertZ) 5)
							)
					)
			
			format "===================================================\n"
			format "\n"
		)
	
	-- Delete the original object, since we've created a new replacement with sequential vert indices.
	delete obj
)
