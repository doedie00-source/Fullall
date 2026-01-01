-- tabs/scroll_tab.lua
-- Dark Scroll Auto Forge Tab (Fixed Version)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function SafeRequire(path)
    local success, result = pcall(function() return require(path) end)
    return success and result or {}
end

local AccessoryInfo = SafeRequire(ReplicatedStorage.GameInfo.AccessoryInfo)

local Knit = require(ReplicatedStorage.Packages.Knit)
local ReplicaController = Knit.GetController("ReplicaListener")
local ForgeRemote = ReplicatedStorage.Packages.Knit.Services.ForgeService.RF.Forge

local ScrollTab = {}
ScrollTab.__index = ScrollTab

function ScrollTab.new(deps)
    local self = setmetatable({}, ScrollTab)
    
    self.UIFactory = deps.UIFactory
    self.StateManager = deps.StateManager
    self.InventoryManager = deps.InventoryManager
    self.Utils = deps.Utils
    self.Config = deps.Config
    self.StatusLabel = deps.StatusLabel
    self.InfoLabel = deps.InfoLabel
    
    self.Container = nil
    self.AccessoryList = nil
    self.SelectedItems = {}
    self.AccessoryCards = {}
    self.IsForging = false
    self.ShouldStop = false
    self.CurrentForgingItem = nil
    self.NeedsUpdate = false
    self.LockOverlay = nil
    
    self.TargetSettings = {
        Damage = 40,
        MaxHealth = 35,
        Exp = 35
    }
    
    self.FORGE_DELAY = 0.5
    self.ORDERED_STATS = {"Damage", "MaxHealth", "Exp"}
    
    return self
end

