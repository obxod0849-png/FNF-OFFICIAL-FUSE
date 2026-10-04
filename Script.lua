-- Надежный мобильный Pro Hub для Funky Friday v3.0
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый гуи, если он был
if playerGui:FindFirstChild("FF_ProHubV3") then
    playerGui.FF_ProHubV3:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FF_ProHubV3"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ==================== ПЛАВАЮЩАЯ ИКОНКА (СЕНСОРНОЕ ПЕРЕЩИСЛЕНИЕ) ====================
local icon = Instance.new("TextButton")
icon.Name = "FloatingIcon"
icon.Size = UDim2.new(0, 55, 0, 55)
icon.Position = UDim2.new(0, 30, 0, 100) -- Гарантированно на видном месте слева
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
icon.Text = "FNF"
icon.TextColor3 = Color3.fromRGB(0, 255, 170)
icon.TextSize = 16
icon.Font = Enum.Font.GothamBold
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(0, 255, 170)
iconStroke.Thickness = 2.5
iconStroke.Parent = icon

-- ==================== ГЛАВНОЕ ОКНО МЕНЮ ====================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 300, 0, 360)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Скрыто до нажатия на иконку
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 80)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Шапка окна
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topBar.Parent = topBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Funky Friday | Pro Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = topBar

-- Кнопка закрытия (крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Логика переключения видимости меню по иконке
local isOpen = false
icon.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

closeBtn.MouseButton1Click:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)

-- ==================== НАДЕЖНОЕ ПЕРЕТАСКИВАНИЕ ПАЛЬЦЕМ (DRAG) ====================
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Применяем перетаскивание на иконку и на само окно
makeDraggable(icon)
makeDraggable(mainFrame)

-- ==================== КНОПКИ И НАСТРОЙКИ ВНУТРИ МЕНЮ ====================
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 52)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 260)
container.ScrollBarThickness = 3
container.Parent = mainFrame

local FF_Settings = {
    AutoPlay = false,
    Accuracy = 100,
    OnlyBad = false
}

-- Функция создания переключателей
local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    btn.Text = ""
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
    lbl.Parent = btn

    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 20, 0, 20)
    ind.Position = UDim2.new(1, -28, 0.5, -10)
    ind.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    ind.Parent = btn

    local indC = Instance.new("UICorner")
    indC.CornerRadius = UDim.new(1, 0)
    indC.Parent = ind

    local state = false
    btn.MouseButton1Click:Connect(function()
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

-- Переключатели
createToggle("Режим 'Только Bad'", 0, function(state)
    FF_Settings.OnlyBad = state
end)

createToggle("Auto-Play (Автоигра)", 52, function(state)
    FF_Settings.AutoPlay = state
end)

-- Кнопка Accuracy
local accBtn = Instance.new("TextButton")
accBtn.Size = UDim2.new(1, 0, 0, 45)
accBtn.Position = UDim2.new(0, 0, 0, 104)
accBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
accBtn.Text = ""
accBtn.Parent = container

local accC = Instance.new("UICorner")
accC.CornerRadius = UDim.new(0, 8)
accC.Parent = accBtn

local accLbl = Instance.new("TextLabel")
accLbl.Size = UDim2.new(1, -20, 1, 0)
accLbl.Position = UDim2.new(0, 12, 0, 0)
accLbl.BackgroundTransparency = 1
accLbl.Text = "Точность: 100%"
accLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
accLbl.TextSize = 13
accLbl.Font = Enum.Font.GothamSemibold
accLbl.TextXAlignment = Enum.TextXAlignment.Left
accLbl.Parent = accBtn

local levels = {100, 75, 50, 25, 1}
local idx = 1
accBtn.MouseButton1Click:Connect(function()
    idx = idx + 1
    if idx > #levels then idx = 1 end
    FF_Settings.Accuracy = levels[idx]
    accLbl.Text = "Точность: " .. FF_Settings.Accuracy .. "%"
end)

-- Кнопка выгрузки скрипта
local unlBtn = Instance.new("TextButton")
unlBtn.Size = UDim2.new(1, 0, 0, 42)
unlBtn.Position = UDim2.new(0, 0, 0, 165)
unlBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 25)
unlBtn.Text = "Закрыть / Выгрузить"
unlBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
unlBtn.TextSize = 13
unlBtn.Font = Enum.Font.GothamBold
unlBtn.Parent = container

local unlC = Instance.new("UICorner")
unlC.CornerRadius = UDim.new(0, 8)
unlC.Parent = unlBtn

unlBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Фоновая логика
task.spawn(function()
    while true do
        task.wait(0.05)
        if FF_Settings.AutoPlay then
            pcall(function()
                local acc = FF_Settings.Accuracy
                if FF_Settings.OnlyBad then
                    acc = math.clamp(acc, 1, 30)
                end
                -- Логика обработки нот
            end)
        end
    end
end)

print("Pro Hub v3 загружен!")
