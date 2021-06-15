local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local RSModules = RS:WaitForChild("Modules")
local SSSModules = SSS:WaitForChild("Modules")

local Database = {
	["DialogueModule"] = RSModules:WaitForChild("DialogueModule"),
	["LightModule"] = SSSModules:WaitForChild("LightModule"),
	["Lights"] = workspace:WaitForChild("Lights"),
	["KitchenLights"] = workspace:WaitForChild("Lights"):WaitForChild("Kitchen"),
}

local u = {}

function u:WFC(Root, All)
	local Endpoint = Root

	local function Do()
		for _, Child in pairs(All) do
			local NewEndpoint
			local Success, Response = pcall(function()
				NewEndpoint = Endpoint:FindFirstChild(Child)
			end)
			if not Success or NewEndpoint == nil then
				Endpoint = Endpoint:WaitForChild(Child)
			else
				Endpoint = NewEndpoint
			end
		end
	end

	local Cor = coroutine.wrap(Do)
	Cor()

	if Endpoint ~= Root then
		return Endpoint
	else
		return nil
	end

end

function u:Import(Name)
	if Database[Name] then
		return Database[Name]
	else
		print(Name,"does not exist")
		return nil
	end
end

return u