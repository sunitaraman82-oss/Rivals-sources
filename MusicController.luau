-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("SoundService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v5 = require(v1.Modules.EventLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Equipment"))
local v_u_11 = v5.IS_ACTIVE and (v5.EVENT_DETAILS.LOBBY_MUSIC or "Default") or "Default"
local v_u_12 = v5.IS_ACTIVE and v5.EVENT_DETAILS.LOBBY_MUSIC_MUFFLED or "DefaultMuffled"
local v_u_13 = {
	[""] = { "", 1 },
	["Default"] = { "rbxassetid://17697682466", 1 },
	["DefaultMuffled"] = { "rbxassetid://17733314783", 1 },
	["Spooky"] = { "rbxassetid://100081814360953", 1 },
	["SpookyMuffled"] = { "rbxassetid://86062306109271", 0.5 },
	["Festive"] = { "rbxassetid://82135261819112", 1 },
	["FestiveMuffled"] = { "rbxassetid://96771526359691", 1 },
	["Obby"] = { "rbxassetid://91718252417630", 1 },
	["Spleef"] = { "rbxassetid://91718252417630", 1 },
	["ZombieTower"] = { "rbxassetid://119694504935889", 1 }
}
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14._new() -- name: _new
	-- upvalues: (copy) v_u_14, (copy) v_u_13
	local v15 = v_u_14
	local v16 = setmetatable({}, v15)
	v16.LocalFighter = nil
	v16._volume = 0.5
	v16._sound_name = ""
	v16._sound_info = v_u_13.
	v16._is_tweening = false
	v16._sound = Instance.new("Sound")
	v16._next_sound = Instance.new("Sound")
	v16._volume_multiplier = 1
	v16._duel_subject_connections = {}
	v16:_Init()
	return v16
end
function v_u_14.SetSoundID(p17, p18, p19) -- name: SetSoundID
	-- upvalues: (copy) v_u_13
	local v20 = not p18 or v_u_13[p18]
	assert(v20, "Argument 1 invalid, expected a string or nil")
	local v21 = not p19 or typeof(p19) == "number"
	assert(v21, "Argument 2 invalid, expected a number or nil")
	if p18 ~= p17._sound_name then
		p17._sound_name = p18 or ""
		p17._sound_info = v_u_13[p17._sound_name]
		p17._volume_multiplier = p19 or 1
		task.spawn(p17._TweenSoundID, p17)
	end
end
function v_u_14.SetVolume(p22, p23) -- name: SetVolume
	local v24 = typeof(p23) == "number"
	assert(v24, "Argument 1 invalid, expected a number")
	p22._volume = p23
	p22:_UpdateVolume()
end
function v_u_14._UpdateSoundGroups(_, p25, p26) -- name: _UpdateSoundGroups
	-- upvalues: (copy) v_u_7, (copy) v_u_2
	local v27 = v_u_2.Master
	local v28
	if p25 == "Master Volume" then
		v28 = p26
	else
		v28 = v_u_7:GetSetting("Master Volume")
	end
	v27.Volume = v28
	local v29 = v_u_2.Master.Music
	local v30
	if p25 == "Music Volume" then
		v30 = p26
	else
		v30 = v_u_7:GetSetting("Music Volume")
	end
	v29.Volume = v30
	local v31 = v_u_2.Master.Other
	local v32
	if p25 == "Other Volume" then
		v32 = p26
	else
		v32 = v_u_7:GetSetting("Other Volume")
	end
	v31.Volume = v32
	local v33 = v_u_2.Master.Finisher
	local v34
	if p25 == "Finisher Volume" then
		v34 = p26
	else
		v34 = v_u_7:GetSetting("Finisher Volume")
	end
	v33.Volume = v34
	local v35 = v_u_2.Master.Emote
	if p25 ~= "Emote Volume" then
		p26 = v_u_7:GetSetting("Emote Volume")
	end
	v35.Volume = p26
end
function v_u_14._GetCurrentEmoteInfo(_) -- name: _GetCurrentEmoteInfo
	-- upvalues: (copy) v_u_8, (copy) v_u_10, (copy) v_u_4
	local v36 = v_u_8.CurrentSubject and v_u_8.CurrentSubject.Entity
	if v36 then
		v36 = v_u_8.CurrentSubject.Entity:GetCurrentEmote()
	end
	if v36 then
		return v36.Info
	end
	local v37 = v_u_10.IsOpen
	if v37 then
		v37 = v_u_10.EquipmentState.SelectedCosmetic
	end
	local v38 = v_u_4.Cosmetics[v37]
	if v38 and v38.Type == "Emote" then
		return v38
	end
end
function v_u_14._GetVolume(p39) -- name: _GetVolume
	local v40 = p39._sound_info[2]
	local v41 = p39:_GetCurrentEmoteInfo()
	local v42 = v41 and v41.IsAudioIntrusive and 0 or 1
	return v40 * p39._volume_multiplier * p39._volume * v42
