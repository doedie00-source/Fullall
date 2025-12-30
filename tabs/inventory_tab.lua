-- tabs/inventory_tab.lua
-- Hidden Inventory Tab (Configurable Theme Support)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Load Info Modules
local function SafeRequire(path)
    local success, result = pcall(function() return require(path) end)
    return success and result or {}
end

local PetsInfo = SafeRequire(ReplicatedStorage.GameInfo.PetsInfo)
local CratesInfo = SafeRequire(ReplicatedStorage.GameInfo.CratesInfo)
local MonsterInfo = SafeRequire(ReplicatedStorage.GameInfo.MonsterInfo)
local AccessoryInfo = SafeRequire(ReplicatedStorage.GameInfo.AccessoryInfo)

local InventoryTab = {}
InventoryTab.__index = InventoryTab

function InventoryTab.new(deps)
    local self = setmetatable({}, InventoryTab)
    self.UIFactory = deps.UIFactory
    self.StateManager = deps.StateManager
    self.InventoryManager = deps.InventoryManager
    self.TradeManager = deps.TradeManager
    self.Utils = deps.Utils
    self.Config = deps.Config
    self.StatusLabel = deps.StatusLabel
    self.Container = nil
    
    self.isPopupOpen = false
    self.currentPopup = nil
    
    return self
end

function InventoryTab:Init(parent)
    local THEME = self.Config.THEME
    
    -- Header
    self.UIFactory.CreateLabel({
        Parent = parent,
        Text = "Hidden Treasures",
        Size = UDim2.new(1, -8, 0, 24),
        Position = UDim2.new(0, 8, 0, 0),
        TextColor = THEME.TextWhite,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    self.UIFactory.CreateLabel({
        Parent = parent,
        Text = "Items currently in your inventory (Hidden List only)",
        Size = UDim2.new(1, -8, 0, 14),
        Position = UDim2.new(0, 8, 0, 22),
        TextColor = THEME.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlign = Enum.TextXAlignment.Left
    })

    -- Grid Container
    self.Container = self.UIFactory.CreateScrollingFrame({
        Parent = parent,
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 45),
        UseGrid = true 
    })
    
    local padding = self.Container:FindFirstChild("UIPadding") or Instance.new("UIPadding", self.Container)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 12)
    
    local layout = self.Container:FindFirstChild("UIGridLayout")
    if layout then
        layout.CellSize = UDim2.new(0, 92, 0, 115)
        layout.CellPadding = UDim2.new(0, 8, 0, 8)
    end

    self:RefreshInventory()
end

