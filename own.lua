--[[
BA5IC UI LIBRARY
Created by: Ikaw
Style: Similar to Orion / Rayfield / Kavo
Features: Window, Tabs, Sections, Buttons, Toggles, Sliders, Dropdowns, Textboxes, Notifications
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local BA5IC = {}
BA5IC.Theme = {
    WindowBg = Color3.fromRGB(90, 30, 130),
    SidebarBg = Color3.fromRGB(70, 25, 110),
    ContentBg = Color3.fromRGB(110, 40, 150),
    SectionBg = Color3.fromRGB(85, 32, 125),
    SearchBg = Color3.fromRGB(60, 20, 100),
    Selected = Color3.fromRGB(150, 60, 210),
    Hover = Color3.fromRGB(130, 50, 180),
    ToggleOn = Color3.fromRGB(60, 220, 100),
    ToggleOff = Color3.fromRGB(200, 60, 80),
    SliderBar = Color3.fromRGB(100, 40, 160),
    SliderFill = Color3.fromRGB(180, 100, 255),
    DropdownBg = Color3.fromRGB(75, 28, 115),
    InputBg = Color3.fromRGB(75, 28, 115),
    UserBg = Color3.fromRGB(80, 28, 120),
    Scroll = Color3.fromRGB(180, 100, 220),
    Text = Color3.new(1, 1, 1),
    TextMuted = Color3.fromRGB(200, 200, 200),
    Corner = UDim.new(0, 10),
    SmallCorner = UDim.new(0, 6),
    SidebarWidth = 160,
    HeaderHeight = 36,
    UserHeight = 60,
    MinW = 420,
    MinH = 280
}

-- Helper function para gumawa ng mga UI elements
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

-- 📢 NOTIFICATION SYSTEM
function BA5IC:Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "BA5IC",
            Text = text or "",
            Duration = duration,
            Button1 = "OK"
        })
    end)
end

