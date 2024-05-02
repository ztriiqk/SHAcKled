Global = {
    PlayerListID = ImInt(0),
    PlayerListName = ImBuffer("", 25),
    PlayerListIDChose = -1,
    damagerhitEnPos = CVector(),
    silenthitEnPos = 0,
    silentoriginEnPos = 0,
    WeaponSlotCombo = ImInt(0),
    Fly = 1,
    rVankanEWVAR = 0,
    DamagerToggleH = 0,
    DamagerVehicleID = 0,
    pedAngle = 0,
    carAngle = 0,
    damagerBone = {},
    silentBone = 0,
    SaveVehicle = 0,
    SaveObjectTimer = 0,
    SaveObjectPos = {},
    SaveObjectDelay = {},
    SaveObject = 0,
    AimAssistAiming = 0,
    AimAssist = nil,
    AimAssist2 = nil,
    AimAssist3 = nil,
    AimAssistDelay = 0,
    AimAssistTarget = {},
    CJWalk = 0,
    AfterDamage = {},
    AfterDamageName = {},
    AfterDamageDelayPer = {},
    Speed = 0,
    SaveSpeedX = 0,
    SaveSpeedY = 0,
    Duration = 0,
    DelayAntiStun = 0,
    SwitchVelocity = {
            [0] = 1,
            [1] = 0
        },
    SpeedSlide = ImInt(0),
    canSlide = ImInt(0),
    Switch = ImInt(-2),
    Aiming = ImInt(0),
    FiredGun = ImInt(0),
    SlideWeapon = ImInt(0),
    CamMod = ImInt(0),
    Delayed = 
        {
            [0] = 0,
            [1] = 0
        },
    DesyncDelay = 0,
    DesyncTimer = 0,
    DrawWall = 0,
    KeyPressed = 0,
    Menu = 0,
    Player = 0,
    LastPosPlayer = 0,
    Vehicle = 0,
    AttachToVehicleID = 0,
    Attached = 0,
    Object = 0,
    CheckpointSave = 0,
    Progressive = 0,
    Timer =
        {
            [0] = 0,
            [1] = 0
        },
    CanJump = 0,
    RandSpeed = 5,
    IndTimer = -1,
    HVHSavePos = 0,
    HVHWaitW = {},
    HvHid = {},
    HvHpos = {},
    Teleporting = {},
    lastbone = 3,
    lastamount = 0,
    VehicleSpam = 0,
    SaveLastAnimation = 0,
    SaveLastPos = CVector(),
    Interior = 0,
    InvCar = -1,
    InvTimer = 0,
    KeyDelay = 0,
    SpeedX = 0,
    SpeedY = 0,
    CVehicleST = Utils:readMemory(0xB6F980, 4, false),
    CPedST = Utils:readMemory(0xB6F5F0, 4, false),
    CPlayerData = 0
}
Global.CPlayerData = Utils:readMemory(Global.CPedST+0x480, 4, false)

Timers = {}
        setmetatable(Timers, {
            __call = function (cls, WaitTime)
            return cls.new(WaitTime)
            end,
        })
        function Timers.new(WaitTime)
                local self = setmetatable({}, Timers)
                self.interval = WaitTime 
                self.currentTime = 0.0
                function self.update(deltaTime)
                    self.currentTime = self.currentTime + deltaTime
                    if(self.currentTime >= self.interval) then
                        self.currentTime = 0
                        return true
                    end
                    return false
                end
                return self
            end
        function calculateDeltaTime()
                local currTime = os.clock()
                deltaTime = (currTime - prevTime) * 1000
                prevTime = currTime
            end  
        prevTime = os.clock()
        deltaTime = 0.0
        ms = Timers(0.5)
        SendCMD = Timers(1)
        PickUP = Timers(1)
        HydraThrustDelay = Timers(5)
        Macro = Timers(10)
        Timerss = Timers(10)
        getVars = Timers(100)
        Visuals = Timers(3)
        getSilentTarget = Timers(500)
        getWeaponsTimer = Timers(1000)
        getTrash = Timers(5000)
        hookTimer = {PlayerSync = Timers(1), DriveSync = Timers(1), MainHook = Timers(1)}
        
        Multiplier = {}
        HideTextDrawTimer = {}

