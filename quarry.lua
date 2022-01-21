args = {...}
local homeX, homeY, homeZ = 0,0,0
local maxX, maxY, maxZ = 0,0,0
local currentX, currentY, currentZ, currentDir = 0,0,0,0

function contains(list, x)
	for _, v in pairs(list) do
		if v == x then
			return true 
		end
	end
	return false
end

function refuel()
	hasRefueled = false
	originalSlot = turtle.getSelectedSlot()
	if turtle.getFuelLevel() < 10 then
		while not hasRefueled do
			for i=1, 16 do
				turtle.select(i)
				hasRefueled = turtle.refuel()
				if hasRefueled then
					turtle.select(originalSlot)
					return
				end
			end
		end
	end
end

function forward()
	refuel()
	if turtle.forward() then
		if     currentDir == 0 then
			currentX = currentX + 1
		elseif currentDir == 1 then
			currentZ = currentZ + 1
		elseif currentDir == 2 then
			currentX = currentX - 1
		elseif currentDir == 3 then
			currentZ = currentZ - 1
		end
		return true
	else
		return false
	end
end

function back()
	refuel()
	if turtle.back() then
		if     currentDir == 0 then
			currentX = currentX - 1
		elseif currentDir == 1 then
			currentZ = currentZ - 1
		elseif currentDir == 2 then
			currentX = currentX + 1
		elseif currentDir == 3 then
			currentZ = currentZ + 1
		end
		return true
	else
		return false
	end
end

function up()
	refuel()
	if turtle.up() then
		currentY = currentY + 1
		return true
	else
		return false
	end
end

function down()
	refuel()
	if turtle.down() then
		currentY = currentY - 1
		return true
	else
		return false
	end
end

function goToY(y)
	while currentY ~= y do
		if currentY < y then
			turtle.digUp()
			up()
		elseif currentY > y then
			turtle.digDown()
			down()
		end 
	end
end

function left()
	turtle.turnLeft()
	currentDir = currentDir - 1
	if currentDir < 0 then
		currentDir = currentDir + 4
	end
end

function right()
	turtle.turnRight()
	currentDir = currentDir + 1
	if currentDir > 3 then
		currentDir = currentDir - 4
	end
end

function turnTowards(direction)
	while direction ~= currentDir do
		left()
	end
end

function goToCoords(x, y, z)
	while currentY ~= y do
		if currentY < y then
			turtle.digUp()
			up()
		elseif currentY > y then
			turtle.digDown()
			down()
		end
	end
	
	while currentX ~= x do
		if     x > currentX then
			turnTowards(0)
		elseif x < currentX then
			turnTowards(2)
		end
		turtle.dig()
		forward()
	end
	
	while currentZ ~= z do
		if     z > currentZ then
			turnTowards(1)
		elseif z < currentZ then
			turnTowards(3)
		end
		turtle.dig()
		forward()
	end
end

function digAround()
	turtle.digUp()
	turtle.digDown()
end

function boolToNumber(val)
	if val == true then
		return 1
	elseif val == false then
		return 0
	end
end

function restock()
	for i =1, 16 do
		if turtle.getItemCount(i) == 0 then
			return
		end
	end
	savedX, savedY, savedZ, savedDir = currentX, currentY, currentZ, currentDir
	savedSlot = turtle.getSelectedSlot()
	goToCoords(homeX,homeY,homeZ)
	turnTowards(2)
	for i =1, 16 do
		turtle.select(i)
		turtle.drop()
	end
	goToCoords(savedX,savedY,savedZ)
	turnTowards(savedDir)
	turtle.select(savedSlot)
	
end


function mineSquare(x, z)
	changeDir = 1
	xVals = {0, x-1}
	pointingFromHome = true
	
	while currentZ ~= z do
		while currentX ~= xVals[boolToNumber(pointingFromHome) + 1] do
			turtle.dig()
			digAround()
			forward()
			restock()
		end
		if currentZ ~= z-1 then
			digAround()
			if changeDir % 2 == 0 then
				left()
			else
				right()
			end
			turtle.dig()
			forward()
			if changeDir % 2 == 0 then
				left()
			else
				right()
			end
			digAround()
			changeDir = changeDir + 1
			pointingFromHome = not pointingFromHome
		else
			digAround()
			goToCoords(homeX, currentY, homeZ)
			turnTowards(0)
			return
		end
	end
	
end


function mineEverything()
	isRunning = true
	while isRunning do
		if isRunning then
			mineSquare(maxX, maxZ)
			--goToCoords(homeX, currentY, homeZ)
			print(currentY)
			print(maxY)
			if currentY == maxY + 2 then
			else
				return
			end
		end
		for i =0, 2 do
			if currentY - i == maxY then
				isRunning = false
			end
		end
	end

	if currentY == maxY + 2 then
		mineSquare(maxX, maxZ)
		goToY(maxY + 1)
	end
	if currentY == maxY + 1 then
		mineSquare(maxX, maxZ)
	end
	if currentY == maxY then
		goToY(maxY + 1)
		mineSquare(maxX, maxZ)
	end
	goToCoords(homeX,homeY,homeZ)
end



function main()
	if #args ~= 3 then
		print("Usage: quarry <distance forward> <distance down> <distance right>")
	else
		maxX, maxY, maxZ = tonumber(args[1]),tonumber(args[2]) * -1 ,tonumber(args[3])
		print(maxY)
		mineEverything()
	end
end

main()