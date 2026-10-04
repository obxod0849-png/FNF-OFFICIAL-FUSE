-- PRO HUB v18: GOD MODE (Visual Tracking Engine)
-- The Ultimate Funky Friday Bypass
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- Защита от дубликатов интерфейса
if CoreGui:FindFirstChild("FF_ProHubV18") then
    CoreGui.FF_ProHubV18:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FF_ProHubV18"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- ==================== ИНТЕРФЕЙС (UI) ====================
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 40, 0, 150)
icon.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
icon.Text = "V18"
icon.TextColor3 = Color3.fromRGB(255, 50, 50)
icon.TextSize = 22
icon.Font = Enum.Font.GothamBlack
icon.ZIndex = 999
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(255, 50, 50)
iconStroke.Thickness = 3

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 390)
mainFrame.Position = UDim2.new(0.5, -155, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 1000
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 120)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "PRO ENGINE V18 | GOD MODE"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local isOpen = false
icon.Activated:Connect(function() isOpen = not isOpen; mainFrame.Visible = isOpen end)
closeBtn.Activated:Connect(function() isOpen = false; mainFrame.Visible = false end)

-- Перетаскивание иконки
local dragInput, dragStart, startPos, dragging
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = icon.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
icon.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Настройки
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 52)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 300)
container.ScrollBarThickness = 3
container.Parent = mainFrame

local FF_Settings = { AutoPlay = false, Accuracy = 100, OnlyBad = false }

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 45); btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38); btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -55, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 13; lbl.Font = Enum.Font.GothamSemibold; lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0, 20, 0, 20); ind.Position = UDim2.new(1, -28, 0.5, -10)
    ind.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    
    local state = false
    btn.Activated:Connect(function()
        state = not state
        ind.BackgroundColor3 = state and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 50, 70)
        callback(state)
    end)
end

createToggle("Режим 'Только Bad'", 0, function(s) FF_Settings.OnlyBad = s end)
createToggle("Auto-Play (Искусственный Интеллект)", 52, function(s) FF_Settings.AutoPlay = s end)

local accBox = Instance.new("TextBox", container)
accBox.Size = UDim2.new(1, 0, 0, 45); accBox.Position = UDim2.new(0, 0, 0, 104)
accBox.BackgroundColor3 = Color3.fromRGB(25, 25, 38); accBox.Text = "Точность (%): 100"
accBox.TextColor3 = Color3.fromRGB(220, 220, 220); accBox.Font = Enum.Font.GothamBold
Instance.new("UICorner", accBox).CornerRadius = UDim.new(0, 8)
accBox.FocusLost:Connect(function()
    local num = tonumber(accBox.Text:match("%d+"))
    if num then FF_Settings.Accuracy = math.clamp(num, 1, 100) end
    accBox.Text = "Точность (%): " .. tostring(FF_Settings.Accuracy)
end)

-- ==================== V18 AI ENGINE (ВИЗУАЛЬНАЯ МАТЕМАТИКА) ====================
local ProcessedNotes = {} -- Хранилище обработанных нот (чтобы не спамить 1 клавишу)
local Keys = {Enum.KeyCode.D, Enum.KeyCode.F, Enum.KeyCode.J, Enum.KeyCode.K} -- Лево, Низ, Верх, Право

-- Универсальная функция нажатия (работает на всех мобильных и ПК эксплойтах)
local function PressKey(keyCode)
    task.spawn(function()
        if keypress then -- Если эксплойт поддерживает прямое нажатие (надежнее)
            keypress(keyCode.Value)
            task.wait(0.03)
            keyrelease(keyCode.Value)
        else -- Фолбэк через VirtualInputManager
            VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
            task.wait(0.03)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        end
    end)
end

