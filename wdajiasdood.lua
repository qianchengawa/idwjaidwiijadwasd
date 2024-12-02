local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "TDM V2.043",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "TowerDefenseMacro",
	LoadingSubtitle = "by 牢大",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
	ConfigurationSaving = {
		Enabled = false,
	},
})
local httpService = game:GetService("HttpService")

function Save(data,name,folder)
	local fullPath
	if folder then
		fullPath = [[TDM/]]..folder.."/"..tostring(name)..".json"
	else
		fullPath = [[TDM/]]..string.gsub(name," ","")..".json"
	end
	local success, encoded = pcall(httpService.JSONEncode, httpService, data)
	if not success then
		return false
	end
	print(encoded)
	writefile(fullPath, encoded)
	return true
end

function Load(name,folder)
	local file
	if folder then
		file = [[TDM/]]..folder.."/"..tostring(name)..".json"
	else
		file = [[TDM/]]..string.gsub(name," ","")..".json"
	end
	if not isfile(file) then return false end

	local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
	if not success then return false end
	return decoded
end
if game.PlaceId == 14279724900 then --游戏内
	local plev = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("placeTower")
	local sel = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("RemoveTower")
	local up = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("UpgradeTower")
	local af = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("ChangeTowerTargetMode")
	local ws = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("waveSkip")
	local slboost = game:GetService("ReplicatedStorage"):WaitForChild("BoostSelect")
	local timestop = game:GetService("ReplicatedStorage"):WaitForChild("TimestopEvent")
	local rp = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("ReplayCore")
	local rd = game:GetService("ReplicatedStorage"):WaitForChild("GAME_START"):WaitForChild("readyButton")
	local times = game:GetService("ReplicatedStorage").Game.Clock
	local character = game:GetService("ReplicatedStorage").Chapter
	local TowerDatasF = workspace.Scripted.TowerData
	local firsttower = nil
	local gameend = game:GetService("ReplicatedStorage").ended
	local inm = game:GetService("ReplicatedStorage").ended.inMenu

	TowerDatasF.ChildAdded:Connect(function(v)
		if not firsttower then
			firsttower = v.Name
		end
	end)
	TowerDatasF.ChildRemoved:Connect(function()
		if not TowerDatasF:GetChildren()[1] then
			firsttower = nil
		end
	end)
	local F = {}

	local function AddF(event,args)
		if event == plev then
			local tower = tostring(args[1])
			local placeCframe = tostring(args[2])
			local idkblon = tostring(args[3])
			F[#F+1] = {tostring(times.Value),event.Name,tower,placeCframe,idkblon}
		elseif (event == sel or event == up or event == af)  then
			local towerID = tostring(args[1])
			F[#F+1] = {tostring(times.Value),event.Name,towerID}
		elseif event == ws then
			local blon = tostring(args[1])
			F[#F+1] = {tostring(times.Value),event.Name,blon}
		elseif event == slboost then
			local boost1 = tostring(args[1])
			local boost2 = tostring(args[2])
			F[#F+1] = {tostring(times.Value),event.Name,tostring(boost1),tostring(boost2)}
		elseif event == timestop then
			F[#F+1] = {tostring(times.Value),event.Name}
		end
	end

	task.spawn(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
	end)
	local aaa = game:GetService("VirtualUser")
	pcall(function()
		game:GetService('Players').LocalPlayer.Idled:connect(function()
			aaa:CaptureController()
			aaa:ClickButton2(Vector2.new())
		end)
	end)
	local inc = false
	local Tab = Window:CreateTab("主要功能", "camera") -- Title, Image
	local Section = Tab:CreateSection("倍速")

	local speed = 5
	local Dropdown = Tab:CreateDropdown({
		Name = "选择倍速",
		Options = {"1","2", "3", "4", "5"},
		CurrentOption = {"5"},
		MultipleOptions = false,
		Callback = function(Options)
			speed = tonumber(unpack(Options))
		end,
	})
	local V1 = false
	local Toggle = Tab:CreateToggle({
		Name = "锁定倍速",
		CurrentValue = false,
		Callback = function(Value)
			V1 = Value
			pcall(function()
				while V1 do
					repeat wait() until game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Speed").Value ~= speed
					game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Speed"):WaitForChild("Change"):FireServer(tonumber(speed))
				end
			end)
		end,
	})

	local Section = Tab:CreateSection("录制")
	local Button = Tab:CreateButton({
		Name = "开始录制\n（一定要点击重播之后再录制）\n（点击重播自动结束录制)",
		Callback = function()
			inc = true
			local hook; hook = hookmetamethod(game,"__namecall",function(self,...)
				if inc then
					local method = getnamecallmethod():lower()
					if tostring(method) == "fireserver" then
						if self == plev then --放置塔
							local args = {...}
							AddF(plev,args)
						elseif self == sel then --售卖塔
							local args = {...}
							AddF(sel,args)
						elseif self == up then --升级塔
							local args = {...}
							AddF(up,args)
						elseif self == af then --更改攻击方式
							local args = {...}
							AddF(af,args)
						elseif self == ws then --跳过波
							local args = {...}
							AddF(ws,args)
						elseif self == slboost then
							local args = {...}
							AddF(slboost,args)
						elseif self == timestop then
							AddF(timestop)
						elseif self == rp then
							Save(F,character.Value)
							inc = false
						end
					end
				end
				return hook(self,...)
			end)
		end,
	})

	local V = false
	local Toggle = Tab:CreateToggle({
		Name = "开始执行\n请在重播页面开启",
		CurrentValue = false,
		Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			V = Value
			local data = Load(character.Value)
			if data then
				while V do
					for i,v in pairs(data) do
						repeat wait() until times.Value >= tonumber(v[1])
						if v[2] == "placeTower" then
							pcall(function()
								local cefra = v[4]:split(", ")
								game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild(tostring(v[2])):FireServer(v[3],CFrame.new(unpack(cefra)),v[5] == "true")
							end)
						elseif v[2] == "waveSkip" then
							pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild(tostring(v[2])):FireServer(v[3] == "true")
							end)
						elseif v[2] == "BoostSelect" then
							pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("BoostSelect"):FireServer(tonumber(tonumber(v[3]) + tonumber(firsttower) - 1),tostring(tonumber(v[4]) + tonumber(firsttower) - 1))
							end)
						elseif v[2] == "TimestopEvent" then
							pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("TimestopEvent"):FireServer()
							end)
						else
							pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild(tostring(v[2])):FireServer(tostring(tonumber(v[3]) + tonumber(firsttower) - 1))
							end)
						end
						if V == false then
							return
						end
						if gameend.Value == true then
							break
						end
						wait()
					end
					if V == false then
						return
					end
					repeat game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("waveSkip"):FireServer(true) wait(0.1) until gameend.Value == true
					times.Value = 0
					repeat 
						rp:FireServer()
						wait()
					until gameend.Value == false
					repeat
						rd:FireServer(game:GetService("Players").LocalPlayer)
						wait()
					until times.Value ~= 0
				end
			else
				print("数据没找到")
			end
		end,
	})
elseif game.PlaceId == 14279693118 then --大厅
	local player = game:GetService("Players").LocalPlayer
	local SaveAbb = {"Eq1","Eq2","Eq3","Eq4","Eq5","Eq6","Eq7","Eq8","Eq9","Eq10"}
	local Tab = Window:CreateTab("主要功能", "camera") -- Title, Image
	local Section = Tab:CreateSection("保存塔")

	local slc = "1"

	local Dropdown = Tab:CreateDropdown({
		Name = "选择槽位",
		Options = {"1","2","3","4","5","6","7","8","9","10"},
		CurrentOption = {"1"},
		MultipleOptions = false,
		Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Options)
			slc = unpack(Options)
		end,
	})

	local Button = Tab:CreateButton({
		Name = "保存当前装备的塔到该槽位",
		Callback = function()
			local eq = {}
			for i,v in pairs(SaveAbb) do
				eq[v] = player:GetAttribute(v)
			end
			Save(eq,slc,"SaveTowers")
		end,
	})

	local Button = Tab:CreateButton({
		Name = "加载当前槽位保存的塔",
		Callback = function()
			local data = Load(slc,"SaveTowers")
			if data then
				for i,v in pairs(SaveAbb) do
					pcall(function()
						game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("equipID"):FireServer(player:GetAttribute(v),false)
						game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("equipID"):FireServer(data[v],true)
					end)
				end
			end
		end,
	})
end
