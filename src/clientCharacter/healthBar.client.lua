local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local HealthBarGui = PlayerGui:WaitForChild("HealthBar")
local GuiHolder = HealthBarGui:WaitForChild("GuiHolder")
local userNameLabel = GuiHolder:WaitForChild("UserName")
local HealthBarHolder = GuiHolder:WaitForChild("HealthBarHolder")
local HealthBar = HealthBarHolder:WaitForChild("Health")
local ExpBarHolder = GuiHolder:WaitForChild("ExpBarHolder")
local ExpBar = ExpBarHolder:WaitForChild("expBar")
local TweenService = game:GetService("TweenService")

HealthBarHolder.BackgroundColor3 = Color3.new(0, 0, 0) -- black

local function onHealthChanged()
	local human = player.Character.Humanoid
	local percent = human.Health / human.MaxHealth
	local healthValue = (1-percent)
	local numberSequence = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0), -- (time, value)
		NumberSequenceKeypoint.new(.999, 0),
		NumberSequenceKeypoint.new(1, 1)
	}
	HealthBar.Color = ColorSequence.new(Color3.new(0,1,0));
	HealthBarHolder.BackgroundColor3 = Color3.new(1,1,1);
	HealthBar.Transparency = numberSequence
	
    local changeHealth = TweenService:Create(HealthBar,TweenInfo.new(.5),{Offset = Vector2.new(-healthValue,0)})
	if(changeHealth) then
		print("Yup we changing")
		changeHealth:Play()
	end
end

local function onCharacterAdded(character)
	local human = character:WaitForChild("Humanoid")
	userNameLabel.Text = character.Name
	human.HealthChanged:Connect(onHealthChanged)
	onHealthChanged()
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then 	
	onCharacterAdded(player.Character)
end