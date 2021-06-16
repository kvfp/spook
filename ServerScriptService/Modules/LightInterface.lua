local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))
local LightModule = require(U:Import("LightModule"))

local MaxLightDistanceFromPlayer = 20

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
		
		local Targets = {}
		
		for _, Part in pairs(LightParts) do
			if Part:IsA("Part") or Part:IsA("MeshPart") then
				local DistanceToRoot = (Root.Position-Part.Position).Magnitude
				if DistanceToRoot <= MaxLightDistanceFromPlayer then
					if Part.Material == Enum.Material.Neon or Part:FindFirstChildOfClass("PointLight") or 
						Part:FindFirstChildOfClass("SurfaceLight") or Part:FindFirstChildOfClass("SpotLight") then
						table.insert(Targets, Part)
					end
				end
			end
		end
		
		if Info.Range == "Single" then
			LightModule:Flicker(Info.Sources[1])
		elseif Info.Range == "All" then
			LightModule:Flicker(Info.Sources)
		elseif Info.Range == "Partial" then
			local Indices = {}
			local PartialList = {}
			for i = 1, Info.Range do
				local RandomIndex = math.random(1, #Info.Sources)
				if Indices[RandomIndex] ~= nil then
					repeat
						RandomIndex = math.random(1, #Info.Sources)
					until Indices[RandomIndex] == nil
				end
				Indices[RandomIndex] = 1
				table.insert(PartialList, LightParts[RandomIndex])
			end
			print("PartialList Length:",#PartialList)
			LightModule:Flicker(PartialList)
		end
	end
end

return LightInterference
