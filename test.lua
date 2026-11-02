if not game:IsLoaded() then game.Loaded:Wait() end

if game.GameId == 7709344486 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/ac57e23d2a5f76bf89df2c0b74462306.lua"))()
    task.wait(3)
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/3662afddbfc5c61b620d0f611136b00a.lua"))()
end
