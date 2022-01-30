local swordMechanics = {}

local animationId = "http://www.roblox.com/asset/?id=8389538800"


function swordMechanics.attack(player, sword)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return end
    local attack = Instance.new("Animation")
    attack.AnimationId = animationId

    local attackAnimation = animator:LoadAnimation(attack)
    attackAnimation:Play()
    player:SetAttribute("Attacking", true)
    while attackAnimation.IsPlaying do
        task.wait()
    end
    player:SetAttribute("Attacking", false)
end

return swordMechanics