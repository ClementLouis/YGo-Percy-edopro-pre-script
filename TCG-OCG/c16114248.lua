--ペア・サイクロイド
function c16114248.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c16114248.fscon)
	e1:SetOperation(c16114248.fsop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
function c16114248.mfilter(c,fc)
	return (c:IsRace(RACE_MACHINE) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c16114248.filterchk(c,tp,mg,sg,fc,code)
	local rg=Group.CreateGroup()
	if not c:IsHasEffect(511002961) then
		if code and not c:IsFusionCode(code) then return false end
		code=c:GetFusionCode()
		rg=mg:Filter(function(rc) return not rc:IsFusionCode(c:GetFusionCode()) and not rc:IsHasEffect(511002961) end,nil)
		mg:Sub(rg)
	end
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
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then
					mg:Merge(rg)
					return false
				end
			end
			tc=g2:GetNext()
		end	
	end
	sg:AddCard(c)
	local res
	if sg:GetCount()<2 then
		res=mg:IsExists(c16114248.filterchk,1,sg,tp,mg,sg,fc,code)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0 and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	code=nil
	return res
end
function c16114248.fscon(e,g,gc)
	if g==nil then return true end
	local c=e:GetHandler()
	local mg=g:Filter(c16114248.mfilter,nil,c)
	if gc then return mg:IsContains(gc) and c16114248.filterchk(gc,tp,mg,Group.CreateGroup(),c) end
	local sg=Group.CreateGroup()
	return mg:IsExists(c16114248.filterchk,1,nil,tp,mg,sg,c)
end
function c16114248.fsop(e,tp,eg,ep,ev,re,r,rp,gc)
	local mg=eg:Filter(c16114248.mfilter,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	local code
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
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
		if not gc:IsHasEffect(511002961) then
			mg=mg:Filter(function(c) return c:IsFusionCode(gc:GetFusionCode()) or c:IsHasEffect(511002961) end,nil)
			code=gc:GetFusionCode()
		end
	end
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local tc=Group.SelectUnselect(mg:Filter(c16114248.filterchk,sg,tp,mg,sg,e:GetHandler(),code),sg,p)
		if not gc or tc~=gc then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if not tc:IsHasEffect(511002961) then
					code=tc:GetFusionCode()
				end
			else
				sg:RemoveCard(tc)
				code=nil
			end
		end
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	if gc then sg:RemoveCard(gc) end
	Duel.SetFusionMaterial(sg)
end
