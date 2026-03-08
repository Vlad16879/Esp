local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local isFlying = false
local speed = 70 -- Скорость полета

-- Создаем физический движитель
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = root

-- Гироскоп, чтобы персонаж не кувыркался на сенсоре
local bg = Instance.new("BodyGyro")
bg.MaxForce = Vector3.new(0, 0, 0)
bg.D = 500 -- Плавность поворота
bg.Parent = root

-- Функция переключения полета
local function onFlyButton(actionName, inputState)
    if inputState == Enum.UserInputState.Begin then
        isFlying = not isFlying
        if isFlying then
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bg.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            print("🚀 Полет запущен!")
        else
            bv.MaxForce = Vector3.new(0, 0, 0)
            bg.MaxForce = Vector3.new(0, 0, 0)
            print("⚓ Приземление...")
        end
    end
end

-- Создаем кнопку специально для тачскрина
ContextActionService:BindAction("MobileFly", onFlyButton, true)
ContextActionService:SetPosition("MobileFly", UDim2.new(0.5, 70, 0, 10)) -- Кнопка будет сверху справа
ContextActionService:SetTitle("MobileFly", "FLY 🚀")

RunService.RenderStepped:Connect(function()
    if isFlying then
        -- На мобилках летим ровно туда, куда направлен палец (камера)
        bv.Velocity = camera.CFrame.LookVector * speed
        -- Поворачиваем туловище вслед за камерой
        bg.CFrame = camera.CFrame
    end
end)