function ScrollTab:Init(parent)
    local THEME = self.Config.THEME
    
    -- Header
    local header = Instance.new("Frame", parent)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 48)
    header.BackgroundTransparency = 1
    
    self.UIFactory.CreateLabel({
        Parent = header,
        Text = "  DARK SCROLL FORGE",
        Size = UDim2.new(1, -8, 0, 28),
        Position = UDim2.new(0, 8, 0, 0),
        TextColor = THEME.TextWhite,
        TextSize = 14,
        Font = Enum.Font.GothamBlack,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    self.UIFactory.CreateLabel({
        Parent = header,
        Text = "Smart auto forge system - All stats must reach target",
        Size = UDim2.new(1, -8, 0, 16),
        Position = UDim2.new(0, 8, 0, 28),
        TextColor = THEME.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    -- Toolbar Settings
    self:CreateToolbar(header)
    
    -- Accessory List
    self.AccessoryList = self.UIFactory.CreateScrollingFrame({
        Parent = parent,
        Size = UDim2.new(1, 0, 1, -52),
        Position = UDim2.new(0, 0, 0, 50),
        UseGrid = true
    })
    
    -- [จุดที่แก้] เปิดระบบขยายขนาดอัตโนมัติ
    self.AccessoryList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.AccessoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.AccessoryList.ScrollBarThickness = 4
    
    local padding = Instance.new("UIPadding", self.AccessoryList)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    
    -- [จุดที่แก้] เพิ่ม Padding ด้านล่างเป็น 85 เพื่อกันที่ให้ปุ่ม Floating Button ไม่บังของชิ้นสุดท้าย
    padding.PaddingBottom = UDim.new(0, 85)
    
    local layout = self.AccessoryList:FindFirstChild("UIGridLayout")
    if layout then
        layout.CellSize = UDim2.new(0, 92, 0, 115)
        layout.CellPadding = UDim2.new(0, 8, 0, 8)
    end
    
    self:CreateFloatingButtons(parent)
    self:CreateLockOverlay(parent)
    self:StartMonitoring()
    self:RefreshAccessoryList()
end

function ScrollTab:CreateToolbar(parent)
    local THEME = self.Config.THEME
    
    local toolbar = self.UIFactory.CreateFrame({
        Parent = parent,
        Size = UDim2.new(0, 360, 0, 30), 
        Position = UDim2.new(1, -368, 0, 8), 
        BgColor = THEME.CardBg,
        Corner = true,
        Stroke = true
    })
    
    local statConfigs = {
        {key = "Damage", name = "DMG", color = THEME.TextWhite, pos = 6},
        {key = "MaxHealth", name = "HP", color = THEME.TextWhite, pos = 100},
        {key = "Exp", name = "XP", color = THEME.TextWhite, pos = 194}
    }
    
    for _, cfg in ipairs(statConfigs) do
        self:CreateStatControl(toolbar, cfg.key, cfg.name, cfg.color, cfg.pos)
    end
    
    -- เส้นขีด
    self.UIFactory.CreateLabel({
        Parent = toolbar,
        Text = "|",
        Size = UDim2.new(0, 8, 0, 20),
        Position = UDim2.new(0, 284, 0, 5),
        TextColor = THEME.GlassStroke or Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.6,
        TextSize = 20,
        Font = Enum.Font.Gotham,
        TextXAlign = Enum.TextXAlignment.Center
    })
    
    -- Scrolls Counter
    self.ScrollCounter = self.UIFactory.CreateLabel({
        Parent = toolbar,
        Text = "0 Scrolls",
        Size = UDim2.new(0, 64, 0, 14),
        Position = UDim2.new(0, 292, 0, 3),
        TextColor = THEME.TextWhite,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlign = Enum.TextXAlignment.Right
    })
    
    -- Selected Counter
    self.SelectedCounter = self.UIFactory.CreateLabel({
        Parent = toolbar,
        Text = "0 Selected",
        Size = UDim2.new(0, 64, 0, 12),
        Position = UDim2.new(0, 292, 0, 16),
        TextColor = THEME.AccentBlue,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlign = Enum.TextXAlignment.Right
    })
end

function ScrollTab:CreateStatControl(parent, statKey, displayName, color, xPos)
    local THEME = self.Config.THEME
    
    -- Label ชื่อ (DMG, HP, XP)
    self.UIFactory.CreateLabel({
        Parent = parent,
        Text = displayName,
        Size = UDim2.new(0, 23, 0, 16),
        Position = UDim2.new(0, xPos, 0, 7),
        TextColor = color,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    -- TextLabel แสดงค่า (ไม่ให้พิมพ์)
    local valueBox = Instance.new("TextLabel", parent)
    valueBox.Size = UDim2.new(0, 30, 0, 16)
    valueBox.Position = UDim2.new(0, xPos + 25, 0, 7)
    valueBox.BackgroundColor3 = THEME.BtnDefault
    valueBox.Text = tostring(self.TargetSettings[statKey]) .. "%"
    valueBox.TextColor3 = THEME.TextWhite
    valueBox.TextSize = 9
    valueBox.Font = Enum.Font.GothamBold
    valueBox.TextXAlignment = Enum.TextXAlignment.Center
    valueBox.BorderSizePixel = 0
    self.UIFactory.AddCorner(valueBox, 4)
    
    -- ปุ่ม + (สูงสุด 40)
    local plusBtn = self.UIFactory.CreateButton({
        Parent = parent,
        Size = UDim2.new(0, 15, 0, 16),
        Position = UDim2.new(0, xPos + 57, 0, 7),
        Text = "+",
        BgColor = THEME.AccentBlue,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        OnClick = function()
            if self.TargetSettings[statKey] < 40 then
                self.TargetSettings[statKey] = self.TargetSettings[statKey] + 5
                valueBox.Text = self.TargetSettings[statKey] .. "%"
                self.NeedsUpdate = true
            end
        end
    })
    
    -- ปุ่ม - (ต่ำสุด 30)
    local minusBtn = self.UIFactory.CreateButton({
        Parent = parent,
        Size = UDim2.new(0, 15, 0, 16),
        Position = UDim2.new(0, xPos + 74, 0, 7),
        Text = "-",
        BgColor = Color3.fromRGB(120, 50, 50),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        OnClick = function()
            if self.TargetSettings[statKey] > 30 then
                self.TargetSettings[statKey] = self.TargetSettings[statKey] - 5
                valueBox.Text = self.TargetSettings[statKey] .. "%"
                self.NeedsUpdate = true
            end
        end
    })
end

function ScrollTab:CreateFloatingButtons(parent)
    local THEME = self.Config.THEME
    
    local spacing = 6
    local btnWidth = 110
    local btnHeight = 32
    local startX = -8
    
    self.SelectAllBtn = self.UIFactory.CreateButton({
        Size = UDim2.new(0, btnWidth, 0, btnHeight),
        Position = UDim2.new(1, startX - btnWidth, 1, -38),
        Text = "SELECT ALL",
        BgColor = THEME.CardBg,
        TextColor = THEME.TextWhite,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = parent,
        OnClick = function() self:ToggleSelectAll() end
    })
    self.SelectAllBtn.ZIndex = 2000
    self.SelectAllBtnStroke = self.UIFactory.AddStroke(self.SelectAllBtn, THEME.AccentBlue, 1.5, 0.4)
    
    self.StartBtn = self.UIFactory.CreateButton({
        Size = UDim2.new(0, btnWidth + 10, 0, btnHeight),
        Position = UDim2.new(1, startX - btnWidth*2 - spacing - 10, 1, -38),
        Text = "START FORGE",
        BgColor = THEME.CardBg,
        TextColor = THEME.TextWhite,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = parent,
        OnClick = function() self:ToggleForge() end
    })
    self.StartBtn.ZIndex = 2000
    self.StartBtnStroke = self.UIFactory.AddStroke(self.StartBtn, THEME.AccentBlue, 1.5, 0.4)
end

function ScrollTab:CreateLockOverlay(parent)
    local THEME = self.Config.THEME
    
    self.LockOverlay = Instance.new("Frame", parent)
    self.LockOverlay.Name = "LockOverlay"
    self.LockOverlay.Size = UDim2.new(1, 0, 1, -52)
    self.LockOverlay.Position = UDim2.new(0, 0, 0, 50)
    self.LockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.LockOverlay.BackgroundTransparency = 0.6
    self.LockOverlay.BorderSizePixel = 0
    self.LockOverlay.ZIndex = 500
    self.LockOverlay.Visible = false
    
    self.LockLabel = self.UIFactory.CreateLabel({
        Parent = self.LockOverlay,
        Text = "[FORGING]\nProcessing...",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextColor = THEME.TextWhite,
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    self.LockLabel.ZIndex = 501
    self.LockLabel.TextWrapped = true
end

function ScrollTab:ToggleForge()
    if self.IsForging then
        self:StopForge()
    else
        self:StartForge()
    end
end

function ScrollTab:StartForge()
    local THEME = self.Config.THEME
    local replica = ReplicaController:GetReplica()
    if not replica or not replica.Data then return end
    
    local inv = replica.Data.ItemsService.Inventory
    local scrolls = (inv.Scrolls and inv.Scrolls["5"]) or 0
    
    if scrolls <= 0 then
        self.StateManager:SetStatus("No Dark Scrolls!", THEME.Fail, self.StatusLabel)
        return
    end
    
    local itemsToForge = {}
    for guid, _ in pairs(self.SelectedItems) do
        table.insert(itemsToForge, guid)
    end
    
    if #itemsToForge == 0 then
        self.StateManager:SetStatus("Select items first", THEME.Warning, self.StatusLabel)
        return
    end
    
    self.IsForging = true
    self.ShouldStop = false
    
    self.StartBtn.Text = "STOP FORGE"
    self.StartBtn.TextColor3 = THEME.TextWhite
    self.StartBtnStroke.Color = THEME.Fail
    
    if self.LockOverlay then
        self.LockOverlay.Visible = true
        if self.LockLabel then
            self.LockLabel.Text = "[STARTING]\nPreparing..."
        end
    end
    
    self.SelectAllBtn.TextTransparency = 0.6
    
    task.spawn(function()
        self:ProcessForging(itemsToForge, replica)
    end)
end

function ScrollTab:ProcessForging(itemsToForge, replica)
    local THEME = self.Config.THEME
    local totalForged = 0
    
    for i, guid in ipairs(itemsToForge) do
        if self.ShouldStop or not self.IsForging then break end
        
        self.CurrentForgingItem = guid
        self.NeedsUpdate = true
        
        local accessories = replica.Data.AccessoryService.Accessories
        local info = accessories[guid]
        
        if not info then
            self.CurrentForgingItem = nil
            continue
        end
        
        self.StateManager:SetStatus(
            string.format("Forging %s (%d/%d)", info.Name, i, #itemsToForge),
            THEME.AccentBlue,
            self.StatusLabel
        )
        
        local attempts = 0
        while self.IsForging and not self:IsItemReachedTarget(info) do
            if self.ShouldStop or not self.IsForging then break end
            local inv = replica.Data.ItemsService.Inventory
            local currentScrolls = (inv.Scrolls and inv.Scrolls["5"]) or 0
            
            if currentScrolls <= 0 then
                self.StateManager:SetStatus("Out of Scrolls!", THEME.Fail, self.StatusLabel)
                self.IsForging = false
                break
            end
            
            attempts = attempts + 1
            pcall(function() 
                ForgeRemote:InvokeServer(guid, 5) 
            end)
            
            totalForged = totalForged + 1
            
            if self.LockLabel then
                self.LockLabel.Text = string.format(
                    "[FORGING] %s\n\nItem: %d / %d\nThis Item: %d\nTotal Used: %d",
                    info.Name, i, #itemsToForge, attempts, totalForged
                )
            end
            
            task.wait(self.FORGE_DELAY)
            
            info = replica.Data.AccessoryService.Accessories[guid]
            if not info then break end
            
            self.NeedsUpdate = true
        end
        
        if not self.IsForging then break end
        
        if self:IsItemReachedTarget(info) then
            self.SelectedItems[guid] = nil
            self.StateManager:SetStatus(
                string.format("%s complete!", info.Name),
                THEME.Success,
                self.StatusLabel
            )
        end
        
        self.CurrentForgingItem = nil
        self.NeedsUpdate = true
        task.wait(0.5)
    end
    
    if self.ShouldStop then
        self.StateManager:SetStatus(
            string.format("Stopped! Total: %d", totalForged),
            THEME.Warning,
            self.StatusLabel
        )
    else
        self.StateManager:SetStatus(
            string.format("Complete! Total: %d", totalForged),
            THEME.Success,
            self.StatusLabel
        )
    end
    
    self.CurrentForgingItem = nil  -- ✅ เคลียร์ item ปัจจุบัน
    self.NeedsUpdate = true  -- ✅ Refresh UI ก่อน reset button
    task.wait(0.3)  -- ให้เวลา UI refresh
    self:ResetButton()
    task.wait(0.7)
    self:RefreshAccessoryList()
end

function ScrollTab:StopForge()
    self.ShouldStop = true
    self.IsForging = false
    self.CurrentForgingItem = nil  -- ✅ Reset item ที่กำลัง forge
    self.StartBtn.Text = "STOPPING..."
    self.StartBtnStroke.Color = self.Config.THEME.Fail
    self.NeedsUpdate = true  -- ✅ Refresh UI ทันที
    
    -- ✅ แสดงสถานะ STOPPING ใน LockLabel
    if self.LockLabel then
        self.LockLabel.Text = "[STOPPING]\n\nPlease wait..."
        self.LockLabel.TextColor3 = self.Config.THEME.Warning
    end
end

function ScrollTab:ResetButton()
    local THEME = self.Config.THEME
    
    self.IsForging = false
    self.ShouldStop = false
    
    self.CurrentForgingItem = nil     
    self.StartBtn.Text = "START FORGE"
    self.StartBtn.TextColor3 = THEME.TextWhite
    self.StartBtnStroke.Color = THEME.AccentBlue
    
    if self.LockOverlay then
        self.LockOverlay.Visible = false
    end
    
    if self.LockLabel then
        self.LockLabel.TextColor3 = THEME.TextWhite
    end

    self.SelectAllBtn.TextTransparency = 0
    self.NeedsUpdate = true
    self:UpdateSelectButton()
end

function ScrollTab:IsItemReachedTarget(info)
    if not info.Scroll or not info.Scroll.Upgrades then
        return false
    end
    
    local upgrades = info.Scroll.Upgrades
    
    for statKey, targetValue in pairs(self.TargetSettings) do
        local currentValue = (upgrades[statKey] or 0) * 100
        if currentValue < targetValue then
            return false
        end
    end
    
    return true
end

function ScrollTab:RefreshAccessoryList()
    -- Clear old frames
    for _, child in pairs(self.AccessoryList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    self.AccessoryCards = {}
    
    local replica = ReplicaController:GetReplica()
    if not replica or not replica.Data then return end
    
    local accessories = replica.Data.AccessoryService.Accessories
    
    -- [[ ส่วนที่เพิ่ม ]] : ตรวจสอบสถานะ Items ที่เลือกอยู่ ก่อนที่จะนับจำนวน
    -- ถ้าเราปรับ Stats ลดลง จน Item นั้นผ่านเกณฑ์แล้ว (Complete) ให้เอาติ๊กถูกออกทันที
    for guid, _ in pairs(self.SelectedItems) do
        local info = accessories[guid]
        if info then
            if self:IsItemReachedTarget(info) then
                self.SelectedItems[guid] = nil -- เอาออกจากรายการเลือก
            end
        else
            self.SelectedItems[guid] = nil -- กันเหนียว กรณีของหาย
        end
    end
    -- [[ จบส่วนที่เพิ่ม ]]

    local inv = replica.Data.ItemsService.Inventory
    local scrolls = (inv.Scrolls and inv.Scrolls["5"]) or 0
    self.ScrollCounter.Text = scrolls .. " Scrolls"
    
    -- นับจำนวนใหม่ (ตอนนี้ตัวเลขจะถูกต้องแล้ว เพราะเราเคลียร์ข้างบนมาแล้ว)
    local selectedCount = 0
    for _ in pairs(self.SelectedItems) do selectedCount = selectedCount + 1 end
    self.SelectedCounter.Text = selectedCount .. " Selected"
    
    for guid, info in pairs(accessories) do
        local baseData = AccessoryInfo[info.Name]
        if baseData then
            self:CreateAccessoryCard(guid, info, baseData)
        end
    end
    
    self:UpdateInfoLabel()
end

function ScrollTab:CreateAccessoryCard(guid, info, baseData)
    local THEME = self.Config.THEME
    local reachedTarget = self:IsItemReachedTarget(info)
    local isCurrentForging = (self.CurrentForgingItem == guid)
    local isSelected = self.SelectedItems[guid]
    
    -- Auto unselect ถ้าถึงเป้าหมายแล้ว
    if reachedTarget and isSelected then
        self.SelectedItems[guid] = nil
        isSelected = false
    end
    
    local Card = Instance.new("Frame", self.AccessoryList)
    -- ✅ สีม่วงสด + ไม่โปร่งใส
    Card.BackgroundColor3 = isCurrentForging and Color3.fromRGB(45, 25, 70) or THEME.CardBg
    Card.BackgroundTransparency = isCurrentForging and 0 or 0.2
    Card.BorderSizePixel = 0
    Card.Size = UDim2.new(0, 92, 0, 115)
    
    self.UIFactory.AddCorner(Card, 10)
    
    -- ✅ Stroke สีม่วงสด หนา ไม่โปร่งใส
    if isCurrentForging then
        self.UIFactory.AddStroke(Card, Color3.fromRGB(200, 100, 255), 2.5, 0)
    elseif isSelected then
        self.UIFactory.AddStroke(Card, THEME.AccentBlue, 2, 0.3)
    else
        self.UIFactory.AddStroke(Card, Color3.fromRGB(0, 0, 0), 0, 1)
    end
    
    -- ไอคอน
    local icon = Instance.new("ImageLabel", Card)
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. tostring(baseData.Image or 0)
    icon.ScaleType = Enum.ScaleType.Fit
    
    -- ✅ เพิ่ม Badge "FORGING"
    if isCurrentForging then
        local forgingBadge = Instance.new("Frame", Card)
        forgingBadge.Size = UDim2.new(0, 70, 0, 16)
        forgingBadge.Position = UDim2.new(0.5, -35, 0, 2)
        forgingBadge.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        forgingBadge.BackgroundTransparency = 0
        forgingBadge.BorderSizePixel = 0
        forgingBadge.ZIndex = 10
        
        self.UIFactory.AddCorner(forgingBadge, 4)
        
        local badgeLabel = self.UIFactory.CreateLabel({
            Parent = forgingBadge,
            Text = "⚡ FORGING",
            Size = UDim2.new(1, 0, 1, 0),
            TextColor = Color3.fromRGB(255, 255, 255),
            TextSize = 8,
            Font = Enum.Font.GothamBlack
        })
        badgeLabel.ZIndex = 11
    end
    
    -- แสดงดาว Evolution
    if info.Evolution and tonumber(info.Evolution) > 0 then
        local starContainer = Instance.new("Frame", Card)
        starContainer.Size = UDim2.new(1, 0, 0, 15)
        starContainer.Position = UDim2.new(0, 0, 0, 68)
        starContainer.BackgroundTransparency = 1
        
        local layout = Instance.new("UIListLayout", starContainer)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0, -2)

        for i = 1, math.min(tonumber(info.Evolution), 3) do
            local s = Instance.new("ImageLabel", starContainer)
            s.Size = UDim2.new(0, 12, 0, 12)
            s.BackgroundTransparency = 1
            s.Image = "rbxassetid://3926305904"
            s.ImageColor3 = THEME.StarColor or Color3.fromRGB(255, 215, 0)
        end
    end
    
    -- ชื่อและ stats (ใช้ RichText)
    local scrollText = ""
    if info.Scroll and info.Scroll.Upgrades then
        local bonuses = {}
        for _, statKey in ipairs(self.ORDERED_STATS) do
            local val = info.Scroll.Upgrades[statKey]
            if val then
                local currentPercent = math.floor(val * 100)
                local targetPercent = self.TargetSettings[statKey]
                local statReached = currentPercent >= targetPercent
                
                local colorMap = {
                    Damage = "rgb(255,80,80)",
                    MaxHealth = "rgb(80,255,180)",
                    Exp = "rgb(255,200,80)"
                }
                
                local nameMap = {
                    Damage = "DMG",
                    MaxHealth = "HP",
                    Exp = "XP"
                }
                
                local color = statReached and colorMap[statKey] or "rgb(100,110,130)"
                local check = statReached and " ✓" or ""
                table.insert(bonuses, string.format("<font color='%s'>%s +%d%%%s</font>", 
                    color, nameMap[statKey], currentPercent, check))
            end
        end
        
        if #bonuses > 0 then
            scrollText = "\n<font size='7'>" .. table.concat(bonuses, " | ") .. "</font>"
        end
    else
        scrollText = "\n<font size='7' color='rgb(100,110,130)'>NO SCROLL</font>"
    end
    
    local nameLbl = self.UIFactory.CreateLabel({
        Parent = Card,
        Text = info.Name .. scrollText,
        Size = UDim2.new(1, -8, 0, 40),
        Position = UDim2.new(0, 4, 1, -45),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextColor = THEME.TextWhite
    })
    nameLbl.TextWrapped = true
    nameLbl.RichText = true
    
    -- ถ้าถึงเป้าหมายแล้ว: ทึบดำ (Dark Overlay)
    if reachedTarget then
        local overlay = Instance.new("Frame", Card)
        overlay.Name = "CompletedOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.7
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 5
        
        self.UIFactory.AddCorner(overlay, 10)
        
        -- ข้อความ COMPLETED
        local completedLabel = self.UIFactory.CreateLabel({
            Parent = overlay,
            Text = "COMPLETED",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            TextColor = THEME.Success,
            TextSize = 10,
            Font = Enum.Font.GothamBlack
        })
        completedLabel.ZIndex = 6
    end
    
    -- ปุ่มกด
    local btn = Instance.new("TextButton", Card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = reachedTarget and 10 or 2
    
    btn.MouseButton1Click:Connect(function()
        if self.IsForging then return end
        if reachedTarget then return end
        
        self.SelectedItems[guid] = not self.SelectedItems[guid] or nil
        self.NeedsUpdate = true
    end)
    
    self.AccessoryCards[guid] = Card
end

function ScrollTab:ToggleSelectAll()
    if self.IsForging then return end
    
    if self:AreAllSelected() then
        self:DeselectAll()
    else
        self:SelectAll()
    end
    self:UpdateSelectButton()
end

function ScrollTab:AreAllSelected()
    local totalCards = 0
    for _ in pairs(self.AccessoryCards) do totalCards = totalCards + 1 end
    
    local selectedCount = 0
    for _ in pairs(self.SelectedItems) do selectedCount = selectedCount + 1 end
    
    return totalCards > 0 and totalCards == selectedCount
end

function ScrollTab:SelectAll()
    for guid, _ in pairs(self.AccessoryCards) do
        self.SelectedItems[guid] = true
    end
    self.NeedsUpdate = true
end

function ScrollTab:DeselectAll()
    self.SelectedItems = {}
    self.NeedsUpdate = true
end

function ScrollTab:UpdateSelectButton()
    local THEME = self.Config.THEME
    
    self.SelectAllBtn.BackgroundColor3 = THEME.CardBg
    self.SelectAllBtn.TextColor3 = THEME.TextWhite
    
    if self:AreAllSelected() then
        self.SelectAllBtn.Text = "UNSELECT ALL"
        self.SelectAllBtnStroke.Color = THEME.Fail
    else
        self.SelectAllBtn.Text = "SELECT ALL"
        self.SelectAllBtnStroke.Color = THEME.AccentBlue
    end
    
    if self.IsForging then
        self.SelectAllBtn.TextTransparency = 0.6
        self.SelectAllBtnStroke.Transparency = 0.8
    else
        self.SelectAllBtn.TextTransparency = 0
        self.SelectAllBtnStroke.Transparency = 0.4
    end
end

function ScrollTab:UpdateInfoLabel()
    if not self.InfoLabel then return end
    
    local count = 0
    for _ in pairs(self.SelectedItems) do count = count + 1 end
    
    if count > 0 then
        self.InfoLabel.Text = string.format("Selected: %d accessories", count)
        self.InfoLabel.TextColor3 = self.Config.THEME.AccentBlue
    else
        self.InfoLabel.Text = ""
    end
end

function ScrollTab:StartMonitoring()
    local replica = ReplicaController:GetReplica()
    if replica then
        replica:ListenToChange({"ItemsService", "Inventory"}, function() 
            self.NeedsUpdate = true 
        end)
        replica:ListenToChange({"AccessoryService", "Accessories"}, function() 
            self.NeedsUpdate = true 
        end)
    end
    
    RunService.Heartbeat:Connect(function()
        if self.NeedsUpdate then
            self.NeedsUpdate = false
            self:RefreshAccessoryList()
            self:UpdateSelectButton()
        end
    end)
end

return ScrollTab
