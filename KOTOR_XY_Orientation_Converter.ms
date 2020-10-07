/***=========================================================
	KOTOR GIT X\Y Orientation Converter for Max
	
	A script for Max/GMax that will take a user-entered	X/Y
	Orientation from a KOTOR GIT file and convert it into a
	valid Euler orientation for use in Max.
	
	DP 2020-10-07
=========================================================***/

try (closerolloutfloater convFloat)catch() -- Check for an existing instance of the floater.

convFloat = newRolloutFloater "GIT Converter" 300 145 -- Declare the floater variable first to prevent Max throwing an undeclared error when hitting the close button the first time the script runs.

rollout kOriPanel "KOTOR X/Y Orientation Converter" ( -- Create the orientation entry rollout.
	
	-- Bad characters filter function created by thatoneguy. Prevents users entering undesirable characters into a rollout textbox.
	-- https://forums.cgsociety.org/t/limit-an-edit-box-to-integer-float-value/1299552/3
	fn FilterNumbers t = (
		badchars = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/?>,<+=_)([]{}*&^%$#@!~`;:'|\\" -- Can also add \" (escaped double quotes) but it screws up the N++ editor formatting.
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
	local maxCheck = (maxversion())[1]
	
	edittext fieldXOri "XOrientation:" fieldWidth:200 labelOnTop:true
	edittext fieldYOri "YOrientation:" fieldWidth:200 labelOnTop:true
	button btConvertOri "Convert" align:#left offset:[60,0] width:50
	button btCloseOri "Close" align:#right offset:[-60,-26.5] width:50
	
	on fieldXOri changed t do
		(
			if maxCheck > 4200 then -- Since GMax freaks out about the bad character filter, only use on Max
				(
					fieldXOri.text = filterNumbers t -- Prevent non-numerical values being entered into the textbox.
				)
		)
	
	on fieldYOri changed t do
		(
			if maxCheck > 4200 then
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
					
					/*
					Determining unit circle quadrant of the original angle:
					If XOri is positive and YOri is positive, then 0 >= angle <= 90 - Quadrant 1.
					If XOri is negative and YOri is positive, then 90 > angle <= 180 - Quadrant 2.
					If XOri is negative and YOri is negative, then 180 > angle < 270 - Quadrant 3.
					If XOri is positive and YOri is negative, then 270 >= angle < 360 - Quadrant 4.
					*/
					
					local angDeg
					
					if inOriX > 0 and inOriY > 0 then -- Angle lies in Quadrant 1
						(
							angDeg = (asin inOriY)
						)
					if inOriX < 0 and inOriY > 0 then -- Angle lies in Quadrant 2
						(
							angDeg = 180 + (asin inOriY)
						)
					if inOriX < 0 and inOriY < 0 then -- Angle lies in Quadrant 3
						(
							angDeg = 180 - (asin inOriY)
						)
					if inOriX > 0 and inOriY < 0 then -- Angle lies in Quadrant 4
						(
							angDeg = 270 - (asin inOriY)
						)
					
					angDeg2 = angDeg - 90
					
					format "===================================================\n"
					format "KOTOR GIT X\Y Orientation Converter for Max\n"
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

addRollout kOriPanel convFloat
