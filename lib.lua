local LumaUI = {}
LumaUI.__index = LumaUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function LumaUI:CreateWindow(settings)
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 400, 0, 300)
    window.Position = UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local title = Instance.new("TextLabel")
    title.Text = settings.Title or "LumaUI"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(118, 255, 123)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = window

    local tabs = {}

    function window:CreateTab(name)
        local tab = {}
        tab.Name = name
        tab.Container = Instance.new("Frame")
        tab.Container.Size = UDim2.new(1, 0, 1, -30)
        tab.Container.Position = UDim2.new(0, 0, 0, 30)
        tab.Container.BackgroundTransparency = 1
        tab.Container.Visible = false
        tab.Container.Parent = window

        function tab:CreateToggle(args)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 200, 0, 30)
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggle.Text = args.Name or "Toggle"
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.SourceSans
            toggle.TextSize = 18
            toggle.Parent = tab.Container

            local state = args.Default or false
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.BackgroundColor3 = state and Color3.fromRGB(118, 255, 123) or Color3.fromRGB(50, 50, 50)
                if args.Callback then args.Callback(state) end
            end)
        end

        function tab:CreateSlider(args)
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(0, 200, 0, 30)
            slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            slider.Parent = tab.Container

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(1, 0, 1, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.TextSize = 18
            valueLabel.Text = tostring(args.Default or 0)
            valueLabel.Parent = slider

            local min = args.Min or 0
            local max = args.Max or 100
            local value = args.Default or min

            slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(moveInput)
                        if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                            local relativeX = math.clamp(moveInput.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
                            value = math.floor(min + (relativeX / slider.AbsoluteSize.X) * (max - min))
                            valueLabel.Text = tostring(value)
                            if args.Callback then args.Callback(value) end
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            connection:Disconnect()
                        end
                    end)
                end
            end)
        end

        function tab:CreateButton(args)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 200, 0, 30)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.Text = args.Name or "Button"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.SourceSans
            button.TextSize = 18
            button.Parent = tab.Container

            button.MouseButton1Click:Connect(function()
                if args.Callback then args.Callback() end
            end)
        end

        function tab:CreateTextBox(args)
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0, 200, 0, 30)
            box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            box.Text = args.Default or ""
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.SourceSans
            box.TextSize = 18
            box.PlaceholderText = args.Placeholder or ""
            box.Parent = tab.Container

            box.FocusLost:Connect(function(enter)
                if args.Callback then args.Callback(box.Text) end
            end)
        end

        function tab:CreateColorPicker(args)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 200, 0, 30)
            frame.BackgroundColor3 = args.Default or Color3.fromRGB(118, 255, 123)
            frame.Parent = tab.Container

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Text = args.Name or "Color"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.SourceSans
            button.TextSize = 18
            button.BackgroundTransparency = 1
            button.Parent = frame

            button.MouseButton1Click:Connect(function()
                if args.Callback then args.Callback(frame.BackgroundColor3) end
            end)
        end

        function tab:CreateNotification(args)
            local notif = Instance.new("Frame")
            notif.Size = UDim2.new(0, 250, 0, 50)
            notif.Position = UDim2.new(0.5, -125, 0.1, 0)
            notif.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            notif.BorderSizePixel = 0
            notif.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(118, 255, 123)
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 18
            text.Text = args.Text or "Notification"
            text.Parent = notif

            local tween = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -125, 0.15, 0)})
            tween:Play()

            delay(args.Duration or 2, function()
                local outTween = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -125, 0.05, 0)})
                outTween:Play()
                outTween.Completed:Connect(function() notif:Destroy() end)
            end)
        end

        return tab
    end

    return window
end

return LumaUI
