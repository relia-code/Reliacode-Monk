--- Modified version of Aya's Monk
--- https://github.com/AyaProfiles/Aya-Monk
local _G, select, setmetatable = _G, select, setmetatable

local TMW = _G.TMW

local A = _G.Action
local CONST = A.Const
local toNum = A.toNum
local Print = A.Print
local GetSpellInfo = A.GetSpellInfo
local GetToggle = A.GetToggle
local GetLatency = A.GetLatency
local InterruptIsValid = A.InterruptIsValid
local Unit = A.Unit

local ACTION_CONST_MONK_BREWMASTER = CONST.MONK_BREWMASTER
local ACTION_CONST_MONK_MISTWEAVER = CONST.MONK_MISTWEAVER
local ACTION_CONST_MONK_WINDWALKER = CONST.MONK_WINDWALKER

local S = {
    PurifyingBrew = (GetSpellInfo(119582)),
    ZenMeditation = (GetSpellInfo(115176)),
    CelestialBrew = (GetSpellInfo(322507)),
    HealingElixir = (GetSpellInfo(122281)),
    Stoneform = (GetSpellInfo(20594)),
    DampenHarm = (GetSpellInfo(122278)),
    FortifyingBrew = (GetSpellInfo(115203)),
    DiffuseMagic = (GetSpellInfo(122783)),
    RenewingMist = (GetSpellInfo(115151)),
    SoothingMist = (GetSpellInfo(115175)),
    LifeCocoon = (GetSpellInfo(116849)),
    SpinningCraneKick = (GetSpellInfo(101546)),
    RisingSunKick = (GetSpellInfo(107428)),
    RenewingMist = (GetSpellInfo(115151)),
    EnvelopingMist = (GetSpellInfo(124682)),
    SurgingMist = (GetSpellInfo(227344)),
    Vivify = (GetSpellInfo(116670)),
    EssenceFont = (GetSpellInfo(191837)),
    Revival = (GetSpellInfo(115310)),
    ThunderFocusTea = (GetSpellInfo(116680)),
    ZenFocusTea = (GetSpellInfo(209584)),
    RefreshingJadeWind = (GetSpellInfo(196725)),
    HealingSphere = (GetSpellInfo(205234)),
    Paralysis = (GetSpellInfo(115078)),
    GrappleWeapon = (GetSpellInfo(233759)),
    ReverseHarm = (GetSpellInfo(287771)),
    TouchofKarma = (GetSpellInfo(122470)),
    TouchofDeath = (GetSpellInfo(115080)),
    StormEarthAndFire = (GetSpellInfo(137639)),
    SolarBeam = (GetSpellInfo(78675)),
    FlyingSerpentKick = (GetSpellInfo(101545)),
    LegSweep = (GetSpellInfo(119381))
}

