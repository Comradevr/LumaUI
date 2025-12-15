local LumaUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function corner(r,p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = p
end

function LumaUI:CreateWindow(cfg)
    local gui = Instance.new("ScreenGui")
    gui.Name = "LumaUI"
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(520,360)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    main.Parent = gui
    corner(12,main)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1,0,0,44)
    top.BackgroundColor3 = Color3.fromRGB(30,30,30)
    top.Parent = main
    corner(12,top)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-20,1,0)
    title.Position = UDim2.fromOffset(20,0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Left
    title.Text = cfg.Title or "LumaUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(118,255,123)
    title.Parent = top

    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0,140,1,-44)
    tabs.Position = UDim2.fromOffset(0,44)
    tabs.BackgroundColor3 = Color3.fromRGB(20,20,20)
    tabs.Parent = main

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1,-140,1,-44)
    pages.Position = UDim2.fromOffset(140,44)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0,6)
    tabLayout.Parent = tabs

    local window = {}

    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,-12,0,36)
        tabBtn.Position = UDim2.fromOffset(6,0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(230,230,230)
        tabBtn.Parent = tabs
        corner(8,tabBtn)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1,-16,1,-16)
        page.Position = UDim2.fromOffset(8,8)
        page.ScrollBarImageTransparency = 1
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.Visible = false
        page.Parent = pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0,8)
        layout.Parent = page

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
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
            b.Size = UDim2.new(1,0,0,42)
            b.BackgroundColor3 = Color3.fromRGB(32,32,32)
            b.Text = ""
            b.Parent = page
            corner(10,b)

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1,-20,1,0)
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
            b.Size = UDim2.new(1,0,0,42)
            b.BackgroundColor3 = Color3.fromRGB(32,32,32)
            b.Text = o.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(230,230,230)
            b.Parent = page
            corner(10,b)

            b.MouseButton1Click:Connect(function()
                if o.Callback then o.Callback() end
            end)
        end

        function tab:CreateSlider(o)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1,0,0,56)
            f.BackgroundColor3 = Color3.fromRGB(32,32,32)
            f.Parent = page
            corner(10,f)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1,-20,0,28)
            l.Position = UDim2.fromOffset(16,0)
            l.BackgroundTransparency = 1
            l.TextXAlignment = Left
            l.Text = o.Name
            l.Font = Enum.Font.Gotham
            l.TextSize = 14
            l.TextColor3 = Color3.fromRGB(230,230,230)
            l.Parent = f

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1,-32,0,6)
            bar.Position = UDim2.fromOffset(16,36)
            bar.BackgroundColor3 = Color3.fromRGB(45,45,45)
            bar.Parent = f
            corner(6,bar)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = Color3.fromRGB(118,255,123)
            fill.Size = UDim2.new(0,0,1,0)
            fill.Parent = bar
            corner(6,fill)

            local min,max = o.Min or 0, o.Max or 100
            local val = o.Default or min

            local function set(v)
                val = math.clamp(v,min,max)
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
                            set(min + (max-min)*p)
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
