/***=========================================================
	KOTOR GIT Trigger Output for Max
	
	A script for Max/GMax that will output the vertex position
	offsets from a trigger's pivot to the Listener window that
	is required for injecting into a GIT, used in KOTOR.
	Revised functionality contributed by JCarter426.
	
	N.B.: Appears that the vert order only is only correctly
	derived for convex shapes.
	
	DP 2022-09-23
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

-- Calculate the angle between two points

fn angleBetweenPoints p1 p2 = (
	return atan2 (p2.y-p1.y) (p2.x-p1.x)
)

-- Calculates the center of an array of points

fn findCenterOfPoints points = (
	x = 0
	y = 0
	for p in points do (
		x += p.x
		y += p.y
	)
	
	return point3 (x/points.count) (y/points.count) 0.0
)

-- Calculates the center of an array of vertices.
-- Each vertex is a pair of (position, index).

fn findCenterOfVerts verts = (
	points = #()
	for i = 1 to verts.count do (
		points[i] = verts[i][1]
	)
	
	return findCenterOfPoints points
)

-- Compare two points by the angle between each point and a central position

fn comparePointsByAngle p1 p2 center: = (
	a1 = angleBetweenPoints p1 center
	a2 = angleBetweenPoints p2 center
	if a1 == a2 then (
		dist1 = distance p1 center
		dist2 = distance p2 center
		
		return if dist1 < dist2 then -1 else if dist1 > dist2 then 1 else 0
	)
	else (
		return if a1 < a2 then -1 else if a1 > a2 then 1 else 0
	)
)

-- Compare two vertices by the angle between each vertex and a central point.
-- Each vertex is a pair of (position, index).

fn compareVertsByAngle v1 v2 center: = (
	return comparePointsByAngle v1[1] v2[1] center: center
)

global vertLimit = 10 -- This is the max number of verts the script will address. Objects with a higher vert count will be skipped. Adjust as needed but use high values at your own risk.

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
				verts = #()
				for i = 1 to vertCount do (
					verts[i] = #(getVert objTrigger i, i)
				)
				center = findCenterOfVerts verts
				qSort verts compareVertsByAngle center: center
				
				for vert in verts do (
						vertX = vert[1].x - objPos.x -- Derive vert's X offset from object pivot.
						vertY = vert[1].y - objPos.y -- Derive vert's Y offset from object pivot.
						vertZ = vert[1].z - objPos.z -- Derive vert's Z offset from object pivot.
						
						-- Output position for the selected vertex in metres. Since GMax apparently has less float precision than modern Max, cap values to 5 decimal places to eliminate unwieldy exponentials.
						format "Vert %: %, %, %\n" vert[2] (roundFloat (toMetres vertX) 5) (roundFloat (toMetres vertY) 5) (roundFloat (toMetres vertZ) 5)
					)
			)
	
	delete objTrigger
	
	format "===================================================\n"
	format "\n"
)
