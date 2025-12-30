-- tabs/dupe_tab.lua
-- Dupe Tab Module - Blue-White Professional Theme

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local ReplicaListener = Knit.GetController("ReplicaListener")

local SuccessLoadCrates, CratesInfo = pcall(function() 
    return require(ReplicatedStorage.GameInfo.CratesInfo) 
end)
if not SuccessLoadCrates then CratesInfo = {} end

local SuccessLoadPets, PetsInfo = pcall(function() 
    return require(ReplicatedStorage.GameInfo.PetsInfo) 
end)
if not SuccessLoadPets then PetsInfo = {} end

local DupeTab = {}
DupeTab.__index = DupeTab

function DupeTab.new(deps)
    local self = setmetatable({}, DupeTab)
    
    self.UIFactory = deps.UIFactory
    self.StateManager = deps.StateManager
    self.InventoryManager = deps.InventoryManager
    self.TradeManager = deps.TradeManager
    self.Utils = deps.Utils
    self.Config = deps.Config
    self.StatusLabel = deps.StatusLabel
    self.InfoLabel = deps.InfoLabel
    self.ScreenGui = deps.ScreenGui
    
    self.Container = nil
    self.SubTabButtons = {}
    self.CurrentSubTab = "Items"
    self.FloatingButtons = {} 
    self.TooltipRef = nil
    
    self.isPopupOpen = false
    self.currentPopup = nil
    
    return self
end

