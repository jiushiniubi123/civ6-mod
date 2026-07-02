
function OnLocalPlayerTurnBegin()	
	RF_TurnActiveFlag = true;
end


--ターン終了時に未来技術・未来の社会制度を選択しているかチェック
function OnLocalPlayerTurnEnd()	
	local playerID	:number = Game.GetLocalPlayer();
	local pPlayer	:table = Players[playerID];
	if (pPlayer == nil) then
		return;
	end

	--フラグの初期化	
	RF_FutureTechFlag = false
	RF_FutureCivicFlag = false
	
	--技術
	local playerTechnology	:table	= pPlayer:GetTechs();
	local iTechID			:number = playerTechnology:GetResearchingTech();			--選択している技術
	local tTechData = GameInfo.Technologies["TECH_FUTURE_TECH"];

	if(iTechID == tTechData.Index) then
		RF_FutureTechFlag = true
	end

	--社会制度
	local playerCulture	:table = pPlayer:GetCulture();
	local iCultureID		:number = playerCulture:GetProgressingCivic();				--選択している社会制度
	local tCivicData = GameInfo.Civics["CIVIC_FUTURE_CIVIC"];

	if(iCultureID == tCivicData.Index) then
		RF_FutureCivicFlag = true
	end

end


-- 未来の技術を繰り返しセットする
function TechnologyCheck(pPlayer)

	--直前のターン終了時に未来の技術が選ばれていた
	if(RF_FutureTechFlag) then
		local playerTechnology = pPlayer:GetTechs();
		if playerTechnology ~= nil then
			--現在研究中の技術をチェック
			local iTechID = playerTechnology:GetResearchingTech();
			--
			if(iTechID == -1) then
				local tParameters :table = {};
				tParameters[PlayerOperations.PARAM_TECH_TYPE] = -241112393;
				tParameters[PlayerOperations.PARAM_INSERT_MODE] = PlayerOperations.VALUE_EXCLUSIVE;
				UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.RESEARCH, tParameters);
			end
		end
	end
	
end

-- 未来の社会制度を繰り返しセットする
function CivicCheck(pPlayer)

	--直前のターン終了時に未来の社会制度が選ばれていた
	if(RF_FutureCivicFlag) then
		local playerCulture	= pPlayer:GetCulture();
		if playerCulture ~= nil then
			--現在研究中の社会制度をチェック
			local iCultureID = playerCulture:GetProgressingCivic();
			--print("iCultureID", iCultureID)
			--研究中の社会制度が無ければ繰り返す
			if(iCultureID == -1) then
				if (Game.GetLocalPlayer() >= 0) then
					local tParameters :table = {};
					tParameters[PlayerOperations.PARAM_CIVIC_TYPE]	= 1024022293;
					tParameters[PlayerOperations.PARAM_INSERT_MODE] = PlayerOperations.VALUE_EXCLUSIVE;
					UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.PROGRESS_CIVIC, tParameters);
				end
			end
		end
	end

end


--ターン開始時にプロジェクトを再セット
function OnPlayerTurnActivated()	
	--他プレイヤーのターンはスキップ
	if(RF_TurnActiveFlag == false) then
		return;
	end

	local playerID	:number = Game.GetLocalPlayer();
	local pPlayer	:table = Players[playerID];
	if (pPlayer == nil) then
		return;
	end

	TechnologyCheck(pPlayer);
	CivicCheck(pPlayer);
	
	RF_TurnActiveFlag = false
	RF_FutureTechFlag = false
	RF_FutureCivicFlag = false
end


function Initialize()
	RF_TurnActiveFlag = false
	RF_FutureTechFlag = false
	RF_FutureCivicFlag = false

	Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin)
	Events.PlayerTurnActivated.Add(OnPlayerTurnActivated)
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd) -- ターン終了時
end


Initialize()