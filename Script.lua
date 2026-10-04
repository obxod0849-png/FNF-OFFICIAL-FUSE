-- Pro Hub v17 (Direct Hook & Node Interceptor Engine)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("FF_ProHubV17") then
    CoreGui.FF_ProHubV17:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FF_ProHubV17"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- ==================== ПЛАВАЮЩАЯ ИКОНКА ====================
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 40, 0, 150)
icon.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
icon.Text = "FNF"
icon.TextColor3 = Color3.fromRGB(0, 255, 170)
icon.TextSize = 18
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 999
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(0, 255, 170)
iconStroke.Thickness = 3
iconStroke.Parent = icon

-- ==================== ГЛАВНОЕ ОКНО МЕНЮ ====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 390)
mainFrame.Position = UDim2.new(0.5, -155, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.ZIndex = 1000
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 120)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Шапка окна
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
topBar.BorderSizePixel = 0
topBar.ZIndex = 1001
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Funky Friday | Pro Engine v17"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 1002
titleText.Parent = topBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 1002
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local isOpen = true
icon.Activated:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

closeBtn.Activated:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)

-- Перетаскивание иконки
local dragging, dragInput, dragStart, startPos
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = icon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

icon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== КОНТЕЙНЕР НАСТРОЕК ====================
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 52)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 300)
container.ScrollBarThickness = 3
container.ZIndex = 1001
container.Parent = mainFrame

local FF_Settings = {
    AutoPlay = false,
    Accuracy = 100,
    OnlyBad = false
}

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    btn.Text = ""
    btn.ZIndex = 1002
    btn.Parent = container

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -55, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 1003
    lbl.Parent = btn

    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 20, 0, 20)
    ind.Position = UDim2.new(1, -28, 0.5, -10)
    ind.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    ind.ZIndex = 1003
    ind.Parent = btn

    local indC = Instance.new("UICorner")
    indC.CornerRadius = UDim.new(1, 0)
    indC.Parent = ind

    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then
            ind.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
            btn.BackgroundColor3 = Color3.fromRGB(20, 40, 35)
        else
            ind.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
        end
        callback(state)
    end)
end

createToggle("Режим 'Только Bad'", 0, function(state)
    FF_Settings.OnlyBad = state
end)

createToggle("Auto-Play (Автоигра)", 52, function(state)
    FF_Settings.AutoPlay = state
end)

-- Поле ввода Accuracy
local accContainer = Instance.new("Frame")
accContainer.Size = UDim2.new(1, 0, 0, 45)
accContainer.Position = UDim2.new(0, 0, 0, 104)
accContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
accContainer.ZIndex = 1002
accContainer.Parent = container

local accC = Instance.new("UICorner")
accC.CornerRadius = UDim.new(0, 8)
accC.Parent = accContainer

local accLbl = Instance.new("TextLabel")
accLbl.Size = UDim2.new(0.6, 0, 1, 0)
accLbl.Position = UDim2.new(0, 12, 0, 0)
accLbl.BackgroundTransparency = 1
accLbl.Text = "Точность (%):"
accLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
accLbl.TextSize = 13
accLbl.Font = Enum.Font.GothamSemibold
accLbl.TextXAlignment = Enum.TextXAlignment.Left
accLbl.ZIndex = 1003
accLbl.Parent = accContainer

local accBox = Instance.new("TextBox")
accBox.Size = UDim2.new(0, 70, 0, 30)
accBox.Position = UDim2.new(1, -78, 0.5, -15)
accBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
accBox.Text = "100"
accBox.TextColor3 = Color3.fromRGB(0, 255, 170)
accBox.TextSize = 14
accBox.Font = Enum.Font.GothamBold
accBox.ZIndex = 1003
accBox.Parent = accContainer

local boxC = Instance.new("UICorner")
boxC.CornerRadius = UDim.new(0, 6)
boxC.Parent = accBox

accBox.FocusLost:Connect(function()
    local num = tonumber(accBox.Text)
    if num then
        FF_Settings.Accuracy = math.clamp(num, 1, 100)
        accBox.Text = tostring(FF_Settings.Accuracy)
    else
        accBox.Text = tostring(FF_Settings.Accuracy)
    end
end)

-- Кнопка выгрузки
local unlBtn = Instance.new("TextButton")
unlBtn.Size = UDim2.new(1, 0, 0, 42)
unlBtn.Position = UDim2.new(0, 0, 0, 165)
unlBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 25)
unlBtn.Text = "Закрыть / Выгрузить"
unlBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
unlBtn.TextSize = 13
unlBtn.Font = Enum.Font.GothamBold
unlBtn.ZIndex = 1002
unlBtn.Parent = container

local unlC = Instance.new("UICorner")
unlC.CornerRadius = UDim.new(0, 8)
unlC.Parent = unlBtn

unlBtn.Activated:Connect(function()
    screenGui:Destroy()
end)

-- ==================== ИСПРАВЛЕННЫЙ ДВИЖОК V17 ====================
task.spawn(function()
    local keys = {Enum.KeyCode.D, Enum.KeyCode.F, Enum.KeyCode.J, Enum.KeyCode.K}

    while true do
        task.wait(0.01)
        if FF_Settings.AutoPlay then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if not pg then return end

                -- Прямой перебор интерфейса игры для поиска нот
                for _, v in ipairs(pg:GetDescendants()) do
                    if v:IsA("GuiObject") and v.Visible then
                        local name = v.Name:lower()
                        -- Если это нота или стрелка интерфейса ритм-игры
                        if name:find("note") or name:find("arrow") or name:find("receptor") then
                            
                            -- Вычисляем шанс срабатывания на основе Accuracy
                            if math.random(1, 100) <= FF_Settings.Accuracy then
                                local keyIndex = math.random(1, 4)
                                if name:find("left") then keyIndex = 1
                                elseif name:find("down") then keyIndex = 2
                                elseif name:find("up") then keyIndex = 3
                                elseif name:find("right") then keyIndex = 4 end

                                local targetKey = keys[keyIndex]
                                
                                -- Режим "Только Bad": делаем искусственную задержку перед нажатием
                                if FF_Settings.OnlyBad then
                                    task.wait(0.09) -- Задержка смещает тайминг в категорию Bad/Meh
                                end

                                -- Симуляция нажатия через UserInputService / VirtualInputManager
                                pcall(function()
                                    VirtualInputManager:SendKeyEvent(true, targetKey, false, game)
                                    task.wait(0.01)
                                    VirtualInputManager:SendKeyEvent(false, targetKey, false, game)
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("Pro Hub v17 запущен и готов к работе.")
