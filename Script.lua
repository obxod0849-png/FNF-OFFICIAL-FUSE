-- Надежный Pro Hub v5 через CoreGui для Delta (Телефон)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Удаляем старый интерфейс, если он остался в CoreGui
if CoreGui:FindFirstChild("FF_ProHubV5") then
    CoreGui.FF_ProHubV5:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FF_ProHubV5"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui -- Используем CoreGui, чтобы эксплойт не блокировал касания

-- ==================== ПЛАВАЮЩАЯ ИКОНКА ====================
local icon = Instance.new("TextButton")
icon.Name = "FloatingIcon"
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 40, 0, 150)
icon.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
icon.Text = "FNF"
icon.TextColor3 = Color3.fromRGB(0, 255, 170)
icon.TextSize = 18
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 999 -- Поверх абсолютно всех элементов игры
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
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 300, 0, 360)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true -- Открыто сразу, чтобы ты видел результат
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
titleText.Text = "Funky Friday | CoreGui Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 1002
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
closeBtn.ZIndex = 1002
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Железобетонное переключение видимости через TouchTap / Activated
local isOpen = true
icon.Activated:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

closeBtn.Activated:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)

-- Плавное перетаскивание пальцем для иконки
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
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
container.CanvasSize = UDim2.new(0, 0, 0, 260)
container.ScrollBarThickness = 3
container.ZIndex = 1001
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

-- Кнопка Accuracy
local accBtn = Instance.new("TextButton")
accBtn.Size = UDim2.new(1, 0, 0, 45)
accBtn.Position = UDim2.new(0, 0, 0, 104)
accBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
accBtn.Text = ""
accBtn.ZIndex = 1002
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
accLbl.ZIndex = 1003
accLbl.Parent = accBtn

local levels = {100, 75, 50, 25, 1}
local idx = 1
accBtn.Activated:Connect(function()
    idx = idx + 1
    if idx > #levels then idx = 1 end
    FF_Settings.Accuracy = levels[idx]
    accLbl.Text = "Точность: " .. FF_Settings.Accuracy .. "%"
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

print("CoreGui Hub успешно запущен!")
