// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Door.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Door.lua")
Script.Load("lua/LogicMixin.lua")
Script.Load("lua/ObstacleMixin.lua")

class 'FuncDoor' (Door)

FuncDoor.kMapName = "func_door"

FuncDoor.kState = enum( {'Open', 'Locked'} )
FuncDoor.kStateSound = { [FuncDoor.kState.Open] = FuncDoor.kOpenSound, 
                          [FuncDoor.kState.Locked] = FuncDoor.kLockSound,
                        }

local kModelNameDefault = PrecacheAsset("models/misc/door/door.model")
local kModelNameClean = PrecacheAsset("models/misc/door/door_clean.model")
local kModelNameDestroyed = PrecacheAsset("models/misc/door/door_destroyed.model")

local kDoorAnimationGraph = PrecacheAsset("models/misc/door/door.animation_graph")

local networkVars =
{
}

AddMixinNetworkVars(LogicMixin, networkVars)
AddMixinNetworkVars(ObstacleMixin, networkVars)

function FuncDoor:OnCreate()

    Door.OnCreate(self)
    InitMixin(self, ObstacleMixin)

end

local function InitModel(self)

    local modelName = kModelNameDefault
    if self.clean then
        modelName = kModelNameClean
    end
    
    self:SetModel(modelName, kDoorAnimationGraph)
    
end

function FuncDoor:OnInitialized()

    Door.OnInitialized(self) 
    InitModel(self)
    
    if self.startsOpen then
        self:SetState(Door.kState.Open)
    else
        self:SetState(Door.kState.Welded)
    end
    
    if Server then
        InitMixin(self, LogicMixin) 
        self:SetUpdates(true)
        if self.stayOpen then  
            self.timedCallbacks = {}
        end
        // the ObsticleMixin includes the object automatically to the mesh
        self.AddedToMesh = true
        self:SetPhysicsType(PhysicsType.Kinematic)
        self:SetPhysicsGroup(PhysicsGroup.BigStructuresGroup)
    end

end

function FuncDoor:OnUpdate(deltaTime) 
    local state = self:GetState()
    if state and (state == Door.kState.Welded or state == Door.kState.Locked) then
        if not self.AddedToMesh then
            self:AddToMesh()
            self.AddedToMesh = true
        end
    else
        if self.AddedToMesh then
            for obstacle, v in pairs(gAllObstacles) do
                if obstacle == self then
                    obstacle:RemoveFromMesh()
                end
            end                
            self.AddedToMesh = false
        end
    end
end

function FuncDoor:Reset() 
    Door.Reset(self)
    
    if self.startsOpen then
        self:SetState(Door.kState.Open)
    else
        self:SetState(Door.kState.Welded)
    end
  
    InitModel(self)
end

function FuncDoor:OnUse(player, elapsedTime)
end

function FuncDoor:OnWeldOverride(doer, elapsedTime)
end

function FuncDoor:GetWeldPercentageOverride()
end

function FuncDoor:GetCanBeWeldedOverride()
    return false
end

function FuncDoor:GetCanTakeDamageOverride()
    return false
end

function FuncDoor:OnLogicTrigger()

    local state = self:GetState()
    if state ~= Door.kState.Welded then
        self:SetState(Door.kState.Welded)
    else
        self:SetState(Door.kState.Open)
    end
    
end

Shared.LinkClassToMap("FuncDoor", FuncDoor.kMapName, networkVars)