local L = {}
L.AUTO = {
    enUS = "Auto",
    ruRU = "Авто "
}
L.OFF = {
    enUS = "Off",
    ruRU = "Выкл."
}
L.PVP = {
    ANY = "PvP"
}
L.SHOULDPURIFY = {
    ANY = S.PurifyingBrew
}
L.PURIFYINGBREW = {
    enUS = S.PurifyingBrew .. " Level",
    ruRU = S.PurifyingBrew .. " Уровень"
}
L.PURIFYINGBREWTT = {
    enUS = "Stagger level on which need\
'" ..
        S.PurifyingBrew .. "' (5 super high, 1 very low)\
\
Right click: Create macro",
    ruRU = "Уровень пошатывания на котором\
нужно '" ..
        S.PurifyingBrew .. "' (5 супер много, 1 очень мало)\
\
Правая кнопка мышки: Создать макрос"
}
L.SHOULDPURIFY_LEVEL2 = {
    enUS = "Level 2",
    ruRU = "Уровень 2"
}
L.SHOULDPURIFY_LEVEL3 = {
    enUS = "Level 3",
    ruRU = "Уровень 3"
}
L.SHOULDPURIFY_LEVEL4 = {
    enUS = "Level 4",
    ruRU = "Уровень 4"
}
L.SHOULDPURIFY_LEVEL5 = {
    enUS = "Level 5",
    ruRU = "Уровень 5"
}
L.ZENMEDITATION = {
    enUS = S.ZenMeditation .. "\
Health Percent",
    ruRU = S.ZenMeditation .. "\
Процент Здоровья"
}
L.CelestialBrew = {
    enUS = S.CelestialBrew .. "\
Health Percent",
    ruRU = S.CelestialBrew .. "\
Процент Здоровья"
}
L.ADDITIONALTAUNT = {
    enUS = "Additional Taunt",
    ruRU = "Дополнительный Таунт"
}
L.ADDITIONALTAUNT_INVOKENIUZAOTHEBLACKOX = {
    enUS = "Invoke Niuzao the BlackOx",
    ruRU = "Призыв Нюцзао, Черного Быка"
}
L.ADDITIONALTAUNT_SUMMONBLACKOXSTATUE = {
    enUS = "Summon BlackOx Statue",
    ruRU = "Призыв статуи Черного Быка"
}
L.ADDITIONALTAUNT_PROVOKEONBLACKOXSTATUE = {
    enUS = "'Provoke' On BlackOx Statue",
    ruRU = "'Вызов' на статую Черного Быка"
}
L.MOUSEOVER = {
    enUS = "Use\
@mouseover",
    ruRU = "Использовать\
@mouseover"
}
L.MOUSEOVERTT = {
    enUS = "Will unlock use actions for @mouseover units\
Example: Resuscitate, Healing\
\
Right click: Create macro",
    ruRU = "Разблокирует использование действий для @mouseover юнитов\
Например: Воскрешение, Хилинг\
\
Правая кнопка мышки: Создать макрос"
}
L.FOCUSTARGET = {
    enUS = "Use\
@focustarget",
    ruRU = "Использовать\
@focustarget"
}
L.FOCUSTARGETTT = {
    enUS = "Will unlock use actions\
for enemy @focustarget units\
\
Right click: Create macro",
    ruRU = "Разблокирует использование\
действий для вражеских @focustarget юнитов\
\
Правая кнопка мышки: Создать макрос"
}
L.TARGETTARGET = {
    enUS = "Use\
@targettarget",
    ruRU = "Использовать\
@targettarget"
}
L.TARGETTARGETTT = {
    enUS = "Will unlock use actions\
for enemy @targettarget units\
\
Right click: Create macro",
    ruRU = "Разблокирует использование\
действий для вражеских @targettarget юнитов\
\
Правая кнопка мышки: Создать макрос"
}
L.AOE = {
    enUS = "Use\
AoE",
    ruRU = "Использовать\
AoE"
}
L.AOETT = {
    enUS = "Enable multiunits rotation\
\
Right click: Create macro",
    ruRU = "Включает ротацию для нескольких целей\
\
Правая кнопка мышки: Создать макрос"
}
L.DEFENSIVE = {
    enUS = "Self Defensive",
    ruRU = "Своя Оборона"
}
L.HEALINGELIXIR = {
    enUS = S.HealingElixir .. "\
Health Percent",
    ruRU = S.HealingElixir .. "\
Процент Здоровья"
}
L.STONEFORM = {
    enUS = S.Stoneform .. "\
Health Percent",
    ruRU = S.Stoneform .. "\
Процент Здоровья"
}
L.DAMPENHARM = {
    enUS = S.DampenHarm .. "\
Health Percent",
    ruRU = S.DampenHarm .. "\
Процент Здоровья"
}
L.FORTIFYINGBREW = {
    enUS = S.FortifyingBrew .. "\
Health Percent",
    ruRU = S.FortifyingBrew .. "\
Процент Здоровья"
}
L.DIFFUSEMAGIC = {
    enUS = S.DiffuseMagic .. "\
Health Percent",
    ruRU = S.DiffuseMagic .. "\
Процент Здоровья"
}
L.MANA_POTION = {
    enUS = "Mana Potion\
Mana Percent",
    ruRU = "Мана Зелье\
Процент Маны"
}
L.HEALINGSYSTEM = {
    enUS = "Healing System",
    ruRU = "Система Исцеления"
}
L.HEALINGENGINEAUTOHOT = {
    enUS = "Auto HoTs",
    ruRU = "Авто ХоТы"
}
L.HEALINGENGINEAUTOHOTTT = {
    enUS = "Will select in @target a member\
which hasn't applied '" ..
        S.RenewingMist .. "'\
\
Right click: Create macro",
    ruRU = "Будет выбирать в @target участника\
который не имеет наложенного '" ..
        S.RenewingMist .. "'\
\
Правая кнопка мышки: Создать макрос"
}
L.HEALINGENGINEPREVENTSUGGEST = {
    enUS = S.SoothingMist .. "\
Next @target - Difference HP",
    ruRU = S.SoothingMist .. "\
След. @target - Разница ХП"
}
L.HEALINGENGINEPREVENTSUGGESTTT = {
    enUS = "If " ..
        S.SoothingMist ..
            "' is channeling,\
then before choosing a new @target condition will be checked,\
that difference in health percent between current unit and next unit >= value of slider\
If condition is true, then next @target will be selected, otherwise we will continue healing current unit\
\
Condition will skip if next unit require dispel or utils\
\
Right click: Create macro",
    ruRU = "Если '" ..
        S.SoothingMist ..
            "' произносится,\
то прежде чем выбрать новый @target будет проверяться условие,\
что разница в процентах здоровья между текущим юнитом и след. юнитом >= значению ползунка\
Если условие соблюдено, то след. @target будет выбран, в ином случае мы продолжаем исцеление текущего юнита\
\
Условие будет пропускаться если след. юнит требует диспела или утилит\
\
Правая кнопка мышки: Создать макрос"
}
L.ROTATION = {
    enUS = "Rotation",
    ruRU = "Ротация"
}
L.EMERGENCYSINGLEROTATION = {
    enUS = "Emergency Single Rotation",
    ruRU = "Экстренная Одиноч. Ротация"
}
L.EMERGENCYSINGLEROTATIONTT = {
    enUS = "Changes priority of rotation if unit is in an emergency\
Emergency rotation has own logic, nor depended by settings below!\
\
Right click: Create macro",
    ruRU = "Меняет приоритет ротации если юнит находится в критическом положении\
Экстренная ротация имеет свою логику, не зависящая от настроек ниже!\
\
Правая кнопка мышки: Создать макрос"
}
L.MAINTAINSTATUECAST = {
    enUS = "Jade Serpent Statue\
Maintain Cast",
    ruRU = "Статуя Нефритовой Змеи\
Поддерживать Произнесение"
}
L.MAINTAINSTATUECASTTT = {
    enUS = "PvP: Prioritization by most inc. damage\
PvE: Prioritization by active tank\
\
Right click: Create macro",
    ruRU = "PvP: Приоритезация по наиболее вход. урону\
PvE: Приоритезация по активному танку\
\
Правая кнопка мышки: Создать макрос"
}
L.LIFECOCOON = {
    enUS = S.LifeCocoon .. " - Health Percent",
    ruRU = S.LifeCocoon .. " - Процент Здоровья"
}
L.THUNDERFOCUSTEAOPTIONS = {
    enUS = S.ThunderFocusTea .. "\
Options",
    ruRU = S.ThunderFocusTea .. "\
Опции"
}
L.THUNDERFOCUSTEAOPTIONS_VIVIFY_MANA_SAVE = {
    enUS = S.Vivify .. " (On Mana Save)",
    ruRU = S.Vivify .. " (На Сохр. Маны)"
}
L.THUNDERFOCUSTEAOPTIONS_VIVIFY_ON_CD = {
    enUS = S.Vivify .. " (On CD)",
    ruRU = S.Vivify .. " (По КД)"
}
L.ZENFOCUSTEAOPTIONS = {
    enUS = S.ZenFocusTea .. "\
Options",
    ruRU = S.ZenFocusTea .. "\
Опции"
}
L.ZENFOCUSTEAOPTIONS_ROOTED = {
    enUS = "While rooted to catch " .. S.SolarBeam,
    ruRU = "Пока в рутах, чтобы поймать " .. S.SolarBeam
}
L.SOOTHINGMIST_STOPCAST_OPTIONS_PRIMARY = {
    enUS = "/stopcasting - @primary unit changed",
    ruRU = "/stopcasting - @главный юнит сменился"
}
L.SOOTHINGMIST_STOPCAST_OPTIONS_MAXHP = {
    enUS = "/stopcasting - @primary unit at full health",
    ruRU = "/stopcasting - @главный юнит на полном здоровье"
}
L.SOOTHINGMIST_STOPCAST_OPTIONS = {
    enUS = S.SoothingMist .. "\
Options",
    ruRU = S.SoothingMist .. "\
Опции"
}
L.SOOTHINGMIST_STOPCAST_OPTIONSTT = {
    enUS = "/stopcasting options works if 'Stop Cast' is enabled in 'General' tab\
\
Right click: Create macro",
    ruRU = "/stopcasting опции работают если 'Стоп Каст' включен в вкладке 'Общее'\
\
Правая кнопка мышки: Создать макрос"
}
L.SOOTHINGMIST_WORKOPTIONS_ANY = {
    enUS = "Any Units",
    ruRU = "Любые Юниты"
}
L.SOOTHINGMIST_WORKOPTIONS_TANKING = {
    enUS = "Tanking Units",
    ruRU = "Танкующие Юниты"
}
L.SOOTHINGMIST_WORKOPTIONS_FOCUSED = {
    enUS = "Focused Units (PvP)",
    ruRU = "Нацеленные Юниты (PvP)"
}
L.SOOTHINGMIST_WORKOPTIONS_MOSTINC = {
    enUS = "Mostly Inc. Damage Units",
    ruRU = "Наибол. Вход. Урон Юниты"
}
L.SOOTHINGMIST_WORKOPTIONS_HPSINCDMG = {
    enUS = "HPS Deficit Units",
    ruRU = "ХПС Дефицит Юниты"
}
L.SOOTHINGMIST_WORKOPTIONS = {
    enUS = S.SoothingMist .. " (filler)\
Work Mode",
    ruRU = S.SoothingMist .. " (филлер)\
Режим Работы"
}
L.SOOTHINGMISTHP = {
    enUS = S.SoothingMist .. " (filler)\
Health Percent",
    ruRU = S.SoothingMist .. " (филлер)\
Процент Здоровья"
}
L.SOOTHINGMISTHPTT = {
    enUS = "Health Percent on which casting '" .. S.SoothingMist .. "' (as filler!)\
\
Right click: Create macro",
    ruRU = "Процент Здоровья на котором произносить '" ..
        S.SoothingMist .. "' (как филлер!)\
\
Правая кнопка мышки: Создать макрос"
}
L.LIMITTT = {
    enUS = "The limit means that the ability only works when <= values\
This is only a limit so as not to go above the value, not a fixed condition!\
\
Right click: Create macro",
    ruRU = "Лимит означает, что способность работает только когда <= значения\
Это только лимит, чтобы не идти выше значения, а не фиксированное условие!\
\
Правая кнопка мышки: Создать макрос"
}
L.VIVIFYHP = {
    enUS = S.Vivify .. " (limit)\
Health Percent",
    ruRU = S.Vivify .. " (лимит)\
Процент Здоровья"
}
L.SURGINGMISTHP = {
    enUS = S.SurgingMist .. " (limit)\
Health Percent",
    ruRU = S.SurgingMist .. " (лимит)\
Процент Здоровья"
}
L.ENVELOPINGMISTHP = {
    enUS = S.EnvelopingMist .. " (limit)\
Health Percent",
    ruRU = S.EnvelopingMist .. " (лимит)\
Процент Здоровья"
}
L.REVIVALDISPELUNITS = {
    enUS = S.Revival .. "\
Mass Dispel Units",
    ruRU = S.Revival .. "\
Масс Диспел Юнитов"
}
L.REVIVALDISPELUNITSTT = {
    enUS = "Count of units which must be dispeled at same time\
Can not be higher than maximum of select able members\
\
Right click: Create macro",
    ruRU = "Кол-во юнитов, которые должны быть задиспелены сразу\
Не может быть выше чем максимум доступных по выбору участников\
\
Правая кнопка мышки: Создать макрос"
}
L.EACHUNITTT = {
    enUS = "Health in percent per each unit <= value\
\
Right click: Create macro",
    ruRU = "Здоровье в процентах по каждому юниту <= значение\
\
Правая кнопка мышки: Создать макрос"
}
L.TOTALUNITSTT = {
    enUS = "Total number of units\
\
Right click: Create macro",
    ruRU = "Суммарное количество юнитов\
\
Правая кнопка мышки: Создать макрос"
}
L.REVIVALHP = {
    enUS = S.Revival .. "\
Each Unit HP",
    ruRU = S.Revival .. "\
Каждый Юнит ХП"
}
L.REVIVALUNITS = {
    enUS = S.Revival .. "\
Total Units",
    ruRU = S.Revival .. "\
Кол-во Юнитов"
}
L.ESSENCEFONTHP = {
    enUS = S.EssenceFont .. "\
Each Unit HP",
    ruRU = S.EssenceFont .. "\
Каждый Юнит ХП"
}
L.ESSENCEFONTUNITS = {
    enUS = S.EssenceFont .. "\
Total Units",
    ruRU = S.EssenceFont .. "\
Кол-во Юнитов"
}
L.REFRESHINGJADEWINDHP = {
    enUS = S.RefreshingJadeWind .. "\
Each Unit HP",
    ruRU = S.RefreshingJadeWind .. "\
Каждый Юнит ХП"
}
L.REFRESHINGJADEWINDUNITS = {
    enUS = S.RefreshingJadeWind .. "\
Total Units",
    ruRU = S.RefreshingJadeWind .. "\
Кол-во Юнитов"
}
L.BURSTTT = {
    enUS = "The percentage of enemy health on which to use actions\
\
Right click: Create macro",
    ruRU = "Процент здоровья противника на котором использовать действия\
\
Правая кнопка мышки: Создать макрос"
}
L.BURSTHEALINGRACIAL = {
    enUS = "Racial Burst Heal\
Health Percent",
    ruRU = "Расовая Бурст Исцел.\
Процент Здоровья"
}
L.BURSTDAMAGE = {
    enUS = "Burst Damage\
Health Percent",
    ruRU = "Бурст Урон\
Процент Здоровья"
}
L.BURSTHEALINGTRINKETS = {
    enUS = "Heal Trinkets\
Health Percent",
    ruRU = "Исцел. Акссесуары\
Процент Здоровья"
}
L.BURSTDAMAGETRINKETS = {
    enUS = "Damage Trinkets\
Health Percent",
    ruRU = "Урон Акссесуары\
Процент Здоровья"
}
L.MOUSEBUTTONSCHECK = {
    enUS = S.HealingSphere .. "\
Check Mouse Buttons",
    ruRU = S.HealingSphere .. "\
Проверять Кнопки Мышки"
}
L.MOUSEBUTTONSCHECKTT = {
    enUS = "Prevents use if the camera is currently spinning with the mouse button held down\
\
Right click: Create macro",
    ruRU = "Предотвращает использование если камера в текущий момент крутится с помощью зажатой кнопки мыши\
\
Правая кнопка мышки: Создать макрос"
}
L.PARALYSISPVP = {
    ANY = "PvP " .. S.Paralysis
}
L.PARALYSISPVPTT = {
    enUS = "@arena1-3 interrupt PvP list from 'Interrupts' tab by Paralysis\
More custom config you can find in group by open /tmw\
\
Right click: Create macro",
    ruRU = "@arena1-3 прерывание Параличом PvP списка из вкладки 'Прерывания'\
Больше кастомизации вы найдете в группе открыв /tmw\
\
Правая кнопка мышки: Создать макрос"
}
L.PARALYSISPVP_ONLYHEAL = {
    enUS = "Only Heal Casts",
    ruRU = "Только Исцел. Заклинания"
}
L.PARALYSISPVP_ONLYPVP = {
    enUS = "Only PvP Casts",
    ruRU = "Только PvP Заклинания"
}
L.PARALYSISPVP_BOTH = {
    enUS = "Heal + PvP Casts",
    ruRU = "Исцел. + PvP Заклинания"
}
L.GRAPPLEWEAPONPVP = {
    enUS = "PvP " .. S.GrappleWeapon .. "\
Triggers",
    ruRU = "PvP " .. S.GrappleWeapon .. "\
Триггеры"
}
L.GRAPPLEWEAPONPVPTT = {
    enUS = "@arena1-3, @target, @mouseover, @targettarget\
ON MELEE BURST - Only if melee player has damage buffs\
ON COOLDOWN - means will use always on melee players\
OFF - Cut out from rotation but still allow work through Queue and MSG systems\
If you want fully turn it OFF then you should make SetBlocker in 'Actions' tab\
\
Right click: Create macro",
    ruRU = "@arena1-3, @target, @mouseover, @targettarget\
ON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\
ON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\
OFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\
Если нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'\
\
Правая кнопка мышки: Создать макрос"
}
L.GRAPPLEWEAPONPVP_MELEEBURST = {
    enUS = "On melee burst",
    ruRU = "На бурст ближ. боя"
}
L.GRAPPLEWEAPONPVP_ONCD = {
    enUS = "On cooldown",
    ruRU = "По восстановлению"
}
L.GRAPPLEWEAPONPVPUNITS = {
    enUS = "PvP " .. S.GrappleWeapon .. "\
Destinations",
    ruRU = "PvP " .. S.GrappleWeapon .. "\
Цели"
}
L.GRAPPLEWEAPONPVPUNITSTT = {
    enUS = "@primary - is @target, @mouseover, @focustarget, @targettarget (these units are depend on toggles above)\
\
Right click: Create macro",
    ruRU = "@primary - это @target, @mouseover, @focustarget, @targettarget (эти юниты зависят от чекбоксов наверху)\
\
Правая кнопка мышки: Создать макрос"
}
L.CATCHINVISIBLE = {
    enUS = "Catch Invisible (arena)",
    ruRU = "Поймать Невидимок (арена)"
}
L.CATCHINVISIBLETT = {
    enUS = "Cast " ..
        S.SpinningCraneKick ..
            " when combat around has been begin and enemy team still has unit in invisible\
Doesn't work if you're mounted or in combat!\
\
Right click: Create macro",
    ruRU = "Применять " ..
        S.SpinningCraneKick ..
            " когда бой поблизости начат и команда противника до сих пор имеет юнита в невидимости\
Не работает, когда вы на транспорте или в бою!\
\
Правая кнопка мышки: Создать макрос"
}
L.PARTY = {
    enUS = "Party",
    ruRU = "Группа"
}
L.PARTYUNITS = {
    enUS = "Party Units",
    ruRU = "Юниты Группы"
}
L.PARTYUNITSTT = {
    enUS = "Enable/Disable relative party passive rotation\
\
Right click: Create macro",
    ruRU = "Включить/Выключить относительно группы пассивную ротацию\
\
Правая кнопка мышки: Создать макрос"
}
L.TOUCHOFKARMA = {
    enUS = S.TouchofKarma .. "\
Health Percent (Self)",
    ruRU = S.TouchofKarma .. "\
Здоровье Процент (Свое)"
}
L.TRINKETDEFENSIVE = {
    enUS = "Protection Trinkets\
Health Percent (Self)",
    ruRU = "Аксессуары Защиты\
Здоровье Процент (Свое)"
}
L.REVERSEHARM = {
    enUS = S.ReverseHarm .. "\
Health Percent (Self)",
    ruRU = S.ReverseHarm .. "\
Здоровье Процент (Свое)"
}
L.SEFOUTBURST = {
    enUS = "PvE SEF \
Out of Burst",
    ruRU = "PvE " .. S.StormEarthAndFire .. "\
Вне Бурста"
}
L.SEFOUTBURSTTT = {
    enUS = "PvE: Enable this setting to allow you\
to use SEF outside 'Burst Mode' conditions\
at 2+ charges or between '" ..
        S.TouchofDeath .. "'\
\
Right click: Create macro",
    ruRU = "PvE: Включенная настройка позволит вам\
использовать " ..
        S.StormEarthAndFire ..
            " вне условий 'Режима Бурстов'\
на 2+ зарядах или между '" ..
                S.TouchofDeath .. "'\
\
Правая кнопка мышки: Создать макрос"
}
L.TOGGLEFLYING = {
    enUS = " " .. S.FlyingSerpentKick .. "\\ for DPS"
}
L.TOGGLEFLYINGTT = {
    enUS = "PvE: Enable this setting to allow you\
to use " ..
        S.FlyingSerpentKick .. " for DPS\
\
Right click: Create macro"
}
L.InterruptList = {
    enUS = "Use Ryan's M+ Interrupt List"
}
L.InterruptListTT = {
    enUS = "Check to use Ryan's M+ list. Uncheck to use default list."
}
L.ParalysisInterrupt = {
    enUS = "Use " .. S.Paralysis .. " to Interrupt"
}
L.ParalysisInterruptTT = {
    enUS = "Use " .. S.Paralysis .. "  CC to interrupt"
}
L.LegSweepInterrupt = {
    enUS = "Use " .. S.LegSweep .. "  to Interrupt"
}
L.LegSweepInterruptTT = {
    enUS = "Use " .. S.LegSweep .. "  CC to interrupt"
}
L.ExplosiveMouseover = {
    enUS = "Auto Target/Kill Explosives"
}
L.ExplosiveMouseoverTT = {
    enUS = "Auto Target/Kill Explosives using /target mouseover"
}

