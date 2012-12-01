//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Logic.lua
// Base entity for logic things

Script.Load("lua/LogicMixin.lua")

class 'Logic' (Entity)

Logic.kMapName = "logic"

local networkVars =
{
}

AddMixinNetworkVars(LogicMixin, networkVars)

function Logic:OnCreate()
    InitMixin(self, LogicMixin)
end


function Logic:OnInitialized()  
end

function Logic:OnUpdate(deltaTime)
end

function Logic:OnLogicTrigger()
end

// needed when we have more than 1 output
function Logic:GetUsedOutputs()
    local outputs = {}
    for i, output in ipairs(self.possibleOutputs) do
        if output ~= "" then
            table.insert(outputs, output)
        end
    end
    
    return outputs
end

Shared.LinkClassToMap("Logic", Logic.kMapName, networkVars)