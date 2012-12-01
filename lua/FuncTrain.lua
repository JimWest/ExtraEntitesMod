//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// FuncTrain.lua
// Entity for mappers to create drivable trains

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/Mixins/ModelMixin.lua")
Script.Load("lua/Mixins/SignalEmitterMixin.lua")
// needed for the MoveToTarget Command
Script.Load("lua/PathingMixin.lua")
Script.Load("lua/TriggerMixin.lua")
Script.Load("lua/TrainMixin.lua")

class 'FuncTrain' (ScriptActor)

FuncTrain.kMapName = "func_train"
FuncTrain.kMoveSpeed = 15.0
FuncTrain.kHoverHeight = 0.8
FuncTrain.kDrivingState = enum( {'Stop', 'Forward1', 'Forward2', 'Forward3', 'Backwards'} )

local networkVars =
{    
    drivingState = "enum FuncTrain.kDrivingState",
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TrainMixin, networkVars)


function FuncTrain:OnCreate()
 
    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, SignalEmitterMixin)
    InitMixin(self, PathingMixin)
    InitMixin(self, TrainMixin)
    
    self:SetUpdates(true)  
    
end

function FuncTrain:OnInitialized()

    ScriptActor.OnInitialized(self)
    InitMixin(self, TriggerMixin)
 
    if self.model ~= nil then    
        Shared.PrecacheModel(self.model)    
        local graphName = string.gsub(self.model, ".model", ".animation_graph")
        Shared.PrecacheAnimationGraph(graphName)        
        self:SetModel(self.model, graphName) 
        
        local coords = self:GetAngles():GetCoords(self:GetOrigin())
        coords.xAxis = coords.xAxis * self.scale.x
        coords.yAxis = coords.yAxis * self.scale.y
        coords.zAxis = coords.zAxis * self.scale.z
        self:SetCoords(coords)   
    end
    

    if self.autoStart then
        self.driving = true
        self.kDrivingState = FuncTrain.kDrivingState.Forward1
    else
        self.driving = false
        self.kDrivingState = FuncTrain.kDrivingState.Stop
    end
    
    if Server then
        // set a box so it can be triggered, use the trigger scale from the mapEditor
        self:MoveTrigger()
        self:CreatePath()
        // Save origin, angles, etc. so we can restore on reset
        self.savedOrigin = Vector(self:GetOrigin())
        self.savedAngles = Angles(self:GetAngles())
    end
   
end


function FuncTrain:Reset()

    // Restore original origin, angles, etc. as it could have been rag-dolled
    self:SetOrigin(self.savedOrigin)
    self:SetAngles(self.savedAngles)
    
end


