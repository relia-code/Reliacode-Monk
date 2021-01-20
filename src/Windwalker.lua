--- Modified version of Aya's Monk
--- https://github.com/AyaProfiles/Aya-Monk

local _G, setmetatable = _G, setmetatable
local ACTION = _G.Action
local Covenant = _G.LibStub("Covenant")
local TMW = _G.TMW
local Action = _G.Action
local CONST = Action.Const
local Listener = Action.Listener
local Create = Action.Create
local GetToggle = Action.GetToggle
local SetToggle = Action.SetToggle
local GetLatency = Action.GetLatency
local GetGCD = Action.GetGCD
local GetCurrentGCD = Action.GetCurrentGCD
local ShouldStop = Action.ShouldStop
local BurstIsON = Action.BurstIsON
local AuraIsValid = Action.AuraIsValid
local InterruptIsValid = Action.InterruptIsValid
local FrameHasSpell = Action.FrameHasSpell
local DetermineUsableObject = Action.DetermineUsableObject

local Utils = Action.Utils
local BossMods = Action.BossMods
local TeamCache = Action.TeamCache
local EnemyTeam = Action.EnemyTeam
local FriendlyTeam = Action.FriendlyTeam
local LoC = Action.LossOfControl
local Player = Action.Player
local MultiUnits = Action.MultiUnits
local UnitCooldown = Action.UnitCooldown
local Unit = Action.Unit
local IsUnitEnemy = Action.IsUnitEnemy
local IsUnitFriendly = Action.IsUnitFriendly
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, UnitIsPlayer = IsIndoors, UnitIsUnit, UnitIsPlayer
local pairs = pairs
local GrappleWeaponIsReady = Action.GrappleWeaponIsReady
local AuraIsValidByPhialofSerenity = Action.AuraIsValidByPhialofSerenity

local Azerite = LibStub("AzeriteTraits")

local ACTION_CONST_MONK_WINDWALKER = CONST.MONK_WINDWALKER
local ACTION_CONST_AUTOTARGET = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP = CONST.SPELLID_FREEZING_TRAP

--For Toaster
local Toaster = _G.Toaster
local GetSpellTexture = _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_MONK_WINDWALKER] = {
    -- Racial
    ArcaneTorrent = Action.Create({Type = "Spell", ID = 50613}),
    BloodFury = Action.Create({Type = "Spell", ID = 20572}),
    Fireblood = Action.Create({Type = "Spell", ID = 265221}),
    AncestralCall = Action.Create({Type = "Spell", ID = 274738}),
    Berserking = Action.Create({Type = "Spell", ID = 26297}),
    ArcanePulse = Action.Create({Type = "Spell", ID = 260364}),
    QuakingPalm = Action.Create({Type = "Spell", ID = 107079}),
    Haymaker = Action.Create({Type = "Spell", ID = 287712}),
    WarStomp = Action.Create({Type = "Spell", ID = 20549}),
    BullRush = Action.Create({Type = "Spell", ID = 255654}),
    GiftofNaaru = Action.Create({Type = "Spell", ID = 59544}),
    Shadowmeld = Action.Create({Type = "Spell", ID = 58984}),
    Stoneform = Action.Create({Type = "Spell", ID = 20594}),
    BagofTricks = Action.Create({Type = "Spell", ID = 312411}),
    WilloftheForsaken = Action.Create({Type = "Spell", ID = 7744}),
    EscapeArtist = Action.Create({Type = "Spell", ID = 20589}),
    EveryManforHimself = Action.Create({Type = "Spell", ID = 59752}),
    LightsJudgment = Action.Create({Type = "Spell", ID = 255647}),
    RocketJump = Action.Create({Type = "Spell", ID = 69070}),
    DarkFlight = Action.Create({Type = "Spell", ID = 68992}),
    -- Monk General
    BlackoutKick = Action.Create({Type = "Spell", ID = 100784}),
    CracklingJadeLightning = Action.Create({Type = "Spell", ID = 117952}),
    Detox = Action.Create({Type = "Spell", ID = 218164}),
    ExpelHarm = Action.Create({Type = "Spell", ID = 322101}),
    FortifyingBrew = Action.Create({Type = "Spell", ID = 243435}),
    LegSweep = Action.Create({Type = "Spell", ID = 119381}),
    MarkoftheCrane = Action.Create({Type = "Spell", ID = 228287}),
    MysticTouch = Action.Create({Type = "Spell", ID = 8647, Hidden = true}),
    Paralysis = Action.Create({Type = "Spell", ID = 344359}),
    Provoke = Action.Create({Type = "Spell", ID = 115546}),
    Resuscitate = Action.Create({Type = "Spell", ID = 115178}),
    Roll = Action.Create({Type = "Spell", ID = 109132}),
    SpinningCraneKick = Action.Create({Type = "Spell", ID = 101546}),
    TigerPalm = Action.Create({Type = "Spell", ID = 100780}),
    RushingTigerPalm = Action.Create({Type = "Spell", ID = 337341}),
    TouchofDeath = Action.Create({Type = "Spell", ID = 325215}),
    Transcendence = Action.Create({Type = "Spell", ID = 101649}),
    TranscendenceTransfer = Action.Create({Type = "Spell", ID = 119996}),
    Vivify = Action.Create({Type = "Spell", ID = 116670}),
    ZenFlight = Action.Create({Type = "Spell", ID = 125883}),
    ZenPilgrimage = Action.Create({Type = "Spell", ID = 126892}),
    -- WindWalker Specific
    Disable = Action.Create({Type = "Spell", ID = 116095}),
    FistsofFury = Action.Create({Type = "Spell", ID = 113656}),
    FlyingSerpentKick = Action.Create({Type = "Spell", ID = 344487}),
    FlyingSerpentKickJump = Action.Create({Type = "Spell", ID = 115057}), -- Action ID of FlyingSerpentKick
    InvokeXuen = Action.Create({Type = "Spell", ID = 323999}),
    RisingSunKick = Action.Create({Type = "Spell", ID = 107428}),
    SpearHandStrike = Action.Create({Type = "Spell", ID = 116705}),
    StormEarthAndFire = Action.Create({Type = "Spell", ID = 137639}),
    StormEarthAndFireFixate = Action.Create({Type = "Spell", ID = 221771}), -- while StormEarthAndFire buff
    TouchofKarma = Action.Create({Type = "Spell", ID = 122470}),
    SpinningCraneKick = Action.Create({Type = "Spell", ID = 101546}),
    Afterlife = Action.Create({Type = "Spell", ID = 116092, Hidden = true}),
    MasteryComboStrikes = Action.Create({Type = "Spell", ID = 115636, Hidden = true}),
    Windwalking = Action.Create({Type = "Spell", ID = 157411, Hidden = true}),
    --Other
    BlessingofKings = Action.Create({Type = "Spell", ID = 58054}),
    MortalWoundsDebuff = Action.Create({Type = "Spell", ID = 115804}),
    StopCast = Action.Create({Type = "Spell", ID = 61721, Hidden = true}),
    --Hidden
    BlackoutKickBuff = Action.Create({Type = "Spell", ID = 116768, Hidden = true}),
    -- Normal Talents
    EyeoftheTiger = Action.Create({Type = "Spell", ID = 196607, Hidden = true}),
    ChiWave = Action.Create({Type = "Spell", ID = 115098}),
    ChiBurst = Action.Create({Type = "Spell", ID = 123986}),
    Celerity = Action.Create({Type = "Spell", ID = 115173, Hidden = true}),
    ChiTorpedo = Action.Create({Type = "Spell", ID = 115008}),
    TigersLust = Action.Create({Type = "Spell", ID = 116841}),
    Ascension = Action.Create({Type = "Spell", ID = 115396, Hidden = true}),
    FistoftheWhiteTiger = Action.Create({Type = "Spell", ID = 261947}),
    EnergizingElixir = Action.Create({Type = "Spell", ID = 115288}),
    TigerTailSweep = Action.Create({Type = "Spell", ID = 264348, Hidden = true}),
    GoodKarma = Action.Create({Type = "Spell", ID = 280195, Hidden = true}),
    RingofPeace = Action.Create({Type = "Spell", ID = 116844}),
    InnerStrength = Action.Create({Type = "Spell", ID = 261767, Hidden = true}),
    DiffuseMagic = Action.Create({Type = "Spell", ID = 122783}),
    DampenHarm = Action.Create({Type = "Spell", ID = 122278}),
    HitCombo = Action.Create({Type = "Spell", ID = 196740, Hidden = true}),
    RushingJadeWind = Action.Create({Type = "Spell", ID = 116847}),
    DanceofChiJi = Action.Create({Type = "Spell", ID = 325201, Hidden = true}),
    SpiritualFocus = Action.Create({Type = "Spell", ID = 280197, Hidden = true}),
    WhirlingDragonPunch = Action.Create({Type = "Spell", ID = 152175}),
    Serenity = Action.Create({Type = "Spell", ID = 152173}),
    -- PvP Talents
    RidetheWind = Action.Create({Type = "Spell", ID = 201372, Hidden = true}),
    TigereyeBrew = Action.Create({Type = "Spell", ID = 247483}),
    ReverseHarm = Action.Create({Type = "Spell", ID = 342928, Hidden = true}),
    DisablingReach = Action.Create({Type = "Spell", ID = 201769, Hidden = true}),
    GrappleWeapon = Action.Create({Type = "Spell", ID = 233759}),
    AlphaTiger = Action.Create({Type = "Spell", ID = 287503, Hidden = true}),
    WindWaker = Action.Create({Type = "Spell", ID = 287506, Hidden = true}),
    PressurePoints = Action.Create({Type = "Spell", ID = 345829, Hidden = true}),
    TurboFists = Action.Create({Type = "Spell", ID = 287681, Hidden = true}),
    -- Covenant Abilities
    SummonSteward = Action.Create({Type = "Spell", ID = 324739}),
    DoorofShadows = Action.Create({Type = "Spell", ID = 300728}),
    Fleshcraft = Action.Create({Type = "Spell", ID = 321687}),
    Fleshcraftshield = Action.Create({Type = "Spell", ID = 324867}),
    Soulshape = Action.Create({Type = "Spell", ID = 310143}),
    WeaponsofOrder = Action.Create({Type = "Spell", ID = 310454}),
    WeaponsofOrderWW = Action.Create({Type = "Spell", ID = 311054, Hidden = true}),
    BonedustBrew = Action.Create({Type = "Spell", ID = 325216}),
    DeathsDue = Action.Create({Type = "Spell", ID = 324128}),
    FaelineStomp = Action.Create({Type = "Spell", ID = 327104}),
    FallenOrder = Action.Create({Type = "Spell", ID = 326860}),
    PhialOfSerenity = Create({Type = "Potion", ID = 177278}),
    -- Conduits
    CoordinatedOffensive = Action.Create({Type = "Spell", ID = 336598, Hidden = true}),
    -- Legendaries
    -- General Legendaries
    DeathsEmbrace = Action.Create({Type = "Spell", ID = 334728, Hidden = true}),
    EmperorsCapacitorStack = Action.Create({Type = "Spell", ID = 337291}),
    ChiEnergy = Action.Create({Type = "Spell", ID = 337571}),
    --Wind Walker Legendaries
    DeadliestCoil = Action.Create({Type = "Spell", ID = 334949, Hidden = true}),
    --Anima Powers - to add later...

    -- Trinkets
    DreadFireVessel = Create({Type = "Trinket", ID = 6805}),
    -- Potions
    PotionofUnbridledFury = Action.Create({Type = "Potion", ID = 169299, QueueForbidden = true}),
    SuperiorPotionofUnbridledFury = Action.Create({Type = "Potion", ID = 168489, QueueForbidden = true}),
    PotionofSpectralStrength = Action.Create({Type = "Potion", ID = 171275, QueueForbidden = true}),
    PotionofSpectralAgility = Action.Create({Type = "Potion", ID = 171270, QueueForbidden = true}),
    PotionofSpectralStamina = Action.Create({Type = "Potion", ID = 171274, QueueForbidden = true}),
    PotionofEmpoweredExorcisms = Action.Create({Type = "Potion", ID = 171352, QueueForbidden = true}),
    PotionofHardenedShadows = Action.Create({Type = "Potion", ID = 171271, QueueForbidden = true}),
    PotionofPhantomFire = Action.Create({Type = "Potion", ID = 171349, QueueForbidden = true}),
    PotionofDeathlyFixation = Action.Create({Type = "Potion", ID = 171351, QueueForbidden = true}),
    SpiritualHealingPotion = Action.Create({Type = "Potion", ID = 171267, QueueForbidden = true}),
    -- Misc
    Channeling = Action.Create({Type = "Spell", ID = 209274, Hidden = true}), -- Show an icon during channeling
    TargetEnemy = Action.Create({Type = "Spell", ID = 44603, Hidden = true}), -- Change Target (Tab button)
    StopCast = Action.Create({Type = "Spell", ID = 61721, Hidden = true}), -- spell_magic_polymorphrabbit
    PoolResource = Action.Create({Type = "Spell", ID = 209274, Hidden = true}),
    Quake = Action.Create({Type = "Spell", ID = 240447, Hidden = true}), -- Quake (Mythic Plus Affix)
    GCD = Action.Create({Type = "Spell", ID = 61304, Hidden = true})
}

