local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Создаем антигравитационную силу
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(0, 0, 0) -- Сначала выключена
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.Parent = humanoidRootPart

local isFlying = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then -- Кнопка E для взлета
        isFlying = not isFlying
        if isFlying then
            bodyVelocity.MaxForce = Vector3.new(4e6, 4e6, 4e6)
        else
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if isFlying then
        -- Магия: летим туда, куда смотрит камера
        local direction = camera.CFrame.LookVector
        bodyVelocity.Velocity = direction * 50 -- Скорость 50
    end
end)
