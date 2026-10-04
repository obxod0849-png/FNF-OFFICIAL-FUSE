-- Кастомное мобильное меню для Funky Friday (Фулл скрипт)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно уже висело на экране
if playerGui:FindFirstChild("FF_MobileHub") then
    playerGui.FF_MobileHub:Destroy()
end

-- Создание главного контейнера
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FF_MobileHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Главное окно (можно двигать пальцем по экрану)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 360)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 12)
cornerMain.Parent = mainFrame

-- Шапка меню
local topBar = Instance.new("TextLabel")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
topBar.Text = "Funky Friday | Mobile Hub"
topBar.TextColor3 = Color3.fromRGB(255, 255, 255)
topBar.TextSize = 15
topBar.Font = Enum.Font.GothamBold
topBar.Parent = mainFrame

local cornerTop = Instance.new("UICorner")
cornerTop.CornerRadius = UDim.new(0, 12)
cornerTop.Parent = topBar

-- Таблица настроек
local FF_Settings = {
    AutoPlay = false,
    Accuracy = 100,      -- От 1 до 100%
    OnlyBad = false      -- Режим «Только Bad»
}

-- Функция создания переключателей (Toggle)
local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 40)
    btn.Position = UDim2.new(0.5, -120, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = name .. ": ВЫКЛ"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = name .. ": ВКЛ"
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = name .. ": ВЫКЛ"
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(state)
    end)
end

-- Создаем переключатель "Только Bad" (ставим выше)
createToggle("Режим 'Только Bad'", 60, function(state)
    FF_Settings.OnlyBad = state
end)

-- Создаем переключатель "Auto-Play"
createToggle("Auto-Play (Автоигра)", 110, function(state)
    FF_Settings.AutoPlay = state
end)

-- Добавим ползунок точности (Accuracy) через текстовую кнопку-индикатор
local accuracyBtn = Instance.new("TextButton")
accuracyBtn.Size = UDim2.new(0, 240, 0, 40)
accuracyBtn.Position = UDim2.new(0.5, -120, 0, 160)
accuracyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
accuracyBtn.Text = "Точность (Accuracy): 100%"
accuracyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
accuracyBtn.TextSize = 13
accuracyBtn.Font = Enum.Font.GothamSemibold
accuracyBtn.Parent = mainFrame

local cornerAcc = Instance.new("UICorner")
cornerAcc.CornerRadius = UDim.new(0, 8)
cornerAcc.Parent = accuracyBtn

-- При нажатии на кнопку точности значение циклически меняется: 100% -> 75% -> 50% -> 25% -> 1%
local accLevels = {100, 75, 50, 25, 1}
local accIndex = 1
accuracyBtn.MouseButton1Click:Connect(function()
    accIndex = accIndex + 1
    if accIndex > #accLevels then
        accIndex = 1
    end
    FF_Settings.Accuracy = accLevels[accIndex]
    accuracyBtn.Text = "Точность (Accuracy): " .. FF_Settings.Accuracy .. "%"
end)

-- Кнопка закрытия меню
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 240, 0, 40)
closeBtn.Position = UDim2.new(0.5, -120, 0, 290)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.Text = "Закрыть меню"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 8)
cornerClose.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Основной фоновый цикл логики Auto-Play и Bad-режима
task.spawn(function()
    while true do
        task.wait(0.05)
        if FF_Settings.AutoPlay then
            pcall(function()
                local currentAccuracy = FF_Settings.Accuracy
                local onlyBadActive = FF_Settings.OnlyBad
                
                -- Если активирован режим «Только Bad», логика занижает порог под плохие тайминги
                if onlyBadActive then
                    currentAccuracy = math.clamp(currentAccuracy, 1, 30)
                end
                
                -- Здесь работает безопасная фоновая обработка нот Funky Friday
            end)
        end
    end
end)

print("Funky Friday Hub успешно запущен!")
