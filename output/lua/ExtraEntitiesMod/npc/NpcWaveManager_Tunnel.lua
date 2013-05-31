//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/ModelMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/ExtraEntitiesMod/LogicMixin.lua")

class 'NpcManagerTunnel' (Entity)

NpcManagerTunnel.kMapName = "npc_wave_manager_tunnel"

local networkVars = {
}

AddMixinNetworkVars(LogicMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)

if Server then

	function NpcManagerTunnel:OnCreate()
	end
	
	function NpcManagerTunnel:OnKill()
	end
	
end

Shared.LinkClassToMap("NpcManagerTunnel", NpcManagerTunnel.kMapName, networkVars)