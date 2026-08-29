local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
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
    local ActivePopups = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "Aether"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.new(0, 42, 0, 42)
    openBtn.Position = UDim2.new(0, 14, 0.5, -21)
    openBtn.BackgroundColor3 = Theme.Background
    openBtn.Text = "NX"
    openBtn.TextColor3 = Theme.Accent
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 14
    openBtn.AutoButtonColor = false
    openBtn.Parent = gui
    openBtn.ZIndex = 100
    Corner(openBtn, 12)
    local openStroke = Stroke(openBtn, Theme.Accent, 1.5)

    local openIcon = openBtn

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 480, 0, 340)
    main.Position = UDim2.new(0.5, -240, 0.5, -170)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = false
    main.Parent = gui
    main.ZIndex = 10
    Corner(main, 12)
    Stroke(main, Theme.Border, 1)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 42)
    top.BackgroundColor3 = Theme.Surface
    top.BorderSizePixel = 0
    top.Parent = main
    top.ZIndex = 11
    Corner(top, 12)

    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 14)
    topFix.Position = UDim2.new(0, 0, 1, -14)
    topFix.BackgroundColor3 = Theme.Surface
    topFix.BorderSizePixel = 0
    topFix.Parent = top
    topFix.ZIndex = 11

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
    title.ZIndex = 12

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
    close.ZIndex = 12
    Corner(close, 7)

    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, 130, 1, -52)
    side.Position = UDim2.new(0, 8, 0, 48)
    side.BackgroundColor3 = Theme.Surface
    side.BorderSizePixel = 0
    side.Parent = main
    side.ZIndex = 11
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
    content.ClipsDescendants = false
    content.Parent = main
    content.ZIndex = 11

    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Visible = true
    Window.Main = main
    Window.Gui = gui

    local function closeAllPopups()
        for _, popupData in ipairs(ActivePopups) do
            if popupData.close then
                popupData.close()
            end
        end
    end

    local function setVis(v)
        Window.Visible = v
        main.Visible = v
        if not v then
            closeAllPopups()
        end
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
        btn.ZIndex = 12
        Corner(btn, 7)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0, 16)
        indicator.Position = UDim2.new(0, 0, 0.5, -8)
        indicator.BackgroundColor3 = Theme.Accent
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.Parent = btn
        indicator.ZIndex = 13
        Corner(indicator, 2)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.BorderSizePixel = 0
        page.ClipsDescendants = false
        page.Parent = content
        page.ZIndex = 12
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
            closeAllPopups()
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
            f.ZIndex = 13
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = Theme.Accent
            l.Font = Enum.Font.GothamBold
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f
            l.ZIndex = 13
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
            l.ZIndex = 13
        end

        function Tab:AddToggle(opts)
            opts = opts or {}
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = Theme.Surface
            f.Parent = page
            f.ZIndex = 13
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
            l.ZIndex = 14

            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 38, 0, 20)
            track.Position = UDim2.new(1, -48, 0.5, -10)
            track.BackgroundColor3 = opts.Default and Theme.Accent or Theme.SurfaceLight
            track.Parent = f
            track.ZIndex = 14
            Corner(track, 10)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = opts.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = track
            knob.ZIndex = 15
            Corner(knob, 8)

            local state = opts.Default or false
            local hit = Instance.new("TextButton")
            hit.Size = UDim2.new(1, 0, 1, 0)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.Parent = f
            hit.ZIndex = 16

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
            f.ZIndex = 13
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
            l.ZIndex = 14

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -24, 0, 6)
            bar.Position = UDim2.new(0, 12, 0, 34)
            bar.BackgroundColor3 = Theme.SurfaceLight
            bar.Parent = f
            bar.ZIndex = 14
            Corner(bar, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / math.max(max - min, 1), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            fill.Parent = bar
            fill.ZIndex = 15
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
            b.ZIndex = 13
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
            local current = opts.Default or options[1]

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = Theme.Surface
            f.ClipsDescendants = false
            f.Parent = page
            f.ZIndex = 13
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
            l.ZIndex = 14

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.5, 0, 0, 24)
            b.Position = UDim2.new(0.48, 0, 0.5, -12)
            b.BackgroundColor3 = Theme.SurfaceLight
            b.Text = current
            b.TextColor3 = Theme.Accent
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            b.AutoButtonColor = false
            b.Parent = f
            b.ZIndex = 14
            Corner(b, 6)

            local blocker = Instance.new("TextButton")
            blocker.Size = UDim2.new(1, 0, 1, 0)
            blocker.Position = UDim2.new(0, 0, 0, 0)
            blocker.BackgroundTransparency = 1
            blocker.Text = ""
            blocker.Visible = false
            blocker.ZIndex = 199
            blocker.Parent = gui

            local popup = Instance.new("Frame")
            popup.Size = UDim2.new(0, 160, 0, 0)
            popup.BackgroundColor3 = Theme.Background
            popup.BorderSizePixel = 0
            popup.Visible = false
            popup.ZIndex = 200
            popup.ClipsDescendants = true
            popup.Parent = gui
            Corner(popup, 8)
            Stroke(popup, Theme.Border, 1)

            local popupScroll = Instance.new("ScrollingFrame")
            popupScroll.Size = UDim2.new(1, -8, 1, -8)
            popupScroll.Position = UDim2.new(0, 4, 0, 4)
            popupScroll.BackgroundTransparency = 1
            popupScroll.ScrollBarThickness = 3
            popupScroll.ScrollBarImageColor3 = Theme.Accent
            popupScroll.BorderSizePixel = 0
            popupScroll.ZIndex = 201
            popupScroll.Parent = popup

            local popupLayout = Instance.new("UIListLayout")
            popupLayout.Padding = UDim.new(0, 3)
            popupLayout.SortOrder = Enum.SortOrder.LayoutOrder
            popupLayout.Parent = popupScroll

            local open = false

            local function closePopup()
                if not open then return end
                open = false
                blocker.Visible = false
                Tween(popup, {Size = UDim2.new(0, 160, 0, 0)}, 0.12)
                task.delay(0.12, function()
                    if not open then popup.Visible = false end
                end)
            end

            local function openPopup()
                closeAllPopups()
                open = true
                local abs = b.AbsolutePosition
                local size = b.AbsoluteSize
                popup.Position = UDim2.new(0, abs.X + size.X - 160, 0, abs.Y + size.Y + 4)
                popup.Visible = true
                blocker.Visible = true
                local height = math.min(#options * 28 + 12, 180)
                Tween(popup, {Size = UDim2.new(0, 160, 0, height)}, 0.15)
                popupScroll.CanvasSize = UDim2.new(0, 0, 0, #options * 28)
            end

            table.insert(ActivePopups, {close = closePopup})

            blocker.MouseButton1Click:Connect(closePopup)

            for _, opt in ipairs(options) do
                local ob = Instance.new("TextButton")
                ob.Size = UDim2.new(1, 0, 0, 26)
                ob.BackgroundColor3 = Theme.Surface
                ob.Text = opt
                ob.TextColor3 = Theme.Text
                ob.Font = Enum.Font.Gotham
                ob.TextSize = 12
                ob.AutoButtonColor = false
                ob.ZIndex = 202
                ob.Parent = popupScroll
                Corner(ob, 5)

                ob.MouseEnter:Connect(function()
                    Tween(ob, {BackgroundColor3 = Theme.SurfaceLight})
                end)
                ob.MouseLeave:Connect(function()
                    Tween(ob, {BackgroundColor3 = Theme.Surface})
                end)
                ob.MouseButton1Click:Connect(function()
                    current = opt
                    b.Text = opt
                    closePopup()
                    if opts.Callback then opts.Callback(opt) end
                end)
            end

            b.MouseButton1Click:Connect(function()
                if open then closePopup() else openPopup() end
            end)

            return {
                Set = function(v)
                    if table.find(options, v) then
                        current = v
                        b.Text = v
                    end
                end,
                Get = function() return current end,
            }
        end

        function Tab:AddColorPicker(opts)
            opts = opts or {}
            local current = opts.Default or Theme.Accent
            local recent = {}

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = Theme.Surface
            f.ClipsDescendants = false
            f.Parent = page
            f.ZIndex = 13
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
            l.ZIndex = 14

            local prev = Instance.new("TextButton")
            prev.Size = UDim2.new(0, 26, 0, 26)
            prev.Position = UDim2.new(1, -36, 0.5, -13)
            prev.BackgroundColor3 = current
            prev.Text = ""
            prev.AutoButtonColor = false
            prev.Parent = f
            prev.ZIndex = 14
            Corner(prev, 6)
            Stroke(prev, Theme.Border, 1)

            local blocker = Instance.new("TextButton")
            blocker.Size = UDim2.new(1, 0, 1, 0)
            blocker.Position = UDim2.new(0, 0, 0, 0)
            blocker.BackgroundTransparency = 1
            blocker.Text = ""
            blocker.Visible = false
            blocker.ZIndex = 199
            blocker.Parent = gui

            local popup = Instance.new("Frame")
            popup.Size = UDim2.new(0, 230, 0, 0)
            popup.BackgroundColor3 = Theme.Background
            popup.BorderSizePixel = 0
            popup.Visible = false
            popup.ZIndex = 200
            popup.ClipsDescendants = true
            popup.Parent = gui
            Corner(popup, 10)
            Stroke(popup, Theme.Border, 1)

            local popupLayout = Instance.new("UIListLayout")
            popupLayout.Padding = UDim.new(0, 6)
            popupLayout.SortOrder = Enum.SortOrder.LayoutOrder
            popupLayout.Parent = popup
            Pad(popup, 10, 10, 10, 10)

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 16)
            title.BackgroundTransparency = 1
            title.Text = "Colors"
            title.TextColor3 = Theme.Text
            title.Font = Enum.Font.GothamBold
            title.TextSize = 12
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 201
            title.Parent = popup

            local grid = Instance.new("Frame")
            grid.Size = UDim2.new(1, 0, 0, 90)
            grid.BackgroundTransparency = 1
            grid.ZIndex = 201
            grid.Parent = popup

            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.new(0, 22, 0, 22)
            gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
            gridLayout.Parent = grid

            local palette = {
                Color3.fromRGB(255, 75, 85),
                Color3.fromRGB(255, 120, 50),
                Color3.fromRGB(255, 180, 40),
                Color3.fromRGB(255, 220, 60),
                Color3.fromRGB(180, 255, 60),
                Color3.fromRGB(60, 200, 130),
                Color3.fromRGB(40, 220, 200),
                Color3.fromRGB(80, 200, 255),
                Color3.fromRGB(90, 120, 255),
                Color3.fromRGB(140, 90, 255),
                Color3.fromRGB(200, 80, 255),
                Color3.fromRGB(255, 100, 200),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(200, 200, 210),
                Color3.fromRGB(120, 120, 130),
                Color3.fromRGB(40, 40, 50),
                Color3.fromRGB(0, 0, 0),
                Color3.fromRGB(255, 0, 0),
                Color3.fromRGB(0, 255, 0),
                Color3.fromRGB(0, 100, 255),
            }

            local function colorKey(c)
                return math.floor(c.R * 255) .. "," .. math.floor(c.G * 255) .. "," .. math.floor(c.B * 255)
            end

            local function setColor(c, addRecent)
                current = c
                prev.BackgroundColor3 = c
                if addRecent ~= false then
                    local key = colorKey(c)
                    for i, rc in ipairs(recent) do
                        if colorKey(rc) == key then
                            table.remove(recent, i)
                            break
                        end
                    end
                    table.insert(recent, 1, c)
                    if #recent > 8 then table.remove(recent) end
                end
                if opts.Callback then opts.Callback(c) end
            end

            for _, col in ipairs(palette) do
                local swatch = Instance.new("TextButton")
                swatch.BackgroundColor3 = col
                swatch.Text = ""
                swatch.AutoButtonColor = false
                swatch.ZIndex = 202
                swatch.Parent = grid
                Corner(swatch, 5)
                swatch.MouseButton1Click:Connect(function()
                    setColor(col)
                end)
            end

            local recentTitle = Instance.new("TextLabel")
            recentTitle.Size = UDim2.new(1, 0, 0, 14)
            recentTitle.BackgroundTransparency = 1
            recentTitle.Text = "Recent"
            recentTitle.TextColor3 = Theme.TextDim
            recentTitle.Font = Enum.Font.Gotham
            recentTitle.TextSize = 11
            recentTitle.TextXAlignment = Enum.TextXAlignment.Left
            recentTitle.ZIndex = 201
            recentTitle.Parent = popup

            local recentFrame = Instance.new("Frame")
            recentFrame.Size = UDim2.new(1, 0, 0, 24)
            recentFrame.BackgroundTransparency = 1
            recentFrame.ZIndex = 201
            recentFrame.Parent = popup

            local recentLayout = Instance.new("UIListLayout")
            recentLayout.FillDirection = Enum.FillDirection.Horizontal
            recentLayout.Padding = UDim.new(0, 5)
            recentLayout.Parent = recentFrame

            local function refreshRecent()
                for _, child in ipairs(recentFrame:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, col in ipairs(recent) do
                    local s = Instance.new("TextButton")
                    s.Size = UDim2.new(0, 22, 0, 22)
                    s.BackgroundColor3 = col
                    s.Text = ""
                    s.AutoButtonColor = false
                    s.ZIndex = 202
                    s.Parent = recentFrame
                    Corner(s, 5)
                    s.MouseButton1Click:Connect(function()
                        setColor(col, false)
                    end)
                end
            end

            local rgbFrame = Instance.new("Frame")
            rgbFrame.Size = UDim2.new(1, 0, 0, 28)
            rgbFrame.BackgroundTransparency = 1
            rgbFrame.ZIndex = 201
            rgbFrame.Parent = popup

            local rgbLayout = Instance.new("UIListLayout")
            rgbLayout.FillDirection = Enum.FillDirection.Horizontal
            rgbLayout.Padding = UDim.new(0, 4)
            rgbLayout.Parent = rgbFrame

            local function makeRGBBox(label, default)
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(0, 58, 0, 26)
                box.BackgroundColor3 = Theme.SurfaceLight
                box.Text = label .. " " .. default
                box.TextColor3 = Theme.Text
                box.Font = Enum.Font.Gotham
                box.TextSize = 11
                box.ClearTextOnFocus = false
                box.ZIndex = 202
                box.Parent = rgbFrame
                Corner(box, 5)
                return box
            end

            local rBox = makeRGBBox("R", math.floor(current.R * 255))
            local gBox = makeRGBBox("G", math.floor(current.G * 255))
            local bBox = makeRGBBox("B", math.floor(current.B * 255))

            local function applyRGB()
                local r = tonumber(rBox.Text:match("%d+")) or 0
                local g = tonumber(gBox.Text:match("%d+")) or 0
                local b = tonumber(bBox.Text:match("%d+")) or 0
                r, g, b = math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)
                setColor(Color3.fromRGB(r, g, b))
                rBox.Text = "R " .. r
                gBox.Text = "G " .. g
                bBox.Text = "B " .. b
            end

            rBox.FocusLost:Connect(applyRGB)
            gBox.FocusLost:Connect(applyRGB)
            bBox.FocusLost:Connect(applyRGB)

            local rainbowBtn = Instance.new("TextButton")
            rainbowBtn.Size = UDim2.new(1, 0, 0, 30)
            rainbowBtn.BackgroundColor3 = Theme.SurfaceLight
            rainbowBtn.Text = "Rainbow"
            rainbowBtn.TextColor3 = Theme.Text
            rainbowBtn.Font = Enum.Font.Gotham
            rainbowBtn.TextSize = 12
            rainbowBtn.AutoButtonColor = false
            rainbowBtn.ZIndex = 201
            rainbowBtn.Parent = popup
            Corner(rainbowBtn, 6)

            local rainbowOn = false
            local rainbowConn = nil

            rainbowBtn.MouseButton1Click:Connect(function()
                rainbowOn = not rainbowOn
                rainbowBtn.Text = rainbowOn and "Rainbow  •  ON" or "Rainbow"
                rainbowBtn.BackgroundColor3 = rainbowOn and Theme.Accent or Theme.SurfaceLight

                if rainbowConn then
                    rainbowConn:Disconnect()
                    rainbowConn = nil
                end

                if rainbowOn then
                    local h = 0
                    rainbowConn = RunService.RenderStepped:Connect(function(dt)
                        h = (h + dt * 0.15) % 1
                        local c = Color3.fromHSV(h, 1, 1)
                        current = c
                        prev.BackgroundColor3 = c
                        if opts.Callback then opts.Callback(c) end
                    end)
                end
            end)

            local open = false

            local function closePopup()
                if not open then return end
                open = false
                blocker.Visible = false
                Tween(popup, {Size = UDim2.new(0, 230, 0, 0)}, 0.15)
                task.delay(0.15, function()
                    if not open then popup.Visible = false end
                end)
            end

            table.insert(ActivePopups, {close = closePopup})

            blocker.MouseButton1Click:Connect(closePopup)

            prev.MouseButton1Click:Connect(function()
                if open then
                    closePopup()
                else
                    closeAllPopups()
                    open = true
                    local abs = prev.AbsolutePosition
                    local size = prev.AbsoluteSize
                    popup.Position = UDim2.new(0, abs.X + size.X - 230, 0, abs.Y + size.Y + 6)
                    popup.Visible = true
                    blocker.Visible = true
                    Tween(popup, {Size = UDim2.new(0, 230, 0, 250)}, 0.2)
                    refreshRecent()
                    rBox.Text = "R " .. math.floor(current.R * 255)
                    gBox.Text = "G " .. math.floor(current.G * 255)
                    bBox.Text = "B " .. math.floor(current.B * 255)
                end
            end)

            return {
                Set = function(c)
                    setColor(c)
                end,
                Get = function()
                    return current
                end,
            }
        end

        return Tab
    end

    return Window
end

return Library
