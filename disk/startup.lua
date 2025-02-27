id = os.getComputerID()
id = tostring(id)

function file_exists(path)
    --Check if startup.lua exists
    f = io.open(path, "r")
    if f ~= nil then
        return true 
    else
        return false
    end
end

function writeAliases()
    if not file_exists("/startup.lua") then
        print("startup.lua already exists, not adding aliases")
        return
    end
    file = io.open("/startup.lua", "w")
    file:write("shell.setAlias(\"nano\", \"edit\")")
    file:write("shell.setAlias(\"cls\", \"clear\")")
    file:close()
end

function setLabel()
    if os.getComputerLabel() ~= nil then
        print("Label Already Set")
        return
    end
    if turtle then
        os.setComputerLabel("Turtle".. id)
        shell.run("copy", "/disk/turtle/*", "/")
    else
        os.setComputerLabel("Desktop"..id)
        shell.run("copy", "/disk/desktop/*", "/")
    end
end

function main()
    setLabel()
    writeAliases()
    shell.run("set", "motd.enable", "false")
    
    print("Setup Complete!")
end


main()
