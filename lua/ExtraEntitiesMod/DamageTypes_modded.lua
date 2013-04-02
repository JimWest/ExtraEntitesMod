//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

kNPCDamageModifier = 0.1
// if its easy you only take half damage
local originalGetDamageByType = GetDamageByType
function GetDamageByType(target, attacker, doer, damage, damageType)
      // only for the client    
    if attacker.isaNpc and not target.isaNpc then
        damage = damage * kNPCDamageModifier
    end
    return originalGetDamageByType(target, attacker, doer, damage, damageType)
end