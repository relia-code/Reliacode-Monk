local _G, math, error, type, pairs = _G, math, error, type, pairs
local math_ceil = math.ceil
local math_max = math.max
local math_min = math.min

local TMW = _G.TMW

local A = _G.Action
local CONST = A.Const
local Print = A.Print
local toStr = A.toStr
local HealingEngine = A.HealingEngine
local Unit = A.Unit
local GetCurrentGCD = A.GetCurrentGCD
local GetSpellDescription = A.GetSpellDescription
local GetToggle = A.GetToggle
local GetLatency = A.GetLatency

local HealingEngineIsManaSave = HealingEngine.IsManaSave

local MW = A[CONST.MONK_MISTWEAVER]

local UnitIsUnit = _G.UnitIsUnit

local function UnitIsSoothingMisting(unitID)
    return A.IamHealer and Unit("player"):IsCastingRemains(MW.SoothingMist.ID) > 0 and
        Unit(unitID):HasBuffs(MW.SoothingMist.ID, true, true) > 0
end

local function GetHealingModifier(unitID, castTime, skipEnvelopingMist)
    local extraHealModifier, envelopingMistDuration, domeofMistBuffDuration = 1, 0, 0
    if A.IamHealer then
        envelopingMistDuration = Unit(unitID):HasBuffs(MW.EnvelopingMist.ID, true)
        if not skipEnvelopingMist and envelopingMistDuration > castTime + GetLatency() then
            extraHealModifier = extraHealModifier * (1 + (MW.EnvelopingMist:GetSpellDescription()[2] / 100))
        end

        if UnitIsUnit(unitID, "player") then
            domeofMistBuffDuration = Unit(unitID):HasBuffs(MW.DomeofMistBuff.ID, true)
            if domeofMistBuffDuration > castTime + GetLatency() then
                extraHealModifier = extraHealModifier * 1.3
            end
        end
    end

    return extraHealModifier, envelopingMistDuration, domeofMistBuffDuration
end

