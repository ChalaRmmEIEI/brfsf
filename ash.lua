-- Draggable icon button to show/hide the main UI
-- Based on iconcloseopen layout, customized for AxelHub style

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local ICON_IMAGE = "rbxassetid://96083355749736"
local ICON_SIZE = 45 
local ICON_POSITION = UDim2.new(0, 20, 0, 20)

-- Create ScreenGui
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "UIToggleIcon"
ToggleGui.Parent = game:GetService("CoreGui")
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.ResetOnSpawn = false

-- Main icon button (Using ImageButton for click handling)
local IconButton = Instance.new("ImageButton")
IconButton.Name = "IconButton"
IconButton.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
IconButton.Position = ICON_POSITION
IconButton.BackgroundTransparency = 1 -- Transparent background as requested
IconButton.BorderSizePixel = 0
IconButton.Active = true
IconButton.AutoButtonColor = false
IconButton.Image = ""
IconButton.Parent = ToggleGui

-- UI Corner for IconButton (not strictly needed if background is transparent but kept for consistency)
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconButton

-- Icon image (Full frame, clip round)
local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Size = UDim2.new(1, 0, 1, 0) -- Full frame as requested
Icon.Position = UDim2.new(0, 0, 0, 0)
Icon.BackgroundTransparency = 1
Icon.Image = ICON_IMAGE
Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
Icon.ImageTransparency = 0.1 -- Slightly transparent as requested
Icon.ScaleType = Enum.ScaleType.Fit
Icon.Parent = IconButton

-- Clip the actual image to be round
local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(1, 0)
ImageCorner.Parent = Icon

-- State variables
local dragging = false
local dragInput, mousePos, framePos
local hasDragged = false
local uiVisible = true
local ToggleCallback = nil

-- Drag update function
local function update(input)
    local delta = input.Position - mousePos
    local newPos = UDim2.new(
        framePos.X.Scale,
        framePos.X.Offset + delta.X,
        framePos.Y.Scale,
        framePos.Y.Offset + delta.Y
    )
    TweenService:Create(IconButton, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = newPos
    }):Play()
    hasDragged = true
end

-- Input handling for drag
IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = IconButton.Position
        hasDragged = false
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

IconButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Click handling (Toggle UI)
IconButton.MouseButton1Click:Connect(function()
    -- Only toggle if not dragged
    if not hasDragged then
        -- Priority 1: Use Custom Callback (Universal Method)
        if ToggleCallback then
            local success, err = pcall(function()
                local isVisible = ToggleCallback()
                if isVisible ~= nil then
                    uiVisible = isVisible
                else
                    uiVisible = not uiVisible
                end
            end)
            if not success then 
                warn("Toggle Callback Error:", err) 
            end
            return
        end

        -- Priority 2: Default "AxelHub" fallback
        local mainUI = game:GetService("CoreGui"):FindFirstChild("AxelHub")
        if mainUI then
            uiVisible = not uiVisible
            mainUI.Enabled = uiVisible
        else
            warn("No Toggle Callback set and 'AxelHub' not found.")
        end
    end
    
    -- Reset drag state after a short delay
    task.wait(0.1)
    hasDragged = false
end)

-- Return module API
return {
    ToggleGui = ToggleGui,
    IconButton = IconButton,
    
    -- Customization methods
    SetIcon = function(assetId)
        Icon.Image = assetId
    end,
    
    SetColor = function() end, -- No stroke for axial style
    
    SetPosition = function(position)
        IconButton.Position = position
    end,
    
    -- Callback system
    SetCallback = function(callback)
        ToggleCallback = callback
    end,
    
    -- State management
    SetState = function(state)
        uiVisible = not state
    end,
    
    -- Manual toggle method
    ToggleUI = function()
        if ToggleCallback then
            local success, err = pcall(function()
                local isVisible = ToggleCallback()
                if isVisible ~= nil then
                    uiVisible = isVisible
                else
                    uiVisible = not uiVisible
                end
            end)
            if not success then 
                warn("Toggle Callback Error:", err) 
            end
            return
        end

        local mainUI = game:GetService("CoreGui"):FindFirstChild("AxelHub")
        if mainUI then
            uiVisible = not uiVisible
            mainUI.Enabled = uiVisible
        else
            warn("No Toggle Callback set and 'AxelHub' not found.")
        end
    end
}
