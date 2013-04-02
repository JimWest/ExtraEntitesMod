//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

// base class for spawning npcs

Script.Load("lua/ExtraEntitiesMod/LogicMixin.lua")
Script.Load("lua/ExtraEntitiesMod/npc/NpcMixin.lua")

class 'NpcManager' (Entity)

NpcManager.kMapName = "npc_wave_manager"
  
local networkVars =
{
}

AddMixinNetworkVars(LogicMixin, networkVars)

if Server then

    function NpcManager:OnCreate()
        Entity.OnCreate(self)
    end

    function NpcManager:OnInitialized()
        InitMixin(self, LogicMixin) 
        self.npcNumber = self.npcNumber or 5
        self.waveTime = self.waveTime or 20
        self.maxWaveNumber = self.maxWaveNumber or 5
        self.active = false
        self.currentWave = 1
        self:SetUpdates(true)
    end    
        
    function NpcManager:GetTechId()
        return kTechId.Skulk
    end    

    function NpcManager:Reset() 
        self.active = false
        self.lastWaveSpawn = nil
        self.currentWave = 1
    end
    
    function NpcManager:GetOutputNames()
        return {self.output1}
    end

    function NpcManager:OnLogicTrigger(player) 
        self.active = true
    end
    
    function NpcManager:OnUpdate(deltaTime) 
        if self.active then
            local time = Shared.GetTime()
            if not self.lastWaveSpawn or time - self.lastWaveSpawn >= self.waveTime then
                // spawn npcs
                local waypoint = nil
                if self.waypoint then
                    waypoint = self:GetLogicEntityWithName(self.waypoint)
                end
                for i = 1, self.npcNumber do
                    self:Spawn(waypoint)
                end
                self.lastWaveSpawn = time
                self.currentWave = self.currentWave + 1
                
                if self.currentWave >= self.maxWaveNumber then
                    // max wave reached
                    self:TriggerOutputs()
                    self:Reset()
                end
                
            end
        end 
    end
    

    function NpcManager:GetClearSpawn(class)
    
        local techId = LookupTechId(class, kTechDataMapName, kTechId.None) 
        local extents = Vector(0.17, 0.2, 0.17)
        if techId  then
             extents = LookupTechData(techId , kTechDataMaxExtents) or  extents 
        end
        // origin of entity is on ground, so make it higher
        local position = self:GetOrigin() + Vector(0, extents.y, 0)        
        
        if not GetHasRoomForCapsule(extents, position, CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, EntityFilterOne(self)) then
            // search clear spawn pos
            for index = 1, 50 do
                randomSpawn = GetRandomSpawnForCapsule(extents.y, extents.x , position , 1, 6, EntityFilterOne(self))
                if position then
                    position = randomSpawn
                    break                
                end
            end
        end
            
        return position
        
    end
    
    function NpcManager:GetSpawnClass()
        if not self.spawnClass then
        
            local class = Skulk.kMapName
            if self.class then
                if self.class == 1 then
                    class = Gorge.kMapName
                elseif self.class == 2 then
                    class = Lerk.kMapName 
                elseif self.class == 3 then
                    class = Fade.kMapName
                elseif self.class == 4 then
                    class = Onos.kMapName
                elseif self.class == 5 then
                    class = Marine.kMapName
                end
            end
                
            self.spawnClass = class
            return class
            
        else
            return self.spawnClass
        end

    end
        

    function NpcManager:GetValues()
        local spawnOrigin = self:GetClearSpawn(Skulk.kMapName)
        // values every npc needs for the npc mixin
        local values = { 
                        origin = spawnOrigin,
                        angles = self:GetAngles(),
                        team = self.team,
                        startsActive = true,
                        isaNpc = true,
                        }
        return values
    end

    function NpcManager:Spawn(waypoint)
        local values = self:GetValues() 
        if values.origin then
            local class = self:GetSpawnClass()
            if class then
                local entity = Server.CreateEntity(class, values)
                // init the xp mixin for the new npc
                InitMixin(entity, NpcMixin)
                if waypoint then
                    entity:GiveOrder(kTechId.Move , waypoint:GetId(), waypoint:GetOrigin(), nil, true, true)
                    entity.mapWaypoint = waypoint:GetId()
                end
            end
        else
            // for debugging
            Print("Found no position for npc!")
        end
    end
    
end

Shared.LinkClassToMap("NpcManager", NpcManager.kMapName, networkVars)
