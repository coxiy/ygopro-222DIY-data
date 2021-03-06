--觉醒十天众 萨拉萨
local m=47591533
local cm=_G["c"..m]
function c47591533.initial_effect(c)
    c:SetSPSummonOnce(47591533)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c47591533.lcheck)
    c:EnableReviveLimit()
    --检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47591533,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47591533)
    e1:SetCondition(c47591533.poscon)
    e1:SetTarget(c47591533.thtg)
    e1:SetOperation(c47591533.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --攻击上升
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47591533,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetOperation(c47591533.atkop1)
    c:RegisterEffect(e3)
    --DIRECT_ATTACK
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47591533,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47591533.condition)
    e4:SetCost(c47591533.cost)
    e4:SetOperation(c47591533.operation)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetTarget(c47591533.tgtg)
    e5:SetOperation(c47591533.tgop)
    c:RegisterEffect(e5)
end
function c47591533.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c47591533.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47591533.filter(c)
    return c:IsCode(47591003) and c:IsAbleToHand()
end
function c47591533.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591533.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47591533.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591533.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47591533.atkop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(1330)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e3)
    end
end
function c47591533.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c47591533.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,3000) end
    Duel.PayLPCost(tp,3000)
end
function c47591533.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c47591533.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
    if chk==0 then return true end
end
function c47591533.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end