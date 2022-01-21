local swordMechanics = {}

function swordMechanics.attack(player, sword)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return end
    local attack = Instance.new("Animation")
    attack.AnimationId = sword:GetAttribute("AnimationID")
    local attackAnimation = animator:LoadAnimation(attack)
    attackAnimation:Play()
end

return swordMechanics