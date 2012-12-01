//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// Load the script from fsfod that we can hook some functions
Script.Load("lua/PathUtil.lua")
Script.Load("lua/fsfod_scripts.lua")

Script.Load("lua/eem_Shared.lua")


Script.Load("lua/Server.lua")







function OnCommandTest(client)
    kCombatModSwitcherPath = "eemTest.txt"
    // Load the settings from file if the file exists.
    local settings = { }
    local settingsFile = io.open(kCombatModSwitcherPath, "w")
    if settingsFile then

       local fileContents = settingsFile:read("*all")
        settings = json.decode(fileContents)        
   end
   settingsFile:write("TEST")
    io.close(settingsFile)
end

// Generic console commands
Event.Hook("Console_test", OnCommandTest)
