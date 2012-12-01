//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// LogicWeldable.lua
// Base entity for LogicWeldable things

Script.Load("lua/LogicMixin.lua")
Script.Load("lua/WeldableMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/TeamMixin.lua")


class 'LogicWeldable' (Logic)

LogicWeldable.kMapName = "logic_weldable"

LogicWeldable.kModelName = PrecacheAsset("models/props/generic/terminals/generic_controlpanel_01.model")
local kAnimationGraph = PrecacheAsset("models/marine/sentry/sentry.animation_graph")

local networkVars =
{
    weldedPercentage = "float",
}

AddMixinNetworkVars(LogicMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)


function LogicWeldable:OnCreate()
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, TeamMixin)
end


function LogicWeldable:OnInitialized()

    InitMixin(self, WeldableMixin)
   
    if self.model ~= nil then    
        Shared.PrecacheModel(self.model)
        self:SetModel(self.model) 
        
        local coords = self:GetAngles():GetCoords(self:GetOrigin())
        coords.xAxis = coords.xAxis * self.scale.x
        coords.yAxis = coords.yAxis * self.scale.y
        coords.zAxis = coords.zAxis * self.scale.z
        self:SetCoords(coords)   
    end

    if Server then
        InitMixin(self, LogicMixin)
        
        if self.output1 then
            self:SetFindEntity()
        else
            Print("Error: No Output-Entity declared")
        end
        self:SetUpdates(true)
        self.weldPercentagePerSecond  = 1 / self.weldTime

        // weldables always belong to the Marine team.
        self:SetTeamNumber(kTeam1Index)  
    end
    self:SetHealth(0)
    self.weldedPercentage = 0
end


function LogicWeldable:OnUpdate(deltaTime)
   
    if not Client then
        if self.enabled then
            if GetGamerules():GetGameStarted() then

            end 
        end
    end
           
end


function LogicWeldable:Reset()
    self.weldedPercentage = 0
end


function LogicWeldable:GetCanTakeDamageOverride()
    return false
end


function LogicWeldable:OnWeldOverride(doer, elapsedTime)

    if Server then
        self.weldedPercentage = self.weldedPercentage + self.weldPercentagePerSecond  * elapsedTime

         if self.weldedPercentage >= 1.0 then
            self.weldedPercentage = 1.0
            self:OnWelded()
         end
    end
    
end

function LogicWeldable:GetWeldPercentageOverride()    
    return self.weldedPercentage    
end


function LogicWeldable:GetTechId()
    return kTechId.Door    
end


function LogicWeldable:FindEntitys()
    // find the output entity
    for _, entity in ientitylist(Shared.GetEntitiesWithClassname("Entity")) do
        if entity.name == self.output1 then
            self.output1_id = entity:GetId()
            break                
        end
    end
    
end


function LogicWeldable:OnWelded()
    if Server then
        if self.output1_id then
            local entity = Shared.GetEntity(self.output1_id)
            if entity then
                if  HasMixin(entity, "Logic") then
                    entity:OnLogicTrigger()
                else
                    Print("Error: Entity " .. entity.name .. " has no Logic function!")
                end
            else
                // something is wrong, search again
                self:FindEntitys()
                self:OnLogicTrigger()
            end
        else
            Print("Error: Entity " .. self.output1 .. " not found!")
            DestroyEntity(self)
        end
    end
end


function LogicWeldable:OnLogicTrigger()
    if self.enabled then
        self.enabled = false
 
    else
        self.enabled = true

    end       
end



Shared.LinkClassToMap("LogicWeldable", LogicWeldable.kMapName, networkVars)