function DupeTab:Init(parent)
    local THEME = self.Config.THEME
    
    -- Header
    local header = Instance.new("Frame", parent)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 68)
    header.BackgroundTransparency = 1
    
    local title = self.UIFactory.CreateLabel({
        Parent = header,
        Text = "  MAGIC DUPE SYSTEM",
        Size = UDim2.new(1, -8, 0, 22),
        Position = UDim2.new(0, 8, 0, 0),
        TextColor = THEME.TextWhite,
        TextSize = 14,
        Font = Enum.Font.GothamBlack,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    local subtitle = self.UIFactory.CreateLabel({
        Parent = header,
        Text = "Dupe items, crates, and pets using trade exploit",
        Size = UDim2.new(1, -8, 0, 14),
        Position = UDim2.new(0, 8, 0, 22),
        TextColor = THEME.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlign = Enum.TextXAlignment.Left
    })
    
    -- Sub-tabs
    local tabsContainer = Instance.new("Frame", header)
    tabsContainer.Size = UDim2.new(1, -8, 0, 30)
    tabsContainer.Position = UDim2.new(0, 8, 0, 38)
    tabsContainer.BackgroundTransparency = 1
    
    local tabsLayout = Instance.new("UIListLayout", tabsContainer)
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 6)
    
    self:CreateSubTab(tabsContainer, "Items", "ITEMS")
    self:CreateSubTab(tabsContainer, "Crates", "CRATES")
    self:CreateSubTab(tabsContainer, "Pets", "PETS")
    
    -- Content Container
    self.Container = self.UIFactory.CreateScrollingFrame({
        Parent = parent,
        Size = UDim2.new(1, 0, 1, -72),
        Position = UDim2.new(0, 0, 0, 70)
    })
    
    self:CreateFloatingButtons(parent)
    
    -- Load First Tab
    self:SwitchSubTab("Items")
end

function DupeTab:CreateFloatingButtons(parent)
    local THEME = self.Config.THEME
    
    local spacing = 6
    local btnWidth = 88
    local btnHeight = 30
    local startX = -8 
    
    -- DUPE Button
    self.FloatingButtons.BtnDupePet = self.UIFactory.CreateButton({
        Size = UDim2.new(0, btnWidth, 0, btnHeight),
        Position = UDim2.new(1, startX - btnWidth, 1, -36),
        Text = "DUPE",
        BgColor = THEME.CardBg,
        TextColor = THEME.TextWhite,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = parent,
        OnClick = function() self:OnDupePets() end
    })
    self.FloatingButtons.BtnDupePet.ZIndex = 101
    self.FloatingButtons.BtnDupePet.Visible = false
    self.UIFactory.AddStroke(self.FloatingButtons.BtnDupePet, THEME.AccentBlue, 1.5, 0.4)
    
    -- EVOLVE Button
    self.FloatingButtons.BtnEvoPet = self.UIFactory.CreateButton({
        Size = UDim2.new(0, btnWidth + 12, 0, btnHeight),
        Position = UDim2.new(1, startX - btnWidth*2 - spacing - 12, 1, -36),
        Text = "EVOLVE",
        BgColor = THEME.CardBg,
        TextColor = THEME.TextWhite,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = parent,
        OnClick = function() self:OnEvolvePets() end
    })
    self.FloatingButtons.BtnEvoPet.ZIndex = 101
    self.FloatingButtons.BtnEvoPet.Visible = false
    self.UIFactory.AddStroke(self.FloatingButtons.BtnEvoPet, THEME.AccentBlue, 1.5, 0.4)
    
    -- DELETE Button
    self.FloatingButtons.BtnDeletePet = self.UIFactory.CreateButton({
        Size = UDim2.new(0, btnWidth, 0, btnHeight),
        Position = UDim2.new(1, startX - btnWidth*3 - spacing*2 - 12, 1, -36),
        Text = "DELETE",
        BgColor = THEME.CardBg,
        TextColor = THEME.TextWhite,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = parent,
        OnClick = function() self:OnDeletePets() end
    })
    self.FloatingButtons.BtnDeletePet.ZIndex = 101
    self.FloatingButtons.BtnDeletePet.Visible = false
    self.UIFactory.AddStroke(self.FloatingButtons.BtnDeletePet, THEME.Fail, 1.5, 0.4)
    
    -- ADD ALL Button
    self.FloatingButtons.BtnAddAll1k = self.UIFactory.CreateButton({
        Size = UDim2.new(0, 130, 0, btnHeight),
        Position = UDim2.new(1, -138, 1, -36),
        Text = "ADD ALL",
        BgColor = THEME.CardBg,
        TextColor = THEME.TextWhite,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = parent
    })
    if self.FloatingButtons.BtnAddAll1k then
        self.FloatingButtons.BtnAddAll1k.ZIndex = 101
        self.FloatingButtons.BtnAddAll1k.Visible = false
        self.UIFactory.AddStroke(self.FloatingButtons.BtnAddAll1k, THEME.AccentBlue, 1.5, 0.4)
    end
end

function DupeTab:CreateSubTab(parent, name, text)
    local THEME = self.Config.THEME
    
    local btn = self.UIFactory.CreateButton({
        Parent = parent,
        Text = text,
        Size = UDim2.new(0, 92, 0, 30),
        BgColor = THEME.BtnDefault,
        TextColor = THEME.TextGray,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        CornerRadius = 6,
        OnClick = function()
            self:SwitchSubTab(name)
        end
    })
    
    self.SubTabButtons[name] = btn
end

function DupeTab:SwitchSubTab(name)
    local THEME = self.Config.THEME
    
    self.CurrentSubTab = name
    self.StateManager.currentDupeTab = name
    
    -- Update Sub-tab Buttons Style
    for tabName, btn in pairs(self.SubTabButtons) do
        local isSelected = (tabName == name)
        btn.BackgroundColor3 = isSelected and THEME.AccentBlue or THEME.BtnDefault
        btn.TextColor3 = isSelected and THEME.TextWhite or THEME.TextGray
    end
    
    -- Update Floating Buttons Visibility
    if name == "Pets" then
        if self.FloatingButtons.BtnDeletePet then self.FloatingButtons.BtnDeletePet.Visible = true end
        if self.FloatingButtons.BtnEvoPet then self.FloatingButtons.BtnEvoPet.Visible = true end
        if self.FloatingButtons.BtnDupePet then self.FloatingButtons.BtnDupePet.Visible = true end
        if self.FloatingButtons.BtnAddAll1k then self.FloatingButtons.BtnAddAll1k.Visible = false end
    elseif name == "Crates" then
        if self.FloatingButtons.BtnDeletePet then self.FloatingButtons.BtnDeletePet.Visible = false end
        if self.FloatingButtons.BtnEvoPet then self.FloatingButtons.BtnEvoPet.Visible = false end
        if self.FloatingButtons.BtnDupePet then self.FloatingButtons.BtnDupePet.Visible = false end
        if self.FloatingButtons.BtnAddAll1k then self.FloatingButtons.BtnAddAll1k.Visible = true end
    else  -- Items
        for _, btn in pairs(self.FloatingButtons) do
            if btn then btn.Visible = false end
        end
    end
    
    -- Update Info Label
    if self.InfoLabel then
        if name == "Items" then
            self.InfoLabel.Text = ""
        elseif name == "Crates" then
            local count = 0
            for _ in pairs(self.StateManager.selectedCrates) do count = count + 1 end
            self.InfoLabel.Text = count > 0 and (count .. " SELECTED") or ""
            self.InfoLabel.TextColor3 = THEME.AccentBlue
        elseif name == "Pets" then
            local count = 0
            for _ in pairs(self.StateManager.selectedPets) do count = count + 1 end
            self.InfoLabel.Text = count > 0 and (count .. " SELECTED") or ""
            self.InfoLabel.TextColor3 = THEME.AccentBlue
        end
    end
    
    self:RefreshInventory()
end

function DupeTab:RefreshInventory()
    local THEME = self.Config.THEME
    
    for _, child in pairs(self.Container:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIGridLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    if self.CurrentSubTab == "Items" then
        self:LoadItemsTab()
    elseif self.CurrentSubTab == "Crates" then
        self:LoadCratesTab()
    elseif self.CurrentSubTab == "Pets" then
        self:LoadPetsTab()
    end
end

-- Items Tab (จาก code เดิม แต่ปรับสีตาม THEME)
function DupeTab:LoadItemsTab()
    local THEME = self.Config.THEME
    local DUPE_RECIPES = self.Config.DUPE_RECIPES
    
    if self.Container:FindFirstChild("UIGridLayout") then
        self.Container.UIGridLayout:Destroy()
    end
    
    local padding = self.Container:FindFirstChild("UIPadding") or Instance.new("UIPadding", self.Container)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 4)
    
    local playerData = self.InventoryManager.GetPlayerData()
    if not playerData then return end
    
    local count = 0
    for _, recipe in ipairs(DUPE_RECIPES.Items) do
        count = count + 1
        local card = Instance.new("Frame", self.Container)
        card.Name = recipe.Name
        card.Size = UDim2.new(1, -16, 0, 72)
        card.BackgroundColor3 = THEME.CardBg
        card.BackgroundTransparency = 0.2
        card.BorderSizePixel = 0
        
        self.UIFactory.AddCorner(card, 8)
        
        -- Check status
        local hasItem = self.InventoryManager.HasItem(recipe.Service, recipe.Tier, playerData)
        local canDupe = true
        for _, tier in ipairs(recipe.RequiredTiers) do
            if not self.InventoryManager.HasItem(recipe.Service, tier, playerData) then
                canDupe = false
                break
            end
        end
        
        -- Set border color
        local borderColor = THEME.GlassStroke
        local borderTransparency = 0.6
        if hasItem then
            borderColor = THEME.ItemInv  -- Green
            borderTransparency = 0.3
        elseif canDupe then
            borderColor = THEME.CardStrokeSelected  -- White-Blue
            borderTransparency = 0.3
        end
        self.UIFactory.AddStroke(card, borderColor, 1.5, borderTransparency)
        
        -- Item Icon
        local icon = Instance.new("ImageLabel", card)
        icon.Size = UDim2.new(0, 56, 0, 56)
        icon.Position = UDim2.new(0, 8, 0.5, -28)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://" .. recipe.Image
        self.UIFactory.AddCorner(icon, 6)
        
        -- Item Name
        local nameLabel = self.UIFactory.CreateLabel({
            Parent = card,
            Text = recipe.Name,
            Size = UDim2.new(0, 280, 0, 18),
            Position = UDim2.new(0, 72, 0, 12),
            TextColor = THEME.TextWhite,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlign = Enum.TextXAlignment.Left
        })
        
        -- Status Text
        local statusText = hasItem and "OWNED" or (canDupe and "READY TO DUPE" or "MISSING ITEMS")
        local statusColor = hasItem and THEME.ItemInv or (canDupe and THEME.AccentBlue or THEME.TextDim)
        
        local statusLabel = self.UIFactory.CreateLabel({
            Parent = card,
            Text = statusText,
            Size = UDim2.new(0, 280, 0, 14),
            Position = UDim2.new(0, 72, 0, 32),
            TextColor = statusColor,
            TextSize = 10,
            Font = Enum.Font.GothamBold,
            TextXAlign = Enum.TextXAlignment.Left
        })
        
        -- Tier Info
        local tierText = "Tier " .. recipe.Tier .. " | Need: " .. table.concat(recipe.RequiredTiers, ", ")
        local tierLabel = self.UIFactory.CreateLabel({
            Parent = card,
            Text = tierText,
            Size = UDim2.new(0, 280, 0, 12),
            Position = UDim2.new(0, 72, 0, 48),
            TextColor = THEME.TextDim,
            TextSize = 9,
            Font = Enum.Font.Gotham,
            TextXAlign = Enum.TextXAlignment.Left
        })
        
        -- Dupe Button
        local dupeBtn = self.UIFactory.CreateButton({
            Size = UDim2.new(0, 70, 0, 28),
            Position = UDim2.new(1, -78, 0.5, -14),
            Text = "DUPE",
            BgColor = canDupe and THEME.AccentBlue or THEME.BtnDisabled,
            TextColor = canDupe and THEME.TextWhite or THEME.TextDisabled,
            TextSize = 10,
            Font = Enum.Font.GothamBold,
            CornerRadius = 6,
            Parent = card,
            OnClick = function()
                if not canDupe then
                    self.StateManager:SetStatus("Missing required tiers", THEME.Fail, self.StatusLabel)
                    return
                end
                self:OnDupeItem(recipe, playerData)
            end
        })
        dupeBtn.AutoButtonColor = canDupe
    end
    
    self.Container.CanvasSize = UDim2.new(0, 0, 0, count * 76)
end

-- Crates Tab
function DupeTab:LoadCratesTab()
    local THEME = self.Config.THEME
    local HIDDEN = self.Config.HIDDEN_LISTS.Crates
    
    local existingLayout = self.Container:FindFirstChild("UIListLayout")
    if existingLayout then existingLayout:Destroy() end
    
    local gridLayout = Instance.new("UIGridLayout", self.Container)
    gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
    gridLayout.CellSize = UDim2.new(0, 100, 0, 120)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = self.Container:FindFirstChild("UIPadding") or Instance.new("UIPadding", self.Container)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 4)
    
    local playerData = self.InventoryManager.GetPlayerData()
    if not playerData or not playerData.CratesService or not playerData.CratesService.OwnedCrates then return end
    
    local ownedCrates = playerData.CratesService.OwnedCrates
    
    if self.FloatingButtons.BtnAddAll1k then
        self.FloatingButtons.BtnAddAll1k.MouseButton1Click:Connect(function()
            local added = 0
            for crateName, amount in pairs(ownedCrates) do
                if amount > 0 and not self:IsHiddenCrate(crateName, HIDDEN) then
                    if not self.StateManager.selectedCrates[crateName] then
                        self.StateManager.selectedCrates[crateName] = math.min(1000, amount)
                        added = added + 1
                    end
                end
            end
            
            if added > 0 then
                self.StateManager:SetStatus("Added " .. added .. " crates (1K each)", THEME.Success, self.StatusLabel)
                self:RefreshInventory()
            end
        end)
    end
    
    for crateName, amount in pairs(ownedCrates) do
        if amount > 0 and not self:IsHiddenCrate(crateName, HIDDEN) then
            self:CreateCrateCard(crateName, amount, THEME)
        end
    end