--Vectors
vecCrosshair = CVector()
vMyScreen = CVector()
vEnScreen = CVector()
vEnScreenToDamager = CVector()
vEnScreenToSilent = CVector()
vMyScreenToSilent = CVector()
middlescreen = CVector(Utils:getResolutionX()*0.5, Utils:getResolutionY()*0.4, 0)
--! Tables
moveFlag = {
    Unknown = 1,             -- Bit 1
    ApplyGravity = 2,        -- Bit 2
    DisableCollisionForce = 4,-- Bit 3
    Collidable = 8,          -- Bit 4
    DisableTurnForce = 16,   -- Bit 5
    DisableMoveForce = 32,   -- Bit 6
    InfiniteMass = 64,       -- Bit 7
    DisableZ = 128           -- Bit 8
}
Timer = {
        Teleport = os.clock(),
        Shits = os.clock(),
        FPS = os.clock(),
        Visuals = 0,
        Stun = ImInt(0),
        AFK = 0,
        Slide = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
            },
        GunC = 0,
        SniperC = 0,
        Indicator1 = 0,
        Indicator2 = 0,
        ChangeColor1 = 0,
        Configs = {   
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 0,
            },
        Teleporting = 0,
    }
SHAkMenu = {
        ChatMessage = ImBool(false),
        Folder = 0,
        SaveOverWrite = ImBool(false),
        Save = ImBool(false),
        Saved = 0,
        Open = 0,
        Load = ImBool(false),
        Loaded = 0,
        Unload = ImBool(false),
        Delete = ImBool(false),
        DeleteYes = ImBool(false),
        DeleteNo = ImBool(false),
        Menu = ImInt(-1),
        Config = 0,
        ConfigName = ImBuffer("Default.SHAk",256),
        CurrentConfig = ImBuffer("Default.SHAk",256),
        DefaultConfig = 0,
        Configs = ImInt(0),
        FpsBoost = ImBool(false),
        RefreshHZ = ImBool(false),
        menuOpened = 0,
        menutransitor = 0,
        menutransitorstatic = 0,
        menutransitorstaticreversed = 140,
        menutransitorstaticreversed2 = 140,
        X = ImFloat(0.0000),
        Y = ImFloat(0.0000),
        AspectRatio = ImBool(false),
        AspectSize = ImFloat(1.3333333730698),
        DrawDistance = ImBool(false),
        DrawDistanceF = ImFloat(1.9),
        Fov = ImBool(false),
        FovView = ImFloat(70.0),
        patch160HP = ImBool(false),
        Lagshot = ImBool(false),
        GetWeapon = {
            Weapon = ImInt(0),
            Ammo = ImInt(0),
        }
    }
