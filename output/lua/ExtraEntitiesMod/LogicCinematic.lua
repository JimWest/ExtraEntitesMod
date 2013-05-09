//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// LogicCinematic.lua
// Base entity for LogicCinematic things

Script.Load("lua/ExtraEntitiesMod/LogicMixin.lua")


class 'LogicCinematic' (Entity)

LogicCinematic.kMapName = "logic_cinematic"


local networkVars =
{
    cinematicName = "string (128)",
    everyPlayer = "boolean",
    effectEntityId = "entityid",
}

AddMixinNetworkVars(LogicMixin, networkVars)


local function RetreiveInput(self)
    SetMoveInputBlocked(false)
    return false    
end


function LogicCinematic:OnCreate()
end

function LogicCinematic:OnInitialized()
    
    if Server then
        InitMixin(self, LogicMixin)
    end
    
    if self.cinematicName then
        PrecacheAsset(self.cinematicName)
    end
    
end

function LogicCinematic:Reset()
end

function LogicCinematic:GetOutputNames()
    return {self.output1}
end

function LogicCinematic:OnLogicTrigger(player)
    if self.cinematicName then
        local effectEntity = Shared.CreateEffect(nil, self.cinematicName, nil, self:GetCoords())
        self.effectEntityId = effectEntity:GetId()
    end
end


function LogicCinematic:OnUpdateRender()

    local unlockMovement = true
    if self.effectEntityId and self.effectEntityId ~= 0 then
        local effect = Shared.GetEntity(self.effectEntityId)
        if effect and effect.cinematic then

            local cullingMode = RenderCamera.CullingMode_Occlusion
            local camera = effect.cinematic:GetCamera()
            
            if camera then
            
                local player = Client.GetLocalPlayer()     

                ClientUI.DestroyUIScripts()    
                            
                // Clear game effects on player
                player:ClearGameEffects() 
               
                gRenderCamera:SetCoords(camera:GetCoords())
                gRenderCamera:SetFov(camera:GetFov())
                gRenderCamera:SetNearPlane(0.01)
                gRenderCamera:SetFarPlane(10000.0)
                gRenderCamera:SetCullingMode(cullingMode)
                Client.SetRenderCamera(gRenderCamera)
                SetMoveInputBlocked(true)
                self.moveBlocked = true
                unlockMovement  = false
            end
 
        end
    end
    
    if unlockMovement and self.moveBlocked then        
        local player = Client.GetLocalPlayer()

        // copied from OnLocalPlayerChanged(), only way I found to do this
        ClientUI.EvaluateUIVisibility(player)
        ClientResources.EvaluateResourceVisibility(player)

        player:OnInitLocalClient()

        self:AddTimedCallback(RetreiveInput, 1)   
        self.moveBlocked = false
    end

end


Shared.LinkClassToMap("LogicCinematic", LogicCinematic.kMapName, networkVars)