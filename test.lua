-- LumaUI Test Script
local LumaUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Comradevr/LumaUI/main/lib.lua'))()

local Window = LumaUI:CreateWindow({
    Title = "LumaUI Test"
})

local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(value)
        print("God Mode: ", value)
    end
})

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0,100},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then char:BreakJoints() end
    end
})
