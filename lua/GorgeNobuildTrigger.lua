//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// GorgeNobuildTrigger.lua
// Entity for mappers to create teleporters

Script.Load("lua/Class.lua")
Script.Load("lua/LogicMixin.lua")

class 'GorgeNobuildTrigger' (Trigger)

GorgeNobuildTrigger.kMapName = "gorge_nobuild_trigger"

local networkVars =
	{
	    enabled = "boolean",
	}
	
AddMixinNetworkVars(LogicMixin, networkVars)


function GorgeNobuildTrigger:OnCreate() 
    Trigger.OnCreate(self)
end

function GorgeNobuildTrigger:OnInitialized()

    Trigger.OnInitialized(self)
    self.startEnabled = self.enabled

end


function GorgeNobuildTrigger:Reset()
    self.enabled = self.startEnabled  
end


function GorgeNobuildTrigger:OnLogicTrigger()
    if self.enabled then
         self.enabled = false
    else
         self.enabled = true
    end
end


Shared.LinkClassToMap("GorgeNobuildTrigger", GorgeNobuildTrigger.kMapName, networkVars)


// only allow building when no on NoGorgePlace
// Make sure point isn't blocking attachment entities
function GetPointBlocksAttachEntities(origin)

    local nozzles = GetEntitiesWithinRange("ResourcePoint", origin, 1.5)
    if table.count(nozzles) == 0 then
    
        local techPoints = GetEntitiesWithinRange("TechPoint", origin, 3.2)
        if table.count(techPoints) == 0 then
        
            local noBuildPoints = GetEntitiesWithinRange("GorgeNobuildTrigger", origin, 1)
            if table.count(noBuildPoints) == 0 then
                return false
            end
            
        end
        
    end
    
    return true
    
end
