//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// LogicCounter.lua
// Base entity for LogicCounter things

Script.Load("lua/LogicMixin.lua")


class 'LogicCounter' (Entity)

LogicCounter.kMapName = "logic_counter"


local networkVars =
{
}

AddMixinNetworkVars(LogicMixin, networkVars)

function LogicCounter:OnCreate()
end


function LogicCounter:OnInitialized()
    
    if Server then
        InitMixin(self, LogicMixin)
        self.countAmount = 0
    end
end


function LogicCounter:Reset()
    self.countAmount = 0
end


function LogicTimer:GetOutputNames()
    return {self.output1}
end


function LogicCounter:OnLogicTrigger()

    self.countAmount = self.countAmount + 1
    if self.countAmount == self.counter then
        self:TriggerOutputs()  
        self.countAmount = 0
    end
    
end


Shared.LinkClassToMap("LogicCounter", LogicCounter.kMapName, networkVars)