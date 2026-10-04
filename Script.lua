-- Загрузка библиотеки Orion UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Создание главного окна для Funky Friday
local Window = OrionLib:MakeWindow({
    Name = "Funky Friday | Menu",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FunkyFridayConfig",
    IntroEnabled = true,
    IntroText = "Запуск Funky Friday...",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

-- Таблица настроек бота
local FF_Settings = {
    AutoPlay = false,
    Accuracy = 100,      -- От 1 до 100
    OnlyBad = false      -- Режим «Только Bad»
}

-- Создание вкладки
local MainTab = Window:MakeTab({
    Name = "Автоигра",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Секция настроек
local MainSection = MainTab:AddSection({
    Name = "Настройки Bot / Auto-Play"
})

-- Переключатель Auto-Play
MainTab:AddToggle({
    Name = "Auto-Play (Автоигра)",
    Default = false,
    Callback = function(Value)
        FF_Settings.AutoPlay = Value
        OrionLib:MakeNotification({
            Name = "Funky Friday",
            Content = Value and "Автоигра включена!" or "Автоигра выключена!",
            Image = "rbxassetid://4483345998",
            Time = 3
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

-- Переключатель режима "Только Bad"
MainTab:AddToggle({
    Name = "Режим 'Только Bad'",
    Default = false,
    Callback = function(Value)
        FF_Settings.OnlyBad = Value
        if Value then
            OrionLib:MakeNotification({
                Name = "Bad Mode",
                Content = "Включен режим ударов только на Bad!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Основной цикл для Funky Friday
task.spawn(function()
    while true do
        task.wait(0.01)
        if FF_Settings.AutoPlay then
            pcall(function()
                -- Логика перехвата нот Funky Friday
                -- Если OnlyBad == true, занижаем тайминги под оценку Bad
                -- Если Accuracy < 100, добавляем рандом промахов
            end)
        end
    end
end)

-- Инициализация
OrionLib:Init()
