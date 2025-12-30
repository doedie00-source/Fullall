-- tabs/players_tab.lua
-- Players Tab Module - Dark Blue Edition

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayersTab = {}
PlayersTab.__index = PlayersTab

function PlayersTab.new(deps)
    local self = setmetatable({}, PlayersTab)
    
    self.UIFactory = deps.UIFactory
    self.StateManager = deps.StateManager
    self.TradeManager = deps.TradeManager
    self.Utils = deps.Utils
    self.Config = deps.Config
    self.StatusLabel = deps.StatusLabel
    
    self.Container = nil
    self.PlayerButtons = {}
    
    return self
end

function PlayersTab:Init(parent)
    local THEME = self.Config.THEME
    
    -- Header
    local header = self.UIFactory.CreateLabel({
        Parent = parent,
        Text = "  SERVER PLAYERS",
        Size = UDim2.new(1, -8, 0, 26),
        Position = UDim2.new(0, 8, 0, 0),
        TextColor = THEME.TextWhite,
        TextSize = 14,
        Font = Enum.Font.GothamBlack,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    local subHeader = self.UIFactory.CreateLabel({
        Parent = parent,
        Text = "Force trade with any player in the server",
        Size = UDim2.new(1, -8, 0, 14),
        Position = UDim2.new(0, 8, 0, 26),
        TextColor = THEME.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    -- Scrolling Frame
    self.Container = self.UIFactory.CreateScrollingFrame({
        Parent = parent,
        Size = UDim2.new(1, 0, 1, -46),
        Position = UDim2.new(0, 0, 0, 44)
    })
    
    self:RefreshList()
end

function PlayersTab:RefreshList()
    local THEME = self.Config.THEME
    
    -- Clear existing
    for _, child in pairs(self.Container:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    self.PlayerButtons = {}

    local padding = self.Container:FindFirstChild("UIPadding") or Instance.new("UIPadding", self.Container)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 4)
    
    local isTrading = self.Utils.IsTradeActive()
    local count = 0
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            -- Card Frame
            local card = Instance.new("Frame", self.Container)
            card.Name = plr.Name
            card.Size = UDim2.new(1, -16, 0, 56)
            card.BackgroundColor3 = THEME.CardBg
            card.BackgroundTransparency = 0.2
            card.BorderSizePixel = 0
            
            self.UIFactory.AddCorner(card, 8)
            self.UIFactory.AddStroke(card, THEME.GlassStroke, 1.5, 0.6)
            
            -- Player Info
            local avatar = Instance.new("ImageLabel", card)
            avatar.Size = UDim2.new(0, 38, 0, 38)
            avatar.Position = UDim2.new(0, 9, 0.5, -19)
            avatar.BackgroundTransparency = 1
            avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=150&height=150&format=png"
            self.UIFactory.AddCorner(avatar, 8)
            
            local nameLabel = self.UIFactory.CreateLabel({
                Parent = card,
                Text = plr.DisplayName,
                Size = UDim2.new(0, 280, 0, 16),
                Position = UDim2.new(0, 54, 0, 11),
                TextColor = THEME.TextWhite,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlign = Enum.TextXAlignment.Left
            })
            
            local usernameLabel = self.UIFactory.CreateLabel({
                Parent = card,
                Text = "@" .. plr.Name,
                Size = UDim2.new(0, 280, 0, 13),
                Position = UDim2.new(0, 54, 0, 29),
                TextColor = THEME.TextDim,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlign = Enum.TextXAlignment.Left
            })

            -- Trade Button
            local tradeBtn = self.UIFactory.CreateButton({
                Size = UDim2.new(0, 82, 0, 30),
                Position = UDim2.new(1, -90, 0.5, -15),
                Text = isTrading and "LOCKED" or "TRADE",
                BgColor = isTrading and THEME.BtnDisabled or THEME.AccentBlue,
                TextColor = isTrading and THEME.TextDisabled or THEME.TextWhite,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                CornerRadius = 6,
                Parent = card
            })
            tradeBtn.AutoButtonColor = not isTrading
            
            table.insert(self.PlayerButtons, tradeBtn)
            tradeBtn:SetAttribute("OriginalColor", THEME.AccentBlue)
            tradeBtn:SetAttribute("OriginalTextColor", THEME.TextWhite)
            
            -- Trade Button Click
            tradeBtn.MouseButton1Click:Connect(function()
                if self.Utils.IsTradeActive() then
                    self.StateManager:SetStatus("Trade is active! Finish it first", THEME.Fail, self.StatusLabel)
                    return
                end

                self.TradeManager.ForceTradeWith(plr, self.StatusLabel, self.StateManager, self.Utils)
                
                -- Auto switch to Inventory tab
                task.spawn(function()
                    local timer = 0
                    while timer < 10 do
                        if self.Utils.IsTradeActive() then
                            if _G.ModernGUI then 
                                _G.ModernGUI:SwitchTab("Inventory")
                            end
                            break
                        end
                        timer = timer + 1
                        task.wait(0.5)
                    end
                end)
            end)
            
            count = count + 1
        end 
    end
    
    self.Container.CanvasSize = UDim2.new(0, 0, 0, count * 60)
end

function PlayersTab:UpdateButtonStates()
    local THEME = self.Config.THEME
    local tradeActive = self.Utils.IsTradeActive()
    
    for _, btn in pairs(self.PlayerButtons) do
        if btn and btn.Parent then
            if tradeActive then
                btn.BackgroundColor3 = THEME.BtnDisabled
                btn.TextColor3 = THEME.TextDisabled
                btn.Text = "LOCKED"
                btn.AutoButtonColor = false
            else
                if btn:GetAttribute("OriginalColor") then
                    btn.BackgroundColor3 = btn:GetAttribute("OriginalColor")
                end
                if btn:GetAttribute("OriginalTextColor") then
                    btn.TextColor3 = btn:GetAttribute("OriginalTextColor")
                end
                btn.Text = "TRADE"
                btn.AutoButtonColor = true
            end
        end
    end
end

return PlayersTab