local SliderMarginOptions = {margin = {top = 10}}
local LayoutConfigOptions = {gutter = 4, padding = {left = 5, right = 5}}
A.Data.ProfileEnabled[A.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "v16 (27.07.2020)",
    [2] = {
        [ACTION_CONST_MONK_BREWMASTER] = {
            LayoutOptions = LayoutConfigOptions,
            {
                -- [1]
                {
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER,
                    TT = L.MOUSEOVERTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ExplosiveMouseover",
                    DBV = true,
                    L = L.ExplosiveMouseover,
                    TT = L.ExplosiveMouseoverTT,
                    M = {}
                }
            },
            {
                -- [2]
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.SHOULDPURIFY_LEVEL2, value = 2},
                        {text = L.SHOULDPURIFY_LEVEL3, value = 3},
                        {text = L.SHOULDPURIFY_LEVEL4, value = 4},
                        {text = L.SHOULDPURIFY_LEVEL5, value = 5},
                        {text = L.AUTO, value = 0}
                    },
                    DB = "ShouldPurify",
                    DBV = 0,
                    L = L.PURIFYINGBREW,
                    TT = L.PURIFYINGBREWTT,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ZenMeditation",
                    DBV = 100,
                    ONOFF = true,
                    L = L.ZENMEDITATION,
                    M = {}
                }
            },
            {
                -- [3]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 85,
                    DB = "HealingElixir",
                    DBV = 85,
                    ONOFF = true,
                    L = L.HEALINGELIXIR,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "CelestialBrew",
                    DBV = 100,
                    ONOFF = true,
                    L = L.CelestialBrew,
                    M = {}
                }
            },
            {
                -- [4]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DampenHarm",
                    DBV = 100,
                    ONOFF = true,
                    L = L.DAMPENHARM,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FortifyingBrew",
                    DBV = 100,
                    ONOFF = true,
                    L = L.FORTIFYINGBREW,
                    M = {}
                }
            },
            {
                -- [5]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Stoneform",
                    DBV = 100,
                    ONOFF = true,
                    L = L.STONEFORM,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.ADDITIONALTAUNT_INVOKENIUZAOTHEBLACKOX, value = 1},
                        {text = L.ADDITIONALTAUNT_SUMMONBLACKOXSTATUE, value = 2},
                        {text = L.ADDITIONALTAUNT_PROVOKEONBLACKOXSTATUE, value = 3}
                    },
                    MULT = true,
                    DB = "AdditionalTaunt",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true
                    },
                    L = L.ADDITIONALTAUNT,
                    M = {}
                }
            },
            {
                -- [6] PvP
                {
                    E = "Header",
                    L = L.PVP
                }
            },
            {
                -- [7]
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.PARALYSISPVP_ONLYHEAL, value = "Heal"},
                        {text = L.PARALYSISPVP_ONLYPVP, value = "PvP"},
                        {text = L.PARALYSISPVP_BOTH, value = "BOTH"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "ParalysisPvP",
                    DBV = "BOTH",
                    L = L.PARALYSISPVP,
                    TT = L.PARALYSISPVPTT,
                    M = {}
                }
            }
        },
        [ACTION_CONST_MONK_WINDWALKER] = {
            LayoutOptions = LayoutConfigOptions,
            {
                -- [1]
                {
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER,
                    TT = L.MOUSEOVERTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "SEFOutBurst",
                    DBV = true,
                    L = L.SEFOUTBURST,
                    TT = L.SEFOUTBURSTTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ToggleFlying",
                    DBV = false,
                    L = L.TOGGLEFLYING,
                    TT = L.TOGGLEFLYINGTT,
                    M = {}
                }
            },
            {
                -- [1] Row 2
                {
                    E = "Checkbox",
                    DB = "InterruptsRyan",
                    DBV = true,
                    L = L.InterruptList,
                    TT = L.InterruptListTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ParalysisInterrupt",
                    DBV = true,
                    L = L.ParalysisInterrupt,
                    TT = L.ParalysisInterruptTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "LegSweepInterrupt",
                    DBV = true,
                    L = L.LegSweepInterrupt,
                    TT = L.LegSweepInterruptTT,
                    M = {}
                },
                {
                    E = "Checkbox",
                    DB = "ExplosiveMouseover",
                    DBV = true,
                    L = L.ExplosiveMouseover,
                    TT = L.ExplosiveMouseoverTT,
                    M = {}
                }
            },
            {
                -- [2] Self Defensives
                {
                    E = "Header",
                    L = L.DEFENSIVE
                }
            },
            {
                -- [3]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TouchofKarma",
                    DBV = 100,
                    ONOFF = true,
                    L = L.TOUCHOFKARMA,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Stoneform",
                    DBV = 100,
                    ONOFF = true,
                    L = L.STONEFORM,
                    M = {}
                }
            },
            {
                -- [4]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DampenHarm",
                    DBV = 100,
                    ONOFF = true,
                    L = L.DAMPENHARM,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FortifyingBrew",
                    DBV = 100,
                    ONOFF = true,
                    L = L.FORTIFYINGBREW,
                    M = {}
                }
            },
            {
                -- [5]
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DiffuseMagic",
                    DBV = 100,
                    ONOFF = true,
                    L = L.DIFFUSEMAGIC,
                    M = {}
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "TrinketDefensive",
                    DBV = 50,
                    ONOFF = false,
                    L = L.TRINKETDEFENSIVE,
                    M = {}
                }
            },
            {
                -- [6] Party
                {
                    E = "Header",
                    L = L.PARTY
                }
            },
            {
                -- [7]
                {
                    E = "Dropdown",
                    OT = {
                        {text = "@party1", value = 1},
                        {text = "@party2", value = 2}
                    },
                    MULT = true,
                    DB = "PartyUnits",
                    DBV = {
                        [1] = true,
                        [2] = true
                    },
                    L = L.PARTYUNITS,
                    TT = L.PARTYUNITSTT,
                    M = {}
                }
            },
            {
                -- [8] PvP
                {
                    E = "Header",
                    L = L.PVP
                }
            },
            {
                -- [9]
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "ReverseHarm",
                    DBV = 100,
                    ONLYON = true,
                    L = L.REVERSEHARM,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.PARALYSISPVP_ONLYHEAL, value = "Heal"},
                        {text = L.PARALYSISPVP_ONLYPVP, value = "PvP"},
                        {text = L.PARALYSISPVP_BOTH, value = "BOTH"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "ParalysisPvP",
                    DBV = "BOTH",
                    L = L.PARALYSISPVP,
                    TT = L.PARALYSISPVPTT,
                    M = {}
                }
            },
            {
                -- [10]
                RowOptions = SliderMarginOptions,
                {
                    E = "Dropdown",
                    OT = {
                        {text = L.GRAPPLEWEAPONPVP_MELEEBURST, value = "ON MELEE BURST"},
                        {text = L.GRAPPLEWEAPONPVP_ONCD, value = "ON COOLDOWN"},
                        {text = L.OFF, value = "OFF"}
                    },
                    DB = "GrappleWeaponPvP",
                    DBV = "ON MELEE BURST",
                    L = L.GRAPPLEWEAPONPVP,
                    TT = L.GRAPPLEWEAPONPVPTT,
                    M = {}
                },
                {
                    E = "Dropdown",
                    OT = {
                        {text = "@arena1", value = 1},
                        {text = "@arena2", value = 2},
                        {text = "@arena3", value = 3},
                        {text = "@primary", value = 4}
                    },
                    MULT = true,
                    DB = "GrappleWeaponPvPunits",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true
                    },
                    L = L.GRAPPLEWEAPONPVPUNITS,
                    TT = L.GRAPPLEWEAPONPVPUNITSTT,
                    M = {}
                }
            },
            {
                -- [11]
                {
                    E = "Checkbox",
                    DB = "CatchInvisible",
                    DBV = true,
                    L = L.CATCHINVISIBLE,
                    TT = L.CATCHINVISIBLETT,
                    M = {}
                }
            }
        }
    },
    [7] = {
        [ACTION_CONST_MONK_WINDWALKER] = {
            ["stun"] = {
                Enabled = true,
                Key = "LegSweep",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_WINDWALKER]
                return     A.LegSweep:IsReadyM(thisunit, true) and
                        (
                            not IsInPvP and
                            MultiUnits:GetByRange(5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0), 1) >= 1
                        ) or
                        (
                            IsInPvP and
                            EnemyTeam():PlayersInRange(1, 5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0))
                        )
            ]]
            },
            ["disarm"] = {
                Enabled = true,
                Key = "GrappleWeapon",
                LUAVER = 6,
                LUA = [[
                return     GrappleWeaponIsReady(thisunit, nil, true)
            ]]
            },
            ["kick"] = {
                Enabled = true,
                Key = "SpearHandStrike",
                LUAVER = 6,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_WINDWALKER]
                return     A.SpearHandStrike:IsReadyM(thisunit) and
                        A.SpearHandStrike:AbsentImun(thisunit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and
                        Unit(thisunit):IsCastingRemains() > 0
            ]]
            },
            ["freedom"] = {
                Enabled = true,
                Key = "TigersLust",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_WINDWALKER]
                return     A.TigersLust:IsReadyM(thisunit) and
                        A.TigersLust:AbsentImun(thisunit) and
                        LossOfControl:IsMissed("SILENCE") and
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]]
            },
            ["dispel"] = {
                Enabled = true,
                Key = "Detox",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_WINDWALKER]
                return     A.Detox:IsReadyM(thisunit) and
                        A.Detox:AbsentImun(thisunit) and
                        AuraIsValid(thisunit, "UseDispel", "Dispel") and
                        LossOfControl:IsMissed("SILENCE") and
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]]
            },
            ["heal"] = {
                Enabled = true,
                Key = "ReverseHarm",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_WINDWALKER]
                return     A.ReverseHarm:IsReadyM(thisunit) and
                        A.ReverseHarm:AbsentImun(thisunit) and
                        LossOfControl:IsMissed("SILENCE") and
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0 and
                        Unit(thisunit):HealthPercent() <= 92
            ]]
            }
        },
        [ACTION_CONST_MONK_BREWMASTER] = {
            ["stun"] = {
                Enabled = true,
                Key = "LegSweep",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_BREWMASTER]
                return     Unit("player"):HasBuffs(A.ZenMeditation.ID, true) == 0 and
                        A.LegSweep:IsReadyM(thisunit, true) and
                        (
                            (
                                not Unit(thisunit):IsEnemy() and
                                (
                                    (
                                        not IsInPvP and
                                        MultiUnits:GetByRange(5, 1) >= 1
                                    ) or
                                    (
                                        IsInPvP and
                                        EnemyTeam():PlayersInRange(1, 5)
                                    )
                                )
                            ) or
                            (
                                Unit(thisunit):IsEnemy() and
                                Unit(thisunit):GetRange() <= 5 and
                                Unit(thisunit):IsControlAble("stun", 0) and
                                Unit(thisunit):HasDeBuffs("Stuned") <= GetCurrentGCD() and
                                A.LegSweep:AbsentImun(thisunit, {"StunImun", "TotalImun", "DamagePhysImun", "CCTotalImun"}, true)
                            )
                        )
            ]]
            },
            ["kick"] = {
                Enabled = true,
                Key = "SpearHandStrike",
                LUAVER = 6,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_BREWMASTER]
                return     Unit("player"):HasBuffs(A.ZenMeditation.ID, true) == 0 and
                        A.SpearHandStrike:IsReadyM(thisunit) and
                        A.SpearHandStrike:AbsentImun(thisunit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and
                        Unit(thisunit):IsCastingRemains() > 0
            ]]
            },
            ["freedom"] = {
                Enabled = true,
                Key = "TigersLust",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_BREWMASTER]
                return     Unit("player"):HasBuffs(A.ZenMeditation.ID, true) == 0 and
                        A.TigersLust:IsReadyM(thisunit) and
                        A.TigersLust:AbsentImun(thisunit) and
                        LossOfControl:IsMissed("SILENCE") and
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]]
            },
            ["dispel"] = {
                Enabled = true,
                Key = "Detox",
                LUAVER = 5,
                LUA = [[
                local A = Action[ACTION_CONST_MONK_BREWMASTER]
                return     Unit("player"):HasBuffs(A.ZenMeditation.ID, true) == 0 and
                        A.Detox:IsReadyM(thisunit) and
                        A.Detox:AbsentImun(thisunit) and
                        AuraIsValid(thisunit, "UseDispel", "Dispel") and
                        LossOfControl:IsMissed("SILENCE") and
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]]
            }
        }
    }
}

