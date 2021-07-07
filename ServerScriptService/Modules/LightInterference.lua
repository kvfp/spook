local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))
local LightModule = require(U:Import("LightModule"))

local MaxLightDistanceFromPlayer = 100

local LightInterference = {}

function LightInterference:Interfere(Info)
	if Info.Type == "Room" then
		if Info.Range == "All" then
			LightModule:Flicker(Info.Room)
		elseif Info.Range == "Partial" then
			-- TODO: implement PARTIAL room-targeted interferences
		end
	elseif Info.Type == "Player" then
		local LightParts = LightModule:GetLightParts(workspace.Lights)
		local Char = Info.Player.Character
		if not Char then return end
		local Root = Char:WaitForChild("HumanoidRootPart")

		print("Final GetLightParts:",#LightParts)

		local Targets = {}

		for _, Part in pairs(LightParts) do
			if Part:IsA("Part") or Part:IsA("MeshPart") then
				local DistanceToRoot = (Root.Position-Part.Position).Magnitude
				if DistanceToRoot <= MaxLightDistanceFromPlayer then
					if Part.Material == Enum.Material.Neon or Part:FindFirstChildOfClass("PointLight") or 
						Part:FindFirstChildOfClass("SurfaceLight") or Part:FindFirstChildOfClass("SpotLight") then
						table.insert(Targets, Part)
					end
				elseif Part.Name == "MainLight" then
					table.insert(Targets, Part)
				end
			end
		end
		
		print("\n\n\n\nTARGETS")
		for _, Target in pairs(Targets) do
			print(Target)
		end
		print("\n\n\n")

		if Info.Range == "Single" then
			LightModule:Flicker({Targets[1]})
		elseif Info.Range == "All" then
			LightModule:Flicker(Targets)
		elseif Info.Range == "Partial" then
			local Indices = {}
			local PartialList = {}
			for i = 1, Info.Count do
				local RandomIndex = math.random(1, #Targets)
				if Indices[RandomIndex] ~= nil then
					repeat
						RandomIndex = math.random(1, #Targets)
					until Indices[RandomIndex] == nil or #Targets < Info.Count
				end
				Indices[RandomIndex] = 1
				table.insert(PartialList, Targets[RandomIndex])
			end
			print("PartialList Length:",#PartialList)
			LightModule:Flicker(PartialList)
		end
	end
end

return LightInterference