local A = setmetatable(Action[ACTION_CONST_MONK_WINDWALKER], {__index = Action})

local player = "player"
local PartyUnits
TMW:RegisterSelfDestructingCallback(
    "TMW_ACTION_IS_INITIALIZED_PRE",
    function()
        PartyUnits = GetToggle(2, "PartyUnits", ACTION_CONST_MONK_WINDWALKER)
        return true -- Signal RegisterSelfDestructingCallback to unregister
    end
)

local function num(val)
    if val then
        return 1
    else
        return 0
    end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
----------------------
-------- COMMON PREAPL -------
----------------------
local Temp = {
    TotalAndPhys = {"TotalImun", "DamagePhysImun"},
    TotalAndCC = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    IsSlotTrinketBlocked = {}
}
do
    -- Push IsSlotTrinketBlocked
    for key, val in pairs(Action[ACTION_CONST_MONK_WINDWALKER]) do
        if type(val) == "table" and val.Type == "Trinket" then
            Temp.IsSlotTrinketBlocked[val.ID] = true
        end
    end
end

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "NATURE") == 0
end

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

--Register Toaster
Toaster:Register(
    "TripToast",
    function(toast, ...)
        local title, message, spellID = ...
        toast:SetTitle(title or "nil")
        toast:SetText(message or "nil")
        if spellID then
            if type(spellID) ~= "number" then
                error(tostring(spellID) .. " (spellID) is not a number for TripToast!")
                toast:SetIconTexture("Interface\\FriendsFrame\\Battlenet-WoWicon")
            else
                toast:SetIconTexture((GetSpellTexture(spellID)))
            end
        else
            toast:SetIconTexture("Interface\\FriendsFrame\\Battlenet-WoWicon")
        end
        toast:SetUrgencyLevel("normal")
    end
)

function Player:AreaTTD(range)
    local ttdtotal = 0
    local totalunits = 0
    local r = range

    for _, unitID in pairs(ActiveUnitPlates) do
        if Unit(unitID):GetRange() <= r then
            local ttd = Unit(unitID):TimeToDie()
            totalunits = totalunits + 1
            ttdtotal = ttd + ttdtotal
        end
    end

    if totalunits == 0 then
        return 0
    end

    return ttdtotal / totalunits
end

local function InMelee(unit)
    -- @return boolean
    return A.TigerPalm:IsInRange(unit)
end

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean
    local c = 0
    for unit in pairs(ActiveUnitPlates) do
        if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then
            if InMelee(unit) then
                c = c + 1
            elseif range then
                local r = Unit(unit):GetRange()
                if r > 0 and r <= range then
                    c = c + 1
                end
            end

            if c >= count then
                return true
            end
        end
    end
end
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if
        not A.SpearHandStrike:IsReadyByPassCastGCD(unit) or
            not A.SpearHandStrike:AbsentImun(unit, Temp.TotalAndPhysKick, true)
     then
        return true
    end
end

--Work around fix for AoE off breaking
if UseAoE == true then
    AoETargets = Action.GetToggle(2, "AoETargets")
else
    AoETargets = 10
end

-- Interrupts spells
local function Interrupts(unit)
    local LegSweepInterrupt = Action.GetToggle(2, "LegSweepInterrupt")
    local ParalysisInterrupt = Action.GetToggle(2, "ParalysisInterrupt")

    if not A.GetToggle(2, "InterruptsRyan") and (A.InstanceInfo.ID >= 2284 and A.InstanceInfo.ID <= 2296) then --uses ryan interrupt table in SL dungeons and raid instance IDs
        useKick, useCC, useRacial, notKickAble, castLeft = Action.InterruptIsValid(unit, "RyanInterrupts", true)
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime =
            Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end

    if castRemainsTime >= A.GetLatency() then
        -- Spear Hand Strike
        if useKick and not notInterruptable and A.SpearHandStrike:IsReady(unit) then
            return A.SpearHandStrike
        end

        -- Paralysis
        if A.Paralysis:IsReady(unit) and ParalysisInterrupt and A.SpearHandStrike:GetCooldown() > 1 and useCC then
            return A.Paralysis
        end

        -- LegSweep
        if A.LegSweep:IsReady(unit) and LegSweepInterrupt and A.SpearHandStrike:GetCooldown() > 1 and useCC then
            return A.LegSweep
        end

        if useRacial and A.QuakingPalm:AutoRacial(unit) then
            return A.QuakingPalm
        end

        if useRacial and A.Haymaker:AutoRacial(unit) then
            return A.Haymaker
        end

        if useRacial and A.WarStomp:AutoRacial(unit) then
            return A.WarStomp
        end

        if useRacial and A.BullRush:AutoRacial(unit) then
            return A.BullRush
        end
    end
end

