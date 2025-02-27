id = os.getComputerID()
id = tostring(id)

function writeAliases()
    if not fs.exists("/startup.lua") then
        print("\"startup.lua\" exists. Skipping")
        return
    end
    file = io.open("/startup.lua", "w")
    file:write("shell.setAlias(\"nano\", \"edit\")\n")
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
