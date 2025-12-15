local LumaUI = {}
LumaUI.__index = LumaUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function LumaUI:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.Notifications = {}
    Window.Title = config.Title or "LumaUI"
    Window.Theme = config.Theme or { Background = Color3.fromRGB(18,18,18), Accent = Color3.fromRGB(48,255,106) }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LumaUI"
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Window.MainFrame = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 100, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(24,24,24)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Window.Sidebar = Sidebar

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -100, 1, 0)
    TabContainer.Position = UDim2.new(0, 100, 0, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    Window.TabContainer = TabContainer

    function Window:CreateTab(tabName)
        local Tab = {}
        Tab.Sections = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 50)
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 18
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)
        TabButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
        TabButton.Parent = Sidebar

        local SectionContainer = Instance.new("ScrollingFrame")
        SectionContainer.Size = UDim2.new(1, 0, 1, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.CanvasSize = UDim2.new(0,0,1,0)
        SectionContainer.ScrollBarThickness = 6
        SectionContainer.Parent = TabContainer
        SectionContainer.Visible = false
        Tab.Container = SectionContainer

        TabButton.MouseButton1Click:Connect(function()
            for _,t in pairs(Window.Tabs) do
                t.Container.Visible = false
            end
            Tab.Container.Visible = true
        end)

        function Tab:CreateSection(sectionName)
            local Section = {}

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -20, 0, 50)
            Frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
            Frame.Position = UDim2.new(0, 10, 0, #self.Sections * 60)
            Frame.Parent = SectionContainer

            local Label = Instance.new("TextLabel")
            Label.Text = sectionName
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 16
            Label.TextColor3 = Color3.fromRGB(255,255,255)
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1,0,0,20)
            Label.Parent = Frame

            Section.Frame = Frame

            function Section:CreateButton(data)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -10, 0, 25)
                Btn.Position = UDim2.new(0,5,#Frame:GetChildren()*30)
                Btn.BackgroundColor3 = Window.Theme.Accent
                Btn.Text = data.Name or "Button"
                Btn.TextColor3 = Color3.fromRGB(0,0,0)
                Btn.Font = Enum.Font.GothamBold
                Btn.TextSize = 14
                Btn.Parent = Frame
                if data.Callback then
                    Btn.MouseButton1Click:Connect(data.Callback)
                end
            end

            function Section:CreateToggle(data)
                local Toggle = Instance.new("TextButton")
                Toggle.Size = UDim2.new(1, -10, 0, 25)
                Toggle.Position = UDim2.new(0,5,#Frame:GetChildren()*30)
                Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
                Toggle.TextColor3 = Color3.fromRGB(255,255,255)
                Toggle.Font = Enum.Font.GothamBold
                Toggle.TextSize = 14
                Toggle.Text = data.Name.." [OFF]"
                Toggle.Parent = Frame
                local state = data.CurrentValue or false
                Toggle.MouseButton1Click:Connect(function()
                    state = not state
                    Toggle.Text = data.Name.." ["..(state and "ON" or "OFF").."]"
                    if data.Callback then data.Callback(state) end
                end)
            end

            function Section:CreateSlider(data)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 25)
                SliderFrame.Position = UDim2.new(0,5,#Frame:GetChildren()*30)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
                SliderFrame.Parent = Frame

                local Slider = Instance.new("TextLabel")
                Slider.Text = data.Name.." "..(data.CurrentValue or 0)
                Slider.Font = Enum.Font.GothamBold
                Slider.TextSize = 14
                Slider.TextColor3 = Color3.fromRGB(255,255,255)
                Slider.BackgroundTransparency = 1
                Slider.Size = UDim2.new(1,0,1,0)
                Slider.Parent = SliderFrame

                local dragging = false
                SliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                SliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouseX = math.clamp(input.Position.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
                        local percent = mouseX/SliderFrame.AbsoluteSize.X
                        local value = math.floor(data.Range[1] + (data.Range[2]-data.Range[1])*percent)
                        Slider.Text = data.Name.." "..value
                        if data.Callback then data.Callback(value) end
                    end
                end)
            end

            table.insert(self.Sections, Section)
            return Section
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    function Window:Notify(data)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0,200,0,50)
        notif.Position = UDim2.new(1,-210,0,10 + #self.Notifications*60)
        notif.BackgroundColor3 = Color3.fromRGB(30,30,30)
        notif.Parent = ScreenGui

        local Text = Instance.new("TextLabel")
        Text.Text = data.Title.."\n"..data.Content
        Text.TextColor3 = Color3.fromRGB(255,255,255)
        Text.TextSize = 14
        Text.Font = Enum.Font.GothamBold
        Text.BackgroundTransparency = 1
        Text.Size = UDim2.new(1,0,1,0)
        Text.Parent = notif

        table.insert(self.Notifications, notif)
        task.delay(data.Duration or 3, function()
            notif:Destroy()
        end)
    end

    return Window
end

return LumaUI
