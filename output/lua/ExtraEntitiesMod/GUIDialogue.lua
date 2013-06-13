//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// modified from GuiExploreHint


Script.Load("lua/GUIScript.lua")
Script.Load("lua/NS2Utility.lua")

class 'GUIDialogue' (GUIScript)

local kFadeMode = enum({ 'FadeIn', 'FadeOut', 'Normal' })

GUIDialogue.kAlienBackgroundTexture = "ui/alien_commander_background.dds"
GUIDialogue.kMarineBackgroundTexture = "ui/marine_commander_background.dds"
GUIDialogue.kDefaultPortraitTexture = "ui/marine_commander_background.dds"

GUIDialogue.kRightOffset = GuiScale(50)
GUIDialogue.kTopOffset = GuiScale(50)
GUIDialogue.kPortraitBackground = { Width = GuiScale(128), Height = GuiScale(256) }
GUIDialogue.kPortraitBackgroundPos = { X = GUIDialogue.kPortraitBackground.Width - GUIDialogue.kRightOffset, Y = GUIDialogue.kTopOffset }
GUIDialogue.kPortraitBackgroundCoords = { X1 = 0, Y1 = 0, X2 = 256, Y2 = 256 }
GUIDialogue.kDialogueBackground = { Width = GuiScale(256), Height = GuiScale(128) }
GUIDialogue.kDialogueBackgroundPos = { X = GUIDialogue.kDialogueBackground.Width - GUIDialogue.kPortraitBackground.Width - GUIDialogue.kRightOffset, Y = GUIDialogue.kTopOffset }
GUIDialogue.kDialogueBackgroundCoords = { X1 = 0, Y1 = 0, X2 = 256, Y2 = 256 }
GUIDialogue.kPortraitIcon = { Width = GuiScale(128), Height = GuiScale(256) }
GUIDialogue.kPortraitIconCoords = { X1 = 0, Y1 = 0, X2 = 256, Y2 = 256 }

GUIDialogue.kBackgroundExtraXOffset = 20
GUIDialogue.kBackgroundExtraYOffset = 20

GUIDialogue.kTextXOffset = 30
GUIDialogue.kTextYOffset = 17

GUIDialogue.kMaxAlpha = 0.9
GUIDialogue.kMinAlpha = 0.1
GUIDialogue.kFadeOutRate = 0.5

function GUIDialogue:Initialize()

    self.textureName = GUIDialogue.kMarineBackgroundTexture
    if PlayerUI_IsOnAlienTeam() then
        self.textureName = GUIDialogue.kAlienBackgroundTexture
    end
    
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(Color(0, 0, 0, 0))
    // 1 above main menu,    
    self.background:SetLayer(kGUILayerMainMenu - 1)
    
    // Initialise the portrait
    self:InitializePortrait()
    self:InitializeDialogue()
    
    // Set up fading
    self.fadeOutTime = 0
    self.fadeMode = kFadeMode.Normal
    self:SetIsVisible(false)
    
end

function GUIDialogue:InitializePortrait()

    self.portraitBackground = GUIManager:CreateGraphicItem()
    self.portraitBackground:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.portraitBackground:SetSize(Vector(GUIDialogue.kPortraitBackground.Width, GUIDialogue.kPortraitBackground.Height, 0))
    self.portraitBackground:SetPosition(GUIDialogue.kPortraitBackgroundPos.X, GUIDialogue.kPortraitBackgroundPos.Y)
    self.portraitBackground:SetTexture(self.textureName)
    GUISetTextureCoordinatesTable(self.portraitBackground, GUIDialogue.kPortraitBackgroundCoords)
    self.background:AddChild(self.portraitBackground)
    
    self.portraitIcon = GUIManager:CreateGraphicItem()
    self.portraitIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.portraitIcon:SetSize(Vector(GUIDialogue.kPortraitIcon.Width, GUIDialogue.kPortraitIcon.Height, 0))
    self.portraitIcon:SetTexture(GUIDialogue.kDefaultPortraitTexture)
	GUISetTextureCoordinatesTable(self.portraitIcon, GUIDialogue.kPortraitIconCoords)
    self.portraitBackground:AddChild(self.portraitIcon)
    
    self.portraitText = GUIManager:CreateTextItem()
    self.portraitText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.portraitText:SetTextAlignmentX(GUIItem.Align_Min)
    self.portraitText:SetTextAlignmentY(GUIItem.Align_Min)
    self.portraitText:SetColor(Color(1, 0, 0, 1))
    self.portraitText:SetText("Unknown")
    self.portraitText:SetFontIsBold(true)
    self.portraitText:SetIsVisible(true)
    self.portraitText:SetInheritsParentAlpha(true)
    self.portraitBackground:AddChild(self.portraitText)