-- Perform profile DB upgrade
TMW:RegisterSelfDestructingCallback(
    "TMW_ACTION_IS_INITIALIZED_PRE",
    function(callbackEvent, pActionDB)
        if pActionDB then
            local L = A.GetLocalization()
            local Version = toNum[A.Data.ProfileUI.DateTime:match("%d+")]

            -- Perform upgrade N/A to v15
            if not pActionDB.Version or pActionDB.Version < 15 then
                local notification =
                    (L["DEBUG"] or "") ..
                    " " ..
                        (L.TAB[7].HEADTITLE or "") ..
                            ' ["%s"] ' .. (L.TAB[7].KEYERRORNOEXIST or "") .. " " .. (L.RESETED or "")

                if pActionDB[7][ACTION_CONST_MONK_MISTWEAVER].msgList["dispel"] then
                    pActionDB[7][ACTION_CONST_MONK_MISTWEAVER].msgList["dispel"] = nil
                    Print(notification:format("dispel"))
                end

                if pActionDB[7][ACTION_CONST_MONK_MISTWEAVER].msgList["freedom"] then
                    pActionDB[7][ACTION_CONST_MONK_MISTWEAVER].msgList["freedom"] = nil
                    Print(notification:format("freedom"))
                end
            end

            if pActionDB.Version ~= Version then
                if pActionDB.Version then
                    Print(
                        A.CurrentProfile ..
                            " " .. L.UPGRADEDFROM .. (pActionDB.Version or "N/A") .. L.UPGRADEDTO .. Version
                    )
                end
                pActionDB.Version = Version
            end

            return true -- Signal RegisterSelfDestructingCallback to unregister
        end
    end
)

