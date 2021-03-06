--銀河暴竜
function c511002848.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24658418,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511002848.condition)
	e1:SetTarget(c511002848.target)
	e1:SetOperation(c511002848.operation)
	c:RegisterEffect(e1)
end
function c511002848.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsCode(93717133)
end
function c511002848.xyzfilter(c,ce,a)
	local e1=Effect.CreateEffect(ce)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(511001225)
	e1:SetValue(1)
	ce:RegisterEffect(e1)
	local res=c:IsXyzSummonable(Group.FromCards(ce,a),2,2)
	e1:Reset()
	return res
end
function c511002848.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttackTarget()
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c511002848.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,c,a) end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511002848.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttackTarget()
	local c=e:GetHandler()
	if not a or not a:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511002848.xyzfilter,tp,LOCATION_EXTRA,0,nil,c,a)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=g:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(511001225)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)	
		Duel.XyzSummon(tp,xyz,Group.FromCards(c,a))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		xyz:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		xyz:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		xyz:RegisterEffect(e3)
	end
end