local function SelfDefensives(unit)
    -- TouchofKarma
    local TouchofKarma = GetToggle(2, "TouchofKarma")
    if TouchofKarma >= 0 then
        local unit
        if IsUnitEnemy("mouseover") then
            unit = "mouseover"
        elseif IsUnitEnemy("target") then
            unit = "target"
        end

        if unit and A.TouchofKarma:IsReady(unit) and A.TouchofKarma:AbsentImun(unit, Temp.TotalAndPhys, true) then
            if
                -- Auto
                ((TouchofKarma >= 100 and
                    (Unit(player):TimeToDieX(30) < 2.5 or
                        (A.IsInPvP and Unit(player):HealthPercent() < 70 and Unit(player):IsFocused(nil, true)))) or
                    -- Custom
                    (TouchofKarma < 100 and Unit(player):HealthPercent() < TouchofKarma)) and
                    (Unit(player):HasBuffs("DeffBuffs", true) == 0 or Unit(player):HealthPercent() < 20)
             then
                return A.TouchofKarma
            end
        end
    end

    -- Phial of Serenity
    local PhialofSerenityHP, PhialofSerenityOperator, PhialofSerenityTTD = GetToggle(2, "PhialofSerenityHP"), GetToggle(2, "PhialofSerenityOperator"), GetToggle(2, "PhialofSerenityTTD")
    if A.PhialofSerenity:IsReady(player) and Unit(player):HasDeBuffs(A.MindGamesDebuff.ID) == 0 and
    PhialofSerenityOperator == "AND" then
        if (PhialofSerenityHP <= 0 or Unit(player):HealthPercent() <= PhialofSerenityHP) and (PhialofSerenityTTD <= 0 or Unit(player):TimeToDie() <= PhialofSerenityTTD) then
            return A.PhialOfSerenity
        end
    else
        if A.PhialofSerenity:IsReady(player) and (PhialofSerenityHP > 0 and Unit(player):HealthPercent() <= PhialofSerenityHP) or (PhialofSerenityTTD > 0 and Unit(player):TimeToDie() <= PhialofSerenityTTD) then
            return A.PhialOfSerenity
        end
    end
    -- Dispel
    if A.PhialofSerenity:IsReady(player) and AuraIsValidByPhialofSerenity() then
        return A.PhialOfSerenity
    end

    -- DampenHarm
    local DampenHarm = GetToggle(2, "DampenHarm")
    if
        DampenHarm >= 0 and A.DampenHarm:IsReady(player) and
            -- Auto
            ((DampenHarm >= 100 and
                -- HP lose per sec >= 20
                (Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 20 or
                    Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.20 or
                    -- TTD
                    Unit(player):TimeToDieX(25) < 5 or
                    (A.IsInPvP and
                        (Unit(player):UseDeff() or
                            (Unit(player, 5):HasFlags() and Unit(player):GetRealTimeDMG() > 0 and
                                Unit(player):IsFocused())))) and
                Unit(player):HasBuffs("DeffBuffs", true) == 0) or -- Custom
                (DampenHarm < 100 and Unit(player):HealthPercent() <= DampenHarm))
     then
        return A.DampenHarm
    end

    -- DiffuseMagic
    local DiffuseMagic = GetToggle(2, "DiffuseMagic")
    if
        DiffuseMagic >= 0 and A.DiffuseMagic:IsReady(player) and
            -- Auto
            ((DiffuseMagic >= 100 and Unit(player):TimeToDieMagicX(35) < 5 and -- Magic Damage still appear
                Unit(player):GetRealTimeDMG(4) > 0 and
                Unit(player):HasBuffs("DeffBuffsMagic") == 0) or -- Custom
                (DiffuseMagic < 100 and Unit(player):HealthPercent() <= DiffuseMagic))
     then
        return A.DiffuseMagic
    end

    -- FortifyingBrew
    local FortifyingBrew = GetToggle(2, "FortifyingBrew")
    if
        FortifyingBrew >= 0 and A.FortifyingBrew:IsReady(player) and
            -- Auto
            ((FortifyingBrew >= 100 and
                ((not A.IsInPvP and Unit(player):HealthPercent() < 40 and Unit(player):TimeToDieX(20) < 6) or
                    (A.IsInPvP and
                        (Unit(player):UseDeff() or
                            (Unit(player, 5):HasFlags() and Unit(player):GetRealTimeDMG() > 0 and
                                Unit(player):IsFocused(nil, true))))) and
                Unit(player):HasBuffs("DeffBuffs") == 0) or -- Custom
                (FortifyingBrew < 100 and Unit(player):HealthPercent() <= FortifyingBrew))
     then
        return A.FortifyingBrew
    end

    -- Stoneform (On Deffensive)
    local Stoneform = GetToggle(2, "Stoneform")
    if
        Stoneform >= 0 and A.Stoneform:IsRacialReadyP(player) and
            -- Auto
            ((Stoneform >= 100 and
                ((not A.IsInPvP and Unit(player):TimeToDieX(65) < 3) or
                    (A.IsInPvP and
                        (Unit(player):UseDeff() or
                            (Unit(player, 5):HasFlags() and Unit(player):GetRealTimeDMG() > 0 and
                                Unit(player):IsFocused()))))) or -- Custom
                (Stoneform < 100 and Unit(player):HealthPercent() <= Stoneform))
     then
        return A.Stoneform
    end

    -- Stoneform (Self Dispel)
    if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
        return A.Stoneform
    end
end

--Fleshcraft
--local FleshcraftHP = Action.GetToggle(2, "FleshcraftHP")
--local FlashcraftOperator = Action.GetToggle(2, "FleshcraftOperator")
--local FlashcraftTTD = Action.GetToggle(2, "FleshcraftTTD")
--if FleshcraftOperator == "AND" and A.Fleshcraft:IsReady(player) and A.Fleshcraft:GetSpellTimeSinceLastCast() > 120 and Unit(player):HealthPercent() <= FleshcraftHP and Unit(player):TimeToDie() <= FlashcraftTTD then
--    return A.Fleshcraft
--end
--if FleshcraftOperator == "OR" and A.Fleshcraft:IsReady(player) and A.Fleshcraft:GetSpellTimeSinceLastCast() > 120 and (Unit(player):HealthPercent() <= FleshcraftHP or Unit(player):TimeToDie() <= FlashcraftTTD) then
--    return A.Fleshcraft
--end

SelfDefensives = A.MakeFunctionCachedDynamic(SelfDefensives)

local function GetAttackType()
    if A.TigereyeBrew:IsSpellLearned() and Unit(player):HasBuffs(A.TigereyeBrew.ID, true, true) > 0 then
        return Temp.TotalAndMag
    end
    return Temp.TotalAndPhys
end

local function GetAttackTypeForDisable()
    if A.TigereyeBrew:IsSpellLearned() and Unit(player):HasBuffs(A.TigereyeBrew.ID, true, true) > 0 then
        return Temp.DisableMag
    end
    return Temp.DisablePhys