-----------------------------------------
--                   PvP
-----------------------------------------
function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then
        return false
    end

    if
        A[A.PlayerSpec] and A[A.PlayerSpec].SpearHandStrike and
            A[A.PlayerSpec].SpearHandStrike:IsReadyP(unit, nil, true) and
            A[A.PlayerSpec].SpearHandStrike:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and
            A.InterruptIsValid(unit, list)
     then
        return true
    end
end

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp") then
        return false
    end

    local Toggle = A.GetToggle(2, "ParalysisPvP")
    if
        Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Paralysis and
            A[A.PlayerSpec].Paralysis:IsReadyP(unit, nil, true) and
            A[A.PlayerSpec].Paralysis:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and
            Unit(unit):IsControlAble("incapacitate", 0)
     then
        if Toggle == "BOTH" then
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true))
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))
        end
    end
end

local unitIDtargets =
    setmetatable(
    {},
    {
        -- string cache for faster performance
        __index = function(t, v)
            t[v] = v .. "target"
            return t[v]
        end
    }
)

local GrappleWeaponPvPunits =
    setmetatable(
    {},
    {
        __index = function(t, v)
            t[v] = GetToggle(2, "GrappleWeaponPvPunits")
            return t[v]
        end
    }
)
local ImunBuffsCC = {"CCTotalImun", "DamagePhysImun", "TotalImun"}
local ImunBuffsInterrupt = {"KickImun", "TotalImun", "DamagePhysImun"}

