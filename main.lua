-- HUMBLE HUB V8 (FULL PRO)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 320)
Main.Position = UDim2.new(0.5,-210,0.5,-160)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- DRAG MAIN
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- TABS
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(1,0,0,40)
Tabs.BackgroundColor3 = Color3.fromRGB(20,20,20)

local function createTab(name, x)
    local b = Instance.new("TextButton", Tabs)
    b.Size = UDim2.new(0,120,1,0)
    b.Position = UDim2.new(0,x,0,0)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

local HomeTab = createTab("Home",0)
local PlayerTab = createTab("Player",120)
local MiscTab = createTab("Misc",240)

-- PAGES
local function createPage()
    local p = Instance.new("ScrollingFrame", Main)
    p.Size = UDim2.new(1,0,1,-40)
    p.Position = UDim2.new(0,0,0,40)
    p.CanvasSize = UDim2.new(0,0,0,800)
    p.ScrollBarThickness = 6
    p.Visible = false
    return p
end

local HomePage = createPage()
local PlayerPage = createPage()
local MiscPage = createPage()
HomePage.Visible = true

local function switch(p)
    HomePage.Visible = false
    PlayerPage.Visible = false
    MiscPage.Visible = false
    p.Visible = true
end

HomeTab.MouseButton1Click:Connect(function() switch(HomePage) end)
PlayerTab.MouseButton1Click:Connect(function() switch(PlayerPage) end)
MiscTab.MouseButton1Click:Connect(function() switch(MiscPage) end)

-- TOGGLE
local function createToggle(parent,text,y,callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.9,0,0,40)
    f.Position = UDim2.new(0.05,0,0,y)
    f.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6,0,1,0)
    l.Text = text
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1,1,1)

    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0,60,0,25)
    b.Position = UDim2.new(0.7,0,0.2,0)
    b.Text = "OFF"

    local state = false

    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- DRAG BUTTON SYSTEM
local function createDraggableButton(text, callback)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = UDim2.new(0,120,0,40)
    btn.Position = UDim2.new(0.5,-60,0.5,-20)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)

    local dragging = false
    local dragStart, startPos

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- RAINBOW
local rainbow = false
local function startRainbow()
    task.spawn(function()
        while rainbow do
            for i=0,1,0.01 do
                if not rainbow then break end
                Main.BackgroundColor3 = Color3.fromHSV(i,1,1)
                task.wait(0.05)
            end
        end
    end)
end

-- ===== HOME TAB =====
createToggle(HomePage,"Rainbow UI",0,function(state)
    rainbow = state
    if state then startRainbow()
    else Main.BackgroundColor3 = Color3.fromRGB(30,30,30) end
end)

-- ===== DRAG BUTTON FEATURES =====

-- SPIN BUTTON
local spinBtn
local spinning = false

createToggle(HomePage,"Spin Button",60,function(state)
    if state then
        spinBtn = createDraggableButton("SPIN", function()
            spinning = not spinning
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if spinning then
                task.spawn(function()
                    while spinning and hrp do
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(20), 0)
                        task.wait(0.05)
                    end
                end)
            end
        end)
    else
        spinning = false
        if spinBtn then spinBtn:Destroy() end
    end
end)

-- FOLLOW BUTTON
local followBtn
local following = false

createToggle(HomePage,"Follow Player Button",120,function(state)
    if state then
        followBtn = create