function FuncTrain:OnUpdate(deltaTime)
    if Server then
        if self.waypointList then
            if (#self.waypointList == 0) then
                self:CreatePath()
            end
        else
            self:CreatePath()
        end
    end    
    
end


function FuncTrain:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = true
end

function FuncTrain:OnUse(player, elapsedTime, useAttachPoint, usePoint, useSuccessTable)

    if Server then   
        self:ChangeDrivingStatus()
    elseif Client then
        player:OnTrainUse(self) 
    end
    
end

//**********************************
// Driving things
//**********************************

function FuncTrain:ChangeDrivingStatus()

    if self.driving then
        self.driving = false
    else
        self.driving = true
    end  
    
    local driveString = "off"
    if self.driving then
        driveString = "on"
    end    
  
end 


function FuncTrain:SetOrigin(origin)
    // locally save the old origin
    local oldOrigin = self:GetOrigin()    
    Entity.SetOrigin(self, origin)
    
    if (oldOrigin.x + oldOrigin.y + oldOrigin.z) ~= 0 then
        self:SetMovementVector(self:GetOrigin() - oldOrigin)  
    end    
end


// set and get Velocity to update the players movement, too
function FuncTrain:SetMovementVector(newVector)
    self.movementVector = newVector   
end

function FuncTrain:GetMovementVector()
    return self.movementVector or Vector(0,0,0)     
end

function FuncTrain:SetOldAngles(newAngles)

    if self.oldAngles then
        self:SetOldAnglesDiff(newAngles)
        self.oldAngles.yaw = newAngles.yaw
        self.oldAngles.pitch = newAngles.pitch
        self.oldAngles.roll = newAngles.roll

    else
        self.oldAngles = newAngles
    end
end

function FuncTrain:SetOldAnglesDiff(newAngles)

    if self.oldAnglesDiff then
        //local turnAmount,remainingYaw = self:CalcTurnAmount(newAngles.yaw, self.oldAngles.yaw, self:GetTurnSpeed(), Shared.GetTime())
        //self.oldAnglesDiff.yaw = (newAngles.yaw - self.oldAngles.yaw)
        local newYaw = (newAngles.yaw - self.oldAngles.yaw)
        self.oldAnglesDiff.yaw = newYaw
        self.oldAnglesDiff.pitch = (newAngles.pitch - self.oldAngles.pitch)
        self.oldAnglesDiff.roll = (newAngles.roll - self.oldAngles.roll)
        
        
    else
        self.oldAnglesDiff = Angles(0,0,0)
    end
end


function FuncTrain:GetDeltaAngles()
    if not self.oldAnglesDiff then
        local angles = Angles()
        angles.pitch = 0
        angles.yaw = 0
        angles.roll = 0
        self.oldAnglesDiff = angles   
    end
    return self.oldAnglesDiff   
end

function FuncTrain:GetSpeed()
    return self.moveSpeed or FuncTrain.kMoveSpeed
end

function FuncTrain:GetIsFlying()
    return true
end

function FuncTrain:GetHoverHeight()
    return FuncTrain.kHoverHeight
end

//**********************************
// Viewing things
//**********************************

function FuncTrain:GetViewOffset()
    return self:GetCoords().yAxis * 1.2
end

function FuncTrain:GetEyePos()
    return self:GetOrigin() + self:GetViewOffset()
end

function FuncTrain:GetViewAngles()
    local viewCoords = Coords.GetLookIn(self:GetEyePos(), self:GetOrigin())
    //local viewAngles = Angles()
    //return viewAngles:BuildFromCoords(viewCoords) or self:GetAngles().yaw
    local angles = Angles(0,0,0)
    angles.yaw = GetYawFromVector(viewCoords.zAxis)
    angles.pitch = GetPitchFromVector(viewCoords.xAxis)
    return angles
end


//**********************************
// Sever and Client only functions
//**********************************

if Server then
  
    function FuncTrain:UpdatePosition(deltaTime)
       
        if self.nextWaypoint then
            // check if the waypoint got a delay
            local hoverWaypont = GetHoverAt(self, self.nextWaypoint)
            //hoverWaypont = self.nextWaypoint
            //if self:IsTargetReached(hoverWaypont, kAIMoveOrderCompleteDistance) then            
              //  self:GetNextWaypoint()
            //else
                local done = self:TrainMoveToTarget(PhysicsMask.All, hoverWaypont, self:GetSpeed(), deltaTime)                
                //if self:IsTargetReached(hoverWaypont, kAIMoveOrderCompleteDistance) then
                if done then
                    self.nextWaypoint = nil
                    self:GetNextWaypoint()
                end
            //end          

        else
            self:GetNextWaypoint()
        end            
    end 
    
    
    function FuncTrain:GetNextWaypoint()

        if #self.waypointList > 0 then
        
            if not self.nextWaypointNr then
                self.nextWaypointNr = 1
                self.nextWaypoint = self.waypointList[self.nextWaypointNr].origin               
            else
                // check if the waypoint got a delay
                local delay = self.waypointList[self.nextWaypointNr].delay 
                local time = Shared.GetTime()
    
                if not self.nextWaypointCheck then
                    self.nextWaypointCheck =  time + delay
                end
                
                if (self.waypointList[self.nextWaypointNr].delay == 0) or time >= self.nextWaypointCheck then 
                    self.waiting = false
                    self.nextWaypointNr = self.nextWaypointNr + 1
                    // TODO: Dont start at one if last Waypoint
                    if self.nextWaypointNr > #self.waypointList then
                        // end of track
                        //self.driving = false
                        //TODO : what happens then?
                        self.nextWaypointNr = 1
                    end
                    
                    self.nextWaypoint = self.waypointList[self.nextWaypointNr].origin
                    self.nextWaypointCheck = nil 
                else
                    self.waiting = true
                end 
              
            end   

        else
            Print("Error: Train " .. self.name .. " found no waypoints!")
            self.driving = false
        end
    end
    
    function FuncTrain:OnTriggerEntered(entity, triggerEnt)
    end    

    function FuncTrain:OnTriggerExited(entity, triggerEnt)
        // destroy the GUI and let the player mov again
    end
    
    // will create a path so the train will know the next points
    function FuncTrain:CreatePath(onUpdate)
        local origin = self:GetOrigin()
        local tempList = {}
        self.waypointList = {}
        for _, ent in ientitylist(Shared.GetEntitiesWithClassname("FuncTrainWaypoint")) do 
            // only search the waypoints for that train
            if ent.trainName == self.name then
                if ent.number > 0 then
                    self.waypointList[ent.number] = {}
                    self.waypointList[ent.number].origin = ent:GetOrigin()
                    self.waypointList[ent.number].delay = ent.waitDelay
                end
            end        
        end
        
        // then copy the wayPointList into a new List so its 1-n
        for i, wayPoint in ipairs(self.waypointList) do
            table.insert(tempList, wayPoint)
        end
        
        // create a smooth path
        self.waypointList = self:CreateSmoothPath(tempList, 1)        
        tempList = nil
        
        if onUpdate then
            if (#self.waypointList  == 0) then
                self:SetUpdates(false)
                Print("Error: Train " .. self.name .. " found no waypoints!")
            end
        end
    end
    
end


if Client then

    
end

Shared.LinkClassToMap("FuncTrain", FuncTrain.kMapName, networkVars)