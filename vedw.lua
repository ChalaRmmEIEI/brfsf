local NotifyIcon = "rbxassetid://90325619807419"

-- Custom Notification System
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "ChaLarmNotify"
NotifGui.Parent = game:GetService("CoreGui")
NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "Container"
NotifContainer.Position = UDim2.new(1, -10, 1, -50) -- Closer to right edge
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Size = UDim2.new(0, 235, 0.8, 0) -- 235px width
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = NotifContainer
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIList.Padding = UDim.new(0, 12)

local TweenService = game:GetService("TweenService")

local function Notify(title, content, duration, image)
    duration = duration or 3
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 65) -- 65px height
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = NotifContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12) -- Back to 12px rounded
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 90) -- Start gray
    stroke.Thickness = 1.5
    stroke.Transparency = 1
    stroke.Parent = frame
    
    local iconGlow = Instance.new("ImageLabel")
    iconGlow.Size = UDim2.new(0, 60, 0, 60)
    iconGlow.Position = UDim2.new(0, 12, 0.5, -30)
    iconGlow.BackgroundTransparency = 1
    iconGlow.Image = image or NotifyIcon
    iconGlow.ImageColor3 = Color3.fromRGB(127, 0, 255) -- Purple glow
    iconGlow.ImageTransparency = 1
    iconGlow.ScaleType = Enum.ScaleType.Fit
    iconGlow.ZIndex = 1
    iconGlow.Parent = frame
    
    local iconGlowCorner = Instance.new("UICorner")
    iconGlowCorner.CornerRadius = UDim.new(0, 12)
    iconGlowCorner.Parent = iconGlow
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 17, 0.5, -25)
    icon.BackgroundTransparency = 1
    icon.Image = image or NotifyIcon
    icon.ImageTransparency = 1
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 2
    icon.Parent = frame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 10)
    iconCorner.Parent = icon

    local tLabel = Instance.new("TextLabel")
    tLabel.Position = UDim2.new(0, 80, 0, 8)
    tLabel.Size = UDim2.new(1, -90, 0, 22)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = Color3.fromRGB(200, 150, 255) -- Soft purple to match theme
    tLabel.TextSize = 15
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.TextTransparency = 1
    tLabel.TextTruncate = Enum.TextTruncate.AtEnd
    tLabel.TextScaled = true -- Auto-size text
    tLabel.Parent = frame
    
    local cLabel = Instance.new("TextLabel")
    cLabel.Position = UDim2.new(0, 80, 0, 32)
    cLabel.Size = UDim2.new(1, -90, 0, 26)
    cLabel.BackgroundTransparency = 1
    cLabel.Text = content
    cLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    cLabel.TextSize = 13
    cLabel.Font = Enum.Font.Gotham
    cLabel.TextXAlignment = Enum.TextXAlignment.Left
    cLabel.TextYAlignment = Enum.TextYAlignment.Top
    cLabel.TextTransparency = 1
    cLabel.TextWrapped = true
    cLabel.TextScaled = true -- Auto-size text
    cLabel.Parent = frame
    
    -- Ultra-smooth entrance animation
    frame.Position = UDim2.new(1, 50, 0, 0)
    frame.Size = UDim2.new(0.9, 0, 0, 58) -- Start at 90% of 65px
    
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Rotation = -15
    
    -- Text starts off-position for slide-in effect
    tLabel.Position = UDim2.new(0, 60, 0, 8) -- Start 20px to the left
    cLabel.Position = UDim2.new(0, 100, 0, 32) -- Start 20px to the right
    
    local slideInfo = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    local bounceInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local shimmerInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local textSlideInfo = TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    
    TweenService:Create(frame, slideInfo, {
        BackgroundTransparency = 0.15, -- More transparent
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 65) -- Scale to 65px
    }):Play()
    
    TweenService:Create(stroke, slideInfo, {Transparency = 0}):Play()
    TweenService:Create(iconGlow, slideInfo, {ImageTransparency = 0.7}):Play()
    TweenService:Create(icon, slideInfo, {ImageTransparency = 0}):Play()
    
    -- Text fade in + slide in
    TweenService:Create(tLabel, textSlideInfo, {
        TextTransparency = 0,
        Position = UDim2.new(0, 80, 0, 8) -- Slide to final position
    }):Play()
    
    TweenService:Create(cLabel, textSlideInfo, {
        TextTransparency = 0,
        Position = UDim2.new(0, 80, 0, 32) -- Slide to final position
    }):Play()
    
    TweenService:Create(icon, bounceInfo, {
        Size = UDim2.new(0, 50, 0, 50),
        Rotation = 0
    }):Play()
    
    -- Shimmer to bright purple
    TweenService:Create(stroke, shimmerInfo, {
        Color = Color3.fromRGB(127, 0, 255)
    }):Play()
    
    task.spawn(function()
        while frame.Parent do
            TweenService:Create(iconGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.85
            }):Play()
            task.wait(1.5)
            if not frame.Parent then break end
            TweenService:Create(iconGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.7
            }):Play()
            task.wait(1.5)
        end
    end)
    
    task.delay(duration, function()
        if not frame.Parent then return end
        
        local outInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
        
        TweenService:Create(frame, outInfo, {
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 50, 0, 0)
        }):Play()
        
        TweenService:Create(stroke, outInfo, {Transparency = 1}):Play()
        TweenService:Create(icon, outInfo, {ImageTransparency = 1}):Play()
        TweenService:Create(iconGlow, outInfo, {ImageTransparency = 1}):Play()
        TweenService:Create(tLabel, outInfo, {TextTransparency = 1}):Play()
        TweenService:Create(cLabel, outInfo, {TextTransparency = 1}):Play()
        
        task.wait(0.6)
        frame:Destroy()
    end)
end

-- Return for module usage
return Notify
