-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1:WaitForChild("Modules"):WaitForChild("EnumLibrary"))
local v_u_4 = require(v_u_1:WaitForChild("Modules"):WaitForChild("Signal"))
local v_u_5 = require(v2.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientPlayerData"))
local v6 = v_u_1:WaitForChild("Remotes"):WaitForChild("Data")
local v_u_7 = v6:WaitForChild("RequestPlayerData")
local v_u_8 = v6:WaitForChild("PlayerDataChanged")
local v_u_9 = v6:WaitForChild("PlayerDataAdded")
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new() -- name: _new
	-- upvalues: (copy) v_u_10, (copy) v_u_4
	local v11 = v_u_10
	local v12 = setmetatable({}, v11)
	v12.PlayerDataAdded = v_u_4.new()
	v12.StatisticsUpdated = v_u_4.new()
	v12.SettingsSliderChanged = v_u_4.new()
	v12.CurrentData = nil
	v12._setting_changed_events = {}
	v12:_Init()
	return v12
end
function v_u_10.Get(p13, ...) -- name: Get
	return p13.CurrentData:Get(...)
end
function v_u_10.Set(p14, ...) -- name: Set
	return p14.CurrentData:Set(...)
end
function v_u_10.GetDataChangedSignal(p15, ...) -- name: GetDataChangedSignal
	return p15.CurrentData:GetDataChangedSignal(...)
end
function v_u_10.GetSetting(p16, ...) -- name: GetSetting
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetSetting(p16, ...)
end
function v_u_10.GetSettingChangedSignal(p17, ...) -- name: GetSettingChangedSignal
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetSettingChangedSignal(p17, ...)
end
function v_u_10.SetSetting(p18, ...) -- name: SetSetting
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):SetSetting(p18, ...)
end
function v_u_10.IsNosniyGamesTeamMember(p19, ...) -- name: IsNosniyGamesTeamMember
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):IsNosniyGamesTeamMember(p19, ...)
end
function v_u_10.GetWeaponData(p20, ...) -- name: GetWeaponData
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetWeaponData(p20, ...)
end
function v_u_10.HasGamepass(p21, ...) -- name: HasGamepass
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):HasGamepass(p21, ...)
end
function v_u_10.GetStatistic(p22, ...) -- name: GetStatistic
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetStatistic(p22, ...)
end
function v_u_10.GetDirectoryStatistic(p23, ...) -- name: GetDirectoryStatistic
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetDirectoryStatistic(p23, ...)
end
function v_u_10.GetWeaponStatistic(p24, ...) -- name: GetWeaponStatistic
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetWeaponStatistic(p24, ...)
end
function v_u_10.GetMapStatistic(p25, ...) -- name: GetMapStatistic
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetMapStatistic(p25, ...)
end
function v_u_10.GetUnlockedWeapons(p26, ...) -- name: GetUnlockedWeapons
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):GetUnlockedWeapons(p26, ...)
end
function v_u_10.AreTasksCompleted(p27, ...) -- name: AreTasksCompleted
	-- upvalues: (copy) v_u_1
	return require(v_u_1.Modules.PlayerDataUtility):AreTasksCompleted(p27, ...)
end
function v_u_10.GetFavoritedWeapons(p28) -- name: GetFavoritedWeapons
	local v29 = {}
	for _, v30 in pairs(p28:Get("WeaponInventory")) do
		if v30.IsFavorited then
			v29[v30.Name] = true
		end
	end
	return v29
end
function v_u_10.OwnsAllWeapons(p31, p32, p33, p34) -- name: OwnsAllWeapons
	-- upvalues: (copy) v_u_1
	local v35 = require(v_u_1.Modules.ItemLibrary)
	local v36 = require(v_u_1.Modules.ShopLibrary)
	local v37 = 0
	local v38 = 0
	for _, v39 in pairs(v36:GetReleasedOwnableWeapons()) do
		if (not p32 or v35.Items[v39].Status == p32) and ((not p34 or v36:IsWeaponReleased(v39)) and (not p33 or v36.Weapons[v39].KeyPrice)) then
			v37 = v37 + 1
		end
	end
	for _, v40 in pairs(p31:Get("WeaponInventory")) do
		if not p32 or v35.Items[v40.Name].Status == p32 then
			local v41 = not p34 or v36:IsWeaponReleased(v40.Name)
			local v42 = (p33 and true or false) and v36.Weapons[v40.Name]
			if v42 then
				v42 = v36.Weapons[v40.Name].KeyPrice
			end
			if v41 and v42 then
				v38 = v38 + 1
			end
		end
	end
	return v37 <= v38
end
function v_u_10.GetNumTasksCompleted(p43, p44) -- name: GetNumTasksCompleted
	local v45 = 0
	for _, v46 in pairs(p43:Get(p44 or "Tasks")) do
		if v46.Completed then
			v45 = v45 + 1
		end
	end
	return v45
end
function v_u_10.IsEmoteEquipped(p47, p48) -- name: IsEmoteEquipped
	for _, v49 in pairs(p47:Get("EquippedEmotes")) do
		if v49.Name == p48 then
			return true
		end
	end