end

function DupeTab:CreateCrateCard(crateName, amount, THEME)
    local card = Instance.new("Frame", self.Container)
    card.Name = crateName
    card.BackgroundColor3 = THEME.CardBg
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(card, 8)
    
    local isSelected = self.StateManager.selectedCrates[crateName] ~= nil
    local borderColor = isSelected and THEME.CardStrokeSelected or THEME.GlassStroke
    local borderTransparency = isSelected and 0.2 or 0.6
    self.UIFactory.AddStroke(card, borderColor, 1.5, borderTransparency)
    
    -- Crate Icon
    local crateInfo = CratesInfo[crateName]
    local icon = Instance.new("ImageLabel", card)
    icon.Size = UDim2.new(1, -12, 0, 70)
    icon.Position = UDim2.new(0, 6, 0, 6)
    icon.BackgroundTransparency = 1
    icon.Image = crateInfo and ("rbxassetid://" .. crateInfo.ImageId) or ""
    self.UIFactory.AddCorner(icon, 6)
    
    -- Crate Name
    local nameLabel = self.UIFactory.CreateLabel({
        Parent = card,
        Text = crateName,
        Size = UDim2.new(1, -8, 0, 14),
        Position = UDim2.new(0, 4, 0, 78),
        TextColor = THEME.TextWhite,
        TextSize = 9,
        Font = Enum.Font.GothamBold
    })
    nameLabel.TextWrapped = true
    nameLabel.TextScaled = true
    
    -- Amount Label
    local amountLabel = self.UIFactory.CreateLabel({
        Parent = card,
        Text = "x" .. amount,
        Size = UDim2.new(1, -8, 0, 12),
        Position = UDim2.new(0, 4, 0, 94),
        TextColor = THEME.TextGray,
        TextSize = 9,
        Font = Enum.Font.Gotham
    })
    
    -- Selection Indicator
    if isSelected then
        local checkMark = self.UIFactory.CreateLabel({
            Parent = card,
            Text = "✓",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -24, 0, 4),
            TextColor = THEME.CardStrokeSelected,
            TextSize = 16,
            Font = Enum.Font.GothamBlack
        })
        local bg = Instance.new("Frame", checkMark)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = THEME.CardBg
        bg.ZIndex = checkMark.ZIndex - 1
        self.UIFactory.AddCorner(bg, 4)
    end
    
    -- Click handler
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    btn.MouseButton1Click:Connect(function()
        self:ShowQuantityPopup({
            Name = crateName,
            Max = amount,
            Default = math.min(1000, amount)
        }, function(quantity)
            self.StateManager.selectedCrates[crateName] = quantity
            self.StateManager:SetStatus("Selected " .. crateName .. " x" .. quantity, THEME.Success, self.StatusLabel)
            self:RefreshInventory()
        end)
    end)
