-- GUI Toggle Icon for UI Control (FIXED VERSION - Compatible with Cascade UI)
-- Draggable icon button to show/hide the main UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local ICON_IMAGE = "rbxassetid://127060073503424"
local ICON_SIZE = 25
local ICON_COLOR = Color3.fromRGB(127, 0, 255)
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
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconButton.BorderSizePixel = 0
IconButton.Active = true
IconButton.AutoButtonColor = false
IconButton.Image = ""
IconButton.Parent = ToggleGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = ICON_COLOR
IconStroke.Thickness = 0.5
IconStroke.Transparency = 0.2
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

-- Click handling (Toggle UI) - FIXED: Separated from drag
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

        -- Priority 2: Default "ChaLarmHub" fallback
        local mainUI = game:GetService("CoreGui"):FindFirstChild("ChaLarmHub")
        if mainUI then
            uiVisible = not uiVisible
            mainUI.Enabled = uiVisible
            
            -- Visual feedback
            TweenService:Create(IconButton, TweenInfo.new(0.1), {
                BackgroundColor3 = uiVisible and Color3.fromRGB(20, 20, 25) or Color3.fromRGB(40, 40, 45)
            }):Play()
        else
            warn("No Toggle Callback set and 'ChaLarmHub' not found.")
        end
    end
    
    -- Reset drag state after a short delay
    task.wait(0.1)
    hasDragged = false
end)

-- Hover effect
IconButton.MouseEnter:Connect(function()
    TweenService:Create(IconStroke, TweenInfo.new(0.2), {
        Transparency = 0,
        Thickness = 1
    }):Play()
    TweenService:Create(Icon, TweenInfo.new(0.2), {
        Size = UDim2.new(0.75, 0, 0.75, 0),
        Position = UDim2.new(0.125, 0, 0.125, 0)
    }):Play()
end)

IconButton.MouseLeave:Connect(function()
    TweenService:Create(IconStroke, TweenInfo.new(0.2), {
        Transparency = 0.2,
        Thickness = 0.5
    }):Play()
    TweenService:Create(Icon, TweenInfo.new(0.2), {
        Size = UDim2.new(0.7, 0, 0.7, 0),
        Position = UDim2.new(0.15, 0, 0.15, 0)
    }):Play()
end)

-- Return module API (Compatible with your script pattern)
return {
    ToggleGui = ToggleGui,
    IconButton = IconButton,
    
    -- Customization methods
    SetIcon = function(assetId)
        Icon.Image = assetId
    end,
    
    SetColor = function(color)
        IconStroke.Color = color
    end,
    
    SetPosition = function(position)
        IconButton.Position = position
    end,
    
    -- Callback system (PRIMARY METHOD - Used by your script)
    SetCallback = function(callback)
        ToggleCallback = callback
    end,
    
    -- State management (state = true means Minimized/Hidden)
    SetState = function(state)
        uiVisible = not state -- Invert: if minimized (true), UI is not visible (false)
        -- Update visual state: Minimized = darker, Visible = normal
        TweenService:Create(IconButton, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(20, 20, 25)
        }):Play()
    end,
    
    -- Manual toggle method (Fallback)
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

        local mainUI = game:GetService("CoreGui"):FindFirstChild("ChaLarmHub")
        if mainUI then
            uiVisible = not uiVisible
            mainUI.Enabled = uiVisible
        else
            warn("No Toggle Callback set and 'ChaLarmHub' not found.")
        end
    end
}