function A.GrappleWeaponIsReady(unitID, skipShouldStop, isMsg)
    if A.IsInPvP then
        local isArena = unitID:match("arena")
        if
            ((unitID == "arena1" and GrappleWeaponPvPunits[A.PlayerSpec][1]) or
                (unitID == "arena2" and GrappleWeaponPvPunits[A.PlayerSpec][2]) or
                (unitID == "arena3" and GrappleWeaponPvPunits[A.PlayerSpec][3]) or
                (not isArena and GrappleWeaponPvPunits[A.PlayerSpec][4]))
         then
            if
                (not isArena and Unit(unitID):IsEnemy() and Unit(unitID):IsPlayer()) or
                    (isArena and not Unit(unitID):InLOS() and (A.Zone == "arena" or A.Zone == "pvp"))
             then
                local GrappleWeapon = A[A.PlayerSpec].GrappleWeapon
                if
                    GrappleWeapon and
                        ((not isMsg and GetToggle(2, "GrappleWeaponPvP") ~= "OFF" and
                            ((not isArena and GrappleWeapon:IsReady(unitID, nil, nil, skipShouldStop)) or
                                (isArena and GrappleWeapon:IsReadyByPassCastGCD(unitID))) and
                            Unit(unitID):IsMelee() and
                            (GetToggle(2, "GrappleWeaponPvP") == "ON COOLDOWN" or
                                Unit(unitID):HasBuffs("DamageBuffs") > 8)) or
                            (isMsg and GrappleWeapon:IsReadyM(unitID))) and
                        GrappleWeapon:AbsentImun(unitID, ImunBuffsCC, true) and
                        Unit(unitID):IsControlAble("disarm") and
                        Unit(unitID):InCC() == 0 and
                        Unit(unitID):HasDeBuffs("Disarmed") == 0
                 then
                    return true
                end
            end
        end
    end
