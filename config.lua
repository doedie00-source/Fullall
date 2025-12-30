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
    -- Base: Deep Void (ดำเกือบสนิท ผสมน้ำเงินลึกสุดๆ)
    MainBg = Color3.fromRGB(5, 6, 10),              -- ดำลึก (Deep Void) - เข้มกว่าเดิมมาก
    MainTransparency = 0,                           -- ทึบตัน (Solid) ไม่จาง

    PanelBg = Color3.fromRGB(12, 14, 20),           -- ดำน้ำเงินเข้ม (Deep Navy)
    PanelTransparency = 0,

    -- Container/Glass: (ดำตัดขอบดุๆ)
    GlassBg = Color3.fromRGB(15, 18, 25),           -- พื้นหลังกล่อง สีเข้มจัด
    GlassTransparency = 0,
    GlassStroke = Color3.fromRGB(40, 55, 80),       -- เส้นขอบสีน้ำเงินหม่น ตัดให้เห็นขอบเขตชัดเจน

    -- Text: (ขาวจั๊วะ ตัดกับพื้นดำ)
    TextWhite = Color3.fromRGB(255, 255, 255),      -- ขาวบริสุทธิ์ อ่านง่ายสุดบนพื้นดำ
    TextGray = Color3.fromRGB(180, 190, 210),       -- เทาอมฟ้าสว่าง
    TextDim = Color3.fromRGB(100, 110, 130),        -- เทาเข้ม

    -- Buttons: (ดุดัน พื้นดำน้ำเงิน กดแล้วฟ้าสด)
    BtnDefault = Color3.fromRGB(20, 25, 35),        -- ปุ่มสีดำน้ำเงิน
    BtnHover = Color3.fromRGB(30, 45, 80),          -- เมาส์ชี้แล้วสว่างขึ้นแบบมีสีสัน
    BtnSelected = Color3.fromRGB(0, 90, 220),       -- ** สีน้ำเงินสด (Electric Blue) ** ตัดฉับ!
    
    BtnMainTab = Color3.fromRGB(15, 18, 24),        -- แท็บสีมืด
    BtnMainTabSelected = Color3.fromRGB(0, 100, 255), -- เลือกแล้วเป็นสีน้ำเงินนีออน

    BtnDupe = Color3.fromRGB(0, 100, 255),          -- ปุ่ม Dupe สีน้ำเงินสด
    BtnDisabled = Color3.fromRGB(10, 12, 16),       -- ดำมืด
    TextDisabled = Color3.fromRGB(60, 65, 75),      -- สีจางจนเกือบมองไม่เห็น

    -- Status Colors (นีออน ตัดพื้นดำ)
    Success = Color3.fromRGB(0, 255, 150),          -- เขียวนีออน
    Fail = Color3.fromRGB(255, 50, 50),             -- แดงสด
    Warning = Color3.fromRGB(255, 200, 0),          -- เหลืองสด
    Info = Color3.fromRGB(0, 180, 255),             -- ฟ้าสด
    
    -- Item Status
    ItemInv = Color3.fromRGB(0, 255, 150),
    ItemEquip = Color3.fromRGB(255, 50, 50),
    PlayerBtn = Color3.fromRGB(25, 30, 40),
    DupeReady = Color3.fromRGB(0, 255, 150),

    -- Cards (พื้นดำ ตัดขอบสีน้ำเงินเข้ม)
    CardBg = Color3.fromRGB(18, 20, 28),            -- การ์ดสีดำน้ำเงินเข้ม
    CardStrokeSelected = Color3.fromRGB(0, 140, 255), -- ขอบฟ้าสว่างวาบ (Electric Stroke)
    CardStrokeLocked = Color3.fromRGB(200, 30, 30),   -- ขอบแดงเข้ม
    CrateSelected = Color3.fromRGB(0, 140, 255),

    -- Accent Colors
    StarColor = Color3.fromRGB(255, 215, 0),
    AccentPurple = Color3.fromRGB(120, 50, 220),
    AccentBlue = Color3.fromRGB(0, 110, 255),       -- ฟ้าเข้มสด (Vibrant Blue)
    AccentGreen = Color3.fromRGB(0, 220, 120),
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
