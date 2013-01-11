//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// Load the script from fsfod that we can hook some functions
Script.Load("lua/PathUtil.lua")
Script.Load("lua/fsfod_scripts.lua")

// hooked classes
Script.Load("lua/eem_Shared.lua")

// original File
Script.Load("../ns2/lua/Client.lua")

// new functions etc
Script.Load("lua/eem_Player_Client.lua")
Script.Load("lua/Hud/GUIFuncTrain.lua")
