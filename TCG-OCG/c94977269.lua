--エルシャドール・ミドラーシュ
function c94977269.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	c:EnableReviveLimit()
	c94977269.min_material_count=2
	c94977269.max_material_count=2
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c94977269.fuscon)
	e1:SetOperation(c94977269.fusop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c94977269.splimit)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c94977269.indval)
	c:RegisterEffect(e3)
	--spsummon count limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(94977269,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c94977269.thtg)
	e5:SetOperation(c94977269.thop)
	c:RegisterEffect(e5)
end
function c94977269.ffilter1(c)
	return (c:IsFusionSetCard(0x9d) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c94977269.ffilter2(c)
	return not c:IsHasEffect(6205579) and (c:IsHasEffect(511002961) or c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsHasEffect(4904633))
end
function c94977269.exfilter(c,g,fc)
	return c:IsFaceup() and c:IsCanBeFusionMaterial(fc) and not g:IsContains(c) and (c94977269.ffilter1(c) or c94977269.ffilter2(c))
end
function c94977269.ffilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and (c94977269.ffilter1(c) or c94977269.ffilter2(c))
end
function c94977269.FCheckGoal(tp,sg,fc)
	local g=Group.CreateGroup()
	return sg:IsExists(c94977269.FCheck,1,nil,sg,g,c94977269.ffilter1,c94977269.ffilter2) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
		and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
end
function c94977269.FCheck(c,tp,mg,sg,fun1,fun2)
	if fun2 then
		sg:AddCard(c)
		mg:RemoveCard(c)
		local res=fun1(c,tp) and mg:IsExists(c94977269.FCheck,1,sg,mg,sg,fun2)
		sg:RemoveCard(c)
		mg:AddCard(c)
		return res
	else
		return fun1(c,tp)
	end
end
function c94977269.filterchk(c,tp,mg,mg2,sg,fc)
	sg:AddCard(c)
	mg:RemoveCard(c)
	if mg2:IsContains(c) then
		mg:Sub(mg2)
	end
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if sg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then
				mg:Merge(rg)
				return false
			end
			local sg2=sg:Filter(function(c) return not aux.TuneMagFilterFus(c,eff[i],f) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	if sg:GetCount()<2 then
		res=mg:IsExists(c94977269.filterchk,1,tp,mg,mg2,sg,fc)
	else
		res=c94977269.FCheckGoal(tp,sg,fc)
	end
	sg:RemoveCard(c)
	mg:AddCard(c)
	mg:Merge(rg)
	mg:Merge(mg2)
	return res
end
function c94977269.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local c=e:GetHandler()
	local mg=g:Filter(c94977269.ffilter,nil,c)
	local sg=Group.CreateGroup()
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		sg=Duel.GetMatchingGroup(c94977269.exfilter,tp,0,LOCATION_MZONE,nil,g)
		mg:Merge(sg)
	end
	if gc then
		return mg:IsContains(gc) and c94977269.filterchk(gc,tp,mg,sg,Group.CreateGroup(),c)
	end
	local sg2=Group.CreateGroup()
	return mg:IsExists(c94977269.filterchk,1,nil,tp,mg,sg,sg2,c)
end
function c94977269.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tp=e:GetHandlerPlayer()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(c100000622.ffilter,nil,c)
	local p=tp
	local sfhchk=false
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c94977269.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg=Group.CreateGroup()
	if gc then
		sg:AddCard(gc) mg:RemoveCard(gc)
		if gc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(aux.TuneMagFilterFus,gc,eff[i],f)
			end
		end
		if exg:IsContains(gc) then mg:Sub(exg) fc:RemoveCounter(tp,0x16,3,REASON_EFFECT) end
	end			
	if gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=mg:FilterSelect(p,c94977269.filterchk,1,1,gc,tp,mg,exg,sg,c)
		if exg:IsContains(g1:GetFirst()) then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		end
	else
		while sg:GetCount()<2 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			local tc=Group.SelectUnselect(mg:Filter(c94977269.filterchk,sg,tp,mg,exg,sg,c),sg,p)
			if not tc then break end
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			else
				sg:RemoveCard(tc)
			end
			if tc:IsHasEffect(73941492+TYPE_FUSION) then
				local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
				for i=1,#eff do
					local f=eff[i]:GetValue()
					mg=mg:Filter(aux.TuneMagFilterFus,tc,eff[i],f)
				end
			end
			if exg:IsContains(tc) then mg:Sub(exg) fc:RemoveCounter(tp,0x16,3,REASON_EFFECT) end
		end
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(g1)
end
function c94977269.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c94977269.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c94977269.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c94977269.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c94977269.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c94977269.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c94977269.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c94977269.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
