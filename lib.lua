local LumaUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function createCorner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
end

function LumaUI:CreateWindow(cfg)
    local gui = Instance.new("ScreenGui")
    gui.Name = "LumaUI"
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(520, 360)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    main.Parent = gui
    createCorner(12, main)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 42)
    top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    top.Parent = main
    createCorner(12, top)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 1, 0)
    title.Position = UDim2.fromOffset(16, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Left
    title.Text = cfg.Title or "LumaUI"
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(118,255,123)
    title.Parent = top

    local tabsBar = Instance.new("Frame")
    tabsBar.Size = UDim2.new(0, 140, 1, -42)
    tabsBar.Position = UDim2.fromOffset(0, 42)
    tabsBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabsBar.Parent = main

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1, -140, 1, -42)
    pages.Position = UDim2.fromOffset(140, 42)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = tabsBar

    local window = {}

    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -12, 0, 36)
        tabBtn.Position = UDim2.fromOffset(6, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(220,220,220)
        tabBtn.Parent = tabsBar
        createCorner(8, tabBtn)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -16, 1, -16)
        page.Position = UDim2.fromOffset(8, 8)
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.ScrollBarImageTransparency = 1
        page.Visible = false
        page.Parent = pages

        local pLayout = Instance.new("UIListLayout")
        pLayout.Padding = UDim.new(0, 8)
        pLayout.Parent = page

        pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,pLayout.AbsoluteContentSize.Y+8)
        end)

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            page.Visible = true
        end)

        local tab = {}

        function tab:CreateToggle(o)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 42)
            b.BackgroundColor3 = Color3.fromRGB(32,32,32)
            b.Text = ""
            b.Parent = page
            createCorner(10, b)

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -60, 1, 0)
            t.Position = UDim2.fromOffset(16,0)
            t.BackgroundTransparency = 1
            t.TextXAlignment = Left
            t.Text = o.Name
            t.Font = Enum.Font.Gotham
            t.TextSize = 14
            t.TextColor3 = Color3.fromRGB(230,230,230)
            t.Parent = b

            local state = o.Default or false

            b.MouseButton1Click:Connect(function()
                state = not state
                b.BackgroundColor3 = state and Color3.fromRGB(118,255,123) or Color3.fromRGB(32,32,32)
                if o.Callback then o.Callback(state) end
            end)
        end

        function tab:CreateButton(o)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 42)
            b.BackgroundColor3 = Color3.fromRGB(32,32,32)
            b.Text = o.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(230,230,230)
            b.Parent = page
            createCorner(10, b)
            b.MouseButton1Click:Connect(function()
                if o.Callback then o.Callback() end
            end)
        end

        function tab:CreateSlider(o)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 56)
            f.BackgroundColor3 = Color3.fromRGB(32,32,32)
            f.Parent = page
            createCorner(10, f)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -16, 0, 28)
            l.Position = UDim2.fromOffset(16,0)
            l.BackgroundTransparency = 1
            l.TextXAlignment = Left
            l.Text = o.Name
            l.Font = Enum.Font.Gotham
            l.TextSize = 14
            l.TextColor3 = Color3.fromRGB(230,230,230)
            l.Parent = f

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -32, 0, 6)
            bar.Position = UDim2.fromOffset(16,36)
            bar.BackgroundColor3 = Color3.fromRGB(45,45,45)
            bar.Parent = f
            createCorner(6, bar)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0,0,1,0)
            fill.BackgroundColor3 = Color3.fromRGB(118,255,123)
            fill.Parent = bar
            createCorner(6, fill)

            local min,max = o.Min or 0, o.Max or 100
            local val = o.Default or min

            local function set(x)
                val = math.clamp(x, min, max)
                fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
                if o.Callback then o.Callback(val) end
            end

            set(val)

            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local c
                    c = UserInputService.InputChanged:Connect(function(m)
                        if m.UserInputType == Enum.UserInputType.MouseMovement then
                            local p = math.clamp((m.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                            set(min+(max-min)*p)
                        end
                    end)
                    UserInputService.InputEnded:Once(function()
                        if c then c:Disconnect() end
                    end)
                end
            end)
        end

        return tab
    end

    return window
end

return LumaUI
