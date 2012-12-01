
// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======    
//
// lua\LogicMixin.lua    
//
// Created by: Mats Olsson (mats.olsson@matsotech.se)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================    

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")

LogicMixin = CreateMixin( LogicMixin )
LogicMixin.type = "Logic"


LogicMixin.expectedMixins =
{
}

LogicMixin.expectedCallbacks =
{
    OnLogicTrigger = "Called when the entity is output of a timer etc."
}


LogicMixin.optionalCallbacks =
{
    FindEntitys = "Looks after output entities when map is loaded (called by NS2Gamerules_hook)."
}



LogicMixin.networkVars =  
{
}

function LogicMixin:__initmixin() 
    self.initialEnabled = self.enabled
end

function LogicMixin:Reset() 
    self.enabled = self.initialEnabled
end

function LogicMixin:SetFindEntity()
    table.insert(kFindEntitiesAfterLoad, self:GetId())
end


