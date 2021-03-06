--Astrograph Sorcerer (Anime)
--アストログラフ・マジシャン
--fixed by MLD
function c511010507.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511012002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c511010507.sptg)
	e1:SetOperation(c511010507.spop)
	c:RegisterEffect(e1)
	--special summon Zarc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511012002,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c511010507.zarccost)
	e2:SetTarget(c511010507.zarctg)
	e2:SetOperation(c511010507.zarcop)
	c:RegisterEffect(e2)
end
function c511010507.spcfilter(c,e,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCanBeEffectTarget(e) 
		and (c:IsLocation(LOCATION_SZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end
function c511010507.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c511010507.spcfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,1,tp,false,false) end
	local g=eg:Filter(c511010507.spcfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c511010507.spcfilterchk(c,e,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsRelateToEffect(e) 
		and (c:IsLocation(LOCATION_SZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and not Duel.GetFieldCard(tp,c:GetPreviousLocation(),c:GetPreviousSequence())
end
function c511010507.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c511010507.spcfilterchk,nil,e,tp)
	if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0 and Duel.SelectEffectYesNo(tp,c) then
		g:KeepAlive()
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_CUSTOM+511012002)
		e1:SetLabelObject(g)
		e1:SetTarget(c511010507.rettg)
		e1:SetOperation(c511010507.retop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+511012002,e,r,tp,tp,0)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c511010507.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	g:DeleteGroup()
	Duel.SetTargetCard(g)
end
function c511010507.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c511010507.spcfilterchk,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_PZONE) then
			local seq=0
			if tc:GetPreviousSequence()==7 or tc:GetPreviousSequence()==4 then seq=1 end
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,tc:GetPreviousPosition(),true,bit.lshift(1,seq))
		else
			Duel.MoveToField(tc,tp,tp,tc:GetPreviousLocation(),tc:GetPreviousPosition(),true,bit.lshift(1,tc:GetPreviousSequence()))
		end
		tc=g:GetNext()
	end
end
function c511010507.zarccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c511010507.zarcspfilter(c,e,tp)
	return c:IsCode(13331639) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511010507.zarcremfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end
function c511010507.zarctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511010507.zarcremfilter,tp,0x5d,0,1,nil,41209827) 
		and Duel.IsExistingMatchingCard(c511010507.zarcremfilter,tp,0x5d,0,1,nil,82044279) 
		and Duel.IsExistingMatchingCard(c511010507.zarcremfilter,tp,0x5d,0,1,nil,16195942) 
		and Duel.IsExistingMatchingCard(c511010507.zarcremfilter,tp,0x5d,0,1,nil,16178681) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c511010507.zarcspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511010507.zarcop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c511010507.zarcremfilter,tp,0x5d,0,nil,41209827)
	local g2=Duel.GetMatchingGroup(c511010507.zarcremfilter,tp,0x5d,0,nil,82044279)
	local g3=Duel.GetMatchingGroup(c511010507.zarcremfilter,tp,0x5d,0,nil,16195942)
	local g4=Duel.GetMatchingGroup(c511010507.zarcremfilter,tp,0x5d,0,nil,16178681)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg4=g4:Select(tp,1,1,nil)
		sg1:Merge(sg4)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)>3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,c511010507.zarcspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
				tc:CompleteProcedure()
			end
		end
	end
end
