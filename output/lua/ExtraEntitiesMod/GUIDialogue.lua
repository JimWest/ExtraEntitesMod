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

GUIDialogue.kAlienBackgroundTexture = "ui/alien_commander_background.dds"
GUIDialogue.kMarineBackgroundTexture = "ui/marine_commander_background.dds"

GUIDialogue.kBackgroundTopCoords = { X1 = 758, Y1 = 452, X2 = 987, Y2 = 487 }
GUIDialogue.kBackgroundTopHeight = GUIDialogue.kBackgroundTopCoords.Y2 - GUIDialogue.kBackgroundTopCoords.Y1
GUIDialogue.kBackgroundCenterCoords = { X1 = 758, Y1 = 487, X2 = 987, Y2 = 505 }
GUIDialogue.kBackgroundBottomCoords = { X1 = 758, Y1 = 505, X2 = 987, Y2 = 536 }
GUIDialogue.kBackgroundBottomHeight = GUIDialogue.kBackgroundBottomCoords.Y2 - GUIDialogue.kBackgroundBottomCoords.Y1

GUIDialogue.kBackgroundExtraXOffset = 20
GUIDialogue.kBackgroundExtraYOffset = 20

GUIDialogue.kTextXOffset = 30
GUIDialogue.kTextYOffset = 17

GUIDialogue.kResourceIconSize = 32
GUIDialogue.kResourceIconTextureWidth = 32
GUIDialogue.kResourceIconTextureHeight = 32
GUIDialogue.kResourceIconXOffset = -30
GUIDialogue.kResourceIconYOffset = 20

GUIDialogue.kResourceIconTextureCoordinates = { }
// Team coordinates.
table.insert(GUIDialogue.kResourceIconTextureCoordinates, { X1 = 844, Y1 = 412, X2 = 882, Y2 = 450 })
// Personal coordinates.
table.insert(GUIDialogue.kResourceIconTextureCoordinates, { X1 = 774, Y1 = 417, X2 = 804, Y2 = 446 })
// Energy coordinates.
table.insert(GUIDialogue.kResourceIconTextureCoordinates, { X1 = 828, Y1 = 546, X2 = 859, Y2 = 577 })
// Ammo coordinates.
table.insert(GUIDialogue.kResourceIconTextureCoordinates, { X1 = 828, Y1 = 546, X2 = 859, Y2 = 577 })

GUIDialogue.kResourceColors = { Color(0, 1, 0, 1), Color(0.2, 0.4, 1, 1), Color(1, 0, 1, 1) }

GUIDialogue.kCostXOffset = -2

GUIDialogue.kRequiresTextMaxHeight = 32
GUIDialogue.kRequiresYOffset = 10

GUIDialogue.kEnablesTextMaxHeight = 48
GUIDialogue.kEnablesYOffset = 10

GUIDialogue.kInfoTextMaxHeight = 48
GUIDialogue.kInfoYOffset = 10

local kTooltipDuration = 1.5

local kExploreModeTextPos = GUIScale( Vector(0, 90, 0) )
local kExploreModeFontScale = GUIScale( Vector(1, 1, 0) )

