/***=========================================================
	KOTOR GIT X\Y Orientation Converter for Max
	
	A script for Max/GMax that will take a user-entered	X/Y
	Orientation from a KOTOR GIT file and convert it into a
	valid Euler orientation for use in Max.
	
	DP 2020-10-07
=========================================================***/

-- Bad characters filter function created by thatoneguy. Prevents users entering undesirable characters into a rollout textbox.
-- https://forums.cgsociety.org/t/limit-an-edit-box-to-integer-float-value/1299552/3
try (destroydialog kOriPanel)catch()

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

rollout kOriPanel "KOTOR X/Y Orientation Converter" ( -- Create orientation entry rollout.
	edittext fieldXOri "XOrientation:" fieldWidth:200 labelOnTop:true
	edittext fieldYOri "YOrientation:" fieldWidth:200 labelOnTop:true
	button btOKOri "OK" align:#left offset:[60,0] width:50
	button btCanOri "Cancel" align:#right offset:[-60,-26.5] width:50
	
	on fieldXOri changed t do -- Prevent non-numerical values being entered into the textbox.
		(
			fieldXOri.text = filterNumbers t
		)
	
	on fieldYOri changed t do -- Prevent non-numerical values being entered into the textbox.
		(
			fieldYOri.text = filterNumbers t
		)
	
	on btCanOri pressed do
		(
			confirmed = true
			closeRolloutFloater convFloat
		)
		
	on btOKOri pressed do
		(
			inOriX = fieldXOri.text as float -- Convert the user-entered numbers into floats.
			inOriY = fieldYOri.text as float
			
			/*
			Determining unit circle quadrant of the original angle:
			If XOri is positive and YOri is positive, then 0 >= angle <= 90 - Quadrant 1
			If XOri is negative and YOri is positive, then 90 > angle <= 180 - Quadrant 2
			If XOri is negative and YOri is negative, then 180 > angle < 270 - Quadrant 3
			If XOri is positive and YOri is negative, then 270 >= angle < 360 - Quadrant 4
			*/
			local angDeg
			
			if inOriX > 0 and inOriY > 0 then
				(
					-- Angle lies in Quadrant 1
					angDeg = (asin inOriY)
				)
			if inOriX < 0 and inOriY > 0 then
				(
					-- Angle lies in Quadrant 2
					angDeg = 180 + (asin inOriY)
				)
			if inOriX < 0 and inOriY < 0 then
				(
					-- Angle lies in Quadrant 3
					angDeg = 180 - (asin inOriY)
				)
			if inOriX > 0 and inOriY < 0 then
				(
					-- Angle lies in Quadrant 4
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
			
			confirmed = true
			closeRolloutFloater convFloat
		)
)

convFloat = newRolloutFloater "GIT Converter" 300 145
addRollout kOriPanel convFloat
