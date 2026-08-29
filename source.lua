--[[
    Orion-Style UI Library
    Usage:
        local Library = loadstring(game:HttpGet("YOUR_LINK"))()
        local Window = Library:CreateWindow({Name = "My Script"})
        local Tab = Window:AddTab("Main")
        Tab:AddToggle({Name = "Enabled", Default = false, Callback = function(v) print(v) end})
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(28, 28, 35),
    SurfaceLight = Color3.fromRGB(36, 36, 45),
    Accent = Color3.fromRGB(90, 120, 255),
    Text = Color3.fromRGB(240, 240, 250),
    TextDim = Color3.fromRGB(150, 150, 165),
    Success = Color3.fromRGB(60, 200, 130),
    Danger = Color3.fromRGB(255, 75, 85),
    Border = Color3.fromRGB(50, 50, 60),
}

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

local function Stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or Theme.Border
    s.Thickness = th or 1
    s.Parent = p
    return s
end

local function Pad(p, t, b, l, r)
    local x = Instance.new("UIPadding")
    x.PaddingTop = UDim.new(0, t or 0)
    x.PaddingBottom = UDim.new(0, b or 0)
    x.PaddingLeft = UDim.new(0, l or 0)
    x.PaddingRight = UDim.new(0, r or 0)
    x.Parent = p
end

local Library = {}

function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local Window = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "OrionLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local openBtn = Instance.new("ImageButton")
    openBtn.Size = UDim2.new(0, 42, 0, 42)
    openBtn.Position = UDim2.new(0, 14, 0.5, -21)
    openBtn.BackgroundColor3 = Theme.Background
    openBtn.AutoButtonColor = false
    openBtn.Parent = gui
    openBtn.ZIndex = 100
    Corner(openBtn, 12)
    local openStroke = Stroke(openBtn, Theme.Accent, 1.5)

    local openIcon = Instance.new("TextLabel")
    openIcon.Size = UDim2.new(1, 0, 1, 0)
    openIcon.BackgroundTransparency = 1
    openIcon.Text = "◈"
    openIcon.TextColor3 = Theme.Accent
    openIcon.Font = Enum.Font.GothamBold
    openIcon.TextSize = 18
    openIcon.Parent = openBtn

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 480, 0, 340)
    main.Position = UDim2.new(0.5, -240, 0.5, -170)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    Corner(main, 12)
    Stroke(main, Theme.Border, 1)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 42)
    top.BackgroundColor3 = Theme.Surface
    top.BorderSizePixel = 0
    top.Parent = main
    Corner(top, 12)

    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 14)
    topFix.Position = UDim2.new(0, 0, 1, -14)
    topFix.BackgroundColor3 = Theme.Surface
    topFix.BorderSizePixel = 0
    topFix.Parent = top

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = cfg.Name or "Window"
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -36, 0.5, -14)
    close.BackgroundColor3 = Theme.SurfaceLight
    close.Text = "×"
    close.TextColor3 = Theme.Danger
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.AutoButtonColor = false
    close.Parent = top
    Corner(close, 7)

    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, 130, 1, -52)
    side.Position = UDim2.new(0, 8, 0, 48)
    side.BackgroundColor3 = Theme.Surface
    side.BorderSizePixel = 0
    side.Parent = main
    Corner(side, 10)

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 4)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = side
    Pad(side, 8, 8, 8, 8)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -152, 1, -52)
    content.Position = UDim2.new(0, 144, 0, 48)
    content.BackgroundTransparency = 1
    content.Parent = main

    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Visible = true
    Window.Main = main
    Window.Gui = gui

    local function setVis(v)
        Window.Visible = v
        main.Visible = v
        Tween(openIcon, {TextColor3 = v and Theme.Accent or Theme.TextDim})
        Tween(openStroke, {Color = v and Theme.Accent or Theme.Border})
    end

    close.MouseButton1Click:Connect(function() setVis(false) end)
    openBtn.MouseButton1Click:Connect(function() setVis(not Window.Visible) end)
    openBtn.MouseEnter:Connect(function() Tween(openBtn, {BackgroundColor3 = Theme.Surface}) end)
    openBtn.MouseLeave:Connect(function() Tween(openBtn, {BackgroundColor3 = Theme.Background}) end)

    UserInputService.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.RightControl then
            setVis(not Window.Visible)
        end
    end)

    function Window:AddTab(name)
        local Tab = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Theme.Surface
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.TextDim
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = side
        Corner(btn, 7)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0, 16)
        indicator.Position = UDim2.new(0, 0, 0.5, -8)
        indicator.BackgroundColor3 = Theme.Accent
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.Parent = btn
        Corner(indicator, 2)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.BorderSizePixel = 0
        page.Parent = content
        Pad(page, 0, 8, 0, 6)

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
        end)

        Tab.Button = btn
        Tab.Page = page
        Tab.Indicator = indicator

        local function select()
            for _, t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                t.Indicator.Visible = false
                Tween(t.Button, {BackgroundColor3 = Theme.Surface})
                t.Button.TextColor3 = Theme.TextDim
            end
            page.Visible = true
            indicator.Visible = true
            Tween(btn, {BackgroundColor3 = Theme.SurfaceLight})
            btn.TextColor3 = Theme.Text
            Window.CurrentTab = Tab
        end

        btn.MouseButton1Click:Connect(select)
        btn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then Tween(btn, {BackgroundColor3 = Theme.SurfaceLight}) end
        end)
        btn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then Tween(btn, {BackgroundColor3 = Theme.Surface}) end
        end)

        table.insert(Window.Tabs, Tab)
        if not Window.CurrentTab then select() end

        function Tab:AddSection(text)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 22)
            f.BackgroundTransparency = 1
            f.Parent = page
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = Theme.Accent
            l.Font = Enum.Font.GothamBold
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f
        end

        function Tab:AddLabel(text)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 0, 22)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = Theme.TextDim
            l.Font = Enum.Font.Gotham
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = page
        end

        function Tab:AddToggle(opts)
            opts = opts or {}
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = Theme.Surface
            f.Parent = page
            Corner(f, 8)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -56, 1, 0)
            l.Position = UDim2.new(0, 12, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = opts.Name or "Toggle"
            l.TextColor3 = Theme.Text
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f

            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 38, 0, 20)
            track.Position = UDim2.new(1, -48, 0.5, -10)
            track.BackgroundColor3 = opts.Default and Theme.Accent or Theme.SurfaceLight
            track.Parent = f
            Corner(track, 10)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = opts.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = track
            Corner(knob, 8)

            local state = opts.Default or false
            local hit = Instance.new("TextButton")
            hit.Size = UDim2.new(1, 0, 1, 0)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.Parent = f

            hit.MouseButton1Click:Connect(function()
                state = not state
                Tween(track, {BackgroundColor3 = state and Theme.Accent or Theme.SurfaceLight})
                Tween(knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                if opts.Callback then opts.Callback(state) end
            end)

            return {
                Set = function(v)
                    state = v
                    track.BackgroundColor3 = state and Theme.Accent or Theme.SurfaceLight
                    knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                end,
                Get = function() return state end,
            }
        end

        function Tab:AddSlider(opts)
            opts = opts or {}
            local min = opts.Min or 0
            local max = opts.Max or 100
            local default = opts.Default or min

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 52)
            f.BackgroundColor3 = Theme.Surface
            f.Parent = page
            Corner(f, 8)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -16, 0, 18)
            l.Position = UDim2.new(0, 12, 0, 6)
            l.BackgroundTransparency = 1
            l.Text = (opts.Name or "Slider") .. "  •  " .. default
            l.TextColor3 = Theme.Text
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -24, 0, 6)
            bar.Position = UDim2.new(0, 12, 0, 34)
            bar.BackgroundColor3 = Theme.SurfaceLight
            bar.Parent = f
            Corner(bar, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / math.max(max - min, 1), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            fill.Parent = bar
            Corner(fill, 3)

            local value = default
            local dragging = false

            local function upd(input)
                local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel + 0.5)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                l.Text = (opts.Name or "Slider") .. "  •  " .. value
                if opts.Callback then opts.Callback(value) end
            end

            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    upd(i)
                end
            end)
            bar.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    upd(i)
                end
            end)

            return {
                Set = function(v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / math.max(max - min, 1)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    l.Text = (opts.Name or "Slider") .. "  •  " .. value
                end,
                Get = function() return value end,
            }
        end

        function Tab:AddButton(opts)
            opts = opts or {}
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 34)
            b.BackgroundColor3 = Theme.Surface
            b.Text = opts.Name or "Button"
            b.TextColor3 = Theme.Text
            b.Font = Enum.Font.Gotham
            b.TextSize = 13
            b.AutoButtonColor = false
            b.Parent = page
            Corner(b, 8)

            b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Theme.SurfaceLight}) end)
            b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Theme.Surface}) end)
            b.MouseButton1Click:Connect(function()
                Tween(b, {BackgroundColor3 = Theme.Accent}, 0.08)
                task.delay(0.12, function() Tween(b, {BackgroundColor3 = Theme.Surface}) end)
                if opts.Callback then opts.Callback() end
            end)
        end

        function Tab:AddDropdown(opts)
            opts = opts or {}
            local options = opts.Options or {"Option 1"}
            local default = opts.Default or options[1]

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = Theme.Surface
            f.Parent = page
            Corner(f, 8)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(0.42, 0, 1, 0)
            l.Position = UDim2.new(0, 12, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = opts.Name or "Dropdown"
            l.TextColor3 = Theme.Text
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.5, 0, 0, 24)
            b.Position = UDim2.new(0.48, 0, 0.5, -12)
            b.BackgroundColor3 = Theme.SurfaceLight
            b.Text = default
            b.TextColor3 = Theme.Accent
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            b.AutoButtonColor = false
            b.Parent = f
            Corner(b, 6)

            local idx = table.find(options, default) or 1
            b.MouseButton1Click:Connect(function()
                idx = idx % #options + 1
                b.Text = options[idx]
                if opts.Callback then opts.Callback(options[idx]) end
            end)

            return {
                Set = function(v)
                    local i = table.find(options, v)
                    if i then idx = i b.Text = v end
                end,
                Get = function() return options[idx] end,
            }
        end

        function Tab:AddColorPicker(opts)
            opts = opts or {}
            local default = opts.Default or Theme.Accent

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = Theme.Surface
            f.Parent = page
            Corner(f, 8)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -48, 1, 0)
            l.Position = UDim2.new(0, 12, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = opts.Name or "Color"
            l.TextColor3 = Theme.Text
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f

            local prev = Instance.new("TextButton")
            prev.Size = UDim2.new(0, 26, 0, 26)
            prev.Position = UDim2.new(1, -36, 0.5, -13)
            prev.BackgroundColor3 = default
            prev.Text = ""
            prev.AutoButtonColor = false
            prev.Parent = f
            Corner(prev, 6)
            Stroke(prev, Theme.Border, 1)

            local colors = {
                Color3.fromRGB(90, 120, 255),
                Color3.fromRGB(255, 75, 85),
                Color3.fromRGB(60, 200, 130),
                Color3.fromRGB(255, 180, 40),
                Color3.fromRGB(180, 90, 255),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(255, 120, 180),
                Color3.fromRGB(80, 200, 255),
            }
            local idx = 1
            prev.MouseButton1Click:Connect(function()
                idx = idx % #colors + 1
                prev.BackgroundColor3 = colors[idx]
                if opts.Callback then opts.Callback(colors[idx]) end
            end)

            return {
                Set = function(c) prev.BackgroundColor3 = c end,
                Get = function() return prev.BackgroundColor3 end,
            }
        end

        return Tab
    end

    return Window
end

return Library
