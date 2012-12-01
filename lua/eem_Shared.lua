//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// add every new class (entity based) here

LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/NS2Gamerules_hook.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/TeleportTrigger.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/FuncTrain.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/FuncTrainWaypoint.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/PushTrigger.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/TimedDoor.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/PortalGunTeleport.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/logic.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/logic_timer.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/logic_multiplier.lua", nil)
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/logic_weldable.lua", nil)

LoadTracker:LoadScriptAfter("lua/weapons/Marine/Rifle.lua", "lua/PortalGun.lua", nil)

// file overrides
LoadTracker:LoadScriptAfter("lua/Shared.lua", "lua/eem_MovementModifier.lua", nil)


