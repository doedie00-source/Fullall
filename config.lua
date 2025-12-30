-- config.lua
-- Configuration & Constants (Dark Blue Professional Theme)

local CONFIG = {
    VERSION = "7.3",
    GUI_NAME = "ModernTradeGUI",
    
    -- Window Settings
    MAIN_WINDOW_SIZE = UDim2.new(0, 750, 0, 480),
    SIDEBAR_WIDTH = 110,
    MINI_ICON_SIZE = UDim2.new(0, 50, 0, 50),
    
    -- Timing
    STATUS_RESET_DELAY = 4,
    BUTTON_CHECK_INTERVAL = 0.5,
    TRADE_RESET_THRESHOLD = 3,
    
    -- UI Spacing
    CORNER_RADIUS = 10,
    LIST_PADDING = 4,
    BUTTON_PADDING = 5,
    CARD_PADDING = 6,
    
    -- Keybind
    TOGGLE_KEY = Enum.KeyCode.T,
}

-- ⚡ Blue-White Professional Theme (Keep Red/Green for Status)
-- config.lua (Aggressive Midnight Edition)

local THEME = {
    -- Base: Deep Navy (พื้นหลังน้ำเงินมืด แบบโปรแกรม Python)
    MainBg = Color3.fromRGB(10, 13, 20),            -- น้ำเงินมืดเกือบดำ (Dark Navy)
    MainTransparency = 0,                           -- ทึบ 100%

    PanelBg = Color3.fromRGB(15, 20, 30),           -- พื้นหลังรอง สว่างขึ้นนิดนึง
    PanelTransparency = 0,

    -- Glass/Containers (จุดสำคัญ! เส้นขอบสีฟ้าสว่าง)
    GlassBg = Color3.fromRGB(20, 25, 40),           -- พื้นหลังกล่องข้อความ
    GlassTransparency = 0,                          
    GlassStroke = Color3.fromRGB(0, 100, 200),      -- **เส้นขอบสีน้ำเงินฟ้า (Electric Blue)** ตัดขอบชัดๆ แบบในรูป

    -- Text (ขาวกับฟ้า)
    TextWhite = Color3.fromRGB(240, 250, 255),      -- ขาวอมฟ้านิดๆ
    TextGray = Color3.fromRGB(140, 160, 190),       -- เทาฟ้า
    TextDim = Color3.fromRGB(80, 100, 130),         -- เทาเข้ม

    -- Buttons (ปุ่มสไตล์ System)
    BtnDefault = Color3.fromRGB(25, 35, 55),        -- ปุ่มพื้นน้ำเงินเข้ม
    BtnHover = Color3.fromRGB(0, 80, 160),          -- ชี้แล้วเป็นสีฟ้าเข้ม
    BtnSelected = Color3.fromRGB(0, 120, 220),      -- เลือกแล้วเป็นสีฟ้าสว่าง (Cyan Blue)
    
    BtnMainTab = Color3.fromRGB(18, 22, 35),        -- แท็บด้านซ้าย
    BtnMainTabSelected = Color3.fromRGB(0, 120, 220), -- แท็บที่เลือกสีฟ้าสว่าง

    BtnDupe = Color3.fromRGB(0, 120, 220),          -- ปุ่มหลักสีฟ้าสว่าง
    BtnDisabled = Color3.fromRGB(12, 15, 20),       -- ปุ่มปิด
    TextDisabled = Color3.fromRGB(60, 70, 90),

    -- Status Colors (นีออนชัดๆ)
    Success = Color3.fromRGB(0, 255, 180),          -- เขียวมิ้นต์ (Cyber Green)
    Fail = Color3.fromRGB(255, 60, 60),             -- แดงสด
    Warning = Color3.fromRGB(255, 200, 50),         -- เหลือง
    Info = Color3.fromRGB(0, 180, 255),             -- ฟ้า
    
    -- Item Status
    ItemInv = Color3.fromRGB(0, 255, 180),
    ItemEquip = Color3.fromRGB(255, 60, 60),
    PlayerBtn = Color3.fromRGB(30, 40, 60),
    DupeReady = Color3.fromRGB(0, 255, 180),

    -- Cards (การ์ดแบบ Cyber)
    CardBg = Color3.fromRGB(20, 28, 45),            -- พื้นหลังการ์ดน้ำเงินเข้ม
    CardStrokeSelected = Color3.fromRGB(0, 160, 255), -- ขอบฟ้าสว่างวาบ (Cyan Glow)
    CardStrokeLocked = Color3.fromRGB(200, 50, 50),
    CrateSelected = Color3.fromRGB(0, 160, 255),

    -- Accent Colors
    StarColor = Color3.fromRGB(255, 215, 0),
    AccentPurple = Color3.fromRGB(140, 80, 255),
    AccentBlue = Color3.fromRGB(0, 140, 255),       -- ฟ้าหลัก (Cyber Blue)
    AccentGreen = Color3.fromRGB(0, 220, 140),
}
local DUPE_RECIPES = {
    Items = {
        -- [SCROLLS]
        {Name = "Dark Scroll", Tier = 5, RequiredTiers = {3, 4, 6}, Service = "Scrolls", Image = "83561916475671"},
        
        -- [TICKETS]
        {Name = "Void Ticket", Tier = 3, RequiredTiers = {4, 5, 6}, Service = "Tickets", Image = "85868652778541"},
        {Name = "Summer Ticket", Tier = 4, RequiredTiers = {3, 5, 6}, Service = "Tickets", Image = "104675798190180"},
        {Name = "Eternal Ticket", Tier = 5, RequiredTiers = {3, 4, 6}, Service = "Tickets", Image = "130196431947308"},
        {Name = "Arcade Ticket", Tier = 6, RequiredTiers = {3, 4, 5}, Service = "Tickets", Image = "104884644514614"},
        
        -- [POTIONS]
        {Name = "White Strawberry", Tier = 1, RequiredTiers = {2}, Service = "Strawberry", Image = "79066822879876"},
        {Name = "Mega Luck Potion", Tier = 3, RequiredTiers = {1, 2}, Service = "Luck Potion", Image = "131175270021637"},
        {Name = "Mega Wins Potion", Tier = 3, RequiredTiers = {1, 2}, Service = "Wins Potion", Image = "77652691143188"},
        {Name = "Mega Exp Potion", Tier = 3, RequiredTiers = {1, 2}, Service = "Exp Potion", Image = "72861583354784"},
    },
    Crates = {},
    Pets = {}
}

local HIDDEN_LISTS = {
    Accessories = {"Ghost", "Pumpkin Head", "Tri Tooth", "Tri Foot", "Tri Eyes", "Tri Ton"},
    Pets = {"I.N.D.E.X", "Spooksy", "Spooplet", "Lordfang", "Batkin", "Flame", "Mega Flame", "Turbo Flame", "Ultra Flame", "I2Pet", "Present", "Polar Bear"},
    Crates = { "Spooky Crate", "i2Perfect Crate" }
}

return {
    CONFIG = CONFIG,
    THEME = THEME,
    DUPE_RECIPES = DUPE_RECIPES,
    HIDDEN_LISTS = HIDDEN_LISTS
}
