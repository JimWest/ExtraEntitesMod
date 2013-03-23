//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/Class.lua")
Script.Load("lua/Player.lua")

// original network variables are not deleted
local networkVars =
{
}


// Modifications for the npc
// every player needs order mixin so we can give them orders etc
Script.Load("lua/OrdersMixin.lua")
AddMixinNetworkVars(OrdersMixin, networkVars)

local overridePlayerOnInitialized = Player.OnInitialized
function Player:OnInitialized()
    overridePlayerOnInitialized(self)
    //InitMixin(self, NpcMixin)
    if not HasMixin(self, "Orders") then
        InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
    end
end


Class_Reload("Player", networkVars)