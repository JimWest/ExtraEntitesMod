//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________
// FuncPlatform.lua
// Entity for mappers to create drivable trains

Script.Load("lua/ExtraEntitiesMod/FuncTrain.lua")

class 'FuncPlatform' (FuncTrain)

FuncPlatform.kMapName = "func_platform"
FuncPlatform.kMoveSpeed = 15.0
FuncPlatform.kHoverHeight = 0.8

local networkVars =
{    
}

function FuncPlatform:OnCreate() 
    FuncTrain.OnCreate(self)    
end

function FuncPlatform:OnInitialized()
    FuncTrain.OnInitialized(self)
end

function FuncPlatform:GetCanBeUsed(player, useSuccessTable)
    // TODO: not usable, only trigerable
end

//**********************************
// Driving things
//**********************************

function FuncPlatform:GetRotationEnabled()
    return false
end

//**********************************
// Viewing things
//**********************************

//**********************************
// Sever and Client only functions
//**********************************

if Server then  
end



Shared.LinkClassToMap("FuncPlatform", FuncPlatform.kMapName, networkVars)