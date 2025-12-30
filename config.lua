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
    -- Base Colors (Blue-Black)
    MainBg = Color3.fromRGB(12, 18, 28),            -- Dark Blue-Black
    MainTransparency = 0.05,
    PanelBg = Color3.fromRGB(18, 24, 35),           -- Dark Blue Panel
    PanelTransparency = 0.2,
    
    -- Glass Effect (Blue)
    GlassBg = Color3.fromRGB(20, 28, 40),           -- Blue Glass
    GlassTransparency = 0.1,
    GlassStroke = Color3.fromRGB(40, 60, 90),       -- Blue Border
    
    -- Text (White-Blue)
    TextWhite = Color3.fromRGB(248, 250, 255),      -- Pure White
    TextGray = Color3.fromRGB(160, 175, 195),       -- Light Blue-Grey
    TextDim = Color3.fromRGB(115, 130, 150),        -- Dim Blue-Grey
    
    -- Buttons (Blue-White Gradient)
    BtnDefault = Color3.fromRGB(28, 38, 55),        -- Dark Blue Button
    BtnHover = Color3.fromRGB(35, 50, 70),          -- Hover Blue
    BtnSelected = Color3.fromRGB(45, 85, 155),      -- Selected Blue
    BtnMainTab = Color3.fromRGB(22, 32, 48),        -- Tab Button
    BtnMainTabSelected = Color3.fromRGB(45, 85, 155), -- Selected Tab
    BtnDupe = Color3.fromRGB(50, 95, 165),          -- Dupe Blue
    BtnDisabled = Color3.fromRGB(22, 28, 38),       -- Disabled Dark
    TextDisabled = Color3.fromRGB(80, 90, 105),     -- Disabled Text
    
    -- Status Colors (Keep Red/Green for Important Status!)
    Success = Color3.fromRGB(60, 110, 180),         -- Blue Success
    Fail = Color3.fromRGB(220, 75, 75),             -- RED (Keep for errors!)
    Warning = Color3.fromRGB(240, 180, 50),         -- Yellow Warning
    Info = Color3.fromRGB(60, 105, 175),            -- Info Blue
    
    -- Special (Keep Green/Red for Equipment Status)
    ItemInv = Color3.fromRGB(65, 180, 130),         -- GREEN (Has item)
    ItemEquip = Color3.fromRGB(220, 75, 75),        -- RED (Equipped/Locked)
    PlayerBtn = Color3.fromRGB(55, 110, 185),       -- Player Blue
    DupeReady = Color3.fromRGB(65, 180, 130),       -- GREEN (Ready)
    
    -- Cards (Blue)
    CardBg = Color3.fromRGB(20, 30, 45),            -- Card Background
    CardStrokeSelected = Color3.fromRGB(80, 160, 255), -- BRIGHT BLUE Border (Selected!)
    CardStrokeLocked = Color3.fromRGB(220, 75, 75),    -- RED Border (Locked!)
    CrateSelected = Color3.fromRGB(80, 160, 255),      -- BRIGHT BLUE (Selected crate border)
    
    -- Accent Colors (Blue-White Palette)
    StarColor = Color3.fromRGB(255, 220, 100),      -- Gold Star
    AccentPurple = Color3.fromRGB(50, 90, 165),     -- Deep Blue
    AccentBlue = Color3.fromRGB(55, 110, 185),      -- Bright Blue
    AccentGreen = Color3.fromRGB(65, 180, 130),     -- GREEN (Keep!)
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
