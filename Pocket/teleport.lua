--[[
    Version: 0.0.1 Alpha
    Main interface for teleport hubs created by teleportPoint.lua for mainframe computers.    
]]

args = {...}

function printUse()
    print("Use: teleport go <location>")
    print("     teleport add <location> <id>")
    print("     teleport remove <location>")
    print("     teleport list")
end



function addLocation(location, new_id)
    local file = nil
    local contents = nil
    if fs.exists("/data/teleport.txt") then
        file = io.open("/data/teleport.txt", "r")
        contents = file:read("*a")
        contents = textutils.unserialise(contents)
        file:close()
    else
        contents = {}
        --file = io.open("/data/teleport.txt", "w")
        --print("No file found")
    end
    
    
    contents[location] = new_id
    file = io.open("/data/teleport.txt", "w")
    file:write(textutils.serialise(contents))
    file:close()
    print("Location \"" .. location .. "\" Saved")
end

function removeLocation(location)
    local file = nil
    local contents = nil
    if fs.exists("/data/teleport.txt") then
        file = io.open("/data/teleport.txt", "r")
        contents = file:read("*a")
        contents = textutils.unserialise(contents)
        file:close()
    else
        print("No Locations Saved")
        return -1
    end
    
    if contents[location] == nil then
        print("No Location named \"" .. location .. "\"")
        return 0
    end
    contents[location] = nil
    file = io.open("/data/teleport.txt", "w")
    file:write(textutils.serialise(contents))
    file:close()
    print("Location \"" .. location .. "\" Removed")
end

function go(location)
    local contents = nil
    if fs.exists("/data/teleport.txt") then
        local file = io.open("/data/teleport.txt", "r")
        contents = file:read("*a")
        contents = textutils.unserialise(contents)
        file:close()
    else
        print("No Locations Saved")
        return -1
    end

    if contents[location] == nil then
        print("No location \"" .. location .. "\" registered")
    else
        rednet.open("back")
        rednet.broadcast(contents[location], "Teleport")
        rednet.close()
    end
end

function list()
    local contents = nil
    if fs.exists("/data/teleport.txt") then
        local file = io.open("/data/teleport.txt", "r")
        contents = file:read("*a")
        contents = textutils.unserialise(contents)
        file:close()
    else
        print("No Locations Saved")
        return -1
    end

    if #contents == 0 then
        print("No Locations Saved")
        return 0
    end

    print("----Saved Locations----")
    for key, value in pairs(contents) do
        print("    " .. key)
    end
end

function main()
    if args[1] == "go" then
        if #args ~= 2 then
            printUse()
        else
            go(args[2])
        end
    elseif args[1] == "add" then
        if #args ~= 3 then
            printUse()
        else
            addLocation(args[2], args[3])
        end
    elseif args[1] == "remove" then
        if #args ~= 2 then
            printUse()
        else
            removeLocation(args[2])
        end
    elseif args[1] == "list" then
        list()
    else
        printUse()
    end
end

--addLocation("home", "12345")
--go("home")
--removeLocation("home")
main()
