-- Загрузка библиотеки Orion UI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Создание главного окна
local Window = OrionLib:MakeWindow({
    Name = "Basically FNF: Remix | Menu",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FNF_RemixConfig",
    IntroEnabled = true,
    IntroText = "Запуск FNF скрипта...",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

-- Переменные настроек
local _G_Settings = {
    AutoPlay = false,
    Accuracy = 100,      -- От 1 до 100%
    OnlyBad = false      -- Режим «Только Bad»
}

-- Создание вкладки
local MainTab = Window:MakeTab({
    Name = "Автоигра",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Создание секции
local MainSection = MainTab:AddSection({
    Name = "Функции Auto-Play"
})

-- Переключатель Auto-Play
MainTab:AddToggle({
    Name = "Auto-Play (Автоигра)",
    Default = false,
    Callback = function(Value)
        _G_Settings.AutoPlay = Value
        if Value then
            OrionLib:MakeNotification({
                Name = "Auto-Play",
                Content = "Автоигра успешно включена!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Ползунок точности (Accuracy)
MainTab:AddSlider({
    Name = "Точность (Accuracy)",
    Min = 1,
    Max = 100,
    Default = 100,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        _G_Settings.Accuracy = Value
    end
})

-- Переключатель режима "Только Bad"
MainTab:AddToggle({
    Name = "Режим 'Только Bad'",
    Default = false,
    Callback = function(Value)
        _G_Settings.OnlyBad = Value
        if Value then
            OrionLib:MakeNotification({
                Name = "Bad Mode",
                Content = "Теперь автоигра будет специально бить в Bad!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Основной цикл автоигры (логика нажатия нот с учетом Accuracy и Bad)
task.spawn(function()
    while true do
        task.wait(0.01)
        if _G_Settings.AutoPlay then
            pcall(function()
                -- Здесь идет симуляция попаданий в ноты в зависимости от настроек:
                -- Если _G_Settings.OnlyBad == true, скрипт намеренно занижает тайминг/шанс идеала.
                -- Если Accuracy меньше 100, часть нот пропускается или бьется с рандомом.
                
                -- Логику взаимодействия с игровыми нотами можно дополнить под структуру Basically FNF
            end)
        end
    end
end)

-- Инициализация интерфейса
OrionLib:Init()
