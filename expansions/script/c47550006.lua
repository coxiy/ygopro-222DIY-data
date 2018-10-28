--五色的祈愿 尤伊西丝
local m=47550006
local cm=_G["c"..m]
function c47550006.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum change
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c47550006.pencon)
    e1:SetTarget(c47550006.pentg)
    e1:SetOperation(c47550006.penop)
    c:RegisterEffect(e1)  
    --Double damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47550006,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(c47550006.descost)
    e2:SetOperation(c47550006.desop)
    c:RegisterEffect(e2)  
    --summon with 1 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47550006,1))
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SUMMON_PROC)
    e3:SetCondition(c47550006.otcon)
    e3:SetOperation(c47550006.otop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47550006,0))
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SUMMON_PROC)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c47550006.ntcon)
    c:RegisterEffect(e4) 
    --summon success
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetOperation(c47550006.sumsuc)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCondition(c47550006.sumcon)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)
    --Special Summon
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47550006,1))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetCondition(c47550006.spcon)
    e7:SetTarget(c47550006.sptg)
    e7:SetOperation(c47550006.spop)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e8:SetCondition(c47550006.damcon)
    e8:SetOperation(c47550006.damop)
    c:RegisterEffect(e8)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_SET_ATTACK_FINAL)
    e9:SetCondition(c47550006.akcon)
    e9:SetValue(5000)
    c:RegisterEffect(e9)   
end
function c47550006.cfilter(c)
    return (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)) and c;GetLeftScale()<10 and c:GetRightScale()<10
end
function c47550006.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47550006.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47550006.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return e:GetHandler():IsDestructable() end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
end
function c47550006.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if not e:GetHandler():IsRelateToEffect(e) then return end
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CHANGE_LSCALE)
        e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e4:SetRange(LOCATION_PZONE)
        e4:SetValue(10)
        sc:RegisterEffect(e4)
        local e5=e4:Clone()
        e5:SetCode(EFFECT_CHANGE_RSCALE)
        sc:RegisterEffect(e5)
    end    
end
function c47550006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c47550006.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if Duel.Destroy(g,REASON_EFFECT) then
        Duel.Destroy(c,REASON_EFFECT)
    end
end
function c47550006.otfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47550006.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47550006.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47550006.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47550006.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47550006.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47550006.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c47550006.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(47550006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c47550006.akcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47550006)>0 and e:GetHandler():GetFlagEffect(47551006)<1
end
function c47550006.spcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c47550006.spfilter(c,e,tp)
    return (c:IsLevel(4) or c:IsLevel(7)) and (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_WARRIOR)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c47550006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c47550006.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47550006.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47550006.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47550006.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47550006.damcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and e:GetHandler():GetFlagEffect(47550006)>0 and e:GetHandler():GetFlagEffect(47551006)<1
end
function c47550006.damop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if Duel.ChangeBattleDamage(ep,ev*2) then
   c:RegisterFlagEffect(47551006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end