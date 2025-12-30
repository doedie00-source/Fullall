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
local THEME = {
    -- Base Colors (เปลี่ยนจากน้ำเงิน เป็นดำเทาด้านๆ)
    MainBg = Color3.fromRGB(25, 25, 25),            -- ดำเทา (พื้นหลังหลัก)
    MainTransparency = 0,                           -- ปรับเป็น 0 (ทึบ) จะได้ไม่ดูจางเหมือนปิดอยู่
    
    PanelBg = Color3.fromRGB(35, 35, 35),           -- เทาเข้ม
    PanelTransparency = 0,                          -- ปรับทึบ
    
    -- Glass/Containers (ลดความเป็นกระจกสีน้ำเงินลง)
    GlassBg = Color3.fromRGB(40, 40, 40),           -- เทา (พื้นหลังรอง)
    GlassTransparency = 0,                          -- ปรับทึบให้ดูชัด
    GlassStroke = Color3.fromRGB(80, 80, 80),       -- เส้นขอบสีเทา (ไม่เอาน้ำเงินแล้ว)
    
    -- Text (ขาวชัดเจน)
    TextWhite = Color3.fromRGB(255, 255, 255),      -- ขาวจั๊วะ
    TextGray = Color3.fromRGB(200, 200, 200),       -- เทาสว่าง
    TextDim = Color3.fromRGB(150, 150, 150),        -- เทาหม่น
    
    -- Buttons (ปุ่มปกติเป็นสีเทา ปุ่มกดแล้วค่อยเป็นสีฟ้า)
    BtnDefault = Color3.fromRGB(50, 50, 50),        -- ปุ่มสีเทาเข้ม
    BtnHover = Color3.fromRGB(70, 70, 70),          -- เมาส์ชี้แล้วสว่างขึ้น
    BtnSelected = Color3.fromRGB(60, 60, 60),       -- ปุ่มที่ถูกเลือก
    
    BtnMainTab = Color3.fromRGB(40, 40, 40),        -- ปุ่ม Tab สีเทา
    BtnMainTabSelected = Color3.fromRGB(60, 120, 200), -- Tab ที่เลือก (ให้มีสีฟ้าหน่อยจะได้รู้ว่าอยู่หน้าไหน)
    
    BtnDupe = Color3.fromRGB(60, 120, 200),         -- ปุ่ม Dupe สีฟ้า
    BtnDisabled = Color3.fromRGB(30, 30, 30),       -- ปุ่มที่กดไม่ได้ (สีมืดๆ)
    TextDisabled = Color3.fromRGB(100, 100, 100),   
    
    -- Status Colors (คงเดิมเพราะเป็นสีมาตรฐาน)
    Success = Color3.fromRGB(80, 200, 120),         -- เขียว
    Fail = Color3.fromRGB(240, 80, 80),             -- แดง
    Warning = Color3.fromRGB(240, 200, 60),         -- เหลือง
    Info = Color3.fromRGB(100, 180, 255),           -- ฟ้าข้อมูล
    
    -- Item Status
    ItemInv = Color3.fromRGB(80, 200, 120),         -- เขียว (มีของ)
    ItemEquip = Color3.fromRGB(240, 80, 80),        -- แดง (ใส่อยู่)
    PlayerBtn = Color3.fromRGB(60, 60, 60),         -- ปุ่มผู้เล่นสีเทา
    DupeReady = Color3.fromRGB(80, 200, 120),       -- เขียว (พร้อม)
    
    -- Cards (ตัวสำคัญ! เปลี่ยนเป็นสีเทาทึบ ของจะได้ดูเด่น)
    CardBg = Color3.fromRGB(45, 45, 45),            -- พื้นหลังการ์ดสีเทา (ไม่ใช่สีน้ำเงินจางๆ)
    CardStrokeSelected = Color3.fromRGB(255, 255, 255), -- ขอบสีขาวเวลาเลือก
    CardStrokeLocked = Color3.fromRGB(240, 80, 80),    -- ขอบแดงเวลาล็อค
    CrateSelected = Color3.fromRGB(255, 255, 255),
    
    -- Accent Colors
    StarColor = Color3.fromRGB(255, 220, 100),
    AccentPurple = Color3.fromRGB(160, 100, 220),
    AccentBlue = Color3.fromRGB(60, 120, 200),      -- ฟ้ามาตรฐาน (ไม่เข้มจนมืด)
    AccentGreen = Color3.fromRGB(80, 200, 120),
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
