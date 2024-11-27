local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
task.spawn(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
end)

local httpService = game:GetService("HttpService")
local plev = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("placeTower")
local sel = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("RemoveTower")
local up = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("UpgradeTower")
local af = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("ChangeTowerTargetMode")
local ws = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("waveSkip")
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

function Save(data)
	local fullPath = [[TDM\]]..character.Value..".json"
	local success, encoded = pcall(httpService.JSONEncode, httpService, data)
	if not success then
		return false
	end
	writefile(fullPath, encoded)
	return true
end

function Load()
	local file = [[TDM\]]..character.Value..".json"
	if not isfile(file) then return false end

	local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
	if not success then return false end
	return decoded
end
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
	end
end

local Window = Rayfield:CreateWindow({
	Name = "SDHub V2.1",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "SDHub",
	LoadingSubtitle = "by 牢大",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
	ConfigurationSaving = {
		Enabled = false,
	},
})

if game.PlaceId == 14279724900 then --游戏内
	local inc = false
	local Tab = Window:CreateTab("录制", "camera") -- Title, Image
	local Button = Tab:CreateButton({
		Name = "开始录制\n（点击重播之后在准备页面点击）\n（录制结束后点击重播自动结束)",
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
						elseif self == rp then
							Save(F)
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
			local data = Load()
			if data then
				while V do
					if gameend.Value == false then
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
							else
								pcall(function()
									game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild(tostring(v[2])):FireServer(tostring(tonumber(v[3]) + tonumber(firsttower) - 1))
								end)
							end
							if V == false or gameend.Value == true then
								break
							end
						end
						repeat wait() until gameend.Value == true
					else
						times.Value = 0
						rp:FireServer()
						wait(1)
						rd:FireServer(game:GetService("Players").LocalPlayer)
					end
					wait()
				end
			else
				print("数据没找到")
			end
		end,
	})
end