PlayerList = {}
Doublejump = {
    Enable = ImBool(false),
    Height = ImFloat(0.1),
    OnKey = ImBool(false),
    Key = ImInt(16)
}
    NOPs = {
            Send = {
                    [23] = ImBool(false),         --OnPlayerClickPlayer
                    [25] = ImBool(false),         --ClientJoin
                    [26] = ImBool(false),         --EnterVehicle 
                    [50] = ImBool(false),         --SendCommand
                    [52] = ImBool(false),         --SendSpawn
                    [53] = ImBool(false),         --SendDeathNotification
                    [54] = ImBool(false),         --NPCJoin
                    [62] = ImBool(false),         --SendDialogResponse 
                    [83] = ImBool(false),         --OnPlayerClickset.TextDraw
                    [96] = ImBool(false),         --OnEnterExitModShop
                    [101] = ImBool(false),        --SendChatMessage
                    [103] = ImBool(false),        --ClientCheckResponse 
                    [106] = ImBool(false),        --UpdateVehicleDamageStatus 
                    [115] = ImBool(false),        --GiveTakeDamage 
                    [116] = ImBool(false),        --OnPlayerEditAttachedObject
                    [117] = ImBool(false),        --OnPlayerEditObject 
                    [118] = ImBool(false),        --InteriorChangeNotification
                    [119] = ImBool(false),        --ClickMap 
                    [128] = ImBool(false),        --RequestClass
                    [129] = ImBool(false),        --RequestSpawn
                    [131] = ImBool(false),        --OnPlayerPickupPickup
                    [132] = ImBool(false),        --OnPlayerSelectedMenuRow 
                    [136] = ImBool(false),        --OnVehicleDeath 
                    [140] = ImBool(false),        --OnPlayerExitedMenu  
                    [154] = ImBool(false),        --ExitVehicle 
                    [155] = ImBool(false),        --UpdateScoresAndPings 
                    [168] = ImBool(false)        --OnCameraTarget
                },
            Receive = {
                    [11] = ImBool(false),     --SetPlayerName 
                    [12] = ImBool(false),     --set.PlayerPos 
                    [13] = ImBool(false),     --set.PlayerPosFindZ 
                    [14] = ImBool(false),     --SetPlayerHealth
                    [15] = ImBool(false),     --TogglePlayerControllable
                    [16] = ImBool(false),     --PlayerPlaySound
                    [17] = ImBool(false),     --SetWorldBound
                    [18] = ImBool(false),     --GivePlayerMoney
                    [19] = ImBool(false),     --setPlayerZAngle
                    [20] = ImBool(false),     --ResetPlayerMoney
                    [21] = ImBool(false),     --ResetPlayerWeapons
                    [22] = ImBool(false),     --GivePlayerWeapon
                    [26] = ImBool(false),     --send.PlayerEnterVehicle
                    [27] = ImBool(false),     --SelectObject 
                    [28] = ImBool(false),     --CancelEdit 
                    [29] = ImBool(false),     --SetPlayerTime
                    [30] = ImBool(false),     --ToggleClock
                    [32] = ImBool(false),     --WorldPlayerAdd
                    [34] = ImBool(false),     --SetPlayerSkillLevel 
                    [37] = ImBool(false),     --DisableCheckpoint 
                    [38] = ImBool(false),     --SetRaceCheckpoint 
                    [39] = ImBool(false),     --DisableRaceCheckpoint 
                    [41] = ImBool(false),     --PlayAudioStream
                    [42] = ImBool(false),     --StopAudioStream
                    [43] = ImBool(false),     --RemoveBuilding
                    [44] = ImBool(false),     --CreateObject 
                    [45] = ImBool(false),     --SetObjectPos 
                    [46] = ImBool(false),     --SetObjectRotation  
                    [47] = ImBool(false),     --DestroyObject 
                    [55] = ImBool(false),     --SendDeathMessage
                    [56] = ImBool(false),     --set.PlayerMapIcon  
                    [57] = ImBool(false),     --RemoveVehicleComponent
                    [58] = ImBool(false),     --Update3DTextLabel
                    [59] = ImBool(false),     --ChatBubble 
                    [61] = ImBool(false),     --ShowDialog
                    [65] = ImBool(false),     --LinkVehicleToInterior
                    [66] = ImBool(false),     --SetPlayerArmour
                    [67] = ImBool(false),     --set.ArmedWeapon
                    [68] = ImBool(false),     --SetSpawnInfo
                    [69] = ImBool(false),     --SetPlayerTeam
                    [70] = ImBool(false),     --send.PutPlayerInVehicle
                    [71] = ImBool(false),     --RemovePlayerFromVehicle
                    [72] = ImBool(false),     --SetPlayerColor
                    [73] = ImBool(false),     --ShowGameText 
                    [74] = ImBool(false),     --ForceClassSelection
                    [75] = ImBool(false),     --AttachObjectToPlayer  
                    [77] = ImBool(false),     --ShowMenu 
                    [78] = ImBool(false),     --HideMenu 
                    [79] = ImBool(false),     --CreateExplosion
                    [80] = ImBool(false),     --ShowPlayerNameTag 
                    [83] = ImBool(false),     --SelectTextDraw / OnPlayerClickTextDraw
                    [84] = ImBool(false),     --SetPlayerObjectMaterial(Text)
                    [85] = ImBool(false),     --GangZoneStopFlash 
                    [86] = ImBool(false),     --ApplyPlayerAnimation  
                    [87] = ImBool(false),     --ClearPlayerAnimation  
                    [88] = ImBool(false),     --SetPlayerSpecialAction 
                    [89] = ImBool(false),     --SetPlayerFightingStyle
                    [90] = ImBool(false),     --set.PlayerVelocity
                    [91] = ImBool(false),     --set.VehicleVelocity
                    [93] = ImBool(false),     --SendClientMessage
                    [94] = ImBool(false),     --SetWorldTime
                    [95] = ImBool(false),     --CreatePickup 
                    [104] = ImBool(false),    --EnableStuntBonus
                    [105] = ImBool(false),    --TextDrawSetString
                    [106] = ImBool(false),    --UpdateVehicleDamageStatus
                    [107] = ImBool(false),    --SetCheckpoint 
                    [108] = ImBool(false),    --AddGangZone 
                    [111] = ImBool(false),    --ToggleWidescreen
                    [113] = ImBool(false),    --SetPlayerAttachedObject 
                    [120] = ImBool(false),    --GangZoneDestroy
                    [121] = ImBool(false),    --GangZoneFlash
                    [122] = ImBool(false),    --StopObject
                    [123] = ImBool(false),    --SetVehicleNumberPlate
                    [124] = ImBool(false),    --TogglePlayerSpectating
                    [126] = ImBool(false),    --SpectatePlayer 
                    [127] = ImBool(false),    --SpectateVehicle 
                    [128] = ImBool(false),    --RequestClass
                    [129] = ImBool(false),    --SpawnPlayer
                    [133] = ImBool(false),    --SetPlayerWantedLevel
                    [134] = ImBool(false),    --ShowTextDraw
                    [135] = ImBool(false),    --set.HideTextDraw
                    [144] = ImBool(false),    --RemovePlayerMapIcon 
                    [145] = ImBool(false),    --SetPlayerAmmo
                    [146] = ImBool(false),    --SetGravity
                    [147] = ImBool(false),    --SetVehicleHealth
                    [148] = ImBool(false),    --AttachTrailerToVehicle
                    [149] = ImBool(false),    --DetachTrailerFromVehicle
                    [152] = ImBool(false),    --SetPlayerWeather
                    [153] = ImBool(false),    --set.PlayerSkin
                    [154] = ImBool(false),    --PlayerExitvehicle
                    [155] = ImBool(false),    --UpdateScoresAndPings 
                    [156] = ImBool(false),    --SetPlayerInterior
                    [157] = ImBool(false),    --set.PlayerCameraPos
                    [158] = ImBool(false),    --set.PlayerCameraLookAt
                    [159] = ImBool(false),    --set.VehiclePos
                    [160] = ImBool(false),    --set.VehicleZAngle
                    [161] = ImBool(false),    --SetVehicleParams
                    [162] = ImBool(false),    --SetPlayerCameraBehindPlayer
                    [163] = ImBool(false),    --WorldPlayerRemove
                    [164] = ImBool(false),    --WorldVehicleAdd
                    [165] = ImBool(false),    --WorldVehicleRemove
                    [166] = ImBool(false),    --DeathBroadcast  
                    [170] = ImBool(false),    --SetTargeting
                    [171] = ImBool(false),    --ShowActor
                    [172] = ImBool(false),    --HideActor 
                    [173] = ImBool(false),    --ApplyActorAnimation 
                    [174] = ImBool(false),    --ClearActorAnimation 
                    [175] = ImBool(false),    --SetActorFacingAngle 
                    [176] = ImBool(false),    --SetActorPos 
                    [178] = ImBool(false)    --SetActorHealth 
                }
        }
    KeyToggle = {
            Silent = ImInt(0),
            Triggerbot = ImInt(0),
            AimAssist = ImInt(0),
            DDamage = ImInt(0),
            Damager = ImInt(0),
            DamageChanger = ImInt(0),
            ExtraWS = ImInt(0),
            RVanka = ImInt(0),
            MacroRun = ImInt(0),
            Crouchhook = ImInt(0),
            GodmodePlayer = ImInt(0),
            GodmodeVehicle = ImInt(0)
        }