function GUIDialogue:Initialize()

     self.flashColor = Color(1,1,1,0)

    self.textureName = GUIDialogue.kMarineBackgroundTexture
    if PlayerUI_IsOnAlienTeam() then
        self.textureName = GUIDialogue.kAlienBackgroundTexture
    end
    
    self.tooltipWidth = GUIScale(320)
    self.tooltipHeight = GUIScale(32)
    
    self.tooltipX = 0
    self.tooltipY = 0
    
    self:InitializeBackground()
    
    self.text = GUIManager:CreateTextItem()
    self.text:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.text:SetTextAlignmentX(GUIItem.Align_Min)
    self.text:SetTextAlignmentY(GUIItem.Align_Min)
    self.text:SetPosition(Vector(GUIDialogue.kTextXOffset, GUIDialogue.kTextYOffset, 0))
    self.text:SetColor(Color(1, 1, 1, 1))
    self.text:SetFontIsBold(true)
    self.text:SetFontName("fonts/AgencyFB_medium.fnt")
    self.text:SetInheritsParentAlpha(true)
    self.background:AddChild(self.text)
    
    self.resourceIcon = GUIManager:CreateGraphicItem()
    self.resourceIcon:SetSize(Vector(GUIDialogue.kResourceIconSize, GUIDialogue.kResourceIconSize, 0))
    self.resourceIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.resourceIcon:SetPosition(Vector(-GUIDialogue.kResourceIconSize + GUIDialogue.kResourceIconXOffset, GUIDialogue.kResourceIconYOffset, 0))
    self.resourceIcon:SetTexture(self.textureName)
    self.resourceIcon:SetIsVisible(false)
    self.resourceIcon:SetInheritsParentAlpha(true)
    self.background:AddChild(self.resourceIcon)
    
    self.cost = GUIManager:CreateTextItem()
    self.cost:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.cost:SetTextAlignmentX(GUIItem.Align_Max)
    self.cost:SetTextAlignmentY(GUIItem.Align_Center)
    self.cost:SetPosition(Vector(GUIDialogue.kCostXOffset, GUIDialogue.kResourceIconSize / 2, 0))
    self.cost:SetColor(Color(1, 1, 1, 1))
    self.cost:SetFontIsBold(true)
    self.cost:SetInheritsParentAlpha(true)
    self.cost:SetFontName("fonts/AgencyFB_small.fnt")
    self.resourceIcon:AddChild(self.cost)
    
    self.requires = GUIManager:CreateTextItem()
    self.requires:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.requires:SetTextAlignmentX(GUIItem.Align_Min)
    self.requires:SetTextAlignmentY(GUIItem.Align_Min)
    self.requires:SetColor(Color(1, 0, 0, 1))
    self.requires:SetText("Requires:")
    self.requires:SetFontIsBold(true)
    self.requires:SetIsVisible(false)
    self.requires:SetInheritsParentAlpha(true)
    self.background:AddChild(self.requires)
    
    self.requiresInfo = GUIManager:CreateTextItem()
    self.requiresInfo:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.requiresInfo:SetTextAlignmentX(GUIItem.Align_Min)
    self.requiresInfo:SetTextAlignmentY(GUIItem.Align_Min)
    self.requiresInfo:SetPosition(Vector(0, 0, 0))
    self.requiresInfo:SetColor(Color(1, 1, 1, 1))
    self.requiresInfo:SetFontIsBold(true)
    self.requiresInfo:SetTextClipped(true, self.tooltipWidth - GUIDialogue.kTextXOffset * 2, GUIDialogue.kRequiresTextMaxHeight)
    self.requiresInfo:SetInheritsParentAlpha(true)
    self.requires:AddChild(self.requiresInfo)
    
    self.enables = GUIManager:CreateTextItem()
    self.enables:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.enables:SetTextAlignmentX(GUIItem.Align_Min)
    self.enables:SetTextAlignmentY(GUIItem.Align_Min)
    self.enables:SetColor(Color(0, 1, 0, 1))
    self.enables:SetText("Enables:")
    self.enables:SetFontIsBold(true)
    self.enables:SetIsVisible(false)
    self.enables:SetInheritsParentAlpha(true)
    self.background:AddChild(self.enables)
    
    self.enablesInfo = GUIManager:CreateTextItem()
    self.enablesInfo:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.enablesInfo:SetTextAlignmentX(GUIItem.Align_Min)
    self.enablesInfo:SetTextAlignmentY(GUIItem.Align_Min)
    self.enablesInfo:SetPosition(Vector(0, 0, 0))
    self.enablesInfo:SetColor(Color(1, 1, 1, 1))
    self.enablesInfo:SetFontIsBold(true)
    self.enablesInfo:SetTextClipped(true, self.tooltipWidth - GUIDialogue.kTextXOffset * 2, GUIDialogue.kEnablesTextMaxHeight)
    self.enablesInfo:SetInheritsParentAlpha(true)
    self.enables:AddChild(self.enablesInfo)
    
    self.info = GUIManager:CreateTextItem()
    self.info:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.info:SetTextAlignmentX(GUIItem.Align_Min)
    self.info:SetTextAlignmentY(GUIItem.Align_Min)
    self.info:SetColor(Color(1, 1, 1, 1))
    self.info:SetFontIsBold(false)
    self.info:SetTextClipped(true, self.tooltipWidth - GUIDialogue.kTextXOffset * 2, GUIDialogue.kInfoTextMaxHeight)
    self.info:SetIsVisible(false)
    self.info:SetInheritsParentAlpha(true)
    self.info:SetFontName("fonts/AgencyFB_tiny.fnt")
    self.background:AddChild(self.info)

    self.backGroundColor = Color(1,1,1,0)
    self.timeLastData = 0
    self:SetBackgroundColor(self.backGroundColor)
    