end

-- Pets Tab (ย่อลงเพื่อความกระชับ)
function DupeTab:LoadPetsTab()
    local THEME = self.Config.THEME
    local HIDDEN = self.Config.HIDDEN_LISTS.Pets
    
    local existingLayout = self.Container:FindFirstChild("UIListLayout")
    if existingLayout then existingLayout:Destroy() end
    
    local gridLayout = Instance.new("UIGridLayout", self.Container)
    gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
    gridLayout.CellSize = UDim2.new(0, 100, 0, 120)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = self.Container:FindFirstChild("UIPadding") or Instance.new("UIPadding", self.Container)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 4)
    
    local playerData = self.InventoryManager.GetPlayerData()
    if not playerData or not playerData.PetsService or not playerData.PetsService.OwnedPets then return end
    
    local ownedPets = playerData.PetsService.OwnedPets
    local equippedPets = playerData.PetsService.EquippedPets or {}
    
    for uuid, petInfo in pairs(ownedPets) do
        if petInfo.Name and not self:IsHiddenPet(petInfo.Name, HIDDEN) then
            self:CreatePetCard(uuid, petInfo, equippedPets, THEME)
        end
    end
    
    self:UpdateEvolveButtonState()
end

function DupeTab:CreatePetCard(uuid, petInfo, equippedPets, THEME)
    local card = Instance.new("Frame", self.Container)
    card.Name = uuid
    card.BackgroundColor3 = THEME.CardBg
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(card, 8)
    
    local isEquipped = table.find(equippedPets, uuid) ~= nil
    local isSelected = self.StateManager.selectedPets[uuid] ~= nil
    
    local borderColor = THEME.GlassStroke
    local borderTransparency = 0.6
    if isEquipped then
        borderColor = THEME.ItemEquip  -- Red
        borderTransparency = 0.3
    elseif isSelected then
        borderColor = THEME.CardStrokeSelected  -- White-Blue
        borderTransparency = 0.2
    end
    self.UIFactory.AddStroke(card, borderColor, 1.5, borderTransparency)
    
    -- Pet Icon
    local petData = PetsInfo[petInfo.Name]
    local icon = Instance.new("ImageLabel", card)
    icon.Size = UDim2.new(1, -12, 0, 70)
    icon.Position = UDim2.new(0, 6, 0, 6)
    icon.BackgroundTransparency = 1
    icon.Image = petData and ("rbxassetid://" .. petData.ImageId) or ""
    self.UIFactory.AddCorner(icon, 6)
    
    -- Pet Name + Level
    local displayText = petInfo.Name
    if petInfo.Level then displayText = displayText .. " Lv." .. petInfo.Level end
    
    local nameLabel = self.UIFactory.CreateLabel({
        Parent = card,
        Text = displayText,
        Size = UDim2.new(1, -8, 0, 14),
        Position = UDim2.new(0, 4, 0, 78),
        TextColor = THEME.TextWhite,
        TextSize = 9,
        Font = Enum.Font.GothamBold
    })
    nameLabel.TextWrapped = true
    nameLabel.TextScaled = true
    
    -- Status
    local statusText = isEquipped and "EQUIPPED" or ""
    local statusLabel = self.UIFactory.CreateLabel({
        Parent = card,
        Text = statusText,
        Size = UDim2.new(1, -8, 0, 12),
        Position = UDim2.new(0, 4, 0, 94),
        TextColor = isEquipped and THEME.ItemEquip or THEME.TextGray,
        TextSize = 8,
        Font = Enum.Font.GothamBold
    })
    
    -- Selection Number
    if isSelected then
        local selectionNum = self.StateManager.selectedPets[uuid]
        local numLabel = self.UIFactory.CreateLabel({
            Parent = card,
            Text = tostring(selectionNum),
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(1, -26, 0, 4),
            TextColor = THEME.TextWhite,
            TextSize = 12,
            Font = Enum.Font.GothamBlack,
            BgColor = THEME.AccentBlue
        })
        numLabel.BackgroundTransparency = 0
        self.UIFactory.AddCorner(numLabel, 4)
    end
    
    -- Click handler
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    btn.MouseButton1Click:Connect(function()
        if isEquipped then
            self.StateManager:SetStatus("Cannot select equipped pet", THEME.Fail, self.StatusLabel)
            return
        end
        
        self.StateManager:TogglePetSelection(uuid)
        self:RefreshInventory()
        self:UpdateEvolveButtonState()
        
        local count = 0
        for _ in pairs(self.StateManager.selectedPets) do count = count + 1 end
        if self.InfoLabel then
            self.InfoLabel.Text = count > 0 and (count .. " SELECTED") or ""
        end
    end)