end
function v_u_14._TweenSoundID(p_u_43) -- name: _TweenSoundID
	-- upvalues: (copy) v_u_6
	if not p_u_43._is_tweening then
		p_u_43._is_tweening = true
		while p_u_43._sound.SoundId ~= p_u_43._sound_info[1] do
			local v44 = (p_u_43._sound_name == "" or p_u_43._sound.SoundId == "") and 0.25 or 2
			p_u_43._next_sound.SoundId = p_u_43._sound_info[1]
			if p_u_43._sound_name ~= "" then
				p_u_43._next_sound:Play()
				p_u_43._next_sound.TimePosition = p_u_43._sound.TimePosition
			end
			local v_u_45 = p_u_43._sound.Volume
			v_u_6:RenderstepForLoop(0, 100, v44, function(p46)
				-- upvalues: (copy) p_u_43, (copy) v_u_45
				local v47 = p46 / 100
				p_u_43._sound.Volume = (1 - v47) * v_u_45
				p_u_43._next_sound.Volume = v47 * p_u_43:_GetVolume()
			end)
			p_u_43._sound:Stop()
			local v48 = p_u_43._next_sound
			p_u_43._next_sound = p_u_43._sound
			p_u_43._sound = v48
		end
		p_u_43._is_tweening = false
	end
end
function v_u_14._UpdateVolume(p49) -- name: _UpdateVolume
	if not p49._is_tweening then
		p49._sound.Volume = p49:_GetVolume()
	end
end
function v_u_14._UpdateSoundID(p50) -- name: _UpdateSoundID
	-- upvalues: (copy) v_u_10, (copy) v_u_8, (copy) v_u_12, (copy) v_u_11
	p50:SetSoundID((v_u_10.IsOpen or v_u_8.CurrentDuelSubject and v_u_8.CurrentDuelSubject:Get("Status") == "GameOver") and v_u_12 or (not v_u_8.CurrentDuelSubject and (p50.LocalFighter and not p50.LocalFighter:Get("IsInShootingRange")) and true or false) and v_u_11 or (v_u_8.CurrentDuelSubject and v_u_8.CurrentDuelSubject:Get("DuelMusic") or nil))
end
function v_u_14._DuelSubjectChanged(p_u_51) -- name: _DuelSubjectChanged
	-- upvalues: (copy) v_u_8
	p_u_51:_UpdateSoundID()
	if v_u_8.CurrentDuelSubject then
		local v52 = p_u_51._duel_subject_connections
		local v53 = v_u_8.CurrentDuelSubject:GetDataChangedSignal("DuelMusic")
		table.insert(v52, v53:Connect(function()
			-- upvalues: (copy) p_u_51
			p_u_51:_UpdateSoundID()
		end))
	end
end
function v_u_14._HookLocalFighter(p_u_54) -- name: _HookLocalFighter
	-- upvalues: (copy) v_u_9
	p_u_54.LocalFighter = v_u_9:WaitForLocalFighter()
	p_u_54.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
		-- upvalues: (copy) p_u_54
		p_u_54:_UpdateSoundID()
	end)
	p_u_54.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
		-- upvalues: (copy) p_u_54
		p_u_54:_UpdateSoundID()
	end)
	p_u_54:_UpdateSoundID()
end
function v_u_14._Setup(p55) -- name: _Setup
	-- upvalues: (copy) v_u_2
	p55._sound.Name = "Music"
	p55._sound.Looped = true
	p55._sound.SoundGroup = v_u_2.Master.Music
	p55._sound.Parent = script
	p55._next_sound.Name = "NextMusic"
	p55._next_sound.Looped = true
	p55._next_sound.SoundGroup = v_u_2.Master.Music
	p55._next_sound.Parent = script
end
function v_u_14._Init(p_u_56) -- name: _Init
	-- upvalues: (copy) v_u_8, (copy) v_u_10, (copy) v_u_7
	v_u_8.DuelSubjectChanged:Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_DuelSubjectChanged()
	end)
	v_u_8.DuelSubjectStatusChanged:Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundID()
	end)
	v_u_8.SubjectEmoteStatusChanged:Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateVolume()
	end)
	v_u_10.Opened:Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundID()
		p_u_56:_UpdateVolume()
	end)
	v_u_10.CustomizingStateChanged:Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateVolume()
	end)
	v_u_7:GetSettingChangedSignal("Master Volume"):Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundGroups()
	end)
	v_u_7:GetSettingChangedSignal("Music Volume"):Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundGroups()
	end)
	v_u_7:GetSettingChangedSignal("Other Volume"):Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundGroups()
	end)
	v_u_7:GetSettingChangedSignal("Finisher Volume"):Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundGroups()
	end)
	v_u_7:GetSettingChangedSignal("Emote Volume"):Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateSoundGroups()
	end)
	v_u_7.SettingsSliderChanged:Connect(function(p57, p58)
		-- upvalues: (copy) p_u_56
		if p57 == "Master Volume" or p57 == "Music Volume" then
			p_u_56:_UpdateSoundGroups(p57, p58)
		end
	end)
	p_u_56:_Setup()
	p_u_56:_UpdateVolume()
	p_u_56:_DuelSubjectChanged()
	task.spawn(p_u_56._HookLocalFighter, p_u_56)
	task.defer(p_u_56._UpdateSoundGroups, p_u_56)
end
return v_u_14._new()