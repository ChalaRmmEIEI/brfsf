local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local ICON_IMAGE = "rbxassetid://127060073503424" -- User specific icon
local ICON_SIZE = 25 -- Smaller size
local ICON_COLOR = Color3.fromRGB(127, 0, 255) -- Purple accent
local ICON_POSITION = UDim2.new(0, 20, 0, 20) -- Top Left corner

-- Create ScreenGui
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "UIToggleIcon"
ToggleGui.Parent = game:GetService("CoreGui")
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.ResetOnSpawn = false

-- Main icon button container
local IconButton = Instance.new("Frame")
IconButton.Name = "IconButton"
IconButton.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
IconButton.Position = ICON_POSITION
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconButton.BorderSizePixel = 0
IconButton.Active = true
IconButton.Parent = ToggleGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0) -- Fully round (circle)
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = ICON_COLOR
IconStroke.Thickness = 0.5 -- Thinner border
IconStroke.Transparency = 0.2 -- Slightly transparent for "smaller" feel
IconStroke.Parent = IconButton

-- Icon image
local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Size = UDim2.new(0.7, 0, 0.7, 0)
Icon.Position = UDim2.new(0.15, 0, 0.15, 0)
Icon.BackgroundTransparency = 1
Icon.Image = ICON_IMAGE
Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
Icon.ScaleType = Enum.ScaleType.Fit
Icon.Parent = IconButton

-- Click detector
local ClickButton = Instance.new("TextButton")
ClickButton.Name = "ClickDetector"
ClickButton.Size = UDim2.new(1, 0, 1, 0)
ClickButton.BackgroundTransparency = 1
ClickButton.Text = ""
ClickButton.Parent = IconButton

-- Unified Input Handling (Drag + Click) on the ClickButton
local dragging = false
local dragInput, mousePos, framePos
local hasDragged = false
local uiVisible = true -- Declare explicitly

local function update(input)
    local delta = input.Position - mousePos
    local newPos = UDim2.new(
        framePos.X.Scale,
        framePos.X.Offset + delta.X,
        framePos.Y.Scale,
        framePos.Y.Offset + delta.Y
    )
    -- Smooth drag with Tween
    TweenService:Create(IconButton, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = newPos
    }):Play()
    hasDragged = true
end

-- Bind input to ClickButton (since it sits on top)
ClickButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = IconButton.Position
        hasDragged = false -- Reset drag state
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                
                -- Only toggle if we didn't drag
                if not hasDragged then
                    local mainUI = game:GetService("CoreGui"):FindFirstChild("ChaLarmHub")
                    if mainUI then
                        uiVisible = not uiVisible
                        mainUI.Enabled = uiVisible
                    end
                end
            end
        end)
    end
end)

ClickButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Return the toggle GUI for external control
local ToggleCallback = nil

return {
    ToggleGui = ToggleGui,
    IconButton = IconButton,
    SetIcon = function(assetId)
        Icon.Image = assetId
    end,
    SetColor = function(color)
        IconStroke.Color = color
    end,
    SetPosition = function(position)
        IconButton.Position = position
    end,
    -- Add SetCallback for universal support
    SetCallback = function(callback)
        ToggleCallback = callback
    end,
    ToggleUI = function()
        -- Priority 1: Use Custom Callback (Universal Method)
        if ToggleCallback then
            local success, err = pcall(function()
                local isVisible = ToggleCallback()
                -- If callback returns state, update uiVisible (optional)
                if isVisible ~= nil then
                    uiVisible = isVisible
                else
                    uiVisible = not uiVisible -- Toggle local state if no return
                end
            end)
            if not success then warn("Toggle Callback Error:", err) end
            return
        end

        -- Priority 2: Default "ChaLarmHub" fallback
        local mainUI = game:GetService("CoreGui"):FindFirstChild("ChaLarmHub")
        if mainUI then
            uiVisible = not uiVisible
            mainUI.Enabled = uiVisible
        else
            warn("No Toggle Callback set and 'ChaLarmHub' not found.")
        end
    end
}