weaponInfo = {}
    weaponInfo[0] =  { id = 0,  slot = 0,  name = "Fist",                     distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1136, animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[1] =  { id = 1,  slot = 0,  name = "Brass Knuckles",           distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1136, animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[2] =  { id = 2,  slot = 1,  name = "Golf Club",                distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[3] =  { id = 3,  slot = 1,  name = "Nitestick",                distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 19,   animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[4] =  { id = 4,  slot = 1,  name = "Knife",                    distance = 1.6,   damage = 0.0,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 747,  animationsflag = 9988,  weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[5] =  { id = 5,  slot = 1,  name = "Bat",                      distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = true  }
    weaponInfo[6] =  { id = 6,  slot = 1,  name = "Shovel",                   distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = true  }
    weaponInfo[7] =  { id = 7,  slot = 1,  name = "Pool Cue",                 distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = true  }
    weaponInfo[8] =  { id = 8,  slot = 1,  name = "Katana",                   distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1545, animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[9] =  { id = 9,  slot = 1,  name = "Chainsaw",                 distance = 1.6,   damage = 27.060001, own = false, ammo = 0, state = 0, clipammo = 0, animations = 320,  animationsflag = 32772, weaponstate = 0, cammode = 4,  twohanded = true  }
    weaponInfo[10] = { id = 10, slot = 10, name = "Purple Dildo",             distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 423,  animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[11] = { id = 11, slot = 10, name = "Dildo",                    distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 749,  animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[12] = { id = 12, slot = 10, name = "Vibrator",                 distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 423,  animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[13] = { id = 13, slot = 10, name = "Silver Vibrator",          distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 749,  animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[14] = { id = 14, slot = 10, name = "Flowers",                  distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 533,  animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[15] = { id = 15, slot = 10, name = "Cane",                     distance = 1.6,   damage = 5.28,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1547, animationsflag = 32776, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[16] = { id = 16, slot = 8,  name = "Grenade",                  distance = 40.0,  damage = 82.5,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 644,  animationsflag = 32784, weaponstate = 1, cammode = 4,  twohanded = false }
    weaponInfo[17] = { id = 17, slot = 8,  name = "Teargas",                  distance = 40.0,  damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 644,  animationsflag = 32784, weaponstate = 1, cammode = 4,  twohanded = false }
    weaponInfo[18] = { id = 18, slot = 8,  name = "Molotov",                  distance = 40.0,  damage = 1.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 644,  animationsflag = 32784, weaponstate = 1, cammode = 4,  twohanded = false }
    weaponInfo[19] = { id = 19, slot = -1, name = "Vehicle M4 (custom)",      distance = 90.0,  damage = 9.9,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 18, twohanded = true  }
    weaponInfo[20] = { id = 20, slot = -1, name = "Vehicle Minigun (custom)", distance = 75.0,  damage = 46.2,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 18, twohanded = true  }
    weaponInfo[21] = { id = 21, slot = -1, name = "Vehicle Rocket (custom)",  distance = 300,   damage = 82.5,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 18, twohanded = true  }
    weaponInfo[22] = { id = 22, slot = 2,  name = "Colt",                     distance = 35.0,  damage = 8.25,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[23] = { id = 23, slot = 2,  name = "Silenced",                 distance = 35.0,  damage = 13.200001, own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[24] = { id = 24, slot = 2,  name = "Desert Eagle",             distance = 35.0,  damage = 46.200001, own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[25] = { id = 25, slot = 3,  name = "Shotgun",                  distance = 40.0,  damage = 49.500004, own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[26] = { id = 26, slot = 3,  name = "Sawnoff",                  distance = 35.0,  damage = 49.500004, own = false, ammo = 0, state = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[27] = { id = 27, slot = 3,  name = "Spas",                     distance = 40.0,  damage = 29.700001, own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[28] = { id = 28, slot = 4,  name = "Uzi",                      distance = 35.0,  damage = 6.6,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[29] = { id = 29, slot = 4,  name = "Mp5",                      distance = 45.0,  damage = 8.25,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[30] = { id = 30, slot = 5,  name = "Ak47",                     distance = 70.0,  damage = 9.900001,  own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[31] = { id = 31, slot = 5,  name = "M4",                       distance = 90.0,  damage = 9.900001,  own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[32] = { id = 32, slot = 4,  name = "Tec9",                     distance = 35.0,  damage = 6.6,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[33] = { id = 33, slot = 6,  name = "Country Rifle",            distance = 100.0, damage = 24.750002, own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 3, cammode = 53, twohanded = true  }
    weaponInfo[34] = { id = 34, slot = 6,  name = "Sniper",                   distance = 320.0, damage = 41.25,     own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 3, cammode = 7,  twohanded = true  }
    weaponInfo[35] = { id = 35, slot = 7,  name = "Rocket Launcher",          distance = 55.0,  damage = 82.5,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 3, cammode = 8,  twohanded = true  }
    weaponInfo[36] = { id = 36, slot = 7,  name = "HeatSeeker",               distance = 55.0,  damage = 82.5,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 3, cammode = 51, twohanded = true  }
    weaponInfo[37] = { id = 37, slot = 7,  name = "Flamethrower",             distance = 5.1,   damage = 1.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[38] = { id = 38, slot = 7,  name = "Minigun",                  distance = 75.0,  damage = 46.2,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[39] = { id = 39, slot = 8,  name = "Satchel",                  distance = 40.0,  damage = 82.5,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 1, cammode = 4,  twohanded = false }
    weaponInfo[40] = { id = 40, slot = 12, name = "Detonator",                distance = 25.0,  damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 1, cammode = 4,  twohanded = false }
    weaponInfo[41] = { id = 41, slot = 9,  name = "Spraycan",                 distance = 6.1,   damage = 0.33,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1164, animationsflag = 32776, weaponstate = 2, cammode = 53, twohanded = false }
    weaponInfo[42] = { id = 42, slot = 9,  name = "Extinguisher",             distance = 10.1,  damage = 0.33,      own = false, ammo = 0, state = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 2, cammode = 53, twohanded = true  }
    weaponInfo[43] = { id = 43, slot = 9,  name = "Camera",                   distance = 100.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 2, cammode = 46, twohanded = false }
    weaponInfo[44] = { id = 44, slot = 11, name = "Night Vision",             distance = 100.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 638,  animationsflag = 32772, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[45] = { id = 45, slot = 11, name = "Thermal Vision",           distance = 100.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 638,  animationsflag = 32772, weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[46] = { id = 46, slot = 11, name = "Parachute",                distance = 1.6,   damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 4,  twohanded = false }
    weaponInfo[47] = { id = 47, slot = -1, name = "Cellphone",                distance = 300.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 0,  twohanded = false }
    weaponInfo[48] = { id = 48, slot = -1, name = "Jetpack",                  distance = 300.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 0,  twohanded = false }
    weaponInfo[49] = { id = 49, slot = -1, name = "Vehicle",                  distance = 300.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 0,  twohanded = false }
    weaponInfo[50] = { id = 50, slot = -1, name = "Helicopter Blades",        distance = 300.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 0,  twohanded = false }
    weaponInfo[51] = { id = 51, slot = -1, name = "Random",                   distance = 300.0, damage = 0.0,       own = false, ammo = 0, state = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 0, cammode = 0,  twohanded = false }
fWeaponName = ""
    for i = 0, #weaponInfo do
        weaponData = weaponInfo[i]
        if weaponData and weaponData.name and weaponData.name ~= "nil" then
            fWeaponName = fWeaponName .. weaponData.name .. "\0"
        end
    end
VehicleType = {}
    VehicleType.Car = 0
    VehicleType.Bike = 1
    VehicleType.Bicycle = 2
    VehicleType.RC = 3
    VehicleType.Heli = 4
    VehicleType.Boat = 5
    VehicleType.Plane = 6
    VehicleType.Train = 7
    VehicleType.Trailer = 8
vehicleInfo = {}   
fModelName = ""
fPlayerBone = {
        3, --	TORSO
        4, --	GROIN
        5, --	LEFT_ARM 
        6, --	RIGHT_ARM
        7, --	LEFT_LEG
        8, --	RIGHT_LEG
        9 --	HEAD
    }
fCheatBone = {
        3, --  TORSO
        1, --  GROIN
        33, --  Left upper arm
        23, --  Right upper arm
        52, --  Left thigh
        42, --  Right thigh
        8 --  Head
    }
sRunAnimations = {
        458,
        462,
        908,
        1196,				
        1224,				
        1226,				
        1227,				
        1228,				
        1229,				
        1230,				
        1231,				
        1232,
        1233,				
        1234,				
        1235,
        1236,
        1249,
        1276, 				
        1277,				
        1278,				
        1279,				
        1280,
        1246,		
        1247,			
        1248,	
        1246,
        1247,
        1248,
        1257,				
        1258,				
        1259,				
        1260,				
        1261,				
        1262,				
        1263,				
        1264,				
        1265,				
        1266,				
        1267,				
        1268,				
        1269
    }
players = {
        id = {},
        SilentTarget = {},
        dist = {},
        fov = {},
        bone = {},
        team = {},
        fightstyle = {},
        Quats = 
        {
            w = 0,
            x = 0,
            y = 0,
            z = 0
        },
        AimPosX = {},
        AimPosY = {},
        AimPosZ = {}
    }
objects = {
        fov = {}
    }
vehicles = {
        dist = {},
        id = {},
        fov = {},
        crasher = {},
        Quats = 
            {
                w = 0,
                x = 0,
                y = 0,
                z = 0
            }
    }
vehicleParts = {
        panels = {},
        doors = {}, 
        lights = {},
        tires = {}
    }
SilentStuff = {
        Fov = 0,
        Fov2 = 0,
        PistolFov = 0,
        PistolFov2 = 0,
        SMGFov = 0,
        SMGFov2 = 0,
        ShotgunFov = 0,
        ShotgunFov2 = 0,
        RifleFov = 0,
        RifleFov2 = 0,
        SniperFov = 0,
        SniperFov2 = 0,
        RocketFov = 0,
        RocketFov2 = 0,
        Distance = 0,
        ChangedDist  = 0,
        VisibleVehicles = ImBool(false),
        VisibleObjects = ImBool(false),
        VisibleCheck = ImBool(false),
        BoneHead = 0,
        BoneChest = 0,
        BoneStomach = 0,
        BoneLeftA = 0,
        BoneRightA = 0,
        BoneLeftL = 0,
        BoneRightL = 0,
        Dmg = 0,
        ChangedDMG = 0,
        Bullets = 0,
        Chance = 0,
        Chance2 = 0,
        Shots = 0,
        ShotsCounter = 0,
        FirstShots = 0
    }
SampKeys = {
        fire = 0,
        aim = 0,
        horn_crouch = 0,
        enterExitCar = 0,
        sprint = 0,
        jump = 0,
        landingGear_lookback = 0,
        walk = 0,
        tab = 0
    }
RPC = {}
memory = {
        ExtraWS = {},
        CPed = {},
        CVehicle = {}
    }
vMy = {}
    Health = Utils:readMemory(Global.CPedST+0x540, 4, false)
    Armour = Utils:readMemory(Global.CPedST+0x548, 4, false)
    bsTrans = BitStream()
    bsWrap:Write32(bsTrans, Health)
    bsWrap:Write32(bsTrans, Armour)
    vMy.Health = bsWrap:ReadFloat(bsTrans)
    vMy.Armour = bsWrap:ReadFloat(bsTrans)
    vMy.OFData = Players:getOnFootData(Players:getLocalID())
    vMy.ICData = Players:getInCarData(Players:getLocalID())
vAmI = {}
vEn = {
        ICData = {},
        OFData = {},
        Driver = {},
        Passenger = {},
        Pos = {},
        HP = {},
        Armor = {},
        isFilterPlayer = {},
        isFilterSkin = {},
        Weapon = {},
        Skin = {},
        Color = {},
        Name = {},
        Vehicle = {},
        Lag = {}
    }
m_offsets = {}--          r1         r2        r3        r4        r4-2      r5        0.3dl
    m_offsets.m_samp_info =   { 0x21A0F8,  0x21A100, 0x26E8DC, 0x26EA0C, 0x26EA0C, 0x26EB94, 0x2ACA24  }
    m_offsets.m_settings =    { 0x3C5,     0x03C1,   0x3D5,    0x3DE,    0x3DE,    0x3D5,    0x3D5     }
    m_offsets.m_game_state =  { 0x3BD,     0x03B9,   0x3CD,    0x3CD,    0x3CD,    0x3CD,    0x3CD     }
    m_offsets.m_pools =       { 0x3CD,     0x3C5,    0x3DE,    0x3DE,    0x3DE,    0x3DE,    0x3DE     }
    m_offsets.m_pickup =      { 0x20,      0x10,     0x10,     0x10,     0x8,      0x8,      0x10      }
    
    m_offsets.m_player =      { 0x18,      0x8,      0x8,      0x8,      0x4,      0x4,      0x4       }
    m_offsets.m_localplayer = { 0x22,      0x1E,     0x2F3A,   0x2A,     0x26,     0x26,     0x1E      }
    m_offsets.m_actor =       { 0x0,       0x0,      0x0,      0x104,    0x104,    0x104,    0x0       }

    m_offsets.m_object =      { 0x27C,     0x27C,    0x27C,    0x27C,    0x27C,    0x27C,    0x27C     }
    m_offsets.m_objectexist = { 0x4C,      0x4C,     0x4C,     0x4C,     0x4C,     0x4C,     0x4C      }

    m_offsets.m_dialog =      { 0x40,      0x40,     0x44,     0x44,     0x44,     0x44,     0x44      }        
    m_offsets.m_server_addr = { 0x20,      0,        0x30,     0,        0,        0x30,     0         }
    m_offsets.m_server_port = { 0x225,     0,        0x235,    0,        0,        0x235,    0         }
OnFootData = {}
DriverData = {}
BulletData = {}
AimData = {}
get = {}
set = {}
read = {}
send = {}
maths = {}
read = {}
send = {}
mainhook = {}
