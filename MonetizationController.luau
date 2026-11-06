-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("MarketplaceService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.MonetizationLibrary)
local v_u_5 = require(v_u_2.Modules.Utility)
local v_u_6 = require(v_u_2.Modules.Signal)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new() -- name: _new
	-- upvalues: (copy) v_u_8, (copy) v_u_6
	local v9 = v_u_8
	local v10 = setmetatable({}, v9)
	v10.PurchaseStarted = v_u_6.new()
	v10.PurchaseFinished = v_u_6.new()
	v10._fetch_robux_price_hashes = {}
	v10:_Init()
	return v10
end
function v_u_8.PromptBulkPurchase(p11, p12) -- name: PromptBulkPurchase
	-- upvalues: (copy) v_u_2
	local v13 = typeof(p12) == "table"
	local v14 = "Argument 1 invalid, expected a table, got " .. tostring(p12)
	assert(v13, v14)
	v_u_2.Remotes.Misc.PromptBulkPurchase:FireServer(p12)
	p11:_StartPrompt()
end
function v_u_8.PromptPurchase(p15, p16) -- name: PromptPurchase
	-- upvalues: (copy) v_u_1, (copy) v_u_3
	local v17 = typeof(p16) == "number"
	local v18 = "Argument 1 invalid, expected a number, got " .. tostring(p16)
	assert(v17, v18)
	v_u_1:PromptPurchase(v_u_3.LocalPlayer, p16)
	p15:_StartPrompt()
end
function v_u_8.PromptProductPurchase(p19, p20) -- name: PromptProductPurchase
	-- upvalues: (copy) v_u_1, (copy) v_u_3
	local v21 = typeof(p20) == "number"
	local v22 = "Argument 1 invalid, expected a number, got " .. tostring(p20)
	assert(v21, v22)
	v_u_1:PromptProductPurchase(v_u_3.LocalPlayer, p20)
	p19:_StartPrompt()
end
function v_u_8.PromptGamePassPurchase(p23, p24) -- name: PromptGamePassPurchase
	-- upvalues: (copy) v_u_7, (copy) v_u_4, (copy) v_u_1, (copy) v_u_3
	local v25 = typeof(p24) == "number"
	local v26 = "Argument 1 invalid, expected a number, got " .. tostring(p24)
	assert(v25, v26)
	if not v_u_7:HasGamepass(v_u_4:GetGamepassName(p24)) then
		v_u_1:PromptGamePassPurchase(v_u_3.LocalPlayer, p24)
		p23:_StartPrompt()
	end
end
function v_u_8.PromptSubscriptionPurchase(p27, p28) -- name: PromptSubscriptionPurchase
	-- upvalues: (copy) v_u_1, (copy) v_u_3
	local v29 = typeof(p28) == "string"
	local v30 = "Argument 1 invalid, expected a string, got " .. tostring(p28)
	assert(v29, v30)
	v_u_1:PromptSubscriptionPurchase(v_u_3.LocalPlayer, p28)
	p27:_StartPrompt()
end
function v_u_8.PromptCurrencyBundlePurchase(p31, p32, p33) -- name: PromptCurrencyBundlePurchase
	-- upvalues: (copy) v_u_7, (copy) v_u_4
	local v34 = p32 - v_u_7:Get(p33)
	if v34 <= 0 then
		return
	else
		local v35 = p33 == "WeaponKeys" and v_u_4.NUM_KEY_BUNDLES or (p33 == "EventCurrency" and v_u_4.NUM_EVENT_CURRENCY_BUNDLES or nil)
		local v36 = p33 == "WeaponKeys" and "keybundle_" or (p33 == "EventCurrency" and "eventcurrencybundle_" or nil)
		if v35 and v36 then
			for v37 = 1, v35 do
				local v38 = v_u_4.Bundles[v36 .. v37]
				if v34 <= v38.Rewards[1].Quantity then
					p31:PromptProductPurchase(v38.ProductID)
					return true
				end
			end
		end
	end
end
function v_u_8.FetchRobuxPrice(_, p39, p40) -- name: FetchRobuxPrice
	-- upvalues: (copy) v_u_1
	local v42, v42 = pcall(v_u_1.GetProductInfoAsync, v_u_1, p39, p40 or Enum.InfoType.Product)
	if not v42 then
		warn("Failed to fetch robux price:", v42)
	end
	if v42 then
		if v42 then
			v42 = v42.PriceInRobux
		end
	end
	return v42
end
function v_u_8.SetRobuxText(p_u_43, p_u_44, ...) -- name: SetRobuxText
	p_u_43._fetch_robux_price_hashes[p_u_44] = (p_u_43._fetch_robux_price_hashes[p_u_44] or 0) + 1
	local v_u_45 = p_u_43._fetch_robux_price_hashes[p_u_44]
	task.spawn(function(...)
		-- upvalues: (copy) p_u_44, (copy) p_u_43, (copy) v_u_45
		p_u_44.Text = "\226\128\162 \226\128\162 \226\128\162"
		p_u_44.Text = p_u_43:_GetRobuxText(v_u_45, p_u_44, ...) or p_u_44.Text
	end, ...)
end
function v_u_8.SetRobuxTextWithFormat(p_u_46, p_u_47, p_u_48, ...) -- name: SetRobuxTextWithFormat
	p_u_46._fetch_robux_price_hashes[p_u_48] = (p_u_46._fetch_robux_price_hashes[p_u_48] or 0) + 1
	local v_u_49 = p_u_46._fetch_robux_price_hashes[p_u_48]
	task.spawn(function(...)
		-- upvalues: (copy) p_u_48, (copy) p_u_46, (copy) v_u_49, (copy) p_u_47
		p_u_48.Text = "\226\128\162 \226\128\162 \226\128\162"
		local v50 = p_u_46:_GetRobuxText(v_u_49, p_u_48, ...)
		if v50 then
			p_u_48.Text = string.format(p_u_47, v50)
		end
	end, ...)
end
function v_u_8.VerifyUGC(_, p51) -- name: VerifyUGC
	-- upvalues: (copy) v_u_2
	v_u_2.Remotes.Data.VerifyUGC:FireServer(p51)
end
function v_u_8._GetRobuxText(p52, p53, p54, ...) -- name: _GetRobuxText
	-- upvalues: (copy) v_u_5
	local v55 = { ... }
	local v56 = 0
	for v57 = 1, #v55, 2 do
		local v58 = p52:FetchRobuxPrice(v55[v57], v55[v57 + 1])
		if p53 ~= p52._fetch_robux_price_hashes[p54] or not v58 then
			return
		end
		v56 = v56 + v58
	end
	return utf8.char(57346) .. " " .. v_u_5:PrettyNumber(v56)
end
function v_u_8._StartPrompt(p59) -- name: _StartPrompt
	p59.PurchaseStarted:Fire()
end
function v_u_8._FinishPrompt(p60, p61) -- name: _FinishPrompt
	p60.PurchaseFinished:Fire(p61)
end
function v_u_8._Init(p_u_62) -- name: _Init
	-- upvalues: (copy) v_u_1, (copy) v_u_4, (copy) v_u_2
	v_u_1.PromptBulkPurchaseFinished:Connect(function(_, _, p63)
		-- upvalues: (copy) p_u_62, (ref) v_u_4
		local v64 = false
		for _, v65 in pairs(p63.Items) do
			if v65.status == Enum.MarketplaceItemPurchaseStatus.Success then
				v64 = true
				break
			end
		end
		p_u_62:_FinishPrompt(v64)
		if v64 then
			local v66 = {}
			for _, v67 in pairs(p63.Items) do
				local v68 = v_u_4.UGCAssetIDToName
				local v69 = v67.id
				local v70 = v68[tostring(v69)]
				if v70 then
					table.insert(v66, v70)
				end
			end
			if #v66 > 0 then
				p_u_62:VerifyUGC(v66)
			end
		end
	end)
	v_u_2.Remotes.Misc.StartPurchasePrompt.OnClientEvent:Connect(function()
		-- upvalues: (copy) p_u_62
		p_u_62:_StartPrompt()
	end)
	v_u_2.Remotes.Misc.FinishPurchasePrompt.OnClientEvent:Connect(function(p71)
		-- upvalues: (copy) p_u_62
		p_u_62:_FinishPrompt(p71)
	end)
end
return v_u_8._new()