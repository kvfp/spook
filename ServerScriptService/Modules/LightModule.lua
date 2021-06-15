local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))
local DimmedNeonColor = Color3.fromRGB(161, 133, 115)

local function GetLightParts(Source, Overrides)
	local Lights = {}

	local function GetAll(Inside)
		if Inside:IsA("Folder") then
			for _, Child in pairs(Inside:GetChildren()) do
				GetAll(Child)
			end
		elseif Inside:IsA("Model") or Inside.Parent.Name == "Main" or Inside.Name == "MainLight" then
			if Overrides == nil then
				if Inside.Parent.Name ~= "Wall" then
					if Inside.Parent.Name ~= "Cabinet" and Inside.Parent.Name ~= "Stove" then
						for _, Descendant in pairs(Inside:GetDescendants()) do
							table.insert(Lights, Descendant)
						end
					else
						if Inside.Name ~= "MainLight" then
							for _, Descendant in pairs(Inside:GetDescendants()) do
								table.insert(Lights, Descendant)
							end
						end
					end
				end
			end
			if Inside:FindFirstChild("Neon") == nil then
				print("\n\n>>>",Inside.Name,"might not be a light!","<<<\n\n")
			end
		end
	end

	GetAll(Source)

	return Lights
end

local function TurnOn(Target)
	local LightParts = GetLightParts(Target)
	for _, Part in pairs(LightParts) do
		if Part:FindFirstChild("OriginalColor") then
			Part.Color = DimmedNeonColor
		elseif Part:IsA("SpotLight") or Part:IsA("SurfaceLight") or Part:IsA("PointLight") then
			Part.Brightness = Part:FindFirstChild("OriginalBrightness").Value
		end
	end
end

local function TurnOff(Target, Overrides)
	local LightParts = GetLightParts(Target, Overrides)
	print("\nLightParts:",#LightParts,"\n")
	for _, Part in pairs(LightParts) do
		if Part:IsA("Part") or Part:IsA("MeshPart") then
			if Part.Material == Enum.Material.Neon then
				if Part:FindFirstChild("OriginalColor") == nil then
					local OriginalColor = Instance.new("Color3Value")
					OriginalColor.Name = "OriginalColor"
					OriginalColor.Parent = Part
					OriginalColor = Part.Color
				end
				Part.Color = DimmedNeonColor
			end
		elseif Part:IsA("SpotLight") or Part:IsA("SurfaceLight") or Part:IsA("PointLight") then
			if Part:FindFirstChild("OriginalBrightness") == nil then
				local OriginalBrightness = Instance.new("NumberValue")
				OriginalBrightness.Name = "OriginalBrightness"
				OriginalBrightness.Parent = Part
				OriginalBrightness.Value = Part.Brightness
			end
			if Part.Parent.Name == "MainLight" then
				print("MainLight found")
				Part.Brightness = 0.1
			else
				Part.Brightness = 0
			end
		end
	end
end

local function Flicker(Target)

end

local function Restore(Target)

end

local function GetSource(SourceName)
	local Source = SourceName
	if typeof(SourceName) ~= "Instance" then
		Source = U:Import(SourceName)
	end
	if Source == nil then
		print("Light source not found")
	end
	return Source
end

local LightModule = {}

function LightModule:TurnOn(SourceName)
	local function Main()
		local Source = GetSource(SourceName)
		if Source then
			TurnOn(Source)
		end
	end
	local Cor = coroutine.wrap(Main)
	Cor()
end

function LightModule:TurnOff(SourceName, Overrides)
	local function Main()
		local Source = GetSource(SourceName)
		if Source then
			TurnOff(Source, Overrides)
		end
	end
	local Cor = coroutine.wrap(Main)
	Cor()
end

return LightModule