end
function v_u_10.SilenceCosmeticNotification(p50, p51, p52) -- name: SilenceCosmeticNotification
	-- upvalues: (copy) v_u_1
	if p51 then
		local v53 = p50:Get("CosmeticNotifications")
		if p52 then
			local v54 = v53[p51]
			if typeof(v54) == "table" then
				v53[p51][p52] = nil
				p50.CurrentData:Replicate("CosmeticNotifications")
				v_u_1.Remotes.Data.SilenceCosmeticNotification:FireServer(p51, p52)
			end
		else
			v53[p51] = nil
			p50.CurrentData:Replicate("CosmeticNotifications")
			v_u_1.Remotes.Data.SilenceCosmeticNotification:FireServer(p51, nil)
		end
	else
		p50.CurrentData:SetReplicate("CosmeticNotifications", {})
		v_u_1.Remotes.Data.SilenceCosmeticNotification:FireServer(nil, nil)
		return
	end
end
function v_u_10.WaitUntilLoaded(p55) -- name: WaitUntilLoaded
	if not p55.CurrentData then
		p55.PlayerDataAdded:Wait()
	end
end
function v_u_10._PlayerDataChanged(p56, p57, ...) -- name: _PlayerDataChanged
	-- upvalues: (copy) v_u_3, (copy) v_u_1
	local v58 = p56.CurrentData
	if not v58 then
		return
	end
	v_u_3:WaitForEnumBuilder()
	local v59 = v_u_3:FromEnum(p57) or p57
	if v59 == "DataValueChanged" then
		v58:SetReplicate(...)
		return
	end
	if v59 == "BulkDataValueChanged" then
		for _, v60 in pairs((...)) do
			v58:SetReplicate(v60[1], v60[2])
		end
		return
	end
	if v59 == "StatisticsBatchUpdate" then
		local v61 = require(v_u_1.Modules.StatisticsLibrary)
		local v62 = ...
		for v63, v64 in pairs(v62[utf8.char(0)] or {}) do
			v58:Set(v58:FromEnum(v63), v64)
		end
		for v65, v66 in pairs(v61.STATISTICS_DIRECTORY_INFO) do
			local v67, _ = table.unpack(v66)
			local v68 = p56:Get(v67)
			for v69, v70 in pairs(v62[utf8.char(0 + v65)] or {}) do
				local v71 = v58:FromEnum(v69)
				v68[v71] = v68[v71] or {}
				for v72, v73 in pairs(v70) do
					v68[v71][v58:FromEnum(v72)] = v73
				end
			end
		end
		p56.StatisticsUpdated:Fire()
		return
	end
	if v59 ~= "WeaponDataChanged" then
		if v59 == "BatchUpdateWeaponXP" then
			local v74 = false
			for _, v75 in pairs((...)) do
				local v76 = p56:GetWeaponData(v58:FromEnum(v75[utf8.char(0)]))
				if v76 then
					v76.Level = v75[utf8.char(1)]
					v76.XP = v75[utf8.char(2)]
					v74 = true
				end
			end
			if v74 then
				v58:Replicate("WeaponInventory")
				return
			end
		else
			if v59 == "SettingChanged" then
				p56:SetSetting(...)
				return
			end
			if v59 == "AddReceipt" then
				local v77 = v58:Get("Receipts")
				table.insert(v77, (...))
				v58:Replicate("Receipts")
				return
			end
			v58:ReplicateFromServer(v59, ...)
		end
		return
	end
	local v78 = v58:Get("WeaponInventory")
	local v79 = ...
	for v80, v81 in pairs(v78) do
		if v81.Name == v79.Name then
			v78[v80] = v79
			break
		end
	end
	v58:Replicate("WeaponInventory")
end
function v_u_10._CreatePlayerData(p82, p83) -- name: _CreatePlayerData
	-- upvalues: (copy) v_u_5
	local v84 = typeof(p83) == "table"
	local v85 = "Argument 1 invalid, expected a table, got " .. tostring(p83)
	assert(v84, v85)
	local v86 = v_u_5.new(p83)
	p82.CurrentData = v86
	p82.PlayerDataAdded:Fire(v86)
end
function v_u_10._RequestPlayerData(p87) -- name: _RequestPlayerData
	-- upvalues: (copy) v_u_7
	local v88 = v_u_7:InvokeServer()
	if v88 then
		p87:_CreatePlayerData(v88)
	end
end
function v_u_10._Init(p_u_89) -- name: _Init
	-- upvalues: (copy) v_u_8, (copy) v_u_9
	v_u_8.OnClientEvent:Connect(function(...)
		-- upvalues: (copy) p_u_89
		p_u_89:_PlayerDataChanged(...)
	end)
	v_u_9.OnClientEvent:Connect(function(...)
		-- upvalues: (copy) p_u_89
		p_u_89:_CreatePlayerData(...)
	end)
	task.spawn(p_u_89._RequestPlayerData, p_u_89)
end
return v_u_10._new()