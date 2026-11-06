-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.Signal)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_9 = require(script:WaitForChild("EmoteRenderLogic"))
local v_u_10 = require(script:WaitForChild("EmoteSoundLogic"))
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11._new() -- name: _new
	-- upvalues: (copy) v_u_11, (copy) v_u_3, (copy) v_u_9, (copy) v_u_10
	local v12 = v_u_11
	local v13 = setmetatable({}, v12)
	v13.CanEmoteChanged = v_u_3.new()
	v13.EmoteRenderLogic = v_u_9.new(v13)
	v13.EmoteSoundLogic = v_u_10.new(v13)
	v13._emoting_cooldown = 0
	v13._equipping_items_cooldown = 0
	v13:_Init()
	return v13
end
function v_u_11.IsEquippingItemsDisabled(p14) -- name: IsEquippingItemsDisabled
	return tick() < p14._equipping_items_cooldown
end
function v_u_11.CanEmote(p15, p16) -- name: CanEmote
	-- upvalues: (copy) v_u_4, (copy) v_u_7, (copy) v_u_2, (copy) v_u_8, (copy) v_u_6, (copy) v_u_5
	if v_u_4:IsEquipmentOpen() or not p16 and v_u_4:IsPageOpen() or tick() < p15._emoting_cooldown then
		return false
	end
	local v17 = v_u_7:GetFighter(v_u_2.LocalPlayer)
	local v18
	if v17 then
		v18 = v17:Get("IsSpectating")
	else
		v18 = v17
	end
	local v19
	if v_u_8:GetPublicState() == v_u_8.CameraState.States.CustomFreecam then
		v19 = not v_u_6.CurrentDuelSubject or v_u_6.CurrentDuelSubject.LocalDueler
	else
		v19 = false
	end
	if not (v18 or v19) then
		return false
	end
	local v20 = v17.IsLocalPlayer and (v17:IsAlive() and not v17.Entity:Get("IsFrozen"))
	if v20 then
		v20 = next(v_u_5:Get("EquippedEmotes")) ~= nil
	end
	return v20
end
function v_u_11.UseEmote(p21, p22) -- name: UseEmote
	-- upvalues: (copy) v_u_5
	local v23 = v_u_5:Get("EquippedEmotes")[p22]
	if v23 then
		p21:UseEmoteByName(v23.Name)
	end
end
function v_u_11.UseEmoteByName(p24, p25) -- name: UseEmoteByName
	-- upvalues: (copy) v_u_1
	p24._equipping_items_cooldown = tick() + 0.5
	v_u_1.Remotes.Replication.Fighter.UseEmoteByName:FireServer(p25)
end
function v_u_11.EquipEmote(_, p26, p27) -- name: EquipEmote
	-- upvalues: (copy) v_u_1
	v_u_1.Remotes.Data.EquipEmote:FireServer(p26, p27)
end
function v_u_11._FighterAdded(p_u_28, p29) -- name: _FighterAdded
	if p29.IsLocalPlayer then
		local function v_u_30() -- name: changed
			-- upvalues: (copy) p_u_28
			p_u_28.CanEmoteChanged:Fire()
		end
		p29:GetDataChangedSignal("IsSpectating"):Connect(v_u_30)
		p29.HealthChanged:Connect(v_u_30)
		p_u_28.CanEmoteChanged:Fire()
		local function v32(p31) -- name: entity_added
			-- upvalues: (copy) v_u_30, (copy) p_u_28
			p31:GetDataChangedSignal("IsFrozen"):Connect(v_u_30)
			p_u_28.CanEmoteChanged:Fire()
		end
		p29.EntityAdded:Connect(v32)
		if p29.Entity then
			task.spawn(v32, p29.Entity)
		end
		p29.EquippedItemChanged:Connect(function()
			-- upvalues: (copy) p_u_28, (copy) v_u_30
			p_u_28._emoting_cooldown = tick() + 0.5
			p_u_28.CanEmoteChanged:Fire()
			task.delay(0.5, v_u_30)
		end)
	end
end
function v_u_11._Init(p_u_33) -- name: _Init
	-- upvalues: (copy) v_u_5, (copy) v_u_8, (copy) v_u_6, (copy) v_u_4, (copy) v_u_7
	v_u_5:GetDataChangedSignal("EquippedEmotes"):Connect(function()
		-- upvalues: (copy) p_u_33
		p_u_33.CanEmoteChanged:Fire()
	end)
	v_u_8.StateChanged:Connect(function()
		-- upvalues: (copy) p_u_33
		p_u_33.CanEmoteChanged:Fire()
	end)
	v_u_6.DuelSubjectChanged:Connect(function()
		-- upvalues: (copy) p_u_33
		p_u_33.CanEmoteChanged:Fire()
	end)
	v_u_4.PageSystemPagesActivity:Connect(function()
		-- upvalues: (copy) p_u_33
		p_u_33.CanEmoteChanged:Fire()
	end)
	v_u_4.EquipmentOpened:Connect(function()
		-- upvalues: (copy) p_u_33
		p_u_33.CanEmoteChanged:Fire()
	end)
	v_u_7.ObjectAdded:Connect(function(p34)
		-- upvalues: (copy) p_u_33
		p_u_33:_FighterAdded(p34)
	end)
	for _, v35 in pairs(v_u_7.Objects) do
		task.spawn(p_u_33._FighterAdded, p_u_33, v35)
	end
end
return v_u_11._new()