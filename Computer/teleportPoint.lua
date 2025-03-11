--[[
    Version: 0.0.1 Alpha
    Lets the computer become a teleport point for enderpearl stasis chambers.
    requires the teleport.lua program for pocket computers.

]]

args = {...}

function printUse()
    term.setTextColor(colors.red)
    print("Use: " ..shell.getRunningProgram() .. " <bubble side> [dispenser side]")
    term.setTextColor(colors.white)
end

function generateNewId()
    local id = ""
    for i = 1, 5 do
        local randChars = {
            string.char(math.random(65, 65 + 25)),
            string.char(math.random(65, 65 + 25)):lower(),
            tostring(math.random(0,9))
        }
        id = id .. randChars[math.random(1, 3)]
    end
    return id
end

function getId()
    local id = ""
    if fs.exists("/data/teleportPoint.txt") then
        file = io.open("/data/teleportPoint.txt", "r")
        contents = file:read("*a")
        contents = string.gsub(contents, "%s+", "") --strip whitespace
        id = contents
        --TODO Make the Save to file system more robust
    else 
        file = io.open("/data/teleportPoint.txt", "w")
        id = generateNewId()
        file:write(id)
        file:close()
    end

    return id
end

function main()
    --Start Rednet
    for _, side in pairs(rs.getSides()) do
        if peripheral.getType(side) == "modem" then
            rednet.open(side)
        end
    end
    if not rednet.isOpen() then
        term.setTextColor(colors.red)
        print("Rednet Failed to Open.")
        print("Check Modem Status")
        term.setTextColor(colors.white)
        return -1
    end
    
    if #args < 1 or #args > 2 then
        printUse()
        return -1
    end

    bubble_side = string.lower(args[1]) --Side the Trapdoor for the bubble column is on
    if arg[2] ~= nil then
        disp_side = string.lower(args[2])   --Side The Dispenser to give another pearl is on
    end

    local teleport_id = getId()
    print("Teleport ID is: ".. teleport_id)

    rs.setOutput(bubble_side, true)

    while true do
        local id, message, protocol = rednet.receive("Teleport")
        --print(id.. ", ".. message .. ", " .. protocol)
        if message == teleport_id then
            rs.setOutput(bubble_side, false)
            os.sleep(0.5)
            rs.setOutput(bubble_side, true)
            if disp_side ~= nil then
                rs.setOutput(disp_side, true)
                os.sleep(0.1)
                rs.setOutput(disp_side, false)
            end
        end
        os.sleep(0.5)
    end

end

main()
--getId()
--print(generateNewId())
