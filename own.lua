--// VOIDWARE UI - FULL VERSION
--// Optimized for Android / Touch Screen
--// Features: Search, Scroll, Drag, Resize, Permanent Tab Highlight

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MyUILib = {}
MyUILib.__index = MyUILib

-- 🧩 Load Lucide Icons
local Lucide = nil
pcall(function()
    Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/refs/heads/master/lib/Icons.luau"))()
end)

-- 🎨 THEME SETTINGS
MyUILib.Theme = {
    WindowBg = Color3.fromRGB(216, 128, 255),
    SidebarBg = Color3.fromRGB(90, 30, 130),
    ContentBg = Color3.fromRGB(110, 40, 150),
    SearchBg = Color3.fromRGB(70, 25, 110),
    TabSelected = Color3.fromRGB(150, 60, 210), -- Kulay ng napiling tab
    UserProfileBg = Color3.fromRGB(80, 28, 120),
    ScrollbarColor = Color3.fromRGB(180, 100, 220),
    IconColor = Color3.new(1, 1, 1),
    IconTransparency = 0.2,
    TextColor = Color3.new(1, 1, 1),
    HeaderIcon = "user-round",
    HeaderTitle = "Voidware",
    HeaderSubtitle = "discord.gg/voidware",
    HeaderFont = Enum.Font.GothamBold,
    HeaderTextSize = 15,
    HeaderSubtitleSize = 11,
    HeaderTextTransparency = 0.2,
    HeaderSubtitleTransparency = 0.35,
    HeaderIconSize = 25,
    CornerRadius = UDim.new(0, 10),
    NormalWindowSize = UDim2.new(0, 450, 0, 530),
    NormalWindowPos = UDim2.new(0.5, -225, 0.5, -265), -- ✅ Fixed position for 450x530
    MinimizedBarSize = UDim2.new(0, 200, 0, 33),
    MinimizedBarPos = UDim2.new(0.5, -120, 0, 12),
    HeaderHeight = 36,
    SidebarWidth = 160,
    UserProfileHeight = 60,
    MinWindowWidth = 420,
    MinWindowHeight = 280,
    TweenTime = 0.22, -- Bilis ng animation
    TweenStyle = Enum.EasingStyle.Quad,
    TweenDirection = Enum.EasingDirection.Out,
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
    local Window = Base.new("Frame", {
        BackgroundColor3 = self.Theme.WindowBg,
        BackgroundTransparency = self.Theme.NormalTransparency,
        Size = self.Theme.NormalWindowSize,
        Position = self.Theme.NormalWindowPos,
        ClipsDescendants = true,
        ZIndex = 10
    })

    Instance.new("UICorner", Window.Instance).CornerRadius = self.Theme.CornerRadius
    local Border = Instance.new("UIStroke", Window.Instance)
    Border.Color = Color3.new(0, 0, 0)
    Border.Transparency = 0.8
    Border.Thickness = 1

    -- 📌 HEADER / DRAG AREA
    local DragArea = Base.new("Frame", {
        Size = UDim2.new(1, 0, 0, self.Theme.HeaderHeight),
        BackgroundTransparency = 1,
        Parent = Window.Instance
    })

    -- 📝 HEADER CONTENT
    local HeaderContainer = Base.new("Frame", {
        Size = UDim2.new(0, 260, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Parent = DragArea.Instance
    })

    -- 🖼️ HEADER ICON
    local HeaderIcon = Base.new("ImageLabel", {
        Size = UDim2.new(0, self.Theme.HeaderIconSize, 0, self.Theme.HeaderIconSize),
        Position = UDim2.new(0, 0, 0.5, -self.Theme.HeaderIconSize/2),
        BackgroundTransparency = 1,
        ImageColor3 = self.Theme.IconColor,
        ImageTransparency = self.Theme.IconTransparency,
        Parent = HeaderContainer.Instance
    })

    if Lucide and Lucide["48px"][self.Theme.HeaderIcon] then
        HeaderIcon.Instance.Image = "rbxassetid://" .. Lucide["48px"][self.Theme.HeaderIcon][1]
        HeaderIcon.Instance.ImageRectSize = Vector2.new(unpack(Lucide["48px"][self.Theme.HeaderIcon][2]))
        HeaderIcon.Instance.ImageRectOffset = Vector2.new(unpack(Lucide["48px"][self.Theme.HeaderIcon][3]))
    else
        Base.new("TextLabel", {
            Text = "●",
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            TextColor3 = self.Theme.IconColor,
            TextTransparency = self.Theme.IconTransparency,
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Parent = HeaderIcon.Instance
        })
    end

    -- 📄 TITLE + SUBTITLE
    local TextContainer = Base.new("Frame", {
        Size = UDim2.new(0, 220, 1, 0),
        Position = UDim2.new(0, self.Theme.HeaderIconSize + 10, 0, 4),
        BackgroundTransparency = 1,
        Parent = HeaderContainer.Instance
    })

    Base.new("TextLabel", {
        Text = self.Theme.HeaderTitle,
        Font = self.Theme.HeaderFont,
        TextSize = self.Theme.HeaderTextSize,
        TextColor3 = self.Theme.TextColor,
        TextTransparency = self.Theme.HeaderTextTransparency,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TextContainer.Instance
    })

    Base.new("TextLabel", {
        Text = self.Theme.HeaderSubtitle,
        Font = Enum.Font.Gotham,
        TextSize = self.Theme.HeaderSubtitleSize,
        TextColor3 = self.Theme.TextColor,
        TextTransparency = self.Theme.HeaderSubtitleTransparency,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0, 16),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TextContainer.Instance
    })

    -- 🎛️ CONTROL BUTTONS
    local Controls = Base.new("Frame", {
        Size = UDim2.new(0, 88, 0, 28),
        Position = UDim2.new(1, -96, 0, 4),
        BackgroundTransparency = 1,
        Parent = DragArea.Instance
    })

    local function CreateBtn(iconName, posX, parent)
        local Btn = Base.new("TextButton", {
            Text = "",
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(0, posX, 0, 0),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Parent = parent or Controls.Instance
        })

        local Icon = Base.new("ImageLabel", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0.5, -7, 0.5, -7),
            BackgroundTransparency = 1,
            ImageColor3 = self.Theme.IconColor,
            ImageTransparency = self.Theme.IconTransparency,
            Parent = Btn.Instance
        })

        if Lucide and Lucide["48px"][iconName] then
            Icon.Instance.Image = "rbxassetid://" .. Lucide["48px"][iconName][1]
            Icon.Instance.ImageRectSize = Vector2.new(unpack(Lucide["48px"][iconName][2]))
            Icon.Instance.ImageRectOffset = Vector2.new(unpack(Lucide["48px"][iconName][3]))
        else
            local fallback = { minus = "—", maximize = "⛶", x = "✕" }
            Base.new("TextLabel", {
                Text = fallback[iconName] or "?",
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextColor3 = self.Theme.IconColor,
                TextTransparency = self.Theme.IconTransparency,
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Parent = Icon.Instance
            })
        end

        return Btn
    end

    local MinimizeBtn = CreateBtn("minus", 0)
    local MaximizeBtn = CreateBtn("maximize", 32)
    local CloseBtn = CreateBtn("x", 64)

    -- 📄 MAIN CONTAINER
    local MainContainer = Base.new("Frame", {
        Size = UDim2.new(1, 0, 1, -self.Theme.HeaderHeight),
        Position = UDim2.new(0, 0, 0, self.Theme.HeaderHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = Window.Instance
    })

    -- 📌 LEFT SIDEBAR
    local Sidebar = Base.new("Frame", {
        Size = UDim2.new(0, self.Theme.SidebarWidth, 1, 0),
        BackgroundColor3 = self.Theme.SidebarBg,
        BackgroundTransparency = 0.1,
        Parent = MainContainer.Instance
    })
    Instance.new("UICorner", Sidebar.Instance).CornerRadius = self.Theme.CornerRadius

    -- ✅ SEARCH BAR
    local SearchBox = Base.new("Frame", {
        Size = UDim2.new(1, -12, 0, 36),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = self.Theme.SearchBg,
        BackgroundTransparency = 0.15,
        Parent = Sidebar.Instance
    })
    Instance.new("UICorner", SearchBox.Instance).CornerRadius = UDim.new(0, 6)

    local SearchIcon = Base.new("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        BackgroundTransparency = 1,
        ImageColor3 = self.Theme.TextColor,
        ImageTransparency = 0.3,
        Parent = SearchBox.Instance
    })
    if Lucide and Lucide["48px"]["search"] then
        SearchIcon.Instance.Image = "rbxassetid://" .. Lucide["48px"]["search"][1]
        SearchIcon.Instance.ImageRectSize = Vector2.new(unpack(Lucide["48px"]["search"][2]))
        SearchIcon.Instance.ImageRectOffset = Vector2.new(unpack(Lucide["48px"]["search"][3]))
    end

    local SearchInput = Base.new("TextBox", {
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search tabs...",
        PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = self.Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = SearchBox.Instance
    })

    -- ✅ SCROLL FRAME FOR TABS (MAY SCROLL PA RIN)
    local SidebarScroll = Base.new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -48 - self.Theme.UserProfileHeight),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Theme.ScrollbarColor,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
        Parent = Sidebar.Instance
    })
    SidebarScroll.Instance.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- ✅ AUTO USER PROFILE SECTION
    local UserProfile = Base.new("Frame", {
        Size = UDim2.new(1, 0, 0, self.Theme.UserProfileHeight),
        Position = UDim2.new(0, 0, 1, -self.Theme.UserProfileHeight),
        BackgroundColor3 = self.Theme.UserProfileBg,
        BackgroundTransparency = 0.1,
        Parent = Sidebar.Instance
    })
    Instance.new("UICorner", UserProfile.Instance).CornerRadius = UDim.new(0, 6)

    -- User Avatar
    local UserAvatar = Base.new("ImageLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 8, 0.5, -20),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.new(0,0,0),
        Parent = UserProfile.Instance
    })
    Instance.new("UICorner", UserAvatar.Instance).CornerRadius = UDim.new(0, 8)

    -- Auto-load avatar thumbnail
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local success, avatarUrl = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, thumbType, thumbSize)
    if success then
        UserAvatar.Instance.Image = avatarUrl
    else
        UserAvatar.Instance.Image = "rbxassetid://6034220868"
    end

    -- Username & Display Name
    local UserInfoContainer = Base.new("Frame", {
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.new(0, 52, 0, 0),
        BackgroundTransparency = 1,
        Parent = UserProfile.Instance
    })

    Base.new("TextLabel", {
        Text = LocalPlayer.DisplayName or LocalPlayer.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = self.Theme.TextColor,
        TextTransparency = 0.15,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = UserInfoContainer.Instance
    })

    Base.new("TextLabel", {
        Text = "@" .. LocalPlayer.Name,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = self.Theme.TextColor,
        TextTransparency = 0.35,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = UserInfoContainer.Instance
    })

    -- 📌 RIGHT CONTENT AREA (WALANG SCROLL)
    local ContentScroll = Base.new("Frame", {
        Size = UDim2.new(1, -self.Theme.SidebarWidth, 1, 0),
        Position = UDim2.new(0, self.Theme.SidebarWidth, 0, 0),
        BackgroundColor3 = self.Theme.ContentBg,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = MainContainer.Instance
    })
    Instance.new("UICorner", ContentScroll.Instance).CornerRadius = self.Theme.CornerRadius

    -- 📋 TAB LIST
    local Tabs = {
        {Name = "Search", Icon = "search"},
        {Name = "Information", Icon = "info"},
        {Name = "Fun", Icon = "star"},
        {Name = "Main", Icon = "code-xml"},
        {Name = "Auto", Icon = "refresh-cw"},
        {Name = "Update Focused", Icon = "crosshair"},
        {Name = "Day Farm", Icon = "sun"},
        {Name = "Settings", Icon = "settings"},
        {Name = "Credits", Icon = "user-check"},
        {Name = "Debug", Icon = "bug"}
    }

    local TabButtons = {}
    local CurrentTab = nil
    local TweenInfo = TweenInfo.new(self.Theme.TweenTime, self.Theme.TweenStyle, self.Theme.TweenDirection)

    -- Create each tab button
    for i, tabData in ipairs(Tabs) do
        local TabBtn = Base.new("TextButton", {
            Size = UDim2.new(1, -12, 0, 36),
            Position = UDim2.new(0, 6, 0, (i-1)*42),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            Visible = true,
            Parent = SidebarScroll.Instance
        })
        Instance.new("UICorner", TabBtn.Instance).CornerRadius = UDim.new(0, 6)

        local TabIcon = Base.new("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 10, 0.5, -9),
            BackgroundTransparency = 1,
            ImageColor3 = self.Theme.TextColor,
            ImageTransparency = 0.2,
            Parent = TabBtn.Instance
        })
        if Lucide and Lucide["48px"][tabData.Icon] then
            TabIcon.Instance.Image = "rbxassetid://" .. Lucide["48px"][tabData.Icon][1]
            TabIcon.Instance.ImageRectSize = Vector2.new(unpack(Lucide["48px"][tabData.Icon][2]))
            TabIcon.Instance.ImageRectOffset = Vector2.new(unpack(Lucide["48px"][tabData.Icon][3]))
        end

        Base.new("TextLabel", {
            Text = tabData.Name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.2,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 36, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn.Instance
        })

        -- ✅ PININDOT ANG TAB - MAY PERMANENTENG SHADE
        TabBtn.Instance.Activated:Connect(function()
            -- Ibalik lahat sa normal
            for _, btn in ipairs(TabButtons) do
                TweenService:Create(btn.Button, TweenInfo, {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = self.Theme.SidebarBg
                }):Play()
            end

            -- Ilagay ang shade sa napiling tab (hindi mawawala)
            TweenService:Create(TabBtn.Instance, TweenInfo, {
                BackgroundTransparency = 0.6, -- Mas mababa = mas madilim
                BackgroundColor3 = self.Theme.TabSelected
            }):Play()

            CurrentTab = tabData.Name
            ContentScroll.Instance:ClearAllChildren()
            Base.new("TextLabel", {
                Text = "Content: "..CurrentTab,
                Font = Enum.Font.GothamBold,
                TextSize = 18,
                TextColor3 = self.Theme.TextColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 10),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ContentScroll.Instance
            })
        end)

        table.insert(TabButtons, {Button = TabBtn.Instance, Name = tabData.Name})
    end

    -- ✅ Update scroll height para sa tabs
    SidebarScroll.Instance.CanvasSize = UDim2.new(0, 0, 0, #Tabs * 42)

    -- ✅ Search filter
    SearchInput.Instance:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchInput.Instance.Text:lower()
        local offset = 0
        local visibleCount = 0

        for _, tab in ipairs(TabButtons) do
            if tab.Name:lower():find(searchText) then
                tab.Button.Visible = true
                tab.Button.Position = UDim2.new(0, 6, 0, offset)
                offset = offset + 42
                visibleCount = visibleCount + 1
            else
                tab.Button.Visible = false
            end
        end

        SidebarScroll.Instance.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 42)
    end)

    -- ✅ Unang tab ang naka-highlight sa simula
    if #TabButtons > 0 then
        TabButtons[1].Button.BackgroundTransparency = 0.6
        TabButtons[1].Button.BackgroundColor3 = self.Theme.TabSelected
    end

    -- 📌 MINIMIZE / RESTORE ✅ FIXED NOW
    local IsMinimized = false
    local IsMaximized = false
    local SavedSize, SavedPos -- ✅ Save position/size before minimize

    MinimizeBtn.Instance.Activated:Connect(function()
        if not IsMinimized then
            -- Save current state
            SavedSize = Window.Instance.Size
            SavedPos = Window.Instance.Position

            TweenService:Create(Window.Instance, TweenInfo, {
                Size = self.Theme.MinimizedBarSize,
                Position = self.Theme.MinimizedBarPos,
                BackgroundTransparency = self.Theme.MinimizedTransparency
            }):Play()

            task.wait(self.Theme.TweenTime / 2)
            MainContainer.Instance.Visible = false
            MinimizeBtn.Instance.Visible = false
            CloseBtn.Instance.Visible = false
            MaximizeBtn.Instance.Position = UDim2.new(1, -32, 0, 0)
            IsMinimized = true
        end
    end)

    MaximizeBtn.Instance.Activated:Connect(function()
        if IsMinimized then
            MainContainer.Instance.Visible = true
            MinimizeBtn.Instance.Visible = true
            CloseBtn.Instance.Visible = true
            MaximizeBtn.Instance.Position = UDim2.new(0, 32, 0, 0)

            -- Restore to saved position/size
            TweenService:Create(Window.Instance, TweenInfo, {
                Size = SavedSize or self.Theme.NormalWindowSize,
                Position = SavedPos or self.Theme.NormalWindowPos,
                BackgroundTransparency = self.Theme.NormalTransparency
            }):Play()
            IsMinimized = false
        else
            if not IsMaximized then
                -- Save before fullscreen
                SavedSize = Window.Instance.Size
                SavedPos = Window.Instance.Position
                TweenService:Create(Window.Instance, TweenInfo, {
                    Size = UDim2.new(0.92, 0, 0.88, 0),
                    Position = UDim2.new(0.04, 0, 0, 0)
                }):Play()
                IsMaximized = true
            else
                TweenService:Create(Window.Instance, TweenInfo, {
                    Size = SavedSize or self.Theme.NormalWindowSize,
                    Position = SavedPos or self.Theme.NormalWindowPos
                }):Play()
                IsMaximized = false
            end
        end
    end)

    CloseBtn.Instance.Activated:Connect(function()
        Window.Instance:Destroy()
    end)

    -- 🖱️ DRAG LOGIC (Gumagana sa touch screen)
    local UIS = game:GetService("UserInputService")
    local Dragging = false
    local StartPos, StartInputPos

    DragArea.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local cPos = Controls.Instance.AbsolutePosition
            local cSize = Controls.Instance.AbsoluteSize

            local overControls =
                mousePos.X >= cPos.X and mousePos.X <= cPos.X + cSize.X and
                mousePos.Y >= cPos.Y and mousePos.Y <= cPos.Y + cSize.Y

            if not overControls then
                Dragging = true
                StartPos = Window.Instance.Position
                StartInputPos = Vector2.new(input.Position.X, input.Position.Y)

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not Dragging then return end
        if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local Delta = Vector2.new(input.Position.X, input.Position.Y) - StartInputPos
        Window.Instance.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
    end)

    -- ✅ RESIZE LOGIC
    local ResizeGrip = Base.new("Frame", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 11,
        Parent = Window.Instance
    })

    local Resizing = false
    local StartSize

    ResizeGrip.Instance.InputBegan:Connect(function(input)
        if IsMinimized then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = true
            StartSize = Vector2.new(Window.Instance.Size.X.Offset, Window.Instance.Size.Y.Offset)
            StartInputPos = Vector2.new(input.Position.X, input.Position.Y)

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Resizing = false
                    self.Theme.NormalWindowSize = Window.Instance.Size
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not Resizing or IsMinimized then return end
        if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local Delta = Vector2.new(input.Position.X, input.Position.Y) - StartInputPos
        local NewWidth = math.max(self.Theme.MinWindowWidth, StartSize.X + Delta.X)
        local NewHeight = math.max(self.Theme.MinWindowHeight, StartSize.Y + Delta.Y)

        Window.Instance.Size = UDim2.new(0, NewWidth, 0, NewHeight)
    end)

    Window.ContentArea = ContentScroll.Instance
    return Window
end

-- 🚀 INITIALIZE UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidwareUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Window = MyUILib:CreateWindow()
Window.Instance.Parent = ScreenGui

return MyUILib