end

-- Helper functions
function DupeTab:IsHiddenCrate(name, hiddenList)
    for _, hidden in ipairs(hiddenList) do
        if name:find(hidden) then return true end
    end
    return false
end

function DupeTab:IsHiddenPet(name, hiddenList)
    for _, hidden in ipairs(hiddenList) do
        if name == hidden then return true end
    end
    return false
end

-- Action handlers
function DupeTab:OnDupeItem(recipe, playerData)
    local THEME = self.Config.THEME
    
    self:ShowQuantityPopup({
        Name = recipe.Name,
        Max = 999,
        Default = 1
    }, function(quantity)
        -- Add to trade
        for i = 1, quantity do
            local key = recipe.Service .. "_" .. recipe.Tier .. "_" .. i
            self.StateManager:AddToTrade(key, {
                Name = recipe.Name,
                Amount = 1,
                Service = recipe.Service,
                Category = "Items",
                Type = "Service",
                RawInfo = {Tier = recipe.Tier}
            })
        end
        
        self.StateManager:SetStatus("Added " .. quantity .. "x " .. recipe.Name, THEME.Success, self.StatusLabel)
        
        if _G.ModernGUI then
            _G.ModernGUI:SwitchTab("Inventory")
        end
    end)
end

function DupeTab:OnDupePets()
    local THEME = self.Config.THEME
    local count = 0
    for uuid, _ in pairs(self.StateManager.selectedPets) do count = count + 1 end
    
    if count == 0 then
        self.StateManager:SetStatus("No pets selected", THEME.Fail, self.StatusLabel)
        return
    end
    
    for uuid, _ in pairs(self.StateManager.selectedPets) do
        local playerData = self.InventoryManager.GetPlayerData()
        if playerData and playerData.PetsService then
            local petInfo = playerData.PetsService.OwnedPets[uuid]
            if petInfo then
                local key = "Pet_" .. uuid
                self.StateManager:AddToTrade(key, {
                    Name = petInfo.Name,
                    Amount = 1,
                    Guid = uuid,
                    Service = "PetsService",
                    Category = "Pets",
                    Type = "GUID",
                    RawInfo = petInfo
                })
            end
        end
    end
    
    self.StateManager:SetStatus("Added " .. count .. " pets to trade", THEME.Success, self.StatusLabel)
    self.StateManager.selectedPets = {}
    
    if _G.ModernGUI then
        _G.ModernGUI:SwitchTab("Inventory")
    end
