-- Загрузка библиотеки Orion UI (безопасный актуальный источник)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Создание главного окна
local Window = OrionLib:MakeWindow({
    Name = "Basically FNF: Remix | Menu",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FNF_RemixConfig",
    IntroEnabled = true,
    IntroText = "Запуск скрипта...",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

-- Создание вкладки
local MainTab = Window:MakeTab({
    Name = "Главная",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Создание секции во вкладке
local MainSection = MainTab:AddSection({
    Name = "Управление"
})

-- Пример кнопки (пока что просто выводит уведомление)
MainTab:AddButton({
    Name = "Тестовая кнопка",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Привет!",
            Content = "Менюшка на Orion успешно работает на телефоне!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- Обязательная строка в конце для инициализации интерфейса
OrionLib:Init()
