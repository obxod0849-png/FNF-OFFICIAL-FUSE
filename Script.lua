-- Проверка работоспособности лаудера
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Лаудер работает!",
        Text = "Скрипт успешно загрузился с GitHub!",
        Duration = 5
    })
end)

print("--- ФУНКЦИЯ ЗАГРУЗКИ ПРОШЛА УСПЕШНО ---")
