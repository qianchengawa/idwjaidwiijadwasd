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

function Save(data)
	local fullPath = [[TDM\]]..character.Value..".json"
	local success, encoded = pcall(httpService.JSONEncode, httpService, data)
	if not success then
		return false
	end
	writefile(fullPath, encoded)
	Rayfield:Notify({
		Title = "TDM",
		Content = "文件保存成功！\n路径位于注入器文件夹\workspace\'TDM\当前章节.json'",
		Duration = 6.5,
		Image = "clock",
	})
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
	elseif event == slboost then
		local boost1 = tostring(args[1])
		local boost2 = tostring(args[2])
		F[#F+1] = {tostring(times.Value),event.Name,boost1,boost2}
	elseif event == timestop then
		F[#F+1] = {tostring(times.Value),event.Name}
	end
end

local Window = Rayfield:CreateWindow({
	Name = "TDM V0.9",
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

if game.PlaceId == 14279724900 then --游戏内
	local aaa = game:GetService("VirtualUser")
	game:GetService('Players').LocalPlayer.Idled:connect(function()
		aaa:CaptureController()
		aaa:ClickButton2(Vector2.new())
	end)
	Rayfield:Notify({
		Title = "TDM",
		Content = "防挂机踢注入成功！",
		Duration = 6.5,
		Image = "clock",
	})
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
			Rayfield:Notify({
				Title = "TDM",
				Content = "已切换为"..tostring(unpack(Options)).."倍速",
				Duration = 6.5,
				Image = "clock",
			})
		end,
	})
	local V1 = false
	local Toggle = Tab:CreateToggle({
		Name = "锁定倍速",
		CurrentValue = false,
		Callback = function(Value)
			if Value == true then
				Rayfield:Notify({
					Title = "TDM",
					Content = "已开启锁定倍速",
					Duration = 6.5,
					Image = "clock",
				})
			elseif Value == false then
				Rayfield:Notify({
					Title = "TDM",
					Content = "已关闭锁定倍速",
					Duration = 6.5,
					Image = "clock",
				})
			end
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
							Rayfield:Notify({
								Title = "TDM",
								Content = "放置 "..args[1],
								Duration = 6.5,
								Image = "clock",
							})
						elseif self == sel then --售卖塔
							local args = {...}
							Rayfield:Notify({
								Title = "TDM",
								Content = "售卖塔编号: "..args[1],
								Duration = 6.5,
								Image = "clock",
							})
							AddF(sel,args)
						elseif self == up then --升级塔
							local args = {...}
							Rayfield:Notify({
								Title = "TDM",
								Content = "升级塔编号: "..args[1],
								Duration = 6.5,
								Image = "clock",
							})
							AddF(up,args)
						elseif self == af then --更改攻击方式
							local args = {...}
							Rayfield:Notify({
								Title = "TDM",
								Content = "更改攻击方式塔编号: "..args[1],
								Duration = 6.5,
								Image = "clock",
							})
							AddF(af,args)
						elseif self == ws then --跳过波
							local args = {...}
							AddF(ws,args)
						elseif self == rp then
							Rayfield:Notify({
								Title = "TDM",
								Content = "检测到录制结束，尝试保存文件",
								Duration = 6.5,
								Image = "clock",
							})
							Save(F)
							inc = false
						elseif self == slboost then
							local args = {...}
							Rayfield:Notify({
								Title = "TDM",
								Content = "编号"..tostring(args[1]).."绑定 编号"..tostring(args[2]),
								Duration = 6.5,
								Image = "clock",
							})
							AddF(slboost,args)
						elseif self == timestop then
							Rayfield:Notify({
								Title = "TDM",
								Content = "咋瓦鲁多！",
								Duration = 6.5,
								Image = "clock",
							})
							AddF(timestop)
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
							if V == false or gameend.Value == true then
								break
							end
						end
						repeat wait() until gameend.Value == true
						times.Value = 0
					else
						times.Value = 0
						rp:FireServer()
						wait(1)
						rd:FireServer(game:GetService("Players").LocalPlayer)
					end
				end
			else
				print("数据没找到")
			end
		end,
	})
end
