//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Factions_GUIGameTimeCountDown.lua

Script.Load("lua/Factions/Factions_Utility.lua")

class 'Factions_GUIGameTimeCountDown' (GUIAnimatedScript)

Factions_GUIGameTimeCountDown.kBackgroundTexture = "ui/Factions/timer/timer_bg.dds"

Factions_GUIGameTimeCountDown.kBackgroundWidth = GUIScale(135)
Factions_GUIGameTimeCountDown.kBackgroundHeight = GUIScale(50)
Factions_GUIGameTimeCountDown.kBackgroundOffsetX = GUIScale(0)
Factions_GUIGameTimeCountDown.kBackgroundOffsetY = GUIScale(0)

Factions_GUIGameTimeCountDown.kTimeOffset = Vector(0, GUIScale(-5), 0)
Factions_GUIGameTimeCountDown.kTimeFontName = "fonts/Arial_20.fnt"
Factions_GUIGameTimeCountDown.kTimeFontSize = 20
Factions_GUIGameTimeCountDown.kTimeBold = true

Factions_GUIGameTimeCountDown.kBgCoords = {14, 0, 112, 34}

Factions_GUIGameTimeCountDown.kBackgroundColor = Color(1, 1, 1, 0.7)
Factions_GUIGameTimeCountDown.kMarineTextColor = kMarineFontColor
Factions_GUIGameTimeCountDown.kAlienTextColor = kAlienFontColor

local function GetTeamType()

	local player = Client.GetLocalPlayer()
	
	if not player:isa("ReadyRoomPlayer") then	
		local teamnumber = player:GetTeamNumber()
		local teamType = GetGamerulesInfo():GetTeamType(teamnumber)
		if teamType == kMarineTeamType then
			return "Marines"
		elseif teamType == kAlienTeamType then
			return "Aliens"
		elseif teamType == kNeutralTeamType then 
			return "Spectator"
		else
			return "Unknown"
		end
	else
		return "Ready Room"
	end
	
end


function Factions_GUIGameTimeCountDown:Initialize()    

	GUIAnimatedScript.Initialize(self)
    
	// Used for Global Offset
	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetPosition( Vector(0, 0, 0) ) 
    self.background:SetIsVisible(true)
    self.background:SetLayer(kGUILayerPlayerHUDBackground)
    self.background:SetColor( Color(1, 1, 1, 0) )
	
    // Timer display background
    self.timerBackground = self:CreateAnimatedGraphicItem()
    self.timerBackground:SetSize( Vector(Factions_GUIGameTimeCountDown.kBackgroundWidth, Factions_GUIGameTimeCountDown.kBackgroundHeight, 0) )
    self.timerBackground:SetPosition(Vector(Factions_GUIGameTimeCountDown.kBackgroundOffsetX - (Factions_GUIGameTimeCountDown.kBackgroundWidth / 2), Factions_GUIGameTimeCountDown.kBackgroundOffsetY, 0))
    self.timerBackground:SetAnchor(GUIItem.Middle, GUIItem.Top) 
    self.timerBackground:SetLayer(kGUILayerPlayerHUD)
    self.timerBackground:SetTexture(Factions_GUIGameTimeCountDown.kBackgroundTexture)
    self.timerBackground:SetTexturePixelCoordinates(unpack(Factions_GUIGameTimeCountDown.kBgCoords))
	self.timerBackground:SetColor( Factions_GUIGameTimeCountDown.kBackgroundColor )
	self.timerBackground:SetIsVisible(false)
	
	// Time remaining
    self.timeRemainingText = self:CreateAnimatedTextItem()
    self.timeRemainingText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.timeRemainingText:SetPosition(Factions_GUIGameTimeCountDown.kTimeOffset)
	self.timeRemainingText:SetLayer(kGUILayerPlayerHUDForeground1)
	self.timeRemainingText:SetTextAlignmentX(GUIItem.Align_Center)
    self.timeRemainingText:SetTextAlignmentY(GUIItem.Align_Center)
	self.timeRemainingText:SetText("")
	self.timeRemainingText:SetColor(Color(1,1,1,1))
	self.timeRemainingText:SetFontSize(Factions_GUIGameTimeCountDown.kTimeFontSize)
    self.timeRemainingText:SetFontName(Factions_GUIGameTimeCountDown.kTimeFontName)
	self.timeRemainingText:SetFontIsBold(Factions_GUIGameTimeCountDown.kTimeBold)
	self.timeRemainingText:SetIsVisible(true)
 
	self.background:AddChild(self.timerBackground)
	self.timerBackground:AddChild(self.timeRemainingText)
    self:Update(0)

end

function Factions_GUIGameTimeCountDown:Update(deltaTime)

    local player = Client.GetLocalPlayer()
	
	// Alter the display based on team, status.
	local newTeam = false
	if (self.playerTeam ~= GetTeamType()) then
		self.playerTeam = GetTeamType()
		newTeam = true
	end
	
	if (newTeam) then
		if (self.playerTeam == "Marines") then
			self.timeRemainingText:SetColor(Factions_GUIGameTimeCountDown.kMarineTextColor)
			self.showTimer = true
		elseif (self.playerTeam == "Aliens") then
			self.timeRemainingText:SetColor(Factions_GUIGameTimeCountDown.kAlienTextColor)
			self.showTimer = true
		else
			self.timerBackground:SetIsVisible(false)
			self.showTimer = false
		end
	end
    
	local player = Client.GetLocalPlayer()
	if (self.showTimer and player:GetIsAlive()) then
		self.timerBackground:SetIsVisible(true)
		local TimeRemaining = GetGamerulesInfo():GetTimeRemainingDigital()
		self.timeRemainingText:SetText(TimeRemaining)
	else
		self.timerBackground:SetIsVisible(false)
	end

end


function Factions_GUIGameTimeCountDown:Uninitialize()

	GUI.DestroyItem(self.timeRemainingText)
	GUI.DestroyItem(self.timerBackground)
    GUI.DestroyItem(self.background)

end