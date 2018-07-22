--乌托兰的织梦人
function c10122017.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN),1,1) 
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(c10122017.con)
	e1:SetValue(10122011)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10122017.con)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10122017,0))
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCondition(c10122017.con2)
	e3:SetTarget(rsv.UtolandTokenTg)
	e3:SetOperation(rsv.UtolandTokenOp(c10122017.op))
	c:RegisterEffect(e3)	
end
function c10122017.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c10122017.con(e)
	return Duel.IsExistingMatchingCard(c10122017.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c10122017.tgfilter(c)
	return c:IsFaceup() and c:IsCode(10122011)
end
function c10122017.op(c,tc)
	rsv.SingleValEffect(c,10122017,2,EFFECT_CANNOT_BE_LINK_MATERIAL,1,nil,RESETFE)
	rsv.SingleValEffect(c,10122017,1,EFFECT_UNRELEASABLE_SUM,1,nil,RESETFE)
end