end

function DupeTab:OnEvolvePets()
    local THEME = self.Config.THEME
    
    if not self.FloatingButtons.BtnEvoPet:GetAttribute("IsValid") then
        self.StateManager:SetStatus("Select 3 same pets to evolve", THEME.Fail, self.StatusLabel)
        return
    end
    
    local count = 0
    for uuid, _ in pairs(self.StateManager.selectedPets) do
        count = count + 1
        if count >= 3 then break end
    end
    
    self.TradeManager.EvolvePets(self.StateManager.selectedPets, self.StatusLabel, self.StateManager)
    self.StateManager.selectedPets = {}
    self:RefreshInventory()
end

function DupeTab:OnDeletePets()
    local THEME = self.Config.THEME
    local count = 0
    for _ in pairs(self.StateManager.selectedPets) do count = count + 1 end
    
    if count == 0 then
        self.StateManager:SetStatus("No pets selected", THEME.Fail, self.StatusLabel)
        return
    end
    
    self:ShowConfirm("DELETE " .. count .. " PETS?", function()
        self.TradeManager.DeletePets(self.StateManager.selectedPets, self.StatusLabel, self.StateManager)
        self.StateManager.selectedPets = {}
        self:RefreshInventory()
    end)
end

function DupeTab:UpdateEvolveButtonState()
    if not self.FloatingButtons.BtnEvoPet then return end
    
    local THEME = self.Config.THEME
    local count = 0
    local firstName = nil
    local isValid = true
    
    for uuid, _ in pairs(self.StateManager.selectedPets) do
        count = count + 1
        local playerData = self.InventoryManager.GetPlayerData()
        if playerData and playerData.PetsService then
            local petInfo = playerData.PetsService.OwnedPets[uuid]
            if petInfo then
                if not firstName then
                    firstName = petInfo.Name
                elseif firstName ~= petInfo.Name then
                    isValid = false
                    break
                end
            end
        end
    end
    
    isValid = isValid and count == 3
    
    if isValid then
        self.FloatingButtons.BtnEvoPet.BackgroundColor3 = THEME.CardBg 
        self.FloatingButtons.BtnEvoPet.AutoButtonColor = true
        self.FloatingButtons.BtnEvoPet.TextTransparency = 0
        self.FloatingButtons.BtnEvoPet.TextColor3 = THEME.TextWhite
        
        if self.FloatingButtons.BtnEvoPet:FindFirstChild("UIStroke") then
            self.FloatingButtons.BtnEvoPet.UIStroke.Color = THEME.AccentBlue
            self.FloatingButtons.BtnEvoPet.UIStroke.Thickness = 1.5
            self.FloatingButtons.BtnEvoPet.UIStroke.Transparency = 0.4
        end
    else
        self.FloatingButtons.BtnEvoPet.BackgroundColor3 = THEME.CardBg
        self.FloatingButtons.BtnEvoPet.AutoButtonColor = false
        self.FloatingButtons.BtnEvoPet.TextTransparency = 0.5
        self.FloatingButtons.BtnEvoPet.TextColor3 = THEME.TextDisabled
        
        if self.FloatingButtons.BtnEvoPet:FindFirstChild("UIStroke") then
            self.FloatingButtons.BtnEvoPet.UIStroke.Color = THEME.GlassStroke
            self.FloatingButtons.BtnEvoPet.UIStroke.Thickness = 1
            self.FloatingButtons.BtnEvoPet.UIStroke.Transparency = 0.7
        end
    end
    
    self.FloatingButtons.BtnEvoPet:SetAttribute("IsValid", isValid)