end

function GUIDialogue:InitializeBackground()

    self.backgroundTop = GUIManager:CreateGraphicItem()
    self.backgroundTop:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.backgroundTop:SetSize(Vector(self.tooltipWidth, self.tooltipHeight, 0))
    self.backgroundTop:SetTexture(self.textureName)
    GUISetTextureCoordinatesTable(self.backgroundTop, GUIDialogue.kBackgroundTopCoords)
    
    self.background = self.backgroundTop
    
    self.backgroundCenter = GUIManager:CreateGraphicItem()
    self.backgroundCenter:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.backgroundCenter:SetSize(Vector(self.tooltipWidth, self.tooltipHeight, 0))
    self.backgroundCenter:SetTexture(self.textureName)
    GUISetTextureCoordinatesTable(self.backgroundCenter, GUIDialogue.kBackgroundCenterCoords)
    self.backgroundTop:AddChild(self.backgroundCenter)
    
    self.backgroundBottom = GUIManager:CreateGraphicItem()
    self.backgroundBottom:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.backgroundBottom:SetSize(Vector(self.tooltipWidth, GUIDialogue.kBackgroundBottomHeight, 0))
    self.backgroundBottom:SetTexture(self.textureName)
    GUISetTextureCoordinatesTable(self.backgroundBottom, GUIDialogue.kBackgroundBottomCoords)
    self.backgroundCenter:AddChild(self.backgroundBottom)
    
    self.flash = GUIManager:CreateGraphicItem()
    self.flash:SetBlendTechnique(GUIItem.Add)
    self.backgroundTop:AddChild(self.flash)

end

function GUIDialogue:SetBackgroundColor(color)

    self.backgroundTop:SetColor(color)
    self.backgroundCenter:SetColor(color)
    self.backgroundBottom:SetColor(color)

end

function GUIDialogue:Uninitialize()

    // Everything is attached to the background so uninitializing it will destroy all items.
    if self.background then
        GUI.DestroyItem(self.background)
    end
    
    if self.exploreModeText then
        GUI.DestroyItem(self.exploreModeText)
    end
    
end

function GUIDialogue:UpdateData(text, hotkey, costNumber, requires, enables, info, typeNumber)

    self.backGroundColor.a = 1
    self.timeLastData = Shared.GetTime()
    self:SetBackgroundColor(self.backGroundColor)

    local totalTextHeight = self:CalculateTotalTextHeight(text, requires, enables, info)
    self:UpdateSizeAndPosition(totalTextHeight)

    self.text:SetText(text)
    if costNumber > 0 and typeNumber > 0 then
        self.resourceIcon:SetIsVisible(true)
        GUISetTextureCoordinatesTable(self.resourceIcon, GUIDialogue.kResourceIconTextureCoordinates[typeNumber])
        self.cost:SetText(ToString(costNumber))
        //self.cost:SetColor(GUIDialogue.kResourceColors[typeNumber])
    else
        self.resourceIcon:SetIsVisible(false)
    end
    
    local nextYPosition = self.text:GetPosition().y + self.text:GetTextHeight(text)
    if string.len(requires) > 0 then
        self.requires:SetIsVisible(true)
        nextYPosition = nextYPosition + GUIDialogue.kRequiresYOffset
        self.requires:SetPosition(Vector(GUIDialogue.kTextXOffset, nextYPosition, 0))
        self.requiresInfo:SetText(requires)
    else
        self.requires:SetIsVisible(false)
    end
    
    if self.requires:GetIsVisible() then
        nextYPosition = self.requires:GetPosition().y + self.requires:GetTextHeight(self.requires:GetText()) + self.requiresInfo:GetTextHeight(self.requiresInfo:GetText())
    end
    
    if string.len(enables) > 0 then
        nextYPosition = nextYPosition + GUIDialogue.kEnablesYOffset
        self.enables:SetIsVisible(true)
        self.enables:SetPosition(Vector(GUIDialogue.kTextXOffset, nextYPosition, 0))
        self.enablesInfo:SetText(enables)
    else
        self.enables:SetIsVisible(false)
    end
    
    if self.enables:GetIsVisible() then
        nextYPosition = self.enables:GetPosition().y + self.enables:GetTextHeight(self.enables:GetText()) + self.enablesInfo:GetTextHeight(self.enablesInfo:GetText())
    end

    if string.len(info) > 0 then
        nextYPosition = nextYPosition + GUIDialogue.kInfoYOffset
        self.info:SetIsVisible(true)
        self.info:SetPosition(Vector(GUIDialogue.kTextXOffset, nextYPosition, 0))
        self.info:SetText(info)
    else
        self.info:SetIsVisible(false)
    end
    