function InventoryTab:RefreshInventory()
    -- Clear old items
    for _, child in pairs(self.Container:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local playerData = self.InventoryManager.GetPlayerData()
    if not playerData then return end

    local HIDDEN = self.Config.HIDDEN_LISTS
    local itemsToRender = {}

    -- 1. Pets
    if playerData.PetsService and playerData.PetsService.Pets then
        for uuid, data in pairs(playerData.PetsService.Pets) do
            if self:CheckHidden(data.Name, HIDDEN.Pets) then
                table.insert(itemsToRender, {
                    Name = data.Name, 
                    UUID = uuid, 
                    Category = "Pets", 
                    Service = "PetsService", 
                    Raw = data, 
                    Image = PetsInfo[data.Name] and PetsInfo[data.Name].Image
                })
            end
        end
    end

    -- 2. Monsters (Saved + Unlocked)
    if playerData.MonsterService then
        if playerData.MonsterService.SavedMonsters then
            for uuid, data in pairs(playerData.MonsterService.SavedMonsters) do
                local mName = (type(data) == "table") and data.Name or data
                if self:CheckHidden(mName, HIDDEN.Secrets) then
                    table.insert(itemsToRender, {
                        Name = mName, 
                        UUID = uuid, 
                        Category = "Secrets", 
                        Service = "MonsterService",
                        ElementData = "SavedMonsters",
                        Raw = (type(data) == "table") and data or {Name = mName}, 
                        Image = MonsterInfo[mName] and MonsterInfo[mName].Image
                    })
                end
            end
        end
        
        if playerData.MonsterService.MonstersUnlocked then
            for _, mName in pairs(playerData.MonsterService.MonstersUnlocked) do
                if self:CheckHidden(mName, HIDDEN.Secrets) then
                    local alreadyAdded = false
                    for _, item in ipairs(itemsToRender) do
                        if item.Category == "Secrets" and item.Name == mName and item.UUID then
                            alreadyAdded = true
                            break
                        end
                    end
                    if not alreadyAdded then
                        table.insert(itemsToRender, {
                            Name = mName,
                            UUID = nil,
                            Category = "Secrets",
                            Service = "MonsterService",
                            ElementData = "MonstersUnlocked",
                            Raw = {Name = mName},
                            Image = MonsterInfo[mName] and MonsterInfo[mName].Image
                        })
                    end
                end
            end
        end
    end

    -- 3. Accessories
    if playerData.AccessoryService and playerData.AccessoryService.Accessories then
        for uuid, data in pairs(playerData.AccessoryService.Accessories) do
            if self:CheckHidden(data.Name, HIDDEN.Accessories) then
                table.insert(itemsToRender, {
                    Name = data.Name, 
                    UUID = uuid, 
                    Category = "Accessories", 
                    Service = "AccessoryService", 
                    Raw = data, 
                    Image = AccessoryInfo[data.Name] and AccessoryInfo[data.Name].Image
                })
            end
        end
    end

    -- 4. Crates
    if playerData.CratesService and playerData.CratesService.Crates then
        for name, amount in pairs(playerData.CratesService.Crates) do
            if amount > 0 and self:CheckHidden(name, HIDDEN.Crates) then
                table.insert(itemsToRender, {
                    Name = name, 
                    Amount = amount, 
                    Category = "Crates", 
                    Service = "CratesService", 
                    Image = CratesInfo[name] and CratesInfo[name].Image
                })
            end
        end
    end

    for _, item in ipairs(itemsToRender) do
        self:CreateItemCard(item, playerData)
    end
end

function InventoryTab:CheckHidden(name, list)
    if not list then return false end
    for _, h in pairs(list) do 
        if h == name then return true end 
    end
    return false
end

function InventoryTab:CreateItemCard(item, playerData)
    local THEME = self.Config.THEME
    
    local isEquipped = false
    if item.Category ~= "Crates" then
        isEquipped = self.Utils.CheckIsEquipped(item.UUID, item.Name, item.Category, playerData)
    end
    
    local key = item.UUID or item.Name
    local isInTrade = self.StateManager:IsInTrade(key)
    
    local Card = Instance.new("Frame", self.Container)
    
    -- 🎨 [THEME APPLIER] --------------------------------------------
    local bgColor = THEME.CardBg        -- ปกติ: น้ำเงินเข้ม
    local bgTrans = 0.2                 -- ปกติ: โปร่งแสงนิดหน่อย
    local textColor = THEME.TextWhite   -- ปกติ: ขาวอมฟ้า

    if isInTrade then
        -- 🔥 สถานะถูกเลือก: ดึงค่าจาก Config (CardBgSelected, CardTextSelected)
        bgColor = THEME.CardBgSelected       -- ดำทึบ
        bgTrans = 0                          -- Solid (ไม่โปร่งแสง)
        textColor = THEME.CardTextSelected   -- เทา
    end
    -- ---------------------------------------------------------------
    
    Card.BackgroundColor3 = bgColor
    Card.BackgroundTransparency = bgTrans
    Card.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(Card, 10)
    
    -- 🚫 [NO STROKE] ไม่มีการสร้างเส้นขอบเมื่ออยู่ในสถานะ Trade
    -- (ยกเว้นตอนใส่ Item อยู่ เพื่อเตือนผู้เล่น)
    if isEquipped then
        self.UIFactory.AddStroke(Card, THEME.Fail, 2, 0.5) -- ยังคงขอบแดงไว้ถ้าใส่อยู่
    end

    -- Image
    local icon = Instance.new("ImageLabel", Card)
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. tostring(item.Image or 0)
    icon.ScaleType = Enum.ScaleType.Fit
    
    -- EQUIP tag
    if isEquipped then
        local eqTag = Instance.new("TextLabel", Card)
        eqTag.Text = "EQUIP"
        eqTag.Size = UDim2.new(0, 42, 0, 12)
        eqTag.Position = UDim2.new(1, -44, 0, 4)
        eqTag.BackgroundTransparency = 1
        eqTag.TextColor3 = THEME.Fail
        eqTag.Font = Enum.Font.GothamBlack
        eqTag.TextSize = 7
        eqTag.TextXAlignment = Enum.TextXAlignment.Right
    end

    -- Stars
    if item.Raw and item.Raw.Evolution and tonumber(item.Raw.Evolution) > 0 then
        local starContainer = Instance.new("Frame", Card)
        starContainer.Size = UDim2.new(1, 0, 0, 15)
        starContainer.Position = UDim2.new(0, 0, 0, 68)
        starContainer.BackgroundTransparency = 1
        
        local layout = Instance.new("UIListLayout", starContainer)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0, -2)

        for i = 1, tonumber(item.Raw.Evolution) do
            local s = Instance.new("ImageLabel", starContainer)
            s.Size = UDim2.new(0, 12, 0, 12)
            s.BackgroundTransparency = 1
            s.Image = "rbxassetid://3926305904"
            s.ImageColor3 = THEME.StarColor or Color3.fromRGB(255, 215, 0)
        end
    end

    -- Name Label
    local levelText = (item.Raw and item.Raw.Level) and (" [Lv."..item.Raw.Level.."]") or ""
    local amountText = (item.Amount and item.Amount > 1) and (" x"..item.Amount) or ""
    
    local scrollText = ""
    if item.Category == "Accessories" and item.Raw and item.Raw.Scroll then
        local scrollName = item.Raw.Scroll.Name or "Unknown"
        scrollText = "\n<font size='8' color='rgb(140,100,255)'>[" .. scrollName .. "]</font>"
        
        if item.Raw.Scroll.Upgrades then
            local bonuses = {}
            for statName, value in pairs(item.Raw.Scroll.Upgrades) do
                local percentage = math.floor(value * 100)
                table.insert(bonuses, statName .. " +" .. percentage .. "%")
            end
            if #bonuses > 0 then
                scrollText = scrollText .. "\n<font size='7' color='rgb(100,200,150)'>" .. table.concat(bonuses, " | ") .. "</font>"
            end
        end
    end
    
    local nameLbl = self.UIFactory.CreateLabel({
        Parent = Card,
        Text = item.Name .. levelText .. amountText .. scrollText,
        Size = UDim2.new(1, -8, 0, scrollText ~= "" and 40 or 25),
        Position = UDim2.new(0, 4, 1, (scrollText ~= "" and -45 or -30)),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextColor = textColor -- ใช้ค่าจาก Config (CardTextSelected)
    })
    nameLbl.TextWrapped = true
    nameLbl.RichText = true

    -- Button Logic
    local btn = Instance.new("TextButton", Card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    btn.MouseButton1Click:Connect(function()
        if self.isPopupOpen then return end
        
        if not self.Utils.IsTradeActive() then 
            self.StateManager:SetStatus("⚠️ Trade Menu NOT open!", THEME.Fail, self.StatusLabel)
            return 
        end
        
        if isEquipped then
            self.StateManager:SetStatus("🔒 Cannot trade equipped items!", THEME.Fail, self.StatusLabel)
            return
        end
        
        if item.Category == "Crates" then
            if isInTrade then
                local oldAmount = self.StateManager.itemsInTrade[key] and self.StateManager.itemsInTrade[key].Amount or item.Amount
                self.TradeManager.SendTradeSignal("Remove", {
                    Name = item.Name, Service = item.Service, Category = item.Category
                }, oldAmount, self.StatusLabel, self.StateManager, self.Utils)
            else
                self:ShowQuantityPopup({Default = item.Amount, Max = item.Amount}, function(qty)
                    self.TradeManager.SendTradeSignal("Add", {
                        Name = item.Name, Service = item.Service, Category = item.Category
                    }, qty, self.StatusLabel, self.StateManager, self.Utils)
                    task.wait(0.1)
                    self:RefreshInventory()
                end)
                return
            end
        else
            if isInTrade then
                self.TradeManager.SendTradeSignal("Remove", {
                    Name = item.Name, Guid = item.UUID, Service = item.Service, Category = item.Category, ElementData = item.ElementData, RawInfo = item.Raw
                }, 1, self.StatusLabel, self.StateManager, self.Utils)
            else
                self.TradeManager.SendTradeSignal("Add", {
                    Name = item.Name, Guid = item.UUID, Service = item.Service, Category = item.Category, ElementData = item.ElementData, RawInfo = item.Raw
                }, 1, self.StatusLabel, self.StateManager, self.Utils)
            end
        end
        
        task.wait(0.1)
        self:RefreshInventory()
    end)
end

function InventoryTab:ShowQuantityPopup(itemData, onConfirm)
    if self.isPopupOpen then return end
    if self.currentPopup and self.currentPopup.Parent then
        self.currentPopup:Destroy()
        self.currentPopup = nil
    end
    
    local THEME = self.Config.THEME
    self.isPopupOpen = true
    
    local PopupFrame = Instance.new("Frame", game:GetService("CoreGui"):FindFirstChild(self.Config.CONFIG.GUI_NAME))
    PopupFrame.Size = UDim2.new(1, 0, 1, 0)
    PopupFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    PopupFrame.BackgroundTransparency = 0.3
    PopupFrame.ZIndex = 3000
    PopupFrame.BorderSizePixel = 0
    self.currentPopup = PopupFrame
    
    local popupBox = Instance.new("Frame", PopupFrame)
    popupBox.Size = UDim2.new(0, 240, 0, 150)
    popupBox.Position = UDim2.new(0.5, -120, 0.5, -75)
    popupBox.BackgroundColor3 = THEME.GlassBg
    popupBox.ZIndex = 3001
    popupBox.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(popupBox, 10)
    -- self.UIFactory.AddStroke(popupBox, THEME.AccentBlue, 2, 0) -- (เอา Stroke ออกตามธีมหลัก)
    
    local titleLabel = self.UIFactory.CreateLabel({
        Parent = popupBox,
        Text = "ENTER AMOUNT",
        Size = UDim2.new(1, 0, 0, 38),
        TextColor = THEME.TextWhite,
        Font = Enum.Font.GothamBold,
        TextSize = 13
    })
    titleLabel.ZIndex = 3002
    
    local input = Instance.new("TextBox", popupBox)
    input.Size = UDim2.new(0.85, 0, 0, 34)
    input.Position = UDim2.new(0.075, 0, 0.35, 0)
    input.Text = tostring(itemData.Default or 1)
    input.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    input.TextColor3 = THEME.TextWhite
    input.Font = Enum.Font.Code
    input.TextSize = 15
    input.ClearTextOnFocus = false
    input.ZIndex = 3002
    input.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(input, 6)
    
    local maxValue = itemData.Max or 999999
    local inputConn = self.Utils.SanitizeNumberInput(input, maxValue)
    
    local function ClosePopup()
        if inputConn then inputConn:Disconnect() end
        if PopupFrame and PopupFrame.Parent then PopupFrame:Destroy() end
        self.isPopupOpen = false
        self.currentPopup = nil
    end
    
    local confirmBtn = self.UIFactory.CreateButton({
        Size = UDim2.new(0.85, 0, 0, 34),
        Position = UDim2.new(0.075, 0, 0.7, 0),
        Text = "CONFIRM",
        BgColor = THEME.AccentBlue,
        CornerRadius = 6,
        Parent = popupBox
    })
    confirmBtn.ZIndex = 3002
    
    local closeBtn = self.UIFactory.CreateButton({
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -30, 0, 4),
        Text = "X",
        BgColor = THEME.Fail,
        CornerRadius = 6,
        Parent = popupBox
    })
    closeBtn.ZIndex = 3002
    
    closeBtn.MouseButton1Click:Connect(ClosePopup)
    confirmBtn.MouseButton1Click:Connect(function()
        local quantity = tonumber(input.Text)
        if quantity and quantity > 0 and quantity <= maxValue then
            ClosePopup()
            onConfirm(quantity)
        end
    end)
end

return InventoryTab