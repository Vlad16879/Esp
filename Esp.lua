local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPMenu"
screenGui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 100, 0, 40)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
openButton.TextColor3 = Color3.new(1,1,1)
openButton.Text = "ESP Меню"
openButton.Parent = screenGui

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 120)
menuFrame.Position = UDim2.new(0, 10, 0, 60)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BackgroundTransparency = 0.4
menuFrame.Parent = screenGui
menuFrame.Visible = false

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Text = "X"
closeButton.Parent = menuFrame

local toggleESPButton = Instance.new("TextButton")
toggleESPButton.Size = UDim2.new(0, 200, 0, 50)
toggleESPButton.Position = UDim2.new(0, 10, 0, 40)
toggleESPButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleESPButton.TextColor3 = Color3.new(1,1,1)
toggleESPButton.Text = "Включить ESP"
toggleESPButton.Parent = menuFrame

local espEnabled = false
local highlights = {}
local connections = {}

local function createHighlight(character)
    if not character or not character:IsA("Model") then return end
    if character:FindFirstChild("HighlightESP") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "HighlightESP"
    highlight.Adornee = character
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.Parent = character
    return highlight
end

local function removeHighlight(character)
    if not character then return end
    local highlight = character:FindFirstChild("HighlightESP")
    if highlight then
        highlight:Destroy()
    end
end

local function onCharacterAdded(plr, character)
    if not espEnabled or plr == player then return end
    highlights[plr] = createHighlight(character)
end

local function onPlayerAdded(plr)
    if plr == player then return end
    
    local conn1 = plr.CharacterAdded:Connect(function(char)
        onCharacterAdded(plr, char)
    end)
    
    local conn2 = plr.CharacterRemoving:Connect(function(char)
        removeHighlight(char)
    end)
    
    connections[plr] = {conn1, conn2}
    
    if plr.Character and espEnabled then
        highlights[plr] = createHighlight(plr.Character)
    end
end

local function onPlayerRemoving(plr)
    if highlights[plr] then
        if plr.Character then
            removeHighlight(plr.Character)
        end
        highlights[plr] = nil
    end
    
    if connections[plr] then
        for _, conn in ipairs(connections[plr]) do
            conn:Disconnect()
        end
        connections[plr] = nil
    end
end

local function enableESP()
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            highlights[plr] = createHighlight(plr.Character)
        end
    end
    toggleESPButton.Text = "Отключить ESP"
end

local function disableESP()
    espEnabled = false
    for plr, _ in pairs(highlights) do
        if plr.Character then
            removeHighlight(plr.Character)
        end
    end
    highlights = {}
    toggleESPButton.Text = "Включить ESP"
end

-- Инициализация
for _, plr in pairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

toggleESPButton.MouseButton1Click:Connect(function()
    if espEnabled then
        disableESP()
    else
        enableESP()
    end
end)

openButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = true
    openButton.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
    openButton.Visible = true
end)
