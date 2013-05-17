//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//	Dialogue by Winston Smith
//
//________________________________

// Apply this mixin to all human-controlled players so they can get dialogue messages

DialogueMixin.kGUIScript = "ExtraEntitiesMod/GUIDialogue"

DialogueMixin = CreateMixin( DialogueMixin )
DialogueMixin.type = "Dialogue"

DialogueMixin.expectedMixins =
{
}

DialogueMixin.expectedCallbacks =
{
}


DialogueMixin.optionalCallbacks =
{
}


DialogueMixin.networkVars =  
{
}


function DialogueMixin:__initmixin() 

	self.timeOfLastDialogue = 0
    
end

function DialogueMixin:CopyPlayerDataFrom(player) 

	self.timeOfLastDialogue = player.timeOfLastDialogue
	
end

function DialogueMixin:GetLocalGUI()

	if Client and self == Client.GetLocalPlayer() then
		return ClientUI.GetScript(DialogueMixin.kGUIScript)
	end

end

function DialogueMixin:ShowDialogue(dialogueMessage)
	if Server then
	
	elseif Client then
	
	end
end