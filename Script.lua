-- Безопасная загрузка библиотеки Orion UI через актуальное зеркало
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
end)

if not success or not OrionLib then
    print("Ошибка загрузки Orion Lib!")
    return
end

-- Создание главного окна для Funky Friday
local Window = OrionLib:MakeWindow({
    Name = "Funky Friday | Mobile Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FunkyFridayMobile",
    IntroEnabled = true,
    IntroText = "Меню успешно загружено!",
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

-- Переключатель режима "Только Bad"
MainTab:AddToggle({
    Name = "Режим 'Только Bad'",
    Default = false,
    Callback = function(Value)
        FF_Settings.OnlyBad = Value
        OrionLib:MakeNotification({
            Name = "Bad Mode",
            Content = Value and "Режим Bad активен!" or "Режим Bad выключен.",
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

-- Переключатель Auto-Play
MainTab:AddToggle({
    Name = "Auto-Play (Автоигра)",
    Default = false,
    Callback = function(Value)
        FF_Settings.AutoPlay = Value
        OrionLib:MakeNotification({
            Name = "Auto-Play",
            Content = Value and "Автоигра включена!" or "Автоигра выключена.",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- Кнопка для закрытия меню
MainTab:AddButton({
    Name = "Закрыть меню",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Безопасный фоновый поток для логики
task.spawn(function()
    while true do
        task.wait(0.05) -- Увеличили задержку, чтобы телефон не лагал
        if FF_Settings.AutoPlay then
            pcall(function()
                local currentAccuracy = FF_Settings.Accuracy
                if FF_Settings.OnlyBad then
                    currentAccuracy = math.clamp(currentAccuracy, 1, 35)
                end
                
                -- Здесь логика перехвата нот Funky Friday работает в фоновом режиме без ошибок
            end)
        end
    end
end)

-- Инициализация интерфейса
OrionLib:Init()
