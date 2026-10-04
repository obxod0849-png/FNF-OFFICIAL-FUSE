-- Продвинутый мобильный интерфейс для Funky Friday v2.0
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старое меню, если уже было запущено
if playerGui:FindFirstChild("FF_AdvancedHub") then
    playerGui.FF_AdvancedHub:Destroy()
end

-- Главный контейнер
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FF_AdvancedHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ==================== ПЛАВАЮЩАЯ ИКОНКА ОТКРЫТИЯ/ЗАКРЫТИЯ ====================
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.4, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
toggleButton.Text = "FNF"
toggleButton.TextColor3 = Color3.fromRGB(0, 255, 170)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Active = true
toggleButton.Draggable = true -- Иконку можно таскать пальцем по экрану!
toggleButton.Parent = screenGui

local cornerToggle = Instance.new("UICorner")
cornerToggle.CornerRadius = UDim.new(1, 0) -- Делаем круглой
cornerToggle.Parent = toggleButton

local strokeToggle = Instance.new("UIStroke")
strokeToggle.Color = Color3.fromRGB(0, 255, 170)
strokeToggle.Thickness = 2
strokeToggle.Parent = toggleButton

-- ==================== ГЛАВНОЕ ОКНО МЕНЮ ====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 380)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Скрыто по умолчанию, открывается по иконке
mainFrame.Active = true
mainFrame.Draggable = true -- Меню тоже двигается пальцем
mainFrame.Parent = screenGui

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 16)
cornerMain.Parent = mainFrame

local strokeMain = Instance.new("UIStroke")
strokeMain.Color = Color3.fromRGB(45, 45, 70)
strokeMain.Thickness = 1.5
strokeMain.Parent = mainFrame

-- Шапка окна
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local cornerTop = Instance.new("UICorner")
cornerTop.CornerRadius = UDim.new(0, 16)
cornerTop.Parent = topBar

-- Исправление скругления нижней части шапки
local fixTop = Instance.new("Frame")
fixTop.Size = UDim2.new(1, 0, 0, 10)
fixTop.Position = UDim2.new(0, 0, 1, -10)
fixTop.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
fixTop.BorderSizePixel = 0
fixTop.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Funky Friday | Pro Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Кнопка закрытия крестиком в углу
local closeXBtn = Instance.new("TextButton")
closeXBtn.Size = UDim2.new(0, 30, 0, 30)
closeXBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeXBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
closeXBtn.Text = "✕"
closeXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeXBtn.TextSize = 14
closeXBtn.Font = Enum.Font.GothamBold
closeXBtn.Parent = topBar

local cornerCloseX = Instance.new("UICorner")
cornerCloseX.CornerRadius = UDim.new(0, 8)
cornerCloseX.Parent = closeXBtn

-- Логика открытия/закрытия по клику на иконку и крестик
local isOpen = false
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

closeXBtn.MouseButton1Click:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)

-- Контейнер для кнопок (скролл или обычный ряд)
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 320)
container.ScrollBarThickness = 4
container.Parent = mainFrame

-- Таблица настроек бота
local FF_Settings = {
    AutoPlay = false,
    Accuracy = 100,
    OnlyBad = false
}

-- Функция создания красивых переключателей
local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    btn.Text = ""
    btn.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 24, 0, 24)
    statusIndicator.Position = UDim2.new(1, -35, 0.5, -12)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    statusIndicator.Parent = btn

    local cornerIndicator = Instance.new("UICorner")
    cornerIndicator.CornerRadius = UDim.new(1, 0)
    cornerIndicator.Parent = statusIndicator

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
            btn.BackgroundColor3 = Color3.fromRGB(25, 45, 40)
        else
            statusIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
        end
        callback(state)
    end)
end

-- Создаем переключатель "Только Bad"
createToggle("Режим 'Только Bad'", 0, function(state)
    FF_Settings.OnlyBad = state
end)

-- Создаем переключатель "Auto-Play"
createToggle("Auto-Play (Автоигра)", 60, function(state)
    FF_Settings.AutoPlay = state
end)

-- Кнопка точной настройки Accuracy
local accBtn = Instance.new("TextButton")
accBtn.Size = UDim2.new(1, 0, 0, 48)
accBtn.Position = UDim2.new(0, 0, 0, 120)
accBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
accBtn.Text = ""
accBtn.Parent = container

local cornerAcc = Instance.new("UICorner")
cornerAcc.CornerRadius = UDim.new(0, 10)
cornerAcc.Parent = accBtn

local accLabel = Instance.new("TextLabel")
accLabel.Size = UDim2.new(1, -20, 1, 0)
accLabel.Position = UDim2.new(0, 15, 0, 0)
accLabel.BackgroundTransparency = 1
accLabel.Text = "Точность (Accuracy): 100%"
accLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
accLabel.TextSize = 14
accLabel.Font = Enum.Font.GothamSemibold
accLabel.TextXAlignment = Enum.TextXAlignment.Left
accLabel.Parent = accBtn

local accLevels = {100, 75, 50, 25, 1}
local accIndex = 1
accBtn.MouseButton1Click:Connect(function()
    accIndex = accIndex + 1
    if accIndex > #accLevels then accIndex = 1 end
    FF_Settings.Accuracy = accLevels[accIndex]
    accLabel.Text = "Точность (Accuracy): " .. FF_Settings.Accuracy .. "%"
end)

-- Кнопка полного закрытия / выгрузки хуба
local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, 0, 0, 45)
unloadBtn.Position = UDim2.new(0, 0, 0, 190)
unloadBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 30)
unloadBtn.Text = "Выгрузить скрипт"
unloadBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
unloadBtn.TextSize = 14
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.Parent = container

local cornerUnload = Instance.new("UICorner")
cornerUnload.CornerRadius = UDim.new(0, 10)
cornerUnload.Parent = unloadBtn

unloadBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================== ФОНОВАЯ ЛОГИКА АВТОИГРЫ ====================
task.spawn(function()
    while true do
        task.wait(0.05)
        if FF_Settings.AutoPlay then
            pcall(function()
                local currentAcc = FF_Settings.Accuracy
                if FF_Settings.OnlyBad then
                    currentAcc = math.clamp(currentAcc, 1, 30)
                end
                -- Логика обработки нот Funky Friday с учетом выбранных параметров
            end)
        end
    end
end)

print("Pro Hub успешно инициализирован!")
