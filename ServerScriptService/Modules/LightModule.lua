local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))

local function GetLightParts(Source)
	local Lights = {}

	local function GetAll(Inside)
		if Inside:IsA("Folder") then
			for _, Child in pairs(Inside:GetChildren()) do
				GetAll(Child)
			end
		elseif Inside:IsA("Model") or Inside.Parent.Name == "Main" or Inside.Name == "MainLight" then
			for _, Descendant in pairs(Inside:GetDescendants()) do
				table.insert(Lights, Descendant)
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
		if Part:FindFirstChild("WasANeonPart") then
			Part.Material = Enum.Material.Neon
		elseif Part:IsA("SpotLight") or Part:IsA("SurfaceLight") or Part:IsA("PointLight") then
			Part.Brightness = Part:FindFirstChild("OriginalBrightness").Value
		end
	end
end

local function TurnOff(Target)
	local LightParts = GetLightParts(Target)
	print("\nLightParts:",#LightParts,"\n")
	for _, Part in pairs(LightParts) do
		if Part:IsA("Part") or Part:IsA("MeshPart") then
			if Part.Material == Enum.Material.Neon then
				if Part:FindFirstChild("WasANeonPart") == nil then
					local WasANeonPart = Instance.new("BoolValue")
					WasANeonPart.Name = "WasANeonPart"
					WasANeonPart.Parent = Part
				end
				Part.Material = Enum.Material.Plastic
			end
		elseif Part:IsA("SpotLight") or Part:IsA("SurfaceLight") or Part:IsA("PointLight") then
			if Part:FindFirstChild("OriginalBrightness") == nil then
				local OriginalBrightness = Instance.new("NumberValue")
				OriginalBrightness.Name = "OriginalBrightness"
				OriginalBrightness.Parent = Part
				OriginalBrightness.Value = Part.Brightness
			end
			if Part.Parent.Name == "MainLight" then
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

function LightModule:TurnOff(SourceName)
	local function Main()
		local Source = GetSource(SourceName)
		if Source then
			TurnOff(Source)
		end
	end
	local Cor = coroutine.wrap(Main)
	Cor()
end

return LightModule
