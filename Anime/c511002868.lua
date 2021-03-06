--Raidraptor - Rapid Xyz
function c511002868.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c511002868.xyzcon)
	e1:SetTarget(c511002868.xyztg)
	e1:SetOperation(c511002868.xyzop)
	c:RegisterEffect(e1)
end
function c511002868.cfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c511002868.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE  
		and Duel.IsExistingMatchingCard(c511002868.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c511002868.xyzfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0xba)
end
function c511002868.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002868.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511002868.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511002868.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.XyzSummon(tp,tc,nil)
		if not tc:IsHasEffect(511002571) then return end
		local eff={tc:GetCardEffect(511002571)}
		local te=nil
		local acd={}
		local ac={}
		for i=1,#eff do
			local temp=eff[i]:GetLabelObject()
			local tg=temp:GetTarget()
			if not tg or tg(temp,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[i],REASON_EFFECT,PLAYER_NONE,0) then
				table.insert(ac,temp)
				table.insert(acd,temp:GetDescription())
			end
		end
		if #ac<=0 or not Duel.SelectYesNo(tp,aux.Stringid(48680970,0)) then return end
		Duel.BreakEffect()
		if #ac==1 then te=ac[1] elseif #ac>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			op=Duel.SelectOption(tp,table.unpack(acd))
			op=op+1
			te=ac[op]
		end
		if not te then return end
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if tg then tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[1],REASON_EFFECT,PLAYER_NONE,1) end
		Duel.BreakEffect()
		tc:CreateEffectRelation(te)
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,Group.CreateGroup(),PLAYER_NONE,0,eff[1],REASON_EFFECT,PLAYER_NONE,1) end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