end

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    ----------
    --- ROTATION VAR ---
    ----------
    local EnemyRotation, FriendlyRotation
    local isSchoolFree = IsSchoolFree()
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
    local inDisarm = LoC:Get("DISARM") > 0
    local Energy = Player:Energy()
    local Chi = Player:Chi()
    local inMelee = false

    --    local PotionTTD = Unit("target"):TimeToDie() > Action.GetToggle(2, "PotionTTD")
    local AutoPotionSelect = Action.GetToggle(2, "AutoPotionSelect")
    local PotionTrue = Action.GetToggle(1, "Potion")
    local Racial = Action.GetToggle(1, "Racial")
    local UseAoE = Action.GetToggle(2, "AoE")
    local AoETargets = Action.GetToggle(2, "AoETargets")
    local currentTargets = MultiUnits:GetByRange(7)
    local MouseoverTarget = UnitName("mouseover")

    local function ComboStrike(SpellObject)
        return (not Player:PrevGCD(1, SpellObject))
    end

    --actions+=/variable,name=hold_xuen,op=set,value=cooldown.invoke_xuen_the_white_tiger.remains>fight_remains|fight_remains<120&fight_remains>cooldown.serenity.remains&cooldown.serenity.remains>10
    VarHoldXuen =
        ((A.InvokeXuen:GetCooldown() > Player:AreaTTD(10)) or
        (Player:AreaTTD(10) < 120 and Player:AreaTTD(10) > A.Serenity:GetCooldown() and A.Serenity:GetCooldown() > 10))

    --actions.cd_serenity=variable,name=serenity_burst,op=set,value=cooldown.serenity.remains<1|pet.xuen_the_white_tiger.active&cooldown.serenity.remains>30|fight_remains<20
    VarSerenityBurst =
        (A.Serenity:GetCooldown() < 1 or
        (A.InvokeXuen:GetSpellTimeSinceLastCast() < 24 and A.Serenity:GetCooldown() > 30) or
        Player:AreaTTD(10) < 20)

    --------------------------------------
    -------- ENEMY UNIT ROTATION ---------
    --------------------------------------
    local function EnemyRotation(unit)
        local _, _, _, _, _, _, _, ChannelCheckplayer = UnitChannelInfo("player")
        local _, _, _, _, ChannelEndMouseover, _, _, ChannelCheckmouseover = UnitChannelInfo("mouseover")

        local inMelee = A.TigerPalm:IsInRange(target or unit)
        -- StormEarthAndFireFixate
        if
            target and useStormEarthAndFireFixate and isSchoolFree and A.StormEarthAndFireFixate:IsReady(target) and
                not A.Serenity:IsSpellLearned() and
                Unit(player):HasBuffs(A.StormEarthAndFire.ID, true) > 0
         then
            return A.StormEarthAndFireFixate:Show(icon)
        end

        -- Check if target is explosive or totem for dont use AoE spells
        if Unit(unit):IsExplosives() or (A.Zone ~= "none" and Unit(unit):IsTotem()) then
            inAoE = false
        end

        --Explosive Rotation
        local function ExplosiveRotation()
            if Unit("target"):IsExplosives() and ChannelCheckplayer == 113656 then
                return A.StopCast:Show(icon)
            end
            if A.TigerPalm:IsReady("target") and (ComboStrike(A.TigerPalm) or not A.HitCombo:IsTalentLearned()) then
                return A.TigerPalm:Show(icon)
            end
            if A.BlackoutKick:IsReady("target") and (ComboStrike(A.BlackoutKick) or not A.HitCombo:IsTalentLearned()) then
                return A.BlackoutKick:Show(icon)
            end
            if A.RisingSunKick:IsReady("target") then
                return A.RisingSunKick:Show(icon)
            end
        end

        if Unit("target"):IsExplosives() and ExplosiveRotation() then
            return true
        end

        --Explosive TargetMouseOver
        A[6] = function(icon, isMulti)
            if
                (A.TigerPalm:IsReady("mouseover") or A.BlackoutKick:IsReady("mouseover") or
                    A.RisingSunKick:IsReady("mouseover")) and
                    A.TigerPalm:IsInRange("mouseover") and
                    Action.GetToggle(2, "ExplosiveMouseover") and
                    Unit("mouseover"):IsExplosives() and
                    (not ChannelCheckplayer == 113656 or
                        (Unit("mouseover"):IsExplosives() and ChannelEndMouseover < 2000))
             then
                return A:Show(icon, ACTION_CONST_LEFT)
            end
        end

        -- Out of combat / Precombat
        if target and inCombat == 0 and not A.IsInPvP then
            local Pull = BossMods:GetPullTimer()

            -- PotionofUnbridledFury => ChiWave => ChiBurst
            if Pull > 0 then
                -- Timing
                local extra_time = GetCurrentGCD() + 0.1
                local ChiWave, ChiBurst

                -- ChiWave
                -- actions.precombat+=/chi_wave,if=!talent.energizing_elixir.enabled
                if
                    inAoE and isSchoolFree and A.ChiWave:IsReady(target, true, nil, true) and
                        (not A.EnergizingElixir:IsTalentLearned()) and
                        (not A.IsInPvP or (Unit(target):GetRange() <= 25 and not EnemyTeam("HEALER"):IsBreakAble(25)))
                 then
                    ChiWave = true
                    extra_time = extra_time + GetGCD()
                end

                -- ChiBurst
                -- actions.precombat+=/chi_burst
                if
                    inAoE and not isMoving and isSchoolFree and A.ChiBurst:IsReady(target, true, nil, true) and
                        (not A.IsInPvP or (Unit(target):GetRange() <= 40 and not EnemyTeam("HEALER"):IsBreakAble(40)))
                 then
                    ChiBurst = true
                    extra_time = extra_time + A.ChiBurst:GetSpellCastTime()
                end

                -- Pull Rotation
                if not inDisarm and A.PotionofUnbridledFury:IsReady(target, true, nil, true) and Pull <= 2.5 then
                    return A.PotionofUnbridledFury:Show(icon)
                end

                if ChiWave and not ShouldStop() and Pull <= extra_time then
                    return A.ChiWave:Show(icon)
                end

                if ChiBurst and not ShouldStop() and Pull <= extra_time then
                    return A.ChiBurst:Show(icon)
                end

                -- Return
                return
            end
        end

        --#####################
        --##### SERENITY ######
        --#####################
        local function SerenityRotation()
            --actions.serenity=fists_of_fury,if=buff.serenity.remains<1
            if
                A.FistsofFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Unit(player):HasBuffs(A.Serenity.ID, true) < 1
             then
                return A.FistsofFury:Show(icon)
            end

            -- Trinket 1
            if A.Trinket1:IsReady(unit) and Unit(unit):GetRange() <= 7 then
                return A.Trinket1:Show(icon)
            end

            -- Trinket 2
            if A.Trinket2:IsReady(unit) and Unit(unit):GetRange() <= 7 then
                return A.Trinket2:Show(icon)
            end

            --actions.serenity+=/spinning_crane_kick,if=combo_strike&(active_enemies>=3|active_enemies>1&!cooldown.rising_sun_kick.up)
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    (MultiUnits:GetByRange(10, 3) >= 3 or
                        (MultiUnits:GetByRange(10, 3) >= 1 and A.RisingSunKick:GetCooldown() > 0))
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.serenity+=/rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike
            if A.RisingSunKick:IsReady(unit) and ComboStrike(A.RisingSunKick) then
                return A.RisingSunKick:Show(icon)
            end

            --actions.serenity+=/fists_of_fury,if=active_enemies>=3
            if
                A.FistsofFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    MultiUnits:GetByRange(10, 3) >= 3
             then
                return A.FistsofFury:Show(icon)
            end

            --actions.serenity+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    Unit(player):HasBuffs(A.DanceofChiJi.ID, true) > 0
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.serenity+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&buff.weapons_of_order_ww.up&cooldown.rising_sun_kick.remains>2
            if
                A.BlackoutKick:IsReady(unit) and ComboStrike(A.BlackoutKick) and
                    Unit("player"):HasBuffs(A.WeaponsofOrderWW.ID, true) > 0 and
                    A.RisingSunKick:GetCooldown() > 2
             then
                return A.BlackoutKick:Show(icon)
            end

            --actions.serenity+=/fists_of_fury,interrupt_if=!cooldown.rising_sun_kick.up
            if A.FistsofFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.FistsofFury:Show(icon)
            end

            -- Interrupt for FoF
            if
                A.FistsofFury:GetSpellTimeSinceLastCast() < 1 and Unit(player):HasBuffs(A.Serenity.ID, true) > 0 and
                    A.RisingSunKick:IsReady(unit)
             then
                return A.StopCast:Show(icon)
            end

            --actions.serenity+=/spinning_crane_kick,if=combo_strike&debuff.bonedust_brew.up
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    Unit("target"):HasDeBuffs(A.BonedustBrew.ID, true) > 0
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.serenity+=/fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
            if A.FistoftheWhiteTiger:IsReady() and Player:Chi() < 3 then
                return A.FistoftheWhiteTiger:Show(icon)
            end

            --actions.serenity+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike|!talent.hit_combo
            if A.BlackoutKick:IsReady(unit) and (ComboStrike(A.BlackoutKick) or not A.HitCombo:IsTalentLearned()) then
                return A.BlackoutKick:Show(icon)
            end

            --actions.serenity+=/spinning_crane_kick
            if
                A.SpinningCraneKick:IsReady() and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick)
             then
                return A.SpinningCraneKick:Show(icon)
            end
        end

        --#####################
        --####### OPENER ######
        --#####################

        local function OpenerRotation()
            --actions.opener=fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3
            if A.FistoftheWhiteTiger:IsReady(unit) and Player:ChiDeficit() >= 3 then
                return A.FistoftheWhiteTiger:Show(icon)
            end

            --actions.opener+=/expel_harm,if=talent.chi_burst.enabled&chi.max-chi>=3
            if
                A.ExpelHarm:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    A.ChiBurst:IsTalentLearned() and
                    Player:ChiDeficit() >= 3
             then
                return A.ExpelHarm:Show(icon)
            end

            --actions.opener+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2
            if A.TigerPalm:IsReady(unit) and ComboStrike(A.TigerPalm) and Player:ChiDeficit() >= 2 then
                return A.TigerPalm:Show(icon)
            end

            --actions.opener+=/chi_wave,if=chi.max-chi=2
            if A.ChiWave:IsReady(unit) and Player:ChiDeficit() == 2 then
                return A.ChiWave:Show(icon)
            end

            --actions.opener+=/expel_harm
            if A.ExpelHarm:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.ExpelHarm:Show(icon)
            end

            --actions.opener+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=chi.max-chi>=2
            if A.TigerPalm:IsReady(unit) and Player:ChiDeficit() >= 2 and ComboStrike(A.TigerPalm) then
                return A.TigerPalm:Show(icon)
            end
        end

        --#####################
        --######## AOE ########
        --#####################

        local function AoERotation()
            --actions.aoe=whirling_dragon_punch
            if A.WhirlingDragonPunch:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.WhirlingDragonPunch:Show(icon)
            end

            if
                A.StormEarthAndFire:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Action.GetToggle(2, "SEFOutBurst") and
                    A.StormEarthAndFire:GetSpellCharges() == 2 and
                    Player:AreaTTD(10) > 15
             then
                return A.StormEarthAndFire:Show(icon)
            end

            if
                A.StormEarthAndFireFixate:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    A.CoordinatedOffensive:IsSoulbindLearned()
             then
                return A.StormEarthandFire:Show(icon)
            end

            --actions.aoe+=/energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>2|chi.max-chi>=4
            if
                A.EnergizingElixir:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ((Player:ChiDeficit() >= 2 and Player:EnergyTimeToMaxPredicted()) > 2 or Player:ChiDeficit() >= 4)
             then
                return A.EnergizingElixir:Show(icon)
            end

            --actions.aoe+=/spinning_crane_kick,if=combo_strike&(buff.dance_of_chiji.up|debuff.bonedust_brew.up)
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    (Unit("player"):HasBuffs(A.DanceofChiJi.ID, true) > 0 or
                        Unit("player"):HasBuffs(A.BonedustBrew.ID, true) > 0)
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.aoe+=/fists_of_fury,if=energy.time_to_max>execute_time|chi.max-chi<=1
            if
                A.FistsofFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (((Player:EnergyTimeToMaxPredicted() > Unit("target"):TimeToDieX(15)) or Unit("target"):IsDummy()) or
                        Player:ChiDeficit() <= 1)
             then
                return A.FistsofFury:Show(icon)
            end

            --actions.aoe+=/rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch&cooldown.rising_sun_kick.duration>cooldown.whirling_dragon_punch.remains+4)&(cooldown.fists_of_fury.remains>3|chi>=5)
            if
                A.RisingSunKick:IsReady(unit) and ComboStrike(A.RisingSunKick) and
                    (A.WhirlingDragonPunch:IsTalentLearned() and
                        (10 * Player:SpellHaste()) > (A.WhirlingDragonPunch:GetCooldown() + 4)) and
                    (A.FistsofFury:GetCooldown() > 3 or Player:Chi() >= 5)
             then
                return A.RisingSunKick:Show(icon)
            end

            --actions.aoe+=/rushing_jade_wind,if=buff.rushing_jade_wind.down
            if
                A.RushingJadeWind:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Unit("player"):HasBuffs(A.RushingJadeWind.ID, true) == 0
             then
                return A.RushingJadeWind:Show(icon)
            end

            --actions.aoe+=/spinning_crane_kick,if=combo_strike&((cooldown.bonedust_brew.remains>2&(chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2))|energy.time_to_max<=3)
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (ComboStrike(A.SpinningCraneKick) and
                        (((A.BonedustBrew:GetCooldown() > 2 or not (C_Covenants.GetActiveCovenantID() == 4)) and
                            (Player:Chi() > 3 or (A.FistsofFury:GetCooldown() > 6)) and
                            (Player:Chi() >= 5 or A.FistsofFury:GetCooldown() > 2)) or
                            Player:EnergyTimeToMaxPredicted() <= 3))
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.aoe+=/expel_harm,if=chi.max-chi>=1
            if A.ExpelHarm:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and Player:ChiDeficit() >= 1 then
                return A.ExpelHarm:Show(icon)
            end

            --actions.aoe+=/fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3
            if A.FistoftheWhiteTiger:IsReady(unit) and Player:ChiDeficit() >= 3 then
                return A.FistoftheWhiteTiger:Show(icon)
            end

            --actions.aoe+=/chi_burst,if=chi.max-chi>=2
            if A.ChiBurst:IsReady(player) and Player:ChiDeficit() >= 2 and not fsMoving then
                return A.ChiBurst:Show(icon)
            end

            --actions.aoe+=/crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&energy.time_to_max>execute_time-1&cooldown.fists_of_fury.remains>execute_time
            if
                A.CracklingJadeLightning:IsReady(unit) and
                    Unit("player"):HasBuffs(A.EmperorsCapacitorStack.ID, true) > 19 and
                    Player:EnergyTimeToMaxPredicted() > (Unit("target"):TimeToDieX(15) - 1) and
                    A.FistsofFury:GetCooldown() > Unit("target"):TimeToDieX(15)
             then
                return A.CracklingJadeLightning:Show(icon)
            end

            --actions.aoe+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=chi.max-chi>=2&(!talent.hit_combo|combo_strike)
            if
                A.TigerPalm:IsReady(unit) and Player:ChiDeficit() >= 2 and
                    (not A.HitCombo:IsTalentLearned() or ComboStrike(A.TigerPalm))
             then
                return A.TigerPalm:Show(icon)
            end

            --actions.aoe+=/chi_wave,if=combo_strike
            if A.ChiWave:IsReady(unit) and ComboStrike(A.ChiWave) then
                return A.ChiWave:Show(icon)
            end

            --actions.aoe+=/flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
            if
                A.FlyingSerpentKick:IsReady(unit) and Action.GetToggle(2, "ToggleFlying") and not isMoving and
                    LoC:Get("ROOT") == 0 and
                    Unit("target"):GetRange() <= 8 and
                    Unit("player"):HasBuffs(A.BlackoutKickBuff, true) == 0 and
                    A.FlyingSerpentKick:AbsentImun(target, GetAttackType()) and
                    Unit(player):HasBuffs(A.BlackoutKickBuff.ID, true) == 0 and
                    (not A.IsInPvP or not EnemyTeam("HEALER"):IsBreakAble(25))
             then
                return A.FlyingSerpentKick:Show(icon)
            end

            -- Cancel for FoF with SEF and Weapons
            if A.FlyingSerpentKick:GetSpellTimeSinceLastCast() < 0.5 and Action.GetToggle(2, "ToggleFlying") then
                return A.FlyingSerpentKickJump:Show(icon)
            end

            --actions.aoe+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&(buff.bok_proc.up|talent.hit_combo&prev_gcd.1.tiger_palm&chi=2&cooldown.fists_of_fury.remains<3|chi.max-chi<=1&prev_gcd.1.spinning_crane_kick&energy.time_to_max<3)
            if
                A.BlackoutKick:IsReady(unit) and
                    (ComboStrike(A.BlackoutKick) and
                        ((Unit("target"):HasBuffs(A.BlackoutKickBuff.ID, true) > 0) or
                            (A.HitCombo:IsTalentLearned() and Player:PrevGCD(1, A.TigerPalm) and Player:Chi() == 2 and
                                A.FistsofFury:GetCooldown() < 3) or
                            (Player:ChiDeficit() <= 1 and Player:PrevGCD(1, A.SpinningCraneKick) and
                                Player:EnergyTimeToMaxPredicted() < 3)))
             then
                return A.BlackoutKick:Show(icon)
            end
        end

        --#####################
        --#### COOLDOWNSEF ####
        --#####################

        local function Cooldownsef()
            --actions.cd_sef=invoke_xuen_the_white_tiger,if=!variable.hold_xuen|fight_remains<25
            if
                A.InvokeXuen:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (not VarHoldXuen or Player:AreaTTD(10) < 25)
             then
                return A.InvokeXuen:Show(icon)
            end

            --actions.cd_sef+=/arcane_torrent,if=chi.max-chi>=1
            if
                A.ArcaneTorrent:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Player:ChiDeficit() >= 1
             then
                return A.ArcaneTorrent:Show(icon)
            end

            --actions.cd_sef+=/touch_of_death,if=buff.storm_earth_and_fire.down&pet.xuen_the_white_tiger.active|fight_remains<10|fight_remains>180
            if
                A.TouchofDeath:IsReady(unit) and
                    ((Unit("player"):HasBuffs(A.StormEarthAndFire.ID, true) == 0 and
                        A.InvokeXuen:GetSpellTimeSinceLastCast() < 24) or
                        Player:AreaTTD(10) < 10 or
                        (Player:AreaTTD(10) > 180 or Unit("target"):IsDummy()))
             then
                return A.TouchofDeath:Show(icon)
            end

            --actions.cd_sef+=/weapons_of_order,if=(raid_event.adds.in>45|raid_event.adds.up)&cooldown.rising_sun_kick.remains<execute_time
            if
                A.WeaponsofOrder:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (A.RisingSunKick:GetCooldown() < Unit("target"):TimeToDieX(15) or Unit("target"):IsDummy())
             then
                return A.WeaponsofOrder:Show(icon)
            end

            --actions.cd_sef+=/faeline_stomp,if=combo_strike&(raid_event.adds.in>10|raid_event.adds.up)
            if
                A.FaelineStomp:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.FaelineStomp)
             then
                return A.FaelineStomp:Show(icon)
            end

            --actions.cd_sef+=/fallen_order,if=raid_event.adds.in>30|raid_event.adds.up
            if A.FallenOrder:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.FallenOrder:Show(icon)
            end

            --actions.cd_sef+=/bonedust_brew,if=raid_event.adds.in>50|raid_event.adds.up,line_cd=60
            if A.BonedustBrew:IsReady(unit) and A.BonedustBrew:GetSpellTimeSinceLastCast() > 60 then
                return A.BonedustBrew:Show(icon)
            end

            --actions.cd_sef+=/storm_earth_and_fire_fixate,if=conduit.coordinated_offensive.enabled
            if A.StormEarthAndFireFixate:IsReady(player) and A.CoordinatedOffensive:IsSoulbindLearned() then
                return A.StormEarthAndFireFixate:Show(icon)
            end

            --actions.cd_sef+=/storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|fight_remains<20|(raid_event.adds.remains>15|!covenant.kyrian&((cooldown.invoke_xuen_the_white_tiger.remains>cooldown.storm_earth_and_fire.full_recharge_time|variable.hold_xuen))&cooldown.fists_of_fury.remains<=9&chi>=2&cooldown.whirling_dragon_punch.remains<=12)
            if
                A.StormEarthAndFire:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    not A.StormEarthAndFireFixate:IsReady(unit) and
                    (A.StormEarthAndFire:GetSpellCharges() == 2 or
                        (Player:AreaTTD(10) < 20 or
                            (Unit("target"):IsDummy() and (300 - Unit("player"):CombatTime()) < 20)) or
                        (C_Covenants.GetActiveCovenantID() ~= 1) and
                            ((A.InvokeXuen:GetCooldown() > A.StormEarthAndFire:GetSpellChargesFullRechargeTime()) or
                                VarHoldXuen) and
                            A.FistsofFury:GetCooldown() <= 9 and
                            Player:Chi() >= 2 and
                            A.WhirlingDragonPunch:GetCooldown() <= 12)
             then
                return A.StormEarthAndFire:Show(icon)
            end

            --actions.cd_sef+=/storm_earth_and_fire,if=covenant.kyrian&(buff.weapons_of_order.up|(fight_remains<cooldown.weapons_of_order.remains|cooldown.weapons_of_order.remains>cooldown.storm_earth_and_fire.full_recharge_time)&cooldown.fists_of_fury.remains<=9&chi>=2&cooldown.whirling_dragon_punch.remains<=12)
            if
                A.StormEarthAndFire:IsReady(unit) and not A.StormEarthAndFireFixate:IsReady(unit) and
                    (inMelee or Unit("target"):GetRange() <= 8) and
                    (C_Covenants.GetActiveCovenantID() == 1 and
                        (Unit("player"):HasBuffs(A.WeaponsofOrder.ID, true) > 0 or
                            ((Player:AreaTTD(10) < A.WeaponsofOrder:GetCooldown()) or
                                (A.WeaponsofOrder:GetCooldown() > A.StormEarthAndFire:GetSpellChargesFullRechargeTime())) and
                                A.FistsofFury:GetCooldown() <= 9 and
                                Player:Chi() >= 2 and
                                A.WhirlingDragonPunch:GetCooldown() <= 12))
             then
                return A.StormEarthAndFire:Show(icon)
            end

            -- Trinket 1
            if A.Trinket1:IsReady(unit) and Unit(unit):GetRange() <= 7 then
                return A.Trinket1:Show(icon)
            end

            -- Trinket 2
            if A.Trinket2:IsReady(unit) and Unit(unit):GetRange() <= 7 then
                return A.Trinket2:Show(icon)
            end

            --actions.cd_sef+=/touch_of_karma,if=fight_remains>159|pet.xuen_the_white_tiger.active|variable.hold_xuen
            if
                A.TouchofKarma:IsReady(unit) and
                    ((Player:AreaTTD(10) > 159 or Unit("target"):IsDummy()) or
                        A.InvokeXuen:GetSpellTimeSinceLastCast() < 24 or
                        VarHoldXuen)
             then
                return A.TouchofKarma:Show(icon)
            end

            --actions.cd_sef+=/blood_fury,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<20
            if
                A.BloodFury:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (A.InvokeXuen:GetCooldown() > 30 or VarHoldXuen or Player:AreaTTD(10) < 20)
             then
                return A.BloodFury:Show(icon)
            end

            --actions.cd_sef+=/berserking,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<15
            if
                A.Berserking:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (A.InvokeXuen:GetCooldown() > 30 or VarHoldXuen or Player:AreaTTD(10) < 15)
             then
                return A.Berserking:Show(icon)
            end

            --actions.cd_sef+=/lights_judgment
            if A.LightsJudgment:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.LightsJudgment:Show(icon)
            end

            --actions.cd_sef+=/fireblood,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<10
            if
                A.Fireblood:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (A.InvokeXuen:GetCooldown() > 30 or VarHoldXuen or Player:AreaTTD(10) < 10)
             then
                return A.Fireblood:Show(icon)
            end

            --actions.cd_sef+=/ancestral_call,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<20
            if
                A.AncestralCall:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (A.InvokeXuen:GetCooldown() > 30 or VarHoldXuen or Player:AreaTTD(10) < 20)
             then
                return A.AncestralCall:Show(icon)
            end

            --actions.cd_sef+=/bag_of_tricks,if=buff.storm_earth_and_fire.down
            if
                A.BagofTricks:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Unit("player"):HasBuffs(A.StormEarthAndFire.ID, true) == 0
             then
                return A.BagofTricks:Show(icon)
            end
        end

        --#############################
        --##### COOLDOWN SERENITY #####
        --#############################

        local function CooldownSerenity()
            --actions.cd_serenity+=/invoke_xuen_the_white_tiger,if=!variable.hold_xuen|fight_remains<25
            if
                A.InvokeXuen:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (not VarHoldXuen or Player:AreaTTD(10) < 25)
             then
                return A.InvokeXuen:Show(icon)
            end

            -- Trinket 1
            if A.Trinket1:IsReady(unit) and Unit(unit):GetRange() <= 7 then
                return A.Trinket1:Show(icon)
            end

            -- Trinket 2
            if A.Trinket2:IsReady(unit) and Unit(unit):GetRange() <= 7 then
                return A.Trinket2:Show(icon)
            end

            --actions.cd_serenity+=/blood_fury,if=variable.serenity_burst
            if A.BloodFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and VarSerenityBurst then
                return A.BloodFury:Show(icon)
            end

            --actions.cd_serenity+=/berserking,if=variable.serenity_burst
            if A.Berserking:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and VarSerenityBurst then
                return A.Berserking:Show(icon)
            end

            --actions.cd_serenity+=/arcane_torrent,if=chi.max-chi>=1
            if
                A.ArcaneTorrent:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Player:ChiDeficit() >= 1
             then
                return A.ArcaneTorrent:Show(icon)
            end

            --actions.cd_serenity+=/lights_judgment
            if A.LightsJudgment:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.LightsJudgment:Show(icon)
            end

            --actions.cd_serenity+=/fireblood,if=variable.serenity_burst
            if A.Fireblood:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and VarSerenityBurst then
                return A.Fireblood:Show(icon)
            end

            --actions.cd_serenity+=/ancestral_call,if=variable.serenity_burst
            if A.AncestralCall:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and VarSerenityBurst then
                return A.AncestralCall:Show(icon)
            end

            --actions.cd_serenity+=/bag_of_tricks,if=variable.serenity_burst
            if A.BagofTricks:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and VarSerenityBurst then
                return A.BagofTricks:Show(icon)
            end

            --actions.cd_serenity+=/touch_of_death,if=fight_remains>180|pet.xuen_the_white_tiger.active|fight_remains<10
            if
                A.TouchofDeath:IsReady(unit) and
                    ((Player:AreaTTD(10) > 180 or Unit("target"):IsDummy()) or
                        A.InvokeXuen:GetSpellTimeSinceLastCast() < 24 or
                        Player:AreaTTD(10) < 10)
             then
                return A.TouchofDeath:Show(icon)
            end

            --actions.cd_serenity+=/touch_of_karma,if=fight_remains>90|pet.xuen_the_white_tiger.active|fight_remains<10
            if
                A.TouchofKarma:IsReady(unit) and
                    ((Player:AreaTTD(10) > 90 or Unit("target"):IsDummy()) or
                        A.InvokeXuen:GetSpellTimeSinceLastCast() < 24 or
                        Player:AreaTTD(10) < 10)
             then
                return A.TouchofKarma:Show(icon)
            end

            --actions.cd_serenity+=/weapons_of_order,if=cooldown.rising_sun_kick.remains<execute_time
            if
                A.WeaponsofOrder:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ((A.RisingSunKick:GetCooldown() < Unit("target"):TimeToDieX(15)) or Unit("target"):IsDummy())
             then
                return A.WeaponsofOrder:Show(icon)
            end

            --actions.cd_serenity+=/faeline_stomp
            if A.FaelineStomp:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.FaelineStomp:Show(icon)
            end

            --actions.cd_serenity+=/fallen_order
            if A.FallenOrder:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.FallenOrder:Show(icon)
            end

            --actions.cd_serenity+=/bonedust_brew
            if A.BonedustBrew:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.BonedustBrew:Show(icon)
            end

            --actions.cd_serenity+=/serenity,if=cooldown.rising_sun_kick.remains<2|fight_remains<15
            if
                A.Serenity:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) and
                    (A.RisingSunKick:GetCooldown() < 2 or Player:AreaTTD(10) < 15)
             then
                return A.Serenity:Show(icon)
            end

            --actions.cd_serenity+=/bag_of_tricks
            if A.BagofTricks:IsReady(unit) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.BagofTricks:Show(icon)
            end
        end

        --#####################
        --###### WEAPONS ######
        --#####################
        local function WeaponsRotation()
            --actions.weapons_of_order=call_action_list,name=cd_sef,if=!talent.serenity
            if not A.Serenity:IsTalentLearned() and Cooldownsef() then
                return true
            end

            --actions.weapons_of_order+=/call_action_list,name=cd_serenity,if=talent.serenity
            if A.Serenity:IsTalentLearned() and CooldownSerenity() then
                return true
            end

            --actions.weapons_of_order+=/energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>3
            if
                A.EnergizingElixir:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Player:ChiDeficit() >= 2 and
                    Player:EnergyTimeToMaxPredicted() > 3
             then
                return A.EnergizingElixir:Show(icon)
            end

            --actions.weapons_of_order+=/rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains
            if A.RisingSunKick:IsReady(unit) then
                return A.RisingSunKick:Show(icon)
            end

            --actions.weapons_of_order+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    Unit(player):HasBuffs(A.DanceofChiJi.ID, true) > 0
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.weapons_of_order+=/fists_of_fury,if=active_enemies>=2&buff.weapons_of_order_ww.remains<1
            if
                A.FistsofFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    MultiUnits:GetByRange(10, 2) >= 2 and
                    Unit("player"):HasBuffs(A.WeaponsofOrderWW.ID, true) < 1
             then
                return A.FistsofFury:Show(icon)
            end

            --actions.weapons_of_order+=/whirling_dragon_punch,if=active_enemies>=2
            if
                A.WhirlingDragonPunch:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    MultiUnits:GetByRange(10, 2) >= 2
             then
                return A.WhirlingDragonPunch:Show(icon)
            end

            --actions.weapons_of_order+=/spinning_crane_kick,if=combo_strike&active_enemies>=3&buff.weapons_of_order_ww.up
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    MultiUnits:GetByRange(10, 3) >= 3 and
                    Unit("player"):HasBuffs(A.WeaponsofOrderWW.ID, true) > 0
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.weapons_of_order+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&active_enemies<=2
            if A.BlackoutKick:IsReady(unit) and ComboStrike(A.BlackoutKick) and MultiUnits:GetByRange(10, 2) <= 2 then
                return A.BlackoutKick:Show(icon)
            end

            --actions.weapons_of_order+=/whirling_dragon_punch
            if A.WhirlingDragonPunch:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.WhirlingDragonPunch:Show(icon)
            end

            --actions.weapons_of_order+=/fists_of_fury,interrupt=1,if=buff.storm_earth_and_fire.up&raid_event.adds.in>cooldown.fists_of_fury.duration*0.6
            if A.FistsofFury:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.FistsofFury:Show(icon)
            end

            -- Cancel for FoF with SEF and Weapons
            if
                A.FistsofFury:GetSpellTimeSinceLastCast() < 1 and Unit(player):HasBuffs(A.WeaponsofOrder.ID, true) > 0 and
                    Unit(player):HasBuffs(A.StormEarthAndFire.ID, true) > 0
             then
                return A.StopCast:Show(icon)
            end

            --actions.weapons_of_order+=/spinning_crane_kick,if=buff.chi_energy.stack>30-5*active_enemies
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    Unit(player):HasBuffsStacks(A.ChiEnergy.ID, true) > (30 - (5 * (MultiUnits:GetByRange(10, 6))))
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.weapons_of_order+=/fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
            if A.FistoftheWhiteTiger:IsReady(unit) and Player:Chi() < 3 then
                return A.FistoftheWhiteTiger:Show(icon)
            end

            --actions.weapons_of_order+=/expel_harm,if=chi.max-chi>=1
            if A.ExpelHarm:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and Player:ChiDeficit() >= 1 then
                return A.ExpelHarm:Show(icon)
            end

            --actions.weapons_of_order+=/chi_burst,if=chi.max-chi>=(1+active_enemies>1)
            if A.ChiBurst:IsReady(player) and Player:ChiDeficit() >= (1 + MultiUnits:GetByRange(10, 6)) and not IsMoving then
                return A.ChiBurst:Show(icon)
            end

            --actions.weapons_of_order+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=(!talent.hit_combo|combo_strike)&chi.max-chi>=2
            if
                A.TigerPalm:IsReady(unit) and (not A.HitCombo:IsTalentLearned() or ComboStrike(A.TigerPalm)) and
                    Player:ChiDeficit() >= 2
             then
                return A.TigerPalm:Show(icon)
            end

            --actions.weapons_of_order+=/chi_wave
            if A.ChiWave:IsReady(unit) then
                return A.ChiWave:Show(icon)
            end

            --actions.weapons_of_order+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=chi>=3|buff.weapons_of_order_ww.up
            if
                A.BlackoutKick:IsReady(unit) and
                    (Player:Chi() >= 3 or Unit("player"):HasBuffs(A.WeaponsofOrderWW.ID, true) > 0)
             then
                return A.BlackoutKick:Show(icon)
            end

            --actions.weapons_of_order+=/flying_serpent_kick,interrupt=1
            if
                target and Unit("target"):GetRange() <= 8 and Action.GetToggle(2, "ToggleFlying") and not isMoving and
                    LoC:Get("ROOT") == 0 and
                    A.FlyingSerpentKick:IsReady(target, true) and
                    A.FlyingSerpentKick:AbsentImun(target, GetAttackType()) and
                    Unit(player):HasBuffs(A.BlackoutKickBuff.ID, true) == 0 and
                    (not A.IsInPvP or not EnemyTeam("HEALER"):IsBreakAble(25))
             then
                return A.FlyingSerpentKick:Show(icon)
            end

            -- Cancel for Kick
            if A.FlyingSerpentKick:GetSpellTimeSinceLastCast() < 0.5 and Action.GetToggle(2, "ToggleFlying") then
                return A.FlyingSerpentKickJump:Show(icon)
            end
        end

        --#####################
        --######## ST #########
        --#####################
        local function STRotation()
            --actions.st=whirling_dragon_punch,if=raid_event.adds.in>cooldown.whirling_dragon_punch.duration*0.8|raid_event.adds.up
            if A.WhirlingDragonPunch:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) then
                return A.WhirlingDragonPunch:Show(icon)
            end

            if
                A.StormEarthAndFire:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Action.GetToggle(2, "SEFOutBurst") and
                    A.StormEarthAndFire:GetSpellCharges() == 2 and
                    Player:AreaTTD(10) > 15
             then
                return A.StormEarthAndFire:Show(icon)
            end

            if A.StormEarthAndFireFixate:IsReady(player) and A.CoordinatedOffensive:IsSoulbindLearned() then
                return A.StormEarthAndFireFixate:Show(icon)
            end

            --actions.st+=/energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>3|chi.max-chi>=4&(energy.time_to_max>2|!prev_gcd.1.tiger_palm)
            if
                A.EnergizingElixir:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ((Player:ChiDeficit() >= 2 and Player:EnergyTimeToMaxPredicted() > 3) or
                        (Player:ChiDeficit() >= 4 and
                            (Player:EnergyTimeToMaxPredicted() > 2 or not Player:PrevGCD(1, A.TigerPalm))))
             then
                return A.EnergizingElixir:Show(icon)
            end

            --actions.st+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&(raid_event.adds.in>buff.dance_of_chiji.remains-2|raid_event.adds.up)
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    Unit(player):HasBuffs(A.DanceofChiJi.ID, true) > 0
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.st+=/rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=cooldown.serenity.remains>1|!talent.serenity
            if
                A.RisingSunKick:IsReady(unit) and ComboStrike(A.RisingSunKick) and
                    (A.Serenity:GetCooldown() > 1 or not A.Serenity:IsTalentLearned())
             then
                return A.RisingSunKick:Show(icon)
            end

            --actions.st+=/fists_of_fury,if=(raid_event.adds.in>cooldown.fists_of_fury.duration*0.8|raid_event.adds.up)&(energy.time_to_max>execute_time-1|chi.max-chi<=1|buff.storm_earth_and_fire.remains<execute_time+1)|fight_remains<execute_time+1
            if
                A.FistsofFury:IsReady(player) and (inMelee or Unit(unit):GetRange() <= 8) and
                    ((Player:EnergyTimeToMaxPredicted() > (Unit("target"):TimeToDieX(15) - 1)) or
                        Player:ChiDeficit() <= 1 or
                        ((Unit(player):HasBuffs(A.StormEarthAndFire.ID, true) < (Unit("target"):TimeToDieX(15) + 1)) or
                            Unit("target"):IsDummy()) or
                        (Player:AreaTTD(10) < (Unit("target"):TimeToDieX(15) + 1) or Unit("target"):IsDummy()))
             then
                return A.FistsofFury:Show(icon)
            end

            --actions.st+=/crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&energy.time_to_max>execute_time-1&cooldown.rising_sun_kick.remains>execute_time|buff.the_emperors_capacitor.stack>14&(cooldown.serenity.remains<5&talent.serenity|cooldown.weapons_of_order.remains<5&covenant.kyrian|fight_remains<5)
            if
                A.CracklingJadeLightning:IsReady(unit) and
                    (Unit(player):HasBuffsStacks(A.EmperorsCapacitorStack.ID, true) > 19 and
                        Player:EnergyTimeToMaxPredicted() > (Unit("target"):TimeToDieX(15) - 1) and
                        (A.RisingSunKick:GetCooldown() > Unit("target"):TimeToDieX(15))) or
                    (Unit(player):HasBuffsStacks(A.EmperorsCapacitorStack.ID, true) > 19 and
                        ((A.Serenity:GetCooldown() < 5 and A.Serenity:IsTalentLearned()) or
                            (A.WeaponsofOrder:GetCooldown() < 5 and C_Covenants.GetActiveCovenantID() == 1) or
                            (Player:AreaTTD() < 5)))
             then
                return A.CracklingJadeLightning:Show(icon)
            end

            --actions.st+=/rushing_jade_wind,if=buff.rushing_jade_wind.down&active_enemies>1
            if
                A.RushingJadeWind:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    Unit(player):HasBuffs(A.RushingJadeWind.ID, true) == 0 and
                    MultiUnits:GetByRange(10, 2) > 1
             then
                return A.RushingJadeWind:Show(icon)
            end

            --actions.st+=/fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
            if A.FistoftheWhiteTiger:IsReady(unit) and Player:Chi() < 3 then
                return A.FistoftheWhiteTiger:Show(icon)
            end

            --actions.st+=/expel_harm,if=chi.max-chi>=1
            if A.ExpelHarm:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and Player:ChiDeficit() >= 1 then
                return A.ExpelHarm:Show(icon)
            end

            --actions.st+=/chi_burst,if=chi.max-chi>=1&active_enemies=1&raid_event.adds.in>20|chi.max-chi>=2&active_enemies>=2
            if
                A.ChiBurst:IsReady(player) and
                    ((Player:ChiDeficit() >= 1 and MultiUnits:GetByRange(10, 3) == 1) or
                        (Player:ChiDeficit() >= 2 and MultiUnits:GetByRange(10, 3) >= 2)) and
                    not IsMoving
             then
                return A.ChiBurst:Show(icon)
            end

            --actions.st+=/chi_wave
            if A.ChiWave:IsReady(unit) then
                return A.ChiWave:Show(icon)
            end

            --actions.st+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2&buff.storm_earth_and_fire.down
            if
                A.TigerPalm:IsReady(unit) and ComboStrike(A.TigerPalm) and Player:ChiDeficit() >= 2 and
                    Unit("player"):HasBuffs(A.StormEarthAndFire.ID, true) == 0
             then
                return A.TigerPalm:Show(icon)
            end

            --actions.st+=/spinning_crane_kick,if=buff.chi_energy.stack>30-5*active_enemies&buff.storm_earth_and_fire.down&(cooldown.rising_sun_kick.remains>2&cooldown.fists_of_fury.remains>2|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>3|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>4|chi.max-chi<=1&energy.time_to_max<2)|buff.chi_energy.stack>10&fight_remains<7
            if
                A.SpinningCraneKick:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                    ComboStrike(A.SpinningCraneKick) and
                    (Unit(player):HasBuffsStacks(A.ChiEnergy.ID, true) > (30 - (5 * (MultiUnits:GetByRange(10, 6)))) and
                        Unit(player):HasBuffs(A.StormEarthandFire.ID, true) == 0 and
                        ((A.RisingSunKick:GetCooldown() > 2 and A.FistsofFury:GetCooldown() > 2) or
                            (A.RisingSunKick:GetCooldown() < 3 and A.FistsofFury:GetCooldown() > 3 and Player:Chi() > 3) or
                            (A.RisingSunKick:GetCooldown() > 3 and A.FistsofFury:GetCooldown() < 3 and Player:Chi() > 4) or
                            (Player:ChiDeficit() <= 1 and Player:EnergyTimeToMaxPredicted() < 2)) or
                        (Unit(player):HasBuffsStacks(A.ChiEnergy.ID, true) > 10 and Player:AreaTTD(10) < 7))
             then
                return A.SpinningCraneKick:Show(icon)
            end

            --actions.st+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&(talent.serenity&cooldown.serenity.remains<3|cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>1|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>2|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>3|chi>5|buff.bok_proc.up)
            if
                A.BlackoutKick:IsReady(unit) and ComboStrike(A.BlackoutKick) and
                    ((A.Serenity:IsTalentLearned() and A.Serenity:GetCooldown() < 3) or
                        (A.RisingSunKick:GetCooldown() > 1 and A.FistsofFury:GetCooldown() > 1) or
                        (A.RisingSunKick:GetCooldown() < 3 and A.FistsofFury:GetCooldown() > 3 and Player:Chi() > 2) or
                        (A.RisingSunKick:GetCooldown() > 3 and A.FistsofFury:GetCooldown() < 3 and Player:Chi() > 3) or
                        (Player:Chi() > 5) or
                        (Unit("player"):HasBuffs(A.BlackoutKickBuff.ID, true) > 0))
             then
                return A.BlackoutKick:Show(icon)
            end

            --actions.st+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2
            if A.TigerPalm:IsReady(unit) and ComboStrike(A.TigerPalm) and Player:ChiDeficit() >= 2 then
                return A.TigerPalm:Show(icon)
            end

            --actions.st+=/flying_serpent_kick,interrupt=1
            if
                A.FlyingSerpentKick:IsReady(player) and Action.GetToggle(2, "ToggleFlying") and not isMoving and
                    LoC:Get("ROOT") == 0 and
                    Unit("target"):GetRange() <= 8 and
                    A.FlyingSerpentKick:AbsentImun(target, GetAttackType()) and
                    Unit(player):HasBuffs(A.BlackoutKickBuff.ID, true) == 0 and
                    (not A.IsInPvP or not EnemyTeam("HEALER"):IsBreakAble(25))
             then
                return A.FlyingSerpentKick:Show(icon)
            end

            -- Cancel for FoF with SEF and Weapons
            if A.FlyingSerpentKick:GetSpellTimeSinceLastCast() < 0.5 and Action.GetToggle(2, "ToggleFlying") then
                return A.FlyingSerpentKickJump:Show(icon)
            end

            --actions.st+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&cooldown.fists_of_fury.remains<3&chi=2&prev_gcd.1.tiger_palm&energy.time_to_50<1
            if
                A.BlackoutKick:IsReady(unit) and ComboStrike(A.BlackoutKick) and A.FistsofFury:GetCooldown() < 3 and
                    Player:Chi() == 2 and
                    Player:PrevGCD(1, A.TigerPalm) and
                    Player:EnergyTimeToX(50) < 1
             then
                return A.BlackoutKick:Show(icon)
            end

            --actions.st+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&energy.time_to_max<2&(chi.max-chi<=1|prev_gcd.1.tiger_palm)
            if
                A.BlackoutKick:IsReady(unit) and ComboStrike(A.BlackoutKick) and Player:EnergyTimeToMaxPredicted() < 2 and
                    (Player:ChiDeficit() <= 1 or Player:PrevGCD(1, A.TigerPalm))
             then
                return A.BlackoutKick:Show(icon)
            end
        end

        --#####################
        --###### GENERIC ######
        --#####################

        --actions=auto_attack

        --actions+=/spear_hand_strike,if=target.debuff.casting.react
        local Interrupt = Interrupts(unit)
        if Interrupt then
            return Interrupt:Show(icon)
        end

        --actions+=/potion,if=(buff.serenity.up|buff.storm_earth_and_fire.up)&pet.xuen_the_white_tiger.active|fight_remains<=60
        --if A.PotionofSpectralAgility:IsReady(player) and Action.GetToggle(1, "Potion") and IsItemInRange(32321) and ((Unit(player):HasBuffs(A.Serenity.ID, true) > 0 or Unit(player):HasBuffs(A.StormEarthandFire.ID, true) > 0) and (A.InvokeXuen:GetSpellTimeSinceLastCast() < 24 or Player:AreaTTD(10) <= 60))
        --then
        -- Notification
        --    A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofSpectralAgility.ID)
        --    return A.PotionofSpectralAgility:Show(icon)
        --end
        --actions+=/call_action_list,name=serenity,if=buff.serenity.up
        if Unit("player"):HasBuffs(A.Serenity.ID, true) > 0 and SerenityRotation() then
            return true
        end

        --actions+=/call_action_list,name=weapons_of_order,if=buff.weapons_of_order.up
        if Unit("player"):HasBuffs(A.WeaponsofOrder.ID, true) > 0 and WeaponsRotation() then
            return true
        end

        --actions+=/call_action_list,name=opener,if=time<4&chi<5&!pet.xuen_the_white_tiger.active
        if
            Unit(player):CombatTime() < 4 and Player:Chi() < 5 and A.InvokeXuen:GetSpellTimeSinceLastCast() > 24 and
                OpenerRotation()
         then
            return true
        end

        --actions+=/fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3&(energy.time_to_max<1|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5|cooldown.weapons_of_order.remains<2)
        if
            A.FistoftheWhiteTiger:IsReady(unit) and Player:ChiDeficit() >= 3 and
                (Player:EnergyTimeToMaxPredicted() < 1 or
                    (Player:EnergyTimeToMaxPredicted() < 4 and A.FistsofFury:GetCooldown() < 1.5) or
                    (A.WeaponsofOrder:GetCooldown() < 2))
         then
            return A.FistoftheWhiteTiger:Show(icon)
        end

        --actions+=/expel_harm,if=chi.max-chi>=1&(energy.time_to_max<1|cooldown.serenity.remains<2|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5|cooldown.weapons_of_order.remains<2)
        if
            A.ExpelHarm:IsReady(player) and (inMelee or Unit("target"):GetRange() <= 8) and
                (Player:ChiDeficit() >= 1 and
                    (Player:EnergyTimeToMaxPredicted() < 1 or
                        (A.Serenity:GetCooldown() < 2 and A.Serenity:IsTalentLearned()) or
                        (Player:EnergyTimeToMaxPredicted() < 4 and A.FistsofFury:GetCooldown() < 1.5) or
                        A.WeaponsofOrder:GetCooldown() < 2))
         then
            return A.ExpelHarm:Show(icon)
        end

        --actions+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&chi.max-chi>=2&(energy.time_to_max<1|cooldown.serenity.remains<2|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5|cooldown.weapons_of_order.remains<2)
        if
            A.TigerPalm:IsReady(unit) and ComboStrike(A.TigerPalm) and Player:ChiDeficit() >= 2 and
                (Player:EnergyTimeToMaxPredicted() < 1 or
                    (A.Serenity:GetCooldown() < 2 and A.Serenity:IsTalentLearned()) or
                    (Player:EnergyTimeToMaxPredicted() < 4 and A.FistsofFury:GetCooldown() < 1.5) or
                    (A.WeaponsofOrder:GetCooldown() < 2))
         then
            return A.TigerPalm:Show(icon)
        end

        --actions+=/call_action_list,name=cd_sef,if=!talent.serenity
        if A.BurstIsON(unit) and not A.Serenity:IsTalentLearned() and Cooldownsef() then
            return true
        end

        --actions+=/call_action_list,name=cd_serenity,if=talent.serenity
        if A.BurstIsON(unit) and A.Serenity:IsTalentLearned() and CooldownSerenity() then
            return true
        end

        --actions+=/call_action_list,name=st,if=active_enemies<3
        if MultiUnits:GetByRange(10, 3) < 3 and STRotation() then
            return true
        end

        --actions+=/call_action_list,name=aoe,if=active_enemies>=3
        if MultiUnits:GetByRange(10, 3) >= 3 and AoERotation() then
            return true
        end
    end
    --Finished Enemy Rotation
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then
        return SelfDefensive:Show(icon)
    end

    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unit = "mouseover"
        if EnemyRotation(unit) then
            return true
        end
    end

    -- Target
    if A.IsUnitEnemy("target") then
        unit = "target"
        if EnemyRotation(unit) then
            return true
        end
    end
end

--Finished