end

function A:CanInterruptPassive(unitID, countGCD)
    if A.IsInPvP and (A.Zone == "arena" or A.Zone == "pvp") then
        if self.isSpearHandStrike then
            -- MW hasn't SpearHandStrike action
            local useKick, _, _, notInterruptable = InterruptIsValid(unitID, "Heal", nil, countGCD)
            if not useKick then
                useKick, _, _, notInterruptable = InterruptIsValid(unitID, "PvP", nil, countGCD)
            end
            if
                useKick and not notInterruptable and self:IsReadyByPassCastGCD(unitID) and
                    self:AbsentImun(unitID, ImunBuffsInterrupt, true)
             then
                return true
            end
        end

        if self.isParalysis then
            local ParalysisPvP = GetToggle(2, "ParalysisPvP")
            if ParalysisPvP and ParalysisPvP ~= "OFF" and self:IsReadyByPassCastGCD(unitID) then
                local _, useCC, castRemainsTime
                if Toggle == "BOTH" then
                    useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, "Heal", nil, countGCD))
                    if not useCC then
                        useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, "PvP", nil, countGCD))
                    end
                else
                    useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, Toggle, nil, countGCD))
                end
                if
                    useCC and castRemainsTime >= GetLatency() and Unit(unitID):IsControlAble("incapacitate") and
                        not Unit(unitID):InLOS() and
                        self:AbsentImun(unitID, ImunBuffsCC, true)
                 then
                    return true
                end
            end
        end
    end
end
