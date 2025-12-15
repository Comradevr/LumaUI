# LumaUI


A full-featured Roblox UI library with modern design and neon accent.


## Features
- Draggable windows with tabs
- Toggles, sliders, buttons, text boxes
- Color picker
- Dropdown menus
- Notifications with smooth animations
- Neon accent color: light green (118, 255, 123)


## Example Usage
```lua
local LumaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Comradevr/LumaUI/main/lib.lua"))()


local window = LumaUI:CreateWindow({ Title = "My Game" })
local playerTab = window:CreateTab("Player")


playerTab:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value)
        print("God Mode:", value)
    end
})

playerTab:CreateSlider({
    Name = "Speed",
    Min = 0,
    Max = 500,
    Default = 50,
    Callback = function(val)
        print("Speed:", val)
    end
})

playerTab:CreateButton({
    Name = "Reset",
    Callback = function()
        print("Reset clicked")
    end
})
```


## Installation
1. Upload `lib.lua` to your GitHub.
2. Load it in Roblox via `loadstring`.


## License
MIT License