function A:PredictHeal(unitID, variation, isClear)
    -- @usage obj:PredictHeal(unitID[, variation[, isClear]])
    -- @return boolean, number
    -- Returns:
    -- [1] true if action can be used
    -- [2] total amount of predicted missed health

    -- Any healing spell can be applied
    if Unit(unitID):IsPenalty() then
        return true, 0
    end

    local PO = GetToggle(8, "PredictOptions")
    -- PO[1] incHeal
    -- PO[2] incDMG
    -- PO[3] threat -- not usable in prediction
    -- PO[4] HoTs
    -- PO[5] absorbPossitive
    -- PO[6] absorbNegative
    local defaultVariation, isManaSave
    local variation = variation or 1
    if not isClear and A.IamHealer and HealingEngineIsManaSave(unitID) then
        isManaSave = true
        defaultVariation = variation
        variation = math_max(variation - 1 + GetToggle(8, "ManaManagementPredictVariation"), 1)
    end

    -- Shared
    if self.predictName == "Vivify" then
        local desc = self:GetSpellDescription()
        local castTime = self:GetSpellCastTime()

        -- Add current GCD to pre-pare
        if castTime > 0 then
            castTime = castTime + GetCurrentGCD()
        end

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > castTime then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] and castTime > 0 then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] and castTime > 0 then
            incDMG = Unit(unitID):GetDMG() * castTime
        end

        if PO[4] and castTime > 0 then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * castTime
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier = GetHealingModifier(unitID, castTime)

        local withoutOptions = desc[1] * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "ChiBurst" then
        local desc = self:GetSpellDescription()
        local castTime = self:GetSpellCastTime()

        -- Add current GCD to pre-pare
        if castTime > 0 then
            castTime = castTime + GetCurrentGCD()
        end

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > castTime then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] and castTime > 0 then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] and castTime > 0 then
            incDMG = Unit(unitID):GetDMG() * castTime
        end

        if PO[4] and castTime > 0 then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * castTime
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier = GetHealingModifier(unitID, castTime)

        local withoutOptions = desc[1] * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "ChiWave" then
        local desc = self:GetSpellDescription()

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local absorbPossitive, absorbNegative = 0, 0
        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier = GetHealingModifier(unitID, 0)

        local withoutOptions = desc[1] * extraHealModifier * variation
        local total = withoutOptions + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    -- BrewMaster
    if self.predictName == "ExpelHarm" then
        local desc = GetSpellDescription(124502)

        local absorbPossitive, absorbNegative = 0, 0
        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local withoutOptions = desc[1] * variation
        local total = withoutOptions + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    -- Mistweaver
    if self.predictName == "Revival" then
        local desc = self:GetSpellDescription()

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local absorbPossitive, absorbNegative = 0, 0
        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier = GetHealingModifier(unitID, 0)

        local withoutOptions = desc[1] * extraHealModifier * variation
        local total = withoutOptions + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "InvokeChiJitheRedCrane" then
        local desc = self:GetSpellDescription()

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local absorbPossitive, absorbNegative = 0, 0
        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local withoutOptions = desc[1] * variation -- This spell doesn't scales on healing modifiers!
        local total = withoutOptions + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "EssenceFont" then
        local desc = self:GetSpellDescription()
        local castTime = desc[6]

        local shards = math_ceil(castTime / desc[7])
        local shardHeal = desc[1]
        local shardsHeal = shardHeal * shards

        local durationHoT = desc[4]
        local healHoT = desc[2]
        local perTickHoT = healHoT / durationHoT

        -- Add current GCD to pre-pare
        if castTime > 0 then
            castTime = castTime + GetCurrentGCD()
        end

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then -- GetCurrentGCD() + GetLatency() here because it's channeling
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] and castTime > 0 then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] and castTime > 0 then
            incDMG = Unit(unitID):GetDMG() * castTime
        end

        if PO[4] and castTime > 0 then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * castTime
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier, envelopingMistDuration, domeofMistBuffDuration = GetHealingModifier(unitID, castTime)

        -- Modifiers of HoT
        -- Note: Would be good to know how game scales few multipliers on different expire, probably it taking source clear input and then summup
        local lifeCocoon = Unit(unitID):HasBuffs(MW.LifeCocoon.ID, true)
        if lifeCocoon > 0 then
            local mod = 1.5
            lifeCocoon = math_min(lifeCocoon, durationHoT) -- cut off longer extra duration
            healHoT = healHoT + math_max((perTickHoT * mod * lifeCocoon) - perTickHoT, perTickHoT * mod * lifeCocoon) -- summup
        --perTickHoT            = healHoT / durationHoT -- refresh
        end

        if envelopingMistDuration > 0 then
            local mod = 1 + (MW.EnvelopingMist:GetSpellDescription()[2] / 100)
            envelopingMistDuration = math_min(envelopingMistDuration, durationHoT) -- cut off longer extra duration
            healHoT =
                healHoT +
                math_max(
                    ((perTickHoT * mod * envelopingMistDuration) - perTickHoT),
                    perTickHoT * mod * envelopingMistDuration
                ) -- summup
        --perTickHoT            = healHoT / durationHoT -- refresh
        end

        if domeofMistBuffDuration > 0 then -- self is checked by GetHealingModifier
            local mod = 1.3
            domeofMistBuffDuration = math_min(domeofMistBuffDuration, durationHoT) -- cut off longer extra duration
            healHoT =
                healHoT +
                math_max(
                    ((perTickHoT * mod * domeofMistBuffDuration) - perTickHoT),
                    perTickHoT * mod * domeofMistBuffDuration
                ) -- summup
        --perTickHoT            = healHoT / durationHoT -- refresh
        end

        local withoutOptions = ((shardsHeal * extraHealModifier) + healHoT) * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
        -- We will count shorter castTime isntead of full duration since incDMG or HoTs can be so large

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "EnvelopingMist" then
        if not isClear and A.IamHealer then
            local limitHP = GetToggle(2, "EnvelopingMistHP")
            if limitHP < 100 and Unit(unitID):HealthPercent() > limitHP then
                return false, 0
            end
        end

        local desc = self:GetSpellDescription()
        local castTime = UnitIsSoothingMisting(unitID) and 0 or self:GetSpellCastTime()
        local fullHeal = desc[1]
        local duration = desc[3]

        -- Add current GCD to pre-pare
        if castTime > 0 then
            castTime = castTime + GetCurrentGCD()
        end

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > castTime then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] and castTime > 0 then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] then
            incDMG = Unit(unitID):GetDMG() * ((castTime + duration) / 2)
        end

        if PO[4] then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * ((castTime + duration) / 2)
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealInstant = MW.Mastery:GetSpellDescription()[1]
        if Unit("player"):HasBuffs(MW.ThunderFocusTea.ID, true) > 0 then
            extraHealInstant = extraHealInstant + MW.ThunderFocusTea:GetSpellDescription()[1]
        end

        local extraHealModifier = GetHealingModifier(unitID, castTime, true)

        -- Modifier of HoT
        local lifeCocoon = Unit(unitID):HasBuffs(MW.LifeCocoon.ID, true)
        if lifeCocoon > 0 then
            local mod = 1.5
            lifeCocoon = math_min(lifeCocoon, duration) -- cut off longer extra duration
            fullHeal = fullHeal + math_max((fullHeal * mod * lifeCocoon) - fullHeal, fullHeal * mod * lifeCocoon) -- summup
        end

        local withoutOptions = (fullHeal + extraHealInstant) * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
        -- We will count average castTime + duration

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "SurgingMist" then
        if not isClear and A.IamHealer then
            local limitHP = GetToggle(2, "SurgingMistHP")
            if limitHP < 100 and Unit(unitID):HealthPercent() > limitHP then
                return false, 0
            end
        end

        local desc = self:GetSpellDescription()
        local castTime = UnitIsSoothingMisting(unitID) and 0 or self:GetSpellCastTime()

        -- Add current GCD to pre-pare
        if castTime > 0 then
            castTime = castTime + GetCurrentGCD()
        end

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > castTime then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] and castTime > 0 then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] and castTime > 0 then
            incDMG = Unit(unitID):GetDMG() * castTime
        end

        if PO[4] and castTime > 0 then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * castTime
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier = GetHealingModifier(unitID, castTime)
        local stacks = Unit(unitID):HasBuffsStacks(self.ID, true)
        if stacks > 0 then
            extraHealModifier = extraHealModifier * (1 + (stacks * 0.5))
        end

        local withoutOptions = desc[1] * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "RefreshingJadeWind" then
        local desc = self:GetSpellDescription()
        local duration = desc[3]

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] then
            incDMG = Unit(unitID):GetDMG() * duration
        end

        if PO[4] then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * duration
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealModifier = GetHealingModifier(unitID, 0)

        local withoutOptions = desc[1] * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "RenewingMist" then
        local desc = self:GetSpellDescription()
        local fullHeal = desc[1]
        local duration =
            desc[3] -
            (Unit("player"):HasBuffs(MW.ThunderFocusTea.ID, true) > GetCurrentGCD() + GetLatency() and 10 or 0) -- avoid issues

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] then
            incDMG = Unit(unitID):GetDMG() * (duration / 2)
        end

        if PO[4] then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * (duration / 2)
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local extraHealInstant = MW.Mastery:GetSpellDescription()[1]

        local extraHealModifier = GetHealingModifier(unitID, 0)
        -- Modifier of HoT
        local lifeCocoon = Unit(unitID):HasBuffs(MW.LifeCocoon.ID, true)
        if lifeCocoon > 0 then
            local mod = 1.5
            lifeCocoon = math_min(lifeCocoon, duration) -- cut off longer extra duration
            fullHeal = fullHeal + math_max((fullHeal * mod * lifeCocoon) - fullHeal, fullHeal * mod * lifeCocoon) -- summup
        end

        local withoutOptions = (fullHeal + extraHealInstant) * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
        -- We will count average duration

        return Unit(unitID):HealthDeficit() >= total, total
    end

    if self.predictName == "SoothingMist" then
        -- No toggle check here!
        local desc = self:GetSpellDescription()
        local fullHeal = desc[1]
        local duration = desc[2]
        local castTime = duration

        -- Add current GCD to pre-pare
        if castTime > 0 then
            castTime = castTime + GetCurrentGCD()
        end

        -- Re-calculate variation depends on mana savers
        if isManaSave then
            if Unit("player"):HasBuffs(MW.ManaTea.ID, true) > GetCurrentGCD() + GetLatency() then -- GetCurrentGCD() + GetLatency() here because it's channeling
                -- Make variation half if we have buff up ManaTea
                variation = math_max(variation / 2, 1)
            end
        end

        local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
        if PO[1] then
            incHeal = Unit(unitID):GetIncomingHeals()
        end

        if PO[2] then
            incDMG = Unit(unitID):GetDMG() * (duration / 3) -- We will count 33% duration
        end

        if PO[4] then -- 4 here!
            HoTs = Unit(unitID):GetHEAL() * (duration / 3) -- We will count 33% duration
        end

        if PO[5] then
            absorbPossitive = Unit(unitID):GetAbsorb()
            -- Better don't touch it, not tested anyway
            if absorbPossitive >= Unit(unitID):HealthDeficit() then
                absorbPossitive = 0
            end
        end

        if PO[6] then
            absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
        end

        local _, envelopingMistDuration, domeofMistBuffDuration = GetHealingModifier(unitID, 0)
        -- Modifier of HoT
        local lifeCocoon = Unit(unitID):HasBuffs(MW.LifeCocoon.ID, true)
        if lifeCocoon > 0 then
            local mod = 1.5
            lifeCocoon = math_min(lifeCocoon, duration) -- cut off longer extra duration
            fullHeal = fullHeal + math_max((fullHeal * mod * lifeCocoon) - fullHeal, fullHeal * mod * lifeCocoon) -- summup
        end

        if envelopingMistDuration > 0 then
            local mod = 1 + (MW.EnvelopingMist:GetSpellDescription()[2] / 100)
            envelopingMistDuration = math_min(envelopingMistDuration, duration) -- cut off longer extra duration
            fullHeal =
                fullHeal +
                math_max((fullHeal * mod * envelopingMistDuration) - fullHeal, fullHeal * mod * envelopingMistDuration) -- summup
        end

        if domeofMistBuffDuration > 0 then -- self is checked by GetHealingModifier
            local mod = 1.3
            domeofMistBuffDuration = math_min(domeofMistBuffDuration, duration) -- cut off longer extra duration
            fullHeal =
                fullHeal +
                math_max((fullHeal * mod * domeofMistBuffDuration) - fullHeal, fullHeal * mod * domeofMistBuffDuration) -- summup
        end

        local withoutOptions = fullHeal * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative

        return Unit(unitID):HealthDeficit() >= total, total
    end

    -- Debug
    if not self.predictName then
        error((self:GetKeyName() or "Unknown action name") .. " doesn't contain predictName")
    end

    return false, 0

    --[[ Old
    if NAME == "EssenceFont" then
        local pre_heal = Unit(UNIT):GetIncomingHeals()  or 0
        local description = self:GetSpellDescription()
        local cast_time = description[6] or 0
        local duration = description[4] or 0
        local tick = description[1] or 0
        local hot_tick = description[2] / duration
        local counter_ticks = math_ceil(cast_time / 0.9)
        local summary_hot_ticks = hot_tick * 0.9 * counter_ticks
        local cached_summary_hot_ticks = summary_hot_ticks
        if LifeCocoon_duration > 0 then
            if LifeCocoon_duration >= cast_time then
                LifeCocoon_duration = cast_time
            end
            summary_hot_ticks = (cached_summary_hot_ticks / cast_time * (cast_time - LifeCocoon_duration)) + (cached_summary_hot_ticks / cast_time * LifeCocoon_variation * LifeCocoon_duration)
        end
        if EnvelopingMist_duration > 0 then
            if EnvelopingMist_duration >= cast_time then
                EnvelopingMist_duration = cast_time
            end
            summary_hot_ticks = summary_hot_ticks + ((cached_summary_hot_ticks / cast_time * (cast_time - EnvelopingMist_duration)) + (cached_summary_hot_ticks / cast_time * EnvelopingMist_variation * EnvelopingMist_duration) - summary_hot_ticks)
        end
        -- While casting
        local summary = (tick * EnvelopingMist_variation * counter_ticks) + summary_hot_ticks
        -- After casting
        local remain_duration = duration - cast_time
        local summary_remain_hot = hot_tick * remain_duration
        if LifeCocoon_duration - cast_time > 0 then
            LifeCocoon_duration = LifeCocoon_duration - cast_time
            if LifeCocoon_duration >= remain_duration then
                LifeCocoon_duration = remain_duration
            end
            summary_remain_hot = (hot_tick * (remain_duration - LifeCocoon_duration)) + (hot_tick * LifeCocoon_variation * LifeCocoon_duration)
        end
        if EnvelopingMist_duration - cast_time > 0 then
            EnvelopingMist_duration = EnvelopingMist_duration - cast_time
            if EnvelopingMist_duration >= remain_duration then
                EnvelopingMist_duration = remain_duration
            end
            summary_remain_hot = summary_remain_hot + ((hot_tick * (remain_duration - EnvelopingMist_duration)) + (hot_tick * EnvelopingMist_variation * EnvelopingMist_duration) - summary_remain_hot)
        end

        local cast = cast_time + A.GetCurrentGCD()
        total = (summary + summary_remain_hot) * variation + pre_heal + (HPS * cast) - (DMG * cast)
    end]]
end

function A.DebugPredictHeal(unitID)
    if unitID and A[A.PlayerSpec] then
        local bool, total
        for _, action in pairs(A[A.PlayerSpec]) do
            if type(action) == "table" and action.predictName then
                bool, total = action:PredictHeal(unitID)
                Print(
                    action.predictName .. ": " .. toStr[bool] .. ", " .. Unit(unitID):HealthDeficit() .. " >= " .. total
                )
            end
        end
    end
end
