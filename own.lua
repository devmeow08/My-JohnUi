--[[
    Voidware UI Library
    ✅ Optimized for ANDROID / Touch Screen
    ✅ Fully working: Drag, Resize, Scroll, Search
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MyUILib = {}
MyUILib.__index = MyUILib

-- 🧩 Load Icons
local Lucide = nil
pcall(function()
    Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/refs/heads/master/lib/Icons.luau"))()
end)

-- 🎨 SETTINGS
MyUILib.Theme = {
    WindowBg = Color3.fromRGB(216, 128, 255),
    SidebarBg = Color3.fromRGB(90, 30, 130),
    ContentBg = Color3.fromRGB(110, 40, 150),
    SearchBg = Color3.fromRGB(70, 25, 110),
    TabHover = Color3.fromRGB(130, 50, 180),
    TabSelected = Color3.fromRGB(150, 60, 210),
    ScrollbarColor = Color3.fromRGB(180, 100, 220),
    ResizeGripColor = Color3.new(1, 1, 1),
    IconColor = Color3.new(1, 1, 1),
    TextColor = Color3.new(1, 1, 1),
    HeaderTitle = "Voidware",
    HeaderSubtitle = "discord.gg/voidware",
    HeaderFont = Enum.Font.GothamBold,
    HeaderTextSize = 16,
    HeaderSubtitleSize = 12,
    CornerRadius = UDim.new(0, 10),

    NormalWindowSize = UDim2.new(0, 600, 0, 400),
    NormalWindowPos = UDim2.new(0.5, -300, 0.5, -200),
    MinimizedBarSize = UDim2.new(0, 220, 0, 38),
    MinimizedBarPos = UDim2.new(0.5, -110, 0, 20),
    HeaderHeight = 38,
    SidebarWidth = 150,
    MinWindowWidth = 380,
    MinWindowHeight = 260,
    ResizeGripSize = 36, -- Mas malaki para madaling pindutin sa touch

    TweenTime = 0.25,
    NormalTransparency = 0,
    MinimizedTransparency = 0.4
}

-- 🧱 BASE CLASS
local Base = {}
Base.__index = Base
function Base.new(class, props)
    local self = setmetatable({}, Base)
    self.Instance = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            self.Instance[k] = v
        end
    end
    return self
end

-- 🪟 CREATE WINDOW
function MyUILib:CreateWindow()
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VoidwareUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main Window
    local Window = Base.new("Frame", {
        BackgroundColor3 = self.Theme.WindowBg,
        BackgroundTransparency = self.Theme.NormalTransparency,
        Size = self.Theme.NormalWindowSize,
        Position = self.Theme.NormalWindowPos,
        ClipsDescendants = true,
        Visible = true,
        ZIndex = 10,
        Parent = ScreenGui
    })
    Instance.new("UICorner", Window.Instance).CornerRadius = self.Theme.CornerRadius
    Instance.new("UIStroke", Window.Instance).Color = Color3.new(0,0,0)

    -- 📌 DRAG AREA
    local DragArea = Base.new("Frame", {
        Size = UDim2.new(1, 0, 0, self.Theme.HeaderHeight),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 20,
        Parent = Window.Instance
    })

    -- Header Text
    Base.new("TextLabel", {
        Text = self.Theme.HeaderTitle,
        Font = self.Theme.HeaderFont,
        TextSize = self.Theme.HeaderTextSize,
        TextColor3 = self.Theme.TextColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.new(0, 12, 0, 4),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DragArea.Instance
    })

    -- Control Buttons
    local Controls = Base.new("Frame", {
        Size = UDim2.new(0, 90, 0, 30),
        Position = UDim2.new(1, -96, 0, 4),
        BackgroundTransparency = 1,
        ZIndex = 25,
        Parent = DragArea.Instance
    })

    local function CreateBtn(txt, xPos)
        local Btn = Base.new("TextButton", {
            Text = txt,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = self.Theme.TextColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, xPos, 0, 0),
            ZIndex = 26,
            Parent = Controls.Instance
        })
        return Btn
    end

    local MinBtn = CreateBtn("—", 0)
    local MaxBtn = CreateBtn("□", 30)
    local CloseBtn = CreateBtn("✕", 60)

    -- 📄 MAIN CONTENT
    local MainContainer = Base.new("Frame", {
        Size = UDim2.new(1, 0, 1, -self.Theme.HeaderHeight),
        Position = UDim2.new(0, 0, 0, self.Theme.HeaderHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = Window.Instance
    })

    -- 📌 SIDEBAR
    local Sidebar = Base.new("Frame", {
        Size = UDim2.new(0, self.Theme.SidebarWidth, 1, 0),
        BackgroundColor3 = self.Theme.SidebarBg,
        BackgroundTransparency = 0.1,
        Parent = MainContainer.Instance
    })
    Instance.new("UICorner", Sidebar.Instance).CornerRadius = self.Theme.CornerRadius

    -- Search Bar
    local SearchBox = Base.new("Frame", {
        Size = UDim2.new(1, -12, 0, 40),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = self.Theme.SearchBg,
        BackgroundTransparency = 0.15,
        Parent = Sidebar.Instance
    })
    Instance.new("UICorner", SearchBox.Instance).CornerRadius = UDim.new(0, 6)

    local SearchInput = Base.new("TextBox", {
        Text = "",
        PlaceholderText = "Search...",
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = self.Theme.TextColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        ClearTextOnFocus = false,
        Parent = SearchBox.Instance
    })

    -- Sidebar Scroll
    local SidebarScroll = Base.new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -52),
        Position = UDim2.new(0, 0, 0, 52),
        BackgroundTransparency = 1,
        ScrollBarThickness = 8, -- Mas makapal para sa touch
        ScrollBarImageColor3 = self.Theme.ScrollbarColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar.Instance
    })
    Instance.new("UIPadding", SidebarScroll.Instance).Padding = UDim.new(0, 6)

    -- Content Area
    local ContentScroll = Base.new("ScrollingFrame", {
        Size = UDim2.new(1, -self.Theme.SidebarWidth, 1, 0),
        Position = UDim2.new(0, self.Theme.SidebarWidth, 0, 0),
        BackgroundColor3 = self.Theme.ContentBg,
        BackgroundTransparency = 0.1,
        ScrollBarThickness = 8,
        ScrollBarImageColor3 = self.Theme.ScrollbarColor,
        CanvasSize = UDim2.new(1, 0, 0, 500),
        Parent = MainContainer.Instance
    })
    Instance.new("UICorner", ContentScroll.Instance).CornerRadius = self.Theme.CornerRadius

    -- 📋 TABS
    local Tabs = {
        "Information", "Main", "Auto", "Farm", "Settings", "Credits", "Debug"
    }
    local TabButtons = {}

    for i, name in ipairs(Tabs) do
        local TabBtn = Base.new("TextButton", {
            Text = name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            TextColor3 = self.Theme.TextColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -12, 0, 42),
            Position = UDim2.new(0, 6, 0, (i-1)*48),
            Parent = SidebarScroll.Instance
        })
        Instance.new("UICorner", TabBtn.Instance).CornerRadius = UDim.new(0, 6)

        TabBtn.Instance.Activated:Connect(function()
            for _, btn in ipairs(TabButtons) do btn.BackgroundTransparency = 1 end
            TabBtn.Instance.BackgroundTransparency = 0.7
            TabBtn.Instance.BackgroundColor3 = self.Theme.TabSelected

            ContentScroll.Instance:ClearAllChildren()
            Base.new("TextLabel", {
                Text = "Tab: "..name,
                Font = Enum.Font.GothamBold,
                TextSize = 18,
                TextColor3 = self.Theme.TextColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 10),
                Parent = ContentScroll.Instance
            })
        end)

        TabBtn.Instance.MouseEnter:Connect(function()
            if TabBtn.Instance.BackgroundTransparency ~= 0.7 then
                TabBtn.Instance.BackgroundTransparency = 0.85
                TabBtn.Instance.BackgroundColor3 = self.Theme.TabHover
            end
        end)
        TabBtn.Instance.MouseLeave:Connect(function()
            if TabBtn.Instance.BackgroundTransparency ~= 0.7 then
                TabBtn.Instance.BackgroundTransparency = 1
            end
        end)

        table.insert(TabButtons, TabBtn.Instance)
    end

    SidebarScroll.Instance.CanvasSize = UDim2.new(0, 0, 0, #Tabs * 48)

    -- Search Function
    SearchInput.Instance:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = SearchInput.Instance.Text:lower()
        local offset = 0
        for i, btn in ipairs(TabButtons) do
            local visible = btn.Text:lower():find(txt) ~= nil
            btn.Visible = visible
            if visible then
                btn.Position = UDim2.new(0, 6, 0, offset)
                offset += 48
            end
        end
        SidebarScroll.Instance.CanvasSize = UDim2.new(0, 0, 0, offset)
    end)

    -- ✅ DRAG LOGIC (TOUCH SUPPORT)
    local Dragging = false
    local StartPos, StartInputPos

    DragArea.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = Vector2.new(input.Position.X, input.Position.Y)
            local cPos = Controls.Instance.AbsolutePosition
            local cSize = Controls.Instance.AbsoluteSize
            if not (pos.X >= cPos.X and pos.X <= cPos.X + cSize.X and pos.Y >= cPos.Y and pos.Y <= cPos.Y + cSize.Y) then
                Dragging = true
                StartPos = Window.Instance.Position
                StartInputPos = pos
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not Dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - StartInputPos
            Window.Instance.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function()
        Dragging = false
    end)

    -- ✅ RESIZE LOGIC (TOUCH FRIENDLY)
    local ResizeGrip = Base.new("TextButton", {
        Text = "╲╱",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = self.Theme.ResizeGripColor,
        BackgroundTransparency = 0.85,
        BackgroundColor3 = Color3.new(0.2,0.2,0.2),
        Size = UDim2.new(0, self.Theme.ResizeGripSize, 0, self.Theme.ResizeGripSize),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        ZIndex = 30,
        Parent = Window.Instance
    })
    Instance.new("UICorner", ResizeGrip.Instance).CornerRadius = UDim.new(0, 6)

    local Resizing = false
    local StartSize

    ResizeGrip.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = true
            StartSize = Vector2.new(Window.Instance.Size.X.Offset, Window.Instance.Size.Y.Offset)
            StartInputPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not Resizing then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - StartInputPos
            local newW = math.max(self.Theme.MinWindowWidth, StartSize.X + delta.X)
            local newH = math.max(self.Theme.MinWindowHeight, StartSize.Y + delta.Y)
            Window.Instance.Size = UDim2.new(0, newW, 0, newH)
        end
    end)

    UserInputService.InputEnded:Connect(function()
        Resizing = false
    end)

    -- Buttons Actions
    local IsMinimized = false
    MinBtn.Instance.Activated:Connect(function()
        if not IsMinimized then
            TweenService:Create(Window.Instance, TweenInfo.new(0.25), {
                Size = self.Theme.MinimizedBarSize,
                Position = self.Theme.MinimizedBarPos,
                BackgroundTransparency = self.Theme.MinimizedTransparency
            }):Play()
            MainContainer.Instance.Visible = false
            ResizeGrip.Instance.Visible = false
            IsMinimized = true
        end
    end)

    MaxBtn.Instance.Activated:Connect(function()
        if IsMinimized then
            TweenService:Create(Window.Instance, TweenInfo.new(0.25), {
                Size = self.Theme.NormalWindowSize,
                Position = self.Theme.NormalWindowPos,
                BackgroundTransparency = self.Theme.NormalTransparency
            }):Play()
            MainContainer.Instance.Visible = true
            ResizeGrip.Instance.Visible = true
            IsMinimized = false
        end
    end)

    CloseBtn.Instance.Activated:Connect(function()
        Window.Instance:Destroy()
    end)

    return Window
end

-- Run
MyUILib:CreateWindow()
return MyUILib
