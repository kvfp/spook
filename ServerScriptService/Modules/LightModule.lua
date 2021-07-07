local U = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("UtilityModule"))
local AudioFolder = U:Import("AudioFolder")

local Audio = {
	["Flicker"] = U:WFC(AudioFolder, {"Flicker"})
}

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
			-- if Inside:FindFirstChild("Neon") == nil then
			-- 	print("\n\n>>>",Inside.Name,"might not be a light!","<<<\n\n")
			-- end
		end
	end

	GetAll(Source)
	print("Got lights:",#Lights)

	return Lights
end

local function ReturnParts(Target)
	local LightParts = Target
	if typeof(Target) ~= "table" then
		LightParts = GetLightParts(Target)
	end
	if LightParts then
		print("LightParts",LightParts)
		for _, Part in pairs(LightParts) do
			if Part:IsA("Part") or Part:IsA("MeshPart") then
				return {One = Part, Many = LightParts}
			end
		end
	end
	return nil
end

local function TurnOn(Target)
	local LightParts = Target
	if typeof(Target) ~= "table" then
		LightParts = GetLightParts(Target)
	end
	for _, Part in pairs(LightParts) do
		if Part:FindFirstChild("OriginalColor") then
			Part.Color = DimmedNeonColor
		elseif Part:IsA("SpotLight") or Part:IsA("SurfaceLight") or Part:IsA("PointLight") then
			Part.Brightness = Part:FindFirstChild("OriginalBrightness").Value
		end
	end
end

local function TurnOff(Target, Overrides)
	local LightParts = Target
	if typeof(Target) ~= "table" then
		LightParts = GetLightParts(Target)
	end
	-- print("\nLightParts:",#LightParts,"\n")
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
				-- print("MainLight found")
				Part.Brightness = 0.1
			else
				Part.Brightness = 0
			end
		end
	end
end

local function GetSource(SourceName)
	local Source = SourceName
	if typeof(SourceName) ~= "Instance" and typeof(SourceName) ~= "table" then
		Source = U:Import(SourceName)
	end
	if Source == nil then
		-- print("Light source not found")
	end
	return Source
end

local function Restore(SourceName)
	local function Main()
		local Source = GetSource(SourceName)
		if Source then
			TurnOn(Source)
		end
	end
	local Cor = coroutine.wrap(Main)
	Cor()
end

local LightModule = {}

function LightModule:GetLightParts(SourceName)
	local LightParts = nil
	local function Main()
		LightParts = GetLightParts(SourceName)
	end
	local Cor = coroutine.wrap(Main)
	Cor()
	return LightParts
end

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

function LightModule:Flicker(SourceName, Overrides)

	local function Main()

		local Source = GetSource(SourceName)

		if Source then

			local OriginalVolume
			local PlayingAudio
			local ReturnedParts = ReturnParts(Source)
			if ReturnedParts then
				if ReturnedParts.One then
					print("Returned",ReturnedParts.One)
					PlayingAudio = Audio["Flicker"]:Clone()
					PlayingAudio.Parent = ReturnedParts.One
					PlayingAudio.TimePosition = math.random()*30
					PlayingAudio:Play()
					OriginalVolume = PlayingAudio.Volume
					PlayingAudio.Volume = 0
				else
					print("Failed return")
				end
			else
				ReturnedParts = { One = Source[1] }
				PlayingAudio = Audio["Flicker"]:Clone()
				PlayingAudio.Parent = ReturnedParts.One
				PlayingAudio.TimePosition = math.random()*30
				PlayingAudio:Play()
				OriginalVolume = PlayingAudio.Volume
				PlayingAudio.Volume = 0
			end


			print("\n\nFlicker start")

			for i = 1, math.random(1, 15) do
				TurnOff(Source)
				PlayingAudio.Volume = OriginalVolume
				wait(math.random(5,40)/100)
				PlayingAudio.Volume = 0

				TurnOn(Source)
				PlayingAudio.Volume = OriginalVolume
				wait(math.random(5,40)/100)
				PlayingAudio.Volume = 0
			end

			if PlayingAudio then
				PlayingAudio:Destroy()
			end
			print("It was still:",ReturnedParts.One)
		end
		print("Flicker end\n\n")

	end
	--local Cor = coroutine.wrap(Main)
	--Cor()
	Main()
end

return LightModule