-- 🪟 GUMAWA NG WINDOW
function BA5IC:MakeWindow(config)
    config = config or {}
    config.Name = config.Name or "BA5IC UI"
    config.SaveConfig = config.SaveConfig or false

    local ScreenGui = Create("ScreenGui", {
        Name = "BA5IC_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })

    local MainWindow = Create("Frame", {
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, -325, 0.5, -225),
        BackgroundColor3 = self.Theme.WindowBg,
        BackgroundTransparency = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = self.Theme.Corner, Parent = MainWindow})
    Create("UIStroke", {Color = Color3.new(0,0,0), Transparency = 0.8, Thickness = 1, Parent = MainWindow})

    -- Header / Drag Area
    local Header = Create("Frame", {
        Size = UDim2.new(1,0,0, self.Theme.HeaderHeight),
        BackgroundTransparency = 1,
        Parent = MainWindow
    })

    Create("TextLabel", {
        Text = config.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = self.Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 250, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })

    -- Control Buttons
    local Controls = Create("Frame", {
        Size = UDim2.new(0, 88, 0, 28),
        Position = UDim2.new(1, -96, 0, 4),
        BackgroundTransparency = 1,
        Parent = Header
    })

    local function MakeBtn(icon, x)
        local btn = Create("TextButton", {
            Size = UDim2.new(0,28,0,28),
            Position = UDim2.new(0,x,0,0),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Parent = Controls
        })
        Create("TextLabel", {
            Text = icon,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Parent = btn
        })
        return btn
    end

    local MinBtn = MakeBtn("—", 0)
    local MaxBtn = MakeBtn("⛶", 32)
    local CloseBtn = MakeBtn("✕", 64)

    -- Main Content
    local MainContent = Create("Frame", {
        Size = UDim2.new(1,0,1, -self.Theme.HeaderHeight),
        Position = UDim2.new(0,0,0, self.Theme.HeaderHeight),
        BackgroundTransparency = 1,
        Parent = MainWindow
    })

    -- Sidebar
    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, self.Theme.SidebarWidth, 1, 0),
        BackgroundColor3 = self.Theme.SidebarBg,
        BackgroundTransparency = 0.1,
        Parent = MainContent
    })
    Create("UICorner", {CornerRadius = self.Theme.Corner, Parent = Sidebar})

    -- Search Bar
    local SearchBox = Create("Frame", {
        Size = UDim2.new(1, -12, 0, 36),
        Position = UDim2.new(0,6,0,6),
        BackgroundColor3 = self.Theme.SearchBg,
        BackgroundTransparency = 0.15,
        Parent = Sidebar
    })
    Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = SearchBox})

    Create("TextLabel", {
        Text = "🔍",
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextColor3 = self.Theme.TextMuted,
        BackgroundTransparency = 1,
        Size = UDim2.new(0,20,1,0),
        Position = UDim2.new(0,8,0,0),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = SearchBox
    })

    local SearchInput = Create("TextBox", {
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0,32,0,0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search tabs...",
        PlaceholderColor3 = Color3.new(0.8,0.8,0.8),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = self.Theme.Text,
        ClearTextOnFocus = false,
        Parent = SearchBox
    })

    -- Sidebar Scroll
    local SidebarScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1,0,1, -48 - self.Theme.UserHeight),
        Position = UDim2.new(0,0,0,48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Theme.Scroll,
        Parent = Sidebar
    })
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6), Parent = SidebarScroll})

    -- User Profile
    local UserFrame = Create("Frame", {
        Size = UDim2.new(1,0,0, self.Theme.UserHeight),
        Position = UDim2.new(0,0,1, -self.Theme.UserHeight),
        BackgroundColor3 = self.Theme.UserBg,
        BackgroundTransparency = 0.1,
        Parent = Sidebar
    })
    Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = UserFrame})

    local Avatar = Create("ImageLabel", {
        Size = UDim2.new(0,40,0,40),
        Position = UDim2.new(0,8,0.5,-20),
        BackgroundColor3 = Color3.new(0,0,0),
        Parent = UserFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0,8), Parent = Avatar})

    pcall(function()
        Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    Create("TextLabel", {
        Text = LocalPlayer.DisplayName,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = self.Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 0, 20),
        Position = UDim2.new(0,52,0,8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = UserFrame
    })
    Create("TextLabel", {
        Text = "@"..LocalPlayer.Name,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = self.Theme.TextMuted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 0, 16),
        Position = UDim2.new(0,52,0,28),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = UserFrame
    })

    -- Content Area
    local ContentArea = Create("ScrollingFrame", {
        Size = UDim2.new(1, -self.Theme.SidebarWidth, 1, 0),
        Position = UDim2.new(0, self.Theme.SidebarWidth, 0, 0),
        BackgroundColor3 = self.Theme.ContentBg,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Theme.Scroll,
        CanvasSize = UDim2.new(1,0,0,0),
        Parent = MainContent
    })
    Create("UICorner", {CornerRadius = self.Theme.Corner, Parent = ContentArea})
    local ContentLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = ContentArea
    })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        Parent = ContentArea
    })
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentArea.CanvasSize = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Drag Function
    local Dragging, StartPos, StartMouse = false
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            StartPos = MainWindow.Position
            StartMouse = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - StartMouse
            MainWindow.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)
    Header.InputEnded:Connect(function() Dragging = false end)

    -- Minimize / Maximize / Close
    local IsMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        if not IsMinimized then
            TweenService:Create(MainWindow, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 240, 0, 36),
                Position = UDim2.new(0.5, -120, 0, 10)
            }):Play()
            MainContent.Visible = false
            IsMinimized = true
        else
            TweenService:Create(MainWindow, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 650, 0, 450),
                Position = UDim2.new(0.5, -325, 0.5, -225)
            }):Play()
            MainContent.Visible = true
            IsMinimized = false
        end
    end)
    CloseBtn.MouseButton1Click:Connect(function() MainWindow:Destroy() end)

    -- Tab Management
    local Tabs = {}
    local WindowAPI = {}

    -- 📑 GUMAWA NG TAB
    function WindowAPI:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        tabConfig.Name = tabConfig.Name or "New Tab"
        tabConfig.Icon = tabConfig.Icon or "•"

        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, -12, 0, 36),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Parent = SidebarScroll
        })
        Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = TabBtn})

        Create("TextLabel", {
            Text = tabConfig.Icon,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,22,1,0),
            Position = UDim2.new(0,8,0,0),
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = TabBtn
        })
        Create("TextLabel", {
            Text = tabConfig.Name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0,36,0,0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _,t in ipairs(Tabs) do t.Button.BackgroundTransparency = 1 end
            TabBtn.BackgroundTransparency = 0.7
            TabBtn.BackgroundColor3 = self.Theme.Selected
        end)

        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundTransparency ~= 0.7 then
                TabBtn.BackgroundTransparency = 0.85
                TabBtn.BackgroundColor3 = self.Theme.Hover
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundTransparency ~= 0.7 then
                TabBtn.BackgroundTransparency = 1
            end
        end)

        table.insert(Tabs, {Name = tabConfig.Name, Button = TabBtn})

        -- Tab Elements API
        local TabAPI = {}

        -- ➕ SECTION
        function TabAPI:AddSection(name)
            local Section = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = self.Theme.SectionBg,
                BackgroundTransparency = 0.15,
                Parent = ContentArea
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = Section})
            Create("TextLabel", {
                Text = name or "Section",
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            return Section
        end

        -- ➕ BUTTON
        function TabAPI:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            btnConfig.Name = btnConfig.Name or "Button"
            btnConfig.Callback = btnConfig.Callback or function() end

            local Btn = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = self.Theme.SidebarBg,
                BackgroundTransparency = 0.1,
                Parent = ContentArea
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = Btn})

            local Click = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = Btn
            })
            Create("TextLabel", {
                Text = btnConfig.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Click
            })

            Click.MouseButton1Click:Connect(btnConfig.Callback)
            return Btn
        end

        -- ➕ TOGGLE
        function TabAPI:AddToggle(togConfig)
            togConfig = togConfig or {}
            togConfig.Name = togConfig.Name or "Toggle"
            togConfig.Default = togConfig.Default or false
            togConfig.Callback = togConfig.Callback or function() end
            local State = togConfig.Default

            local TogFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = self.Theme.SidebarBg,
                BackgroundTransparency = 0.1,
                Parent = ContentArea
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = TogFrame})

            Create("TextLabel", {
                Text = togConfig.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TogFrame
            })

            local ToggleSwitch = Create("Frame", {
                Size = UDim2.new(0, 36, 0, 20),
                Position = UDim2.new(1, -44, 0.5, -10),
                BackgroundColor3 = State and self.Theme.ToggleOn or self.Theme.ToggleOff,
                Parent = TogFrame
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ToggleSwitch})

            local ToggleKnob = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.new(1,1,1),
                Parent = ToggleSwitch
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleKnob})

            local ClickArea = Create("TextButton", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Parent = TogFrame
            })

            local function UpdateToggle()
                ToggleSwitch.BackgroundColor3 = State and self.Theme.ToggleOn or self.Theme.ToggleOff
                TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {
                    Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }):Play()
                togConfig.Callback(State)
            end

            ClickArea.MouseButton1Click:Connect(function()
                State = not State
                UpdateToggle()
            end)

            return {
                Get = function() return State end,
                Set = function(val) State = val; UpdateToggle() end
            }
        end

        -- ➕ SLIDER
        function TabAPI:AddSlider(sldConfig)
            sldConfig = sldConfig or {}
            sldConfig.Name = sldConfig.Name or "Slider"
            sldConfig.Min = sldConfig.Min or 0
            sldConfig.Max = sldConfig.Max or 100
            sldConfig.Default = sldConfig.Default or sldConfig.Min
            sldConfig.Callback = sldConfig.Callback or function() end
            local Value = math.clamp(sldConfig.Default, sldConfig.Min, sldConfig.Max)

            local SliderFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = self.Theme.SidebarBg,
                BackgroundTransparency = 0.1,
                Parent = ContentArea
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = SliderFrame})

            local NameLabel = Create("TextLabel", {
                Text = sldConfig.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 0, 20),
                Position = UDim2.new(0, 8, 0, 4),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })

            local ValueLabel = Create("TextLabel", {
                Text = tostring(Value),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 30, 0, 20),
                Position = UDim2.new(1, -36, 0, 4),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })

            local SliderBar = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 8),
                Position = UDim2.new(0, 8, 0, 32),
                BackgroundColor3 = self.Theme.SliderBar,
                Parent = SliderFrame
            })
            Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = SliderBar})

            local SliderFill = Create("Frame", {
                Size = UDim2.new((Value - sldConfig.Min) / (sldConfig.Max - sldConfig.Min), 0, 1, 0),
                BackgroundColor3 = self.Theme.SliderFill,
                Parent = SliderBar
            })
            Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = SliderFill})

            local SliderKnob = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((Value - sldConfig.Min) / (sldConfig.Max - sldConfig.Min), -7, 0.5, -7),
                BackgroundColor3 = Color3.new(1,1,1),
                ZIndex = 2,
                Parent = SliderBar
            })
            Create("UICorner", {CornerRadius = UDim.new(0,7), Parent = SliderKnob})

            local Dragging = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not Dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                local relX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = math.floor(sldConfig.Min + relX * (sldConfig.Max - sldConfig.Min))
                SliderFill.Size = UDim2.new(relX, 0, 1, 0)
                SliderKnob.Position = UDim2.new(relX, -7, 0.5, -7)
                ValueLabel.Text = tostring(Value)
                sldConfig.Callback(Value)
            end)

            return {
                Get = function() return Value end,
                Set = function(v)
                    Value = math.clamp(v, sldConfig.Min, sldConfig.Max)
                    local rel = (Value - sldConfig.Min)/(sldConfig.Max - sldConfig.Min)
                    SliderFill.Size = UDim2.new(rel,0,1,0)
                    SliderKnob.Position = UDim2.new(rel, -7, 0.5, -7)
                    ValueLabel.Text = tostring(Value)
                end
            }
        end

        -- ➕ DROPDOWN
        function TabAPI:AddDropdown(dropConfig)
            dropConfig = dropConfig or {}
            dropConfig.Name = dropConfig.Name or "Dropdown"
            dropConfig.Options = dropConfig.Options or {}
            dropConfig.Default = dropConfig.Default or dropConfig.Options[1]
            dropConfig.Callback = dropConfig.Callback or function() end
            local Selected = dropConfig.Default
            local Open = false

            local DropFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = self.Theme.SidebarBg,
                BackgroundTransparency = 0.1,
                Parent = ContentArea
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = DropFrame})

            Create("TextLabel", {
                Text = dropConfig.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropFrame
            })

            local Arrow = Create("TextLabel", {
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0,20,1,0),
                Position = UDim2.new(1, -24, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = DropFrame
            })

            local OptionsFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = self.Theme.DropdownBg,
                BackgroundTransparency = 0.1,
                Visible = false,
                ClipsDescendants = true,
                Parent = DropFrame
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = OptionsFrame})
            local OptionsLayout = Create("UIListLayout", {Padding = UDim.new(0,2), Parent = OptionsFrame})

            local function BuildOptions()
                for _,c in ipairs(OptionsFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _,opt in ipairs(dropConfig.Options) do
                    local OptBtn = Create("TextButton", {
                        Size = UDim2.new(1, -8, 0, 32),
                        BackgroundColor3 = self.Theme.SidebarBg,
                        BackgroundTransparency = 0.1,
                        AutoButtonColor = false,
                        Text = opt,
                        Font = Enum.Font.GothamSemibold,
                        TextSize = 13,
                        TextColor3 = self.Theme.Text,
                        Parent = OptionsFrame
                    })
                    Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = OptBtn})
                    OptBtn.MouseButton1Click:Connect(function()
                        Selected = opt
                        DropFrame:FindFirstChild("NameLabel").Text = dropConfig.Name .. ": " .. Selected
                        Open = false
                        OptionsFrame.Visible = false
                        OptionsFrame.Size = UDim2.new(1,0,0,0)
                        Arrow.Text = "▼"
                        dropConfig.Callback(Selected)
                    end)
                end
                OptionsFrame.Size = UDim2.new(1,0,0, OptionsLayout.AbsoluteContentSize.Y + 8)
            end

            BuildOptions()
            DropFrame:FindFirstChild("NameLabel").Text = dropConfig.Name .. ": " .. Selected

            local ClickArea = Create("TextButton", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Parent = DropFrame
            })

            ClickArea.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    BuildOptions()
                    OptionsFrame.Visible = true
                    Arrow.Text = "▲"
                else
                    OptionsFrame.Visible = false
                    Arrow.Text = "▼"
                end
            end)

            return {
                Get = function() return Selected end,
                Set = function(val) Selected = val; DropFrame:FindFirstChild("NameLabel").Text = dropConfig.Name .. ": " .. val; dropConfig.Callback(val) end,
                Refresh = function(newOpts) dropConfig.Options = newOpts; BuildOptions() end
            }
        end

        -- ➕ TEXTBOX
        function TabAPI:AddTextBox(txtConfig)
            txtConfig = txtConfig or {}
            txtConfig.Name = txtConfig.Name or "Input"
            txtConfig.Placeholder = txtConfig.Placeholder or "Type here..."
            txtConfig.Default = txtConfig.Default or ""
            txtConfig.Callback = txtConfig.Callback or function() end

            local TextFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = self.Theme.SidebarBg,
                BackgroundTransparency = 0.1,
                Parent = ContentArea
            })
            Create("UICorner", {CornerRadius = self.Theme.SmallCorner, Parent = TextFrame})

            Create("TextLabel", {
                Text = txtConfig.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 80, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextFrame
            })

            local Input = Create("TextBox", {
                Size = UDim2.new(1, -96, 0, 28),
                Position = UDim2.new(0, 88, 0.5, -14),
                BackgroundColor3 = self.Theme.InputBg,
                BackgroundTransparency = 0.15,
                Text = txtConfig.Default,
                PlaceholderText = txtConfig.Placeholder,
                PlaceholderColor3 = Color3.new(0.7,0.7,0.7),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = self.Theme.Text,
                ClearTextOnFocus = false,
                Parent = TextFrame
            })
            Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = Input})

            Input.FocusLost:Connect(function(enterPressed)
                txtConfig.Callback(Input.Text, enterPressed)
            end)

            return {
                Get = function() return Input.Text end,
                Set = function(val) Input.Text = val end
            }
        end

        return TabAPI
    end

    -- Piliin ang unang tab bilang default
    task.spawn(function()
        task.wait(0.1)
        if #Tabs > 0 then
            Tabs[1].Button.BackgroundTransparency = 0.7
            Tabs[1].Button.BackgroundColor3 = BA5IC.Theme.Selected
        end
    end)

    return WindowAPI
end

return BA5IC
