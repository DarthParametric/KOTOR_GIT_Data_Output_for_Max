/***==================================================================================
	KOTOR GIT Orientation Converter for Max
	
	A script for Max/GMax that will take a user-entered	creature X/Y orientation
	or static camera quaternion from a KOTOR GIT file and convert it into a	valid
	Euler Z axis orientation for use in 3DSMax or GMax.
	
	DP 2020-10-07 / 2021-11-17
==================================================================================***/

try (closerolloutfloater convFloat)catch() -- Check for an existing instance of the floater.

-- Bad characters filter function created by thatoneguy. Prevents users entering undesirable characters into a rollout textbox.
-- https://forums.cgsociety.org/t/limit-an-edit-box-to-integer-float-value/1299552/3
fn FilterNumbers t = (
	badchars = " ABCDFGHIJKLMNOPQRSTUVWXYZabcdfghijklmnopqrstuvwxyz/?>,<+=_)([]{}*&^%$#@!~`;:'|\\" -- Can also add \" (escaped double quotes) but it screws up the N++ editor formatting. Additionally, don't filter E/e for use in exponentials. 
	WorkingString = ""
	t = filterstring t badchars
	
	for i=1 to t.count do WorkingString += t[i]
	
	t = WorkingString
	WorkingString = filterstring t "." splitEmptyTokens:true
	
	if WorkingString.count > 2 do
		(
			t = ""
			t += WorkingString[1]+"."
			for i = 2 to WorkingString.count do t+= WorkingString[i]
		)
	return t
)

-- Determine what version of Max is being using. The primary interest is whether it is GMax (v4200), since that errors out on the FilterNumbers function.
-- Version check idea taken from KOTORMax by bead-v, https://deadlystream.com/files/file/1151-kotormax/
maxCheckDP = (maxversion())[1]

convFloat = newRolloutFloater "GIT Orientation Converter" 300 365 -- Declare the floater variable first to prevent Max throwing an undeclared error when hitting the close button the first time the script runs.

rollout kOriPanel "KOTOR Creature X/Y Orientation Converter" ( -- Create the orientation entry rollout.
	
	edittext fieldXOri "XOrientation:" labelOnTop:true
	edittext fieldYOri "YOrientation:" labelOnTop:true
	button btConvertOri "Convert" align:#left offset:[60,0] width:50
	button btCloseOri "Close" align:#right offset:[-60,-26.5] width:50
	
	on fieldXOri changed t do
		(
			if maxCheckDP > 4200 then -- Since GMax freaks out about the bad character filter, only use on Max
				(
					fieldXOri.text = filterNumbers t -- Prevent non-numerical values being entered into the textbox.
				)
		)
	
	on fieldYOri changed t do
		(
			if maxCheckDP > 4200 then
				(
					fieldYOri.text = filterNumbers t
				)
		)
	
	on btConvertOri pressed do -- Convert button action.
		(
			strXOri = fieldXOri.text
			strYOri = fieldYOri.text
			
			if strXOri.count > 0 and strYOri.count > 0 then -- Safety check to only process the button click if both fields contain data.
				(
					inOriX = strXOri as float -- Convert the user-entered numbers into floats.
					inOriY = strYOri as float
					
					local angDeg					
					
					angDeg = (atan2 inOriY inOriX) -- Simplified calculation thanks to ndix UR.
					
					angDeg2 = angDeg - 90
					
					if angDeg2 < 0 and (angDeg2 + 360) < 180 then -- Rationalise adjusted Max angles under 180°
						(
							angDeg2 += 360
						)
					
					format "===================================================\n"
					format "KOTOR Creature X\Y Orientation Converter for Max\n"
					format "---------------------------------------------------\n"
					format "X ORIENTATION: %\n" inOriX
					format "Y ORIENTATION: %\n" inOriY
					format "------------------- CONVERSION --------------------\n"
					format "IN-GAME FACING (in °): %\n" angDeg
					format "MAX Z ORIENTATION (in °): %\n" angDeg2
					format "===================================================\n"
					format "\n"
					
					fieldXOri.text = "" -- Once the conversion is done, clear the text fields so a fresh set of values can be entered.
					fieldYOri.text = ""
				)
		)
	
	on btCloseOri pressed do -- Close button action.
		(
			if convFloat != undefined then closerolloutfloater convFloat -- Close the parent pop-up dialogue.
		)
)

rollout KCamRotConvert "KOTOR Static Camera Orientation Converter" ( -- Create the camera orientation conversion entry rollout.
	
	edittext fieldCamWOri "W:" labelOnTop:true
	edittext fieldCamXOri "X:" labelOnTop:true
	edittext fieldCamYOri "Y:" labelOnTop:true
	edittext fieldCamZOri "Z:" labelOnTop:true
	button btConvertCam "Convert" align:#left offset:[60,0] width:50
	button btCloseCam "Close" align:#right offset:[-60,-26.5] width:50
	
	on fieldCamWOri changed t do
		(
			-- These values are always zero, since the quat is only a Z rotation
			fieldCamXOri.text = "0"
			fieldCamYOri.text = "0"
			
			if maxCheckDP > 4200 then -- Since GMax freaks out about the bad character filter, only use on Max
				(
					fieldCamWOri.text = filterNumbers t -- Prevent non-numerical values being entered into the textbox.
				)
		)
	
	on fieldCamZOri changed t do
		(
			fieldCamXOri.text = "0"
			fieldCamYOri.text = "0"
			
			if maxCheckDP > 4200 then
				(
					fieldCamZOri.text = filterNumbers t
				)
		)
	
	on btConvertCam pressed do -- Convert button action.
		(
			strCamWOri = fieldCamWOri.text
			strCamZOri = fieldCamZOri.text
			
			if strCamWOri.count > 0 and strCamZOri.count > 0 then -- Safety check to only process the button click if both fields contain data.
				(
					inCamWOri = strCamWOri as float -- Convert the user-entered numbers into floats.
					inCamZOri = strCamZOri as float
					
					local rotQuatCam
					
					rotQuatCam = quat 0 0 inCamZOri inCamWOri
					
					local rotDegCam
					
					rotDegCam = quatToEuler rotQuatCam
					
					zCamRot = rotDegCam.Z
					
					local zCamRot2
					
					if zCamRot < 0 then zCamRot2 = abs zCamRot else zCamRot2 = 0 - zCamRot -- To account for apparent sign flipping.
					
					
					format "===================================================\n"
					format "KOTOR Static Camera Orientation Converter for Max\n"
					format "---------------------------------------------------\n"
					format "W: %\n" inCamWOri
					format "X: 0\n"
					format "Y: 0\n"
					format "Z: %\n" inCamZOri
					format "------------------- CONVERSION --------------------\n"
					format "MAX Z ORIENTATION (in °): %\n" zCamRot2
					format "===================================================\n"
					format "\n"
					
					fieldCamWOri.text = "" -- Once the conversion is done, clear the text fields so a fresh set of values can be entered.
					fieldCamXOri.text = "0"
					fieldCamYOri.text = "0"
					fieldCamZOri.text = ""
				)
		)
	
	on btCloseCam pressed do -- Close button action.
		(
			if convFloat != undefined then closerolloutfloater convFloat -- Close the parent pop-up dialogue.
		)
)

addRollout kOriPanel convFloat
addRollout KCamRotConvert convFloat