end

function GUIDialogue:InitializeDialogue()

    self.dialogueBackground = GUIManager:CreateGraphicItem()
    self.dialogueBackground:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.dialogueBackground:SetSize(Vector(GUIDialogue.kDialogueBackground.Width, GUIDialogue.kDialogueBackground.Height, 0))
    self.dialogueBackground:SetPosition(GUIDialogue.kDialogueBackgroundPos.X, GUIDialogue.kDialogueBackgroundPos.Y)
    self.dialogueBackground:SetTexture(self.textureName)
    GUISetTextureCoordinatesTable(self.dialogueBackground, GUIDialogue.kDialogueBackgroundCoords)
    self.background:AddChild(self.dialogueBackground)
    
    self.dialogueText = GUIManager:CreateTextItem()
    self.dialogueText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.dialogueText:SetTextAlignmentX(GUIItem.Align_Min)
    self.dialogueText:SetTextAlignmentY(GUIItem.Align_Min)
    self.dialogueText:SetColor(Color(1, 0, 0, 1))
    self.dialogueText:SetText("Dialogue")
    self.dialogueText:SetFontIsBold(false)
    self.dialogueText:SetIsVisible(true)
    self.dialogueText:SetInheritsParentAlpha(true)
    self.dialogueBackground:AddChild(self.dialogueText)

end

function GUIDialogue:SetPortraitTexture(newTexture)
	if newTexture then
		self.portraitIcon:SetTexture(newTexture)
	else
		self.portraitIcon:SetTexture(GUIDialogue.kDefaultPortraitTexture)
	end
end

function GUIDialogue:SetDialogueText(newText)
	self.dialogueText:SetText(newText)
end

function GUIDialogue:SetPortraitText(newText)
	self.portraitText:SetText(newText)
end

function GUIDialogue:SetIsVisible(value)

	self.dialogue:SetIsVisible(value)
    self.portrait:SetIsVisible(value)

end

function GUIDialogue:GetAlpha()
	return self.portrait:GetColor().a
end

function GUIDialogue:GetTargetAlpha()
	if self.fadeMode == kFadeMode.FadeIn then
		return GUIDialogue.kMaxAlpha
	elseif self.fadeMode == kFadeMode.FadeOut then
		return GUIDialogue.kMinAlpha
	else
		return self:GetAlpha()
	end
end

function GUIDialogue:SetAlpha(alphaVal)

	local portraitColor = self.portrait:GetColor()
	portraitColor.a = alphaVal
	self.portrait:SetColor(portraitColor)
	
	local dialogueColor = self.dialogue:GetColor()
	dialogueColor.a = alphaVal
	self.dialogue:SetColor(dialogueColor)

end

function GUIDialogue:Uninitialize()

    // Everything is attached to the background so uninitializing it will destroy all items.
    if self.portrait then
        GUI.DestroyItem(self.portrait)
    end
    
    if self.dialogue then
        GUI.DestroyItem(self.dialogue)
    end
    
end

function GUIDialogue:StartFadeIn(fadeIn)
	if fadeIn then
		self.fadeMode = kFadeMode.FadeIn
	else
		self.fadeMode = kFadeMode.Normal
		self:SetAlpha(GUIDialogue.kMaxAlpha)
		self:SetIsVisible(true)
	end
end

function GUIDialogue:SetFadeoutTime(newTime)
	self.fadeOutTime = newTime
end

function GUIDialogue:StartFadeout(fadeOut)
	if fadeOut then
		self.fadeMode = kFadeMode.FadeOut
	else
		self.fadeMode = kFadeMode.Normal
		self:SetAlpha(GUIDialogue.kMinAlpha)
		self:SetIsVisible(false)
	end
end

function GUIDialogue:GetIsFading()

	return self.fadeMode == kFadeMode.Normal
	
end

function GUIDialogue:Update(deltaTime)

	if self.fadeOutTime > 0 and self.fadeOutTime <= Shared.GetTime() then
		self:StartFadeout()
		self.fadeOutTime = 0
	end

	if self:GetIsFading() then
		self:UpdateFading(deltaTime)
	end

end

function GUIDialogue:UpdateFading(deltaTime)

	// Increase/Decrease alpha
	local currentAlpha = self:GetAlpha()
	local targetAlpha = self:GetTargetAlpha()
	if currentAlpha == targetAlpha then
		self.fadeMode = kFadeMode.Normal
	else
		local nextAlpha = Slerp(currentAlpha, targetAlpha, GUIDialogue.kFadeOutRate)
		self:SetAlpha(nextAlpha)
		currentAlpha = nextAlpha
	end
	
	// Update visibility
	local visible = currentAlpha > GUIDialogue.kMinAlpha
	self:SetIsVisible(visible)

end