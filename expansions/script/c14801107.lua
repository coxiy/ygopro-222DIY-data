--武装神姬 高机动之依妲
local m=14801107
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_UNION),2)
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
    e4:SetValue(1800)
    c:RegisterEffect(e4)
    --recover
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetCategory(CATEGORY_RECOVER)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetCondition(cm.reccon)
    e5:SetTarget(cm.rectg)
    e5:SetOperation(cm.recop)
    local e7=Effect.CreateEffect(c)  
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
    e7:SetRange(LOCATION_SZONE)  
    e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
    e7:SetTarget(cm.eftg1)  
    e7:SetLabelObject(e5)  
    c:RegisterEffect(e7)
    --equip
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,3))
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCategory(CATEGORY_EQUIP)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetCondition(cm.eqcon2)
    e6:SetTarget(cm.eqtg2)
    e6:SetOperation(cm.eqop2)
    c:RegisterEffect(e6)
    --damage
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(m,4))
    e8:SetCategory(CATEGORY_DESTROY)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_EQUIP)
    e8:SetCountLimit(1,m)
    e8:SetTarget(cm.destg)
    e8:SetOperation(cm.desop)
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
    e11:SetValue(1800)
    c:RegisterEffect(e11)
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
function cm.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function cm.eqcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.filter2(c)
    return c:IsSetCard(0x4811) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.eqop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e6=Effect.CreateEffect(c)
        e6:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e6:SetType(EFFECT_TYPE_SINGLE)
        e6:SetCode(EFFECT_EQUIP_LIMIT)
        e6:SetReset(RESET_EVENT+0x1fe0000)
        e6:SetValue(cm.eqlimit1)
        tc:RegisterEffect(e6)
    end
end
function cm.eqlimit1(e,c)
    return e:GetOwner()==c
end
function cm.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and cm.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function cm.econ(e)
    return e:GetHandler():GetEquipTarget()
end
function cm.efilters(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.eftg1(e,c)  
    return e:GetHandler():GetEquipTarget()==c  
end
function cm.eqlimit(e,c)
    return (c:IsSetCard(0x4811) and c:IsType(TYPE_MONSTER)) or e:GetHandler():GetEquipTarget()==c
end

function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local rec=bc:GetBaseAttack()
    if rec<0 then rec=0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end