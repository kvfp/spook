local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))
local LightModule = require(U:Import("LightModule"))

print("\n\nStarting in")
for i = 1, 15 do
	print(15-i)
	wait(1)
end

while true do
	print("\nKitchen lights off")
	LightModule:TurnOff("KitchenLights")

	wait(2)

	print("\nKitchen lights on")
	LightModule:TurnOn("KitchenLights")

	wait(2)
end