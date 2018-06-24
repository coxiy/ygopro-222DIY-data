--武装神姬 天使之安瓦尔
local m=14801101
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,2)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.eqtg)
    e1:SetOperation(cm.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(cm.econ)
    e3:SetValue(cm.efilters)
    c:RegisterEffect(e3)
    --Atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(2500)
    c:RegisterEffect(e4)
    --draw(battle)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,3))
    e5:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCondition(cm.hacon)
    e5:SetTarget(cm.target)
    e5:SetOperation(cm.operation)
    local e7=Effect.CreateEffect(c)  
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
    e7:SetRange(LOCATION_SZONE)  
    e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
    e7:SetTarget(cm.eftg1)  
    e7:SetLabelObject(e5)  
    c:RegisterEffect(e7)
    --immune
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetCondition(cm.immcon)
    e6:SetValue(cm.efilter)
    c:RegisterEffect(e6)
    --damage
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(m,2))
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_EQUIP)
    e8:SetCountLimit(1,m)
    e8:SetTarget(cm.sptg3)
    e8:SetOperation(cm.spop3)
    c:RegisterEffect(e8)
    --eqlimit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_EQUIP_LIMIT)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e9:SetValue(cm.eqlimit)
    c:RegisterEffect(e9)
    --Def up
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_EQUIP)
    e11:SetCode(EFFECT_UPDATE_DEFENSE)
    e11:SetValue(2500)
    c:RegisterEffect(e11)
end
function cm.matfilter(c)
    return c:IsSetCard(0x4811) and c:IsLinkType(TYPE_LINK)
end
function cm.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsSetCard(0x4811) and ct2==0
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not cm.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cm.econ(e)
    return e:GetHandler():GetEquipTarget()
end
function cm.efilters(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

function cm.hacon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
    if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT) end
    Duel.BreakEffect()
    Duel.Draw(tp,2,REASON_EFFECT)
    Duel.Draw(1-tp,2,REASON_EFFECT)
end
function cm.immcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function cm.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

function cm.filter4(c,e,tp)
    return c:IsSetCard(0x4811) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter4),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.eftg1(e,c)  
    return e:GetHandler():GetEquipTarget()==c  
end
function cm.eqlimit(e,c)
    return (c:IsSetCard(0x4811) and c:IsType(TYPE_MONSTER)) or e:GetHandler():GetEquipTarget()==c
end