function InitializeNewGame()
	local aPlayers = PlayerManager.GetAlive();


	for loop, pPlayer in ipairs(aPlayers) do
		local iPlayer = pPlayer:GetID();
		local pScience:table = pPlayer:GetTechs();

		pScience:SetTech(GameInfo.Technologies["TECH_SCOUTSAIL"].Index, true);
	
	end

end;


LuaEvents.NewGameInitialized.Add(InitializeNewGame);