end

// Determine the height of the tooltip based on all the text inside of it.
function GUIDialogue:CalculateTotalTextHeight(text, requires, enables, info)

    local totalHeight = 0
    
    if string.len(text) > 0 then
        totalHeight = totalHeight + self.text:GetTextHeight(text)
    end
    
    if string.len(requires) > 0 then
        totalHeight = totalHeight + self.requiresInfo:GetTextHeight(requires)
    end
    
    if string.len(enables) > 0 then
        totalHeight = totalHeight + self.enablesInfo:GetTextHeight(enables)
    end
    
    if string.len(info) > 0 then
        totalHeight = totalHeight + self.info:GetTextHeight(info)
    end
    
    return totalHeight

end

function GUIDialogue:UpdateSizeAndPosition(totalTextHeight)
    
    local topAndBottomHeight = GUIDialogue.kBackgroundTopHeight - GUIDialogue.kBackgroundBottomHeight
    local adjustedHeight = self.tooltipHeight + totalTextHeight - topAndBottomHeight
    self.backgroundCenter:SetSize(Vector(self.tooltipWidth, adjustedHeight, 0))

    self.background:SetPosition(Vector(GUIDialogue.kBackgroundExtraXOffset, 0, 0))
    
    self.flash:SetSize(Vector(self.tooltipWidth, self.tooltipHeight + totalTextHeight + GUIDialogue.kBackgroundTopHeight + GUIDialogue.kBackgroundBottomHeight, 0))

end

function GUIDialogue:SetIsVisible(setIsVisible)

    self.background:SetIsVisible(setIsVisible)

end

function GUIDialogue:GetBackground()

    return self.background

end

function GUIDialogue:Highlight()
    if self.flashColor.a < 0.5 then
        self.flashColor.a = 0.5
    end
end

// Start fadeout if we haven't already
function GUIDialogue:FadeOut()

    self.timeLastData = math.min(self.timeLastData, Shared.GetTime() - kTooltipDuration)
    self.backGroundColor.a = 0
    self:SetBackgroundColor(self.backGroundColor)

end

function GUIDialogue:Update(deltaTime)

    if PlayerUI_IsACommander() then
    
        self.backGroundColor.a = 0
        self:SetBackgroundColor(self.backGroundColor)
        
    else

        if self.timeLastData + kTooltipDuration < Shared.GetTime() then

            self.backGroundColor.a = math.max(0, self.backGroundColor.a - deltaTime)
            self:SetBackgroundColor(self.backGroundColor)

        end
        
        self.textureName = GUIDialogue.kMarineBackgroundTexture
        if PlayerUI_IsOnAlienTeam() then
            self.textureName = GUIDialogue.kAlienBackgroundTexture
        end
        
        self.resourceIcon:SetTexture(self.textureName)
        self.backgroundTop:SetTexture(self.textureName)
        self.backgroundCenter:SetTexture(self.textureName)
        self.backgroundBottom:SetTexture(self.textureName)
    
    end
    
    self.flashColor.a = math.max(0, self.flashColor.a - deltaTime)
    self.flash:SetColor(self.flashColor)

end