-- Функция отслеживания одной конкретной ноты
local function TrackNoteAndHit(noteGui)
    local targetLane = 1
    -- Определяем линию ноты по ее имени или позиции
    local name = noteGui.Name:lower()
    if name:match("left") or name:match("0") then targetLane = 1
    elseif name:match("down") or name:match("1") then targetLane = 2
    elseif name:match("up") or name:match("2") then targetLane = 3
    elseif name:match("right") or name:match("3") then targetLane = 4
    else targetLane = math.random(1, 4) end

    local targetKey = Keys[targetLane]
    local connection
    
    -- Привязываем слежение к рендеру кадров для максимальной точности
    connection = RunService.RenderStepped:Connect(function()
        if not FF_Settings.AutoPlay then return end
        
        -- Если нота пропала (уже нажали или пропустили) - отключаем слежение
        if not noteGui or not noteGui.Parent then
            connection:Disconnect()
            return
        end

        local noteY = noteGui.AbsolutePosition.Y
        -- Ищем Рецептор (зону удара). Обычно рецепторы висят на высоте ~100 или внизу экрана.
        -- В FF Y-центр рецептора для игрока примерно известен. Будем считать расстояние:
        -- (Это защита, если игра скрывает рецепторы. По умолчанию берем зону ~150px от края)
        local hitZoneY = 120 
        
        -- Попытка найти реальный рецептор на экране (для идеальной математики)
        local pg = player:FindFirstChild("PlayerGui")
        if pg then
            for _, v in pairs(pg:GetDescendants()) do
                if v:IsA("GuiObject") and (v.Name:lower():match("receptor") or v.Name:lower():match("strum")) then
                    hitZoneY = v.AbsolutePosition.Y
                    break
                end
            end
        end

        local distance = math.abs(noteY - hitZoneY)

        -- ЛОГИКА "ТОЛЬКО BAD"
        if FF_Settings.OnlyBad then
            -- Чтобы получить Bad, надо ударить рано. Идеальное расстояние для Bad - от 30 до 50 пикселей.
            if distance <= 45 and distance >= 30 then
                PressKey(targetKey)
                connection:Disconnect() -- Отключаем трекер, кнопка уже нажата
            end
        else
            -- ЛОГИКА ОБЫЧНОЙ ИГРЫ (SICK / GOOD)
            if distance <= 10 then -- Почти идеальное совпадение
                if math.random(1, 100) <= FF_Settings.Accuracy then
                    PressKey(targetKey)
                end
                connection:Disconnect() -- В любом случае прекращаем слежку
            end
        end
    end)
    
    -- Защита от бесконечного висения функции в памяти (если нота зависла на 5 сек - убиваем поток)
    task.delay(5, function()
        if connection then connection:Disconnect() end
    end)
end

-- Главный сканер интерфейса (Ищет НОВЫЕ ноты каждые 0.1 сек)
task.spawn(function()
    while true do
        task.wait(0.05)
        if FF_Settings.AutoPlay then
            local pg = player:FindFirstChild("PlayerGui")
            if pg then
                for _, gui in ipairs(pg:GetDescendants()) do
                    if gui:IsA("GuiObject") and gui.Visible and gui.AbsoluteSize.X > 5 then
                        local name = gui.Name:lower()
                        -- Если это нота и мы ее ЕЩЕ НЕ ОБРАБАТЫВАЛИ
                        if (name:match("note") or name:match("arrow")) and not name:match("receptor") and not name:match("strum") then
                            if not ProcessedNotes[gui] then
                                ProcessedNotes[gui] = true -- СТАВИМ МЕТКУ (Больше спама не будет!)
                                TrackNoteAndHit(gui) -- Отправляем ноту в персональный трекер
                            end
                        end
                    end
                end
            end
            
            -- Очистка старых данных из памяти, чтобы не было лагов
            for guiObj, _ in pairs(ProcessedNotes) do
                if not guiObj or not guiObj.Parent then
                    ProcessedNotes[guiObj] = nil
                end
            end
        end
    end
end)

print("[PRO HUB v18]: GOD MODE ACTIVATED. Visual Math Engine Running.")
```eof

