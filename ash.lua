
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

return function(ToggleCallback)
    local ICON_IMAGE = "rbxassetid://96083355749736"
    local ICON_SIZE = 50
    local ICON_POSITION = UDim2.new(0, 20, 0, 100) -- Below Roblox Logo
    
    local Main = Instance.new("ScreenGui")
    Main.Name = "AxelHub_Toggle"
    Main.Parent = CoreGui
    Main.ResetOnSpawn = false
    
    local Button = Instance.new("ImageButton")
    Button.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
    Button.Position = ICON_POSITION
    Button.BackgroundTransparency = 1
    Button.Image = ""
    Button.Active = true
    Button.Parent = Main
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Button
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = ICON_IMAGE
    Icon.ImageTransparency = 0.1
    Icon.Parent = Button
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 15, 1, 15)
    Shadow.Position = UDim2.new(0, -7.5, 0, -7.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = 0
    Shadow.Parent = Button

    -- Dragging Logic
    local dragging = false
    local dragInput, mousePos, framePos
    local hasDragged = false

    local function update(input)
        local delta = input.Position - mousePos
        local newPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        TweenService:Create(Button, TweenInfo.new(0.1), {Position = newPos}):Play()
        hasDragged = true
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = Button.Position
            hasDragged = false
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    Button.MouseButton1Click:Connect(function()
        if not hasDragged and ToggleCallback then
            ToggleCallback()
            -- Add a small "pop" effect
            TweenService:Create(Icon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0.8, 0, 0.8, 0)}):Play()
            task.wait(0.2)
            TweenService:Create(Icon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        end
    end)
    
    return Main
end
