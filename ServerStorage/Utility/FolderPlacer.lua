local SS = game:GetService("Selection")

local function PlaceInFolder(Location, FolderName)
    print("\n\n\n-------------------------------------------------------")
    
    local FailedPlacements = 0
    local SuccessfulPlacements = 0

    local Folder = Location:FindFirstChild(FolderName)
	if not Folder then 
		Folder = Instance.new("Folder")
        Folder.Name = FolderName
        Folder.Parent = Location
        print("Created new folder:")
	end
    print(Folder:GetFullName())

    for _, Obj in pairs(SS:Get()) do
        local function PlaceObj()
            Obj.Parent = Folder
        end
        local success, err = pcall(PlaceObj)
        if err then
            FailedPlacements += 1
            print("Failed for",Obj.Name,err)
        else
            SuccessfulPlacements += 1
            print("Success:",Obj:GetFullName())
        end
    end

    local Rate = 100*math.floor(SuccessfulPlacements/(SuccessfulPlacements+FailedPlacements))
    print("\n\nSuccess:",Rate.."%")
    print("Failed:",FailedPlacements)

    print("-------------------------------------------------------")
end

PlaceInFolder(workspace.Lights.LivingRoom, "Ceiling")