//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

kBaseNpcDamage = 0.1
kNpcDamageDifficultyIncrease = 0.05

// if its easy you only take half damage
local originalGetDamageByType = GetDamageByType
function GetDamageByType(target, attacker, doer, damage, damageType)
      // only for the client    
    if attacker.isaNpc and not target.isaNpc then
		if self.difficulty then
			damage = damage * (kBaseNpcDamage + (kNpcDamageDifficultyIncrease * self.difficulty))
		else
			damage = damage * 0.1
		end
    end
    return originalGetDamageByType(target, attacker, doer, damage, damageType)
end