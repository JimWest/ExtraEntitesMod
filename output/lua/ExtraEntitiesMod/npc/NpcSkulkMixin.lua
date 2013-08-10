//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")

NpcSkulkMixin = CreateMixin( NpcSkulkMixin )
NpcSkulkMixin.type = "NpcSkulk"

NpcSkulkMixin.expectedMixins =
{
    Npc = "Required to work"
}

NpcSkulkMixin.expectedCallbacks =
{
}


NpcSkulkMixin.networkVars =  
{
}


function NpcSkulkMixin:__initmixin()   
    // can use leap    
    self.twoHives = true 
    self.threeHives = true 
end


function NpcSkulkMixin:CheckImportantEvents()
end


function NpcSkulkMixin:EngagementPointOverride(target)
    // attack exos at origin
    if target:isa("Exo") then
        return target:GetOrigin()
    end
end



// use leap step sometimes
function NpcSkulkMixin:AiSpecialLogic(deltaTime)

    local order = self:GetCurrentOrder()
    if order then
        if self.points and self.index and #self.points >= self.index then
            if ((self:GetOrigin() - self.points[self.index]):GetLengthXZ() > 1.7) and not self.usedShadowStep then
                // shadow step will bring you faster forward
                // only random
                if math.random(1, 100) < 10 then                    
                    self.usedShadowStep = true
                end
            else     
                if ((self:GetOrigin() - self.points[self.index]):GetLengthXZ() <1.7) and self.usedShadowStep  then
                    // hold it if they point is far away
                    self.usedShadowStep = false
                end
            end
        end
        
        if self.usedShadowStep and not self.inTargetRange then
            self:PressButton(Move.SecondaryAttack)
        end
        
    end
end

function NpcSkulkMixin:GetHasSecondary(player)
    return true
end    