end

function DupeTab:ShowQuantityPopup(itemData, onConfirm)
    if self.isPopupOpen then return end
    
    if self.currentPopup and self.currentPopup.Parent then
        self.currentPopup:Destroy()
        self.currentPopup = nil
    end
    
    local THEME = self.Config.THEME
    self.isPopupOpen = true
    
    local PopupFrame = Instance.new("Frame", self.ScreenGui)
    PopupFrame.Size = UDim2.new(1, 0, 1, 0)
    PopupFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    PopupFrame.BackgroundTransparency = 0.4
    PopupFrame.ZIndex = 3000
    PopupFrame.BorderSizePixel = 0
    self.currentPopup = PopupFrame
    
    local popupBox = Instance.new("Frame", PopupFrame)
    popupBox.Size = UDim2.new(0, 240, 0, 145)
    popupBox.Position = UDim2.new(0.5, -120, 0.5, -72.5)
    popupBox.BackgroundColor3 = THEME.GlassBg
    popupBox.ZIndex = 3001
    popupBox.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(popupBox, 10)
    self.UIFactory.AddStroke(popupBox, THEME.AccentBlue, 2, 0.3)
    
    local titleLabel = self.UIFactory.CreateLabel({
        Parent = popupBox,
        Text = "ENTER AMOUNT",
        Size = UDim2.new(1, 0, 0, 36),
        TextColor = THEME.TextWhite,
        Font = Enum.Font.GothamBold,
        TextSize = 12
    })
    titleLabel.ZIndex = 3002
    
    local input = Instance.new("TextBox", popupBox)
    input.Size = UDim2.new(0.85, 0, 0, 32)
    input.Position = UDim2.new(0.075, 0, 0.35, 0)
    input.Text = tostring(itemData.Default or 1)
    input.BackgroundColor3 = THEME.CardBg
    input.TextColor3 = THEME.TextWhite
    input.Font = Enum.Font.Code
    input.TextSize = 14
    input.ClearTextOnFocus = false
    input.ZIndex = 3002
    input.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(input, 6)
    self.UIFactory.AddStroke(input, THEME.GlassStroke, 1, 0.5)
    
    local maxValue = itemData.Max or 999999
    local inputConn = self.Utils.SanitizeNumberInput(input, maxValue)
    
    local function ClosePopup()
        if inputConn then inputConn:Disconnect() end
        if PopupFrame and PopupFrame.Parent then
            PopupFrame:Destroy()
        end
        self.isPopupOpen = false
        self.currentPopup = nil
    end
    
    local confirmBtn = self.UIFactory.CreateButton({
        Size = UDim2.new(0.85, 0, 0, 32),
        Position = UDim2.new(0.075, 0, 0.7, 0),
        Text = "CONFIRM",
        BgColor = THEME.AccentBlue,
        TextColor = THEME.TextWhite,
        CornerRadius = 6,
        Parent = popupBox
    })
    confirmBtn.ZIndex = 3002
    
    local closeBtn = self.UIFactory.CreateButton({
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -28, 0, 6),
        Text = "✕",
        BgColor = THEME.BtnDefault,
        TextColor = THEME.TextGray,
        TextSize = 12,
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

function DupeTab:ShowConfirm(text, onYes)
    if self.isPopupOpen then return end
    
    local THEME = self.Config.THEME
    self.isPopupOpen = true
    
    local ConfirmOverlay = Instance.new("Frame", self.ScreenGui)
    ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
    ConfirmOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    ConfirmOverlay.BackgroundTransparency = 0.2
    ConfirmOverlay.ZIndex = 2000
    ConfirmOverlay.BorderSizePixel = 0
    self.currentPopup = ConfirmOverlay
    
    local box = Instance.new("Frame", ConfirmOverlay)
    box.Size = UDim2.new(0, 300, 0, 150)
    box.Position = UDim2.new(0.5, -150, 0.5, -75)
    box.BackgroundColor3 = THEME.GlassBg
    box.ZIndex = 2001
    box.BorderSizePixel = 0
    
    self.UIFactory.AddCorner(box, 10)
    self.UIFactory.AddStroke(box, THEME.Fail, 2, 0.3)
    
    local titleLabel = self.UIFactory.CreateLabel({
        Parent = box,
        Text = text,
        Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.new(0, 0, 0, 8),
        Font = Enum.Font.GothamBlack,
        TextSize = 13,
        TextColor = THEME.Fail
    })
    titleLabel.ZIndex = 2002
    
    local subLabel = self.UIFactory.CreateLabel({
        Parent = box,
        Text = "Are you sure? This cannot be undone!",
        Size = UDim2.new(1, -16, 0, 32),
        Position = UDim2.new(0, 8, 0, 48),
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor = THEME.TextGray
    })
    subLabel.ZIndex = 2002
    subLabel.TextWrapped = true
    
    local btnContainer = Instance.new("Frame", box)
    btnContainer.Size = UDim2.new(1, 0, 0, 38)
    btnContainer.Position = UDim2.new(0, 0, 1, -46)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ZIndex = 2002
    
    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 10)
    
    local function CloseConfirm()
        if ConfirmOverlay and ConfirmOverlay.Parent then
            ConfirmOverlay:Destroy()
        end
        self.isPopupOpen = false
        self.currentPopup = nil
    end
    
    local cancelBtn = self.UIFactory.CreateButton({
        Text = "CANCEL",
        Size = UDim2.new(0, 100, 0, 32),
        BgColor = THEME.BtnDefault,
        TextColor = THEME.TextWhite,
        Parent = btnContainer,
        OnClick = CloseConfirm
    })
    cancelBtn.ZIndex = 2003
    
    local yesBtn = self.UIFactory.CreateButton({
        Text = "YES, DELETE",
        Size = UDim2.new(0, 120, 0, 32),
        BgColor = THEME.Fail,
        TextColor = THEME.TextWhite,
        Parent = btnContainer,
        OnClick = function()
            CloseConfirm()
            onYes()
        end
    })
    yesBtn.ZIndex = 2003
end

return DupeTab
