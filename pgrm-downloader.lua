-- Check if Disk Drive attached

-- Table Functions for Config
function tsave(table,name)
    local file = fs.open(name,"w")
    file.write(textutils.serialize(table))
    file.close()
end
function tload(name)
    local file = fs.open(name, "r")
    local data = file.readAll()
    file.close()
    return textutils.unserialize(data)
end

-- Configuration Setup
if fs.exists("/pgrm-dwnldr-cfg") ~= true then
    pdcfg = {}
    cfgloop = 0
    print("NOTE: This program only works with the first attached disk, categorized as '/disk/'")
    sleep(5)
    while true do
        -- Get Type of download.
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("File download type? ([G]ithub or [P]astebin?)")
            answer = read()
            if answer == "G" or answer == "P" then
                pdcfg["type"] = answer
                break
            else
                print("Input not recognized. G for Github or P for Pastebin!")
                sleep(2)
            end
        end
        -- Get file download name
        term.clear()
        term.setCursorPos(1,1)
        print("What is the name the file should be downloaded as? (Include .lua if you want it on there!)")
        answer = read()
        pdcfg["name"] = answer
        -- Get Link to download from.
        term.clear()
        term.setCursorPos(1,1)
        print("What is the link/pastebin code? (Depending on what type you selected.)")
        answer = read()
        pdcfg["link"] = answer
        -- Clear Disk first?
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("Clear Disk before download? ([Y]es or [N]o?)")
            answer = read()
            if answer == "Y" or answer == "N" then
                pdcfg["clear"] = answer
                break
            else
                print("Input not recognized. Y for Yes or N for No!")
                sleep(2)
            end
        end
        -- Get drive location/id
        term.clear()
        term.setCursorPos(1,1)
        print("What side is the drive on/what is the drive's ID? (Eg. FRONT, BACK, LEFT, RIGHT, TOP, BOTTOM, drive_0")
        answer = read()
        pdcfg["loc"] = answer
        -- Confirm Configurations
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("Type: " .. pdcfg.type)
            print("Download As: " .. pdcfg.name)
            print("Link/Code: " .. pdcfg.link)
            print("Clear Disk: " .. pdcfg.clear)
            print("Disk Drive Location: " .. pdcfg.loc)
            print()
            print("Is this correct? ")
            answer = read()
            if answer == "Y" then
                cfgloop = 1
                break
            elseif answer == "N" then
                break
            end
        end
        if cfgloop == 1 then
            break
        end
    end
    tsave(pdcfg,"/pgrm-dwnldr-cfg")
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print("Do you want this program to run on startup? (This will replace the current startup.lua file! ([Y]es or [N]o?)")
        answer = read()
        if answer == "Y" or answer == "N" then
            pdstart = fs.open("/startup.lua","w")
            pdstart.write("shell.run(\"/" .. shell.getRunningProgram() .. "\")")
            break
        else
            break
        end
    end
end

-- Get Config loaded
local pdcfg = tload("/pgrm-dwnldr-cfg")
-- Main Program
dwnldd = 0
while true do
    if disk.hasData(pdcfg.loc) then
        if dwnldd == 0 then
            if pdcfg.clear == "Y" then
                shell.run("rm disk/*")
            end
            if pdcfg.type == "G" then
                shell.run("wget " .. pdcfg.link .. " " .. "disk/" .. pdcfg.name)
            elseif pdcfg.type == "P" then
                shell.run("pastebin get " .. pdcfg.link .. " " .. "disk/" .. pdcfg.name)
            end
            dwnldd = 1
        end
    else
        dwnldd = 0
    end
    sleep(0.05)
end