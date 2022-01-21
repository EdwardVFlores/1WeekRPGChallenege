local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local MoneyService = Knit.CreateService {
    Name = "MoneyService";
    Client = {};
}

function MoneyService:KnitStart()
    print("InitializedMoney")
end

function MoneyService:KnitInit()
    print("InitializedMoney")
end

return MoneyService
