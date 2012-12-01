//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// PushTrigger.lua
// Entity for mappers to create teleporters

Script.Load("lua/LogicMixin.lua")

class 'PushTrigger' (Trigger)

PushTrigger.kMapName = "push_trigger"

local networkVars =
{
}

AddMixinNetworkVars(LogicMixin, networkVars)

local function PushEntity(self, entity)

    //if Server then        
        if self.enabled then
            // push the player in the direction of the trigger
            // y -1.57 in game is up in the air
            local angles =  self:GetAngles()
            local origin = self:GetOrigin()
            local force = self.pushForce
            if angles then
                // get the direction Vector the pushTrigger should push you                
                local directionVector= Vector(0,0,0)
                // pitch to vector
                directionVector.z = math.cos(angles.pitch)
                directionVector.y = -math.sin(angles.pitch)
                
                // yaw to vector
                if angles.yaw ~= 0 then
                    directionVector.x = directionVector.z * math.sin(angles.yaw)                   
                    directionVector.z = directionVector.z * math.cos(angles.yaw)                                
                end           
                
                // get him in the air a bit
                if entity:GetIsOnGround() then
                    entity:SetOrigin(entity:GetOrigin() + Vector(0,0.2,0))  
                    entity.jumping = true                 
                end 
                
                entity.pushTime = -1
                
                velocity = directionVector * force 
                entity:SetVelocity(velocity)

            end 
        end
    //end
    
end

local function PushAllInTrigger(self)

    for _, entity in ipairs(self:GetEntitiesInTrigger()) do
        PushEntity(self, entity)
    end
    
end

function PushTrigger:OnCreate()
 
    Trigger.OnCreate(self)  
    
    if Server then
        self:SetUpdates(true)  
    end
    
end

function PushTrigger:OnInitialized()

    Trigger.OnInitialized(self) 
    if Server then
        InitMixin(self, LogicMixin)   
    end
    self:SetTriggerCollisionEnabled(true) 
    
end

function PushTrigger:OnTriggerEntered(enterEnt, triggerEnt)

    if self.enabled then
         PushEntity(self, enterEnt)
    end
    
end


//Addtimedcallback had not worked, so lets search it this way
function PushTrigger:OnUpdate(deltaTime)

    if self.enabled then
        PushAllInTrigger(self)
    end
    
end


function PushTrigger:OnLogicTrigger()
    if self.enabled then
        self.enabled = false
    else
        self.enabled = true
    end
end


Shared.LinkClassToMap("PushTrigger", PushTrigger.kMapName, networkVars)