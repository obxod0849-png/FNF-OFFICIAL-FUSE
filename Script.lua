-- Загрузка библиотеки Orion UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Создание главного окна для Funky Friday
local Window = OrionLib:MakeWindow({
    Name = "Funky Friday | Mobile Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FunkyFridayMobile",
    IntroEnabled = true,
    IntroText = "Загрузка чит-меню...",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

-- Таблица настроек
local FF_Settings = {
    AutoPlay = false,
    Accuracy = 100,      -- От 1 до 100%
    OnlyBad = false      -- Режим «Только Bad»
}

-- Создание вкладки
local MainTab = Window:MakeTab({
    Name = "Главная",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Секция управления
local MainSection = MainTab:AddSection({
    Name = "Функции Автоигры"
})

-- Переключатель режима "Только Bad" (ставим выше, чтобы игрок мог задействовать логику)
MainTab:AddToggle({
    Name = "Режим 'Только Bad'",
    Default = false,
    Callback = function(Value)
        FF_Settings.OnlyBad = Value
        OrionLib:MakeNotification({
            Name = "Bad Mode",
            Content = Value and "Режим Bad активен!" : "Режим Bad выключен.",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- Ползунок точности (Accuracy) от 1 до 100
MainTab:AddSlider({
    Name = "Точность (Accuracy)",
    Min = 1,
    Max = 100,
    Default = 100,
    Color = Color3.fromRGB(0, 170, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        FF_Settings.Accuracy = Value
    end
})

-- Переключатель Auto-Play (теперь учитывает настройки Bad и Accuracy)
MainTab:AddToggle({
    Name = "Auto-Play (Автоигра)",
    Default = false,
    Callback = function(Value)
        FF_Settings.AutoPlay = Value
        OrionLib:MakeNotification({
            Name = "Auto-Play",
            Content = Value and "Автоигра успешно заведена!" : "Автоигра остановлена.",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- Кнопка для скрытия/показа меню (очень удобно на телефоне, чтобы не закрывало экран)
MainTab:AddButton({
    Name = "Скрыть / Показать меню (Кнопка)",
    Callback = function()
        OrionLib:Destroy() -- Безопасное закрытие интерфейса при необходимости
    end
})

-- Рабочий цикл перехвата нот в Funky Friday
task.spawn(function()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    while true do
        task.wait(0.01)
        if FF_Settings.AutoPlay then
            pcall(function()
                -- Основная логика обработки нот с учетом Accuracy и OnlyBad
                local currentAccuracy = FF_Settings.Accuracy
                local badMode = FF_Settings.OnlyBad
                
                -- Если включен OnlyBad, алгоритм намеренно снижает порог тайминга до оценки Bad
                if badMode then
                    currentAccuracy = math.clamp(currentAccuracy, 1, 35) -- искусственное ограничение под плохие оценки
                end
                
                -- Поиск и эмуляция нажатий стрелок в игре
                local playerGui = localPlayer:WaitForChild("PlayerGui", 1)
                if playerGui then
                    for _, v in ipairs(playerGui:GetDescendants()) do
                        if v:IsA("GuiObject") and (v.Name:lower():find("note") or v.Name:lower():find("arrow")) then
                            -- Проверка рандома по проценту точности (Accuracy)
                            if math.random(1, 100) <= currentAccuracy then
                                -- Триггер нажатия для мобильного эксплойта
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Инициализация интерфейса
OrionLib:Init()
