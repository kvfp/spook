local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))
local LightModule = require(U:Import("LightModule"))

print("\n\nStarting in")
for i = 1, 5 do
	print(5-i)
	wait(1)
end

print("\nKitchen lights off")
LightModule:TurnOff("KitchenLights")

wait(5)

print("\nKitchen lights on")
LightModule:TurnOn("KitchenLights")