local bit = require("bit32")
local luaVersion = "1.17"
local unload = false

--Timers 
    local Timers = {}
            
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
            
        local ms = Timers(1)
        local SendCMD = Timers(1)
        local PickUP = Timers(1)
        local Macro = Timers(10)
        local Timerss = Timers(10)
        local getMyVars = Timers(15)
        local Visuals = Timers(10)
        local getNearests = Timers(250)
        local getSilentTarget = Timers(750)
        local getWeaponsTimer = Timers(1000)
        local CollectGarbage = Timers(5000)

        local DMGTimer, RVankaTimer1
--
--Vectors
    local vecCrosshair = CVector()
    local vMyScreen = CVector()
    local vEnScreen = CVector()
    local vMyScreenToDamager = CVector()
    local vEnScreenToDamager = CVector()
    local middlescreen = CVector(Utils:getResolutionX()*0.5, Utils:getResolutionY()*0.4, 0)
--
--!  Tables
    local Timer = {
            Teleport = os.clock(),
            Shits = os.clock(),
            FPS = os.clock(),
            second =  {
                    [0] = 0,
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                },
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
            GetLag = {},
        }
    local SHAkMenu = {
            ChatMessage = ImBool(false),
            Folder = 0,
            SaveOverWrite = ImBool(false),
            Save = ImBool(false),
            Saved = 0,
            Open = 0,
            Load = ImBool(false),
            Loaded = 0,
            IsLoading = 0,
            unload = ImBool(false),
            Delete = ImBool(false),
            DeleteYes = ImBool(false),
            DeleteNo = ImBool(false),
            Menu = ImInt(-1),
            Config = 0,
            ConfigName = ImBuffer("Default.SHAk",256),
            ConfigChoosen = 0,
            DefaultConfig = 0,
            Configs = ImInt(0),
            FolderName = 0,
            FpsBoost = ImBool(false),
            RefreshHZ = ImBool(false),
            menuOpened = 0,
            menutransitor = 0,
            menutransitorstatic = 0,
            menutransitorstaticreversed = 140,
            menutransitorstaticreversed2 = 140,
            X = ImFloat(0),
            Y = ImFloat(0)
        }
    --CFG
        local Panic = {
                Visuals = ImBool(false),
                VisualsKey = ImInt(0),
                EveryThingExceptVisuals = ImBool(false),
                EveryThingExceptVisualsKey = ImInt(0)
            }
        local Silent =
            {
                Enable = ImBool(false),
                OnKey = ImBool(false),
                Key = ImInt(1),
                KeyType = ImInt(0),
                DrawFov = ImBool(false),
                Force = ImBool(false),
                WallShot = ImBool(false),
                WeaponClass = ImInt(0),
                OnlyGiveTakeDamage = ImBool(false),
                OnlyGiveTakeDamageType = ImInt(0),
                SyncRotation = ImBool(false),
                SyncAimZ = ImBool(false),
                Clist = ImBool(false),
                AFK = ImBool(false),
                Death = ImBool(false),
                InVehicle = ImBool(false),
                Pistols = {
                        Fov = ImFloat(0.0),
                        Chance = ImInt(100),
                        FirstShots = {
                                Shots = ImInt(0),
                                Fov = ImFloat(0.0),
                                Chance = ImInt(100)
                            },
                        VisibleCheck = {
                                Buildings = ImBool(false),
                                Vehicles = ImBool(false),
                                Objects = ImBool(false)
                            },
                        Bones = {
                                Head = ImBool(false),
                                Chest = ImBool(false),
                                Stomach = ImBool(false),
                                LeftArm = ImBool(false),
                                RightArm = ImBool(false),
                                LeftLeg = ImBool(false),
                                RightLeg = ImBool(false)
                            },
                        DistanceEnable = ImBool(false),
                        Distance = ImInt(350), 
                        ChangeDamage = ImBool(false),
                        Damage = ImFloat(100),
                        Bullets = ImInt(1),
                        Spread = {
                                Min = ImFloat(-0.15),
                                Max = ImFloat(0.15)
                            }
                    },
                Shotguns = {
                        Fov = ImFloat(0.0),
                        Chance = ImInt(100),
                        FirstShots = {
                                Shots = ImInt(0),
                                Fov = ImFloat(0.0),
                                Chance = ImInt(100)
                            },
                        VisibleCheck = {
                                Buildings = ImBool(false),
                                Vehicles = ImBool(false),
                                Objects = ImBool(false)
                            },
                        Bones = {
                                Head = ImBool(false),
                                Chest = ImBool(false),
                                Stomach = ImBool(false),
                                LeftArm = ImBool(false),
                                RightArm = ImBool(false),
                                LeftLeg = ImBool(false),
                                RightLeg = ImBool(false)
                            },
                        DistanceEnable = ImBool(false),
                        Distance = ImInt(350), 
                        ChangeDamage = ImBool(false),
                        Damage = ImFloat(100),
                        Bullets = ImInt(1),
                        Spread = {
                                Min = ImFloat(-0.15),
                                Max = ImFloat(0.15)
                            }
                    },
                Smgs = {
                        Fov = ImFloat(0.0),
                        Chance = ImInt(100),
                        FirstShots = {
                                Fov = ImFloat(0.0),
                                Shots = ImInt(0),
                                Chance = ImInt(100)
                            },
                        VisibleCheck = {
                                Buildings = ImBool(false),
                                Vehicles = ImBool(false),
                                Objects = ImBool(false)
                            },
                        Bones = {
                                Head = ImBool(false),
                                Chest = ImBool(false),
                                Stomach = ImBool(false),
                                LeftArm = ImBool(false),
                                RightArm = ImBool(false),
                                LeftLeg = ImBool(false),
                                RightLeg = ImBool(false)
                            },
                        DistanceEnable = ImBool(false),
                        Distance = ImInt(350), 
                        ChangeDamage = ImBool(false),
                        Damage = ImFloat(100),
                        Bullets = ImInt(1),
                        Spread = {
                                Min = ImFloat(-0.15),
                                Max = ImFloat(0.15)
                            }
                    },
                Rifles = {
                        Fov = ImFloat(0.0),
                        Chance = ImInt(100),
                        FirstShots = {
                                Fov = ImFloat(0.0),
                                Shots = ImInt(0),
                                Chance = ImInt(100)
                            },
                        VisibleCheck = {
                                Buildings = ImBool(false),
                                Vehicles = ImBool(false),
                                Objects = ImBool(false)
                            },
                        Bones = {
                                Head = ImBool(false),
                                Chest = ImBool(false),
                                Stomach = ImBool(false),
                                LeftArm = ImBool(false),
                                RightArm = ImBool(false),
                                LeftLeg = ImBool(false),
                                RightLeg = ImBool(false)
                            },
                        DistanceEnable = ImBool(false),
                        Distance = ImInt(350), 
                        ChangeDamage = ImBool(false),
                        Damage = ImFloat(100),
                        Bullets = ImInt(1),
                        Spread = {
                                Min = ImFloat(-0.15),
                                Max = ImFloat(0.15)
                            }
                    },
                Snipers = {
                        Fov = ImFloat(0.0),
                        Chance = ImInt(100),
                        FirstShots = {
                                Fov = ImFloat(0.0),
                                Shots = ImInt(0),
                                Chance = ImInt(100)
                            },
                        VisibleCheck = {
                                Buildings = ImBool(false),
                                Vehicles = ImBool(false),
                                Objects = ImBool(false)
                            },
                        Bones = {
                                Head = ImBool(false),
                                Chest = ImBool(false),
                                Stomach = ImBool(false),
                                LeftArm = ImBool(false),
                                RightArm = ImBool(false),
                                LeftLeg = ImBool(false),
                                RightLeg = ImBool(false)
                            },
                        DistanceEnable = ImBool(false),
                        Distance = ImInt(350), 
                        ChangeDamage = ImBool(false),
                        Damage = ImFloat(100),
                        Bullets = ImInt(1),
                        Spread = {
                                Min = ImFloat(-0.15),
                                Max = ImFloat(0.15)
                            },
                    },
                Rockets = {
                        Fov = ImFloat(0.0),
                        Chance = ImInt(100),
                        FirstShots = {
                                Fov = ImFloat(0.0),
                                Shots = ImInt(0),
                                Chance = ImInt(100)
                            },
                        VisibleCheck = {
                                Buildings = ImBool(false),
                                Vehicles = ImBool(false),
                                Objects = ImBool(false)
                            },
                        Bones = {
                                Head = ImBool(false),
                                Chest = ImBool(false),
                                Stomach = ImBool(false),
                                LeftArm = ImBool(false),
                                RightArm = ImBool(false),
                                LeftLeg = ImBool(false),
                                RightLeg = ImBool(false)
                            },
                        DistanceEnable = ImBool(false),
                        Distance = ImInt(350), 
                        ChangeDamage = ImBool(false),
                        Damage = ImFloat(100),
                        Bullets = ImInt(1),
                        Spread = {
                                Min = ImFloat(-0.15),
                                Max = ImFloat(0.15)
                            },
                    }
            }
        local AimAssist = {
                Enable = ImBool(false),
                OnKey = ImBool(false),
                Key = ImInt(1),
                KeyType = ImInt(0),
                FOVType = ImInt(0),
                FOV = ImFloat(1),
                ForceWhoDamaged = ImBool(false),
                IgnoreCList = ImBool(false),
                DrawFOV = ImBool(false)
            }
        local Damager = {
                Enable = ImBool(false),
                OnKey = ImBool(false),
                Key = ImInt(1),
                KeyType = ImInt(0),
                TargetType = ImInt(0),
                Chance = ImInt(100),
                ChangeDamage = ImBool(false),
                Damage = ImFloat(100),
                CurrentWeapon = ImBool(false),
                Weapon = ImInt(0),
                DistanceEnable = ImBool(false),
                Distance = ImInt(350), 
                Bullets = ImInt(1),
                SyncWeapon = ImBool(false),
                DeathNotification = ImBool(false),
                Spawn = ImBool(false),
                VisibleChecks = ImBool(false),
                Force = ImBool(false),
                Bone = ImInt(7),
                Delay = ImInt(20),
                EmulCbug = ImBool(false),
                SyncAim = ImBool(false),
                SyncOnfootData = ImBool(false),
                SyncRotation = ImBool(false),
                SyncBullet = {
                        Enable = ImBool(false),
                        Type = ImInt(0)
                    },
                SyncPos = ImBool(false),
                VisibleCheck = {
                        Vehicles = ImBool(false),
                        Objects = ImBool(false)
                    },
                ShowHitPos = ImBool(false),
                Clist = ImBool(false),
                AFK = ImBool(false),
                Death = ImBool(false),
                OnlyGiveTakeDamage = ImBool(false),
                TakeDamage = ImBool(false),
                OnlyStreamed = ImBool(false),
                gtdID = ImInt(-1),
                IgnoreGiveTakeDamage = ImBool(false)
            }
        local DamageChanger = {
                Enable = ImBool(false),
                OnKey = ImBool(false),
                Key = ImInt(1),
                KeyType = ImInt(0),
                Pistols = {
                        Enable = ImBool(false),
                        DMG = ImFloat(0),
                    },
                Shotguns = {
                        Enable = ImBool(false),
                        DMG = ImFloat(0),
                    },
                SMGs = {
                        Enable = ImBool(false),
                        DMG = ImFloat(0),
                    },
                Rifles = {
                        Enable = ImBool(false),
                        DMG = ImFloat(0),
                    },
                Snipers = {
                        Enable = ImBool(false),
                        DMG = ImFloat(0),
                    },
            }
        local BulletRebuff = {
                Enable = ImBool(false),
                SameWeapon = ImBool(false),
                SyncWeapon = ImBool(false),
                Clist = ImBool(false),
                Force = ImBool(false)
            }
        local Troll = {
                FakePos = {
                        Enable = ImBool(false),
                        OnFoot = ImBool(false),
                        InCar = ImBool(false),
                        RandomPos = ImBool(false),
                        X = ImFloat(0.0),
                        Y = ImFloat(0.0)
                    },
                FuckSync = ImBool(false),
                TrollWalk = ImBool(false),
                RVanka = {
                        Enable = ImBool(false),
                        OnKey = ImBool(false),
                        KeyType = ImInt(0),
                        Key = ImInt(0),
                        Distance = ImInt(100), 
                        Speed = ImFloat(0.999),
                        Timer = ImInt(7),
                        PlayerTimer = {}
                    },
                RainCars = ImBool(false),
                Slapper = {
                        Enable = ImBool(false),
                        Key = ImInt(0),
                        OnKey = ImBool(false)
                    } ,
                VehicleTroll = ImBool(false),
                VehicleTrollType = ImInt(0),
                Crasher = {
                        Detonator = ImBool(false)
                    }
            }
        local Godmode = {
                PlayerEnable = ImBool(false),
                PlayerCollision = ImBool(false),
                PlayerMelee = ImBool(false),
                PlayerBullet = ImBool(false),
                PlayerFire = ImBool(false),
                PlayerExplosion = ImBool(false),
                VehicleEnable = ImBool(false),
                VehicleCollision = ImBool(false),
                VehicleMelee = ImBool(false),
                VehicleBullet = ImBool(false),
                VehicleFire = ImBool(false),
                VehicleExplosion = ImBool(false),
                InvisibleCar = 0
            }
        local Vehicle = {
                NoCarCollision = ImBool(false),
                NoCarCollisionKey = ImInt(0),
                AntiCarFlip = ImBool(false),
                AutoAttachTrailer = ImBool(false),
                AutoAttachWaiting = 0,
                AttachDelay = 0,
                SaveTrailer = -1,
                TrailerToVehicle = 0,
                Unlock = ImBool(false),
                NeverOffEngine = ImBool(false),
                DriveNoLicense = ImBool(false),
                DriveNoLicenseFakeData = ImBool(false),
                AntiCarJack = ImBool(false),
                NeverPopTire = ImBool(false),
                BoatFly = ImBool(false),
                PerfectHandling = ImBool(false),
                PerfectHandlingOnKey = ImBool(false),
                PerfectHandlingKey = ImInt(0),
                FreezeRot = ImBool(false),
                PotatoCars = ImBool(false),
                PotatoType = ImInt(0),
                InfinityNitrous = ImBool(false),
                InfinityNitrousType = ImInt(0),
                FastExit = ImBool(false),
                Recovery = ImBool(false),
                RecoverParts = ImBool(false),
                ChosenTimer = ImInt(0),
                HPAmount = ImFloat(0),
                LimitVelocity = ImBool(false),
                SmartLimitMaxVelocity = ImBool(false),
                LimitVelocityOnKey = ImBool(false),
                LimitVelocityKey = ImInt(32),
                LimitSaveVelx = 0,
                LimitSaveVely = 0,
                LimitSaveVelz = 0,
                LimitperSaveVelx = 0,
                LimitperSaveVely = 0,
                LimitperSaveVelz = 0,
                Velocity = ImInt(90),
                CarJump = ImBool(false),
                CarJumpKey = ImInt(0),
                Height = ImFloat(0.1),
                AutoMotorbike = ImBool(false),
                MotorbikeDelay = ImInt(1),
                AutoBike = ImBool(false),
                BikeDelay = ImInt(1)
            }
        local Teleport = {
                Enable = ImBool(false),
                FromGround = ImBool(false),
                OnFootVelocity = ImFloat(1),
                InCarVelocity = ImFloat(1),
                PersonalDelay = ImInt(100),
                toPlayer = ImBool(false),
                toPlayerKey = ImInt(0),
                toVehicle = ImBool(false),
                toInside = ImBool(false),
                toVehicleType = ImInt(0),
                toVehicleDriver = ImBool(false),
                toVehicleKey = ImInt(0),
                HvH = ImBool(false),
                HVHDeath = ImBool(false),
                HVHAFK = ImBool(false),
                HvHAntiKick = ImBool(false),
                HvHKey = ImInt(17),
                HVHWait = ImInt(25),
                AttachToVehicle = ImBool(false),
                toObject = ImBool(false),
                ObjectKey = ImInt(0),
                Jumper = ImBool(false),
                JumperKey = ImInt(49),
                ShowSaveTeleports = ImBool(false),
                PosToScreen = {
                        [0] = CVector(),
                        [1] = CVector(),
                        [2] = CVector(),
                        [3] = CVector()
                    },
                SaveTeleports = {
                        [0] = ImBool(false),
                        [1] = ImBool(false),
                        [2] = ImBool(false),
                        [3] = ImBool(false)
                    },
                LoadTeleports = {
                        [0] = ImBool(false),
                        [1] = ImBool(false),
                        [2] = ImBool(false),
                        [3] = ImBool(false)
                    },
                DelSaveTeleports = {
                        [0] = ImBool(false),
                        [1] = ImBool(false),
                        [2] = ImBool(false),
                        [3] = ImBool(false)
                    },
                SavedPos = {
                        [0] = CVector(),
                        [1] = CVector(),
                        [2] = CVector(),
                        [3] = CVector()
                    },
                toCheckpoint = ImBool(false),
                CheckpointKey = ImInt(0),
                ACDelay = ImInt(1000)
            }
        local WallHack = {
                Enable = ImBool(false),
                Sceleton = ImBool(false)
            }
        local RadarHack = {
                Enable = ImBool(false),
                PlayerMarkers = ImBool(false),
                AfterDamage = ImBool(false),
                Onlyoutofview = ImBool(false),
                ShowLine = ImBool(false),
                ShowName = ImBool(false),
                ShowHP = ImBool(false),
                HPSize = ImInt(32),
                HPHeight = ImInt(5),
                LinkedToChar = ImBool(false),
                Bone = ImInt(2),
                MaxPlayers = ImInt(0),
                X = ImFloat(1.0),
                Y = ImFloat(1.0),
                maxLength = ImFloat(1),
                lowDistance = ImInt(1), 
                maxDistance = ImInt(1), 
                PlayerPos = {},
                PlayerID = {},
                RadarMaxPlayer = -1
            }
        local StreamWall = {
                Enable = ImBool(false),
                AFK = ImBool(false),
                HP = ImBool(false),
                HPUnder = ImBool(false),
                MaxPlayers = ImInt(0),
                X = ImFloat(0),
                Y = ImFloat(0)
            }
        local Filters = {
                Enable = ImBool(false),
                X = ImFloat(0),
                Y = ImFloat(0)
            }
        local Indicator = {
                Enable = ImBool(false),
                Damager = ImBool(false),
                Silent = ImBool(false),
                MacroRun = ImBool(false),
                Slide = ImBool(false),
                FakeLagPeek = ImBool(false),
                SlideSpeed = ImBool(false),
                AntiStun = ImBool(false),
                Godmode = ImBool(false),
                X = ImFloat(0),
                Y = ImFloat(0)
            }
        local Movement = {
                Slide = {
                        Enable = ImBool(false),
                        OnKey = ImBool(false),
                        Key = ImInt(32),
                        PrioritizeFist1handedgun = ImBool(false),
                        PrioritizeFist2handedgun = ImBool(false),
                        PerWeap = ImBool(false),
                        AutoC = ImBool(false),
                        SpeedEnable = ImBool(false),
                        SpeedFakeSync = ImBool(false),
                        Speed = ImFloat(5),
                        SpeedDuration = ImInt(10),
                        SpeedChance = ImInt(100),
                        SpeedGameSpeed = ImInt(0),
                        SwitchVelocity = {
                            [0] = ImInt(1),
                            [1] = ImInt(10),
                            [2] = ImInt(1),
                            [3] = ImInt(10)
                        },
                        SilencedPistol = ImBool(false),
                        DesertEagle = ImBool(false),
                        Shotgun = ImBool(false),
                        Sawnoff = ImBool(false),
                        CombatShotgun = ImBool(false),
                        Mp5 = ImBool(false),
                        Ak47 = ImBool(false),
                        M4 = ImBool(false),
                        CountryRifle = ImBool(false),
                        SniperRifle = ImBool(false)
                    },
                MacroRun = {
                        Enable = ImBool(false),
                        OnKey = ImBool(false),
                        Key = ImInt(32),
                        KeyType = ImInt(0),
                        Bypass = ImBool(false),
                        Speed = ImInt(1),
                        Legit = ImBool(false),
                        SpeedBasedOnHp = ImBool(false)
                    },
                AntiStun = {
                        Enable = ImBool(false),
                        ChanceEnable = ImBool(false),
                        MinChance = ImInt(0),
                        IncreaseMinChance = ImInt(0),
                        Timer = ImInt(0),
                        Velocity = ImBool(false),
                        AFK = ImBool(false),
                        Chance,
                        On = 0,
                        SaveDamageHP = 0,
                        SaveDamageAR = 0
                    },
                FakeLagPeek = {
                        Enable = ImBool(false),
                        DrawWalls = ImBool(false),
                        AtTarget = ImBool(false),
                        DistanceFromWall = ImInt(2),
                        Fov = ImFloat(0),
                        Time = ImInt(0),
                        Delay = ImInt(0),
                        Ready = {},
                        Wall = ImBool(false)
                    },
                bUseCJWalk = ImBool(false),
                RunEverywhere = ImBool(false),
                ForceSkin = ImBool(false),
                ChosenSkin = ImInt(230),
                NoAnimations = ImBool(false),
                NoFall = ImBool(false),
                NoFallNodamage = ImBool(false),
                Fight = ImBool(false),
                FightStyle = ImInt(0)
            }
        local Extra = {
                AutoDeleteWeapon = {
                        Slot0 = {
                                brass = ImBool(false)
                            },
                        Slot1 = {
                                golf = ImBool(false),
                                nitestick = ImBool(false),
                                knife = ImBool(false),
                                bat = ImBool(false),
                                shovel = ImBool(false),
                                pool = ImBool(false),
                                katana = ImBool(false),
                                chainsaw = ImBool(false)
                            },
                        Slot2 = {
                                colt = ImBool(false),
                                silenced = ImBool(false),
                                desert = ImBool(false)
                            },
                        Slot3 = {
                                shotgun = ImBool(false),
                                sawnoff = ImBool(false),
                                spas = ImBool(false)
                            },
                        Slot4 = {
                                uzi = ImBool(false),
                                mp5 = ImBool(false),
                                tec9 = ImBool(false)
                            },
                        Slot5 = {
                                ak47 = ImBool(false),
                                m4 = ImBool(false)
                            },
                        Slot6 = {
                                cuntgun = ImBool(false),
                                sniper = ImBool(false)
                            },
                        Slot7 = {
                                rocket = ImBool(false),
                                heatseeker = ImBool(false),
                                flamethrower = ImBool(false),
                                minigun = ImBool(false)
                            },
                        Slot8 = {
                                satchel = ImBool(false),
                                grenade = ImBool(false),
                                teargas = ImBool(false)
                            },
                        Slot9 = {
                                spraycan = ImBool(false),
                                extinguisher = ImBool(false),
                                camera = ImBool(false)
                            },
                        Slot10 = {
                                purple = ImBool(false),
                                dildo = ImBool(false),
                                vibrator = ImBool(false),
                                silver = ImBool(false),
                                flowers = ImBool(false),
                                cane = ImBool(false)
                            },
                        Slot11 = {
                                night = ImBool(false),
                                thermal = ImBool(false),
                                Parachute = ImBool(false)
                            },
                        Slot12 = {
                                detonator = ImBool(false)
                            }
                    },
                fuckKeyStrokes =
                    {
                        Enable = ImBool(false),
                        Mode = ImInt(0),
                        Key = 
                            {
                                fire = ImBool(false),
                                aim = ImBool(false),
                                horn_crouch = ImBool(false),
                                enterExitCar = ImBool(false),
                                sprint = ImBool(false),
                                jump = ImBool(false),
                                landingGear_lookback = ImBool(false),
                                walk = ImBool(false),
                                tab = ImBool(false)
                            },
                    },
                RemoveObjectTemp =
                    {
                        Enable = ImBool(false),
                        Key = ImInt(0),
                        Time = ImInt(1000),
                    },
                AutoReply = 
                    {
                        [0] = ImBool(false),
                        [1] = ImBool(false),
                        [2] = ImBool(false),
                    },
                Message = 
                    {
                        [1] = ImBuffer("nothing",255),
                        [2] = ImBuffer("nothing",255),
                    },
                Reply = 
                    {
                        [1] = ImBuffer("nothing",255),
                        [2] = ImBuffer("nothing",255),
                    },
                ExtraWS = 
                    {
                        Enable = ImBool(false),
                        OnKey = ImBool(false),
                        Key = ImInt(1),
                        KeyType = ImInt(0),
                        X = ImBool(false),
                        Y = ImBool(false),
                        PerCategory = 
                            {
                                Enable = ImBool(false),
                                Pistols = ImBool(false),
                                Shotguns = ImBool(false),
                                SMGs = ImBool(false),
                                Rifles = ImBool(false),
                                Snipers = ImBool(false)
                            }
                    },
                IgnoreWater = ImBool(false),
                AntiAFK = ImBool(false),
                SetWeaponSkill = ImBool(false),
                SetWeaponSkillLevel = ImInt(0), 
                SendCMD = {
                    Enable = ImBool(false),
                    Command = ImBuffer("healme",20),
                    Times = ImInt(1),
                    Delay = ImInt(2000),
                    HP = ImInt(0),
                    Armour = ImInt(0)
                },
                PickUP = { 
                    Enable = ImBool(false),
                    Model1 = ImInt(11736),
                    Model2 = ImInt(11738),
                    Model3 = ImInt(1242),
                    Delay = ImInt(1000),
                    HP = ImInt(100),
                    Armour = ImInt(10)
                },
                RequestSpawn = ImBool(false),
                RequestSpawnHP = ImInt(0),
                RequestSpawnArmour = ImInt(0),
                Mobile = ImBool(false),
                AntiFreeze = ImBool(false),
                AntiSniper = ImBool(false),
                AntiSniperTypeMode = ImInt(1),
                AntiSniperChance = ImInt(50),
                AntiSlapper = ImBool(false),
                ForceGravity = ImBool(false),
                GravityFloat = ImFloat(0),
                SpecialAction = ImInt(0)
            }
        local Commands = {
                Filters = ImBool(),
                FiltersChosen = ImBuffer("/addfilter", 255),
                CreateVeh = ImBool(),
                CreateVehNormal = ImBuffer("/cveh", 255),
                CreateVehInvisible = ImBuffer("/iveh", 255),
                SetSkin = ImBool(),
                SetSkinChosen = ImBuffer("/sskin", 255),
                GiveWeapon = ImBool(),
                GiveWeaponChosen = ImBuffer("/gweap", 255),
                SetSpecialAction = ImBool(),
                SetSpecialActionChosen = ImBuffer("/action", 255)
            }
        local Doublejump = {
                Enable = ImBool(false),
                Height = ImFloat(0.1),
                OnKey = ImBool(false),
                Key = ImInt(16)
            }
        local NOPs = {
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
        local KeyToggle = {
                Silent = ImInt(0),
                AimAssist = ImInt(0),
                Damager = ImInt(0),
                ChangeDamage = ImInt(0),
                ExtraWS = ImInt(0),
                RVanka = ImInt(0),
                MacroRun = ImInt(0)
            }
    local SHAcKvar = {
            slidecancel = 0,
            damagerhitEnPos = CVector(),
            damagerhitMyPos = CVector(),
            WeaponSlotCombo = ImInt(0),
            Fly = 1,
            rVankanEWVAR = 0,
            DamagerToggleH = 0,
            DamagerVehicleID = 0,
            pedAngle = 0,
            carAngle = 0,
            damagerBone = 0,
            silentBone = 0,
            SaveVehicle = 0,
            SaveObjectTimer = 0,
            SaveObjectPos = {},
            SaveObjectDelay = {},
            SaveObject = 0,
            AimAssistAiming = 0,
            AimAssistAimingTime = 0,
            AimAssist = nil,
            AimAssist2 = nil,
            AimAssist3 = nil,
            AimAssistDelay = 0,
            AimAssistTarget = {},
            CJWalk = 0,
            AfterDamage = {},
            AfterDamageName = {},
            AfterDamageDelayPer = {},
            ShotsTaken = 0,
            Speed = 0,
            SaveSpeedX = 0,
            SaveSpeedY = 0,
            Duration = 0,
            DelayAntiStun = 0,
            SwitchVelocity = 
                {
                    [0] = 1,
                    [1] = 0
                },
            toSlide = ImInt(0),
            SpeedSlide = ImInt(0),
            canSlide = ImInt(0),
            Switch = ImInt(-2),
            Aiming = ImInt(0),
            FiredGun = ImInt(0),
            SlideWeapon = ImInt(0),
            savedWeaponToSlide = ImInt(0),
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
            AntiSniperCount = 0,
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
            RequestingSpawn = 0,
            SavePosForSpawn = 0,
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
            SpeedY = 0
        }
    local weaponInfo = {}
        weaponInfo[0] =  { id = 0,  slot = 0,  name = "Fist",                     distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 1136, animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false}
        weaponInfo[1] =  { id = 1,  slot = 0,  name = "Brass Knuckles",           distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 1136, animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false}
        weaponInfo[2] =  { id = 2,  slot = 1,  name = "Golf Club",                distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[3] =  { id = 3,  slot = 1,  name = "Nitestick",                distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 19,   animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[4] =  { id = 4,  slot = 1,  name = "Knife",                    distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 751,  animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[5] =  { id = 5,  slot = 1,  name = "Bat",                      distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = true }
        weaponInfo[6] =  { id = 6,  slot = 1,  name = "Shovel",                   distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = true }
        weaponInfo[7] =  { id = 7,  slot = 1,  name = "Pool Cue",                 distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 17,   animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = true }
        weaponInfo[8] =  { id = 8,  slot = 1,  name = "Katana",                   distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 1545, animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[9] =  { id = 9,  slot = 1,  name = "Chainsaw",                 distance = 1.6,   damage = 27.060001, own = false, ammo = 0, clipammo = 0, animations = 320,  animationsflag = 32772, weaponstate = 63,  cammode = 4,  twohanded = true }
        weaponInfo[10] = { id = 10, slot = 10, name = "Purple Dildo",             distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 423,  animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[11] = { id = 11, slot = 10, name = "Dildo",                    distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 749,  animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[12] = { id = 12, slot = 10, name = "Vibrator",                 distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 423,  animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[13] = { id = 13, slot = 10, name = "Silver Vibrator",          distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 749,  animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[14] = { id = 14, slot = 10, name = "Flowers",                  distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 533,  animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[15] = { id = 15, slot = 10, name = "Cane",                     distance = 1.6,   damage = 5.28,      own = false, ammo = 0, clipammo = 0, animations = 1547, animationsflag = 32776, weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[16] = { id = 16, slot = 8,  name = "Grenade",                  distance = 40.0,  damage = 82.5,      own = false, ammo = 0, clipammo = 0, animations = 644,  animationsflag = 32784, weaponstate = 127, cammode = 4,  twohanded = false }
        weaponInfo[17] = { id = 17, slot = 8,  name = "Teargas",                  distance = 40.0,  damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 644,  animationsflag = 32784, weaponstate = 127, cammode = 4,  twohanded = false }
        weaponInfo[18] = { id = 18, slot = 8,  name = "Molotov",                  distance = 40.0,  damage = 1.0,       own = false, ammo = 0, clipammo = 0, animations = 644,  animationsflag = 32784, weaponstate = 127, cammode = 4,  twohanded = false }
        weaponInfo[19] = { id = 19, slot = -1, name = "Vehicle M4 (custom)",      distance = 90.0,  damage = 9.9,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 18, twohanded = true }
        weaponInfo[20] = { id = 20, slot = -1, name = "Vehicle Minigun (custom)", distance = 75.0,  damage = 46.2,      own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 18, twohanded = true }
        weaponInfo[21] = { id = 21, slot = -1, name = "Vehicle Rocket (custom)",  distance = 300,   damage = 82.5,      own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 18, twohanded = true }
        weaponInfo[22] = { id = 22, slot = 2,  name = "Colt",                     distance = 35.0,  damage = 8.25,      own = false, ammo = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[23] = { id = 23, slot = 2,  name = "Silenced",                 distance = 35.0,  damage = 13.200001, own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false}
        weaponInfo[24] = { id = 24, slot = 2,  name = "Desert Eagle",             distance = 35.0,  damage = 46.200001, own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false}
        weaponInfo[25] = { id = 25, slot = 3,  name = "Shotgun",                  distance = 40.0,  damage = 49.500004, own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 255, cammode = 53, twohanded = true }
        weaponInfo[26] = { id = 26, slot = 3,  name = "Sawnoff",                  distance = 35.0,  damage = 49.500004, own = false, ammo = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false}
        weaponInfo[27] = { id = 27, slot = 3,  name = "Spas",                     distance = 40.0,  damage = 29.700001, own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = true }
        weaponInfo[28] = { id = 28, slot = 4,  name = "Uzi",                      distance = 35.0,  damage = 6.6,       own = false, ammo = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[29] = { id = 29, slot = 4,  name = "Mp5",                      distance = 45.0,  damage = 8.25,      own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[30] = { id = 30, slot = 5,  name = "Ak47",                     distance = 70.0,  damage = 9.900001,  own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 155, cammode = 53, twohanded = true }
        weaponInfo[31] = { id = 31, slot = 5,  name = "M4",                       distance = 90.0,  damage = 9.900001,  own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 155, cammode = 53, twohanded = true }
        weaponInfo[32] = { id = 32, slot = 4,  name = "Tec9",                     distance = 35.0,  damage = 6.6,       own = false, ammo = 0, clipammo = 0, animations = 363,  animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[33] = { id = 33, slot = 6,  name = "Cuntgun",                  distance = 100.0, damage = 24.750002, own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = true }
        weaponInfo[34] = { id = 34, slot = 6,  name = "Sniper",                   distance = 320.0, damage = 41.25,     own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 171, cammode = 7,  twohanded = true }
        weaponInfo[35] = { id = 35, slot = 7,  name = "Rocket Launcher",          distance = 55.0,  damage = 82.5,      own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 171, cammode = 8,  twohanded = true }
        weaponInfo[36] = { id = 36, slot = 7,  name = "HeatSeeker",               distance = 55.0,  damage = 82.5,      own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 171, cammode = 51, twohanded = true }
        weaponInfo[37] = { id = 37, slot = 7,  name = "Flamethrower",             distance = 5.1,   damage = 1.0,       own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 191, cammode = 53, twohanded = true }
        weaponInfo[38] = { id = 38, slot = 7,  name = "Minigun",                  distance = 75.0,  damage = 46.2,      own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32766, weaponstate = 191, cammode = 53, twohanded = true }
        weaponInfo[39] = { id = 39, slot = 8,  name = "Satchel",                  distance = 40.0,  damage = 82.5,      own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 127, cammode = 4,  twohanded = false }
        weaponInfo[40] = { id = 40, slot = 12, name = "Detonator",                distance = 25.0,  damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 127, cammode = 4,  twohanded = false }
        weaponInfo[41] = { id = 41, slot = 9,  name = "Spraycan",                 distance = 6.1,   damage = 0.33,      own = false, ammo = 0, clipammo = 0, animations = 1164, animationsflag = 32776, weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[42] = { id = 42, slot = 9,  name = "Extinguisher",             distance = 10.1,  damage = 0.33,      own = false, ammo = 0, clipammo = 0, animations = 1167, animationsflag = 32776, weaponstate = 191, cammode = 53, twohanded = true }
        weaponInfo[43] = { id = 43, slot = 9,  name = "Camera",                   distance = 100.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 46, twohanded = false }
        weaponInfo[44] = { id = 44, slot = 11, name = "Nightvision",              distance = 100.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[45] = { id = 45, slot = 11, name = "Infraredvision",           distance = 100.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[46] = { id = 46, slot = 11, name = "Parachute",                distance = 1.6,   damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 63,  cammode = 4,  twohanded = false }
        weaponInfo[47] = { id = 47, slot = -1, name = "Cellphone",                distance = 300.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[48] = { id = 48, slot = -1, name = "Jetpack",                  distance = 300.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[49] = { id = 49, slot = -1, name = "Vehicle",                  distance = 300.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[50] = { id = 50, slot = -1, name = "Helicopter Blades",        distance = 300.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 53, twohanded = false }
        weaponInfo[51] = { id = 51, slot = -1, name = "Random",                   distance = 300.0, damage = 0.0,       own = false, ammo = 0, clipammo = 0, animations = 0,    animationsflag = 0,     weaponstate = 191, cammode = 53, twohanded = false }
    local fWeaponName = ""
        for i = 0, #weaponInfo do
            local weaponData = weaponInfo[i]
            if weaponData and weaponData.name and weaponData.name ~= "nil" then
                fWeaponName = fWeaponName .. weaponData.name .. "\0"
            end
        end
    local VehicleType = {}
        VehicleType.Car = 0
        VehicleType.Bike = 1
        VehicleType.Bicycle = 2
        VehicleType.RC = 3
        VehicleType.Heli = 4
        VehicleType.Boat = 5
        VehicleType.Plane = 6
        VehicleType.Train = 7
        VehicleType.Trailer = 8
    local vehicleInfo = {}    
    local fPlayerBone = {
            3, --	TORSO
            4, --	GROIN
            5, --	LEFT_ARM 
            6, --	RIGHT_ARM
            7, --	LEFT_LEG
            8, --	RIGHT_LEG
            9 --	HEAD
        }
    local fCheatBone = {
            3, --  TORSO
            1, --  GROIN
            33, --  Left upper arm
            23, --  Right upper arm
            52, --  Left thigh
            42, --  Right thigh
            8 --  Head
        }
    local sRunAnimations = {
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
    local players = {
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
    local objects = {
            fov = {}
        }
    local vehicles = {
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
    local vehicleParts = {
            panels = {},
            doors = {}, 
            lights = {},
            tires = {}
        }
    local SilentStuff = {
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
    local SampKeys = {
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
    local RPC = {}
    local CVehicleST = Utils:readMemory(0xB6F980, 4, false)
    local CPedST = Utils:readMemory(0xB6F5F0, 4, false)
    local memory = {
            ExtraWS = {},
            CPed = {},
            CVehicle = {}
        }
    local vMy = {}
    local vAmI = {}
    local vEn = {
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
    local m_offsets = {}
        m_offsets.m_samp_info = {0x21A0F8, 0, 0x26E8DC, 0, 0, 0x2ACA24}
        m_offsets.m_settings = {0x3C5, 0, 0x3D5, 0, 0, 0x3D5}
        m_offsets.m_game_state = {0x3BD, 0, 0x3CD, 0, 0, 0x3CD}
        m_offsets.m_pools = {0x3CD, 0, 0x3DE, 0, 0, 0x3DE}
        
        m_offsets.m_server_addr = {0x20, 0, 0x30, 0, 0, 0x30}
        m_offsets.m_server_port = {0x225, 0, 0x235, 0, 0, 0x235}
    local OnFootData = {}
    local BulletData = {}
    local AimData = {}
    local get = {}
    local set = {}
    local maths = {}
    local read = {}
    local send = {}
    local Pickups = {}
-- 
--! Variables
    local v =
        {
            PickUP = 0,
            SendCMD = 0,
            SampVer = Utils:getSampVer()+1,
            SampAdr = Utils:getSampDLL(),
            StunTimer = 0,
            StunCount = Movement.AntiStun.MinChance.v,
            SmartStunCount = 0,
            SniperProt = 0,
            KBDraw1 = 0,
            KBDraw2 = 0,
            cefini = 0,
            Wait = 0,
            shooting = 0,
            TargetFakeLag = -1,
            enteringvehicle = 0,
            filteringid = -1,
            filterIdtoSHAk = -1,
            filterSkintoSHAk = -1,
            filtertimer = 0,
            AutoReply2 = 0,
            SilentPlayerID = -1,
            DamagerPlayerID = -1,
            getCrosshair = 1,
            CrosshairTimer = 0,
            NoFall = 0, 
            TeleportCounter = 0,
            Cfgbrokenlines = 0,
            lastweapon = -1,
            Hww2 = 0,
            menutyped = 0,
            button = 0,
            ConfigsDefault = {},
            ConfigsDefaults = "Default",
            Overwritetimer = 0,
            HideDraws = {},
            ShowDraws = {},
            WaitForPickLag = 0,
            DamagerCbug = 0,
            DrivingPlayerID = -1,
            Troller = -1,
            savedNoTirePop = 0,
            iCamModeCount = 0,
            fuckerpertimer = {},
            Bypass = 0,
            ACBypass = 0,
            bufferLength = 30,
            bufferText = "                              SHAcKled",
            BuffShackled = 0,
            colorBorder1 = 0,
            colorBorder2 = 0,
            colorShackled = 0,
            IndicatorIntervals = {},
            startValue = 0,
            endValue = 2
        }
    Shackled = {}
        Shackled[1] = ImBuffer("SHAcKled", v.bufferLength)

        for i = 1, 64 do
            Shackled[i] = ImBuffer(v.bufferText .. string.rep(" ", (34-i)*2), v.bufferLength)
            v.bufferText = string.sub(v.bufferText, 2)
        end
        v.BuffShackled = Shackled[1].v

        for i = 1, 64 do
            v.IndicatorIntervals[i] = {v.startValue, v.endValue}
            v.startValue = v.endValue
            v.endValue = v.endValue + 2
        end

--
--! CFG
    function get.RPC()
        RPC = {
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "SetPlayerName", 
            "SetPlayerPos", 
            "SetPlayerPosFindZ", 
            "SetPlayerHealth",
            "TogglePlayerControllable",
            "PlayerPlaySound",
            "SetWorldBound",
            "GivePlayerMoney",
            "setPlayerZAngle",
            "ResetPlayerMoney",
            "ResetPlayerWeapons",
            "GivePlayerWeapon",
            "OnPlayerClickPlayer",
            "nil",
            "ClientJoin",
            "SendPlayerEnterVehicle",
            "SelectObject", 
            "CancelEdit", 
            "SetPlayerTime",
            "ToggleClock",
            "nil",
            "WorldPlayerAdd",
            "nil",
            "SetPlayerSkillLevel",
            "nil",
            "nil",
            "DisableCheckpoint", 
            "SetRaceCheckpoint", 
            "DisableRaceCheckpoint", 
            "nil",
            "PlayAudioStream",
            "StopAudioStream",
            "RemoveBuilding",
            "CreateObject", 
            "SetObjectPos", 
            "SetObjectRotation",  
            "DestroyObject", 
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "NPCJoin",
            "SendDeathMessage",
            "SetPlayerMapIcon",  
            "RemoveVehicleComponent",
            "Update3DTextLabel",
            "ChatBubble",
            "nil", 
            "ShowDialog",
            "nil",
            "nil",
            "nil",
            "LinkVehicleToInterior",
            "SetPlayerArmour",
            "SetArmedWeapon",
            "SetSpawnInfo",
            "SetPlayerTeam",
            "SendPutPlayerInVehicle",
            "RemovePlayerFromVehicle",
            "SetPlayerColor",
            "ShowGameText", 
            "ForceClassSelection",
            "AttachObjectToPlayer",  
            "nil",
            "ShowMenu", 
            "HideMenu", 
            "CreateExplosion",
            "ShowPlayerNameTag", 
            "nil",
            "nil",
            "SelectTextDraw / OnPlayerClickTextDraw",
            "SetPlayerObjectMaterial(Text)",
            "GangZoneStopFlash", 
            "ApplyPlayerAnimation",  
            "ClearPlayerAnimation",  
            "SetPlayerSpecialAction", 
            "SetPlayerFightingStyle",
            "SetPlayerVelocity",
            "SetVehicleVelocity",
            "nil",
            "SendClientMessage",
            "SetWorldTime",
            "CreatePickup", 
            "OnEnterExitModShop",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "nil",
            "ClientCheckResponse",
            "EnableStuntBonus",
            "TextDrawSetString",
            "UpdateVehicleDamageStatus",
            "SetCheckpoint", 
            "AddGangZone", 
            "nil",
            "nil",
            "ToggleWidescreen",
            "nil",
            "SetPlayerAttachedObject",
            "nil",
            "GiveTakeDamage",
            "OnPlayerEditAttachedObject",
            "OnPlayerEditObject",
            "nil",
            "ClickMap",
            "GangZoneDestroy",
            "GangZoneFlash",
            "StopObject",
            "SetVehicleNumberPlate",
            "TogglePlayerSpectating",
            "nil",
            "SpectatePlayer", 
            "SpectateVehicle", 
            "RequestClass",
            "SpawnPlayer",
            "nil",
            "OnPlayerPickupPickup",
            "OnPlayerSelectedMenuRow",
            "SetPlayerWantedLevel",
            "ShowTextDraw",
            "HideTextDraw",
            "OnVehicleDeath",
            "nil",
            "nil",
            "nil",
            "OnPlayerExitedMenu",
            "nil",
            "nil",
            "nil",
            "RemovePlayerMapIcon", 
            "SetPlayerAmmo",
            "SetGravity",
            "SetVehicleHealth",
            "AtachTrailerFromVehicle",
            "DetachTrailerFromVehicle",
            "nil",
            "nil",
            "SetPlayerWeather",
            "SetPlayerSkin",
            "PlayerExitvehicle",
            "UpdateScoresAndPings", 
            "SetPlayerInterior",
            "SetPlayerCameraPos",
            "SetPlayerCameraLookAt",
            "SetVehiclePos",
            "SetVehicleZAngle",
            "SetVehicleParams",
            "SetPlayerCameraBehindPlayer",
            "WorldPlayerRemove",
            "WorldVehicleAdd",
            "WorldVehicleRemove",
            "DeathBroadcast",  
            "nil",
            "OnCameraTarget",
            "nil",
            "SetTargeting",
            "ShowActor",
            "HideActor", 
            "ApplyActorAnimation", 
            "ClearActorAnimation", 
            "SetActorFacingAngle", 
            "SetActorPos", 
            "nil",
            "SetActorHealth"
        }
        end
        get.RPC()
    function get.vehicleInfoFix()
            vehicleInfo[400] = { id = 400, velocity = 164,  type = VehicleType.Car,     name = "Landstalker" }
            vehicleInfo[401] = { id = 401, velocity = 153,  type = VehicleType.Car,     name = "Bravura" }
            vehicleInfo[402] = { id = 402, velocity = 194,  type = VehicleType.Car,     name = "Buffalo" }
            vehicleInfo[403] = { id = 403, velocity = 114,  type = VehicleType.Car,     name = "Linerunner" }
            vehicleInfo[404] = { id = 404, velocity = 138,  type = VehicleType.Car,     name = "Perennial" }
            vehicleInfo[405] = { id = 405, velocity = 171,  type = VehicleType.Car,     name = "Sentinel" }
            vehicleInfo[406] = { id = 406, velocity = 115,  type = VehicleType.Car,     name = "Dumper" }
            vehicleInfo[407] = { id = 407, velocity = 154,  type = VehicleType.Car,     name = "Firetruck" }
            vehicleInfo[408] = { id = 408, velocity = 104,  type = VehicleType.Car,     name = "Trashmaster" }
            vehicleInfo[409] = { id = 409, velocity = 164,  type = VehicleType.Car,     name = "Stretch" }
            vehicleInfo[410] = { id = 410, velocity = 135,  type = VehicleType.Car,     name = "Manana" }
            vehicleInfo[411] = { id = 411, velocity = 231,  type = VehicleType.Car,     name = "Infernus" }
            vehicleInfo[412] = { id = 412, velocity = 176,  type = VehicleType.Car,     name = "Voodoo" }
            vehicleInfo[413] = { id = 413, velocity = 115,  type = VehicleType.Car,     name = "Pony" }
            vehicleInfo[414] = { id = 414, velocity = 110,  type = VehicleType.Car,     name = "Mule" }
            vehicleInfo[415] = { id = 415, velocity = 200,  type = VehicleType.Car,     name = "Cheetah" }
            vehicleInfo[416] = { id = 416, velocity = 160,  type = VehicleType.Car,     name = "Ambulance" }
            vehicleInfo[417] = { id = 417, velocity = 130,  type = VehicleType.Heli,    name = "Leviathan" }
            vehicleInfo[418] = { id = 418, velocity = 120,  type = VehicleType.Car,     name = "Moonbeam" }
            vehicleInfo[419] = { id = 419, velocity = 155,  type = VehicleType.Car,     name = "Esperanto" }
            vehicleInfo[420] = { id = 420, velocity = 151,  type = VehicleType.Car,     name = "Taxi" }
            vehicleInfo[421] = { id = 421, velocity = 160,  type = VehicleType.Car,     name = "Washington" }
            vehicleInfo[422] = { id = 422, velocity = 146,  type = VehicleType.Car,     name = "Bobcat" }
            vehicleInfo[423] = { id = 423, velocity = 103,  type = VehicleType.Car,     name = "Whoopee" }
            vehicleInfo[424] = { id = 424, velocity = 141,  type = VehicleType.Car,     name = "BF Injection" }
            vehicleInfo[425] = { id = 425, velocity = 170,  type = VehicleType.Heli,    name = "Hunter" }
            vehicleInfo[426] = { id = 426, velocity = 180,  type = VehicleType.Car,     name = "Premier" }
            vehicleInfo[427] = { id = 427, velocity = 172,  type = VehicleType.Car,     name = "Enforcer" }
            vehicleInfo[428] = { id = 428, velocity = 163,  type = VehicleType.Car,     name = "Securicar" }
            vehicleInfo[429] = { id = 429, velocity = 210,  type = VehicleType.Car,     name = "Banshee" }
            vehicleInfo[430] = { id = 430, velocity = 160,  type = VehicleType.Boat,    name = "Predator" }
            vehicleInfo[431] = { id = 431, velocity = 136,  type = VehicleType.Car,     name = "Bus" }
            vehicleInfo[432] = { id = 432, velocity = 98,   type = VehicleType.Car,     name = "Rhino" }
            vehicleInfo[433] = { id = 433, velocity = 115,  type = VehicleType.Car,     name = "Barracks" }
            vehicleInfo[434] = { id = 434, velocity = 174,  type = VehicleType.Car,     name = "Hotknife" }
            vehicleInfo[435] = { id = 435, velocity = 100,  type = VehicleType.Trailer, name = "Article  Trailer" }
            vehicleInfo[436] = { id = 436, velocity = 155,  type = VehicleType.Car,     name = "Previon" }
            vehicleInfo[437] = { id = 437, velocity = 164,  type = VehicleType.Car,     name = "Coach" }
            vehicleInfo[438] = { id = 438, velocity = 150,  type = VehicleType.Car,     name = "Cabbie" }
            vehicleInfo[439] = { id = 439, velocity = 177,  type = VehicleType.Car,     name = "Stallion" }
            vehicleInfo[440] = { id = 440, velocity = 142,  type = VehicleType.Car,     name = "Rumpo" }
            vehicleInfo[441] = { id = 441, velocity = 78,   type = VehicleType.RC,      name = "RC Bandit" }
            vehicleInfo[442] = { id = 442, velocity = 145,  type = VehicleType.Car,     name = "Romero" }
            vehicleInfo[443] = { id = 443, velocity = 131,  type = VehicleType.Car,     name = "Packer" }
            vehicleInfo[444] = { id = 444, velocity = 115,  type = VehicleType.Car,     name = "Monster" }
            vehicleInfo[445] = { id = 445, velocity = 172,  type = VehicleType.Car,     name = "Admiral" }
            vehicleInfo[446] = { id = 446, velocity = 180,  type = VehicleType.Boat,    name = "Squallo" }
            vehicleInfo[447] = { id = 447, velocity = 150,  type = VehicleType.Heli,    name = "Seasparrow" }
            vehicleInfo[448] = { id = 448, velocity = 180,  type = VehicleType.Bike,    name = "Pizzaboy" }
            vehicleInfo[449] = { id = 449, velocity = 1000, type = VehicleType.Train,   name = "Tram" }
            vehicleInfo[450] = { id = 450, velocity = 1000, type = VehicleType.Trailer, name = "Article  Trailer 2" }
            vehicleInfo[451] = { id = 451, velocity = 201,  type = VehicleType.Car,     name = "Turismo" }
            vehicleInfo[452] = { id = 452, velocity = 170,  type = VehicleType.Boat,    name = "Speeder" }
            vehicleInfo[453] = { id = 453, velocity = 70,   type = VehicleType.Boat,    name = "Reefer" }
            vehicleInfo[454] = { id = 454, velocity = 135,  type = VehicleType.Boat,    name = "Tropic" }
            vehicleInfo[455] = { id = 455, velocity = 164,  type = VehicleType.Car,     name = "Flatbed" }
            vehicleInfo[456] = { id = 456, velocity = 110,  type = VehicleType.Car,     name = "Yankee" }
            vehicleInfo[457] = { id = 457, velocity = 99,   type = VehicleType.Car,     name = "Caddy" }
            vehicleInfo[458] = { id = 458, velocity = 164,  type = VehicleType.Car,     name = "Solair" }
            vehicleInfo[459] = { id = 459, velocity = 142,  type = VehicleType.Car,     name = "Topfun Van" }
            vehicleInfo[460] = { id = 460, velocity = 150,  type = VehicleType.Plane,   name = "Skimmer" }
            vehicleInfo[461] = { id = 461, velocity = 214,  type = VehicleType.Bike,    name = "PCJ-600"}
            vehicleInfo[462] = { id = 462, velocity = 195,  type = VehicleType.Bike,    name = "Faggio" }
            vehicleInfo[463] = { id = 463, velocity = 214,  type = VehicleType.Bike,    name = "Freeway" }
            vehicleInfo[464] = { id = 464, velocity = 50,   type = VehicleType.RC,      name = "RC Baron" }
            vehicleInfo[465] = { id = 465, velocity = 60,   type = VehicleType.RC,      name = "RC Raider" }
            vehicleInfo[466] = { id = 466, velocity = 153,  type = VehicleType.Car,     name = "Glendale" }
            vehicleInfo[467] = { id = 467, velocity = 146,  type = VehicleType.Car,     name = "Oceanic" }
            vehicleInfo[468] = { id = 468, velocity = 200,  type = VehicleType.Bike,    name = "Sanchez" }
            vehicleInfo[469] = { id = 469, velocity = 150,  type = VehicleType.Heli,    name = "Sparrow" }
            vehicleInfo[470] = { id = 470, velocity = 163,  type = VehicleType.Car,     name = "Patriot" }
            vehicleInfo[471] = { id = 471, velocity = 115,  type = VehicleType.Bike,    name = "Quad" }
            vehicleInfo[472] = { id = 472, velocity = 130,  type = VehicleType.Boat,    name = "Coastguard" }
            vehicleInfo[473] = { id = 473, velocity = 102,  type = VehicleType.Boat,    name = "Dinghy" }
            vehicleInfo[474] = { id = 474, velocity = 155,  type = VehicleType.Car,     name = "Hermes" }
            vehicleInfo[475] = { id = 475, velocity = 180,  type = VehicleType.Car,     name = "Sabre" }
            vehicleInfo[476] = { id = 476, velocity = 300,  type = VehicleType.Plane,   name = "Rustler" }
            vehicleInfo[477] = { id = 477, velocity = 194,  type = VehicleType.Car,     name = "ZR350" }
            vehicleInfo[478] = { id = 478, velocity = 122,  type = VehicleType.Car,     name = "Walton" }
            vehicleInfo[479] = { id = 479, velocity = 146,  type = VehicleType.Car,     name = "Regina" }
            vehicleInfo[480] = { id = 480, velocity = 192,  type = VehicleType.Car,     name = "Comet" }
            vehicleInfo[481] = { id = 481, velocity = 102,  type = VehicleType.Bicycle, name = "BMX" }
            vehicleInfo[482] = { id = 482, velocity = 163,  type = VehicleType.Car,     name = "Burrito" }
            vehicleInfo[483] = { id = 483, velocity = 128,  type = VehicleType.Car,     name = "Camper" }
            vehicleInfo[484] = { id = 484, velocity = 80,   type = VehicleType.Boat,    name = "Marquis" }
            vehicleInfo[485] = { id = 485, velocity = 103,  type = VehicleType.Car,     name = "Baggage" }
            vehicleInfo[486] = { id = 486, velocity = 67,   type = VehicleType.Car,     name = "Dozer" }
            vehicleInfo[487] = { id = 487, velocity = 200,  type = VehicleType.Heli,    name = "Maverick" }
            vehicleInfo[488] = { id = 488, velocity = 200,  type = VehicleType.Heli,    name = "SAN News Maverick" }
            vehicleInfo[489] = { id = 489, velocity = 145,  type = VehicleType.Car,     name = "Rancher" }
            vehicleInfo[490] = { id = 490, velocity = 163,  type = VehicleType.Car,     name = "FBI Rancher" }
            vehicleInfo[491] = { id = 491, velocity = 155,  type = VehicleType.Car,     name = "Virgo" }
            vehicleInfo[492] = { id = 492, velocity = 146,  type = VehicleType.Car,     name = "Greenwood" }
            vehicleInfo[493] = { id = 493, velocity = 200,  type = VehicleType.Boat,    name = "Jetmax" }
            vehicleInfo[494] = { id = 494, velocity = 225,  type = VehicleType.Car,     name = "Hotring  Racer" }
            vehicleInfo[495] = { id = 495, velocity = 185,  type = VehicleType.Car,     name = "Sandking" }
            vehicleInfo[496] = { id = 496, velocity = 169,  type = VehicleType.Car,     name = "Blista Compact" }
            vehicleInfo[497] = { id = 497, velocity = 200,  type = VehicleType.Heli,    name = "Police  Maverick" }
            vehicleInfo[498] = { id = 498, velocity = 112,  type = VehicleType.Car,     name = "Boxville" }
            vehicleInfo[499] = { id = 499, velocity = 128,  type = VehicleType.Car,     name = "Benson" }
            vehicleInfo[500] = { id = 500, velocity = 146,  type = VehicleType.Car,     name = "Mesa" }
            vehicleInfo[501] = { id = 501, velocity = 50,   type = VehicleType.RC,      name = "RC Goblin" }
            vehicleInfo[502] = { id = 502, velocity = 230,  type = VehicleType.Car,     name = "Hotring Racer A" }
            vehicleInfo[503] = { id = 503, velocity = 230,  type = VehicleType.Car,     name = "Hotring Racer B" }
            vehicleInfo[504] = { id = 504, velocity = 180,  type = VehicleType.Car,     name = "Bloodring Banger" }
            vehicleInfo[505] = { id = 505, velocity = 145,  type = VehicleType.Car,     name = "Rancher Lure" }
            vehicleInfo[506] = { id = 506, velocity = 190,  type = VehicleType.Car,     name = "Super GT" }
            vehicleInfo[507] = { id = 507, velocity = 173,  type = VehicleType.Car,     name = "Elegant" }
            vehicleInfo[508] = { id = 508, velocity = 112,  type = VehicleType.Car,     name = "Journey" }
            vehicleInfo[509] = { id = 509, velocity = 110,  type = VehicleType.Bicycle, name = "Bike" }
            vehicleInfo[510] = { id = 510, velocity = 140,  type = VehicleType.Bicycle, name = "Mountain Bike" }
            vehicleInfo[511] = { id = 511, velocity = 300,  type = VehicleType.Plane,   name = "Beagle" }
            vehicleInfo[512] = { id = 512, velocity = 300,  type = VehicleType.Plane,   name = "Cropduster" }
            vehicleInfo[513] = { id = 513, velocity = 300,  type = VehicleType.Plane,   name = "Stuntplane" }
            vehicleInfo[514] = { id = 514, velocity = 125,  type = VehicleType.Car,     name = "Tanker" }
            vehicleInfo[515] = { id = 515, velocity = 148,  type = VehicleType.Car,     name = "Roadtrain" }
            vehicleInfo[516] = { id = 516, velocity = 164,  type = VehicleType.Car,     name = "Nebula" }
            vehicleInfo[517] = { id = 517, velocity = 164,  type = VehicleType.Car,     name = "Majestic" }
            vehicleInfo[518] = { id = 518, velocity = 171,  type = VehicleType.Car,     name = "Buccaneer" }
            vehicleInfo[519] = { id = 519, velocity = 283,  type = VehicleType.Plane,   name = "Shamal" }
            vehicleInfo[520] = { id = 520, velocity = 283,  type = VehicleType.Plane,   name = "Hydra" }
            vehicleInfo[521] = { id = 521, velocity = 220,  type = VehicleType.Bike,    name = "FCR900" }
            vehicleInfo[522] = { id = 522, velocity = 220,  type = VehicleType.Bike,    name = "NRG500" }
            vehicleInfo[523] = { id = 523, velocity = 200,  type = VehicleType.Bike,    name = "HPV1000" }
            vehicleInfo[524] = { id = 524, velocity = 135,  type = VehicleType.Car,     name = "Cement Truck" }
            vehicleInfo[525] = { id = 525, velocity = 167,  type = VehicleType.Car,     name = "Towtruck" }
            vehicleInfo[526] = { id = 526, velocity = 164,  type = VehicleType.Car,     name = "Fortune" }
            vehicleInfo[527] = { id = 527, velocity = 155,  type = VehicleType.Car,     name = "Cadrona" }
            vehicleInfo[528] = { id = 528, velocity = 185,  type = VehicleType.Car,     name = "FBI Truck" }
            vehicleInfo[529] = { id = 529, velocity = 155,  type = VehicleType.Car,     name = "Willard" }
            vehicleInfo[530] = { id = 530, velocity = 63,   type = VehicleType.Car,     name = "Forklift" }
            vehicleInfo[531] = { id = 531, velocity = 73,   type = VehicleType.Car,     name = "Tractor" }
            vehicleInfo[532] = { id = 532, velocity = 115,  type = VehicleType.Car,     name = "Combine Harvester" }
            vehicleInfo[533] = { id = 533, velocity = 174,  type = VehicleType.Car,     name = "Feltzer" }
            vehicleInfo[534] = { id = 534, velocity = 176,  type = VehicleType.Car,     name = "Remington" }
            vehicleInfo[535] = { id = 535, velocity = 165,  type = VehicleType.Car,     name = "Slamvan" }
            vehicleInfo[536] = { id = 536, velocity = 180,  type = VehicleType.Car,     name = "Blade" }
            vehicleInfo[537] = { id = 537, velocity = 300,  type = VehicleType.Train,   name = "Freight " }
            vehicleInfo[538] = { id = 538, velocity = 300,  type = VehicleType.Train,   name = "Brownstreak " }
            vehicleInfo[539] = { id = 539, velocity = 170,  type = VehicleType.Car,     name = "Vortex" }
            vehicleInfo[540] = { id = 540, velocity = 155,  type = VehicleType.Car,     name = "Vincent" }
            vehicleInfo[541] = { id = 541, velocity = 211,  type = VehicleType.Car,     name = "Bullet" }
            vehicleInfo[542] = { id = 542, velocity = 171,  type = VehicleType.Car,     name = "Clover" }
            vehicleInfo[543] = { id = 543, velocity = 157,  type = VehicleType.Car,     name = "Sadler" }
            vehicleInfo[544] = { id = 544, velocity = 149,  type = VehicleType.Car,     name = "Firetruck LA" }
            vehicleInfo[545] = { id = 545, velocity = 150,  type = VehicleType.Car,     name = "Hustler" }
            vehicleInfo[546] = { id = 546, velocity = 160,  type = VehicleType.Car,     name = "Intruder" }
            vehicleInfo[547] = { id = 547, velocity = 151,  type = VehicleType.Car,     name = "Primo" }
            vehicleInfo[548] = { id = 548, velocity = 164,  type = VehicleType.Heli,    name = "Cargobob" }
            vehicleInfo[549] = { id = 549, velocity = 126,  type = VehicleType.Car,     name = "Tampa" }
            vehicleInfo[550] = { id = 550, velocity = 300,  type = VehicleType.Car,     name = "Sunrise" }
            vehicleInfo[551] = { id = 551, velocity = 150,  type = VehicleType.Car,     name = "Merit" }
            vehicleInfo[552] = { id = 552, velocity = 165,  type = VehicleType.Car,     name = "Utility Van" }
            vehicleInfo[553] = { id = 553, velocity = 115,  type = VehicleType.Plane,   name = "Nevada" }
            vehicleInfo[554] = { id = 554, velocity = 115,  type = VehicleType.Car,     name = "Yosemite" }
            vehicleInfo[555] = { id = 555, velocity = 163,  type = VehicleType.Car,     name = "Windsor" }
            vehicleInfo[556] = { id = 556, velocity = 185,  type = VehicleType.Car,     name = "Monster A" }
            vehicleInfo[557] = { id = 557, velocity = 176,  type = VehicleType.Car,     name = "Monster B" }
            vehicleInfo[558] = { id = 558, velocity = 165,  type = VehicleType.Car,     name = "Uranus" }
            vehicleInfo[559] = { id = 559, velocity = 185,  type = VehicleType.Car,     name = "Jester" }
            vehicleInfo[560] = { id = 560, velocity = 250,  type = VehicleType.Car,     name = "Sultan" }
            vehicleInfo[561] = { id = 561, velocity = 92,   type = VehicleType.Car,     name = "Stratum" }
            vehicleInfo[562] = { id = 562, velocity = 173,  type = VehicleType.Car,     name = "Elegy" }
            vehicleInfo[563] = { id = 563, velocity = 167,  type = VehicleType.Heli,    name = "Raindance" }
            vehicleInfo[564] = { id = 564, velocity = 180,  type = VehicleType.RC,      name = "RC Tiger" }
            vehicleInfo[565] = { id = 565, velocity = 152,  type = VehicleType.Car,     name = "Flash" }
            vehicleInfo[566] = { id = 566, velocity = 300,  type = VehicleType.Car,     name = "Tahoma" }
            vehicleInfo[567] = { id = 567, velocity = 300,  type = VehicleType.Car,     name = "Savanna" }
            vehicleInfo[568] = { id = 568, velocity = 97,   type = VehicleType.Car,     name = "Bandito" }
            vehicleInfo[569] = { id = 569, velocity = 63,   type = VehicleType.Train,   name = "Freight Flat Trailer" }
            vehicleInfo[570] = { id = 570, velocity = 115,  type = VehicleType.Car,     name = "Streak  Trailer" }
            vehicleInfo[571] = { id = 571, velocity = 63,   type = VehicleType.Car,     name = "Kart" }
            vehicleInfo[572] = { id = 572, velocity = 164,  type = VehicleType.Car,     name = "Mower" }
            vehicleInfo[573] = { id = 573, velocity = 164,  type = VehicleType.Car,     name = "Dune" }
            vehicleInfo[574] = { id = 574, velocity = 300,  type = VehicleType.Car,     name = "Sweeper" }
            vehicleInfo[575] = { id = 575, velocity = 135,  type = VehicleType.Car,     name = "Broadway" }
            vehicleInfo[576] = { id = 576, velocity = 164,  type = VehicleType.Car,     name = "Tornado" }
            vehicleInfo[577] = { id = 577, velocity = 160,  type = VehicleType.Plane,   name = "AT400" }
            vehicleInfo[578] = { id = 578, velocity = 200,  type = VehicleType.Car,     name = "DFT-30"}
            vehicleInfo[579] = { id = 579, velocity = 142,  type = VehicleType.Car,     name = "Huntley" }
            vehicleInfo[580] = { id = 580, velocity = 89,   type = VehicleType.Car,     name = "Stafford" }
            vehicleInfo[581] = { id = 581, velocity = 300,  type = VehicleType.Bike,    name = "BF-400" }
            vehicleInfo[582] = { id = 582, velocity = 159,  type = VehicleType.Car,     name = "Newsvan" }
            vehicleInfo[583] = { id = 583, velocity = 200,  type = VehicleType.Car,     name = "Tug" }
            vehicleInfo[584] = { id = 584, velocity = 173,  type = VehicleType.Trailer, name = "Petrol Trailer" }
            vehicleInfo[585] = { id = 585, velocity = 169,  type = VehicleType.Car,     name = "Emperor" }
            vehicleInfo[586] = { id = 586, velocity = 300,  type = VehicleType.Bike,    name = "Wayfarer" }
            vehicleInfo[587] = { id = 587, velocity = 300,  type = VehicleType.Car,     name = "Euros" }
            vehicleInfo[588] = { id = 588, velocity = 300,  type = VehicleType.Car,     name = "Hotdog" }
            vehicleInfo[589] = { id = 589, velocity = 300,  type = VehicleType.Car,     name = "Club" }
            vehicleInfo[590] = { id = 590, velocity = 63,   type = VehicleType.Trailer, name = "Freight Box Trailer" }
            vehicleInfo[591] = { id = 591, velocity = 110,  type = VehicleType.Trailer, name = "Article Trailer 3" }
            vehicleInfo[592] = { id = 592, velocity = 183,  type = VehicleType.Plane,   name = "Andromada" }
            vehicleInfo[593] = { id = 593, velocity = 183,  type = VehicleType.Plane,   name = "Dodo" }
            vehicleInfo[594] = { id = 594, velocity = 183,  type = VehicleType.RC,      name = "RC Cam" }
            vehicleInfo[595] = { id = 595, velocity = 164,  type = VehicleType.Boat,    name = "Launch" }
            vehicleInfo[596] = { id = 596, velocity = 157,  type = VehicleType.Car,     name = "Police Car LSPD" }
            vehicleInfo[597] = { id = 597, velocity = 115,  type = VehicleType.Car,     name = "Police Car SFPD" }
            vehicleInfo[598] = { id = 598, velocity = 176,  type = VehicleType.Car,     name = "Police Car LVPD" }
            vehicleInfo[599] = { id = 599, velocity = 178,  type = VehicleType.Car,     name = "Police Ranger" }
            vehicleInfo[600] = { id = 600, velocity = 153,  type = VehicleType.Car,     name = "Picador" }
            vehicleInfo[601] = { id = 601, velocity = 157,  type = VehicleType.Car,     name = "SWAT" }
            vehicleInfo[602] = { id = 602, velocity = 103,  type = VehicleType.Car,     name = "Alpha" }
            vehicleInfo[603] = { id = 603, velocity = 103,  type = VehicleType.Car,     name = "Phoenix" }
            vehicleInfo[604] = { id = 604, velocity = 100,  type = VehicleType.Car,     name = "Glendale Shit" }
            vehicleInfo[605] = { id = 605, velocity = 112,  type = VehicleType.Car,     name = "Sadler Shit" }
            vehicleInfo[606] = { id = 606, velocity = 100,  type = VehicleType.Trailer, name = "Baggage Trailer A" }
            vehicleInfo[607] = { id = 607, velocity = 100,  type = VehicleType.Trailer, name = "Baggage Trailer B" }
            vehicleInfo[608] = { id = 608, velocity = 100,  type = VehicleType.Trailer, name = "Tug Stairs Trailer" }
            vehicleInfo[609] = { id = 609, velocity = 100,  type = VehicleType.Car,     name = "Boxville" }
            vehicleInfo[610] = { id = 610, velocity = 100,  type = VehicleType.Trailer, name = "Farm Trailer" }
            vehicleInfo[611] = { id = 611, velocity = 100,  type = VehicleType.Trailer, name = "Utility Trailer" }
        end
    function get.AllMyVariables()
        --MyVars
            vMy.ID = Players:getLocalID()
            vAmI.Driver = Players:isDriver(vMy.ID)
            vAmI.Passenger = false
            if not vAmI.Driver then
                vAmI.Passenger = Players:Driving(vMy.ID)
            end
            vMy.ICData = Players:getInCarData(vMy.ID)
            vMy.OFData = Players:getOnFootData(vMy.ID)
            vMy.Vehicle = Players:getVehicleID(vMy.ID)
            vMy.VehicleModel = Cars:getCarModel(vMy.Vehicle)
            vMy.Weapon = Players:getPlayerWeapon(vMy.ID)
            vMy.Pos = Players:getPlayerPosition(vMy.ID)
            vMy.Color = Players:getPlayerColor(vMy.ID)
            vMy.HP = Players:getPlayerHP(vMy.ID)
            vMy.Armor = Players:getPlayerArmour(vMy.ID)
            vMy.Name = Players:getPlayerName(vMy.ID)
        end
        get.AllMyVariables()
    function get.FovfromConfig()
            if SilentStuff.PistolFov ~= Silent.Pistols.Fov.v*20 then
                SilentStuff.PistolFov = Silent.Pistols.Fov.v*20
            end
            if SilentStuff.PistolFov2 ~= Silent.Pistols.FirstShots.Fov.v*20 then
                SilentStuff.PistolFov2 = Silent.Pistols.FirstShots.Fov.v*20
            end
            if SilentStuff.SMGFov ~= Silent.Smgs.Fov.v*20 then
                SilentStuff.SMGFov = Silent.Smgs.Fov.v*20
            end
            if SilentStuff.SMGFov2 ~= Silent.Smgs.FirstShots.Fov.v*20 then
                SilentStuff.SMGFov2 = Silent.Smgs.FirstShots.Fov.v*20
            end
            if SilentStuff.ShotgunFov ~= Silent.Shotguns.Fov.v*20 then
                SilentStuff.ShotgunFov = Silent.Shotguns.Fov.v*20
            end
            if SilentStuff.ShotgunFov2 ~= Silent.Shotguns.FirstShots.Fov.v*20 then
                SilentStuff.ShotgunFov2 = Silent.Shotguns.FirstShots.Fov.v*20
            end
            if SilentStuff.RifleFov ~= Silent.Rifles.Fov.v*20 then
                SilentStuff.RifleFov = Silent.Rifles.Fov.v*20
            end
            if SilentStuff.RifleFov2 ~= Silent.Rifles.FirstShots.Fov.v*20 then
                SilentStuff.RifleFov2 = Silent.Rifles.FirstShots.Fov.v*20
            end
            if SilentStuff.SniperFov ~= Silent.Snipers.Fov.v*20 then
                SilentStuff.SniperFov = Silent.Snipers.Fov.v*20
            end
            if SilentStuff.SniperFov2 ~= Silent.Snipers.FirstShots.Fov.v*20 then
                SilentStuff.SniperFov2 = Silent.Snipers.FirstShots.Fov.v*20
            end
            if SilentStuff.RocketFov ~= Silent.Rockets.Fov.v*20 then
                SilentStuff.RocketFov = Silent.Rockets.Fov.v*20
            end
            if SilentStuff.RocketFov2 ~= Silent.Rockets.FirstShots.Fov.v*20 then
                SilentStuff.RocketFov2 = Silent.Rockets.FirstShots.Fov.v*20
            end
        end
    function get.SilentConfig(Weapon, Vehicle)
            if Weapon >= 22 and Weapon <= 24 then 
                SilentStuff.Fov = SilentStuff.PistolFov SilentStuff.Fov2 = SilentStuff.PistolFov2 SilentStuff.Distance = Silent.Pistols.DistanceEnable .v SilentStuff.ChangedDist = Silent.Pistols.Distance.v
                SilentStuff.VisibleVehicles = Silent.Pistols.VisibleCheck.Vehicles.v SilentStuff.VisibleObjects = Silent.Pistols.VisibleCheck.Objects.v SilentStuff.VisibleCheck = Silent.Pistols.VisibleCheck.Buildings.v
                SilentStuff.Dmg = Silent.Pistols.Damage.v SilentStuff.ChangedDMG = Silent.Pistols.ChangeDamage.v SilentStuff.Bullets = Silent.Pistols.Bullets.v 
                SilentStuff.Chance = Silent.Pistols.Chance.v SilentStuff.Chance2 = Silent.Pistols.FirstShots.Chance.v SilentStuff.VisibleCheck = Silent.Pistols.VisibleCheck.Buildings.v
                
                SilentStuff.Shots = Silent.Pistols.FirstShots.Shots.v
                SilentStuff.BoneHead = Silent.Pistols.Bones.Head.v
                SilentStuff.BoneChest = Silent.Pistols.Bones.Chest.v
                SilentStuff.BoneStomach = Silent.Pistols.Bones.Stomach.v
                SilentStuff.BoneLeftA = Silent.Pistols.Bones.LeftArm.v
                SilentStuff.BoneRightA = Silent.Pistols.Bones.RightArm.v
                SilentStuff.BoneLeftL = Silent.Pistols.Bones.LeftLeg.v
                SilentStuff.BoneRightL = Silent.Pistols.Bones.RightLeg.v
                SilentStuff.MinSpread = Silent.Pistols.Spread.Min.v
                SilentStuff.MaxSpread = Silent.Pistols.Spread.Max.v

            elseif Weapon >= 25 and Weapon <= 27 then 
                SilentStuff.Fov = SilentStuff.ShotgunFov SilentStuff.Fov2 = SilentStuff.ShotgunFov2 SilentStuff.Distance = Silent.Shotguns.DistanceEnable .v SilentStuff.ChangedDist = Silent.Shotguns.Distance.v
                SilentStuff.VisibleVehicles = Silent.Shotguns.VisibleCheck.Vehicles.v SilentStuff.VisibleObjects = Silent.Shotguns.VisibleCheck.Objects.v SilentStuff.VisibleCheck = Silent.Shotguns.VisibleCheck.Buildings.v
                SilentStuff.Dmg = Silent.Shotguns.Damage.v SilentStuff.ChangedDMG = Silent.Shotguns.ChangeDamage.v SilentStuff.Bullets = Silent.Shotguns.Bullets.v 
                SilentStuff.Chance = Silent.Shotguns.Chance.v SilentStuff.Chance2 = Silent.Shotguns.FirstShots.Chance.v SilentStuff.VisibleCheck = Silent.Shotguns.VisibleCheck.Buildings.v
                
                SilentStuff.Shots = Silent.Shotguns.FirstShots.Shots.v
                SilentStuff.BoneHead = Silent.Shotguns.Bones.Head.v
                SilentStuff.BoneChest = Silent.Shotguns.Bones.Chest.v
                SilentStuff.BoneStomach = Silent.Shotguns.Bones.Stomach.v
                SilentStuff.BoneLeftA = Silent.Shotguns.Bones.LeftArm.v
                SilentStuff.BoneRightA = Silent.Shotguns.Bones.RightArm.v
                SilentStuff.BoneLeftL = Silent.Shotguns.Bones.LeftLeg.v
                SilentStuff.BoneRightL = Silent.Shotguns.Bones.RightLeg.v
                SilentStuff.MinSpread = Silent.Shotguns.Spread.Min.v
                SilentStuff.MaxSpread = Silent.Shotguns.Spread.Max.v

            elseif Weapon >= 28 and Weapon <= 29 or Weapon == 32 then 
                SilentStuff.Fov = SilentStuff.SMGFov SilentStuff.Fov2 = SilentStuff.SMGFov2 SilentStuff.Distance = Silent.Smgs.DistanceEnable .v SilentStuff.ChangedDist = Silent.Smgs.Distance.v
                SilentStuff.VisibleVehicles = Silent.Smgs.VisibleCheck.Vehicles.v SilentStuff.VisibleObjects = Silent.Smgs.VisibleCheck.Objects.v SilentStuff.VisibleCheck = Silent.Smgs.VisibleCheck.Buildings.v
                SilentStuff.Dmg = Silent.Smgs.Damage.v SilentStuff.ChangedDMG = Silent.Smgs.ChangeDamage.v SilentStuff.Bullets = Silent.Smgs.Bullets.v 
                SilentStuff.Chance = Silent.Smgs.Chance.v SilentStuff.Chance2 = Silent.Smgs.FirstShots.Chance.v SilentStuff.VisibleCheck = Silent.Smgs.VisibleCheck.Buildings.v
                
                SilentStuff.Shots = Silent.Smgs.FirstShots.Shots.v
                SilentStuff.BoneHead = Silent.Smgs.Bones.Head.v
                SilentStuff.BoneChest = Silent.Smgs.Bones.Chest.v
                SilentStuff.BoneStomach = Silent.Smgs.Bones.Stomach.v
                SilentStuff.BoneLeftA = Silent.Smgs.Bones.LeftArm.v
                SilentStuff.BoneRightA = Silent.Smgs.Bones.RightArm.v
                SilentStuff.BoneLeftL = Silent.Smgs.Bones.LeftLeg.v
                SilentStuff.BoneRightL = Silent.Smgs.Bones.RightLeg.v
                SilentStuff.MinSpread = Silent.Smgs.Spread.Min.v
                SilentStuff.MaxSpread = Silent.Smgs.Spread.Max.v

            elseif Weapon >= 30 and Weapon <= 31 or Weapon == 38 then 
                SilentStuff.Fov = SilentStuff.RifleFov SilentStuff.Fov2 = SilentStuff.RifleFov2 SilentStuff.Distance = Silent.Rifles.DistanceEnable .v SilentStuff.ChangedDist = Silent.Rifles.Distance.v
                SilentStuff.VisibleVehicles = Silent.Rifles.VisibleCheck.Vehicles.v SilentStuff.VisibleObjects = Silent.Rifles.VisibleCheck.Objects.v SilentStuff.VisibleCheck = Silent.Rifles.VisibleCheck.Buildings.v
                SilentStuff.Dmg = Silent.Rifles.Damage.v SilentStuff.ChangedDMG = Silent.Rifles.ChangeDamage.v SilentStuff.Bullets = Silent.Rifles.Bullets.v 
                SilentStuff.Chance = Silent.Rifles.Chance.v SilentStuff.Chance2 = Silent.Rifles.FirstShots.Chance.v SilentStuff.VisibleCheck = Silent.Rifles.VisibleCheck.Buildings.v
                
                SilentStuff.Shots = Silent.Rifles.FirstShots.Shots.v
                SilentStuff.BoneHead = Silent.Rifles.Bones.Head.v
                SilentStuff.BoneChest = Silent.Rifles.Bones.Chest.v
                SilentStuff.BoneStomach = Silent.Rifles.Bones.Stomach.v
                SilentStuff.BoneLeftA = Silent.Rifles.Bones.LeftArm.v
                SilentStuff.BoneRightA = Silent.Rifles.Bones.RightArm.v
                SilentStuff.BoneLeftL = Silent.Rifles.Bones.LeftLeg.v
                SilentStuff.BoneRightL = Silent.Rifles.Bones.RightLeg.v
                SilentStuff.MinSpread = Silent.Rifles.Spread.Min.v
                SilentStuff.MaxSpread = Silent.Rifles.Spread.Max.v

            elseif Weapon == 33 or Weapon == 34 then 
                SilentStuff.Fov = SilentStuff.SniperFov SilentStuff.Fov2 = SilentStuff.SniperFov2 SilentStuff.Distance = Silent.Snipers.DistanceEnable .v SilentStuff.ChangedDist = Silent.Snipers.Distance.v 
                SilentStuff.VisibleVehicles = Silent.Snipers.VisibleCheck.Vehicles.v SilentStuff.VisibleObjects = Silent.Snipers.VisibleCheck.Objects.v SilentStuff.VisibleCheck = Silent.Snipers.VisibleCheck.Buildings.v
                SilentStuff.Dmg = Silent.Snipers.Damage.v SilentStuff.ChangedDMG = Silent.Snipers.ChangeDamage.v SilentStuff.Bullets = Silent.Snipers.Bullets.v 
                SilentStuff.Chance = Silent.Snipers.Chance.v SilentStuff.Chance2 = Silent.Snipers.FirstShots.Chance.v SilentStuff.VisibleCheck = Silent.Snipers.VisibleCheck.Buildings.v 
                
                SilentStuff.Shots = Silent.Snipers.FirstShots.Shots.v
                SilentStuff.BoneHead = Silent.Snipers.Bones.Head.v
                SilentStuff.BoneChest = Silent.Snipers.Bones.Chest.v
                SilentStuff.BoneStomach = Silent.Snipers.Bones.Stomach.v
                SilentStuff.BoneLeftA = Silent.Snipers.Bones.LeftArm.v
                SilentStuff.BoneRightA = Silent.Snipers.Bones.RightArm.v
                SilentStuff.BoneLeftL = Silent.Snipers.Bones.LeftLeg.v
                SilentStuff.BoneRightL = Silent.Snipers.Bones.RightLeg.v
                SilentStuff.MinSpread = Silent.Snipers.Spread.Min.v
                SilentStuff.MaxSpread = Silent.Snipers.Spread.Max.v

            elseif Weapon == 35 or Weapon == 36 or Vehicle == 432 then 
                SilentStuff.Fov = SilentStuff.RocketFov SilentStuff.Fov2 = SilentStuff.RocketFov2 SilentStuff.Distance = Silent.Rockets.DistanceEnable .v SilentStuff.ChangedDist = Silent.Rockets.Distance.v 
                SilentStuff.VisibleVehicles = Silent.Rockets.VisibleCheck.Vehicles.v SilentStuff.VisibleObjects = Silent.Rockets.VisibleCheck.Objects.v SilentStuff.VisibleCheck = Silent.Rockets.VisibleCheck.Buildings.v
                SilentStuff.Dmg = Silent.Rockets.Damage.v SilentStuff.ChangedDMG = Silent.Rockets.ChangeDamage.v SilentStuff.Bullets = Silent.Rockets.Bullets.v 
                SilentStuff.Chance = Silent.Rockets.Chance.v SilentStuff.Chance2 = Silent.Rockets.FirstShots.Chance.v SilentStuff.VisibleCheck = Silent.Rockets.VisibleCheck.Buildings.v 
                
                SilentStuff.Shots = Silent.Rockets.FirstShots.Shots.v
                SilentStuff.BoneHead = Silent.Rockets.Bones.Head.v
                SilentStuff.BoneChest = Silent.Rockets.Bones.Chest.v
                SilentStuff.BoneStomach = Silent.Rockets.Bones.Stomach.v
                SilentStuff.BoneLeftA = Silent.Rockets.Bones.LeftArm.v
                SilentStuff.BoneRightA = Silent.Rockets.Bones.RightArm.v
                SilentStuff.BoneLeftL = Silent.Rockets.Bones.LeftLeg.v
                SilentStuff.BoneRightL = Silent.Rockets.Bones.RightLeg.v
                SilentStuff.MinSpread = Silent.Rockets.Spread.Min.v
                SilentStuff.MaxSpread = Silent.Rockets.Spread.Max.v
            else 
                SilentStuff.Fov = 0 SilentStuff.Fov2 = 0 SilentStuff.Shots = 0  SilentStuff.Distance = 0 SilentStuff.ChangedDist  = 0 
                SilentStuff.VisibleVehicles = 0 SilentStuff.VisibleObjects = 0 SilentStuff.VisibleCheck = 0
                SilentStuff.Dmg = 0 SilentStuff.ChangedDMG = 0 SilentStuff.Bullets = 0
                SilentStuff.Chance = 0 SilentStuff.Chance2 = 0 
               
                SilentStuff.Shots = 0
                SilentStuff.BoneHead = 0
                SilentStuff.BoneChest = 0
                SilentStuff.BoneStomach = 0
                SilentStuff.BoneLeftA = 0
                SilentStuff.BoneRightA = 0
                SilentStuff.BoneLeftL = 0
                SilentStuff.BoneRightL = 0
                SilentStuff.MinSpread = 0
                SilentStuff.MaxSpread = 0
            end
            v.lastweapon = Weapon
        end
-- 
--! Functions
    function get.GitHubPageContent(url)
            local command = "curl -s -L " .. url
            local handle = io.popen(command)
            local result = handle:read("*a")
            handle:close()
            return result
        end

    function get.updateInfo()
            local url = "https://raw.githubusercontent.com/ztriiqk/SHAcKled/main/update.txt"
            local content = get.GitHubPageContent(url)
            if content then
                local versionPattern = "(.-)\n"
                local version = content:match(versionPattern)
                
                if version and version ~= luaVersion then
                    local firstLine = true
                    for line in content:gmatch("[^\r\n]+") do
                        if firstLine then
                            PrintConsole("SHAcKled v"..luaVersion.." latest v"..line.." \n\nPatch Notes:")
                        else
                            PrintConsole(line)
                        end
                        firstLine = false
                    end
        
                    local fileUrl = "https://raw.githubusercontent.com/ztriiqk/SHAcKled/main/Shackled.lua"
                    local fileContent = get.GitHubPageContent(fileUrl)
                    if fileContent then

                        local handle = io.popen("pwd")
                        local currentDirectory = handle:read("*a")
                        handle:close()

                        local scriptPath = debug.getinfo(1, "S").source:sub(2)
                        local scriptName = scriptPath:match("[^/\\]+$")

                        local file = io.open(Config_path..""..scriptName, "w")
                        if file then
                            file:write(fileContent)
                            file:close()
                            PrintConsole("\nDownload completed, Refresh lua.")
                        else
                            PrintConsole("Error writting file.")
                        end
                    else
                        PrintConsole("Erro downloading file.")
                    end
                else
                    PrintConsole("\nSHAcKled.lua v"..luaVersion.." no updates found.\n\n")
                end
            end
        end
    function set.cleanVar()
            if unload == true then
                OnFootData = nil
                BulletData = nil
                AimData = nil
                get = nil
                set = nil
                send = nil
                Shackled = nil
                Slide = nil
                Macro = nil
                Timerss = nil
                getMyVars = nil
                Visuals = nil
                getNearests = nil
                getSilentTarget = nil
                getWeaponsTimer = nil
                CollectGarbage = nil
                bit = nil
                Timers = nil
                Silent = nil
                AimAssist = nil
                Damager = nil
                DamageChanger = nil
                BulletRebuff = nil
                Troll = nil
                Godmode = nil
                Teleport = nil
                RadarHack = nil
                DMGTimer = nil
                RVankaTimer1 = nil 
                SendCMD = nil
                StreamWall = nil
                Filters = nil
                Indicator = nil
                Movement = nil
                Extra = nil
                Commands = nil
                Doublejump = nil
                NOPs = nil
                KeyToggle = nil
                m_offsets = nil
                Shackled = nil
                vEn = nil
                vAmI = nil
                vMy = nil
                memory = nil
                RPC = nil
                SampKeys = nil
                SilentStuff = nil
                vehicleParts = nil
                vehicles = nil
                objects = nil
                players = nil
                sRunAnimations = nil
                fCheatBone = nil
                fPlayerBone = nil
                vehicleInfo = nil
                VehicleType = nil
                fWeaponName = nil
                weaponInfo = nil
                SHAcKvar = nil
                Timer = nil
                SHAkMenu = nil
                vecCrosshair = nil
                vMyScreen = nil
                vEnScreen = nil
                vMyScreenToDamager = nil
                vEnScreenToDamager = nil
                middlescreen = nil
                v = nil
                collectgarbage("collect")
            end
        end
    function get.ScriptDirectory()
            local script_path = debug.getinfo(1, "S").source:sub(2)
            local path_separator = package.config:sub(1,1) -- obtém o separador de caminho do sistema operacional atual
            local last_separator_index = script_path:find(path_separator .. "[^" .. path_separator .. "]*$")
            if last_separator_index then
                return script_path:sub(1, last_separator_index-1) 
            else
                return "" 
            end
        end
    local function unloadScript()
                unload = true
                local script_path = debug.getinfo(1, "S").source:sub(2)
                local script_name = string.match(script_path, "([^/\\]+)$")
                local lua_dir = script_path:gsub("[/\\][^/\\]*$", "")
                local script_dir = get.ScriptDirectory()

                local registry_key = [[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]]
                local registry_key_recent = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\RecentDocs"
                local registry_key_user_assist = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\UserAssist\\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\\Count"

                local registry_value = {
                    [0] = script_name,
                    [1] = "Default.SHAk",
                    [2] = "Config1.SHAk",
                    [3] = "Config2.SHAk",
                    [4] = "Config3.SHAk",
                    [5] = "Config4.SHAk",
                    [6] = "Config5.SHAk",
                    [7] = "lua",
                }

                local defaultconfig = script_dir .. "\\Default.SHAk"
                local config1 = script_dir .. "\\Config1.SHAk"
                local config2 = script_dir .. "\\Config2.SHAk"
                local config3 = script_dir .. "\\Config3.SHAk"
                local config4 = script_dir .. "\\Config4.SHAk"
                local config5 = script_dir .. "\\Config5.SHAk"
                os.remove(script_path)
                os.remove(defaultconfig)
                os.remove(config1)
                os.remove(config2)
                os.remove(config3)
                os.remove(config4)
                os.remove(config5)

                local folderExists = os.rename(lua_dir, lua_dir)

                if folderExists then
                    local deleteCommand = "rmdir /s /q " .. lua_dir
                    local result = os.execute(deleteCommand)
                end

                for i, value in ipairs(registry_value) do
                    local command = string.format('reg delete "%s" /v "%s" /f', registry_key, value)
                    local command_recent = string.format('reg delete "%s" /f /va /d "%s"', registry_key_recent, value)
                    local command_user_assist = string.format('reg delete "%s" /f /v "%s"', registry_key_user_assist, value)
                    
                    os.execute(command)
                    os.execute(command_recent)
                    os.execute(command_user_assist)
                end
                set.cleanVar()
                collectgarbage("collect")
            end
    function get.PlayerFPS()
            local FPS = Utils:readMemory(0xB7CB50, 4, false)
            local bsData = BitStream()
            bsWrap:Reset(bsData)
            bsWrap:Write32(bsData, FPS)
            FPS = bsWrap:ReadFloat(bsData)
            return FPS
        end
    function read.Memories()
        --Structs
            CPedST = Utils:readMemory(0xB6F5F0, 4, false)
            CVehicleST = Utils:readMemory(0xB6F980, 4, false)
        --Others
            memory.ExtraWS.v1 = Utils:readMemory(0x5109AC, 1, false)
            memory.ExtraWS.v2 = Utils:readMemory(0x5109C5, 1, false)
            memory.ExtraWS.v3 = Utils:readMemory(0x5231A6, 1, false)
            memory.ExtraWS.v4 = Utils:readMemory(0x52322D, 1, false)
            memory.ExtraWS.v5 = Utils:readMemory(0x5233BA, 1, false)
            --memory.GameSpeed = Utils:readMemory(0xB7CB64, 4, true)
        --CPed
            memory.CPed.God = Utils:readMemory(CPedST+0x42, 1, false)
            memory.CPed.Movement = Utils:readMemory(CPedST+0x41, 1, false)
            memory.CPed.Anim = Utils:readMemory(CPedST+0x534, 1, false)
        --CVehicle
            memory.CVehicle.CarTire1 = Utils:readMemory(CVehicleST+0x5A5, 1, false)
            memory.CVehicle.CarTire2 = Utils:readMemory(CVehicleST+0x5A6, 1, false)
            memory.CVehicle.CarTire3 = Utils:readMemory(CVehicleST+0x5A7, 1, false)
            memory.CVehicle.CarTire4 = Utils:readMemory(CVehicleST+0x5A8, 1, false)
            memory.CVehicle.BikeTire1 = Utils:readMemory(CVehicleST+0x65C, 1, false)
            memory.CVehicle.BikeTire2 = Utils:readMemory(CVehicleST+0x65D, 1, false)
            memory.CVehicle.PerfectHandling = Utils:readMemory(0x96914C, 1, false)
            memory.CVehicle.Surface = Utils:readMemory(CVehicleST+0x41, 1, false)
        end
        read.Memories()
    function set.Memories()
            if Extra.IgnoreWater.v then
                Utils:writeMemory(0x6C2759, 1, 1, true)
            else
                Utils:writeMemory(0x6C2759, 0, 1, true)
            end
            if Vehicle.PotatoCars.v then
                if Vehicle.PotatoType.v == 0 then
                    Utils:writeMemory(0x52C9EE, 1, 1, false)
                    Utils:writeMemory(0x96914B, 0, 1, false)
                else
                    Utils:writeMemory(0x96914B, 1, 1, false)
                    Utils:writeMemory(0x52C9EE, 0, 1, false)
                end
            else
                Utils:writeMemory(0x96914B, 0, 1, false)
                Utils:writeMemory(0x52C9EE, 0, 1, false)
            end
            if Vehicle.BoatFly.v then
                Utils:writeMemory(0x969153, 1, 1, false)
            else
                Utils:writeMemory(0x969153, 0, 1, false)
            end
            if Extra.AntiAFK.v then
                Utils:writeMemory(0x747FB6, 0x1010101, 1, false)
                Utils:writeMemory(0x74805A, 0x1010101, 1, false)
                Utils:writeMemory(0x74542B, -0x6F6F6F70, 8, false)
            else
                Utils:writeMemory(0x747FB6, 0, 1, false)
                Utils:writeMemory(0x74805A, 0, 1, false)
                Utils:writeMemory(0x74542B, 0x5051FF15, 8, false)
            end
        end
    function get.script_path()
            local info = debug.getinfo(1,'S');
            local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
            return script_path
        end
        local script_path = get.script_path()
        Config_path = script_path
        
    local function color(r, g, b, a)
            r = math.max(0, math.min(255, r))
            g = math.max(0, math.min(255, g))
            b = math.max(0, math.min(255, b))
            a = math.max(0, math.min(255, a))

            local colorValue = bit.bor(bit.lshift(a, 24), bit.lshift(r, 16), bit.lshift(g, 8), b)

            return colorValue
        end

    local function lerpColor(c1, c2, t)
                local r1, g1, b1, a1 = bit.rshift(bit.band(c1, 0xFF0000), 16), bit.rshift(bit.band(c1, 0xFF00), 8), bit.band(c1, 0xFF), bit.rshift(bit.band(c1, 0xFF000000), 24)
                local r2, g2, b2, a2 = bit.rshift(bit.band(c2, 0xFF0000), 16), bit.rshift(bit.band(c2, 0xFF00), 8), bit.band(c2, 0xFF), bit.rshift(bit.band(c2, 0xFF000000), 24)

                local r = t * (r2 - r1) + r1
                local g = t * (g2 - g1) + g1
                local b = t * (b2 - b1) + b1
                local a = t * (a2 - a1) + a1

                return color(r, g, b, a)
            end 
    
    function SHAkMenu.resetMenuTimer(menutype)
            if v.menutyped ~= menutype then
                SHAkMenu.menutransitor = 0
                SHAkMenu.menutransitorstatic = 0
                SHAkMenu.menutransitorstaticreversed = 140
                v.menutyped = menutype
            end
        end
    function SHAkMenu.resetMenuTimerStaticReversed()
            SHAkMenu.menutransitorstaticreversed = 140
        end
    function SHAkMenu.resetMenuTimerStaticReversed2()
            SHAkMenu.menutransitorstaticreversed2 = 140
        end
    function get.Split(s, delimiter)
            if delimiter == nil then
                delimiter = "%s"
            end
            local result = {}
            for str in string.gmatch(s, "([^"..delimiter.."]+)") do
                table.insert(result, str)
            end
            return result;
        end
    function read.containsSubstringIgnoreCase(mainString, substring)
            local lowerMainString = string.lower(mainString)
            local lowerSubstring = string.lower(substring)
            return string.find(lowerMainString, lowerSubstring, 1, true) ~= nil
        end

    function send.Message(buf, color)
            if SHAkMenu.ChatMessage.v then
                local bsData = BitStream()
                local dColor = bsWrap:Write32(bsData, color)
                local dMessageLength = bsWrap:Write32(bsData, 255)
                bsWrap:WriteBuf(bsData,buf,255)
                EmulRPC(93,bsData)
            end
        end
    function set.HideTextDraw(id)
            local bsData = BitStream()
            bsWrap:Write16(bsData, id) 
            EmulRPC(135,bsData)
        end
    function set.TextDraw(message, color, id, X, Y)
            if Panic.Visuals.v == false then   
                set.HideTextDraw(id)
                if id == 2046 then
                    v.ShowDraws[0] = id
                    v.HideDraws[0] = 0
                end
                if id == 2045 then
                    v.ShowDraws[1] = id
                    v.HideDraws[1] = 0
                end
                local bsData = BitStream()
                bsWrap:Write16(bsData, id)
                bsWrap:Write16(bsData, 102)
                bsWrap:WriteBuf(bsData,message,102)
                EmulRPC(105,bsData)
                bsWrap:Reset(bsData)
                local wTextDrawID = bsWrap:Write16(bsData, id)
                local Flags = bsWrap:Write8(bsData, 16)
                local fLetterWidth = bsWrap:WriteFloat(bsData, 0.399999) 
                local fLetterHeight = bsWrap:WriteFloat(bsData, 1) 
                local dwLetterColor = bsWrap:Write32(bsData, color) 
                local fLineWidth = bsWrap:WriteFloat(bsData, 1280) 
                local fLineHeight = bsWrap:WriteFloat(bsData, 1280) 
                local dwBoxColor = bsWrap:Write32(bsData, 80808080) 
                local Shadow = bsWrap:Write8(bsData, 1) 
                local Outline = bsWrap:Write8(bsData, 1) 
                local dwBackgroundColor = bsWrap:WriteFloat(bsData, -17000) 
                local Style = bsWrap:Write8(bsData, 3) 
                local Selectable = bsWrap:Write8(bsData, 0) 
                local fX = bsWrap:WriteFloat(bsData, X) 
                local fY = bsWrap:WriteFloat(bsData, Y) 
                local wModelID = bsWrap:Write16(bsData, 1) 
                local fRotX = bsWrap:WriteFloat(bsData, 0) 
                local fRotY = bsWrap:WriteFloat(bsData, 0) 
                local fRotZ = bsWrap:WriteFloat(bsData, 0) 
                local fZoom = bsWrap:WriteFloat(bsData, 0) 
                local wColor1 = bsWrap:Write16(bsData, 0) 
                local wColor2 = bsWrap:Write16(bsData, 0) 
                local szTextLen = bsWrap:Write16(bsData, 102)
                bsWrap:WriteBuf(bsData,message,102)
                EmulRPC(134,bsData)
            end
        end
    function read.BoolFromString(var, varcheck, value)
            if var ~= varcheck then
                PrintConsole("Error at variable: ".. var .."... // Expected: "..varcheck)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
            return ImBool(tostring(value) == "true")
        end
    function read.IntFromString(var, varcheck, value)
            if var ~= varcheck then
                PrintConsole("Error at variable: ".. var .."... // Expected: "..varcheck)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
            local ivalue = tonumber(value)
            return ImInt(ivalue or 0)
        end
    function read.FloatFromString(var, varcheck, value)
            if var ~= varcheck then
                PrintConsole("Error at variable: ".. var .."... // Expected: "..varcheck)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
            local fvalue = tonumber(value)
            return ImFloat(fvalue or 0)
        end
    function read.VectorFromString(var1, varcheck1, x, var2, varcheck2, y, var3, varcheck3, z)
            if var1 ~= varcheck1 then
                PrintConsole("Error at variable: ".. var1 .."... // Expected: "..varcheck1)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
            if var2 ~= varcheck2 then
                PrintConsole("Error at variable: ".. var2 .."... // Expected: "..varcheck2)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
            if var3 ~= varcheck3 then
                PrintConsole("Error at variable: ".. var3 .."... // Expected: "..varcheck3)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
            x = tonumber(x)
            y = tonumber(y)
            z = tonumber(z)
            return CVector(x, y, z)
        end
    function read.BufferFromString(var, varcheck, value)
            if var ~= varcheck then
                PrintConsole("Error at variable: ".. var .."... // Expected: "..varcheck)
                v.Cfgbrokenlines = v.Cfgbrokenlines + 1
            end
        
            return ImBuffer(tostring(value), 100)
        end
    --SaveAsString
        function Panic.SaveAsString()
                local output = ""    
                output = output .. string.format("Panic.Visuals = %s", Panic.Visuals.v) .. "\n"
                output = output .. string.format("Panic.VisualsKey = %d", Panic.VisualsKey.v) .. "\n"
                output = output .. string.format("Panic.EveryThingExceptVisuals = %s", Panic.EveryThingExceptVisuals.v) .. "\n"
                output = output .. string.format("Panic.EveryThingExceptVisualsKey = %d", Panic.EveryThingExceptVisualsKey.v) .. "\n"
                return output
            end
        function Commands.SaveAsString()
                local output = ""    
                output = output .. string.format("Commands.Filters = %s", Commands.Filters.v) .. "\n"
                output = output .. string.format("Commands.FiltersChosen = %s", Commands.FiltersChosen.v) .. "\n"
                output = output .. string.format("Commands.CreateVeh = %s", Commands.CreateVeh.v) .. "\n"
                output = output .. string.format("Commands.CreateVehNormal = %s", Commands.CreateVehNormal.v) .. "\n"
                output = output .. string.format("Commands.CreateVehInvisible = %s", Commands.CreateVehInvisible.v) .. "\n"
                output = output .. string.format("Commands.SetSkin = %s", Commands.SetSkin.v) .. "\n"
                output = output .. string.format("Commands.SetSkinChosen = %s", Commands.SetSkinChosen.v) .. "\n"
                output = output .. string.format("Commands.GiveWeapon = %s", Commands.GiveWeapon.v) .. "\n"
                output = output .. string.format("Commands.GiveWeaponChosen = %s", Commands.GiveWeaponChosen.v) .. "\n"
                output = output .. string.format("Commands.SetSpecialAction = %s", Commands.SetSpecialAction.v) .. "\n"
                output = output .. string.format("Commands.SetSpecialActionChosen = %s", Commands.SetSpecialActionChosen.v) .. "\n"
                return output
            end
        function Movement.SaveAsString()
                local output = ""    
                output = output .. string.format("Movement.Slide.Enable = %s", Movement.Slide.Enable.v) .. "\n"
                output = output .. string.format("Movement.Slide.OnKey = %s", Movement.Slide.OnKey.v) .. "\n"
                output = output .. string.format("Movement.Slide.Key = %d", Movement.Slide.Key.v) .. "\n"
                output = output .. string.format("Movement.Slide.PrioritizeFist1handedgun = %s", Movement.Slide.PrioritizeFist1handedgun.v) .. "\n"
                output = output .. string.format("Movement.Slide.PrioritizeFist2handedgun = %s", Movement.Slide.PrioritizeFist2handedgun.v) .. "\n"
                output = output .. string.format("Movement.Slide.PerWeap = %s", Movement.Slide.PerWeap.v) .. "\n"
                output = output .. string.format("Movement.Slide.SilencedPistol = %s", Movement.Slide.SilencedPistol.v) .. "\n"
                output = output .. string.format("Movement.Slide.DesertEagle = %s", Movement.Slide.DesertEagle.v) .. "\n"
                output = output .. string.format("Movement.Slide.Shotgun = %s", Movement.Slide.Shotgun.v) .. "\n"
                output = output .. string.format("Movement.Slide.Sawnoff = %s", Movement.Slide.Sawnoff.v) .. "\n"
                output = output .. string.format("Movement.Slide.CombatShotgun = %s", Movement.Slide.CombatShotgun.v) .. "\n"
                output = output .. string.format("Movement.Slide.Mp5 = %s", Movement.Slide.Mp5.v) .. "\n"
                output = output .. string.format("Movement.Slide.Ak47 = %s", Movement.Slide.Ak47.v) .. "\n"
                output = output .. string.format("Movement.Slide.M4 = %s", Movement.Slide.M4.v) .. "\n"
                output = output .. string.format("Movement.Slide.CountryRifle = %s", Movement.Slide.CountryRifle.v) .. "\n"
                output = output .. string.format("Movement.Slide.SniperRifle = %s", Movement.Slide.SniperRifle.v) .. "\n"
                output = output .. string.format("Movement.Slide.AutoC = %s", Movement.Slide.AutoC.v) .. "\n"
                output = output .. string.format("Movement.Slide.SpeedEnable = %s", Movement.Slide.SpeedEnable.v) .. "\n"
                output = output .. string.format("Movement.Slide.SpeedFakeSync = %s", Movement.Slide.SpeedFakeSync.v) .. "\n"
                output = output .. string.format("Movement.Slide.Speed = %.3f", Movement.Slide.Speed.v) .. "\n"
                output = output .. string.format("Movement.Slide.SpeedDuration = %d", Movement.Slide.SpeedDuration.v) .. "\n"
                output = output .. string.format("Movement.Slide.SpeedChance = %d", Movement.Slide.SpeedChance.v) .. "\n"
                output = output .. string.format("Movement.Slide.SpeedGameSpeed = %d", Movement.Slide.SpeedGameSpeed.v) .. "\n"
                output = output .. string.format("Movement.Slide.SwitchVelocity0 = %d", Movement.Slide.SwitchVelocity[0].v) .. "\n"
                output = output .. string.format("Movement.Slide.SwitchVelocity1 = %d", Movement.Slide.SwitchVelocity[1].v) .. "\n"
                output = output .. string.format("Movement.Slide.SwitchVelocity2 = %d", Movement.Slide.SwitchVelocity[2].v) .. "\n"
                output = output .. string.format("Movement.Slide.SwitchVelocity3 = %d", Movement.Slide.SwitchVelocity[3].v) .. "\n"
                output = output .. string.format("Movement.MacroRun.Enable = %s", Movement.MacroRun.Enable.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.OnKey = %s", Movement.MacroRun.OnKey.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.KeyType = %d", Movement.MacroRun.KeyType.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.Key = %s", Movement.MacroRun.Key.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.Speed = %d", Movement.MacroRun.Speed.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.Legit = %s", Movement.MacroRun.Legit.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.SpeedBasedOnHp = %s", Movement.MacroRun.SpeedBasedOnHp.v) .. "\n"
                output = output .. string.format("Movement.MacroRun.Bypass = %s", Movement.MacroRun.Bypass.v) .. "\n"
                output = output .. string.format("Movement.AntiStun.Enable = %s",Movement.AntiStun.Enable.v) .. "\n"
                output = output .. string.format("Movement.AntiStun.MinChance = %d",Movement.AntiStun.MinChance.v) .. "\n"
                output = output .. string.format("Movement.AntiStun.IncreaseMinChance = %d",Movement.AntiStun.IncreaseMinChance.v) .. "\n"
                output = output .. string.format("Movement.AntiStun.Timer = %d",Movement.AntiStun.Timer.v) .. "\n"
                output = output .. string.format("Movement.AntiStun.AFK = %s",Movement.AntiStun.AFK.v) .. "\n"
                output = output .. string.format("Movement.FakeLagPeek.Enable = %s",Movement.FakeLagPeek.Enable.v) .. "\n" 
                output = output .. string.format("Movement.FakeLagPeek.AtTarget = %s",Movement.FakeLagPeek.AtTarget.v) .. "\n" 
                output = output .. string.format("Movement.FakeLagPeek.DistanceFromWall = %d",Movement.FakeLagPeek.DistanceFromWall.v) .. "\n" 
                output = output .. string.format("Movement.FakeLagPeek.Fov = %f",Movement.FakeLagPeek.Fov.v) .. "\n" 
                output = output .. string.format("Movement.FakeLagPeek.Time = %d",Movement.FakeLagPeek.Time.v) .. "\n" 
                output = output .. string.format("Movement.FakeLagPeek.Delay = %d",Movement.FakeLagPeek.Delay.v) .. "\n" 
                output = output .. string.format("Movement.FakeLagPeek.DrawWalls = %s",Movement.FakeLagPeek.DrawWalls.v) .. "\n" 
                output = output .. string.format("Movement.bUseCJWalk = %s",Movement.bUseCJWalk.v) .. "\n"
                output = output .. string.format("Movement.ForceSkin = %s",Movement.ForceSkin.v) .. "\n"
                output = output .. string.format("Movement.ChosenSkin = %d",Movement.ChosenSkin.v) .. "\n"
                output = output .. string.format("Movement.NoFall = %s",Movement.NoFall.v) .. "\n"
                output = output .. string.format("Movement.NoFallNodamage = %s",Movement.NoFallNodamage.v) .. "\n"
                output = output .. string.format("Movement.NoAnimations = %s",Movement.NoAnimations.v) .. "\n"
                output = output .. string.format("Movement.RunEverywhere = %s",Movement.RunEverywhere.v) .. "\n"
                output = output .. string.format("Movement.Fight = %s",Movement.Fight.v) .. "\n"
                output = output .. string.format("Movement.FightStyle = %d",Movement.FightStyle.v) .. "\n"
                return output
            end
        function RadarHack.SaveAsString()
                local output = ""
                output = output .. string.format("RadarHack.Enable = %s",RadarHack.Enable.v) .. "\n"
                output = output .. string.format("RadarHack.PlayerMarkers = %s",RadarHack.PlayerMarkers.v) .. "\n"
                output = output .. string.format("RadarHack.Onlyoutofview = %s",RadarHack.Onlyoutofview.v) .. "\n"
                output = output .. string.format("RadarHack.AfterDamage = %s",RadarHack.AfterDamage.v) .. "\n"
                output = output .. string.format("RadarHack.ShowLine = %s",RadarHack.ShowLine.v) .. "\n"
                output = output .. string.format("RadarHack.ShowName = %s",RadarHack.ShowName.v) .. "\n"
                output = output .. string.format("RadarHack.ShowHP = %s",RadarHack.ShowHP.v) .. "\n"
                output = output .. string.format("RadarHack.HPSize = %d",RadarHack.HPSize.v) .. "\n"
                output = output .. string.format("RadarHack.HPHeight = %d",RadarHack.HPHeight.v) .. "\n"
                output = output .. string.format("RadarHack.LinkedToChar = %s",RadarHack.LinkedToChar.v) .. "\n"
                output = output .. string.format("RadarHack.Bone = %d",RadarHack.Bone.v) .. "\n"
                output = output .. string.format("RadarHack.MaxPlayers = %d",RadarHack.MaxPlayers.v) .. "\n"
                output = output .. string.format("RadarHack.X = %.3f",RadarHack.X.v) .. "\n"
                output = output .. string.format("RadarHack.Y = %.3f",RadarHack.Y.v) .. "\n"
                output = output .. string.format("RadarHack.maxLength = %.3f",RadarHack.maxLength.v) .. "\n"
                output = output .. string.format("RadarHack.lowDistance = %d",RadarHack .lowDistance.v) .. "\n"
                output = output .. string.format("RadarHack.maxDistance = %d",RadarHack .maxDistance.v) .. "\n"
                return output
            end
        function StreamWall.SaveAsString()
                local output = ""
                output = output .. string.format("StreamWall.Enable = %s",StreamWall.Enable.v) .. "\n"
                output = output .. string.format("StreamWall.AFK = %s",StreamWall.AFK.v) .. "\n"
                output = output .. string.format("StreamWall.HP = %s",StreamWall.HP.v) .. "\n"
                output = output .. string.format("StreamWall.MaxPlayers = %d",StreamWall.MaxPlayers.v) .. "\n"
                output = output .. string.format("StreamWall.X = %.3f",StreamWall.X.v) .. "\n"
                output = output .. string.format("StreamWall.Y = %.3f",StreamWall.Y.v) .. "\n"
                return output
            end
        function Extra.SaveAsString()
                local output = ""
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot0.brass = %s",Extra.AutoDeleteWeapon.Slot0.brass.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.golf = %s",Extra.AutoDeleteWeapon.Slot1.golf.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.nitestick = %s",Extra.AutoDeleteWeapon.Slot1.nitestick.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.knife = %s",Extra.AutoDeleteWeapon.Slot1.knife.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.bat = %s",Extra.AutoDeleteWeapon.Slot1.bat.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.shovel = %s",Extra.AutoDeleteWeapon.Slot1.shovel.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.pool = %s",Extra.AutoDeleteWeapon.Slot1.pool.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.katana = %s",Extra.AutoDeleteWeapon.Slot1.katana.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot1.chainsaw = %s",Extra.AutoDeleteWeapon.Slot1.chainsaw.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot2.colt = %s",Extra.AutoDeleteWeapon.Slot2.colt.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot2.silenced = %s",Extra.AutoDeleteWeapon.Slot2.silenced.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot2.desert = %s",Extra.AutoDeleteWeapon.Slot2.desert.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot3.shotgun = %s",Extra.AutoDeleteWeapon.Slot3.shotgun.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot3.sawnoff = %s",Extra.AutoDeleteWeapon.Slot3.sawnoff.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot3.spas = %s",Extra.AutoDeleteWeapon.Slot3.spas.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot4.uzi = %s",Extra.AutoDeleteWeapon.Slot4.uzi.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot4.mp5 = %s",Extra.AutoDeleteWeapon.Slot4.mp5.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot4.tec9 = %s",Extra.AutoDeleteWeapon.Slot4.tec9.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot5.ak47 = %s",Extra.AutoDeleteWeapon.Slot5.ak47.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot5.m4 = %s",Extra.AutoDeleteWeapon.Slot5.m4.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot6.cuntgun = %s",Extra.AutoDeleteWeapon.Slot6.cuntgun.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot6.sniper = %s",Extra.AutoDeleteWeapon.Slot6.sniper.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot7.rocket = %s",Extra.AutoDeleteWeapon.Slot7.rocket.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot7.heatseeker = %s",Extra.AutoDeleteWeapon.Slot7.heatseeker.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot7.flamethrower = %s",Extra.AutoDeleteWeapon.Slot7.flamethrower.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot7.minigun = %s",Extra.AutoDeleteWeapon.Slot7.minigun.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot8.satchel = %s",Extra.AutoDeleteWeapon.Slot8.satchel.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot8.grenade = %s",Extra.AutoDeleteWeapon.Slot8.grenade.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot8.teargas = %s",Extra.AutoDeleteWeapon.Slot8.teargas.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot9.spraycan = %s",Extra.AutoDeleteWeapon.Slot9.spraycan.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot9.extinguisher = %s",Extra.AutoDeleteWeapon.Slot9.extinguisher.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot9.camera = %s",Extra.AutoDeleteWeapon.Slot9.camera.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot10.purple = %s",Extra.AutoDeleteWeapon.Slot10.purple.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot10.dildo = %s",Extra.AutoDeleteWeapon.Slot10.dildo.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot10.vibrator = %s",Extra.AutoDeleteWeapon.Slot10.vibrator.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot10.silver = %s",Extra.AutoDeleteWeapon.Slot10.silver.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot10.flowers = %s",Extra.AutoDeleteWeapon.Slot10.flowers.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot10.cane = %s",Extra.AutoDeleteWeapon.Slot10.cane.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot11.night = %s",Extra.AutoDeleteWeapon.Slot11.night.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot11.thermal = %s",Extra.AutoDeleteWeapon.Slot11.thermal.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot11.Parachute = %s",Extra.AutoDeleteWeapon.Slot11.Parachute.v) .. "\n"
                output = output .. string.format("Extra.AutoDeleteWeapon.Slot12.detonator = %s",Extra.AutoDeleteWeapon.Slot12.detonator.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Enable = %s",Extra.fuckKeyStrokes.Enable.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Mode = %d",Extra.fuckKeyStrokes.Mode.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.fire = %s",Extra.fuckKeyStrokes.Key.fire.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.aim = %s",Extra.fuckKeyStrokes.Key.aim.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.horn_crouch = %s",Extra.fuckKeyStrokes.Key.horn_crouch.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.enterExitCar = %s",Extra.fuckKeyStrokes.Key.enterExitCar.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.sprint = %s",Extra.fuckKeyStrokes.Key.sprint.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.jump = %s",Extra.fuckKeyStrokes.Key.jump.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.landingGear_lookback = %s",Extra.fuckKeyStrokes.Key.landingGear_lookback.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.walk = %s",Extra.fuckKeyStrokes.Key.walk.v) .. "\n"
                output = output .. string.format("Extra.fuckKeyStrokes.Key.tab %s",Extra.fuckKeyStrokes.Key.tab.v) .. "\n"
                output = output .. string.format("Extra.RemoveObjectTemp.Enable = %s",Extra.RemoveObjectTemp.Enable.v) .. "\n"
                output = output .. string.format("Extra.RemoveObjectTemp.Key = %d",Extra.RemoveObjectTemp.Key.v) .. "\n"
                output = output .. string.format("Extra.RemoveObjectTemp.Time = %d",Extra.RemoveObjectTemp.Time.v) .. "\n"
                output = output .. string.format("Extra.Mobile = %s",Extra.Mobile.v) .. "\n"
                output = output .. string.format("Extra.AutoReply0 = %s",Extra.AutoReply[0].v) .. "\n"
                output = output .. string.format("Extra.AutoReply1 = %s",Extra.AutoReply[1].v) .. "\n"
                output = output .. string.format("Extra.AutoReply2 = %s",Extra.AutoReply[2].v) .. "\n"
                output = output .. string.format("Extra.Message1 = %s",Extra.Message[1].v) .. "\n"
                output = output .. string.format("Extra.Message2 = %s",Extra.Message[2].v) .. "\n"
                output = output .. string.format("Extra.Reply1 = %s",Extra.Reply[1].v) .. "\n"
                output = output .. string.format("Extra.Reply2 = %s",Extra.Reply[2].v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.Enable = %s",Extra.ExtraWS.Enable.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.OnKey = %s",Extra.ExtraWS.OnKey.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.Key = %d",Extra.ExtraWS.Key.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.KeyType = %d",Extra.ExtraWS.KeyType.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.X = %s",Extra.ExtraWS.X.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.Y = %s",Extra.ExtraWS.Y.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.Enable = %s",Extra.ExtraWS.Enable.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.PerCategory.Pistols = %s",Extra.ExtraWS.PerCategory.Pistols.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.PerCategory.Shotguns = %s",Extra.ExtraWS.PerCategory.Shotguns.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.PerCategory.SMGs = %s",Extra.ExtraWS.PerCategory.SMGs.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.PerCategory.Rifles = %s",Extra.ExtraWS.PerCategory.Rifles.v) .. "\n"
                output = output .. string.format("Extra.ExtraWS.PerCategory.Snipers = %s",Extra.ExtraWS.PerCategory.Snipers.v) .. "\n"
                output = output .. string.format("Extra.SetWeaponSkill = %s",Extra.SetWeaponSkill.v) .. "\n"
                output = output .. string.format("Extra.SetWeaponSkillLevel = %d",Extra.SetWeaponSkillLevel.v) .. "\n"
                output = output .. string.format("Extra.SendCMD.Enable = %s",Extra.SendCMD.Enable.v) .. "\n"
                output = output .. string.format("Extra.SendCMD.Command = %s",Extra.SendCMD.Command.v) .. "\n"
                output = output .. string.format("Extra.SendCMD.Times = %d",Extra.SendCMD.Times.v) .. "\n"
                output = output .. string.format("Extra.SendCMD.Delay = %d",Extra.SendCMD.Delay.v) .. "\n"
                output = output .. string.format("Extra.SendCMD.HP = %d",Extra.SendCMD.HP.v) .. "\n"
                output = output .. string.format("Extra.SendCMD.Armour = %d",Extra.SendCMD.Armour.v) .. "\n"
                output = output .. string.format("Extra.PickUP.Enable = %s",Extra.PickUP.Enable.v) .. "\n"
                output = output .. string.format("Extra.PickUP.Model1 = %d",Extra.PickUP.Model1.v) .. "\n"
                output = output .. string.format("Extra.PickUP.Model2 = %d",Extra.PickUP.Model2.v) .. "\n"
                output = output .. string.format("Extra.PickUP.Model3 = %d",Extra.PickUP.Model3.v) .. "\n"
                output = output .. string.format("Extra.PickUP.Delay = %d",Extra.PickUP.Delay.v) .. "\n"
                output = output .. string.format("Extra.PickUP.HP = %d",Extra.PickUP.HP.v) .. "\n"
                output = output .. string.format("Extra.PickUP.Armour = %d",Extra.PickUP.Armour.v) .. "\n"
                output = output .. string.format("Extra.RequestSpawn = %s",Extra.RequestSpawn.v) .. "\n"
                output = output .. string.format("Extra.RequestSpawnHP = %d",Extra.RequestSpawnHP.v) .. "\n"
                output = output .. string.format("Extra.RequestSpawnArmour = %d",Extra.RequestSpawnArmour.v) .. "\n"
                output = output .. string.format("Extra.AntiFreeze = %s",Extra.AntiFreeze.v) .. "\n"
                output = output .. string.format("Extra.AntiSniper = %s",Extra.AntiSniper.v) .. "\n"
                output = output .. string.format("Extra.AntiSniperTypeMode = %d",Extra.AntiSniperTypeMode.v) .. "\n"
                output = output .. string.format("Extra.AntiSniperChance = %d",Extra.AntiSniperChance.v) .. "\n"
                output = output .. string.format("Extra.IgnoreWater = %s",Extra.IgnoreWater.v) .. "\n"
                output = output .. string.format("Extra.AntiAFK = %s",Extra.AntiAFK.v) .. "\n"
                output = output .. string.format("Extra.AntiSlapper = %s",Extra.AntiSlapper.v) .. "\n"
                output = output .. string.format("Extra.ForceGravity = %s",Extra.ForceGravity.v) .. "\n"
                output = output .. string.format("Extra.GravityFloat = %.3f",Extra.GravityFloat.v) .. "\n"
                output = output .. string.format("Extra.SpecialAction = %d",Extra.SpecialAction.v) .. "\n"
                return output
            end
        function Vehicle.SaveAsString()
                local output = ""
                output = output .. string.format("Vehicle.Unlock = %s",Vehicle.Unlock.v) .. "\n" 
                output = output .. string.format("Vehicle.AutoAttachTrailer = %s",Vehicle.AutoAttachTrailer.v) .. "\n" 
                output = output .. string.format("Vehicle.NeverOffEngine = %s",Vehicle.NeverOffEngine.v) .. "\n" 
                output = output .. string.format("Vehicle.DriveNoLicense = %s",Vehicle.DriveNoLicense.v) .. "\n" 
                output = output .. string.format("Vehicle.DriveNoLicenseFakeData = %s",Vehicle.DriveNoLicenseFakeData.v) .. "\n" 
                output = output .. string.format("Vehicle.FastExit = %s",Vehicle.FastExit.v) .. "\n" 
                output = output .. string.format("Vehicle.AntiCarJack = %s",Vehicle.AntiCarJack.v) .. "\n" 
                output = output .. string.format("Vehicle.AntiCarFlip = %s",Vehicle.AntiCarFlip.v) .. "\n" 
                output = output .. string.format("Vehicle.NeverPopTire = %s",Vehicle.NeverPopTire.v) .. "\n" 
                output = output .. string.format("Vehicle.BoatFly = %s",Vehicle.BoatFly.v) .. "\n" 
                output = output .. string.format("Vehicle.PerfectHandling = %s",Vehicle.PerfectHandling.v) .. "\n" 
                output = output .. string.format("Vehicle.PerfectHandlingOnKey = %s",Vehicle.PerfectHandlingOnKey.v) .. "\n" 
                output = output .. string.format("Vehicle.PerfectHandlingKey = %d",Vehicle.PerfectHandlingKey.v) .. "\n"
                output = output .. string.format("Vehicle.FreezeRot = %s",Vehicle.FreezeRot.v) .. "\n" 
                output = output .. string.format("Vehicle.PotatoCars = %s",Vehicle.PotatoCars.v) .. "\n" 
                output = output .. string.format("Vehicle.PotatoType = %d",Vehicle.PotatoType.v) .. "\n" 
                output = output .. string.format("Vehicle.NoCarCollision = %s",Vehicle.NoCarCollision.v) .. "\n" 
                output = output .. string.format("Vehicle.NoCarCollisionKey = %d",Vehicle.NoCarCollisionKey.v) .. "\n" 
                output = output .. string.format("Vehicle.InfinityNitrous = %s",Vehicle.InfinityNitrous.v) .. "\n" 
                output = output .. string.format("Vehicle.InfinityNitrousType = %d",Vehicle.InfinityNitrousType.v) .. "\n" 
                output = output .. string.format("Vehicle.Recovery = %s",Vehicle.Recovery.v) .. "\n" 
                output = output .. string.format("Vehicle.RecoverParts = %s",Vehicle.RecoverParts.v) .. "\n" 
                output = output .. string.format("Vehicle.ChosenTimer = %d",Vehicle.ChosenTimer.v) .. "\n" 
                output = output .. string.format("Vehicle.HPAmount = %.3f",Vehicle.HPAmount.v) .. "\n"
                output = output .. string.format("Vehicle.LimitVelocity = %s",Vehicle.LimitVelocity.v) .. "\n"
                output = output .. string.format("Vehicle.SmartLimitMaxVelocity = %s",Vehicle.SmartLimitMaxVelocity.v) .. "\n"
                output = output .. string.format("Vehicle.LimitVelocityOnKey = %s",Vehicle.LimitVelocityOnKey.v) .. "\n"
                output = output .. string.format("Vehicle.LimitVelocityKey = %d",Vehicle.LimitVelocityKey.v) .. "\n"
                output = output .. string.format("Vehicle.Velocity = %d",Vehicle.Velocity.v) .. "\n"
                output = output .. string.format("Vehicle.CarJump = %s",Vehicle.CarJump.v) .. "\n"
                output = output .. string.format("Vehicle.CarJumpKey = %d",Vehicle.CarJumpKey.v) .. "\n"
                output = output .. string.format("Vehicle.Height = %.1f",Vehicle.Height.v) .. "\n"
                output = output .. string.format("Vehicle.AutoMotorbike = %s",Vehicle.AutoMotorbike.v) .. "\n"
                output = output .. string.format("Vehicle.MotorbikeDelay = %d",Vehicle.MotorbikeDelay.v) .. "\n"
                output = output .. string.format("Vehicle.AutoBike = %s",Vehicle.AutoBike.v) .. "\n"
                output = output .. string.format("Vehicle.BikeDelay = %d",Vehicle.BikeDelay.v) .. "\n"
                return output
            end

        function Filters.SaveAsString()
                local output = ""
                output = output .. string.format("Filters.Enable = %s",Filters.Enable.v) .. "\n" 
                output = output .. string.format("Filters.X = %.3f",Filters.X.v) .. "\n" 
                output = output .. string.format("Filters.Y = %.3f",Filters.Y.v) .. "\n" 
                return output
            end
        function Indicator.SaveAsString()
                local output = ""
                output = output .. string.format("Indicator.Enable = %s",Indicator.Enable.v) .. "\n" 
                output = output .. string.format("Indicator.Damager = %s",Indicator.Damager.v) .. "\n"
                output = output .. string.format("Indicator.Silent = %s",Indicator.Silent.v) .. "\n" 
                output = output .. string.format("Indicator.MacroRun = %s",Indicator.MacroRun.v) .. "\n" 
                output = output .. string.format("Indicator.Slide = %s",Indicator.Slide.v) .. "\n" 
                output = output .. string.format("Indicator.FakeLagPeek = %s",Indicator.FakeLagPeek.v) .. "\n" 
                output = output .. string.format("Indicator.SlideSpeed = %s",Indicator.SlideSpeed.v) .. "\n" 
                output = output .. string.format("Indicator.AntiStun = %s",Indicator.AntiStun.v) .. "\n" 
                output = output .. string.format("Indicator.Godmode = %s",Indicator.Godmode.v) .. "\n" 
                output = output .. string.format("Indicator.X = %.3f",Indicator.X.v) .. "\n" 
                output = output .. string.format("Indicator.Y = %.3f",Indicator.Y.v) .. "\n" 
                return output
            end
        function Teleport.SaveAsString()
                local output = ""
                output = output .. string.format("Teleport.Enable = %s",Teleport.Enable.v) .. "\n"
                output = output .. string.format("Teleport.FromGround = %s",Teleport.FromGround.v) .. "\n"
                output = output .. string.format("Teleport.PersonalDelay = %d",Teleport.PersonalDelay.v) .. "\n"
                output = output .. string.format("Teleport.ACDelay = %d",Teleport.ACDelay.v) .. "\n"
                output = output .. string.format("Teleport.OnFootVelocity = %.3f",Teleport.OnFootVelocity.v) .. "\n"
                output = output .. string.format("Teleport.InCarVelocity = %.3f",Teleport.InCarVelocity.v) .. "\n"
                output = output .. string.format("Teleport.toPlayer = %s",Teleport.toPlayer.v) .. "\n"
                output = output .. string.format("Teleport.toPlayerKey = %d",Teleport.toPlayerKey.v) .. "\n"
                output = output .. string.format("Teleport.toVehicle = %s",Teleport.toVehicle.v) .. "\n"
                output = output .. string.format("Teleport.toInside = %s",Teleport.toInside.v) .. "\n"
                output = output .. string.format("Teleport.toVehicleType = %d",Teleport.toVehicleType.v) .. "\n"
                output = output .. string.format("Teleport.toVehicleDriver = %s",Teleport.toVehicleDriver.v) .. "\n"
                output = output .. string.format("Teleport.toVehicleKey = %d",Teleport.toVehicleKey.v) .. "\n"
                output = output .. string.format("Teleport.toCheckpoint = %s",Teleport.toCheckpoint.v) .. "\n"
                output = output .. string.format("Teleport.CheckpointKey = %d",Teleport.CheckpointKey.v) .. "\n"
                output = output .. string.format("Teleport.HvH = %s",Teleport.HvH.v) .. "\n"
                output = output .. string.format("Teleport.HVHDeath = %s",Teleport.HVHDeath.v) .. "\n"
                output = output .. string.format("Teleport.HVHAFK = %s",Teleport.HVHAFK.v) .. "\n"
                output = output .. string.format("Teleport.HvHAntiKick = %s",Teleport.HvHAntiKick.v) .. "\n"
                output = output .. string.format("Teleport.HvHKey = %d",Teleport.HvHKey.v) .. "\n"
                output = output .. string.format("Teleport.HVHWait = %d",Teleport.HVHWait.v) .. "\n"
                output = output .. string.format("Teleport.AttachToVehicle = %s",Teleport.AttachToVehicle.v) .. "\n"
                output = output .. string.format("Teleport.toObject = %s",Teleport.toObject.v) .. "\n"
                output = output .. string.format("Teleport.ObjectKey = %d",Teleport.ObjectKey.v) .. "\n"
                output = output .. string.format("Teleport.Jumper = %s",Teleport.Jumper.v) .. "\n"
                output = output .. string.format("Teleport.JumperKey = %d",Teleport.JumperKey.v) .. "\n"

                output = output .. string.format("Teleport.ShowSaveTeleports = %s",Teleport.ShowSaveTeleports.v) .. "\n"
                output = output .. string.format("Teleport.SavedPos0.fX = %.5f",Teleport.SavedPos[0].fX) .. "\n"
                output = output .. string.format("Teleport.SavedPos0.fY = %.5f",Teleport.SavedPos[0].fY) .. "\n"
                output = output .. string.format("Teleport.SavedPos0.fZ = %.5f",Teleport.SavedPos[0].fZ) .. "\n"
                output = output .. string.format("Teleport.SavedPos1.fX = %.5f",Teleport.SavedPos[1].fX) .. "\n"
                output = output .. string.format("Teleport.SavedPos1.fY = %.5f",Teleport.SavedPos[1].fY) .. "\n"
                output = output .. string.format("Teleport.SavedPos1.fZ = %.5f",Teleport.SavedPos[1].fZ) .. "\n"
                output = output .. string.format("Teleport.SavedPos2.fX = %.5f",Teleport.SavedPos[2].fX) .. "\n"
                output = output .. string.format("Teleport.SavedPos2.fY = %.5f",Teleport.SavedPos[2].fY) .. "\n"
                output = output .. string.format("Teleport.SavedPos2.fZ = %.5f",Teleport.SavedPos[2].fZ) .. "\n"
                output = output .. string.format("Teleport.SavedPos3.fX = %.5f",Teleport.SavedPos[3].fX) .. "\n"
                output = output .. string.format("Teleport.SavedPos3.fY = %.5f",Teleport.SavedPos[3].fY) .. "\n"
                output = output .. string.format("Teleport.SavedPos3.fZ = %.5f",Teleport.SavedPos[3].fZ) .. "\n"
                return output
            end
        function Troll.SaveAsString()
                local output = ""
                output = output .. string.format("Troll.FakePos.Enable = %s",Troll.FakePos.Enable.v) .. "\n"
                output = output .. string.format("Troll.FakePos.RandomPos = %s",Troll.FakePos.RandomPos.v) .. "\n"
                output = output .. string.format("Troll.FakePos.OnFoot = %s",Troll.FakePos.OnFoot.v) .. "\n"
                output = output .. string.format("Troll.FakePos.InCar = %s",Troll.FakePos.InCar.v) .. "\n"
                output = output .. string.format("Troll.FakePos.X = %.3f",Troll.FakePos.X.v) .. "\n"
                output = output .. string.format("Troll.FakePos.Y = %.3f",Troll.FakePos.Y.v) .. "\n"
                output = output .. string.format("Troll.FuckSync = %s",Troll.FuckSync.v) .. "\n"
                output = output .. string.format("Troll.Slapper.Enable = %s",Troll.Slapper.Enable.v) .. "\n"
                output = output .. string.format("Troll.Slapper.OnKey = %s",Troll.Slapper.OnKey.v) .. "\n"
                output = output .. string.format("Troll.Slapper.Key = %d",Troll.Slapper.Key.v) .. "\n"
                output = output .. string.format("Troll.RVanka.Enable = %s",Troll.RVanka.Enable.v) .. "\n"
                output = output .. string.format("Troll.RVanka.OnKey = %s",Troll.RVanka.OnKey.v) .. "\n"
                output = output .. string.format("Troll.RVanka.KeyType = %d",Troll.RVanka.KeyType.v) .. "\n"
                output = output .. string.format("Troll.RVanka.Key = %d",Troll.RVanka.Key.v) .. "\n"
                output = output .. string.format("Troll.RVanka.Speed = %f",Troll.RVanka.Speed.v) .. "\n"
                output = output .. string.format("Troll.RVanka.Distance = %d",Troll.RVanka.Distance.v) .. "\n"
                output = output .. string.format("Troll.RVanka.Timer = %d",Troll.RVanka.Timer.v) .. "\n"
                return output
            end
        function Damager.SaveAsString()
                local output = ""
                output = output .. string.format("Damager.Enable = %s",Damager.Enable.v) .. "\n"
                output = output .. string.format("Damager.OnKey = %s",Damager.OnKey.v) .. "\n"
                output = output .. string.format("Damager.KeyType = %d",Damager.KeyType.v) .. "\n"
                output = output .. string.format("Damager.Key = %d",Damager.Key.v) .. "\n"
                output = output .. string.format("Damager.IgnoreGiveTakeDamage = %s",Damager.IgnoreGiveTakeDamage.v) .. "\n"
                output = output .. string.format("Damager.ChangeDamage = %s",Damager.ChangeDamage.v) .. "\n"
                output = output .. string.format("Damager.Damage = %.3f",Damager.Damage.v) .. "\n"
                output = output .. string.format("Damager.CurrentWeapon = %s",Damager.CurrentWeapon.v) .. "\n"
                output = output .. string.format("Damager.Weapon = %d",Damager.Weapon.v) .. "\n"
                output = output .. string.format("Damager.Chance = %d",Damager.Chance.v) .. "\n"
                output = output .. string.format("Damager.DistanceEnable = %s",Damager.DistanceEnable.v) .. "\n"
                output = output .. string.format("Damager.Distance = %d",Damager .Distance.v) .. "\n"
                output = output .. string.format("Damager.Bullets = %d",Damager.Bullets.v) .. "\n"
                output = output .. string.format("Damager.TargetType = %d",Damager.TargetType.v) .. "\n"
                output = output .. string.format("Damager.VisibleChecks = %s",Damager.VisibleChecks.v) .. "\n"
                output = output .. string.format("Damager.Bone = %d",Damager.Bone.v) .. "\n"
                output = output .. string.format("Damager.Force = %s",Damager.Force.v) .. "\n"
                output = output .. string.format("Damager.Delay = %d",Damager.Delay.v) .. "\n"
                output = output .. string.format("Damager.EmulCbug = %s",Damager.EmulCbug.v) .. "\n"
                output = output .. string.format("Damager.SyncAim = %s",Damager.SyncAim.v) .. "\n"
                output = output .. string.format("Damager.SyncOnfootData = %s",Damager.SyncOnfootData.v) .. "\n"
                output = output .. string.format("Damager.SyncRotation = %s",Damager.SyncRotation.v) .. "\n"
                output = output .. string.format("Damager.SyncBullet.Enable = %s",Damager.SyncBullet.Enable.v) .. "\n"
                output = output .. string.format("Damager.SyncBullet.Type = %d",Damager.SyncBullet.Type.v) .. "\n"
                output = output .. string.format("Damager.SyncWeapon = %s",Damager.SyncWeapon.v) .. "\n"
                output = output .. string.format("Damager.DeathNotification = %s",Damager.DeathNotification.v) .. "\n"
                output = output .. string.format("Damager.Spawn = %s",Damager.Spawn.v) .. "\n"
                output = output .. string.format("Damager.SyncPos = %s",Damager.SyncPos.v) .. "\n"
                output = output .. string.format("Damager.VisibleCheck.Vehicles = %s",Damager.VisibleCheck.Vehicles.v) .. "\n"
                output = output .. string.format("Damager.VisibleCheck.Objects = %s",Damager.VisibleCheck.Objects.v) .. "\n"
                output = output .. string.format("Damager.ShowHitPos = %s",Damager.ShowHitPos.v) .. "\n"
                output = output .. string.format("Damager.Clist = %s",Damager.Clist.v) .. "\n"
                output = output .. string.format("Damager.AFK = %s",Damager.AFK.v) .. "\n"
                output = output .. string.format("Damager.Death = %s",Damager.Death.v) .. "\n"
                output = output .. string.format("Damager.TakeDamage = %s",Damager.TakeDamage.v) .. "\n"
                output = output .. string.format("Damager.OnlyStreamed = %s",Damager.OnlyStreamed.v) .. "\n"
                output = output .. string.format("Damager.gtdID = %d",Damager.gtdID.v) .. "\n"
                return output
            end
        function DamageChanger.SaveAsString()
                local output = ""
                output = output .. string.format("DamageChanger.Enable = %s",DamageChanger.Enable.v) .. "\n"
                output = output .. string.format("DamageChanger.OnKey = %s",DamageChanger.OnKey.v) .. "\n"
                output = output .. string.format("DamageChanger.Key = %d",DamageChanger.Key.v) .. "\n"
                output = output .. string.format("DamageChanger.KeyType = %d",DamageChanger.KeyType.v) .. "\n"
                output = output .. string.format("DamageChanger.Pistols.Enable = %s",DamageChanger.Pistols.Enable.v) .. "\n"
                output = output .. string.format("DamageChanger.Pistols.DMG = %f",DamageChanger.Pistols.DMG.v) .. "\n"
                output = output .. string.format("DamageChanger.Shotguns.Enable = %s",DamageChanger.Shotguns.Enable.v) .. "\n"
                output = output .. string.format("DamageChanger.Shotguns.DMG = %f",DamageChanger.Shotguns.DMG.v) .. "\n"
                output = output .. string.format("DamageChanger.SMGs.Enable = %s",DamageChanger.SMGs.Enable.v) .. "\n"
                output = output .. string.format("DamageChanger.SMGs.DMG = %f",DamageChanger.SMGs.DMG.v) .. "\n"
                output = output .. string.format("DamageChanger.Rifles.Enable = %s",DamageChanger.Rifles.Enable.v) .. "\n"
                output = output .. string.format("DamageChanger.Rifles.DMG = %f",DamageChanger.Rifles.DMG.v) .. "\n"
                output = output .. string.format("DamageChanger.Snipers.Enable = %s",DamageChanger.Snipers.Enable.v) .. "\n"
                output = output .. string.format("DamageChanger.Snipers.DMG = %f",DamageChanger.Snipers.DMG.v) .. "\n"
                return output
            end
        function Silent.SaveAsString()
                local output = ""
                output = output .. string.format("Silent.Enable = %s",Silent.Enable.v) .. "\n" 
                output = output .. string.format("Silent.OnKey = %s",Silent.OnKey.v) .. "\n"
                output = output .. string.format("Silent.KeyType = %d",Silent.KeyType.v) .. "\n" 
                output = output .. string.format("Silent.Key = %d",Silent.Key.v) .. "\n"  
                output = output .. string.format("Silent.DrawFov = %s",Silent.DrawFov.v) .. "\n" 
                output = output .. string.format("Silent.Force = %s",Silent.Force.v) .. "\n" 
                output = output .. string.format("Silent.WallShot = %s",Silent.WallShot.v) .. "\n" 
                output = output .. string.format("Silent.Clist = %s",Silent.Clist.v) .. "\n" 
                output = output .. string.format("Silent.AFK = %s",Silent.AFK.v) .. "\n" 
                output = output .. string.format("Silent.AFK = %s",Silent.AFK.v) .. "\n" 
                output = output .. string.format("Silent.InVehicle = %s",Silent.InVehicle.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Fov = %f",Silent.Pistols.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.FirstShots.Fov = %f",Silent.Pistols.FirstShots.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.FirstShots.Shots = %d",Silent.Pistols.FirstShots.Shots.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.VisibleCheck.Buildings = %s",Silent.Pistols.VisibleCheck.Buildings.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.DistanceEnable = %s",Silent.Pistols.DistanceEnable.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Distance = %d",Silent .Pistols.Distance.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.ChangeDamage = %s",Silent.Pistols.ChangeDamage.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bullets = %d",Silent.Pistols.Bullets.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Damage = %f",Silent.Pistols.Damage.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Chance = %d",Silent.Pistols.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.FirstShots.Chance = %d",Silent.Pistols.FirstShots.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.Head = %s",Silent.Pistols.Bones.Head.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.Chest = %s",Silent.Pistols.Bones.Chest.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.Stomach = %s",Silent.Pistols.Bones.Stomach.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.LeftArm = %s",Silent.Pistols.Bones.LeftArm.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.RightArm = %s",Silent.Pistols.Bones.RightArm.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.LeftLeg = %s",Silent.Pistols.Bones.LeftLeg.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Bones.RightLeg = %s",Silent.Pistols.Bones.RightLeg.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Spread.Min = %f",Silent.Pistols.Spread.Min.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.Spread.Max = %f",Silent.Pistols.Spread.Max.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.VisibleCheck.Vehicles = %s",Silent.Pistols.VisibleCheck.Vehicles.v) .. "\n" 
                output = output .. string.format("Silent.Pistols.VisibleCheck.Objects = %s",Silent.Pistols.VisibleCheck.Objects.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Fov = %f",Silent.Shotguns.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.FirstShots.Fov = %f",Silent.Shotguns.FirstShots.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.FirstShots.Shots = %d",Silent.Shotguns.FirstShots.Shots.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.VisibleCheck.Buildings = %s",Silent.Shotguns.VisibleCheck.Buildings.v) .. "\n"
                output = output .. string.format("Silent.Shotguns.DistanceEnable = %s",Silent.Shotguns.DistanceEnable.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Distance = %d",Silent .Shotguns.Distance.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.ChangeDamage = %s",Silent.Shotguns.ChangeDamage.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bullets = %d",Silent.Shotguns.Bullets.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Damage = %f",Silent.Shotguns.Damage.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Chance = %d",Silent.Shotguns.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.FirstShots.Chance = %d",Silent.Shotguns.FirstShots.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.Head = %s",Silent.Shotguns.Bones.Head.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.Chest = %s",Silent.Shotguns.Bones.Chest.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.Stomach = %s",Silent.Shotguns.Bones.Stomach.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.LeftArm = %s",Silent.Shotguns.Bones.LeftArm.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.RightArm = %s",Silent.Shotguns.Bones.RightArm.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.LeftLeg = %s",Silent.Shotguns.Bones.LeftLeg.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Bones.RightLeg = %s",Silent.Shotguns.Bones.RightLeg.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Spread.Min = %f",Silent.Shotguns.Spread.Min.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.Spread.Max = %f",Silent.Shotguns.Spread.Max.v) .. "\n" 
                output = output .. string.format("Silent.Shotguns.VisibleCheck.Vehicles = %s",Silent.Shotguns.VisibleCheck.Vehicles.v) .. "\n"
                output = output .. string.format("Silent.Shotguns.VisibleCheck.Objects = %s",Silent.Shotguns.VisibleCheck.Objects.v) .. "\n"
                output = output .. string.format("Silent.Smgs.Fov = %f",Silent.Smgs.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.FirstShots.Fov = %f",Silent.Smgs.FirstShots.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.FirstShots.Shots = %d",Silent.Smgs.FirstShots.Shots.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.VisibleCheck.Buildings = %s",Silent.Smgs.VisibleCheck.Buildings.v) .. "\n"
                output = output .. string.format("Silent.Smgs.DistanceEnable = %s",Silent.Smgs.DistanceEnable.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Distance = %d",Silent .Smgs.Distance.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.ChangeDamage = %s",Silent.Smgs.ChangeDamage.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bullets = %d",Silent.Smgs.Bullets.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Damage = %f",Silent.Smgs.Damage.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Chance = %d",Silent.Smgs.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.FirstShots.Chance = %d",Silent.Smgs.FirstShots.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.Head = %s",Silent.Smgs.Bones.Head.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.Chest = %s",Silent.Smgs.Bones.Chest.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.Stomach = %s",Silent.Smgs.Bones.Stomach.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.LeftArm = %s",Silent.Smgs.Bones.LeftArm.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.RightArm = %s",Silent.Smgs.Bones.RightArm.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.LeftLeg = %s",Silent.Smgs.Bones.LeftLeg.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Bones.RightLeg = %s",Silent.Smgs.Bones.RightLeg.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Spread.Min = %f",Silent.Smgs.Spread.Min.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.Spread.Max = %f",Silent.Smgs.Spread.Max.v) .. "\n" 
                output = output .. string.format("Silent.Smgs.VisibleCheck.Vehicles = %s",Silent.Smgs.VisibleCheck.Vehicles.v) .. "\n"
                output = output .. string.format("Silent.Smgs.VisibleCheck.Objects = %s",Silent.Smgs.VisibleCheck.Objects.v) .. "\n"
                output = output .. string.format("Silent.Rifles.Fov = %f",Silent.Rifles.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.FirstShots.Fov = %f",Silent.Rifles.FirstShots.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.FirstShots.Shots = %d",Silent.Rifles.FirstShots.Shots.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.VisibleCheck.Buildings = %s",Silent.Rifles.VisibleCheck.Buildings.v) .. "\n"
                output = output .. string.format("Silent.Rifles.DistanceEnable = %s",Silent.Rifles.DistanceEnable.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Distance = %d",Silent .Rifles.Distance.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.ChangeDamage = %s",Silent.Rifles.ChangeDamage.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bullets = %d",Silent.Rifles.Bullets.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Damage = %f",Silent.Rifles.Damage.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Chance = %d",Silent.Rifles.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.FirstShots.Chance = %d",Silent.Rifles.FirstShots.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.Head = %s",Silent.Rifles.Bones.Head.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.Chest = %s",Silent.Rifles.Bones.Chest.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.Stomach = %s",Silent.Rifles.Bones.Stomach.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.LeftArm = %s",Silent.Rifles.Bones.LeftArm.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.RightArm = %s",Silent.Rifles.Bones.RightArm.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.LeftLeg = %s",Silent.Rifles.Bones.LeftLeg.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Bones.RightLeg = %s",Silent.Rifles.Bones.RightLeg.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Spread.Min = %f",Silent.Rifles.Spread.Min.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.Spread.Max = %f",Silent.Rifles.Spread.Max.v) .. "\n" 
                output = output .. string.format("Silent.Rifles.VisibleCheck.Vehicles = %s",Silent.Rifles.VisibleCheck.Vehicles.v) .. "\n"
                output = output .. string.format("Silent.Rifles.VisibleCheck.Objects = %s",Silent.Rifles.VisibleCheck.Objects.v) .. "\n"
                output = output .. string.format("Silent.Snipers.Fov = %f",Silent.Snipers.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.FirstShots.Fov = %f",Silent.Snipers.FirstShots.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.FirstShots.Shots = %d",Silent.Snipers.FirstShots.Shots.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.VisibleCheck.Buildings = %s",Silent.Snipers.VisibleCheck.Buildings.v) .. "\n"
                output = output .. string.format("Silent.Snipers.DistanceEnable = %s",Silent.Snipers.DistanceEnable.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Distance = %d",Silent .Snipers.Distance.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.ChangeDamage = %s",Silent.Snipers.ChangeDamage.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bullets = %d",Silent.Snipers.Bullets.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Damage = %f",Silent.Snipers.Damage.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Chance = %d",Silent.Snipers.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.FirstShots.Chance = %d",Silent.Snipers.FirstShots.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.Head = %s",Silent.Snipers.Bones.Head.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.Chest = %s",Silent.Snipers.Bones.Chest.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.Stomach = %s",Silent.Snipers.Bones.Stomach.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.LeftArm = %s",Silent.Snipers.Bones.LeftArm.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.RightArm = %s",Silent.Snipers.Bones.RightArm.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.LeftLeg = %s",Silent.Snipers.Bones.LeftLeg.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Bones.RightLeg = %s",Silent.Snipers.Bones.RightLeg.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Spread.Min = %f",Silent.Snipers.Spread.Min.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.Spread.Max = %f",Silent.Snipers.Spread.Max.v) .. "\n" 
                output = output .. string.format("Silent.Snipers.VisibleCheck.Vehicles = %s",Silent.Snipers.VisibleCheck.Vehicles.v) .. "\n"
                output = output .. string.format("Silent.Snipers.VisibleCheck.Objects = %s",Silent.Snipers.VisibleCheck.Objects.v) .. "\n"
                output = output .. string.format("Silent.Rockets.Fov = %f",Silent.Rockets.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.FirstShots.Fov = %f",Silent.Rockets.FirstShots.Fov.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.FirstShots.Shots = %d",Silent.Rockets.FirstShots.Shots.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.VisibleCheck.Buildings = %s",Silent.Rockets.VisibleCheck.Buildings.v) .. "\n"
                output = output .. string.format("Silent.Rockets.DistanceEnable = %s",Silent.Rockets.DistanceEnable.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Distance = %d",Silent .Rockets.Distance.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.ChangeDamage = %s",Silent.Rockets.ChangeDamage.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bullets = %d",Silent.Rockets.Bullets.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Damage = %f",Silent.Rockets.Damage.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Chance = %d",Silent.Rockets.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.FirstShots.Chance = %d",Silent.Rockets.FirstShots.Chance.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.Head = %s",Silent.Rockets.Bones.Head.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.Chest = %s",Silent.Rockets.Bones.Chest.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.Stomach = %s",Silent.Rockets.Bones.Stomach.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.LeftArm = %s",Silent.Rockets.Bones.LeftArm.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.RightArm = %s",Silent.Rockets.Bones.RightArm.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.LeftLeg = %s",Silent.Rockets.Bones.LeftLeg.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Bones.RightLeg = %s",Silent.Rockets.Bones.RightLeg.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Spread.Min = %f",Silent.Rockets.Spread.Min.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.Spread.Max = %f",Silent.Rockets.Spread.Max.v) .. "\n" 
                output = output .. string.format("Silent.Rockets.VisibleCheck.Vehicles = %s",Silent.Rockets.VisibleCheck.Vehicles.v) .. "\n"
                output = output .. string.format("Silent.Rockets.VisibleCheck.Objects = %s",Silent.Rockets.VisibleCheck.Objects.v) .. "\n"
                output = output .. string.format("Silent.SyncRotation = %s",Silent.SyncRotation.v) .. "\n"
                output = output .. string.format("Silent.SyncAimZ = %s",Silent.SyncAimZ.v) .. "\n"
                output = output .. string.format("Silent.OnlyGiveTakeDamage = %s",Silent.OnlyGiveTakeDamage.v) .. "\n"
                output = output .. string.format("Silent.OnlyGiveTakeDamageType = %d",Silent.OnlyGiveTakeDamageType.v) .. "\n"
                return output
            end
        function AimAssist.SaveAsString()
                local output = ""
                output = output .. string.format("AimAssist.Enable = %s",AimAssist.Enable.v) .. "\n"
                output = output .. string.format("AimAssist.OnKey = %s",AimAssist.OnKey.v) .. "\n"
                output = output .. string.format("AimAssist.Key = %s",AimAssist.Key.v) .. "\n"
                output = output .. string.format("AimAssist.KeyType = %s",AimAssist.KeyType.v) .. "\n"
                output = output .. string.format("AimAssist.DrawFOV = %s",AimAssist.DrawFOV.v) .. "\n"
                output = output .. string.format("AimAssist.FOVType = %d",AimAssist.FOVType.v) .. "\n"
                output = output .. string.format("AimAssist.FOV = %f",AimAssist.FOV.v) .. "\n"
                output = output .. string.format("AimAssist.ForceWhoDamaged = %s",AimAssist.ForceWhoDamaged.v) .. "\n"
                return output
            end
        function Doublejump.SaveAsString()
                local output = ""
                output = output .. string.format("Doublejump.Enable = %s",Doublejump.Enable.v).. "\n"
                output = output .. string.format("Doublejump.Height = %.1f",Doublejump.Height.v).. "\n"
                output = output .. string.format("Doublejump.OnKey = %s",Doublejump.OnKey.v).. "\n"
                output = output .. string.format("Doublejump.Key = %d",Doublejump.Key.v).. "\n"
                return output
            end
        function BulletRebuff.SaveAsString()
                local output = ""
                output = output .. string.format("BulletRebuff.Enable = %s",BulletRebuff.Enable.v).. "\n"
                output = output .. string.format("BulletRebuff.SyncWeapon = %s",BulletRebuff.SyncWeapon.v).. "\n"
                output = output .. string.format("BulletRebuff.SameWeapon = %s",BulletRebuff.SameWeapon.v).. "\n"
                output = output .. string.format("BulletRebuff.Clist = %s",BulletRebuff.Clist.v).. "\n"
                output = output .. string.format("BulletRebuff.Force = %s",BulletRebuff.Force.v).. "\n"
                return output
            end
        function Godmode.SaveAsString()
                local output = ""
                output = output .. string.format("Godmode.PlayerEnable = %s",Godmode.PlayerEnable.v).. "\n"
                output = output .. string.format("Godmode.PlayerCollision = %s",Godmode.PlayerCollision.v).. "\n"
                output = output .. string.format("Godmode.PlayerMelee = %s",Godmode.PlayerMelee.v).. "\n"
                output = output .. string.format("Godmode.PlayerBullet = %s",Godmode.PlayerBullet.v).. "\n"
                output = output .. string.format("Godmode.PlayerFire = %s",Godmode.PlayerFire.v).. "\n"
                output = output .. string.format("Godmode.PlayerExplosion = %s",Godmode.PlayerExplosion.v).. "\n"
                output = output .. string.format("Godmode.VehicleEnable = %s",Godmode.VehicleEnable.v).. "\n"
                output = output .. string.format("Godmode.VehicleCollision = %s",Godmode.VehicleCollision.v).. "\n"
                output = output .. string.format("Godmode.VehicleMelee = %s",Godmode.VehicleMelee.v).. "\n"
                output = output .. string.format("Godmode.VehicleBullet = %s",Godmode.VehicleBullet.v).. "\n"
                output = output .. string.format("Godmode.VehicleFire = %s",Godmode.VehicleFire.v).. "\n"
                output = output .. string.format("Godmode.VehicleExplosion = %s",Godmode.VehicleExplosion.v).. "\n"
                return output
            end
        function SHAkMenu.SaveAsString()
                local output = ""
                output = output .. string.format("SHAkMenu.ChatMessage = %s",SHAkMenu.ChatMessage.v).. "\n"
                output = output .. string.format("SHAkMenu.FpsBoost = %s",SHAkMenu.FpsBoost.v).. "\n"
                output = output .. string.format("SHAkMenu.RefreshHZ = %s",SHAkMenu.RefreshHZ.v).. "\n"
                output = output .. string.format("SHAkMenu.X = %f",SHAkMenu.X.v).. "\n"
                output = output .. string.format("SHAkMenu.Y = %f",SHAkMenu.Y.v)
                return output
            end 
    function read.LoadFromString(s)
            local cfglines = 0
            local var1 = {}
            local var2 = {}
            local lines = {}
            local index = 0
            local splitted = 0
            for line in s:gmatch("([^\n]*)\n?") do
                splitted = get.Split(line, " = ")
                local variable = splitted[1]
                local value = splitted[2]
                local value1 = splitted[3]
                local value2 = splitted[3]
                var1[index] = variable
                var2[index] = 0
                lines[index] = value
                index = index + 1
            end
                Panic.Visuals = read.BoolFromString(var1[cfglines],"Panic.Visuals",lines[cfglines]) cfglines = cfglines + 1
                Panic.VisualsKey = read.IntFromString(var1[cfglines],"Panic.VisualsKey",lines[cfglines]) cfglines = cfglines + 1
                Panic.EveryThingExceptVisuals = read.BoolFromString(var1[cfglines],"Panic.EveryThingExceptVisuals",lines[cfglines]) cfglines = cfglines + 1
                Panic.EveryThingExceptVisualsKey = read.IntFromString(var1[cfglines],"Panic.EveryThingExceptVisualsKey",lines[cfglines]) cfglines = cfglines + 1
                Commands.Filters = read.BoolFromString(var1[cfglines],"Commands.Filters",lines[cfglines]) cfglines = cfglines + 1
                Commands.FiltersChosen = read.BufferFromString(var1[cfglines],"Commands.FiltersChosen",lines[cfglines]) cfglines = cfglines + 1 
                Commands.CreateVeh = read.BoolFromString(var1[cfglines],"Commands.CreateVeh",lines[cfglines]) cfglines = cfglines + 1
                Commands.CreateVehNormal = read.BufferFromString(var1[cfglines],"Commands.CreateVehNormal",lines[cfglines]) cfglines = cfglines + 1 
                Commands.CreateVehInvisible = read.BufferFromString(var1[cfglines],"Commands.CreateVehInvisible",lines[cfglines]) cfglines = cfglines + 1 
                Commands.SetSkin = read.BoolFromString(var1[cfglines],"Commands.SetSkin",lines[cfglines]) cfglines = cfglines + 1
                Commands.SetSkinChosen = read.BufferFromString(var1[cfglines],"Commands.SetSkinChosen",lines[cfglines]) cfglines = cfglines + 1 
                Commands.GiveWeapon = read.BoolFromString(var1[cfglines],"Commands.GiveWeapon",lines[cfglines]) cfglines = cfglines + 1 
                Commands.GiveWeaponChosen = read.BufferFromString(var1[cfglines],"Commands.GiveWeaponChosen",lines[cfglines]) cfglines = cfglines + 1 
                Commands.SetSpecialAction = read.BoolFromString(var1[cfglines],"Commands.SetSpecialAction",lines[cfglines]) cfglines = cfglines + 1
                Commands.SetSpecialActionChosen = read.BufferFromString(var1[cfglines],"Commands.SetSpecialActionChosen",lines[cfglines]) cfglines = cfglines + 1 

                Movement.Slide.Enable = read.BoolFromString(var1[cfglines],"Movement.Slide.Enable",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.OnKey = read.BoolFromString(var1[cfglines],"Movement.Slide.OnKey",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.Key = read.IntFromString(var1[cfglines],"Movement.Slide.Key",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.PrioritizeFist1handedgun = read.BoolFromString(var1[cfglines],"Movement.Slide.PrioritizeFist1handedgun",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.PrioritizeFist2handedgun = read.BoolFromString(var1[cfglines],"Movement.Slide.PrioritizeFist2handedgun",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.PerWeap = read.BoolFromString(var1[cfglines],"Movement.Slide.PerWeap",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SilencedPistol = read.BoolFromString(var1[cfglines],"Movement.Slide.SilencedPistol",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.DesertEagle = read.BoolFromString(var1[cfglines],"Movement.Slide.DesertEagle",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.Shotgun = read.BoolFromString(var1[cfglines],"Movement.Slide.Shotgun",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.Sawnoff = read.BoolFromString(var1[cfglines],"Movement.Slide.Sawnoff",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.CombatShotgun = read.BoolFromString(var1[cfglines],"Movement.Slide.CombatShotgun",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.Mp5 = read.BoolFromString(var1[cfglines],"Movement.Slide.Mp5",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.Ak47 = read.BoolFromString(var1[cfglines],"Movement.Slide.Ak47",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.M4 = read.BoolFromString(var1[cfglines],"Movement.Slide.M4",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.CountryRifle = read.BoolFromString(var1[cfglines],"Movement.Slide.CountryRifle",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SniperRifle = read.BoolFromString(var1[cfglines],"Movement.Slide.SniperRifle",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.AutoC = read.BoolFromString(var1[cfglines],"Movement.Slide.AutoC",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SpeedEnable = read.BoolFromString(var1[cfglines],"Movement.Slide.SpeedEnable",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SpeedFakeSync = read.BoolFromString(var1[cfglines],"Movement.Slide.SpeedFakeSync",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.Speed = read.FloatFromString(var1[cfglines], "Movement.Slide.Speed",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SpeedDuration = read.IntFromString(var1[cfglines],"Movement.Slide.SpeedDuration",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SpeedChance = read.IntFromString(var1[cfglines],"Movement.Slide.SpeedChance",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SpeedGameSpeed = read.IntFromString(var1[cfglines],"Movement.Slide.SpeedGameSpeed",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SwitchVelocity[0] = read.IntFromString(var1[cfglines],"Movement.Slide.SwitchVelocity0",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SwitchVelocity[1] = read.IntFromString(var1[cfglines],"Movement.Slide.SwitchVelocity1",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SwitchVelocity[2] = read.IntFromString(var1[cfglines],"Movement.Slide.SwitchVelocity2",lines[cfglines]) cfglines = cfglines + 1
                Movement.Slide.SwitchVelocity[3] = read.IntFromString(var1[cfglines],"Movement.Slide.SwitchVelocity3",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.Enable = read.BoolFromString(var1[cfglines],"Movement.MacroRun.Enable",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.OnKey = read.BoolFromString(var1[cfglines],"Movement.MacroRun.OnKey",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.KeyType = read.IntFromString(var1[cfglines],"Movement.MacroRun.KeyType",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.Key = read.IntFromString(var1[cfglines],"Movement.MacroRun.Key",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.Speed = read.IntFromString(var1[cfglines],"Movement.MacroRun.Speed",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.Legit = read.BoolFromString(var1[cfglines],"Movement.MacroRun.Legit",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.SpeedBasedOnHp = read.BoolFromString(var1[cfglines],"Movement.MacroRun.SpeedBasedOnHp",lines[cfglines]) cfglines = cfglines + 1
                Movement.MacroRun.Bypass = read.BoolFromString(var1[cfglines],"Movement.MacroRun.Bypass",lines[cfglines]) cfglines = cfglines + 1
                Movement.AntiStun.Enable = read.BoolFromString(var1[cfglines],"Movement.AntiStun.Enable",lines[cfglines]) cfglines = cfglines + 1
                Movement.AntiStun.MinChance = read.IntFromString(var1[cfglines],"Movement.AntiStun.MinChance",lines[cfglines]) cfglines = cfglines + 1
                Movement.AntiStun.IncreaseMinChance = read.IntFromString(var1[cfglines],"Movement.AntiStun.IncreaseMinChance",lines[cfglines]) cfglines = cfglines + 1
                Movement.AntiStun.Timer = read.IntFromString(var1[cfglines],"Movement.AntiStun.Timer",lines[cfglines]) cfglines = cfglines + 1
                Movement.AntiStun.AFK = read.BoolFromString(var1[cfglines],"Movement.AntiStun.AFK",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.Enable = read.BoolFromString(var1[cfglines],"Movement.FakeLagPeek.Enable",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.AtTarget = read.BoolFromString(var1[cfglines],"Movement.FakeLagPeek.AtTarget",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.DistanceFromWall = read.IntFromString(var1[cfglines],"Movement.FakeLagPeek.DistanceFromWall",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.Fov = read.FloatFromString(var1[cfglines],"Movement.FakeLagPeek.Fov",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.Time = read.IntFromString(var1[cfglines],"Movement.FakeLagPeek.Time",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.Delay = read.IntFromString(var1[cfglines],"Movement.FakeLagPeek.Delay",lines[cfglines]) cfglines = cfglines + 1
                Movement.FakeLagPeek.DrawWalls = read.BoolFromString(var1[cfglines],"Movement.FakeLagPeek.DrawWalls",lines[cfglines]) cfglines = cfglines + 1
                Movement.bUseCJWalk = read.BoolFromString(var1[cfglines],"Movement.bUseCJWalk",lines[cfglines]) cfglines = cfglines + 1
                Movement.ForceSkin = read.BoolFromString(var1[cfglines],"Movement.ForceSkin",lines[cfglines]) cfglines = cfglines + 1
                Movement.ChosenSkin = read.IntFromString(var1[cfglines],"Movement.ChosenSkin",lines[cfglines]) cfglines = cfglines + 1
                Movement.NoFall = read.BoolFromString(var1[cfglines],"Movement.NoFall",lines[cfglines]) cfglines = cfglines + 1
                Movement.NoFallNodamage = read.BoolFromString(var1[cfglines],"Movement.NoFallNodamage",lines[cfglines]) cfglines = cfglines + 1
                Movement.NoAnimations = read.BoolFromString(var1[cfglines],"Movement.NoAnimations",lines[cfglines]) cfglines = cfglines + 1
                Movement.RunEverywhere = read.BoolFromString(var1[cfglines],"Movement.RunEverywhere",lines[cfglines]) cfglines = cfglines + 1
                Movement.Fight = read.BoolFromString(var1[cfglines],"Movement.Fight",lines[cfglines]) cfglines = cfglines + 1
                Movement.FightStyle = read.IntFromString(var1[cfglines],"Movement.FightStyle",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.Enable = read.BoolFromString(var1[cfglines],"RadarHack.Enable",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.PlayerMarkers = read.BoolFromString(var1[cfglines],"RadarHack.PlayerMarkers",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.Onlyoutofview = read.BoolFromString(var1[cfglines],"RadarHack.Onlyoutofview",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.AfterDamage = read.BoolFromString(var1[cfglines],"RadarHack.AfterDamage",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.ShowLine = read.BoolFromString(var1[cfglines],"RadarHack.ShowLine",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.ShowName = read.BoolFromString(var1[cfglines],"RadarHack.ShowName",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.ShowHP = read.BoolFromString(var1[cfglines],"RadarHack.ShowHP",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.HPSize = read.IntFromString(var1[cfglines],"RadarHack.HPSize",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.HPHeight = read.IntFromString(var1[cfglines],"RadarHack.HPHeight",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.LinkedToChar = read.BoolFromString(var1[cfglines],"RadarHack.LinkedToChar",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.Bone = read.IntFromString(var1[cfglines],"RadarHack.Bone",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.MaxPlayers = read.IntFromString(var1[cfglines],"RadarHack.MaxPlayers",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.X = read.FloatFromString(var1[cfglines],"RadarHack.X",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.Y = read.FloatFromString(var1[cfglines],"RadarHack.Y",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.maxLength = read.FloatFromString(var1[cfglines],"RadarHack.maxLength",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.lowDistance = read.IntFromString(var1[cfglines ],"RadarHack.lowDistance",lines[cfglines]) cfglines = cfglines + 1
                RadarHack.maxDistance = read.IntFromString(var1[cfglines ],"RadarHack.maxDistance",lines[cfglines]) cfglines = cfglines + 1
                StreamWall.Enable = read.BoolFromString(var1[cfglines],"StreamWall.Enable",lines[cfglines]) cfglines = cfglines + 1
                StreamWall.AFK = read.BoolFromString(var1[cfglines],"StreamWall.AFK",lines[cfglines]) cfglines = cfglines + 1
                StreamWall.HP = read.BoolFromString(var1[cfglines],"StreamWall.HP",lines[cfglines]) cfglines = cfglines + 1
                StreamWall.MaxPlayers = read.IntFromString(var1[cfglines],"StreamWall.MaxPlayers",lines[cfglines]) cfglines = cfglines + 1
                StreamWall.X = read.FloatFromString(var1[cfglines],"StreamWall.X",lines[cfglines]) cfglines = cfglines + 1
                StreamWall.Y = read.FloatFromString(var1[cfglines],"StreamWall.Y",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot0.brass = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot0.brass",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.golf = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.golf",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.nitestick = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.nitestick",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.knife = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.knife",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.bat = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.bat",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.shovel = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.shovel",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.pool = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.pool",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.katana = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.katana",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot1.chainsaw = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot1.chainsaw",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot2.colt = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot2.colt",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot2.silenced = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot2.silenced",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot2.desert = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot2.desert",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot3.shotgun = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot3.shotgun",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot3.sawnoff = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot3.sawnoff",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot3.spas = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot3.spas",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot4.uzi = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot4.uzi",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot4.mp5 = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot4.mp5",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot4.tec9 = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot4.tec9",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot5.ak47 = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot5.ak47",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot5.m4 = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot5.m4",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot6.cuntgun = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot6.cuntgun",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot6.sniper = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot6.sniper",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot7.rocket = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot7.rocket",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot7.heatseeker = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot7.heatseeker",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot7.flamethrower = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot7.flamethrower",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot7.minigun = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot7.minigun",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot8.satchel = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot8.satchel",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot8.grenade = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot8.grenade",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot8.teargas = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot8.teargas",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot9.spraycan = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot9.spraycan",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot9.extinguisher = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot9.extinguisher",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot9.camera = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot9.camera",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot10.purple = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot10.purple",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot10.dildo = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot10.dildo",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot10.vibrator = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot10.vibrator",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot10.silver = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot10.silver",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot10.flowers = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot10.flowers",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot10.cane = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot10.cane",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot11.night = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot11.night",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot11.thermal = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot11.thermal",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot11.Parachute = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot11.Parachute",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoDeleteWeapon.Slot12.detonator = read.BoolFromString(var1[cfglines],"Extra.AutoDeleteWeapon.Slot12.detonator",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Enable = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Enable",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Mode = read.IntFromString(var1[cfglines],"Extra.fuckKeyStrokes.Mode",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.fire = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.fire",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.aim = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.aim",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.horn_crouch = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.horn_crouch",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.enterExitCar = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.enterExitCar",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.sprint = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.sprint",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.jump = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.jump",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.landingGear_lookback = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.landingGear_lookback",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.walk = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.walk",lines[cfglines]) cfglines = cfglines + 1
                Extra.fuckKeyStrokes.Key.tab = read.BoolFromString(var1[cfglines],"Extra.fuckKeyStrokes.Key.tab",lines[cfglines]) cfglines = cfglines + 1
                Extra.RemoveObjectTemp.Enable = read.BoolFromString(var1[cfglines],"Extra.RemoveObjectTemp.Enable",lines[cfglines]) cfglines = cfglines + 1
                Extra.RemoveObjectTemp.Key = read.IntFromString(var1[cfglines],"Extra.RemoveObjectTemp.Key",lines[cfglines]) cfglines = cfglines + 1
                Extra.RemoveObjectTemp.Time = read.IntFromString(var1[cfglines],"Extra.RemoveObjectTemp.Time",lines[cfglines]) cfglines = cfglines + 1
                Extra.Mobile = read.BoolFromString(var1[cfglines],"Extra.Mobile",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoReply[0] = read.BoolFromString(var1[cfglines],"Extra.AutoReply0",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoReply[1] = read.BoolFromString(var1[cfglines],"Extra.AutoReply1",lines[cfglines]) cfglines = cfglines + 1
                Extra.AutoReply[2] = read.BoolFromString(var1[cfglines],"Extra.AutoReply2",lines[cfglines]) cfglines = cfglines + 1
                Extra.Message[1] = read.BufferFromString(var1[cfglines],"Extra.Message1",lines[cfglines]) cfglines = cfglines + 1
                Extra.Message[2] = read.BufferFromString(var1[cfglines],"Extra.Message2",lines[cfglines]) cfglines = cfglines + 1
                Extra.Reply[1] = read.BufferFromString(var1[cfglines],"Extra.Reply1",lines[cfglines]) cfglines = cfglines + 1
                Extra.Reply[2] = read.BufferFromString(var1[cfglines],"Extra.Reply2",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.Enable = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.Enable",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.OnKey = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.OnKey",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.Key = read.IntFromString(var1[cfglines],"Extra.ExtraWS.Key",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.KeyType = read.IntFromString(var1[cfglines],"Extra.ExtraWS.KeyType",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.X = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.X",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.Y = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.Y",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.Enable = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.Enable",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.PerCategory.Pistols = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.PerCategory.Pistols",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.PerCategory.Shotguns = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.PerCategory.Shotguns",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.PerCategory.SMGs = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.PerCategory.SMGs",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.PerCategory.Rifles = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.PerCategory.Rifles",lines[cfglines]) cfglines = cfglines + 1
                Extra.ExtraWS.PerCategory.Snipers = read.BoolFromString(var1[cfglines],"Extra.ExtraWS.PerCategory.Snipers",lines[cfglines]) cfglines = cfglines + 1
                Extra.SetWeaponSkill = read.BoolFromString(var1[cfglines],"Extra.SetWeaponSkill",lines[cfglines]) cfglines = cfglines + 1
                Extra.SetWeaponSkillLevel = read.IntFromString(var1[cfglines],"Extra.SetWeaponSkillLevel",lines[cfglines]) cfglines = cfglines + 1
                Extra.SendCMD.Enable = read.BoolFromString(var1[cfglines],"Extra.SendCMD.Enable",lines[cfglines]) cfglines = cfglines + 1
                Extra.SendCMD.Command = read.BufferFromString(var1[cfglines],"Extra.SendCMD.Command",lines[cfglines]) cfglines = cfglines + 1
                Extra.SendCMD.Times = read.IntFromString(var1[cfglines],"Extra.SendCMD.Times",lines[cfglines]) cfglines = cfglines + 1
                Extra.SendCMD.Delay = read.IntFromString(var1[cfglines],"Extra.SendCMD.Delay",lines[cfglines]) cfglines = cfglines + 1
                Extra.SendCMD.HP = read.IntFromString(var1[cfglines],"Extra.SendCMD.HP",lines[cfglines]) cfglines = cfglines + 1
                Extra.SendCMD.Armour = read.IntFromString(var1[cfglines],"Extra.SendCMD.Armour",lines[cfglines]) cfglines = cfglines + 1
                Extra.PickUP.Enable = read.BoolFromString(var1[cfglines],"Extra.PickUP.Enable",lines[cfglines]) cfglines = cfglines + 1 
                Extra.PickUP.Model1 = read.IntFromString(var1[cfglines],"Extra.PickUP.Model1",lines[cfglines]) cfglines = cfglines + 1 
                Extra.PickUP.Model2 = read.IntFromString(var1[cfglines],"Extra.PickUP.Model2",lines[cfglines]) cfglines = cfglines + 1 
                Extra.PickUP.Model3 = read.IntFromString(var1[cfglines],"Extra.PickUP.Model3",lines[cfglines]) cfglines = cfglines + 1 
                Extra.PickUP.Delay = read.IntFromString(var1[cfglines],"Extra.PickUP.Delay",lines[cfglines]) cfglines = cfglines + 1 
                Extra.PickUP.HP = read.IntFromString(var1[cfglines],"Extra.PickUP.HP",lines[cfglines]) cfglines = cfglines + 1 
                Extra.PickUP.Armour = read.IntFromString(var1[cfglines],"Extra.PickUP.Armour",lines[cfglines]) cfglines = cfglines + 1 
                Extra.RequestSpawn = read.BoolFromString(var1[cfglines],"Extra.RequestSpawn",lines[cfglines]) cfglines = cfglines + 1
                Extra.RequestSpawnHP = read.IntFromString(var1[cfglines],"Extra.RequestSpawnHP",lines[cfglines]) cfglines = cfglines + 1
                Extra.RequestSpawnArmour = read.IntFromString(var1[cfglines],"Extra.RequestSpawnArmour",lines[cfglines]) cfglines = cfglines + 1
                Extra.AntiFreeze = read.BoolFromString(var1[cfglines],"Extra.AntiFreeze",lines[cfglines]) cfglines = cfglines + 1
                Extra.AntiSniper = read.BoolFromString(var1[cfglines],"Extra.AntiSniper",lines[cfglines]) cfglines = cfglines + 1
                Extra.AntiSniperTypeMode = read.IntFromString(var1[cfglines],"Extra.AntiSniperTypeMode",lines[cfglines]) cfglines = cfglines + 1
                Extra.AntiSniperChance = read.IntFromString(var1[cfglines],"Extra.AntiSniperChance",lines[cfglines]) cfglines = cfglines + 1
                Extra.IgnoreWater = read.BoolFromString(var1[cfglines],"Extra.IgnoreWater",lines[cfglines]) cfglines = cfglines + 1
                Extra.AntiAFK = read.BoolFromString(var1[cfglines],"Extra.AntiAFK",lines[cfglines]) cfglines = cfglines + 1
                Extra.AntiSlapper = read.BoolFromString(var1[cfglines],"Extra.AntiSlapper",lines[cfglines]) cfglines = cfglines + 1
                Extra.ForceGravity = read.BoolFromString(var1[cfglines],"Extra.ForceGravity",lines[cfglines]) cfglines = cfglines + 1
                Extra.GravityFloat = read.FloatFromString(var1[cfglines],"Extra.GravityFloat",lines[cfglines]) cfglines = cfglines + 1
                Extra.SpecialAction = read.IntFromString(var1[cfglines],"Extra.SpecialAction",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.Unlock = read.BoolFromString(var1[cfglines],"Vehicle.Unlock",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.AutoAttachTrailer = read.BoolFromString(var1[cfglines],"Vehicle.AutoAttachTrailer",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.NeverOffEngine = read.BoolFromString(var1[cfglines],"Vehicle.NeverOffEngine",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.DriveNoLicense = read.BoolFromString(var1[cfglines],"Vehicle.DriveNoLicense",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.DriveNoLicenseFakeData = read.BoolFromString(var1[cfglines],"Vehicle.DriveNoLicenseFakeData",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.FastExit = read.BoolFromString(var1[cfglines],"Vehicle.FastExit",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.AntiCarJack = read.BoolFromString(var1[cfglines],"Vehicle.AntiCarJack",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.AntiCarFlip = read.BoolFromString(var1[cfglines],"Vehicle.AntiCarFlip",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.NeverPopTire = read.BoolFromString(var1[cfglines],"Vehicle.NeverPopTire",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.BoatFly = read.BoolFromString(var1[cfglines],"Vehicle.BoatFly",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.PerfectHandling = read.BoolFromString(var1[cfglines],"Vehicle.PerfectHandling",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.PerfectHandlingOnKey = read.BoolFromString(var1[cfglines],"Vehicle.PerfectHandlingOnKey",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.PerfectHandlingKey = read.IntFromString(var1[cfglines],"Vehicle.PerfectHandlingKey",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.FreezeRot = read.BoolFromString(var1[cfglines],"Vehicle.FreezeRot",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.PotatoCars = read.BoolFromString(var1[cfglines],"Vehicle.PotatoCars",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.PotatoType = read.IntFromString(var1[cfglines],"Vehicle.PotatoType",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.NoCarCollision = read.BoolFromString(var1[cfglines],"Vehicle.NoCarCollision",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.NoCarCollisionKey = read.IntFromString(var1[cfglines],"Vehicle.NoCarCollisionKey",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.InfinityNitrous = read.BoolFromString(var1[cfglines],"Vehicle.InfinityNitrous",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.InfinityNitrousType = read.IntFromString(var1[cfglines],"Vehicle.InfinityNitrousType",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.Recovery = read.BoolFromString(var1[cfglines],"Vehicle.Recovery",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.RecoverParts = read.BoolFromString(var1[cfglines],"Vehicle.RecoverParts",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.ChosenTimer = read.IntFromString(var1[cfglines],"Vehicle.ChosenTimer",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.HPAmount = read.FloatFromString(var1[cfglines],"Vehicle.HPAmount",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.LimitVelocity = read.BoolFromString(var1[cfglines],"Vehicle.LimitVelocity",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.SmartLimitMaxVelocity = read.BoolFromString(var1[cfglines],"Vehicle.SmartLimitMaxVelocity",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.LimitVelocityOnKey = read.BoolFromString(var1[cfglines],"Vehicle.LimitVelocityOnKey",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.LimitVelocityKey = read.IntFromString(var1[cfglines],"Vehicle.LimitVelocityKey",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.Velocity = read.IntFromString(var1[cfglines],"Vehicle.Velocity",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.CarJump = read.BoolFromString(var1[cfglines],"Vehicle.CarJump",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.CarJumpKey = read.IntFromString(var1[cfglines],"Vehicle.CarJumpKey",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.Height = read.FloatFromString(var1[cfglines],"Vehicle.Height",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.AutoMotorbike = read.BoolFromString(var1[cfglines],"Vehicle.AutoMotorbike",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.MotorbikeDelay = read.IntFromString(var1[cfglines],"Vehicle.MotorbikeDelay",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.AutoBike = read.BoolFromString(var1[cfglines],"Vehicle.AutoBike",lines[cfglines]) cfglines = cfglines + 1
                Vehicle.BikeDelay = read.IntFromString(var1[cfglines],"Vehicle.BikeDelay",lines[cfglines]) cfglines = cfglines + 1
                Filters.Enable = read.BoolFromString(var1[cfglines],"Filters.Enable",lines[cfglines]) cfglines = cfglines + 1 
                Filters.X = read.FloatFromString(var1[cfglines],"Filters.X",lines[cfglines]) cfglines = cfglines + 1 
                Filters.Y = read.FloatFromString(var1[cfglines],"Filters.Y",lines[cfglines]) cfglines = cfglines + 1 
                Indicator.Enable = read.BoolFromString(var1[cfglines],"Indicator.Enable",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.Damager = read.BoolFromString(var1[cfglines],"Indicator.Damager",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.Silent = read.BoolFromString(var1[cfglines],"Indicator.Silent",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.MacroRun = read.BoolFromString(var1[cfglines],"Indicator.MacroRun",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.Slide = read.BoolFromString(var1[cfglines],"Indicator.Slide",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.FakeLagPeek = read.BoolFromString(var1[cfglines],"Indicator.FakeLagPeek",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.SlideSpeed = read.BoolFromString(var1[cfglines],"Indicator.SlideSpeed",lines[cfglines]) cfglines = cfglines + 1 
                Indicator.AntiStun = read.BoolFromString(var1[cfglines],"Indicator.AntiStun",lines[cfglines]) cfglines = cfglines + 1 
                Indicator.Godmode = read.BoolFromString(var1[cfglines],"Indicator.Godmode",lines[cfglines]) cfglines = cfglines + 1  
                Indicator.X = read.FloatFromString(var1[cfglines],"Indicator.X",lines[cfglines]) cfglines = cfglines + 1 
                Indicator.Y = read.FloatFromString(var1[cfglines],"Indicator.Y",lines[cfglines]) cfglines = cfglines + 1 
                Teleport.Enable = read.BoolFromString(var1[cfglines],"Teleport.Enable",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.FromGround = read.BoolFromString(var1[cfglines],"Teleport.FromGround",lines[cfglines]) cfglines = cfglines + 1 
                Teleport.PersonalDelay = read.IntFromString(var1[cfglines],"Teleport.PersonalDelay",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.ACDelay = read.IntFromString(var1[cfglines],"Teleport.ACDelay",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.OnFootVelocity = read.FloatFromString(var1[cfglines],"Teleport.OnFootVelocity",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.InCarVelocity = read.FloatFromString(var1[cfglines],"Teleport.InCarVelocity",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.toPlayer = read.BoolFromString(var1[cfglines],"Teleport.toPlayer",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.toPlayerKey = read.IntFromString(var1[cfglines],"Teleport.toPlayerKey",lines[cfglines]) cfglines = cfglines + 1 
                Teleport.toVehicle = read.BoolFromString(var1[cfglines],"Teleport.toVehicle",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.toInside = read.BoolFromString(var1[cfglines],"Teleport.toInside",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.toVehicleType = read.IntFromString(var1[cfglines],"Teleport.toVehicleType",lines[cfglines]) cfglines = cfglines + 1 
                Teleport.toVehicleDriver = read.BoolFromString(var1[cfglines],"Teleport.toVehicleDriver",lines[cfglines]) cfglines = cfglines + 1 
                Teleport.toVehicleKey = read.IntFromString(var1[cfglines],"Teleport.toVehicleKey",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.toCheckpoint = read.BoolFromString(var1[cfglines],"Teleport.toCheckpoint",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.CheckpointKey = read.IntFromString(var1[cfglines],"Teleport.CheckpointKey",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.HvH = read.BoolFromString(var1[cfglines],"Teleport.HvH",lines[cfglines]) cfglines = cfglines + 1
                Teleport.HVHDeath = read.BoolFromString(var1[cfglines],"Teleport.HVHDeath",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.HVHAFK = read.BoolFromString(var1[cfglines],"Teleport.HVHAFK",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.HvHAntiKick = read.BoolFromString(var1[cfglines],"Teleport.HvHAntiKick",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.HvHKey = read.IntFromString(var1[cfglines],"Teleport.HvHKey",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.HVHWait = read.IntFromString(var1[cfglines],"Teleport.HVHWait",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.AttachToVehicle = read.BoolFromString(var1[cfglines],"Teleport.AttachToVehicle",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.toObject = read.BoolFromString(var1[cfglines],"Teleport.toObject",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.ObjectKey = read.IntFromString(var1[cfglines],"Teleport.ObjectKey",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.Jumper = read.BoolFromString(var1[cfglines],"Teleport.Jumper",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.JumperKey = read.IntFromString(var1[cfglines],"Teleport.JumperKey",lines[cfglines]) cfglines = cfglines + 1  

                Teleport.ShowSaveTeleports = read.BoolFromString(var1[cfglines],"Teleport.ShowSaveTeleports",lines[cfglines]) cfglines = cfglines + 1  
                Teleport.SavedPos[0] = read.VectorFromString(
                    var1[cfglines],"Teleport.SavedPos0.fX",lines[cfglines],  
                    var1[cfglines+1],"Teleport.SavedPos0.fY",lines[cfglines+1],
                    var1[cfglines+2],"Teleport.SavedPos0.fZ",lines[cfglines+2]) cfglines = cfglines + 3 
                Teleport.SavedPos[1] = read.VectorFromString(
                    var1[cfglines],"Teleport.SavedPos1.fX",lines[cfglines],  
                    var1[cfglines+1],"Teleport.SavedPos1.fY",lines[cfglines+1],
                    var1[cfglines+2],"Teleport.SavedPos1.fZ",lines[cfglines+2]) cfglines = cfglines + 3 
                Teleport.SavedPos[2] = read.VectorFromString(
                    var1[cfglines],"Teleport.SavedPos2.fX",lines[cfglines],  
                    var1[cfglines+1],"Teleport.SavedPos2.fY",lines[cfglines+1],
                    var1[cfglines+2],"Teleport.SavedPos2.fZ",lines[cfglines+2]) cfglines = cfglines + 3 
                Teleport.SavedPos[3] = read.VectorFromString(
                    var1[cfglines],"Teleport.SavedPos3.fX",lines[cfglines],  
                    var1[cfglines+1],"Teleport.SavedPos3.fY",lines[cfglines+1],
                    var1[cfglines+2],"Teleport.SavedPos3.fZ",lines[cfglines+2]) cfglines = cfglines + 3 
                Troll.FakePos.Enable = read.BoolFromString(var1[cfglines],"Troll.FakePos.Enable",lines[cfglines]) cfglines = cfglines + 1
                Troll.FakePos.RandomPos = read.BoolFromString(var1[cfglines],"Troll.FakePos.RandomPos",lines[cfglines]) cfglines = cfglines + 1
                Troll.FakePos.OnFoot = read.BoolFromString(var1[cfglines],"Troll.FakePos.OnFoot",lines[cfglines]) cfglines = cfglines + 1
                Troll.FakePos.InCar = read.BoolFromString(var1[cfglines],"Troll.FakePos.InCar",lines[cfglines]) cfglines = cfglines + 1
                Troll.FakePos.X = read.FloatFromString(var1[cfglines],"Troll.FakePos.X",lines[cfglines]) cfglines = cfglines + 1
                Troll.FakePos.Y = read.FloatFromString(var1[cfglines],"Troll.FakePos.Y",lines[cfglines]) cfglines = cfglines + 1
                Troll.FuckSync = read.BoolFromString(var1[cfglines],"Troll.FuckSync",lines[cfglines]) cfglines = cfglines + 1
                Troll.Slapper.Enable = read.BoolFromString(var1[cfglines],"Troll.Slapper.Enable",lines[cfglines]) cfglines = cfglines + 1
                Troll.Slapper.OnKey = read.BoolFromString(var1[cfglines],"Troll.Slapper.OnKey",lines[cfglines]) cfglines = cfglines + 1
                Troll.Slapper.Key = read.IntFromString(var1[cfglines],"Troll.Slapper.Key",lines[cfglines]) cfglines = cfglines + 1
                Troll.RVanka.Enable = read.BoolFromString(var1[cfglines],"Troll.RVanka.Enable",lines[cfglines]) cfglines = cfglines + 1 
                Troll.RVanka.OnKey = read.BoolFromString(var1[cfglines],"Troll.RVanka.OnKey",lines[cfglines]) cfglines = cfglines + 1 
                Troll.RVanka.KeyType = read.IntFromString(var1[cfglines],"Troll.RVanka.KeyType",lines[cfglines]) cfglines = cfglines + 1 
                Troll.RVanka.Key = read.IntFromString(var1[cfglines],"Troll.RVanka.Key",lines[cfglines]) cfglines = cfglines + 1 
                Troll.RVanka.Speed = read.FloatFromString(var1[cfglines],"Troll.RVanka.Speed",lines[cfglines]) cfglines = cfglines + 1 
                Troll.RVanka.Distance = read.IntFromString(var1[cfglines ],"Troll.RVanka.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Troll.RVanka.Timer = read.IntFromString(var1[cfglines],"Troll.RVanka.Timer",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Enable = read.BoolFromString(var1[cfglines],"Damager.Enable",lines[cfglines]) cfglines = cfglines + 1 
                Damager.OnKey = read.BoolFromString(var1[cfglines],"Damager.OnKey",lines[cfglines]) cfglines = cfglines + 1 
                Damager.KeyType = read.IntFromString(var1[cfglines],"Damager.KeyType",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Key = read.IntFromString(var1[cfglines],"Damager.Key",lines[cfglines]) cfglines = cfglines + 1 
                Damager.IgnoreGiveTakeDamage = read.BoolFromString(var1[cfglines],"Damager.IgnoreGiveTakeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Damager.ChangeDamage = read.BoolFromString(var1[cfglines],"Damager.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Damage = read.FloatFromString(var1[cfglines],"Damager.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Damager.CurrentWeapon = read.BoolFromString(var1[cfglines],"Damager.CurrentWeapon",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Weapon = read.IntFromString(var1[cfglines],"Damager.Weapon",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Chance = read.IntFromString(var1[cfglines],"Damager.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Damager.DistanceEnable = read.BoolFromString(var1[cfglines],"Damager.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Distance = read.IntFromString(var1[cfglines ],"Damager.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Bullets = read.IntFromString(var1[cfglines],"Damager.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Damager.TargetType = read.IntFromString(var1[cfglines],"Damager.TargetType",lines[cfglines]) cfglines = cfglines + 1 
                Damager.VisibleChecks = read.BoolFromString(var1[cfglines],"Damager.VisibleChecks",lines[cfglines]) cfglines = cfglines + 1
                Damager.Bone = read.IntFromString(var1[cfglines],"Damager.Bone",lines[cfglines]) cfglines = cfglines + 1
                Damager.Force = read.BoolFromString(var1[cfglines],"Damager.Force",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Delay = read.IntFromString(var1[cfglines],"Damager.Delay",lines[cfglines]) cfglines = cfglines + 1 
                Damager.EmulCbug = read.BoolFromString(var1[cfglines],"Damager.EmulCbug",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncAim = read.BoolFromString(var1[cfglines],"Damager.SyncAim",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncOnfootData = read.BoolFromString(var1[cfglines],"Damager.SyncOnfootData",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncRotation = read.BoolFromString(var1[cfglines],"Damager.SyncRotation",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncBullet.Enable = read.BoolFromString(var1[cfglines],"Damager.SyncBullet.Enable",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncBullet.Type = read.IntFromString(var1[cfglines],"Damager.SyncBullet.Type",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncWeapon = read.BoolFromString(var1[cfglines],"Damager.SyncWeapon",lines[cfglines]) cfglines = cfglines + 1 
                Damager.DeathNotification = read.BoolFromString(var1[cfglines],"Damager.DeathNotification",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Spawn = read.BoolFromString(var1[cfglines],"Damager.Spawn",lines[cfglines]) cfglines = cfglines + 1 
                Damager.SyncPos = read.BoolFromString(var1[cfglines],"Damager.SyncPos",lines[cfglines]) cfglines = cfglines + 1 
                Damager.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Damager.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1 
                Damager.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Damager.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1 
                Damager.ShowHitPos = read.BoolFromString(var1[cfglines],"Damager.ShowHitPos",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Clist = read.BoolFromString(var1[cfglines],"Damager.Clist",lines[cfglines]) cfglines = cfglines + 1 
                Damager.AFK = read.BoolFromString(var1[cfglines],"Damager.AFK",lines[cfglines]) cfglines = cfglines + 1 
                Damager.Death = read.BoolFromString(var1[cfglines],"Damager.Death",lines[cfglines]) cfglines = cfglines + 1 
                Damager.TakeDamage = read.BoolFromString(var1[cfglines],"Damager.TakeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Damager.OnlyStreamed = read.BoolFromString(var1[cfglines],"Damager.OnlyStreamed",lines[cfglines]) cfglines = cfglines + 1 
                Damager.gtdID = read.IntFromString(var1[cfglines],"Damager.gtdID",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Enable = read.BoolFromString(var1[cfglines],"DamageChanger.Enable",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.OnKey = read.BoolFromString(var1[cfglines],"DamageChanger.OnKey",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Key = read.IntFromString(var1[cfglines],"DamageChanger.Key",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.KeyType = read.IntFromString(var1[cfglines],"DamageChanger.KeyType",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Pistols.Enable = read.BoolFromString(var1[cfglines],"DamageChanger.Pistols.Enable",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Pistols.DMG = read.FloatFromString(var1[cfglines],"DamageChanger.Pistols.DMG",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Shotguns.Enable = read.BoolFromString(var1[cfglines],"DamageChanger.Shotguns.Enable",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Shotguns.DMG = read.FloatFromString(var1[cfglines],"DamageChanger.Shotguns.DMG",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.SMGs.Enable = read.BoolFromString(var1[cfglines],"DamageChanger.SMGs.Enable",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.SMGs.DMG = read.FloatFromString(var1[cfglines],"DamageChanger.SMGs.DMG",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Rifles.Enable = read.BoolFromString(var1[cfglines],"DamageChanger.Rifles.Enable",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Rifles.DMG = read.FloatFromString(var1[cfglines],"DamageChanger.Rifles.DMG",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Snipers.Enable = read.BoolFromString(var1[cfglines],"DamageChanger.Snipers.Enable",lines[cfglines]) cfglines = cfglines + 1 
                DamageChanger.Snipers.DMG = read.FloatFromString(var1[cfglines],"DamageChanger.Snipers.DMG",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Enable = read.BoolFromString(var1[cfglines],"Silent.Enable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.OnKey = read.BoolFromString(var1[cfglines],"Silent.OnKey",lines[cfglines]) cfglines = cfglines + 1 
                Silent.KeyType = read.IntFromString(var1[cfglines],"Silent.KeyType",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Key = read.IntFromString(var1[cfglines],"Silent.Key",lines[cfglines]) cfglines = cfglines + 1  
                Silent.DrawFov = read.BoolFromString(var1[cfglines],"Silent.DrawFov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Force = read.BoolFromString(var1[cfglines],"Silent.Force",lines[cfglines]) cfglines = cfglines + 1 
                Silent.WallShot = read.BoolFromString(var1[cfglines],"Silent.WallShot",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Clist = read.BoolFromString(var1[cfglines],"Silent.Clist",lines[cfglines]) cfglines = cfglines + 1 
                Silent.AFK = read.BoolFromString(var1[cfglines],"Silent.AFK",lines[cfglines]) cfglines = cfglines + 1 
                Silent.AFK = read.BoolFromString(var1[cfglines],"Silent.AFK",lines[cfglines]) cfglines = cfglines + 1 
                Silent.InVehicle = read.BoolFromString(var1[cfglines],"Silent.InVehicle",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.Fov = read.FloatFromString(var1[cfglines],"Silent.Pistols.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.FirstShots.Fov = read.FloatFromString(var1[cfglines],"Silent.Pistols.FirstShots.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.FirstShots.Shots = read.IntFromString(var1[cfglines],"Silent.Pistols.FirstShots.Shots",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.VisibleCheck.Buildings = read.BoolFromString(var1[cfglines],"Silent.Pistols.VisibleCheck.Buildings",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.DistanceEnable = read.BoolFromString(var1[cfglines],"Silent.Pistols.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.Distance = read.IntFromString(var1[cfglines ],"Silent.Pistols.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.ChangeDamage = read.BoolFromString(var1[cfglines],"Silent.Pistols.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.Bullets = read.IntFromString(var1[cfglines],"Silent.Pistols.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.Damage = read.FloatFromString(var1[cfglines],"Silent.Pistols.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.Chance = read.IntFromString(var1[cfglines],"Silent.Pistols.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.FirstShots.Chance = read.IntFromString(var1[cfglines],"Silent.Pistols.FirstShots.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.Bones.Head = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.Head",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Bones.Chest = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.Chest",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Bones.Stomach = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.Stomach",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Bones.LeftArm = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.LeftArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Bones.RightArm = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.RightArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Bones.LeftLeg = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.LeftLeg",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Bones.RightLeg = read.BoolFromString(var1[cfglines],"Silent.Pistols.Bones.RightLeg",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Pistols.Spread.Min = read.FloatFromString(var1[cfglines],"Silent.Pistols.Spread.Min",lines[cfglines]) cfglines = cfglines + 1
                Silent.Pistols.Spread.Max = read.FloatFromString(var1[cfglines],"Silent.Pistols.Spread.Max",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Silent.Pistols.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Pistols.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Silent.Pistols.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.Fov = read.FloatFromString(var1[cfglines],"Silent.Shotguns.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.FirstShots.Fov = read.FloatFromString(var1[cfglines],"Silent.Shotguns.FirstShots.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.FirstShots.Shots = read.IntFromString(var1[cfglines],"Silent.Shotguns.FirstShots.Shots",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.VisibleCheck.Buildings = read.BoolFromString(var1[cfglines],"Silent.Shotguns.VisibleCheck.Buildings",lines[cfglines]) cfglines = cfglines + 1
                Silent.Shotguns.DistanceEnable = read.BoolFromString(var1[cfglines],"Silent.Shotguns.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.Distance = read.IntFromString(var1[cfglines ],"Silent.Shotguns.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.ChangeDamage = read.BoolFromString(var1[cfglines],"Silent.Shotguns.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.Bullets = read.IntFromString(var1[cfglines],"Silent.Shotguns.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.Damage = read.FloatFromString(var1[cfglines],"Silent.Shotguns.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.Chance = read.IntFromString(var1[cfglines],"Silent.Shotguns.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.FirstShots.Chance = read.IntFromString(var1[cfglines],"Silent.Shotguns.FirstShots.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.Bones.Head = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.Head",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Shotguns.Bones.Chest = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.Chest",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Shotguns.Bones.Stomach = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.Stomach",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Shotguns.Bones.LeftArm = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.LeftArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Shotguns.Bones.RightArm = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.RightArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Shotguns.Bones.LeftLeg = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.LeftLeg",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Shotguns.Bones.RightLeg = read.BoolFromString(var1[cfglines],"Silent.Shotguns.Bones.RightLeg",lines[cfglines]) cfglines = cfglines + 1
                Silent.Shotguns.Spread.Min = read.FloatFromString(var1[cfglines],"Silent.Shotguns.Spread.Min",lines[cfglines]) cfglines = cfglines + 1
                Silent.Shotguns.Spread.Max = read.FloatFromString(var1[cfglines],"Silent.Shotguns.Spread.Max",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Shotguns.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Silent.Shotguns.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1
                Silent.Shotguns.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Silent.Shotguns.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1
                Silent.Smgs.Fov = read.FloatFromString(var1[cfglines],"Silent.Smgs.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.FirstShots.Fov = read.FloatFromString(var1[cfglines],"Silent.Smgs.FirstShots.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.FirstShots.Shots = read.IntFromString(var1[cfglines],"Silent.Smgs.FirstShots.Shots",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.VisibleCheck.Buildings = read.BoolFromString(var1[cfglines],"Silent.Smgs.VisibleCheck.Buildings",lines[cfglines]) cfglines = cfglines + 1
                Silent.Smgs.DistanceEnable = read.BoolFromString(var1[cfglines],"Silent.Smgs.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.Distance = read.IntFromString(var1[cfglines ],"Silent.Smgs.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.ChangeDamage = read.BoolFromString(var1[cfglines],"Silent.Smgs.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.Bullets = read.IntFromString(var1[cfglines],"Silent.Smgs.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.Damage = read.FloatFromString(var1[cfglines],"Silent.Smgs.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.Chance = read.IntFromString(var1[cfglines],"Silent.Smgs.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.FirstShots.Chance = read.IntFromString(var1[cfglines],"Silent.Smgs.FirstShots.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.Bones.Head = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.Head",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Smgs.Bones.Chest = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.Chest",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Smgs.Bones.Stomach = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.Stomach",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Smgs.Bones.LeftArm = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.LeftArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Smgs.Bones.RightArm = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.RightArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Smgs.Bones.LeftLeg = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.LeftLeg",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Smgs.Bones.RightLeg = read.BoolFromString(var1[cfglines],"Silent.Smgs.Bones.RightLeg",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Smgs.Spread.Min = read.FloatFromString(var1[cfglines],"Silent.Smgs.Spread.Min",lines[cfglines]) cfglines = cfglines + 1
                Silent.Smgs.Spread.Max = read.FloatFromString(var1[cfglines],"Silent.Smgs.Spread.Max",lines[cfglines]) cfglines = cfglines + 1
                Silent.Smgs.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Silent.Smgs.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1
                Silent.Smgs.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Silent.Smgs.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rifles.Fov = read.FloatFromString(var1[cfglines],"Silent.Rifles.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.FirstShots.Fov = read.FloatFromString(var1[cfglines],"Silent.Rifles.FirstShots.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.FirstShots.Shots = read.IntFromString(var1[cfglines],"Silent.Rifles.FirstShots.Shots",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.VisibleCheck.Buildings = read.BoolFromString(var1[cfglines],"Silent.Rifles.VisibleCheck.Buildings",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rifles.DistanceEnable = read.BoolFromString(var1[cfglines],"Silent.Rifles.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.Distance = read.IntFromString(var1[cfglines ],"Silent.Rifles.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.ChangeDamage = read.BoolFromString(var1[cfglines],"Silent.Rifles.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.Bullets = read.IntFromString(var1[cfglines],"Silent.Rifles.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.Damage = read.FloatFromString(var1[cfglines],"Silent.Rifles.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.Chance = read.IntFromString(var1[cfglines],"Silent.Rifles.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.FirstShots.Chance = read.IntFromString(var1[cfglines],"Silent.Rifles.FirstShots.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.Bones.Head = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.Head",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rifles.Bones.Chest = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.Chest",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rifles.Bones.Stomach = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.Stomach",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rifles.Bones.LeftArm = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.LeftArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rifles.Bones.RightArm = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.RightArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rifles.Bones.LeftLeg = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.LeftLeg",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rifles.Bones.RightLeg = read.BoolFromString(var1[cfglines],"Silent.Rifles.Bones.RightLeg",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rifles.Spread.Min = read.FloatFromString(var1[cfglines],"Silent.Rifles.Spread.Min",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rifles.Spread.Max = read.FloatFromString(var1[cfglines],"Silent.Rifles.Spread.Max",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rifles.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Silent.Rifles.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rifles.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Silent.Rifles.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1
                Silent.Snipers.Fov = read.FloatFromString(var1[cfglines],"Silent.Snipers.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.FirstShots.Fov = read.FloatFromString(var1[cfglines],"Silent.Snipers.FirstShots.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.FirstShots.Shots = read.IntFromString(var1[cfglines],"Silent.Snipers.FirstShots.Shots",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.VisibleCheck.Buildings = read.BoolFromString(var1[cfglines],"Silent.Snipers.VisibleCheck.Buildings",lines[cfglines]) cfglines = cfglines + 1
                Silent.Snipers.DistanceEnable = read.BoolFromString(var1[cfglines],"Silent.Snipers.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Distance = read.IntFromString(var1[cfglines ],"Silent.Snipers.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.ChangeDamage = read.BoolFromString(var1[cfglines],"Silent.Snipers.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Bullets = read.IntFromString(var1[cfglines],"Silent.Snipers.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Damage = read.FloatFromString(var1[cfglines],"Silent.Snipers.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Chance = read.IntFromString(var1[cfglines],"Silent.Snipers.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.FirstShots.Chance = read.IntFromString(var1[cfglines],"Silent.Snipers.FirstShots.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Bones.Head = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.Head",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Snipers.Bones.Chest = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.Chest",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Snipers.Bones.Stomach = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.Stomach",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Snipers.Bones.LeftArm = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.LeftArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Snipers.Bones.RightArm = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.RightArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Snipers.Bones.LeftLeg = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.LeftLeg",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Bones.RightLeg = read.BoolFromString(var1[cfglines],"Silent.Snipers.Bones.RightLeg",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Snipers.Spread.Min = read.FloatFromString(var1[cfglines],"Silent.Snipers.Spread.Min",lines[cfglines]) cfglines = cfglines + 1
                Silent.Snipers.Spread.Max = read.FloatFromString(var1[cfglines],"Silent.Snipers.Spread.Max",lines[cfglines]) cfglines = cfglines + 1
                Silent.Snipers.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Silent.Snipers.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1
                Silent.Snipers.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Silent.Snipers.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rockets.Fov = read.FloatFromString(var1[cfglines],"Silent.Rockets.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.FirstShots.Fov = read.FloatFromString(var1[cfglines],"Silent.Rockets.FirstShots.Fov",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.FirstShots.Shots = read.IntFromString(var1[cfglines],"Silent.Rockets.FirstShots.Shots",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.VisibleCheck.Buildings = read.BoolFromString(var1[cfglines],"Silent.Rockets.VisibleCheck.Buildings",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rockets.DistanceEnable = read.BoolFromString(var1[cfglines],"Silent.Rockets.DistanceEnable",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Distance = read.IntFromString(var1[cfglines ],"Silent.Rockets.Distance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.ChangeDamage = read.BoolFromString(var1[cfglines],"Silent.Rockets.ChangeDamage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Bullets = read.IntFromString(var1[cfglines],"Silent.Rockets.Bullets",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Damage = read.FloatFromString(var1[cfglines],"Silent.Rockets.Damage",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Chance = read.IntFromString(var1[cfglines],"Silent.Rockets.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.FirstShots.Chance = read.IntFromString(var1[cfglines],"Silent.Rockets.FirstShots.Chance",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Bones.Head = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.Head",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rockets.Bones.Chest = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.Chest",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rockets.Bones.Stomach = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.Stomach",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rockets.Bones.LeftArm = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.LeftArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rockets.Bones.RightArm = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.RightArm",lines[cfglines]) cfglines = cfglines + 1  
                Silent.Rockets.Bones.LeftLeg = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.LeftLeg",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Bones.RightLeg = read.BoolFromString(var1[cfglines],"Silent.Rockets.Bones.RightLeg",lines[cfglines]) cfglines = cfglines + 1 
                Silent.Rockets.Spread.Min = read.FloatFromString(var1[cfglines],"Silent.Rockets.Spread.Min",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rockets.Spread.Max = read.FloatFromString(var1[cfglines],"Silent.Rockets.Spread.Max",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rockets.VisibleCheck.Vehicles = read.BoolFromString(var1[cfglines],"Silent.Rockets.VisibleCheck.Vehicles",lines[cfglines]) cfglines = cfglines + 1
                Silent.Rockets.VisibleCheck.Objects = read.BoolFromString(var1[cfglines],"Silent.Rockets.VisibleCheck.Objects",lines[cfglines]) cfglines = cfglines + 1
                Silent.SyncRotation = read.BoolFromString(var1[cfglines],"Silent.SyncRotation",lines[cfglines]) cfglines = cfglines + 1
                Silent.SyncAimZ = read.BoolFromString(var1[cfglines],"Silent.SyncAimZ",lines[cfglines]) cfglines = cfglines + 1
                Silent.OnlyGiveTakeDamage = read.BoolFromString(var1[cfglines],"Silent.OnlyGiveTakeDamage",lines[cfglines]) cfglines = cfglines + 1
                Silent.OnlyGiveTakeDamageType = read.IntFromString(var1[cfglines],"Silent.OnlyGiveTakeDamageType",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.Enable = read.BoolFromString(var1[cfglines],"AimAssist.Enable",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.OnKey = read.BoolFromString(var1[cfglines],"AimAssist.OnKey",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.Key = read.IntFromString(var1[cfglines],"AimAssist.Key",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.KeyType = read.IntFromString(var1[cfglines],"AimAssist.KeyType",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.DrawFOV = read.BoolFromString(var1[cfglines],"AimAssist.DrawFOV",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.FOVType = read.IntFromString(var1[cfglines],"AimAssist.FOVType",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.FOV = read.FloatFromString(var1[cfglines],"AimAssist.FOV",lines[cfglines]) cfglines = cfglines + 1
                AimAssist.ForceWhoDamaged = read.BoolFromString(var1[cfglines],"AimAssist.ForceWhoDamaged",lines[cfglines]) cfglines = cfglines + 1
                Doublejump.Enable = read.BoolFromString(var1[cfglines],"Doublejump.Enable",lines[cfglines]) cfglines = cfglines + 1
                Doublejump.Height = read.FloatFromString(var1[cfglines],"Doublejump.Height",lines[cfglines]) cfglines = cfglines + 1
                Doublejump.OnKey = read.BoolFromString(var1[cfglines],"Doublejump.OnKey",lines[cfglines]) cfglines = cfglines + 1
                Doublejump.Key = read.IntFromString(var1[cfglines],"Doublejump.Key",lines[cfglines]) cfglines = cfglines + 1
                BulletRebuff.Enable = read.BoolFromString(var1[cfglines],"BulletRebuff.Enable",lines[cfglines]) cfglines = cfglines + 1
                BulletRebuff.SyncWeapon = read.BoolFromString(var1[cfglines],"BulletRebuff.SyncWeapon",lines[cfglines]) cfglines = cfglines + 1
                BulletRebuff.SameWeapon = read.BoolFromString(var1[cfglines],"BulletRebuff.SameWeapon",lines[cfglines]) cfglines = cfglines + 1
                BulletRebuff.Clist = read.BoolFromString(var1[cfglines],"BulletRebuff.Clist",lines[cfglines]) cfglines = cfglines + 1
                BulletRebuff.Force = read.BoolFromString(var1[cfglines],"BulletRebuff.Force",lines[cfglines]) cfglines = cfglines + 1
                Godmode.PlayerEnable = read.BoolFromString(var1[cfglines],"Godmode.PlayerEnable",lines[cfglines]) cfglines = cfglines + 1
                Godmode.PlayerCollision = read.BoolFromString(var1[cfglines],"Godmode.PlayerCollision",lines[cfglines]) cfglines = cfglines + 1
                Godmode.PlayerMelee = read.BoolFromString(var1[cfglines],"Godmode.PlayerMelee",lines[cfglines]) cfglines = cfglines + 1
                Godmode.PlayerBullet = read.BoolFromString(var1[cfglines],"Godmode.PlayerBullet",lines[cfglines]) cfglines = cfglines + 1
                Godmode.PlayerFire = read.BoolFromString(var1[cfglines],"Godmode.PlayerFire",lines[cfglines]) cfglines = cfglines + 1
                Godmode.PlayerExplosion = read.BoolFromString(var1[cfglines],"Godmode.PlayerExplosion",lines[cfglines]) cfglines = cfglines + 1
                Godmode.VehicleEnable = read.BoolFromString(var1[cfglines],"Godmode.VehicleEnable",lines[cfglines]) cfglines = cfglines + 1
                Godmode.VehicleCollision = read.BoolFromString(var1[cfglines],"Godmode.VehicleCollision",lines[cfglines]) cfglines = cfglines + 1
                Godmode.VehicleMelee = read.BoolFromString(var1[cfglines],"Godmode.VehicleMelee",lines[cfglines]) cfglines = cfglines + 1
                Godmode.VehicleBullet = read.BoolFromString(var1[cfglines],"Godmode.VehicleBullet",lines[cfglines]) cfglines = cfglines + 1
                Godmode.VehicleFire = read.BoolFromString(var1[cfglines],"Godmode.VehicleFire",lines[cfglines]) cfglines = cfglines + 1
                Godmode.VehicleExplosion = read.BoolFromString(var1[cfglines],"Godmode.VehicleExplosion",lines[cfglines]) cfglines = cfglines + 1
                SHAkMenu.ChatMessage = read.BoolFromString(var1[cfglines],"SHAkMenu.ChatMessage",lines[cfglines]) cfglines = cfglines + 1
                SHAkMenu.FpsBoost = read.BoolFromString(var1[cfglines],"SHAkMenu.FpsBoost",lines[cfglines]) cfglines = cfglines + 1
                SHAkMenu.RefreshHZ = read.BoolFromString(var1[cfglines],"SHAkMenu.RefreshHZ",lines[cfglines]) cfglines = cfglines + 1
                SHAkMenu.X = read.FloatFromString(var1[cfglines],"SHAkMenu.X",lines[cfglines]) cfglines = cfglines + 1
                SHAkMenu.Y = read.FloatFromString(var1[cfglines],"SHAkMenu.Y",lines[cfglines]) cfglines = cfglines + 1
        --OldCFG?
            if v.Cfgbrokenlines > 0 then
                PrintConsole("shackled.lua - Broken Config (".. SHAkMenu.ConfigDisk ..") ".. v.Cfgbrokenlines .." errors!")
            end
            get.FovfromConfig()
            get.SilentConfig(vMy.Weapon, vMy.Vehicle)
            set.HideTextDraw(2047)
            set.HideTextDraw(2046)
            set.HideTextDraw(2045)
            set.Memories()
            if SHAkMenu.RefreshHZ.v then
                Utils:writeMemory(0xC9C070, 0, 1, false)
            else
                Utils:writeMemory(0xC9C070, 60, 1, false)
            end
            if SHAkMenu.FpsBoost.v then
                Utils:writeMemory2(0x53E227, "\xC3", 1, false)
            else
                Utils:writeMemory2(0x53E227, "\xE9", 1, false)
            end
            if Movement.RunEverywhere.v then
                Utils:writeMemory(0x55E874, 4, 2, false)
            else
                Utils:writeMemory(0x55E874, 1165, 2, false)
            end
        end
    function SHAkMenu.SaveF()
            SHAkMenu.Config = 1
            
                wf = io.open(SHAkMenu.ConfigDisk, "w")
                local outputtext = Panic.SaveAsString()
                outputtext = outputtext .. Commands.SaveAsString()
                outputtext = outputtext .. Movement.SaveAsString()
                outputtext = outputtext .. RadarHack.SaveAsString()
                outputtext = outputtext .. StreamWall.SaveAsString()
                outputtext = outputtext .. Extra.SaveAsString()
                outputtext = outputtext .. Vehicle.SaveAsString()
                outputtext = outputtext .. Filters.SaveAsString()
                outputtext = outputtext .. Indicator.SaveAsString()
                outputtext = outputtext .. Teleport.SaveAsString()
                outputtext = outputtext .. Troll.SaveAsString()
                outputtext = outputtext .. Damager.SaveAsString()
                outputtext = outputtext .. DamageChanger.SaveAsString()
                outputtext = outputtext .. Silent.SaveAsString()
                outputtext = outputtext .. AimAssist.SaveAsString()
                outputtext = outputtext .. Doublejump.SaveAsString()
                outputtext = outputtext .. BulletRebuff.SaveAsString()
                outputtext = outputtext .. Godmode.SaveAsString()
                outputtext = outputtext .. SHAkMenu.SaveAsString()
                wf:write(string.format("%s",outputtext))
                wf:close()


            local color = 0x2FFFFFF
            local buf = ImBuffer("shackled.lua - {FFFFFF}Config ".. SHAkMenu.ConfigDisk .." Saved",50)
            send.Message(buf, color)
            Timer.Configs[0] = 0
            SHAkMenu.Saved = 1
            if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
            SHAkMenu.Loaded = 0
            get.Config()
            Timer.Visuals = 0
        end
    function SHAkMenu.LoadF()
            if SHAkMenu.Config == 1 then
                v.Cfgbrokenlines = 0
                local rf = io.open(SHAkMenu.ConfigDisk, "r")
                if rf ~= nil then
                    local Content = rf:read("*a")
                    rf:close()
                    read.LoadFromString(Content)
                    local buf = ImBuffer("shackled.lua - {FFFFFF}Config ".. SHAkMenu.ConfigDisk .." Loaded",50)
                    local color = 0x2FFFFFF
                    send.Message(buf, color)
                    SHAkMenu.Config = 3
                    SHAkMenu.ConfigChoosen = SHAkMenu.ConfigName.v
                    Timer.Visuals = 0
                end
            end
        end
    function get.File(file_name)
        local file_found = io.open(file_name, "r")   
        if file_found == nil then
            SHAkMenu.Config = 0
            SHAkMenu.DefaultConfig = 1
            SHAkMenu.IsLoading = 0
        else
            SHAkMenu.Config = 1
            if SHAkMenu.IsLoading == 1 or SHAkMenu.DefaultConfig == 0 and SHAkMenu.Folder > 0 then
                SHAkMenu.LoadF()
                SHAkMenu.DefaultConfig = 1
                SHAkMenu.IsLoading = 0
            end
            file_found:close()
        end
        return file_found
        end
    function get.Folder(folder_name)
        local ok, err, code = os.rename(folder_name, folder_name)
        if code == 13 or ok or code == 17 then
            if SHAkMenu.Folder == 0 or SHAkMenu.Folder == -2 or SHAkMenu.Folder == -3 or SHAkMenu.Folder == -4 then
                if SHAkMenu.Folder == 0 then
                    SHAkMenu.Folder = 1
                end
                if SHAkMenu.Folder == -2 or SHAkMenu.Folder == -3 then
                    SHAkMenu.Folder = 2
                end
            end
            SHAkMenu.ConfigDisk = folder_name..""..SHAkMenu.ConfigName.v
            SHAkMenu.FolderName = folder_name
            return get.File(SHAkMenu.ConfigDisk)
        else
            if SHAkMenu.Folder > 0 then
                SHAkMenu.Folder = -2
            else
                if SHAkMenu.Folder ~= -2 and SHAkMenu.Folder ~= -3 then
                    SHAkMenu.Folder = -3
                end
            end
        end
        return ok, err
        end
        get.Folder(Config_path)
    function get.Config()
            for i = 1, 5 do
                v.ConfigsDefault[i] = SHAkMenu.FolderName.."Config".. i ..".SHAk"
                local file_found = io.open(v.ConfigsDefault[i], "r")   
                if file_found ~= nil then
                    v.ConfigsDefault[i] = "Config".. i .."\n ",i
                    file_found:close()
                else
                    v.ConfigsDefault[i] = "Not Saved"
                end
            end
            get.Folder(Config_path)
        end
    function get.ScriptTimers()
            PickUP = Timers(Extra.PickUP.Delay.v)
            DMGTimer = Timers(Damager.Delay.v+5)
            RVankaTimer1 = Timers(Troll.RVanka.Timer.v+5)
        end
        get.ScriptTimers()
    --Math
        function maths.isInteger(num)
                return num % 1 == 0
            end
        function maths.quaternionToAngle(quaternion)
                local w = quaternion.w
                local angle = 2 * math.acos(w)
                return math.deg(angle) -- Convert angle to degrees
            end
        function maths.degreesToRadians(degrees)
                return degrees * (math.pi / 180)
            end
        function maths.increaseVelocityByAngle(velocity, angle, acceleration)
                local angleRadians = maths.degreesToRadians(angle)
                local cosAngle = math.cos(angleRadians)
                local sinAngle = math.sin(angleRadians)
            
                -- Calculate the new velocity components
                local newVelX = velocity.x * cosAngle - velocity.y * sinAngle
                local newVelY = velocity.x * sinAngle + velocity.y * cosAngle
            
                -- Increase the velocity in the direction of the angle
                newVelX = newVelX + acceleration * cosAngle
                newVelY = newVelY + acceleration * sinAngle
            
                -- Update the velocity
                velocity.x = newVelX
                velocity.y = newVelY
            
                return velocity
            end
        function maths.round(x)
                return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
            end
        function maths.randomFloat(lower, greater)
                return lower + math.random()  * (greater - lower);
            end
        
        function maths.randomInt(min, max)
                local randomInt = math.random(min, max) -- Generates a random integer within the specified range
                return randomInt
            end
        function maths.Vector3dotProduct(v1, v2)
                return v1.fX * v2.fX + v1.fY * v2.fY + v1.fZ * v2.fZ
            end
        function maths.Vector3subtract(v1, v2)
                local x = v1.fX - v2.fX
                local y = v1.fY - v2.fY
                local z = v1.fZ - v2.fZ
                return CVector(x, y, z)
            end
        function maths.Vector3GetMagnitude(v)
                return math.sqrt(v.fX * v.fX + v.fY * v.fY + v.fZ * v.fZ)
            end
        function maths.Vector3Length(x, y, z)
                return math.sqrt(x * x + y * y + z * z)
            end
        function maths.normalizeVector3(v1)
                local magnitude = math.sqrt(v1.fX * v1.fX + v1.fY * v1.fY + v1.fZ * v1.fZ)
                if magnitude > 0 then
                    return CVector(v1.fX / magnitude, v1.fY / magnitude, v1.fZ / magnitude)
                else
                    return CVector(0, 0, 0)
                end
            end
        function maths.Vector3Normalize(v)
                local r = 1.0 / maths.Vector3GetMagnitude(v)
                local x = v.fX * r
                local y = v.fY * r
                local z = v.fZ * r
                return CVector(x, y, z)
            end
        --function magnitude(vector)
        --        return math.sqrt(vector.fX * vector.fX + vector.fY * vector.fY + vector.fZ * vector.fZ)
        --    end
        function maths.Vector3MultiplyNumber(v, number)
                return CVector(v.fX * number, v.fY * number, v.fZ * number)
            end
        function maths.heading(v1)
                return math.deg(v1.fX, v1.fY)
              end

        local Quaternion = {}
            Quaternion.__index = Quaternion
        function maths.Chance(percent)
                assert(percent >= 0 and percent <= 100)
                return percent >= math.random(1, 100) 
            end
        function maths.getLowerIn(table)
                local low = math.huge
                local index
                for i, v in pairs(table) do
                    if v < low then
                        low = v
                        index = i
                    end
                end
                return index
            end
        function maths.getHigherIn( table)
                local high = -math.huge
                local index
                for i, v in pairs(table) do
                    if v > high then
                        high = v
                        index = i
                    end
                end
                return index
            end
        function maths.tablelength(table)
                local count = 0
                for _ in pairs(table) do count = count + 1 end
                return count
              end
    --Weapon
        function get.ChangeWeapon(weapon, sametype)
                local nearest = math.huge
                local IsWeaponTwoHanded = weaponInfo[weapon].twohanded
                local currentWeaponSlot = weaponInfo[weapon].slot
                local WeaponID = 0
                for _, arma in pairs(weaponInfo) do
                    if sametype == 0 and arma.twohanded and not IsWeaponTwoHanded or sametype == 0 and not arma.twohanded and IsWeaponTwoHanded or
                    sametype == 1 and not arma.twohanded and not IsWeaponTwoHanded or sametype == 1 and arma.twohanded and IsWeaponTwoHanded then
                        if arma.own and arma.id ~= weaponInfo[weapon].id then
                            local difference = math.abs(arma.slot - currentWeaponSlot)
                            if currentWeaponSlot == 6 then
                                WeaponID = 0
                                break 
                            elseif difference < nearest then
                                WeaponID = arma.id
                                nearest = difference
                            end
                        end
                    end
                end
                return WeaponID
            end
        function get.WeaponInSlot(slot)
                for _, weaponData in pairs(weaponInfo) do
                    if weaponData.own and weaponData.slot == slot then
                        return weaponData.id
                    end
                end
                return 0
            end
        function set.ArmedWeapon(weaponID)
                local bsData = BitStream()
                bsWrap:Write32(bsData, weaponID)
                EmulRPC(67, bsData)
                bsWrap:Reset(bsData)
            end
        function set.WeaponInSlot(slot, weapon)
                local pedAddress = Utils:readMemory(0xB6F5F0, 4, false)
                local CWeapon = pedAddress + 0x5A0
                local current_cweapon = CWeapon + (slot) * 0x1C
                
                Utils:writeMemory(current_cweapon + 0x0, weapon, 4, false)
            end
        function set.WeaponAmmo(weaponID, amount)
                local pedAddress = Utils:readMemory(0xB6F5F0, 4, false)
                local CWeapon = pedAddress + 0x5A0
            
                for weaponIndex = 1, 13 do
                    local current_cweapon = CWeapon + (weaponIndex -1) * 0x1C

                    local wID = Utils:readMemory(current_cweapon + 0x0, 4, false)
                    if wID == weaponID then
                        weaponInfo[weaponID].ammo = weaponInfo[weaponID].ammo - amount
                        amount = weaponInfo[weaponID].ammo
                        Utils:writeMemory(current_cweapon + 12, amount, 4, false)
                        return
                    end
                end
            end
        function set.WeaponAmmoClip(weaponID, amount)
                local pedAddress = Utils:readMemory(0xB6F5F0, 4, false)

                local CWeapon = pedAddress + 0x5A0
                for weaponIndex = 1, 13 do
                    local current_cweapon = CWeapon + (weaponIndex -1) * 0x1C
                    local clipammo = Utils:readMemory(current_cweapon + 8, 4, false)
                    local current_cweapon = CWeapon + (weaponIndex -1) * 0x1C

                    local wID = Utils:readMemory(current_cweapon + 0x0, 4, false)
                    if wID == weaponID then
                        weaponInfo[weaponID].clipammo = amount
                        amount = weaponInfo[weaponID].clipammo
                        Utils:writeMemory(current_cweapon + 8, amount, 4, false)
                        return
                    end
                end
            end
        function set.RemovePlayerWeapon(weaponID)
                local pedAddress = Utils:readMemory(0xB6F5F0, 4, false)
                local CWeapon = pedAddress + 0x5A0
            
                for weaponIndex = 1, 13 do
                    local current_cweapon = CWeapon + (weaponIndex -1) * 0x1C

                    local wID = Utils:readMemory(current_cweapon + 0x0, 4, false)
                    if wID == weaponID then
                        weaponInfo[weaponID].own = false
                        weaponInfo[weaponID].ammo = 0
                        Utils:writeMemory(current_cweapon + 12, 0, 4, false)
                        return Utils:writeMemory(current_cweapon + 0x0, 0, 4, false)
                    end
                end
            end
    --Object & Vehicles
        function get.PickupPool()
            if v.SampVer == 1 then -- r1
                local SAMP_INFO_OFFSET = v.SampAdr + 0x21A0F8 
                SAMP_INFO_OFFSET = Utils:readMemory(SAMP_INFO_OFFSET, 4, false)

                local SAMP_PPOOLS_OFFSET = SAMP_INFO_OFFSET + 0x3CD 
                SAMP_PPOOLS_OFFSET = Utils:readMemory(SAMP_PPOOLS_OFFSET, 4, false)

                local SAMP_PPOOL_PICKUP_OFFSET = SAMP_PPOOLS_OFFSET + 0x20 
                SAMP_PPOOL_PICKUP_OFFSET = Utils:readMemory(SAMP_PPOOL_PICKUP_OFFSET, 4, false)
                return SAMP_PPOOL_PICKUP_OFFSET
            elseif v.SampVer == 2 then -- r2
                local SAMP_INFO_OFFSET = v.SampAdr + 0x21A100 
                SAMP_INFO_OFFSET = Utils:readMemory(SAMP_INFO_OFFSET, 4, false)

                local SAMP_PPOOLS_OFFSET = SAMP_INFO_OFFSET + 0x3C5 
                SAMP_PPOOLS_OFFSET = Utils:readMemory(SAMP_PPOOLS_OFFSET, 4, false)

                local SAMP_PPOOL_PICKUP_OFFSET = SAMP_PPOOLS_OFFSET + 0x10  
                SAMP_PPOOL_PICKUP_OFFSET = Utils:readMemory(SAMP_PPOOL_PICKUP_OFFSET, 4, false)
                return SAMP_PPOOL_PICKUP_OFFSET
            elseif v.SampVer == 3 then -- r3
                local SAMP_INFO_OFFSET = v.SampAdr + 0x26E8DC  
                SAMP_INFO_OFFSET = Utils:readMemory(SAMP_INFO_OFFSET, 4, false)

                local SAMP_PPOOLS_OFFSET = SAMP_INFO_OFFSET + 0x3DE  
                SAMP_PPOOLS_OFFSET = Utils:readMemory(SAMP_PPOOLS_OFFSET, 4, false)

                local SAMP_PPOOL_PICKUP_OFFSET = SAMP_PPOOLS_OFFSET + 0x10  
                SAMP_PPOOL_PICKUP_OFFSET = Utils:readMemory(SAMP_PPOOL_PICKUP_OFFSET, 4, false)
                return SAMP_PPOOL_PICKUP_OFFSET
            elseif v.SampVer == 4 then -- r4
                local SAMP_INFO_OFFSET = v.SampAdr + 0x26EA0C  
                SAMP_INFO_OFFSET = Utils:readMemory(SAMP_INFO_OFFSET, 4, false)

                local SAMP_PPOOLS_OFFSET = SAMP_INFO_OFFSET + 0x3DE 
                SAMP_PPOOLS_OFFSET = Utils:readMemory(SAMP_PPOOLS_OFFSET, 4, false)

                local SAMP_PPOOL_PICKUP_OFFSET = SAMP_PPOOLS_OFFSET + 0x10 
                SAMP_PPOOL_PICKUP_OFFSET = Utils:readMemory(SAMP_PPOOL_PICKUP_OFFSET, 4, false)
                return SAMP_PPOOL_PICKUP_OFFSET
            elseif v.SampVer == 5 then -- r4-2
                local SAMP_INFO_OFFSET = v.SampAdr + 0x26EA0C 
                SAMP_INFO_OFFSET = Utils:readMemory(SAMP_INFO_OFFSET, 4, false)

                local SAMP_PPOOLS_OFFSET = SAMP_INFO_OFFSET + 0x3DE 
                SAMP_PPOOLS_OFFSET = Utils:readMemory(SAMP_PPOOLS_OFFSET, 4, false)

                local SAMP_PPOOL_PICKUP_OFFSET = SAMP_PPOOLS_OFFSET + 0x8 
                SAMP_PPOOL_PICKUP_OFFSET = Utils:readMemory(SAMP_PPOOL_PICKUP_OFFSET, 4, false)
                return SAMP_PPOOL_PICKUP_OFFSET
            elseif v.SampVer == 5 then -- 03dl
                local SAMP_INFO_OFFSET = v.SampAdr + 0x2ACA24  
                SAMP_INFO_OFFSET = Utils:readMemory(SAMP_INFO_OFFSET, 4, false)

                local SAMP_PPOOLS_OFFSET = SAMP_INFO_OFFSET + 0x3DE  
                SAMP_PPOOLS_OFFSET = Utils:readMemory(SAMP_PPOOLS_OFFSET, 4, false)

                local SAMP_PPOOL_PICKUP_OFFSET = SAMP_PPOOLS_OFFSET + 0x10  
                SAMP_PPOOL_PICKUP_OFFSET = Utils:readMemory(SAMP_PPOOL_PICKUP_OFFSET, 4, false)
                return SAMP_PPOOL_PICKUP_OFFSET
            end
        end
        function get.NearestVehiclesFromScreen()
                local vMyCar = vMy.Vehicle
                for i = 1, SAMP_MAX_VEHICLES do 
                    if Cars:isCarOnServer(i) then
                        vehicles.id[i] = i
                        if Cars:isCarStreamed(i) then
                            local Car = Cars:getCarPosition(i)
                            Utils:GameToScreen(Car, vEnScreen)
                            local   distance = Utils:Get3Ddist(Car , CVector(vMy.OFData.Pos.fX,vMy.OFData.Pos.fY,vMy.OFData.Pos.fZ))
                            local fov = Utils:Get2Ddist(middlescreen,vEnScreen)
                            vehicles.fov[i] = fov
                            if i == 1999 and Godmode.InvisibleCar == 1 then 
                                vehicles.dist[i] = nil
                            else
                                vehicles.dist[i] =  distance
                            end
                            if  distance < 5 then
                                vehicles.crasher[i] =   distance
                            else
                                if vehicles.crasher[i] ~= nil then vehicles.crasher[i] = nil end
                            end
                        else
                            if vehicles.fov[i] ~= nil then vehicles.fov[i] = nil end
                            if vehicles.dist[i] ~= nil then vehicles.dist[i] = nil end
                            if vehicles.crasher[i] ~= nil then vehicles.crasher[i] = nil end
                        end
                    else
                        if vehicles.crasher[i] ~= nil then vehicles.crasher[i] = nil end
                        if vehicles.dist[i] ~= nil then vehicles.dist[i] = nil end
                        if vehicles.id[i] ~= -1 then vehicles.id[i] = -1 end
                        if vehicles.fov[i] ~= nil then vehicles.fov[i] = nil end
                    end
                end
                if Vehicle.Unlock.v then
                    local nearestvehicle = maths.getLowerIn(vehicles.dist)
                    if nearestvehicle ~= nil then
                        
                        local isFunctionDefined = type(set.VehicleParams) == "function"
                        if not isFunctionDefined then
                            return 0
                        end
                        set.VehicleParams(nearestvehicle, 0 ,0)
                    end
                end
            end
        function get.NearestObjectsFromScreen()
                local ObjScreen = CVector()
                for i = 0, SAMP_MAX_OBJECTS do 
                    if Objects:isObjectOnServer(i) and SHAcKvar.SaveObjectPos[i] == nil then
                        local ObjectLoc = Objects:getObjectPosition(i)
                        Utils:GameToScreen(ObjectLoc, ObjScreen)
                        if ObjScreen.fZ > 1 then
                            local fov = Utils:Get2Ddist(middlescreen,ObjScreen)
                            local   distance = Utils:Get2Ddist(vMy .Pos, ObjectLoc)
                            if  distance < 1000 then
                                objects.fov[i] = fov
                            else
                                if objects.fov[i] ~= nil then objects.fov[i] = nil end
                            end
                        else
                            if objects.fov[i] ~= nil then objects.fov[i] = nil end
                        end
                    else
                        if objects.fov[i] ~= nil then objects.fov[i] = nil end
                    end
                end
            end
        function get.PlayerWeapons()
                local pedAddress = Utils:readMemory(0xB6F5F0, 4, false)
                --local WeaponSkill = GetWeaponInfo(0xB6F5F0, 24)

                local CWeapon = pedAddress + 0x5A0
            
                for weaponIndex = 1, 13 do
                    local current_cweapon = CWeapon + (weaponIndex -1) * 0x1C
                    local weaponID = Utils:readMemory(current_cweapon + 0x0, 4, false)
                    local clipammo = Utils:readMemory(current_cweapon + 8, 4, false)
                    local Ammo = Utils:readMemory(current_cweapon + 12, 4, false)

                    for _, weaponData in pairs(weaponInfo) do
                        if weaponData.slot == weaponIndex-1 then
                            weaponData.clipammo = clipammo
                            weaponData.ammo = Ammo
                            if weaponData.id == weaponID and weaponID > 20 and Ammo ~= 0 
                            or weaponID < 20 and weaponData.id == weaponID then
                                if not weaponData.own then
                                    weaponData.own = true
                                end
                            else
                                if weaponData.own then
                                    weaponData.own = false
                                end
                            end
                        end
                    end
                end
            end
        function get.PlayersFromCameraToTarget(playerPosition, targetPosition, cameraPosition)
                local cameraToPlayer = maths.Vector3subtract(playerPosition, cameraPosition)
                local cameraToTarget = maths.Vector3subtract(targetPosition, cameraPosition)
            
                cameraToPlayer = maths.normalizeVector3(cameraToPlayer)
                cameraToTarget = maths.normalizeVector3(cameraToTarget)
            
                --Check if the nearest player is in front of the camera by calculating the dot product of the camera-to-player direction and the camera-to-target direction. 
                --If the dot product is positive, the nearest player is in front of the camera
                local dotProduct = maths.Vector3dotProduct(cameraToPlayer, cameraToTarget);

                --if(dotProduct < 0.90) then
                --    return true
                --else
                --    return false
                --end
                return dotProduct
            end
        function get.isPlayerAlive(playerID)
                local vEnData
                if playerID ~= nil then
                    if Players:isPlayerStreamed(playerID) or playerID == vMy.ID then
                        local vEnDriver = Players:isDriver(playerID)
                        local vEnPassenger = false
                        if not vEnDriver then
                            vEnPassenger = Players:Driving(playerID)
                        end
                        if vEnDriver or vEnPassenger then
                            vEnData = Players:getInCarData(playerID)
                        else
                            vEnData = Players:getOnFootData(playerID)
                        end
                        local speedf = math.sqrt(((vEnData.Speed.fX*vEnData.Speed.fX)+(vEnData.Speed.fY*vEnData.Speed.fY))+(vEnData.Speed.fZ*vEnData.Speed.fZ)) * 187.666667;
                        local speed = maths.round(speedf);
                        local vEnHP = Players:getPlayerHP(playerID)
                        if vEnHP > 0 or vEnHP == 0 and speed ~= 0 then
                            return true
                        else
                            return false
                        end
                    end
                end
                return false
            end
        function get.SilentBones(playerID)
                local bones = {}
                local vMyPos = Players:getBonePosition(vMy.ID,7)
                if SilentStuff.BoneHead == true then bones[8] = Players:getBonePosition(playerID,8) end
                if SilentStuff.BoneChest == true then bones[3] = Players:getBonePosition(playerID,3) end
                if SilentStuff.BoneStomach == true then bones[2] = Players:getBonePosition(playerID,2) end
                if SilentStuff.BoneLeftA == true then bones[33] = Players:getBonePosition(playerID,33) end
                if SilentStuff.BoneRightA == true then bones[23] = Players:getBonePosition(playerID,23) end
                if SilentStuff.BoneLeftL == true then bones[42] = Players:getBonePosition(playerID,42) end
                if SilentStuff.BoneRightL == true then bones[52] = Players:getBonePosition(playerID,52) end
                vEnScreen = CVector()
                local bonesDist = {}
                for j = 0, 52 do
                    if bones[j] ~= nil then
                        Utils:GameToScreen(bones[j], vEnScreen)
                        bonesDist[j] = Utils:Get3Ddist(SilentCrosshair,vEnScreen)
                    end
                end
                return bonesDist
            end
        function get.CheatBoneFromGame(gameBone)
                local cheatBone
                if gameBone == 9 then cheatBone = 8
                elseif gameBone == 3 then cheatBone = 3
                elseif gameBone == 4 then cheatBone = 2
                elseif gameBone == 5 then cheatBone = 33
                elseif gameBone == 6 then cheatBone = 23
                elseif gameBone == 7 then cheatBone = 42
                elseif gameBone == 8 then cheatBone = 52
                end
                return cheatBone
            end
        function get.GameBoneFromCheat(cheatBone)
                if cheatBone == 8 then gameBone = 9
                elseif cheatBone == 3 then gameBone = 3
                elseif cheatBone == 2 then gameBone = 4
                elseif cheatBone == 33 then gameBone = 5
                elseif cheatBone == 23 then gameBone = 6
                elseif cheatBone == 42 then gameBone = 7
                elseif cheatBone == 52 then gameBone = 8
                end
                return gameBone
            end
        function get.NearestPlayersFromScreen()
                for i = 0, 1003 do
                    if Players:isPlayerOnServer(i) then
                        players.id[i] = true
                        if Players:isPlayerStreamed(i) then
                            if Utils:isOnScreen(i) then
                                local vEnPos = Players:getPlayerPosition(i)
                                Utils:GameToScreen(vEnPos, vEnScreen)
                                local fov = Utils:Get2Ddist(middlescreen,vEnScreen)
                                players.fov[i] = fov
                            else
                                if players.fov[i] ~= nil then players.fov[i] = nil end
                            end
                        else
                            if players.fov[i] ~= nil then players.fov[i] = nil end
                        end
                    else
                        players.id[i] = nil
                    end
                end
            end
        function get.NearestBoneFrom(V1)
                vMyScreen = CVector()
                local vMyPos = Players:getBonePosition(vMy.ID,7)
                
                if SilentStuff.BoneHead == true or SilentStuff.BoneChest == true or SilentStuff.BoneStomach == true or SilentStuff.BoneLeftA == true or 
                SilentStuff.BoneRightA == true or SilentStuff.BoneLeftL == true or SilentStuff.BoneRightL == true then
                    for i, _ in pairs(players.id) do
                        if Players:isPlayerStreamed(i) and i ~= vMy.ID then
                            if Utils:isOnScreen(i) then
                                local getbones = get.SilentBones(i)
                                local nearestBone = maths.getLowerIn(getbones)
                                local vEnHead = Players:getBonePosition(i,nearestBone)
                                Utils:GameToScreen(vEnHead, vMyScreen)

                                local vEnDriver = Players:isDriver(i)
                                local vEnPassenger = false
                                if not vEnDriver then
                                    vEnPassenger = Players:Driving(i)
                                end

                                if Silent.InVehicle.v and not vEnDriver or Silent.InVehicle.v == false then 
                                    if Silent.InVehicle.v and not vEnPassenger or Silent.InVehicle.v == false then
                                       -- if Utils:IsLineOfSightClear(V1, vMyScreen, SilentStuff.VisibleCheck, SilentStuff.VisibleVehicles, false, SilentStuff.VisibleObjects, false, false, false) or SilentStuff.VisibleCheck == false then
                                            local distance = Utils:Get2Ddist(V1 , vEnHead)
                                            players.dist[i] = distance
                                            players.bone[i] = nearestBone
                                       -- else
                                       --     if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                       --     if players.dist[i] ~= nil then players.dist[i] = nil end
                                       --     if players.bone[i] ~= nil then players.bone[i] = nil end
                                       -- end
                                    else
                                        if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                        if players.dist[i] ~= nil then players.dist[i] = nil end
                                        if players.bone[i] ~= nil then players.bone[i] = nil end
                                    end
                                else
                                    if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                    if players.dist[i] ~= nil then players.dist[i] = nil end
                                    if players.bone[i] ~= nil then players.bone[i] = nil end
                                end
                            else
                                if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                if players.dist[i] ~= nil then players.dist[i] = nil end
                                if players.bone[i] ~= nil then players.bone[i] = nil end
                            end
                        else
                            if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                            if players.dist[i] ~= nil then players.dist[i] = nil end
                            if players.bone[i] ~= nil then players.bone[i] = nil end
                        end
                    end
                    nearestPlayerFromCrosshair = maths.getLowerIn(players.dist)
                else
                    if v.SilentPlayerID ~= -1 then v.SilentPlayerID = -1 end
                end
            end
            local tableto = {}
        function get.TargetSilent()
                if KeyToggle.Silent.v == 1 then
                    local bsData = BitStream()
                    local vEnHead = -1  
                    local vMyPos = Players:getBonePosition(vMy.ID,7)
                    local vMyCam = Utils:getCameraPosition()
                    local fov = 0
                    for i, _ in pairs(players.id) do
                        if Players:isPlayerOnServer(i) == false then
                            players.SilentTarget[i] = nil
                        end
                        if Players:isPlayerStreamed(i) then
                            if Utils:isOnScreen(i) then
                                if players.bone[i] ~= nil then
                                    vEnHead = Players:getBonePosition(i, players.bone[i])
                                    Utils:GameToScreen(vEnHead, vEnScreen)
                                    fov = Utils:Get2Ddist(SilentCrosshair,vEnScreen)
                                    if SilentStuff.FirstShots == 0 and fov < SilentStuff.Fov or SilentStuff.FirstShots == 1 and fov < SilentStuff.Fov2 then
                                        local Distance = Utils:Get3Ddist(vEnHead , vMyPos)
                                        local PlayerDist
                                        if SilentStuff.Distance == true then
                                            PlayerDist  = SilentStuff.ChangedDist
                                        else
                                            PlayerDist = weaponInfo[vMy.Weapon].distance
                                        end
                                        if Distance < PlayerDist then
                                            local vEnPos = Players:getPlayerPosition(i)
                                            local vMyColor = vMy.Color
                                            local vEnColor = Players:getPlayerColor(i)
                                            if Silent.Clist.v and vMyColor ~= vEnColor or Silent.Clist.v == false then  
                                                if Silent.Force.v == false and Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(i) == false 
                                                or Silent.Force.v and Players:isPlayerInFilter(i) 
                                                or Damager.Force.v and Players:isSkinInFilter(i) then
                                                    if Silent.AFK.v and Players:isPlayerAFK(i) == false or Silent.AFK.v == false then
                                                        local vEnData = Players:getOnFootData(i)
                                                        if Silent.Death.v and get.isPlayerAlive(i) == true or Silent.Death.v == false then
                                                            local viewcars = false
                                                            if Silent.Pistols.VisibleCheck.Vehicles.v == true then
                                                                viewcars = true
                                                            end

                                                            local vEnDriver = Players:isDriver(i)
                                                            local vEnPassenger = false
                                                            if not vEnDriver then
                                                                vEnPassenger = Players:Driving(i)
                                                            end

                                                            if Silent.InVehicle.v and not vEnDriver then 
                                                                viewcars = true
                                                            elseif Silent.InVehicle.v and not vEnPassenger then
                                                                viewcars = true
                                                            end
                                                            if Utils:IsLineOfSightClear(vMyPos, vEnHead, SilentStuff.VisibleCheck, viewcars, false, SilentStuff.VisibleObjects, false, false, false) or SilentStuff.VisibleCheck == false then
                                                                players.SilentTarget[i] = fov
                                                                local nearest = maths.getLowerIn(players.SilentTarget)
                                                                if nearest == nil then
                                                                    v.SilentPlayerID = -1
                                                                else
                                                                    v.SilentPlayerID = nearest 
                                                                end 
                                                            else
                                                                if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                                                if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                                            end
                                                        else
                                                            if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                                            if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                                        end
                                                    else
                                                        if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                                        if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                                    end
                                                else
                                                    if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                                    if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                                end
                                            else
                                                if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                                if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                            end
                                        else
                                            if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                        end
                                    else
                                        if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                        if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                    end
                                else 
                                    if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                    if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                                end
                            else 
                                if v.SilentPlayerID == i then v.SilentPlayerID = -1 end
                                if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                            end
                        else
                            if v.SilentPlayerID == i then  v.SilentPlayerID = -1 end
                            if players.SilentTarget[i] ~= nil then players.SilentTarget[i] = nil end
                        end
                    end
                end
            end
        function get.PlayerLag(playerID)
                --Utils:writeMemory(0x6194A0, 1, 1, true)
                local expectedPosition = CVector(0, 0, 0)
                --if v.WaitForPickLag == 0 then
                    local data = 0
                    if Players:Driving(playerID) then
                        data = Players:getInCarData(playerID)
                    else
                        data = Players:getOnFootData(playerID)
                    end
                    local velocity = CVector(data.Speed.fX, data.Speed.fY, data.Speed.fZ)
                    local vEnPos 
                    if playerID ~= vMy.ID then
                        vEnPos = Players:getPlayerPosition(playerID)
                    else
                        vEnPos = vMy.Pos
                    end
                    local velocityMagnitude = math.sqrt(velocity.fX * velocity.fX + velocity.fY * velocity.fY + velocity.fZ * velocity.fZ)
                    if(velocityMagnitude > 0) then
                        if Timer.GetLag[playerID] == nil or Timer.GetLag[playerID] == NULL then
                            Timer.GetLag[playerID] = 0
                        end
                        Timer.GetLag[playerID] = Timer.GetLag[playerID] + 1
                        if Timer.GetLag[playerID] > 25 and playerID ~= vMy.ID then
                            local bsData = BitStream()
                            SendRPC(155, bsData)
                            Timer.GetLag[playerID] = 0
                        end
                        ping = Players:getPlayerPing(playerID)
                        local speed = (velocityMagnitude * 0.1) * 0.5 * 1000
                        local t = 1.0;
                    
                        if(ping > -1 and ping < 1000) then
                            t = (1.0 / 1000) * ping
                        end
                        
                        local direction = maths.Vector3Normalize(velocity)
                        local directionTimesSpeed = maths.Vector3MultiplyNumber(direction, t * speed)
                        expectedPosition = vEnPos + (direction * t * speed)
                    else
                        expectedPosition = vEnPos
                    end
                    --Utils:writeMemory(0x6194a0, 1, 0, true)
                    return expectedPosition
                --end
            end
        function get.LagCompensatedPosition(MyPosition, playerId, velocityModifier)
                local vMyPos = MyPosition
                local position = Players:getPlayerPosition(playerId)
                local zground = Utils:FindGroundZForCoord(position.fX,position.fY)
                position = CVector(position.fX, position.fY, position.fZ - maths.randomFloat(1.45, 1.55))
                local dist = Utils:Get3Ddist(vMyPos, position) * 0.5
                local vData 
                if Players:isDriver(playerId) or Players:Driving(playerId) then
                    vData = Players:getInCarData(playerId)
                else
                    vData = Players:getOnFootData(playerId)
                end

                local velocity = CVector(vData.Speed.fX * dist, vData.Speed.fY * dist, vData.Speed.fZ * dist)
                if (zground + velocity.fZ) < zground then
                    velocity.fZ = 0
                end
                velocity = velocity * velocityModifier
                local expectedPosition = position

                local magnitude = maths.Vector3GetMagnitude(velocity)
                if Timer.GetLag[playerId] == nil or Timer.GetLag[playerId] == NULL then
                    Timer.GetLag[playerId] = 0
                end

                Timer.GetLag[playerId] = Timer.GetLag[playerId] + 1
                if Timer.GetLag[playerId] > 25 then
                    local bsData = BitStream()
                    SendRPC(155, bsData)
                    Timer.GetLag[playerId] = 0
                end
                
                if(magnitude > 0) then
                    local speed = (magnitude * 0.1) * 1000
                    local ping = Players:getPlayerPing(playerId)
                    local t = 1.0

                    if(ping < 1000) then
                        t = (1.0 / 1000) * ping        
                    end

                    local direction = maths.Vector3Normalize(velocity)

                    expectedPosition.fX = position.fX + (direction.fX * t * speed * 0.5)
                    expectedPosition.fY = position.fY + (direction.fY * t * speed * 0.5)
                    expectedPosition.fZ = position.fZ + (direction.fZ * t * speed * 0.5)
                end

                return expectedPosition
            end

        function get.PlayerToRadar(playerID, vMyPos)
                if Players:isPlayerStreamed(playerID) then
                    local vEnPos = Players:getPlayerPosition(playerID)
                    local maxLength = RadarHack.maxDistance.v
                    local Distance3d = Utils:Get3Ddist(vMyPos, vEnPos)
                    local direction = vEnPos - vMyPos
                    local magnitude = maths.Vector3GetMagnitude(direction)
                    local direction = direction * (1.0 / magnitude)
                    if(Distance3d > maxLength) then
                        normalizedDistance = 1.35
                    else 
                        normalizedDistance = Distance3d / maxLength  / 1.35
                    end
                    local Distance3d = normalizedDistance * RadarHack.maxLength.v
                    RadarHack.PlayerPos[playerID] = CVector(vMyPos.fX + direction.fX * Distance3d, vMyPos.fY + direction.fY * Distance3d, vMyPos.fZ + direction.fZ * Distance3d)
                else
                    RadarHack.PlayerPos[playerID] = nil
                end
            end
        function get.nearwall(vMyPos, distance)
                vMyPos.fZ = vMyPos.fZ + 0.5
                local WallPos1 = CVector(vMyPos.fX +distance, vMyPos.fY, vMyPos.fZ)
                local WallPos2 = CVector(vMyPos.fX -distance, vMyPos.fY, vMyPos.fZ)
                local WallPos3 = CVector(vMyPos.fX, vMyPos.fY + distance, vMyPos.fZ)
                local WallPos4 = CVector(vMyPos.fX, vMyPos.fY - distance, vMyPos.fZ)
                local WallPos5 = CVector(vMyPos.fX +distance, vMyPos.fY +distance, vMyPos.fZ)
                local WallPos6 = CVector(vMyPos.fX -distance, vMyPos.fY -distance, vMyPos.fZ)
                local WallPos7 = CVector(vMyPos.fX +distance, vMyPos.fY -distance, vMyPos.fZ)
                local WallPos8 = CVector(vMyPos.fX -distance, vMyPos.fY +distance, vMyPos.fZ)
                if Utils:IsLineOfSightClear(vMyPos, WallPos1, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos1 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos2, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos2 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos3, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos3 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos4, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos4 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos5, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos5 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos6, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos6 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos7, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos7 return true
                elseif Utils:IsLineOfSightClear(vMyPos, WallPos8, true, true ,false, true, false, false, false) == false then SHAcKvar.DrawWall = WallPos8 return true
                else
                    SHAcKvar.DrawWall = 0
                    return false
                end
            end
        function get.Direction(pointA, pointB)
                local direction = pointA - pointB
                return maths.Vector3Normalize(direction)
            end
        function get.AimZ(myPos, PlayerPos)
                local d = CVector(
                    Utils:Get3Ddist(CVector(PlayerPos.fX, PlayerPos.fY, myPos.fZ) , CVector(myPos.fX, myPos.fY, PlayerPos.fZ)), 
                    Utils:Get3Ddist(CVector(myPos.fX, myPos.fY, PlayerPos.fZ) , CVector(myPos.fX, myPos.fY, myPos.fZ)), 
                    0)

                local aimZ = math.atan(math.abs(d.fY/d.fX))
                aimZ = PlayerPos.fZ > myPos.fZ and -aimZ or aimZ
                return aimZ
            end
        function get.onFootData()
                local data = Players:getOnFootData(Players:getLocalID())
                    OnFootData = {
                        lrkey = data.sLeftRightKeys,
                        udkey = data.sUpDownKeys,
                        keys = data.sKeys,
                        X = data.Pos.fX,
                        Y = data.Pos.fY,
                        Z = data.Pos.fZ,
                        quat_w = players.Quats.w,
                        quat_x = players.Quats.x,
                        quat_y = players.Quats.y,
                        quat_z = players.Quats.z,
                        health = Players:getPlayerHP(Players:getLocalID()),
                        armour = Players:getPlayerArmour(Players:getLocalID()),
                        weapon_id = vMy.Weapon,
                        special_action = data.SpecialAction,
                        velocity_x = data.Speed.fX,
                        velocity_y = data.Speed.fY,
                        velocity_z = data.Speed.fZ,
                        surfing_offsets_x = data.SurfingOffsets.fX,
                        surfing_offsets_y = data.SurfingOffsets.fY,
                        surfing_offsets_z = data.SurfingOffsets.fZ,
                        surfing_vehicle_id = data.sSurfingVehicleID,
                        animation_id = data.sCurrentAnimationID,
                        animation_flags = data.sAnimFlags
                    }
                return OnFootData
            end
        function get.BulletData()
                    BulletData = {
                        type = 0,
                        hitid = 65535,
                        originX = 0,
                        originY = 0,
                        originZ = 0,
                        posX = 0,
                        posY = 0,
                        posZ = 0,
                        offsetX = 0,
                        offsetY = 0,
                        offsetZ = 0,
                        weapon = 0
                    }
                return BulletData
            end
        function get.AimData()
                local data = Players:getAimData(Players:getLocalID())
                    AimData = {
                        cammode = data.CamMode,
                        camfrontX = data.vecAimf1.fX,
                        camfrontY = data.vecAimf1.fY,
                        camfrontZ = data.vecAimf1.fZ,
                        camposX = data.vecAimPos.fX,
                        camposY = data.vecAimPos.fY,
                        camposZ = data.vecAimPos.fZ,
                        aimZ = data.fAimZ,
                        weaponstate = 0,
                        camzoom = 85,
                        aspectratio = 0
                    }
                return AimData
            end
    --Emulate RPC
        function set.EscState()
                Utils:writeMemory(0x747FB6, 0x1, 1, false)
                Utils:writeMemory(0x74805A, 0x1, 1, false)

                Utils:writeMemory(0x53EA88, 0x90, 6, false) -- Disable Mouse Centering
                Utils:writeMemory(0x74542B, 0x90, 8, false) -- Disable ESC when game is minimized
            end
            if Extra.AntiAFK.v then
                set.EscState()
            end
        function set.CJWalk()
                if m_offsets.m_samp_info[v.SampVer] ~= 0 and Movement.bUseCJWalk.v then
                    local sampInfo = Utils:readMemory(v.SampAdr + m_offsets.m_samp_info[v.SampVer], 4, false)
                    local settings = Utils:readMemory(sampInfo + m_offsets.m_settings[v.SampVer], 4, false)
                    local bUseCJWalk2 = Utils:readMemory(settings + 0x0, 1, false)
                    if bUseCJWalk2 == 0 then
                        SHAcKvar.CJWalk = 2
                    end
                    Utils:writeMemory(settings + 0x0, 1, 1, false)
                end
            end
        function set.RadarHacks()
                if m_offsets.m_samp_info[v.SampVer] ~= 0 then
                    local sampInfo = Utils:readMemory(v.SampAdr + m_offsets.m_samp_info[v.SampVer], 4, false)
                    local settings = Utils:readMemory(sampInfo + m_offsets.m_settings[v.SampVer], 4, false)
                    local playerMarkersMode = Utils:readMemory(settings + 0x30, 4, false)

                    local bool = 0
                    local Buf = ImBuffer("OFF",3)
                    if RadarHack.PlayerMarkers.v then
                        bool = 1
                        Buf = ImBuffer("ON",2)
                    end
                    Utils:writeMemory(settings + 0x30, bool, 4, false)
                end
            end
            if RadarHack.PlayerMarkers.v then
                set.RadarHacks()
            end
        function set.VehicleParams(vehicleID, objective, doorslocked)
                local bsData = BitStream()
                bsWrap:Write16(bsData, vehicleID) 
                bsWrap:Write8(bsData, objective) 
                bsWrap:Write8(bsData, doorslocked) 
                EmulRPC(161,bsData)
                bsWrap:Reset(bsData)
            end
        function set.PlayerFacing(myPos, vEnPos)
                local dx = vEnPos.fX - myPos.fX
                local dy = vEnPos.fY - myPos.fY
                local dz = 0
                local yaw = math.atan2(dx, dz)

                if dx < 0 then
                    dx = myPos.fX - vEnPos.fX
                    dy = myPos.fY - vEnPos.fY
                    dz = 0
                    yaw = math.atan2(-dx, -dz)
                end
                local pitch = math.atan2(dy, math.sqrt(dx * dx + dz * dz))

                local   distance = math.sqrt(dx  * dx + dy * dy + dz * dz)
                pitch = math.asin(dy /  distance)

                local cy = math.cos(yaw * 0.5)
                local sy = math.sin(yaw * 0.5)
                local cp = math.cos(pitch * 0.5)
                local sp = math.sin(pitch * 0.5)

                local qw = cy * cp + sy * sp
                local qx = nil
                local qy = nil
                local qz = sy * cp - cy * sp

                local lengthQ = math.sqrt(qw * qw + qz * qz)
                qw = qw / lengthQ
                qz = qz / lengthQ
                return qw, nil, nil, qz
            end
        function set.PlayerZAngle(degrees)
        
                local radians = degrees * 0.01745329251994444386
            
                local pPlayer = Utils:readMemory(0xB6F5F0, 4, false)
                
                if(pPlayer > 0) then
                    --Utils:writeMemory(pPlayer + 0x558, radians, 4, true)
                    --Utils:writeMemory(pPlayer + 0x560, 5, 4, true)
                    --Utils:writeMemory(pPlayer + 0x55C, radians, 4, true)
                end
            
                return 0
            end
        function set.PlayerWeaponSkill()
                if Extra.SetWeaponSkill.v then
                    local bsData = BitStream()
                    for i = 0, 10 do
                        bsWrap:Reset(bsData)
                        bsWrap:Write16(bsData, vMy.ID)
                        bsWrap:Write32(bsData, i)
                        bsWrap:Write16(bsData, Extra.SetWeaponSkillLevel.v)
                        EmulRPC(34, bsData)
                    end
                end
            end
        function set.PlayerCameraLookAt(x, y, z, cut)
                local bsData = BitStream()
                bsWrap:WriteFloat(bsData, x) 
                bsWrap:WriteFloat(bsData, y) 
                bsWrap:WriteFloat(bsData, z) 
                bsWrap:Write8(bsData, cut)
                EmulRPC(158, bsData)
                bsWrap:Reset(bsData)
            end
        function set.PlayerCameraPos(x, y, z)
                local bsData = BitStream()
                bsWrap:WriteFloat(bsData, x) 
                bsWrap:WriteFloat(bsData, y) 
                bsWrap:WriteFloat(bsData, z) 
                EmulRPC(157, bsData)
                bsWrap:Reset(bsData)
            end
        function set.FightStyle()
                local fightstyle = 0
                if Movement.Fight.v then
                    if Movement.FightStyle.v == 0 then fightstyle = 4 end
                    if Movement.FightStyle.v == 1 then fightstyle = 5 end
                    if Movement.FightStyle.v == 2 then fightstyle = 6 end
                    if Movement.FightStyle.v == 3 then fightstyle = 7 end
                    if Movement.FightStyle.v == 4 then fightstyle = 15 end
                    if Movement.FightStyle.v == 5 then fightstyle = 16 end
                    local bsData = BitStream()
                    bsWrap:Write16(bsData, vMy.ID) 
                    bsWrap:Write8(bsData, fightstyle) 
                    EmulRPC(89,bsData)
                end
            end
        function set.PlayerGravity()
                if Extra.ForceGravity.v then
                    local bsData = BitStream()
                    bsWrap:WriteFloat(bsData, Extra.GravityFloat.v) 
                    EmulRPC(146,bsData)
                else
                    if Extra.GravityFloat.v ~= 0.008 then
                        local bsData = BitStream()
                        bsWrap:WriteFloat(bsData, 0.008) 
                        EmulRPC(146,bsData)
                    end
                end
            end
        function set.EngineState(wVehicleID)
                local bsData = BitStream()
                bsWrap:Write16(bsData, wVehicleID)
                bsWrap:Write8(bsData, 1)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                EmulRPC(24,bsData)
                bsWrap:Reset(bsData)
            end
        function set.VehicleZAngle(Angle)
                local data = vMy.ICData
                local bsData = BitStream()
                bsWrap:Write16(bsData, data.VehicleID)
                bsWrap:WriteFloat(bsData, Angle)
                EmulRPC(160,bsData)
                bsWrap:Reset(bsData)
            end
        function set.VehiclePos(veh, X, Y, Z)
                local data = vMy.ICData
                local bsData = BitStream()
                bsWrap:Write16(bsData, veh)
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                EmulRPC(159,bsData)
                bsWrap:Reset(bsData)
            end
        function set.ClearPlayerAnimations()
                local bsData = BitStream()
                bsWrap:Write16(bsData, vMy.ID)
                EmulRPC(87,bsData)
                bsWrap:Reset(bsData)
            end
        function set.PlayerSkin(SkinID)
                local bsData = BitStream()
                bsWrap:Write32(bsData, vMy.ID)
                bsWrap:Write32(bsData, SkinID) 
                EmulRPC(153,bsData)
            end
        function set.PlayerPos(X, Y, Z)
                local bsData = BitStream()
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                EmulRPC(12,bsData)
                bsWrap:Reset(bsData)
            end
        function set.PlayerPosFindZ(X, Y, Z)
                local bsData = BitStream()
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                EmulRPC(13,bsData)
                bsWrap:Reset(bsData)
            end
        function set.PlayerVelocity(X, Y, Z)
                local bsData = BitStream()
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                EmulRPC(90,bsData)
                bsWrap:Reset(bsData)
            end
        function set.VehicleVelocity(X, Y, Z)
                local bsData = BitStream()
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                EmulRPC(91,bsData)
                bsWrap:Reset(bsData)
            end
        function set.PlayerMapIcon(X, Y, Z, IconType)
                local bsData = BitStream()
                bsWrap:Write8(bsData, 99) 
                bsWrap:WriteFloat(bsData, X) 
                bsWrap:WriteFloat(bsData, Y) 
                bsWrap:WriteFloat(bsData, Z) 
                bsWrap:Write8(bsData, IconType)
                bsWrap:Write32(bsData, 0) 
                bsWrap:Write8(bsData, 3) 
                EmulRPC(56, bsData)   
                bsWrap:Reset(bsData)        
            end
        function set.PlayerMapIconRadar(X, Y, Z, IconId, IconType, PlayerID)
                local bsData = BitStream()
                bsWrap:Write8(bsData, IconId) 
                bsWrap:WriteFloat(bsData, X) 
                bsWrap:WriteFloat(bsData, Y) 
                bsWrap:WriteFloat(bsData, Z) 
                bsWrap:Write8(bsData, IconType)
                bsWrap:Write32(bsData, 0) 
                bsWrap:Write8(bsData, 1) 
                EmulRPC(56, bsData)   
                bsWrap:Reset(bsData)   
            end
        function set.DesyncPlayer(PlayerID, X, Y, Z)
                local SkinID = Players:getPlayerSkin(PlayerID)
                local color = Players:getPlayerColor(PlayerID)
                local fightstyle = 0
                local team = 0
                if players.fightstyle[PlayerID] ~= nil then
                    fightstyle = players.fightstyle[PlayerID]
                    team = players.team[PlayerID]
                else
                    fightstyle = 0
                    team = 0
                end

                local shiftedColor = bit.bor(bit.lshift(bit.band(color, 0x00ffffff), 8), bit.rshift(color, 24))

                local bsData = BitStream()
                bsWrap:Write16(bsData, PlayerID)
                EmulRPC(163, bsData)
                bsWrap:Reset(bsData)
                bsWrap:Write16(bsData, PlayerID)
                bsWrap:Write8(bsData, team)
                bsWrap:Write32(bsData, SkinID)
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                bsWrap:WriteFloat(bsData, 0)
                bsWrap:Write32(bsData, shiftedColor)
                bsWrap:Write8(bsData, fightstyle)
                EmulRPC(32, bsData)
                bsWrap:Reset(bsData)
            end
        function set.VehicleParts(vehicle, panels, doors, lights, tires)
                local bsData = BitStream()
                bsWrap:Write16(bsData, vehicle) --wVehicleID
                bsWrap:Write32(bsData, panels) --panels
                bsWrap:Write32(bsData, doors) --doors
                bsWrap:Write8(bsData, lights) --lights
                bsWrap:Write8(bsData, tires) --tires
                EmulRPC(106 ,bsData)
            end
        function set.KeyState(mem, state)
                Utils:writeMemory(mem, state, 1, true)
            end
        function send.PlayerEnterVehicle(wVehicleID, IsPassenger)
                local bsData = BitStream()
                bsWrap:Write16(bsData, wVehicleID)
                bsWrap:Write8(bsData, IsPassenger)
                SendRPC(26, bsData)
            end
        function send.WeaponUpdate(weaponID, TargetID)
                if weaponInfo[weaponID].ammo ~= nil then
                    if weaponInfo[weaponID].ammo > 1 then
                        local bsData = BitStream()
                        bsWrap:Write8(bsData, 204)
                        bsWrap:Write16(bsData, TargetID)
                        bsWrap:Write16(bsData, 65535)
                        bsWrap:Write8(bsData, weaponInfo[weaponID].slot)
                        bsWrap:Write8(bsData, weaponInfo[weaponID].id)
                        bsWrap:Write16(bsData, weaponInfo[weaponID].ammo)
                        SendPacket(204, bsData)
                        bsWrap:Reset(bsData)
                    end
                end
            end
        function send.CameraTarget(playerID)
                local bsData = BitStream()
                bsWrap:Write16(bsData, 65535) 
                bsWrap:Write16(bsData, 65535) 
                bsWrap:Write16(bsData, playerID) 
                bsWrap:Write16(bsData, 65535)     
                SendRPC(168, bsData)
            end
        function send.GiveTakeDamage(Bool, playerID, amount, Weapon, Bone)
                --Verify
                local bsData = BitStream()
                bsWrap:WriteBool(bsData,Bool) 
                bsWrap:Write16(bsData,playerID) 
                bsWrap:WriteFloat(bsData,amount) 
                bsWrap:Write32(bsData,Weapon)
                bsWrap:Write32(bsData,Bone) 
                
                SendRPC(115, bsData)
                bsWrap:Reset(bsData)
            end
        function send.DeathNotification(Reason, playerID)
                local bsData = BitStream()
                bsWrap:Write8(bsData, Reason)
                bsWrap:Write16(bsData, playerID)
                SendRPC(53,bsData)
                bsWrap:Reset(bsData)
            end
        function send.Vehicle2(vehicleID)
                local bsData = BitStream()
                local vCarPos = Cars:getCarPosition(vehicleID)
                bsWrap:Write8(bsData, 200) 
                bsWrap:Write16(bsData, vehicleID)
                bsWrap:Write16(bsData, 4)
                bsWrap:Write16(bsData, 1)
                bsWrap:Write16(bsData, 23)
                bsWrap:WriteFloat(bsData, 0)  
                bsWrap:WriteFloat(bsData, 0)      
                bsWrap:WriteFloat(bsData, 0)   
                bsWrap:WriteFloat(bsData, 0)  
                bsWrap:WriteFloat(bsData, vCarPos.fX)
                bsWrap:WriteFloat(bsData, vCarPos.fY)
                bsWrap:WriteFloat(bsData, vCarPos.fZ+1000)
                bsWrap:WriteFloat(bsData, 0.0)
                bsWrap:WriteFloat(bsData, 0.0)
                bsWrap:WriteFloat(bsData, 0.0)
                bsWrap:WriteFloat(bsData, Cars:getCarHP(vehicleID))
                bsWrap:Write8(bsData, vMy.HP)
                bsWrap:Write8(bsData, vMy.Armor)
                bsWrap:Write8(bsData, 1)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:WriteFloat(bsData, 0)
                SendPacket(200, bsData)
                bsWrap:Reset(bsData) 
            end
        function send.Vehicle(vehicleID)
                local bsData = BitStream()
                local vCarPos = Cars:getCarPosition(vehicleID)
                
                bsWrap:Write8(bsData, 211) 
                bsWrap:Write16(bsData, vehicleID) 
                bsWrap:Write8(bsData, 0) 
                bsWrap:Write8(bsData, 1) 
                bsWrap:Write8(bsData, 0) 
                bsWrap:Write8(bsData, 0) 
                bsWrap:Write8(bsData, vMy.HP)
                bsWrap:Write8(bsData, vMy.Armor)
                bsWrap:Write16(bsData, 0) 
                bsWrap:Write16(bsData, 0) 
                bsWrap:Write16(bsData, 0) 
                bsWrap:WriteFloat(bsData, vCarPos.fX)  
                bsWrap:WriteFloat(bsData, vCarPos.fY)  
                bsWrap:WriteFloat(bsData, vCarPos.fZ)  
                SendPacket(211, bsData)

                bsWrap:Reset(bsData)
                bsWrap:Write16(bsData, vehicleID) 
                bsWrap:Write8(bsData, 0)
                SendRPC(26,bsData)
                bsWrap:Reset(bsData)
                send.Vehicle2(vehicleID)
            end
        function send.PassengerSync(X, Y, Z, vEnPos, weapon)
                local bsData = BitStream()
                bsWrap:Write8(bsData, 211)
                bsWrap:Write16(bsData, SHAcKvar.DamagerVehicleID) 
                bsWrap:Write8(bsData, 65) 
                --bsWrap:Write8(bsData, 1) 
                --bsWrap:Write8(bsData, 0) 
                bsWrap:Write8(bsData, weapon) 
                bsWrap:Write8(bsData, vMy.HP) 
                bsWrap:Write8(bsData, vMy.Armor) 
                bsWrap:Write16(bsData, 0) 
                if SHAcKvar.DamagerToggleH ~= 65 then
                    bsWrap:Write16(bsData, 2) 
                else
                    bsWrap:Write16(bsData, 4) 
                end
                bsWrap:Write16(bsData, 0) 
                bsWrap:WriteFloat(bsData, X) 
                bsWrap:WriteFloat(bsData, Y) 
                bsWrap:WriteFloat(bsData, Z)
                SendPacket(211, bsData)
                bsWrap:Reset(bsData)
            end
        function send.inCarSync(X, Y, Z, vEnPos, vehicle)
                local b
                local h
                local a
                local c1, c2, c3
                local s1, s2, s3
                local vEnPosfX
                local vEnPosfY

                local lrkey = 0
                local udkey = 0
                local keys = 0
                local quat_w = 0
                local quat_x = 0
                local quat_y = 0
                local quat_z = 0
                local velocity_x = 0
                local velocity_y = 0
                local velocity_z = 0
                local vehicle_health = 0
                local player_health = 0
                local player_armour = 0
                local additional_key = 0
                local weapon_id = 0
                local siren_state = 0
                local landing_gear_state = 0
                local trailer_id = 0
                local train_speed = 0

                if vEnPos ~= 0 then
                    vEnPosfX = CVector(vEnPos.fX - vMy.Pos.fX, 0, 0)
                    vEnPosfY = CVector(0, vEnPos.fY - vMy.Pos.fY, 0)
                    b = 0 * math.pi / 360
                    h = 0 * math.pi / 360
                    a = maths.heading(vEnPosfX, vEnPosfY) * math.pi / 360
                    c1, c2, c3 = math.cos(h), math.cos(a), math.cos(b)
                    s1, s2, s3 = math.sin(h), math.sin(a), math.sin(b)
                end
                local var = math.random(1,5)
                local icdata = vMy.ICData
                keys = 8
                local quaternions = {}
                local vMyPos = Players:getBonePosition(vMy.ID,23)
                if SHAcKvar.Teleporting[1] == 1 and vEnPos ~= 192 then
                    local qw, qx, qy, qz = set.PlayerFacing(vMyPos, vEnPos)
                    
                    quaternions.w = qw
                    quaternions.x = 0
                    quaternions.y = 0
                    quaternions.z = qz
                    quat_w = qw
                    quat_z = qz
                end   
                
                if SHAcKvar.Teleporting[1] == 1 and quaternions ~= 0 and vEnPos ~= 192 then
                    local velocity = {x = 0.02, y = 0.02, z = -0.0000001}
                    local angle = maths.quaternionToAngle(quaternions)
                    local aa = maths.increaseVelocityByAngle(velocity, angle, 0.005)
                
                    local deltaX = (aa.x+vMyPos.fX)-vMyPos.fX
                    local deltaY = (aa.y+vMyPos.fY)-vMyPos.fY
                    local radians = math.atan2(deltaY, deltaX)
                    local degrees = (radians * 180) / math.pi - 90

                    SHAcKvar.pedAngle = degrees

                    velocity_x = aa.x
                    velocity_y = aa.y
                end


                local bsData = BitStream()
                bsWrap:Write8(bsData, 200) 
                bsWrap:Write16(bsData, vehicle)
                bsWrap:Write16(bsData, lrkey)
                bsWrap:Write16(bsData, udkey)
                bsWrap:Write16(bsData, keys)
                bsWrap:WriteFloat(bsData, quat_w)  
                bsWrap:WriteFloat(bsData, quat_x)   
                bsWrap:WriteFloat(bsData, quat_y)   
                bsWrap:WriteFloat(bsData, quat_z)   
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                velocity_x = 0.07
                velocity_y = 0.07
                velocity_z = 0
                bsWrap:WriteFloat(bsData, velocity_x)
                bsWrap:WriteFloat(bsData, velocity_y)
                bsWrap:WriteFloat(bsData, velocity_z) 
                bsWrap:WriteFloat(bsData, icdata.HealthCar)
                bsWrap:Write8(bsData, vMy.HP)
                bsWrap:Write8(bsData, vMy.Armor)
                bsWrap:Write8(bsData, additional_key)
                bsWrap:Write8(bsData, weapon_id)
                bsWrap:Write8(bsData, siren_state)
                bsWrap:Write8(bsData, landing_gear_state)
                bsWrap:Write8(bsData, trailer_id)
                bsWrap:WriteFloat(bsData, train_speed)
                SendPacket(200, bsData)
                bsWrap:Reset(bsData)
            end
        function send.onFootSync(data)
                local bsData = BitStream()
                bsWrap:Write8(bsData, 207) 
                bsWrap:Write16(bsData, data.lrkey) 
                bsWrap:Write16(bsData, data.udkey)
                bsWrap:Write16(bsData, data.keys)
                bsWrap:WriteFloat(bsData, data.X)
                bsWrap:WriteFloat(bsData, data.Y)
                bsWrap:WriteFloat(bsData, data.Z)
                bsWrap:WriteFloat(bsData, data.quat_w)
                bsWrap:WriteFloat(bsData, data.quat_x)
                bsWrap:WriteFloat(bsData, data.quat_y)
                bsWrap:WriteFloat(bsData, data.quat_z)
                bsWrap:Write8(bsData, data.health)
                bsWrap:Write8(bsData, data.armour)
                bsWrap:Write8(bsData, data.weapon_id)
                bsWrap:Write8(bsData, data.special_action)
                bsWrap:WriteFloat(bsData, data.velocity_x)
                bsWrap:WriteFloat(bsData, data.velocity_y)
                bsWrap:WriteFloat(bsData, data.velocity_z)
                bsWrap:WriteFloat(bsData, data.surfing_offsets_x)
                bsWrap:WriteFloat(bsData, data.surfing_offsets_y)
                bsWrap:WriteFloat(bsData, data.surfing_offsets_z)
                bsWrap:Write16(bsData, data.surfing_vehicle_id)
                bsWrap:Write16(bsData, data.animation_id)
                bsWrap:Write16(bsData, data.animation_flags)
                SendPacket(207, bsData)
                bsWrap:Reset(bsData)
            end
        function send.BulletSync(data)
                if Players:isPlayerStreamed(data.hitid) then
                    local bsData = BitStream()
                    bsWrap:Write8(bsData, 206)  
                    bsWrap:Write8(bsData, data.type) 
                    bsWrap:Write16(bsData, data.hitid) 
                    bsWrap:WriteFloat(bsData, data.originX)
                    bsWrap:WriteFloat(bsData, data.originY) 
                    bsWrap:WriteFloat(bsData, data.originZ) 
                    bsWrap:WriteFloat(bsData, data.posX) 
                    bsWrap:WriteFloat(bsData, data.posY) 
                    bsWrap:WriteFloat(bsData, data.posZ) 
                    bsWrap:WriteFloat(bsData, data.offsetX)  
                    bsWrap:WriteFloat(bsData, data.offsetY) 
                    bsWrap:WriteFloat(bsData, data.offsetZ) 
                    bsWrap:Write8(bsData, data.weapon)
                    SendPacket(206, bsData)
                    bsWrap:Reset(bsData)
                end
            end
        function send.AimSync(data)
                local bsData = BitStream()
                bsWrap:Write8(bsData, 203)  
                bsWrap:Write8(bsData, data.cammode or 0)
                bsWrap:WriteFloat(bsData, data.camfrontX or 0)  
                bsWrap:WriteFloat(bsData, data.camfrontY or 0)  
                bsWrap:WriteFloat(bsData, data.camfrontZ or 0) 
                bsWrap:WriteFloat(bsData, data.camposX or 0)
                bsWrap:WriteFloat(bsData, data.camposY or 0)
                bsWrap:WriteFloat(bsData, data.camposZ or 0)
                bsWrap:WriteFloat(bsData, data.aimZ or 0)
                bsWrap:Write8(bsData, data.weaponstate or 0)
                bsWrap:Write8(bsData, data.camzoom or 0)
                bsWrap:Write8(bsData, data.aspectratio or 0)
                SendPacket(203, bsData)
                bsWrap:Reset(bsData)
            end
        function send.SpectatorSync(X, Y, Z)
                local bsData = BitStream()
                bsWrap:Write8(bsData, 212) 
                bsWrap:Write16(bsData, 0) 
                bsWrap:Write16(bsData, 0) 
                bsWrap:Write16(bsData, math.random(1,9)) 
                bsWrap:WriteFloat(bsData, X) 
                bsWrap:WriteFloat(bsData, Y) 
                bsWrap:WriteFloat(bsData, Z)
                SendPacket(212, bsData)
                bsWrap:Reset(bsData) 
            end
        function send.UnoccupiedSync(vehicle, X, Y, Z, velocityX, velocityY, velocityZ)
                local VehicleHealth = Cars:getCarHP(vehicle)
                local bsData = BitStream()
                local pos = Cars:getCarPosition(vehicle)
                local Timer = 0
                local Timer2 = 0
                local RollX
                local RollY
                local RollZ
                for i = 0, 600 do
                    Timer = Timer + 1
                    if Timer > 5 then
                        if i >= 550 then
                            bsWrap:Reset(bsData)
                            bsWrap:Write8(bsData, 207) 
                            bsWrap:Write16(bsData, 128) 
                            bsWrap:Write16(bsData, 128) 
                            bsWrap:Write16(bsData, 128)  
                            bsWrap:WriteFloat(bsData, pos.fX)  
                            bsWrap:WriteFloat(bsData, pos.fY)  
                            bsWrap:WriteFloat(bsData, pos.fZ)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:Write8(bsData, vMy.HP)  
                            bsWrap:Write8(bsData, vMy.Armor)  
                            bsWrap:Write8(bsData, 0)  
                            bsWrap:Write8(bsData, 0)  
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.1,0.1))  
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.1,0.1))  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:Write16(bsData, 0)  
                            bsWrap:Write16(bsData, 0)  
                            bsWrap:Write16(bsData, 0) 
                            SendPacket(207, bsData)
                            
                            bsWrap:Reset(bsData)
                            bsWrap:Write8(bsData, 209) 
                            bsWrap:Write16(bsData, vehicle) 
                            bsWrap:Write8(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0.00000000000001) 
                            bsWrap:WriteFloat(bsData, 0.00000000000001) 
                            bsWrap:WriteFloat(bsData, 0.00000000000001) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.000005, 000005)) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.000005, 000005)) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.000005, 000005)) 
                            bsWrap:WriteFloat(bsData, X) 
                            bsWrap:WriteFloat(bsData, Y) 
                            bsWrap:WriteFloat(bsData, Z) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.500065, -1.000065)) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.500065, -1.000065)) 
                            bsWrap:WriteFloat(bsData, 1.5) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.500065, -1.000065)) 
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.500065, -1.000065)) 
                            bsWrap:WriteFloat(bsData, 1.5) 
                            bsWrap:WriteFloat(bsData, VehicleHealth)
                            SendPacket(209, bsData)
                            bsWrap:Reset(bsData)
                        else
                            bsWrap:Reset(bsData)
                            bsWrap:Write8(bsData, 207) 
                            bsWrap:Write16(bsData, 128) 
                            bsWrap:Write16(bsData, 128) 
                            bsWrap:Write16(bsData, 128)  
                            bsWrap:WriteFloat(bsData, pos.fX)  
                            bsWrap:WriteFloat(bsData, pos.fY)  
                            bsWrap:WriteFloat(bsData, pos.fZ)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:Write8(bsData, vMy.HP)  
                            bsWrap:Write8(bsData, vMy.Armor)  
                            bsWrap:Write8(bsData, 0)  
                            bsWrap:Write8(bsData, 0)  
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.1,0.1))  
                            bsWrap:WriteFloat(bsData, maths.randomFloat(-0.1,0.1))  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:WriteFloat(bsData, 0)  
                            bsWrap:Write16(bsData, 0)  
                            bsWrap:Write16(bsData, 0)  
                            bsWrap:Write16(bsData, 0) 
                            SendPacket(207, bsData)
                            bsWrap:Reset(bsData)
                        end
                        Timer = 0
                    end
                end      
            end
        function send.PutPlayerInVehicle(wVehicleID, bSeatID)
                local havedriver = Cars:getHavePassenger(wVehicleID, 0)
                local driver
                local vEnPos
                local bsData = BitStream()
                local PlayersDist = {}
                local nearest
                local vehiclePos = Cars:getCarPosition(wVehicleID)
                
                if Godmode.InvisibleCar ~= 1 and wVehicleID ~= 1999 then
                    if havedriver == true and Teleport.toVehicleDriver.v then
                        for i, _ in pairs(players.id) do
                            if Players:isPlayerStreamed(i) then

                                local vEnDriver = Players:isDriver(i)

                                if vEnDriver then
                                    local car = Players:getVehicleID(i)
                                    if car == wVehicleID then
                                        vEnPos2 = Players:getPlayerPosition(i)
                                        PlayersDist[i] = Utils:Get3Ddist(vehiclePos, vEnPos2)
                                        nearest = maths.getLowerIn(PlayersDist)
                                        vEnPos = nearest
                                        driver = nearest
                                    end
                                end
                            end
                        end
                        if driver ~= nil and vMy.ID ~= driver then
                            if Players:isPlayerStreamed(driver) then
                                local vEnPos = Players:getPlayerPosition(vEnPos)
                                Timer.Configs[3] = 0
                                v.DrivingPlayerID = driver
                                set.DesyncPlayer(driver, vEnPos.fX, vEnPos.fY, vEnPos.fZ+2)
                            end
                        end
                    end
                end

                bsWrap:Write16(bsData, wVehicleID)
                bsWrap:Write8(bsData, bSeatID)
                EmulRPC(70, bsData)
                bsWrap:Reset(bsData)
                --bsWrap:Write32(bsData, 6)
                --bsWrap:Write16(bsData, wVehicleID)
                --bsWrap:Write8(bsData, 1)
                --EmulRPC(70, bsData)
                --bsWrap:Reset(bsData)
            end
            local function isNan(number)
                return number ~= number
            end
            local function TeleportPlayerTo(Pos)
                if SHAcKvar.Teleporting[1] ~= 2 then
                    SHAcKvar.Teleporting[1] = 1
                end
                local direction = CVector()
                local posLocal = CVector()
                local posPlayer
                local velocity
                if vAmI.Passenger or vAmI.Driver then
                    velocity = Teleport.InCarVelocity.v
                else
                    velocity = Teleport.OnFootVelocity.v
                end
                if v.Bypass == 1 then
                    velocity = 0
                end
                if SHAcKvar.Delayed[1] <= Teleport.PersonalDelay.v then
                    if SHAcKvar.Progressive == 0 then
                        posLocal = Players:getPlayerPosition(Players:getLocalID())
                    else
                        posLocal = SHAcKvar.Progressive
                    end
                    direction = posLocal - Pos
                    
                    local direction = maths.Vector3Normalize(direction)
                    local maxLength = velocity
                    local distance = Utils:Get3Ddist(posLocal, Pos)
                    local normalizedDistance
                    if(distance > maxLength) then
                        normalizedDistance = 1.0
                    else
                        normalizedDistance = distance / maxLength
                    end
                    local distance = normalizedDistance * maxLength
                    posPlayer = CVector(posLocal.fX - direction.fX * distance, posLocal.fY - direction.fY * distance, posLocal.fZ - direction.fZ * distance)
                         
                    local zground = Utils:FindGroundZForCoord(posPlayer.fX,posPlayer.fY)
                    
                    SHAcKvar.Progressive = posPlayer
                    local posPlayer2 = posPlayer
                    posPlayer2.fZ = Pos.fZ
                    local distancefromcheckpoint = Utils:Get3Ddist(Pos, posPlayer2)
                    v.TeleportCounter = tonumber(distancefromcheckpoint)
                    if SHAcKvar.Teleporting[1] == 2 then
                        if Players:Driving(Players:getLocalID()) then
                            local veh = Players:getVehicleID(Players:getLocalID())
                            set.VehiclePos(veh, posPlayer.fX, posPlayer.fY, zground+1)
                            set.VehicleZAngle(SHAcKvar.carAngle)
                        else
                            set.PlayerPos(posPlayer.fX, posPlayer.fY, zground+1)
                        end
                        local bsData = BitStream()
                        EmulRPC(162, bsData)
                        bsWrap:Write8(bsData, 99)
                        EmulRPC(144, bsData)
                        bsWrap:Reset(bsData)
                        
                        v.Bypass = 0
                        v.ACBypass = 0
                        for i = 0, 26 do
                            if SHAcKvar.Teleporting[i] ~= 0 then
                                SHAcKvar.Teleporting[i] = 0
                            end
                        end
                        SHAcKvar.Progressive = 0
                    else
                        if distancefromcheckpoint < maxLength and not isNan(distancefromcheckpoint) then
                            --bypass = 0;
                            --v.ACBypass = 0;
                            local car = Players:getVehicleID(Players:getLocalID())
                            local Driver = Cars:getHavePassenger(SHAcKvar.Vehicle, 0)
                            local Seat1 = Cars:getHavePassenger(SHAcKvar.Vehicle, 1)
                            local Seat2 = Cars:getHavePassenger(SHAcKvar.Vehicle, 2)
                            local Seat3 = Cars:getHavePassenger(SHAcKvar.Vehicle, 3)
                            if Players:isDriver(Players:getLocalID()) or Players:Driving(Players:getLocalID()) then
                                if SHAcKvar.Teleporting[6] == 1 and Teleport.toInside.v then
                                    if Teleport.toVehicleDriver.v and car ~= SHAcKvar.Vehicle or
                                    Teleport.toVehicleDriver.v and car == SHAcKvar.Vehicle and Players:Driving(Players:getLocalID()) and Players:isDriver(Players:getLocalID()) == false then
                                        send.PutPlayerInVehicle(SHAcKvar.Vehicle, 0)
                                    else
                                        local Passenger
                                        if Driver == false then Passenger = 0
                                        elseif Seat1 == false then Passenger = 1
                                        elseif Seat2 == false then Passenger = 2 
                                        elseif Seat3 == false then Passenger = 3
                                        else Passenger = 4 end
                                        send.PutPlayerInVehicle(SHAcKvar.Vehicle, Passenger)
                                    end
                                else
                                    local veh = Players:getVehicleID(Players:getLocalID())
                                    set.VehiclePos(veh, Pos.fX, Pos.fY, Pos.fZ+1)
                                    set.VehicleZAngle(SHAcKvar.carAngle)
                                end
                            else
                                if SHAcKvar.Teleporting[6] == 1 and Teleport.toInside.v then
                                    if Teleport.toVehicleDriver.v then
                                        if Teleport.toVehicleType.v == 0 then
                                            send.PlayerEnterVehicle(SHAcKvar.Vehicle, 0)
                                        end
                                        send.PutPlayerInVehicle(SHAcKvar.Vehicle, 0)
                                    else
                                        local Passenger
                                        if Driver == false then Passenger = 0
                                        elseif Seat1 == false then Passenger = 1
                                        elseif Seat2 == false then Passenger = 2 
                                        elseif Seat3 == false then Passenger = 3
                                        else Passenger = 4 end
                                        if Teleport.toVehicleType.v == 0 then
                                            send.PlayerEnterVehicle(SHAcKvar.Vehicle, Passenger)
                                        end
                                        send.PutPlayerInVehicle(SHAcKvar.Vehicle, Passenger)
                                    end
                                else
                                    set.PlayerPos(posPlayer.fX, posPlayer.fY, posPlayer.fZ)
                                    --set.PlayerZAngle(SHAcKvar.pedAngle)
                                    Teleport.LoadTeleports[0].v = false
                                    Teleport.LoadTeleports[1].v = false
                                    Teleport.LoadTeleports[2].v = false
                                    Teleport.LoadTeleports[3].v = false
                                end
                            end
                            local bsData = BitStream()
                            EmulRPC(162, bsData)
                            bsWrap:Write8(bsData, 99)
                            EmulRPC(144, bsData)
                            bsWrap:Reset(bsData)
                            SHAcKvar.Progressive = 0
                            for i = 0, 26 do
                                if SHAcKvar.Teleporting[i] ~= 0 then
                                    if i >= 4 then
                                        SHAcKvar.CheckpointSave = 0
                                    end
                                    SHAcKvar.Teleporting[i] = 0
                                end
                            end
                            SHAcKvar.Delayed[1] = 0
                        else
                            
                            local qw, qx, qy, qz = set.PlayerFacing(posPlayer, Pos)
                            if Players:Driving(Players:getLocalID()) then
                                local veh = Players:getVehicleID(Players:getLocalID())
                                set.VehiclePos(veh, posPlayer.fX, posPlayer.fY, posPlayer.fZ)
                                local icdata = Players:getInCarData(Players:getLocalID())
                                if Teleport.FromGround.v then
                                    send.inCarSync(posPlayer.fX, posPlayer.fY, zground+1, CVector(Pos.fX, Pos.fY, Pos.fZ), icdata.VehicleID)
                                else
                                    send.inCarSync(posPlayer.fX, posPlayer.fY, posPlayer.fZ, CVector(Pos.fX, Pos.fY, Pos.fZ), icdata.VehicleID)
                                end
                            else
                                set.PlayerPos(posPlayer.fX, posPlayer.fY, posPlayer.fZ)
                                local ofData = get.onFootData()
                                OnFootData.lrkey = 8
                                OnFootData.udkey = 8
                                OnFootData.keys = 8
                                OnFootData.X = posPlayer.fX
                                OnFootData.Y = posPlayer.fY
                                OnFootData.quat_w = qw
                                OnFootData.quat_z = qz
                                OnFootData.velocity_x = 0
                                OnFootData.velocity_y = 0
                                OnFootData.velocity_z = 0
                                if Teleport.FromGround.v then
                                    OnFootData.Z = zground+1
                                else
                                    OnFootData.Z = posPlayer.fZ
                                end
                                send.onFootSync(OnFootData)
                                
                                OnFootData.velocity_x = 0.07
                                OnFootData.velocity_y = 0.07
                                OnFootData.velocity_z = -1
                                send.onFootSync(OnFootData)
                            end
                            local a = math.random(1,2)
                            local mapIcon
                            if a == 1 then mapIcon = 38
                            elseif a == 2 then mapIcon = 36
                            end
                            set.PlayerMapIcon(posPlayer.fX, posPlayer.fY, zground+2, mapIcon)
                            --set.PlayerCameraLookAt(posPlayer.fX, posPlayer.fY, zground4Player, 0)
                        end
                    end
                    if v.Bypass ~= 1 then
                        SHAcKvar.Delayed[1] = SHAcKvar.Delayed[1] + 1
                    end
                end
            end
        function send.VehicleParts(vehicle, panels, doors, lights, tires)
                local bsData = BitStream()
                bsWrap:Write16(bsData, vehicle) --wVehicleID
                bsWrap:Write32(bsData, panels) --panels
                bsWrap:Write32(bsData, doors) --doors
                bsWrap:Write8(bsData, lights) --lights
                bsWrap:Write8(bsData, tires) --tires
                SendRPC(106 ,bsData)
            end
        local function DetonatorCrasher()
                local bsData = BitStream()
                local rand = math.random(0,1)
                bsWrap:Write8(bsData, 207)
                bsWrap:Write16(bsData, vMy.OFData.sLeftRightKeys) 
                bsWrap:Write16(bsData, vMy.OFData.sUpDownKeys) 
                bsWrap:Write16(bsData, 128)  
                bsWrap:WriteFloat(bsData, vMy.Pos.fX)
                bsWrap:WriteFloat(bsData, vMy.Pos.fY)
                bsWrap:WriteFloat(bsData, vMy.Pos.fZ)  
                bsWrap:WriteFloat(bsData, players.Quats.w)  
                bsWrap:WriteFloat(bsData, players.Quats.x)  
                bsWrap:WriteFloat(bsData, players.Quats.y)  
                bsWrap:WriteFloat(bsData, players.Quats.z)  
                bsWrap:Write8(bsData, vMy.OFData.Health)  
                bsWrap:Write8(bsData, vMy.OFData.Armor)  
                bsWrap:Write8(bsData, 40)  
                bsWrap:Write8(bsData, vMy.OFData.SpecialAction)  
                bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fX)  
                bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fY)  
                bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fZ)  
                bsWrap:WriteFloat(bsData, vMy.OFData.SurfingOffsets.fX)  
                bsWrap:WriteFloat(bsData, vMy.OFData.SurfingOffsets.fY)  
                bsWrap:WriteFloat(bsData, vMy.OFData.SurfingOffsets.fZ)  
                bsWrap:Write16(bsData, vMy.OFData.sSurfingVehicleID)  
                bsWrap:Write16(bsData, vMy.OFData.sCurrentAnimationID)  
                bsWrap:Write16(bsData, vMy.OFData.sAnimFlags)
                SendPacket(207,bsData)
                for i = 0, 6 do
                    v.iCamModeCount = v.iCamModeCount + 1
                    if v.iCamModeCount >= 6 then
                        v.iCamModeCount = 0
                    end
                    local bsData = BitStream()
                    bsWrap:Reset(bsData)
                    bsWrap:Write8(bsData, 203)
                    local CrashCam = {7, 8, 34, 45, 46, 51, 65}
                    local aimData = Players:getAimData(vMy.ID)
                    local cam_mode = bsWrap:Write8(bsData, CrashCam[i+1])  
                    local cam_front_vec_x = bsWrap:WriteFloat(bsData, aimData.vecAimf1.fX)  
                    local cam_front_vec_y = bsWrap:WriteFloat(bsData, aimData.vecAimf1.fY)
                    local cam_front_vec_z = bsWrap:WriteFloat(bsData, aimData.vecAimf1.fZ)  
                    local cam_pos_x = bsWrap:WriteFloat(bsData, aimData.vecAimPos.fX)  
                    local cam_pos_y = bsWrap:WriteFloat(bsData, aimData.vecAimPos.fY)   
                    local cam_pos_z = bsWrap:WriteFloat(bsData, aimData.vecAimPos.fZ)  
                    local aim_z = bsWrap:WriteFloat(bsData, aimData.fAimZ)  
                    local weapon_state = bsWrap:Write8(bsData, 63)  
                    local cam_zoom = bsWrap:Write8(bsData, 85)  
                    local aspect_ratio = bsWrap:Write8(bsData, 0) 
                    SendPacket(203,bsData)
                end
            end
        local function RemoveVehicle(ID)
                local bsData = BitStream()
                bsWrap:Write16(bsData, ID)
                EmulRPC(165,bsData)
                bsWrap:Reset(bsData)
            end
        local function CreateVehicle(ID, model, X, Y, Z, bodycolor1, bodycolor2)
                local IC = vMy.OFData
                local health = 999
                local bsData = BitStream()
                local Driver = -1
                if vAmI.Driver or vAmI.Passenger then 
                    IC = vMy.ICData
                    health = IC.HealthCar
                    if IC.VehicleID ~= 1999 then
                        Driver = IC.VehicleID
                    else
                        Driver = -1
                        Godmode.InvisibleCar = 1
                    end
                else
                    if ID ~= 1999 then
                        Driver = 0
                    else
                        Driver = -1
                        Godmode.InvisibleCar = 1
                    end
                end
                local vec = Players:getAimData(vMy.ID)
                local deltaX = (vec.vecAimf1.fX+IC.Pos.fX)-IC.Pos.fX
                local deltaY = (vec.vecAimf1.fY+IC.Pos.fY)-IC.Pos.fY
                local radians = math.atan2(deltaY, deltaX)
                local degrees = (radians * 180) / math.pi - 90
                RemoveVehicle(ID)
                local X, Y
                if Driver ~= 0 then X = IC.Pos.fX else X = vec.vecAimPos.fX end
                if Driver ~= 0 then Y = IC.Pos.fY else Y = vec.vecAimPos.fY end
                bsWrap:Write16(bsData, ID)
                bsWrap:Write32(bsData, model)
                bsWrap:WriteFloat(bsData, X)
                bsWrap:WriteFloat(bsData, Y)
                bsWrap:WriteFloat(bsData, Z)
                bsWrap:WriteFloat(bsData, degrees)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:WriteFloat(bsData, health)
                bsWrap:Write8(bsData, SHAcKvar.Interior)
                bsWrap:Write32(bsData, 0)
                bsWrap:Write32(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write32(bsData, bodycolor1)
                bsWrap:Write32(bsData, bodycolor2)
                EmulRPC(164,bsData)
                bsWrap:Reset(bsData)
                send.PutPlayerInVehicle(ID,0)
                if Driver == -1 then
                    Godmode.InvisibleCar = 1
                    SHAcKvar.InvCar = 0
                    SHAcKvar.InvTimer = 0
                end
                set.EngineState(ID)
                bsWrap:Write16(bsData, ID) 
                bsWrap:WriteFloat(bsData, degrees)
                EmulRPC(160, bsData)
            end
        local function vehiclefucker(car)
                -- local Car = maths.getLowerIn(vehicles.dist)
                -- if Car ~= nil then
                local vCarPos = Cars:getCarPosition(car)
                local bsData = BitStream()
                local seat
                
                local posX = vCarPos.fX
                local posY = vCarPos.fY
                local posZ = vCarPos.fZ
                local x = math.random(-99,99)
                local y = math.random(-99,99)
                local z = maths.randomFloat(0.000001, 0.000002)
                for i = 0, 2 do
                    if Troll.VehicleTrollType.v == 2 then
                        seat = maths.Chance(50)
                        if seat == true then
                            seat = 1
                        else
                            seat = 0
                        end
                    else
                        seat = 0
                    end
                    bsWrap:Write8(bsData, 209) 
                    bsWrap:Write16(bsData, car) 
                    bsWrap:Write8(bsData, seat) 
                    bsWrap:WriteFloat(bsData, 0.00000000000001) 
                    bsWrap:WriteFloat(bsData, 0.00000000000001) 
                    bsWrap:WriteFloat(bsData, 0.00000000000001) 
                    bsWrap:WriteFloat(bsData, maths.randomFloat(-0.000005, 0.000005)) 
                    bsWrap:WriteFloat(bsData, maths.randomFloat(-0.000005, 0.000005)) 
                    bsWrap:WriteFloat(bsData, maths.randomFloat(-0.000005, 0.000005)) 
                    bsWrap:WriteFloat(bsData, posX)
                    bsWrap:WriteFloat(bsData, posY)
                    bsWrap:WriteFloat(bsData, posZ)
                    bsWrap:WriteFloat(bsData, x) 
                    bsWrap:WriteFloat(bsData, y) 
                    bsWrap:WriteFloat(bsData, z) 
                    bsWrap:WriteFloat(bsData, 0.00000000000001) 
                    bsWrap:WriteFloat(bsData, 0.00000000000001) 
                    bsWrap:WriteFloat(bsData, 0.00000000000001) 
                    bsWrap:WriteFloat(bsData, Cars:getCarHP(car))
                    SendPacket(209, bsData)
                    bsWrap:Reset(bsData)
                end
            end
    --RPC/PACKET
        local function OnReceivePacket(packetId, bsData)
                if Panic.EveryThingExceptVisuals.v == false and unload == false and Godmode.InvisibleCar ~= nil and Godmode.InvisibleCar ~= 1 then
                local Packet_ID = bsWrap:Read8(bsData)
                local PlayerID = bsWrap:Read16(bsData)
                if packetId == 207 then -- ONFOOT SYNC
                    local OFdata = Players:getOnFootData(PlayerID)
                    if Players:getPlayerWeapon(PlayerID) == 40 then
                        local camModes = {7, 8, 34, 45, 46, 51, 65}
                        for k, v in pairs(camModes) do
                            local AimData = Players:getAimData(PlayerID)
                            if AimData.CamMode == v then
                                PrintConsole( Players:getPlayerName(PlayerID) .. "(".. PlayerID ..") Detonator Crasher")
                                return false
                            end
                        end
                    end
                    if Vehicle.AntiCarJack.v then
                        if vAmI.Driver then
                            if Players:isPlayerStreamed(PlayerID) then
                                local vEnPos = Players:getPlayerPosition(PlayerID)
                                local   distance = Utils:Get3Ddist(vMy .Pos, vEnPos)
                                if OFdata.SpecialAction == 3 and distance < 5 then
                                    if Players:isPlayerStreamed(PlayerID) then
                                        set.DesyncPlayer(PlayerID, vEnPos.fX+3, vEnPos.fY+3, vEnPos.fZ)
                                    end
                                    return false
                                end
                            end
                        end
                    end
                end
                if packetId == 200 then -- INCAR SYNC
                    local ICdata = vMy.ICData

                    local vehicle_id = bsWrap:Read16(bsData)
                    local lrkey = bsWrap:Read16(bsData) 
                    local udkey = bsWrap:Read16(bsData) 
                    local keys = bsWrap:Read16(bsData) 
                    local quat_w = bsWrap:ReadFloat(bsData) 
                    local quat_x = bsWrap:ReadFloat(bsData) 
                    local quat_y = bsWrap:ReadFloat(bsData) 
                    local quat_z = bsWrap:ReadFloat(bsData) 
                    local X = bsWrap:ReadFloat(bsData) 
                    local Y = bsWrap:ReadFloat(bsData) 
                    local Z = bsWrap:ReadFloat(bsData) 
                    local velocity_x = bsWrap:ReadFloat(bsData) 
                    local velocity_y = bsWrap:ReadFloat(bsData) 
                    local velocity_z = bsWrap:ReadFloat(bsData) 
                    local vehicle_health = bsWrap:ReadFloat(bsData) 
                    local player_health = bsWrap:Read8(bsData) 
                    local player_armour = bsWrap:Read8(bsData) 
                    local additional_key = bsWrap:Read8(bsData) 
                    local weapon_id = bsWrap:Read8(bsData) 
                    local siren_state = bsWrap:Read8(bsData) 
                    local landing_gear_state = bsWrap:Read8(bsData) 
                    local trailer_id = bsWrap:Read8(bsData) 
                    local train_speed = bsWrap:ReadFloat(bsData)
                    --if Vehicle.DriveNoLicense.v and Vehicle.DriveNoLicenseFakeData.v or Vehicle.AntiCarJack.v then
                    if ICdata.VehicleID == vehicle_id and vAmI.Driver then
                        if v.DrivingPlayerID ~= PlayerID then
                            v.Troller = PlayerID
                            Timer.Configs[4] = 0
                        else
                            Timer.Configs[3] = 0
                        end
                        return false
                    end
                end
                if packetId == 209 then -- UNOCCUPIED SYNC
                --Anti RollCrasher
                    local vehicle_id = bsWrap:Read16(bsData)
                    local seat_id = bsWrap:Read8(bsData)
                    local roll_x = bsWrap:ReadFloat(bsData)
                    local roll_y = bsWrap:ReadFloat(bsData)
                    local roll_z = bsWrap:ReadFloat(bsData)
                    if roll_x >= 10000.0 or roll_y >= 10000.0 or roll_z >= 10000.0 or roll_x <= -10000.0 or roll_y <= -10000.0 or roll_z <= -10000.0 then
                        PrintConsole( Players:getPlayerName(PlayerID) .. "(".. PlayerID ..") Roll Crasher")
                        bsWrap:Reset(bsData)
                        return false
                    end
                end
                if packetId == 206 then -- BULLET SYNC
                    local hittype = bsWrap:Read8(bsData)
                    local hitid = bsWrap:Read16(bsData)
                    local OriginX = bsWrap:ReadFloat(bsData)
                    local OriginY = bsWrap:ReadFloat(bsData)
                    local OriginZ = bsWrap:ReadFloat(bsData)
                    local posX = bsWrap:ReadFloat(bsData)
                    local posY = bsWrap:ReadFloat(bsData)
                    local posZ = bsWrap:ReadFloat(bsData)
                    local offsetX = bsWrap:ReadFloat(bsData)
                    local offsetY = bsWrap:ReadFloat(bsData)
                    local offsetZ = bsWrap:ReadFloat(bsData)
                    local WeaponID = bsWrap:Read8(bsData)
                    if hitid == vMy.ID then
                        SHAcKvar.AfterDamage[PlayerID] = PlayerID
                        SHAcKvar.AfterDamageName[PlayerID] = Players:getPlayerName(PlayerID)
                        SHAcKvar.AfterDamageDelayPer[PlayerID] = 0
                    end
                    local health = vMy.OFData.Health - weaponInfo[WeaponID].damage
                    local armour = vMy.OFData.Armor - weaponInfo[WeaponID].damage
                    if Movement.AntiStun.Enable.v and hitid == vMy.ID then
                        SHAcKvar.ShotsTaken = SHAcKvar.ShotsTaken + 1
                        if SHAcKvar.ShotsTaken >= Movement.AntiStun.Timer.v then
                            v.KBDraw1 = 1
                            v.StunCount = Movement.AntiStun.MinChance.v
                            v.SmartStunCount = 0
                            SHAcKvar.ShotsTaken = 0
                        end
                        Movement.AntiStun.Chance = maths.Chance(StunCount)
                        if Movement.AntiStun.On == 1 then
                            local ArmorLeft
                            if Godmode.PlayerEnable.v == false or Godmode.PlayerEnable.v and Godmode.PlayerBullet.v == false then
                                if Movement.AntiStun.SaveDamageAR ~= 0 and Movement.AntiStun.SaveDamageAR == vMy.OFData.Armor then
                                    --local bsDataa = BitStream()
                                    --bsWrap:WriteFloat(bsDataa, armour) 
                                    --EmulRPC(66, bsDataa)
                                    --bsWrap:Reset(bsDataa)
                                    bsWrap:Reset(bsData)
                                    return false
                                end
                                if Movement.AntiStun.SaveDamageHP ~= 0 and Movement.AntiStun.SaveDamageHP == vMy.OFData.Health then
                                    --local bsDataa = BitStream()
                                    --bsWrap:WriteFloat(bsDataa, health) 
                                    --EmulRPC(14, bsDataa)
                                    --bsWrap:Reset(bsDataa)
                                    if data.Health < 0 then 
                                        Movement.AntiStun.SaveDamageHP = 0
                                        Movement.AntiStun.On = 0 
                                    else
                                        Movement.AntiStun.SaveDamageHP = health
                                    end
                                    bsWrap:Reset(bsData)
                                    return false
                                end
                            end
                        end
                    end
                    if BulletRebuff.Enable.v and hitid == vMy.ID then
                        if Players:isPlayerInFilter(PlayerID) and BulletRebuff.Force.v or BulletRebuff.Force.v == false then
                            if Players:getPlayerColor(PlayerID) ~= vMy.Color and BulletRebuff.Clist.v or BulletRebuff.Clist.v == false then
                                local Weapon = vMy.Weapon
                                if BulletRebuff.SameWeapon.v then
                                    local slot = 0
                                    if WeaponID >= 2 and WeaponID <= 9 then 
                                        slot = 1
                                    elseif WeaponID >= 22 and WeaponID <= 24 then 
                                        slot = 2
                                    elseif WeaponID >= 25 and WeaponID <= 27 then 
                                        slot = 3
                                    elseif WeaponID >= 28 and WeaponID <= 29 or WeaponID == 32 then 
                                        slot = 4
                                    elseif WeaponID >= 30 and WeaponID <= 31 then 
                                        slot = 5
                                    elseif WeaponID >= 33 and WeaponID <= 34 then 
                                        slot = 6
                                    elseif WeaponID >= 35 and WeaponID <= 38 then 
                                        slot = 7
                                    elseif WeaponID >= 41 and WeaponID <= 43 then 
                                        slot = 8
                                    elseif WeaponID >= 16 and WeaponID <= 18 then 
                                        slot = 9
                                    elseif WeaponID >= 10 and WeaponID <= 15 then 
                                        slot = 10
                                    end
                                    Weapon = get.WeaponInSlot(slot)
                                end
                                local Amount = weaponInfo[Weapon].damage
                                if BulletRebuff.SyncWeapon.v then
                                    if weaponInfo[Weapon].ammo == nil or weaponInfo[Weapon].ammo > 0 then
                                        set.WeaponAmmo(weaponInfo[Weapon].id, 1)
                                    end
                                    send.WeaponUpdate(Weapon, PlayerID)
                                end
                                local randBone
                                if SHAcKvar.lastbone == 3 then
                                    randBone = math.random(3,9)
                                else
                                    randBone = SHAcKvar.lastbone
                                end
                                local cheatBone = get.CheatBoneFromGame(randBone)
                                SHAcKvar.damagerBone = cheatBone
                                local vEnPos = Players:getPlayerPosition(PlayerID)
                                local vEnPos2 = Players:getBonePosition(PlayerID, cheatBone)
                                local offset = CVector()
                                local rand = CVector(maths.randomFloat(-0.05, 0.05), maths.randomFloat(-0.05, 0.05), maths.randomFloat(-0.02, 0.02))
                                offset = vEnPos2 - vEnPos + rand
                                local hitpos = CVector(vEnPos.fX+offset.fX, vEnPos.fY+offset.fY, vEnPos.fZ+offset.fZ)
                                local vMyBone = Players:getBonePosition(vMy.ID, 22)
                                local origin = CVector(vMyBone.fX, vMyBone.fY, vMyBone.fZ)
                                
                                local qw, qx, qy, qz = set.PlayerFacing(vMyBone, vEnPos)
                                local ofData = get.onFootData()
                                OnFootData.keys = 132
                                OnFootData.weapon = weaponInfo[Weapon].id
                                OnFootData.quat_w = qw
                                OnFootData.quat_z = qz
                                OnFootData.animation_id = weaponInfo[Weapon].animations
                                OnFootData.animation_flags = weaponInfo[Weapon].animationsflag

                                send.onFootSync(OnFootData)

                                send.CameraTarget(PlayerID)
                                
                                if Weapon >= 22 then

                                    if Weapon >= 22 and Weapon ~= 46 then
                                        local aD = get.AimData()
                                        local direction = get.Direction(vEnPos, vMyBone)
                                        local aimz = get.AimZ(vMyBone, vEnPos)
                                        local aD = get.AimData()
                                        AimData.cammode = weaponInfo[Weapon].cammode
                                        AimData.weaponstate = weaponInfo[Weapon].weaponstate
                                        AimData.camfrontX = direction.fX
                                        AimData.camfrontY = direction.fY 
                                        AimData.camfrontZ = direction.fZ
                                        AimData.aimZ = aimz
                                        send.AimSync(AimData)

                                        local myBulletData = get.BulletData()
                                        BulletData.type = hittype
                                        BulletData.hitid = PlayerID
                                        BulletData.originX = origin.fX
                                        BulletData.originY = origin.fY
                                        BulletData.originZ = origin.fZ
                                        BulletData.posX = hitpos.fX
                                        BulletData.posY = hitpos.fY
                                        BulletData.posZ = hitpos.fZ
                                        BulletData.offsetX = offset.fX
                                        BulletData.offsetY = offset.fY
                                        BulletData.offsetZ = offset.fZ
                                        BulletData.weapon = Weapon
                                        send.BulletSync(BulletData)
                                    end 
                                    send.GiveTakeDamage(false, PlayerID, Amount, Weapon, randBone)
                                else
                                    send.GiveTakeDamage(false, PlayerID, Amount, Weapon, randBone)
                                end
                            end
                        end
                    end 
                    if hitid == vMy.ID then
                        if Extra.RequestSpawn.v then
                            if Extra.RequestSpawnHP.v < 100 and armour < 0 and health < Extra.RequestSpawnHP.v or
                            Extra.RequestSpawnHP.v >= 100 and armour < Extra.RequestSpawnArmour.v then
                                local bsData = BitStream()
                                SendRPC(129, bsData)
                                SendRPC(52, bsData)
                                SHAcKvar.SavePosForSpawn = CVector(data.Pos.fX, data.Pos.fY, data.Pos.fZ)
                                SHAcKvar.RequestingSpawn = 1
                                return false
                            end
                        end
                    end
                end
                if packetId == 203 then --AimSync
                    --Read
                    local cam_mode = bsWrap:Read8(bsData)  
                    players.AimPosX[PlayerID] = bsWrap:ReadFloat(bsData)  
                    players.AimPosY[PlayerID] = bsWrap:ReadFloat(bsData)  
                    players.AimPosZ[PlayerID] = bsWrap:ReadFloat(bsData)  
                    local cam_pos_x = bsWrap:ReadFloat(bsData)  
                    local cam_pos_y = bsWrap:ReadFloat(bsData)  
                    local cam_pos_z = bsWrap:ReadFloat(bsData)  
                    local aim_z = bsWrap:ReadFloat(bsData)  
                    local weapon_state = bsWrap:Read8(bsData)  
                    local cam_zoom = bsWrap:Read8(bsData)  
                    local aspect_ratio = bsWrap:Read8(bsData) 
                end
                end
                return true
            end
        local function OnReceiveRPC(rpcId, bsData)
                    if Panic.EveryThingExceptVisuals.v == false and unload == false then
                        bsWrap:ResetReadPointer(bsData)
                    if rpcId == 24 then
                        local wVehicleID = bsWrap:Read16(bsData)
                        local Engine = bsWrap:Read8(bsData)
                        if Vehicle.NeverOffEngine.v then
                            if Engine == 0 then
                                set.EngineState(wVehicleID)
                                return false
                            end
                        end
                        bsWrap:Reset(bsData)
                    end
                    if rpcId == 95 then
                        local iPickupID = bsWrap:Read32(bsData)
                        local iModelID = bsWrap:Read32(bsData) 
                        local iSpawnType = bsWrap:Read32(bsData) 
                        local X = bsWrap:ReadFloat(bsData)
                        local Y = bsWrap:ReadFloat(bsData)
                        local Z = bsWrap:ReadFloat(bsData)
                        bsWrap:Reset(bsData)

                        Pickups[iPickupID] = {
                            ModelID = iModelID,
                            SpawnType = iSpawnType,
                            X = X,
                            Y = Y,
                            Z = Z
                        }
                    end
                    if rpcId == 63 then
                        local iPickupID = bsWrap:Read32(bsData)
                        Pickups[iPickupID] = nil
                    end
                    if rpcId == 168 then
                        local ObjectTarget = bsWrap:Read16(bsData)
                        local VehicleTarget = bsWrap:Read16(bsData) 
                        local PlayerTarget = bsWrap:Read16(bsData) 
                        local ActorTarget = bsWrap:Read16(bsData)
                    end
                    if rpcId == 139 then
                        local bZoneNames = bsWrap:ReadBool(bsData)
                        local bUseCJ = bsWrap:ReadBool(bsData) 
                        if bUseCJ == false then
                            SHAcKvar.CJWalk = 0
                        else
                            SHAcKvar.CJWalk = 2
                        end
                        local bAllowWeapons = bsWrap:ReadBool(bsData)
                        local bLimitGlobalChatRadius = bsWrap:ReadBool(bsData)
                        local fGlobalChatRadius = bsWrap:ReadFloat(bsData)
                        local bStuntBonus = bsWrap:ReadBool(bsData)
                        local fNafNameTagDistancemeT = bsWrap:ReadFloat(bsData)
                        local bDisableEnterExits = bsWrap:ReadBool(bsData)
                        local bNameTagLOS = bsWrap:ReadBool(bsData)
                        local bManualVehEngineAndLights = bsWrap:ReadBool(bsData)
                        local dSpawnsAvailable = bsWrap:Read32(bsData)
                        local wPlayerID = bsWrap:Read16(bsData)
                        local bShowNameTags = bsWrap:ReadBool(bsData)
                        local dShowPlayerMarkers = bsWrap:Read32(bsData)
                        local bWorldTime = bsWrap:Read8(bsData)
                        local bWeather = bsWrap:Read8(bsData)
                        local fGravity = bsWrap:ReadFloat(bsData)
                        local bLanMode = bsWrap:ReadBool(bsData)
                        local dDeathDropMoney = bsWrap:Read32(bsData)
                        local bInstagib = bsWrap:ReadBool(bsData)
                        local dOnfootRate = bsWrap:Read32(bsData)
                        local dInCarRate = bsWrap:Read32(bsData)
                        local dWeaponRate = bsWrap:Read32(bsData)
                        local dMultiplier = bsWrap:Read32(bsData)
                        local dLagCompMode = bsWrap:Read32(bsData)
                        local length = bsWrap:Read8(bsData)
                        local HostName1 = ImBuffer(length)
                        local HostName2 = bsWrap:ReadBuf(bsData, HostName1, length)
                        local bVehicleModels = bsWrap:Read8(bsData) 
                        local dVehicleFriendlyFire = bsWrap:Read32(bsData)
                        if Movement.bUseCJWalk.v then
                            bsWrap:Reset(bsData)
                            bsWrap:WriteBool(bsData, bZoneNames)
                            bsWrap:WriteBool(bsData, true)
                            bsWrap:WriteBool(bsData, bAllowWeapons)
                            bsWrap:WriteBool(bsData, bLimitGlobalChatRadius)
                            bsWrap:WriteFloat(bsData, fGlobalChatRadius)
                            bsWrap:WriteBool(bsData, bStuntBonus)
                            bsWrap:WriteFloat(bsData, fNafNameTagDistancemeT)
                            bsWrap:WriteBool(bsData, bDisableEnterExits)
                            bsWrap:WriteBool(bsData, bNameTagLOS)
                            bsWrap:WriteBool(bsData, bManualVehEngineAndLights)
                            bsWrap:Write32(bsData, dSpawnsAvailable)
                            bsWrap:Write16(bsData, wPlayerID)
                            bsWrap:WriteBool(bsData, bShowNameTags)
                            bsWrap:Write32(bsData, dShowPlayerMarkers)                            
                            bsWrap:Write8(bsData, bWorldTime)
                            bsWrap:Write8(bsData, bWeather)
                            bsWrap:WriteFloat(bsData, fGravity)
                            bsWrap:WriteBool(bsData, bLanMode)
                            bsWrap:Write32(bsData, dDeathDropMoney)                            
                            bsWrap:WriteBool(bsData, bInstagib)
                            bsWrap:Write32(bsData, dOnfootRate)                     
                            bsWrap:Write32(bsData, dInCarRate)
                            bsWrap:Write32(bsData, dWeaponRate)
                            bsWrap:Write32(bsData, dMultiplier)
                            bsWrap:Write32(bsData, dLagCompMode)
                            bsWrap:Write8(bsData, length)
                            bsWrap:WriteBuf(bsData, HostName1, length)
                            bsWrap:Write8(bsData, bVehicleModels) 
                            bsWrap:Write32(bsData, dVehicleFriendlyFire)
                            EmulRPC(139, bsData)
                            return false
                        end
                    end
                    if rpcId == 156 then
                        local interior = bsWrap:Read8(bsData) 
                        SHAcKvar.Interior = interior
                    end
                    if rpcId == 103 then
                        local requestType = bsWrap:Read8(bsData)
                        local arg = bsWrap:Read32(bsData)
                        local offset = bsWrap:Read16(bsData)
                        local readSize = bsWrap:Read16(bsData)
                
                        if readSize > 256 or readSize < 2 or offset > 256 then
                            return
                        end
                
                        local result = 0

                        if requestType == 0x5 then
                            if arg >= 0x400000 and arg <= 0x856E00 then
                                result = Utils:readMemory(arg + offset - dwGTAModule + ClearGTAModule, readSize, false)
                            end
                        end
                        if requestType == 0x45 then
                            if arg <= 0xC3500 then
                                result = Utils:readMemory(arg + offset + ClearSAMPModule, readSize, false)
                            end
                        end
                
                        bsWrap:Reset(bsData)
                        bsWrap:Write8(bsData, requestType)
                        bsWrap:Write32(bsData, arg)
                        bsWrap:Write8(bsData, result)
                        SendRPC(rpcId, bsData)
                        return false
                    end
                    if rpcId == 34 then
                        if Extra.SetWeaponSkill.v then
                            return false
                        end
                    end
                    if rpcId == 12 or rpcId == 13 or rpcId == 68 or rpcId == 128 or rpcId == 153 or rpcId == 87 then
                        if SHAcKvar.RequestingSpawn ~= 0 then
                            set.PlayerPos(SHAcKvar.SavePosForSpawn.fX, SHAcKvar.SavePosForSpawn.fY, SHAcKvar.SavePosForSpawn.fZ)
                            return false
                        end
                    end
                    if rpcId == 106 then
                            local vehicle = bsWrap:Read16(bsData)
                            vehicleParts.panels[vehicle] = bsWrap:Read32(bsData)
                            vehicleParts.doors[vehicle] = bsWrap:Read32(bsData)
                            vehicleParts.lights[vehicle] = bsWrap:Read8(bsData)
                            vehicleParts.tires[vehicle] = bsWrap:Read8(bsData)
                        if Vehicle.NeverPopTire.v then
                            return false
                        end
                    end
                    if rpcId == 164 then
                        local vehicle = bsWrap:Read16(bsData) 
                        local ModelID = bsWrap:Read32(bsData) 
                        local X = bsWrap:ReadFloat(bsData) 
                        local Y = bsWrap:ReadFloat(bsData) 
                        local Z = bsWrap:ReadFloat(bsData) 
                        local Angle = bsWrap:ReadFloat(bsData) 
                        local InteriorColor1 = bsWrap:Read32(bsData) 
                        local InteriorColor2 = bsWrap:Read32(bsData) 
                        local Health = bsWrap:ReadFloat(bsData) 
                        local interior = bsWrap:Read8(bsData) 
                        vehicleParts.doors[vehicle] = bsWrap:Read32(bsData) 
                        vehicleParts.panels[vehicle] = bsWrap:Read32(bsData) 
                        vehicleParts.lights[vehicle] = bsWrap:Read8(bsData) 
                        vehicleParts.tires[vehicle] = bsWrap:Read8(bsData)
                    end
                    if rpcId == 32 then
                        local wPlayerID = bsWrap:Read16(bsData)
                        local team = bsWrap:Read8(bsData)
                        local dSkinId = bsWrap:Read32(bsData)
                        local PosX = bsWrap:ReadFloat(bsData)
                        local PosY = bsWrap:ReadFloat(bsData)
                        local PosZ = bsWrap:ReadFloat(bsData)
                        local facing_angle = bsWrap:ReadFloat(bsData)
                        local player_color = bsWrap:Read32(bsData) 
                        local fighting_style = bsWrap:Read8(bsData) 
                        if players.team[wPlayerID] ~= player_color then players.team[wPlayerID] = team end
                        if players.fightstyle[wPlayerID] ~= player_color then players.fightstyle[wPlayerID] = fighting_style end
                    end
                    if rpcId == 105 or rpcId == 134 or rpcId == 135 then
                        local wTextDrawID = bsWrap:Read16(bsData)
                        if v.ShowDraws[0] == wTextDrawID or v.ShowDraws[1] == wTextDrawID then
                            return false
                        end
                    end
                    if rpcId == 35 then
                        if Extra.Mobile.v then
                            return false
                        end
                    end
                    if rpcId == 103 then
                        local type8 = bsWrap:Read8(bsData)
                        local arg = bsWrap:Read32(bsData)
                        local response = bsWrap:Read8(bsData)
                        if type8 == 72 then
                            if Extra.Mobile.v then
                                return false
                            end
                        end
                    end
                --Auto Reply
                    if Extra.AutoReply[0].v then
                        if rpcId == 93 then
                            if Extra.AutoReply[1].v then
                                local color = bsWrap:Read32(bsData)
                                local dMessageLength = bsWrap:Read32(bsData)
                                local buf = ImBuffer(dMessageLength)
                                bsWrap:ReadBuf(bsData, buf, dMessageLength)
                        
                                if buf.v ~= nil then
                                    local cleanedText = string.gsub(buf.v, "{%a+}", "")
                                    local cleanedText = string.lower(cleanedText)
                                    if cleanedText ~= "" then
                                        local searchText = string.lower(Extra.Message[1].v)
                                        if string.find(cleanedText, searchText, 1, true) then
                                            Utils:SayChat(Extra.Reply[1].v)
                                        end
                                    end
                                end
                            end
                        end
                        if rpcId == 101 then
                            if Extra.AutoReply[1].v then
                                local PlayerID = bsWrap:Read16(bsData)
                                if PlayerID ~= vMy.ID then
                                    local Length = bsWrap:Read8(bsData)
                                    local buf = ImBuffer(Length)
                                    bsWrap:ReadBuf(bsData, buf, Length)
                                    if buf.v ~= nil then
                                        local cleanedText = string.gsub(buf.v, "{%a+}", "")
                                        local cleanedText = string.lower(cleanedText)
                                        if cleanedText ~= "" then
                                            local searchText = string.lower(Extra.Message[1].v)
                                            if string.find(cleanedText, searchText, 1, true) then
                                                Utils:SayChat(Extra.Reply[1].v)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if rpcId == 105 then
                            if Extra.AutoReply[2].v then
                                local wTextDrawID = bsWrap:Read16(bsData)
                                local TextLength = bsWrap:Read16(bsData)
                                local buf = ImBuffer(TextLength)
                                bsWrap:ReadBuf(bsData, buf, TextLength)
                                if buf.v ~= nil then
                                    local cleanedText = string.gsub(buf.v, "{%a+}", "")
                                    local cleanedText = string.lower(cleanedText)
                                    if cleanedText ~= "" then
                                        local searchText = string.lower(Extra.Message[2].v)
                                        if string.find(cleanedText, searchText, 1, true) then
                                            Utils:SayChat(Extra.Reply[2].v)
                                        end
                                    end
                                end
                            end
                        end
                        if rpcId == 134 then
                            if Extra.AutoReply[2].v then
                                local wTextDrawID = bsWrap:Read16(bsData) 
                                local Flags = bsWrap:Read8(bsData) 
                                local fLetterWidth = bsWrap:ReadFloat(bsData) 
                                local fLetterHeight = bsWrap:ReadFloat(bsData) 
                                local dLetterColor = bsWrap:Read32(bsData) 
                                local fLineWidth = bsWrap:ReadFloat(bsData) 
                                local fLineHeight = bsWrap:ReadFloat(bsData) 
                                local dBoxColor = bsWrap:Read32(bsData) 
                                local Shadow = bsWrap:Read8(bsData) 
                                local Outline = bsWrap:Read8(bsData) 
                                local dBackgroundColor = bsWrap:ReadFloat(bsData) 
                                local Style = bsWrap:Read8(bsData) 
                                local Selectable = bsWrap:Read8(bsData) 
                                local fX = bsWrap:ReadFloat(bsData) 
                                local fY = bsWrap:ReadFloat(bsData) 
                                local wModelID = bsWrap:Read16(bsData) 
                                local fRotX = bsWrap:ReadFloat(bsData) 
                                local fRotY = bsWrap:ReadFloat(bsData) 
                                local fRotZ = bsWrap:ReadFloat(bsData) 
                                local fZoom = bsWrap:ReadFloat(bsData) 
                                local wColor1 = bsWrap:Read16(bsData) 
                                local wColor2 = bsWrap:Read16(bsData) 
                                local szTextLen = bsWrap:Read16(bsData) 
                                local buf = ImBuffer(szTextLen)
                                bsWrap:ReadBuf(bsData, buf, szTextLen)
                                if buf.v ~= nil then
                                    local cleanedText = string.gsub(buf.v, "{%a+}", "")
                                    local cleanedText = string.lower(cleanedText)
                                    if cleanedText ~= "" then
                                        local searchText = string.lower(Extra.Message[2].v)
                                        if string.find(cleanedText, searchText, 1, true) then
                                            Utils:SayChat(Extra.Reply[2].v)
                                        end
                                    end
                                end
                            end
                        end
                    end
                if rpcId == 44 then
                    local wObjectID = bsWrap:Read16(bsData)
                    local ModelID = bsWrap:Read32(bsData)
                    if ModelID == 385 then
                        return false
                    end
                end
                if rpcId == 12 or rpcId == 159 then
                    if KeyToggle.RVanka.v == 1 then
                        return false
                    end
                    local vehicle = 0
                    if rpcId == 159 then
                        vehicle = bsWrap:Read16(bsData)
                    end
                    local floatX = bsWrap:ReadFloat(bsData)
                    local floatY = bsWrap:ReadFloat(bsData)
                    local floatZ = bsWrap:ReadFloat(bsData)

                    local vMyPos = CVector(vMy.Pos.fX,vMy.Pos.fY,vMy.Pos.fZ)
                    local Vector = CVector(floatX,floatY,floatZ)

                    local distance = Utils:Get2Ddist(vMyPos, Vector)

                    if Extra.AntiSlapper.v then
                        if floatZ - vMy.Pos.fZ >= 1 or floatZ - vMy.Pos.fZ <= -1 then
                            if floatX - vMy.Pos.fX <= 5 and floatX - vMy.Pos.fX >= -5 and floatY - vMy.Pos.fY <= 5 and floatX - vMy.Pos.fY >= -5 then
                                return false
                            end
                        end
                    end
                    if Vehicle.DriveNoLicense.v then
                        if distance < 2 then
                            return false
                        end
                    end
                    if SHAcKvar.Teleporting[1] == 1 then
                        if distance < Teleport.OnFootVelocity.v+1 or distance < Teleport.InCarVelocity.v+1 then
                            if vAmI.Driver then
                                local veh = vMy.Vehicle
                                bsWrap:Reset(bsData)
                                bsWrap:Write16(bsData, veh) 
                                bsWrap:Write8(bsData, 0)
                                EmulRPC(70, bsData)
                            end
                            return false
                        end
                    end
                    bsWrap:Reset(bsData)
                end
                if rpcId == 38 then
                    local Type = bsWrap:Read8(bsData)
                    local floatX = bsWrap:ReadFloat(bsData)
                    local floatY = bsWrap:ReadFloat(bsData)
                    local floatZ = bsWrap:ReadFloat(bsData)
                    SHAcKvar.CheckpointSave = CVector(floatX, floatY, floatZ)
                    bsWrap:Reset(bsData)
                end
                if rpcId == 107 then
                    local floatX = bsWrap:ReadFloat(bsData)
                    local floatY = bsWrap:ReadFloat(bsData)
                    local floatZ = bsWrap:ReadFloat(bsData)
                    SHAcKvar.CheckpointSave = CVector(floatX, floatY, floatZ)
                    bsWrap:Reset(bsData)
                end
                if rpcId == 26 then
                    local wPlayerID = bsWrap:Read16(bsData)
                    local wVehicleID = bsWrap:Read16(bsData)
                    local bIsPassenger = bsWrap:Read8(bsData)
                    local myICdata = vMy.ICData
                    if Vehicle.AntiCarJack.v then
                        if myICdata.VehicleID == wVehicleID and bIsPassenger == 0 then
                            local vEnPos = vMy.Pos
                            if Players:isPlayerStreamed(wPlayerID) then
                                set.DesyncPlayer(wPlayerID, vEnPos.fX, vEnPos.fY, vEnPos.fZ+2)
                            end
                            return false
                        end
                    end
                    if Vehicle.DriveNoLicense.v and Vehicle.DriveNoLicenseFakeData.v then
                        if ICdata.wVehicleID == wVehicleID then
                            return false
                        end
                    end
                end
                if rpcId == 15 then
                    return false
                end
                if Vehicle.DriveNoLicense.v then
                    if rpcId == 165 or rpcId == 163 then
                        return false
                    end
                    if rpcId == 71 or rpcId == 93 and v.enteringvehicle == 1 and Vehicle.DriveNoLicenseFakeData.v then
                        return false
                    end
                    if Vehicle.DriveNoLicenseFakeData.v and v.enteringvehicle == 1 then
                        if rpcId == 15 or rpcId == 86 or rpcId == 87 then
                            return false
                        end
                    end
                    if rpcId == 70 then
                        local wVehicleID = bsWrap:Read16(bsData)
                    end
                end
                if rpcId == 153 and Movement.ForceSkin.v then
                    return false
                end
            --No Apply Animations
                if Movement.NoAnimations.v then
                    if rpcId == 86 or rpcId == 87 then
                        return false
                    end
                end
            --NOPS
                if NOPs.Receive[rpcId] ~= nil then
                    if NOPs.Receive[rpcId].v then
                        local message = ImBuffer("NOPs OnReceiveRPC - ".. RPC[rpcId] .." ID: (".. rpcId ..")",155) send.Message(message, 0xFF000000)
                        PrintConsole("NOPs OnReceiveRPC - ".. RPC[rpcId] .." ID: (".. rpcId ..")")
                        return false
                    end
                end
                end
                return true
            end

        local function OnSendPacket(packetId, bsData)
                if Panic.EveryThingExceptVisuals.v == false and unload == false then
                    --bsWrap:ResetReadPointer(bsData)
                if packetId == 32 then
                    v.WaitForPickLag = 1
                else
                    if v.WaitForPickLag ~= 0 then v.WaitForPickLag = 0 end
                end
                if SHAcKvar.DesyncTimer > 1 and v.shooting == 0 and SHAcKvar.DesyncDelay > 1 then
                    return false
                end
                if packetId == 205 then --ID_STATS_UPDATE 
                    if Extra.Mobile.v then
                        return false
                    end
                end
                if packetId == 210 then
                    Vehicle.SaveTrailer = bsWrap:Read16(bsData) 

                    local ic = vMy.ICData
                    Vehicle.TrailerToVehicle = ic.VehicleID
                end
                if packetId == 204 then --WeaponUpdate
                    targetId = bsWrap:Read16(bsData) 
                    targetActorId = bsWrap:Read16(bsData) 
                    local slotupdate = bsWrap:Read8(bsData) 
                    local weaponupdate = bsWrap:Read8(bsData) 
                    local ammoupdate = bsWrap:Read16(bsData)
                    bsWrap:Reset(bsData)
                    if KeyToggle.Silent.v == 1 and v.SilentPlayerID ~= -1 and Players:isPlayerStreamed(v.SilentPlayerID) then
                        bsWrap:Write16(bsData, v.SilentPlayerID) 
                        bsWrap:Write16(bsData, targetActorId) 
                        bsWrap:Write8(bsData, slotupdate) 
                        bsWrap:Write8(bsData, weaponupdate) 
                        bsWrap:Write16(bsData, ammoupdate)
                        SendPacket(204, bsData)
                        return false
                    end
                    if Damager.Enable.v and KeyToggle.Damager.v == 1 and v.DamagerPlayerID ~= -1 then
                        targetId = v.DamagerPlayerID
                    end
                end
                if packetId == 207 then --OnfootSync
                    if SHAcKvar.Teleporting[1] == 1 or SHAcKvar.Teleporting[1] == 2 then
                        return false
                    end
                    --Read
                        local lrKey = bsWrap:Read16(bsData) 
                        local udKey = bsWrap:Read16(bsData) 
                        local keys = bsWrap:Read16(bsData)
                        if Extra.fuckKeyStrokes.Enable.v then
                                if Extra.fuckKeyStrokes.Mode.v == 0 or Extra.fuckKeyStrokes.Mode.v == 1 then
                                    local var
                                    if Extra.fuckKeyStrokes.Mode.v == 0 then
                                        var = "> 0"
                                    else
                                        var = "== 0"
                                    end
                                    
                                    if bit.band(keys, 0x0004) == (var == "> 0" and 4 or 0) and Extra.fuckKeyStrokes.Key.fire.v then SampKeys.fire = 4 else SampKeys.fire = 0 end
                                    if bit.band(keys, 0x0080) == (var == "> 0" and 128 or 0) and Extra.fuckKeyStrokes.Key.aim.v then SampKeys.aim = 128 else SampKeys.aim = 0 end
                                    if bit.band(keys, 0x0002) == (var == "> 0" and 2 or 0) and Extra.fuckKeyStrokes.Key.horn_crouch.v then SampKeys.horn_crouch = 2 else SampKeys.horn_crouch = 0 end
                                    if bit.band(keys, 0x0010) == (var == "> 0" and 16 or 0) and Extra.fuckKeyStrokes.Key.enterExitCar.v then SampKeys.enterExitCar = 16 else SampKeys.enterExitCar = 0 end
                                    if bit.band(keys, 0x0020) == (var == "> 0" and 32 or 0) and Extra.fuckKeyStrokes.Key.jump.v then SampKeys.decel_jump = 32 else SampKeys.decel_jump = 0 end
                                    if bit.band(keys, 0x0200) == (var == "> 0" and 512 or 0) and Extra.fuckKeyStrokes.Key.landingGear_lookback.v then SampKeys.landingGear_lookback = 512 else SampKeys.landingGear_lookback = 0 end
                                    if bit.band(keys, 0x0400) == (var == "> 0" and 1024 or 0) and Extra.fuckKeyStrokes.Key.walk.v then SampKeys.walk = 1024 else  SampKeys.walk = 0 end
                                    if bit.band(keys, 0x0001) == (var == "> 0" and 1 or 0) and Extra.fuckKeyStrokes.Key.tab.v then SampKeys.tab = 1 else SampKeys.tab = 0 end
                                    if bit.band(keys, 0x0008) == (var == "> 0" and 8 or 0) and Extra.fuckKeyStrokes.Key.sprint.v then SampKeys.sprint = 8 else SampKeys.sprint = 0 end
                                
                                    for k, v in pairs(SampKeys) do
                                        if v ~= 0 then
                                            if Extra.fuckKeyStrokes.Mode.v == 0 then
                                                keys = keys - v
                                            else
                                                keys = keys + v
                                            end
                                        end
                                    end
                                end
                                if Extra.fuckKeyStrokes.Mode.v == 2 then
                                    local CTRL = maths.Chance(50)
                                    local SPACE = maths.Chance(50)
                                    local SHIFT = maths.Chance(50) 
                                    local C = maths.Chance(50)
                                    local F = maths.Chance(50) 
                                    local TAB = maths.Chance(50) 
                                    local ALT = maths.Chance(50) 
                                    local LOOKBehind = maths.Chance(50) 
                                    if CTRL == true then keys = keys + 4 end
                                    if SPACE == true then keys = keys + 8 end
                                    if SHIFT == true then keys = keys + 32 end
                                    if C == true then keys = keys + 2 end
                                    if F == true then keys = keys + 16 end
                                    if TAB == true then keys = keys + 1 end
                                    if ALT == true then keys = keys + 1024 end
                                    if LOOKBehind == true then keys = keys + 512 end
                                end
                        end
                        local X = bsWrap:ReadFloat(bsData)  
                        local Y = bsWrap:ReadFloat(bsData)  
                        local Z = bsWrap:ReadFloat(bsData)  
                        local quat_w = bsWrap:ReadFloat(bsData)
                        local quat_x = bsWrap:ReadFloat(bsData)
                        local quat_y = bsWrap:ReadFloat(bsData)
                        local quat_z = bsWrap:ReadFloat(bsData)
                        local health = bsWrap:Read8(bsData)  
                        local armour = bsWrap:Read8(bsData)  
                        local weapon_id = bsWrap:Read8(bsData)  
                        local special_action = bsWrap:Read8(bsData)  
                        local velocity_x = bsWrap:ReadFloat(bsData)  
                        local velocity_y = bsWrap:ReadFloat(bsData)  
                        local velocity_z = bsWrap:ReadFloat(bsData)  
                        local surfing_offsets_x = bsWrap:ReadFloat(bsData)  
                        local surfing_offsets_y = bsWrap:ReadFloat(bsData)  
                        local surfing_offsets_z = bsWrap:ReadFloat(bsData)  
                        local surfing_vehicle_id = bsWrap:Read16(bsData)  
                        local animation_id = bsWrap:Read16(bsData)  
                        local animation_flags = bsWrap:Read16(bsData)
                        if v.NoFall >= 1 and v.NoFall < 10 then
                            animation_id = 1129
                            if v.NoFall == 1 then
                                v.NoFall = 2
                            end
                        end
                        players.Quats.w = quat_w
                        players.Quats.x = quat_x
                        players.Quats.y = quat_y
                        players.Quats.z = quat_z
                        if animation_id == 1231 or animation_id == 1266 then
                            if SHAcKvar.CJWalk ~= 2 and Movement.bUseCJWalk.v then SHAcKvar.CJWalk = 2 end
                        elseif animation_id == 1224 or animation_id == 1257 then
                            if SHAcKvar.CJWalk ~= 0 then SHAcKvar.CJWalk = 0 end
                        end
                        local datas = vMy.ICData 
                        if vAmI.Driver and datas.VehicleID == 0 then
                            return false
                        end
                    --
                        if Teleport.Enable.v and Teleport.HvH.v and Utils:IsKeyDown(Teleport.HvHKey.v) and Teleport.HvHAntiKick.v or 
                        SHAcKvar.Teleporting[1] == 1 or SHAcKvar.rVankanEWVAR ~= 0 then
                            return false
                        else 
                            if SHAcKvar.CJWalk == 2 and Movement.bUseCJWalk.v == true or Troll.FakePos.Enable.v or Troll.FuckSync.v or Troll.TrollWalk.v or Extra.Mobile.v or Extra.AntiSniper.v or
                            KeyToggle.MacroRun.v == 1 and Movement.MacroRun.Bypass.v or SHAcKvar.Duration ~= 0 and SHAcKvar.Duration < Movement.Slide.SpeedDuration.v+10 and Movement.Slide.SpeedFakeSync.v or 
                            KeyToggle.Damager.v == 1 and v.DamagerPlayerID ~= -1 and Players:isPlayerStreamed( v.DamagerPlayerID) and Damager.OnlyStreamed.v and Damager.TakeDamage.v == false and Damager.SyncOnfootData.v or
                            KeyToggle.Silent.v == 1 and v.SilentPlayerID ~= -1 and Players:isPlayerStreamed(v.SilentPlayerID) or Extra.fuckKeyStrokes.Enable.v then
                                vEnPos = -1
                                if Players:isPlayerStreamed(Players:getNearestPlayer()) then
                                    vEnPos = Players:getPlayerPosition(Players:getNearestPlayer())
                                end
                            
                                local vMyPos = CVector(X, Y, Z)

                                if Troll.FakePos.Enable.v and Troll.FakePos.RandomPos.v and Troll.FakePos.OnFoot.v then
                                    X = X + math.random(-3,3) 
                                    Y = Y + math.random(-3,3) 
                                else
                                    if Troll.FakePos.Enable.v and Troll.FakePos.OnFoot.v then
                                        local FakePosition = CVector(X+Troll.FakePos.X.v, Y+Troll.FakePos.Y.v, Z+0.5)
                                        if Utils:IsLineOfSightClear(vMyPos, FakePosition, true, true ,false, true, false, false, false) == true then
                                            X = X + Troll.FakePos.X.v
                                            Y = Y + Troll.FakePos.Y.v
                                        end
                                    end
                                end
                                if KeyToggle.Damager.v == 1 and v.DamagerPlayerID ~= -1 and Players:isPlayerStreamed( v.DamagerPlayerID) and Damager.OnlyStreamed.v and Damager.TakeDamage.v == false and Damager.SyncOnfootData.v then
                                    local vEnPos 
                                    local vMyPos = Players:getPlayerPosition(vMy.ID)
                                    if v.DamagerCbug == 1 then
                                        keys = 134
                                        special_action = 1
                                    else
                                        keys = 0
                                        special_action = 0
                                    end
                                    if Damager.CurrentWeapon.v then
                                        weapon_id = vMy.Weapon
                                    else
                                        if Damager.Weapon.v == 51 then
                                            weapon_id = math.random(0, 49)
                                        else 
                                            if Damager.Weapon.v == 35 or Damager.Weapon.v == 36 then
                                                keys = 132
                                            end
                                            weapon_id = Damager.Weapon.v
                                        end
                                    end
                                    if Damager.SyncPos.v then
                                        vMyPos = get.PlayerLag( v.DamagerPlayerID)
                                        local offsetX = 1.7
                                        local offsetY = 0
                                        if weapon_id ~= 41 and weapon_id ~= 42 and weapon_id ~= 37 and weapon_id ~= 35 and weapon_id ~= 36 then
                                            lrKey = 65408
                                            offsetX = 0
                                        end
                                        X = vMyPos.fX+offsetX
                                        Y = vMyPos.fY
                                        Z = vMyPos.fZ
                                        keys = 4
                                        local vData = Players:getOnFootData( v.DamagerPlayerID)
                                        velocity_x = vData.Speed.fX*1.3
                                        velocity_y = vData.Speed.fY*1.3
                                        velocity_z = vData.Speed.fZ
                                        vEnPos = Players:getBonePosition( v.DamagerPlayerID, SHAcKvar.damagerBone)
                                    else
                                        if weapon_id == 41 or weapon_id == 42 or weapon_id == 37 or weapon_id == 35 or weapon_id == 36 or vMy.Vehicle == 432 then
                                            vEnPos = get.LagCompensatedPosition(CVector(X, Y, Z), v.DamagerPlayerID, 1.0)
                                        else
                                            vEnPos = Players:getBonePosition( v.DamagerPlayerID, SHAcKvar.damagerBone)
                                        end
                                    end
                                    if Damager.SyncRotation.v then
                                        local qw, qx, qy, qz = set.PlayerFacing(CVector(X, Y, Z), vEnPos)
                                        quat_w = qw
                                        quat_x = 0
                                        quat_y = 0
                                        quat_z = qz
                                    end
                                    local direction = get.Direction(vEnPos, CVector(X, Y, Z))
                                    local aimz = get.AimZ(CVector(X, Y, Z), vEnPos)

                                    AimData.cammode = weaponInfo[weapon_id].cammode
                                    AimData.weaponstate = weaponInfo[weapon_id].weaponstate
                                    AimData.camfrontX = direction.fX
                                    AimData.camfrontY = direction.fY 
                                    AimData.camfrontZ = direction.fZ
                                    AimData.aimZ = aimz
                                    send.AimSync(AimData)
                                else
                                    if KeyToggle.Silent.v == 1 and v.SilentPlayerID ~= -1 and Players:isPlayerStreamed(v.SilentPlayerID) and Silent.SyncRotation.v then
                                        if vMy.OFData.sCurrentAnimationID > 1157 and vMy.OFData.sCurrentAnimationID < 1165 or vMy.OFData.sCurrentAnimationID == 1167 then
                                            local vEnPos
                                            local offsetX = 0
                                            local offsetY = 0
                                            if Troll.FakePos.Enable.v and Troll.FakePos.OnFoot.v then
                                                offsetX = Troll.FakePos.X.v
                                                offsetY = Troll.FakePos.Y.v
                                            end
                                            vMyPos.fX = vMyPos.fX + offsetX
                                            vMyPos.fY = vMyPos.fY + offsetY
                                            if weapon_id == 41 or weapon_id == 42 or weapon_id == 37 or weapon_id == 35 or weapon_id == 36 or vMy.Vehicle == 432 then
                                                vEnPos = get.LagCompensatedPosition(CVector(X, Y, Z), v.SilentPlayerID, 1.0)
                                            else
                                                vEnPos = Players:getBonePosition(v.SilentPlayerID, players.bone[v.SilentPlayerID] )
                                            end
                                            local qw, qx, qy, qz = set.PlayerFacing(vMyPos, vEnPos)
                                            quat_w = qw
                                            quat_x = 0
                                            quat_y = 0
                                            quat_z = qz
                                        end
                                    else
                                        if Troll.FuckSync.v then
                                            quat_w = quat_w + math.random(-180, 180)
                                            quat_x = quat_x + math.random(-5, 5)
                                            quat_y = quat_y + math.random(-5, 5)
                                            quat_z = quat_z + math.random(-180, 180)
                                        end
                                    end
                                end
                                local Chance = maths.Chance(Extra.AntiSniperChance.v)
                                local antiWhiteSkin
                                if Extra.AntiSniperChance.v >= 100 then
                                    antiWhiteSkin = 1
                                else
                                    antiWhiteSkin = 0
                                end
                                if Extra.AntiSniper.v and Extra.AntiSniperTypeMode.v == 0 then
                                    SHAcKvar.AntiSniperCount = SHAcKvar.AntiSniperCount + 1
                                    if SHAcKvar.AntiSniperCount > 20 and antiWhiteSkin == 1 then
                                        SHAcKvar.AntiSniperCount = 0
                                    else
                                        if Chance == true then
                                            special_action = 3
                                        end
                                    end
                                end
                                if KeyToggle.MacroRun.v == 1 and Movement.MacroRun.Bypass.v or SHAcKvar.Duration ~= 0 and SHAcKvar.Duration < Movement.Slide.SpeedDuration.v+10 and Movement.Slide.SpeedFakeSync.v then
                                    local MaxVelocityX
                                    local MaxVelocityY
                                    if velocity_x > 0.23 then
                                        MaxVelocityX = 0.23
                                    else
                                        if velocity_x < -0.23 then
                                            MaxVelocityX = -0.23
                                        end
                                    end
                                    if velocity_y > 0.23 then
                                        MaxVelocityY = 0.23
                                    else
                                        if velocity_y < -0.23 then
                                            MaxVelocityY = -0.23
                                        end
                                    end
                                    if velocity_x > 0.23 or velocity_x < -0.23 then
                                        velocity_x = MaxVelocityX
                                    end
                                    if velocity_y > 0.23 or velocity_y < -0.23 then
                                        velocity_y = MaxVelocityY
                                    end
                                end
                                if Extra.AntiSniper.v and Extra.AntiSniperTypeMode.v == 1 then
                                    surfing_offsets_x = X
                                    surfing_offsets_y = Y
                                    surfing_offsets_z = Z
                                    SHAcKvar.AntiSniperCount = SHAcKvar.AntiSniperCount + 1
                                    local nearestvehicle = maths.getLowerIn(vehicles.dist)
                                    local lowestid = maths.getLowerIn(vehicles.id)
                                    if surfing_vehicle_id == 0 then
                                        if Chance == true and nearestvehicle ~= nil then
                                            if SHAcKvar.AntiSniperCount > 20 and antiWhiteSkin == 1 then
                                                surfing_vehicle_id = 0
                                                SHAcKvar.AntiSniperCount = 0
                                            else
                                                if nearestvehicle ~= 65535 and nearestvehicle ~= nil then
                                                    surfing_vehicle_id = nearestvehicle
                                                else
                                                    if lowestid ~= -1 and lowestid ~= nil and lowestid ~= 65535 then
                                                        surfing_vehicle_id = lowestid
                                                    else
                                                        surfing_vehicle_id = math.random(1,300)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if Extra.Mobile.v then
                                        surfing_vehicle_id = 0
                                    end
                                end
                                --if v.NoFall >= 1 and v.NoFall < 10 then
                                --    animation_id = 1129
                                --    if v.NoFall == 1 then
                                --        v.NoFall = 2
                                --    end
                                --else
                                    if Troll.TrollWalk.v then
                                        local a = math.random(1,3)
                                        if a == 1 then
                                            animation_id = 970
                                            animation_flags = 970
                                        elseif a == 2 then
                                            animation_id = 973
                                            animation_flags = 973
                                        elseif a == 3 then
                                            animation_id = 974
                                            animation_flags = 974
                                        end
                                    else
                                        if Extra.Mobile.v then
                                            animation_id = 0
                                            animation_flags = 0
                                        else
                                            if Movement.bUseCJWalk.v == true then
                                                if animation_id == 1231 then
                                                    animation_id = 1224
                                                elseif animation_id == 1266 then
                                                    animation_id = 1257
                                                end
                                            end
                                        end
                                    end
                                --end
                                bsWrap:Reset(bsData)
                                bsWrap:Write8(bsData, 207) 
                                bsWrap:Write16(bsData, lrKey) 
                                bsWrap:Write16(bsData, udKey)
                                bsWrap:Write16(bsData, keys)
                                bsWrap:WriteFloat(bsData, X)
                                bsWrap:WriteFloat(bsData, Y)
                                bsWrap:WriteFloat(bsData, Z)
                                bsWrap:WriteFloat(bsData, quat_w)  
                                bsWrap:WriteFloat(bsData, quat_x)   
                                bsWrap:WriteFloat(bsData, quat_y)   
                                bsWrap:WriteFloat(bsData, quat_z)  
                                bsWrap:Write8(bsData, health)  
                                bsWrap:Write8(bsData, armour)  
                                bsWrap:Write8(bsData, weapon_id) 
                                bsWrap:Write8(bsData, special_action)
                                bsWrap:WriteFloat(bsData, velocity_x)
                                bsWrap:WriteFloat(bsData, velocity_y)
                                bsWrap:WriteFloat(bsData, velocity_z) 
                                bsWrap:WriteFloat(bsData, surfing_offsets_x)  
                                bsWrap:WriteFloat(bsData, surfing_offsets_y)  
                                bsWrap:WriteFloat(bsData, surfing_offsets_z)  
                                bsWrap:Write16(bsData, surfing_vehicle_id)
                                bsWrap:Write16(bsData, animation_id)  
                                bsWrap:Write16(bsData, animation_flags)
                                SendPacket(207, bsData)
                                bsWrap:Reset(bsData) 
                                return false
                            end
                        end
                end
                if packetId == 200 then --DriverSync
                    if SHAcKvar.Teleporting[1] == 1 or SHAcKvar.rVankanEWVAR ~= 0 then
                        return false
                    end
                    --Read
                        local vehicle_id = bsWrap:Read16(bsData)
                        local lrkey = bsWrap:Read16(bsData) 
                        local udkey = bsWrap:Read16(bsData) 
                        local keys = bsWrap:Read16(bsData) 
                        local quat_w = bsWrap:ReadFloat(bsData) 
                        local quat_x = bsWrap:ReadFloat(bsData) 
                        local quat_y = bsWrap:ReadFloat(bsData) 
                        local quat_z = bsWrap:ReadFloat(bsData) 
                        local X = bsWrap:ReadFloat(bsData) 
                        local Y = bsWrap:ReadFloat(bsData) 
                        local Z = bsWrap:ReadFloat(bsData) 
                        local velocity_x = bsWrap:ReadFloat(bsData) 
                        local velocity_y = bsWrap:ReadFloat(bsData) 
                        local velocity_z = bsWrap:ReadFloat(bsData) 
                        local vehicle_health = bsWrap:ReadFloat(bsData) 
                        local player_health = bsWrap:Read8(bsData) 
                        local player_armour = bsWrap:Read8(bsData) 
                        local additional_key = bsWrap:Read8(bsData) 
                        local weapon_id = bsWrap:Read8(bsData) 
                        local siren_state = bsWrap:Read8(bsData) 
                        local landing_gear_state = bsWrap:Read8(bsData) 
                        local trailer_id = bsWrap:Read8(bsData) 
                        local train_speed = bsWrap:ReadFloat(bsData)
                        bsWrap:Reset(bsData)
                        
                        vehicles.Quats.w = quat_w
                        vehicles.Quats.x = quat_x
                        vehicles.Quats.y = quat_y
                        vehicles.Quats.z = quat_z
                    --
                    local vehicle
                    
                    if Godmode.InvisibleCar == 1 and vMy.Vehicle == 1999 then
                        local speedX = velocity_x/math.random(2,4)
                        local speedY = velocity_y/math.random(2,4)
                        local speedZ = velocity_z/4
                        if speedX ~= 0 or speedY ~= 0 then
                            keys = 8
                        end
                        bsWrap:Write8(bsData, 207) 
                        bsWrap:Write16(bsData, lrkey) 
                        bsWrap:Write16(bsData, udkey) 
                        bsWrap:Write16(bsData, keys)  
                        bsWrap:WriteFloat(bsData, X)  
                        bsWrap:WriteFloat(bsData, Y)  
                        bsWrap:WriteFloat(bsData, Z)  
                        bsWrap:WriteFloat(bsData, vehicles.Quats.w)  
                        bsWrap:WriteFloat(bsData, 0)  
                        bsWrap:WriteFloat(bsData, 0)  
                        bsWrap:WriteFloat(bsData, vehicles.Quats.z)  
                        bsWrap:Write8(bsData, vMy.HP)  
                        bsWrap:Write8(bsData, vMy.Armor)  
                        bsWrap:Write8(bsData, vMy.Weapon)  
                        bsWrap:Write8(bsData, 0)  
                        bsWrap:WriteFloat(bsData, speedX)  
                        bsWrap:WriteFloat(bsData, speedY)  
                        bsWrap:WriteFloat(bsData, speedZ)  
                        bsWrap:WriteFloat(bsData, 0)  
                        bsWrap:WriteFloat(bsData, 0)  
                        bsWrap:WriteFloat(bsData, 0)  
                        bsWrap:Write16(bsData, 0)  
                        if SHAcKvar.CJWalk == 2 then
                            bsWrap:Write16(bsData, 1224)
                        else
                            bsWrap:Write16(bsData, 1257)
                        end
                        bsWrap:Write16(bsData, 32770) 
                        SendPacket(207,bsData)
                        bsWrap:Reset(bsData)
                        return false
                    end
                    if Vehicle.DriveNoLicense.v and Vehicle.DriveNoLicenseFakeData.v then
                        local math = math.random(1,5)
                        if math == 1 then
                            bsWrap:Write8(bsData, 209) 
                            bsWrap:Write16(bsData, vehicle_id) 
                            bsWrap:Write8(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, X) 
                            bsWrap:WriteFloat(bsData, Y) 
                            bsWrap:WriteFloat(bsData, Z) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 999)
                            SendPacket(209,bsData)
                            bsWrap:Reset(bsData)
                            return false
                        end
                    end
                    if Troll.FakePos.Enable.v and Troll.FakePos.InCar.v or Vehicle.LimitVelocity.v or Troll.FuckSync.v or Extra.Mobile.v then
                        --RVanka
                            local vMyPos = vMy.Pos
                            if Troll.FuckSync.v then
                                quat_w = quat_w + math.random(-180, 180)
                                quat_x = quat_x + math.random(-5, 5)
                                quat_y = quat_y + math.random(-5, 5)
                                quat_z = quat_z + math.random(-180, 180)
                            end
                            if Troll.FakePos.Enable and Troll.FakePos.RandomPos.v and Troll.FakePos.InCar.v then
                                X = X + math.random(-7,7)
                                Y = Y + math.random(-7,7)
                            else
                                if Troll.FakePos.Enable and Troll.FakePos.InCar.v then
                                    local FakePosition = CVector(X+Troll.FakePos.X.v, Y+Troll.FakePos.Y.v, Z+0.5)
                                    local MyPos = CVector(X, Y, Z)
                                    if Utils:IsLineOfSightClear(MyPos, FakePosition, true, true ,false, true, false, false, false) == true then
                                        X = X + Troll.FakePos.X.v
                                        Y = Y + Troll.FakePos.Y.v
                                    end
                                end
                            end
                            if Vehicle.LimitVelocity.v then
                                local car = Cars:getCarModel(vehicle_id)
                                local carvelocity = Cars:getCarVelocity(vehicle_id)
                                speedf = math.sqrt(((carvelocity.fX*carvelocity.fX)+(carvelocity.fY*carvelocity.fY))+(carvelocity.fZ*carvelocity.fZ)) * 187.666667;
                                speed = maths.round(speedf);
                                local CVehicle = Utils:readMemory(0xB6F980, 4, false)
                                local Surface = Utils:readMemory(CVehicle+0x41, 1, false)
                                local air
                                if Surface ~= 0 then air = 0 else air = 15 end
                                if Vehicle.SmartLimitMaxVelocity.v then
                                    if speed-air < vehicleInfo[car].velocity then
                                        Vehicle.LimitSaveVelx = velocity_x
                                        Vehicle.LimitSaveVely = velocity_y
                                        Vehicle.LimitSaveVelz = velocity_z
                                        if speed < Vehicle.Velocity.v+10 then
                                            Vehicle.LimitperSaveVelx = velocity_x
                                            Vehicle.LimitperSaveVely = velocity_y
                                            Vehicle.LimitperSaveVelz = velocity_z
                                        else
                                            if Vehicle.LimitVelocityOnKey.v and Utils:IsKeyDown(Vehicle.LimitVelocityKey.v) or Vehicle.LimitVelocityOnKey.v == false then
                                                velocity_x = Vehicle.LimitperSaveVelx
                                                velocity_y = Vehicle.LimitperSaveVely
                                                velocity_z = Vehicle.LimitperSaveVelz
                                            end
                                        end
                                    else
                                        if speed < Vehicle.Velocity.v+10 then
                                            Vehicle.LimitperSaveVelx = velocity_x
                                            Vehicle.LimitperSaveVely = velocity_y
                                            Vehicle.LimitperSaveVelz = velocity_z
                                            
                                            velocity_x = Vehicle.LimitSaveVelx
                                            velocity_y = Vehicle.LimitSaveVely
                                            velocity_z = Vehicle.LimitSaveVelz
                                        else
                                            if Vehicle.LimitVelocityOnKey.v and Utils:IsKeyDown(Vehicle.LimitVelocityKey.v) or Vehicle.LimitVelocityOnKey.v == false then
                                                velocity_x = Vehicle.LimitperSaveVelx
                                                velocity_y = Vehicle.LimitperSaveVely
                                                velocity_z = Vehicle.LimitperSaveVelz
                                            else
                                                velocity_x = Vehicle.LimitSaveVelx
                                                velocity_y = Vehicle.LimitSaveVely
                                                velocity_z = Vehicle.LimitSaveVelz
                                            end
                                        end
                                    end
                                else
                                    if speed < Vehicle.Velocity.v+10 then
                                        Vehicle.LimitperSaveVelx = velocity_x
                                        Vehicle.LimitperSaveVely = velocity_y
                                        Vehicle.LimitperSaveVelz = velocity_z
                                    else
                                        if Vehicle.LimitVelocityOnKey.v and Utils:IsKeyDown(Vehicle.LimitVelocityKey.v) or Vehicle.LimitVelocityOnKey.v == false then
                                            velocity_x = Vehicle.LimitperSaveVelx
                                            velocity_y = Vehicle.LimitperSaveVely
                                            velocity_z = Vehicle.LimitperSaveVelz
                                        end
                                    end
                                end
                            end
                            bsWrap:Write8(bsData, 200) 
                            bsWrap:Write16(bsData, vehicle_id)
                            bsWrap:Write16(bsData, lrkey)
                            bsWrap:Write16(bsData, udkey)
                            bsWrap:Write16(bsData, keys)
                            bsWrap:WriteFloat(bsData, quat_w)  
                            bsWrap:WriteFloat(bsData, quat_x)   
                            bsWrap:WriteFloat(bsData, quat_y)   
                            bsWrap:WriteFloat(bsData, quat_z)   
                            bsWrap:WriteFloat(bsData, X)
                            bsWrap:WriteFloat(bsData, Y)
                            bsWrap:WriteFloat(bsData, Z)
                            bsWrap:WriteFloat(bsData, velocity_x)
                            bsWrap:WriteFloat(bsData, velocity_y)
                            bsWrap:WriteFloat(bsData, velocity_z) 
                            bsWrap:WriteFloat(bsData, vehicle_health)
                            bsWrap:Write8(bsData, player_health)
                            bsWrap:Write8(bsData, player_armour)
                            bsWrap:Write8(bsData, additional_key)
                            bsWrap:Write8(bsData, weapon_id)
                            bsWrap:Write8(bsData, siren_state)
                            bsWrap:Write8(bsData, landing_gear_state)
                            bsWrap:Write8(bsData, trailer_id)
                            if Extra.Mobile.v then
                                bsWrap:WriteFloat(bsData, 0)
                            else
                                bsWrap:WriteFloat(bsData, train_speed)
                            end
                            SendPacket(200, bsData)
                            bsWrap:Reset(bsData) 
                            return false
                    end
                end
                if packetId == 206 then --BulletSync
                    local hittype = bsWrap:Read8(bsData)
                    local hitid = bsWrap:Read16(bsData)
                    local OriginX = bsWrap:ReadFloat(bsData)
                    local OriginY = bsWrap:ReadFloat(bsData)
                    local OriginZ = bsWrap:ReadFloat(bsData)
                    local posX = bsWrap:ReadFloat(bsData)
                    local posY = bsWrap:ReadFloat(bsData)
                    local posZ = bsWrap:ReadFloat(bsData)
                    local offsetX = bsWrap:ReadFloat(bsData)
                    local offsetY = bsWrap:ReadFloat(bsData)
                    local offsetZ = bsWrap:ReadFloat(bsData)
                    local WeaponID = bsWrap:Read8(bsData)
                    if AimAssist.Enable.v and AimAssist.ForceWhoDamaged.v and hitid ~= 65535 then
                        if Players:isPlayerStreamed(hitid) and vMy.Weapon == 24 then
                            if AimAssist.IgnoreCList.v and Players:getPlayerColor(hitid) ~= vMy.Color or AimAssist.IgnoreCList.v == false then
                                if Players:isPlayerInFilter(hitid) == false and Players:isSkinInFilter(hitid) == false then
                                    SHAcKvar.AimAssist = hitid
                                    SHAcKvar.AimAssistDelay = 0
                                end
                            end
                        end
                    end
                end
                if packetId == 203 then --AimSync
                    --Read
                        local cam_mode = bsWrap:Read8(bsData)  
                        local cam_front_vec_x = bsWrap:ReadFloat(bsData)  
                        local cam_front_vec_y = bsWrap:ReadFloat(bsData)  
                        local cam_front_vec_z = bsWrap:ReadFloat(bsData)  
                        local cam_pos_x = bsWrap:ReadFloat(bsData)  
                        local cam_pos_y = bsWrap:ReadFloat(bsData)  
                        local cam_pos_z = bsWrap:ReadFloat(bsData)  
                        local aim_z = bsWrap:ReadFloat(bsData)  
                        local weapon_state = bsWrap:Read8(bsData)  
                        local cam_zoom = bsWrap:Read8(bsData)  
                        local aspect_ratio = bsWrap:Read8(bsData) 

                        IC = vMy.ICData
                        if Godmode.InvisibleCar == 1 and vMy.Vehicle == 1999 then
                            bsWrap:Reset(bsData) 
                            bsWrap:Write8(bsData, 203)  
                            bsWrap:Write8(bsData, 4)  
                            bsWrap:WriteFloat(bsData, cam_front_vec_x)  
                            bsWrap:WriteFloat(bsData, cam_front_vec_y)  
                            bsWrap:WriteFloat(bsData, cam_front_vec_z) 
                            bsWrap:WriteFloat(bsData, cam_pos_x)  
                            bsWrap:WriteFloat(bsData, cam_pos_y)  
                            bsWrap:WriteFloat(bsData, cam_pos_z)  
                            bsWrap:WriteFloat(bsData, aim_z) 
                            bsWrap:Write8(bsData, weapon_state)  
                            bsWrap:Write8(bsData, cam_zoom)  
                            bsWrap:Write8(bsData, aspect_ratio)
                            SendPacket(203, bsData)
                            bsWrap:Reset(bsData) 
                            return false
                        else
                        --Silent
                            if KeyToggle.Silent.v == 1 then
                                
                                get.SilentConfig(vMy.Weapon, vMy.VehicleModel)
                                get.NearestBoneFrom(SilentCrosshair)
                                get.TargetSilent()
                                if Players:isPlayerStreamed(v.SilentPlayerID) then
                                    local weapon = vMy.Weapon
                                    local offsetX = 0
                                    local offsetY = 0
                                    local offsetZ = 0
                                    local nearestBone = players.bone[v.SilentPlayerID] 
                                    local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                                    local vMyBone = Players:getBonePosition(Players:getLocalID(), 25)
                                    local vEnPos = Players:getPlayerPosition(v.SilentPlayerID)
                                    local dist = Utils:Get3Ddist(vMyPos, vEnPos)
                                    if vMy.VehicleModel == 432 then
                                        vMyBone = Cars:getCarPosition(vMy.Vehicle)
                                        weapon = 21
                                        offsetZ = 0.9 * (dist * 0.1337)
                                    end
                                    if Troll.FakePos.Enable.v and Troll.FakePos.OnFoot.v then
                                        offsetX = Troll.FakePos.X.v
                                        offsetY = Troll.FakePos.Y.v
                                    end
                                    vMyPos.fX = vMyPos.fX + offsetX
                                    vMyPos.fY = vMyPos.fY + offsetY
                                    vMyPos.fZ = vMyPos.fZ + offsetZ
                                    vMyBone.fX = vMyBone.fX + offsetX
                                    vMyBone.fY = vMyBone.fY + offsetY
                                    vMyBone.fZ = vMyBone.fZ + offsetZ
                                    if vMy.VehicleModel == 432 then
                                        weapon = 21
                                        offsetZ = 9
                                    end
                                    local expectedPosition
                                    if weapon == 41 or weapon == 42 or weapon == 37 or weapon == 35 or weapon == 36 then
                                        expectedPosition = get.LagCompensatedPosition(vMyPos, v.SilentPlayerID, 1.0)
                                    elseif vMy.VehicleModel == 432 then
                                        expectedPosition = get.PlayerLag(v.SilentPlayerID)
                                        expectedPosition.fZ = expectedPosition.fZ - offsetZ
                                    else
                                        expectedPosition = Players:getBonePosition(v.SilentPlayerID, players.bone[v.SilentPlayerID])
                                    end
                                    local myAimData = get.AimData()
                                    local direction = get.Direction(expectedPosition, vMyBone)
                                    local aimz = get.AimZ(vMyBone, expectedPosition)
                                    AimData.cammode = weaponInfo[weapon].cammode
                                    AimData.weaponstate = weaponInfo[weapon].weaponstate
                                    AimData.camfrontX = direction.fX
                                    AimData.camfrontY = direction.fY 
                                    AimData.camfrontZ = direction.fZ
                                    AimData.camposX = vMyBone.fX
                                    AimData.camposY = vMyBone.fY
                                    AimData.camposZ = vMyBone.fZ
                                    if Silent.SyncAimZ.v then
                                        AimData.aimZ = aimz
                                    else
                                        AimData.aimZ = aim_z
                                    end
                                    send.AimSync(AimData)
                                    return false
                                end
                            end
                        end
                    if SHAcKvar.Teleporting[1] == 1 then
                        return false
                    end
                end  
                if packetId == 211 then --PassengerSync
                    SHAcKvar.DamagerVehicleID = bsWrap:Read16(bsData) 
                    local drive_by = bsWrap:Read8(bsData) 
                    --local seat_id = bsWrap:Read8(bsData) 
                    SHAcKvar.DamagerToggleH = bsWrap:Read8(bsData) 
                    --local aditionalKey = bsWrap:Read8(bsData) 
                    --local weapon_id = bsWrap:Read8(bsData) 
                    local health = bsWrap:Read8(bsData) 
                    local armour = bsWrap:Read8(bsData) 
                    local lrkey = bsWrap:Read16(bsData) 
                    local udkey = bsWrap:Read16(bsData) 
                    local keys = bsWrap:Read16(bsData) 
                    local X = bsWrap:ReadFloat(bsData) 
                    local Y = bsWrap:ReadFloat(bsData) 
                    local Z = bsWrap:ReadFloat(bsData)
                    bsWrap:Reset(bsData)
                end
                if packetId == 209 then --UnoccupiedSync
                    local vehicleId = bsWrap:Read16(bsData) 
                    local seatId = bsWrap:Read8(bsData) 
                    local RollX = bsWrap:ReadFloat(bsData) 
                    local RollY = bsWrap:ReadFloat(bsData) 
                    local RollZ = bsWrap:ReadFloat(bsData) 
                    local DirectionX = bsWrap:ReadFloat(bsData) 
                    local DirectionY = bsWrap:ReadFloat(bsData) 
                    local DirectionZ = bsWrap:ReadFloat(bsData) 
                    local PosX = bsWrap:ReadFloat(bsData) 
                    local PosY = bsWrap:ReadFloat(bsData) 
                    local PosZ = bsWrap:ReadFloat(bsData) 
                    local VelocityX = bsWrap:ReadFloat(bsData) 
                    local VelocityY = bsWrap:ReadFloat(bsData) 
                    local VelocityZ = bsWrap:ReadFloat(bsData) 
                    local AngularityX = bsWrap:ReadFloat(bsData) 
                    local AngularityY = bsWrap:ReadFloat(bsData) 
                    local AngularityZ = bsWrap:ReadFloat(bsData) 
                    local Health = bsWrap:ReadFloat(bsData)
                    if vehicleId == Vehicle.SaveTrailer then
                        Vehicle.AutoAttachWaiting = 1
                    end
                    if Troll.VehicleTroll.v and Troll.VehicleTrollType.v == 0 then
                        local x = math.random(-99,99)
                        local y = math.random(-99,99)
                        local z = maths.randomFloat(0.000001, 0.000002)
                        bsWrap:Reset(bsData)
                        bsWrap:Write8(bsData, 209) 
                        bsWrap:Write16(bsData, vehicleId) 
                        bsWrap:Write8(bsData, seatId) 
                        bsWrap:WriteFloat(bsData, RollX) 
                        bsWrap:WriteFloat(bsData, RollY) 
                        bsWrap:WriteFloat(bsData, RollZ) 
                        bsWrap:WriteFloat(bsData, DirectionX) 
                        bsWrap:WriteFloat(bsData, DirectionY) 
                        bsWrap:WriteFloat(bsData, DirectionZ) 
                        bsWrap:WriteFloat(bsData, PosX)
                        bsWrap:WriteFloat(bsData, PosY)
                        bsWrap:WriteFloat(bsData, PosZ)
                        bsWrap:WriteFloat(bsData, x) 
                        bsWrap:WriteFloat(bsData, y) 
                        bsWrap:WriteFloat(bsData, z) 
                        bsWrap:WriteFloat(bsData, AngularityX) 
                        bsWrap:WriteFloat(bsData, AngularityY) 
                        bsWrap:WriteFloat(bsData, AngularityZ) 
                        bsWrap:WriteFloat(bsData, Health)
                        SendPacket(209, bsData)
                        bsWrap:Reset(bsData)
                        return false
                    end
                end
                end
                return true
            end 
        local function OnSendRPC(rpcId, bsData)
                if Panic.EveryThingExceptVisuals.v == false and unload == false then
                    if rpcId == 131 then
                        local iPickupID = bsWrap:Read32(bsData)
                        Pickups[iPickupID] = nil
                    end
                    if rpcId == 168 then
                        local ObjectTarget = bsWrap:Read16(bsData)
                        local VehicleTarget = bsWrap:Read16(bsData) 
                        local PlayerTarget = bsWrap:Read16(bsData) 
                        local ActorTarget = bsWrap:Read16(bsData)
                    end
                    if rpcId == 26 then
                        if Godmode.InvisibleCar == 1 and vMy.Vehicle == 1999 then
                            return false
                        end
                    end
                --SendSpawn \\ RequestSpawn
                    if rpcId == 52 or rpcId == 129 then
                        SHAcKvar.canSlide = 0
                        Timer.Slide[0] = 0
                    end
                --Crasher
                    -- if rpcId == 26 then
                    --         local wVehicleID = bsWrap:Read16(bsData)
                    --         local bIsPassenger = bsWrap:Read8(bsData)
                    --         local pos = Cars:getCarPosition(wVehicleID)
                    --         bsWrap:Reset(bsData)
                    --         bsWrap:Write8(bsData, 207) 
                    --         bsWrap:Write16(bsData, 128) 
                    --         bsWrap:Write16(bsData, 128) 
                    --         bsWrap:Write16(bsData, 128)  
                    --         bsWrap:WriteFloat(bsData, pos.fX)  
                    --         bsWrap:WriteFloat(bsData, pos.fY)  
                    --         bsWrap:WriteFloat(bsData, pos.fZ)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:Write8(bsData, vMy.HP)  
                    --         bsWrap:Write8(bsData, vMy.Armor)  
                    --         bsWrap:Write8(bsData, 0)  
                    --         bsWrap:Write8(bsData, 0)  
                    --         bsWrap:WriteFloat(bsData, 0.4999)  
                    --         bsWrap:WriteFloat(bsData, 0.4999)  
                    --         bsWrap:WriteFloat(bsData, 0.4999)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:WriteFloat(bsData, 0)  
                    --         bsWrap:Write16(bsData, 0)  
                    --         bsWrap:Write16(bsData, 0)  
                    --         bsWrap:Write16(bsData, 0) 
                    --         SendPacket(207, bsData)
                    --         bsWrap:Reset(bsData)
                    --         bsWrap:Write8(bsData, 209) 
                    --         bsWrap:Write16(bsData, wVehicleID) 
                    --         bsWrap:Write8(bsData, 1) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, pos.fX) 
                    --         bsWrap:WriteFloat(bsData, pos.fY) 
                    --         bsWrap:WriteFloat(bsData, pos.fZ-0.5) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, 0) 
                    --         bsWrap:WriteFloat(bsData, Cars:getCarHP(wVehicleID))
                    --         SendPacket(209, bsData)
                    --         bsWrap:Reset(bsData) 
                    --     end
                --GiveTakeDamage
                    if rpcId == 115 then
                        local bool = bsWrap:ReadBool(bsData)
                        local playerID = bsWrap:Read16(bsData)
                        local Amount = bsWrap:ReadFloat(bsData)
                        local WeaponID = bsWrap:Read32(bsData)
                        local bone = bsWrap:Read32(bsData)
                    
                        if bool == true then
                            if Extra.RequestSpawn.v then
                                if Extra.RequestSpawnHP.v < 100 and armour == 0 and health < Extra.RequestSpawnHP.v or
                                Extra.RequestSpawnHP.v >= 100 and armour < Extra.RequestSpawnArmour.v then
                                    local bsData = BitStream()
                                    SendRPC(129, bsData)
                                    SendRPC(52, bsData)
                                    SHAcKvar.SavePosForSpawn = CVector(data.Pos.fX, data.Pos.fY, data.Pos.fZ)
                                    SHAcKvar.RequestingSpawn = 1
                                    return false
                                else
                                    SHAcKvar.RequestingSpawn = 0
                                end
                            else
                                SHAcKvar.RequestingSpawn = 0
                            end
                        else
                            SHAcKvar.RequestingSpawn = 0
                            if KeyToggle.DamageChanger.v == 1 then
                                local DMGAmount = Amount
                                if WeaponID >= 22 and WeaponID <= 24 and DamageChanger.Pistols.Enable.v then 
                                    DMGAmount = DamageChanger.Pistols.DMG.v
                                elseif WeaponID >= 25 and WeaponID <= 27 and DamageChanger.Shotguns.Enable.v  then 
                                    DMGAmount = DamageChanger.Shotguns.DMG.v
                                elseif WeaponID >= 28 and WeaponID <= 29 and DamageChanger.SMGs.Enable.v or WeaponID == 32 and DamageChanger.SMGs.Enable.v then 
                                    DMGAmount = DamageChanger.SMGs.DMG.v
                                elseif WeaponID >= 30 and WeaponID <= 31 and DamageChanger.Rifles.Enable.v then 
                                    DMGAmount = DamageChanger.Rifles.DMG.v
                                elseif WeaponID >= 33 and WeaponID <= 34 and DamageChanger.Snipers.Enable.v then 
                                    DMGAmount = DamageChanger.Snipers.DMG.v
                                elseif WeaponID >= 35 and WeaponID <= 38 and DamageChanger.Rifles.Enable.v then 
                                    DMGAmount = DamageChanger.Rifles.DMG.v
                                end

                                bsWrap:Reset(bsData)
                                bsWrap:WriteBool(bsData, bool)
                                bsWrap:Write16(bsData, playerID)
                                bsWrap:WriteFloat(bsData, DMGAmount)
                                bsWrap:Write32(bsData, WeaponID)
                                bsWrap:Write32(bsData, bone)
                                SendRPC(115, bsData)
                                return false
                            end
                        end
                        if Movement.AntiStun.Enable.v and playerID == vMy.ID and Movement.AntiStun.On == 1 then
                            bsWrap:Reset(bsData)
                            return false
                        end
                    else
                        SHAcKvar.RequestingSpawn = 0
                    end
                --PopTirefix 
                    if rpcId == 106 then
                        if Extra.Mobile.v then
                            return false
                        end
                    end
                --FastExit
                    if rpcId == 154 then
                        local vehicle = bsWrap:Read16(bsData)
                        if Vehicle.FastExit.v then
                            if vAmI.Driver or vAmI.Passenger then
                                bsWrap:Reset(bsData)
                                local vModel = Cars:getCarModel(vehicle)
                                if vehicleInfo[vModel].type ~= VehicleType.Bike and vehicleInfo[vModel].type ~= VehicleType.Bicycle and vehicleInfo[vModel].type ~= VehicleType.RC then
                                    local vMyPelvis = Players:getBonePosition(vMy.ID, 1)
                                    local vMyRClav = Players:getBonePosition(vMy.ID, 51)
                                    local vMyLClav = Players:getBonePosition(vMy.ID, 41)
                                    local expectedPos
                                    if vAmI.Driver then
                                        expectedPos = (vMyPelvis - vMyRClav) * 12
                                    else
                                        expectedPos = (vMyPelvis - vMyLClav) * 12
                                    end
                                    expectedPos = expectedPos + vMyPelvis
                                    set.PlayerPos(expectedPos.fX, expectedPos.fY, expectedPos.fZ)
                                else
                                    if vehicleInfo[vModel].type == VehicleType.RC then
                                        local vMyPos = Cars:getCarPosition(vehicle)
                                        set.PlayerPos(vMyPos.fX, vMyPos.fY, vMyPos.fZ)
                                    else
                                        set.PlayerPos(vMy.Pos.fX, vMy.Pos.fY, vMy.Pos.fZ+1)
                                    end
                                end
                            end
                        end
                    end
                --Mobile
                    if rpcId == 25 then
                        if Extra.Mobile.v then
                            local iVersion = bsWrap:Read32(bsData) 
                            local byteMod = bsWrap:Read8(bsData)
                            local byteNicknameLen = bsWrap:Read8(bsData)
                            local buffer1 = ImBuffer(byteNicknameLen)
                            bsWrap:ReadBuf(bsData,buffer1,byteNicknameLen)
                            local uiClientChallengeResponse = bsWrap:Read32(bsData)
                            local byteAuthKeyLen = bsWrap:Read8(bsData)
                            local buffer2 = ImBuffer(byteAuthKeyLen)
                            bsWrap:ReadBuf(bsData,buffer2,byteAuthKeyLen)
                            local iClientVerLen = bsWrap:Read8(bsData)
                            local buffer3 = ImBuffer(iClientVerLen)
                            bsWrap:ReadBuf(bsData,buffer3,iClientVerLen)
                            local unknown = bsWrap:Read32(bsData)
                            bsWrap:Reset(bsData)
                            bsWrap:Write32(bsData, iVersion)
                            bsWrap:Write8(bsData, byteMod)
                            bsWrap:Write8(bsData, byteNicknameLen)
                            bsWrap:WriteBuf(bsData, buffer1, byteNicknameLen)
                            bsWrap:Write32(bsData, uiClientChallengeResponse)
                            local bufWriter = ImBuffer("39FB2DEEDB49ACFB8D4EECE6953D2507988CCCF4410")
                            bsWrap:Write8(bsData, bufWriter.capacity)
                            bsWrap:WriteBuf(bsData, bufWriter, bufWriter.capacity)
                            local bufWrite = ImBuffer("mobile")
                            bsWrap:Write8(bsData, bufWrite.capacity)
                            bsWrap:WriteBuf(bsData, bufWrite, bufWrite.capacity)
                            bsWrap:Write32(bsData, 0)
                        end
                    end
                    if rpcId == 103 then
                        local type8 = bsWrap:Read8(bsData)
                        local arg = bsWrap:Read32(bsData)
                        local response = bsWrap:Read8(bsData)
                        if type8 == 72 then
                            if Extra.Mobile.v then
                                return false
                            end
                        end
                    end
                --Filters
                    if rpcId == 23 then
                        local PlayerID = bsWrap:Read16(bsData)
                        local Source = bsWrap:Read8(bsData)
                        if Filters.Enable.v then
                            if v.filteringid ~= PlayerID then v.filteringid = PlayerID end
                            if v.filtertimer ~= 0 then v.filtertimer = 0 end
                        end
                    end
                --Checkpoint
                    if rpcId == 119 then
                        local floatX = bsWrap:ReadFloat(bsData)
                        local floatY = bsWrap:ReadFloat(bsData)
                        local floatZ = bsWrap:ReadFloat(bsData)
                        local zground = Utils:FindGroundZForCoord(floatX, floatY)
                        SHAcKvar.CheckpointSave = CVector(floatX, floatY, zground)
                        if Teleport.Enable.v and Teleport.toCheckpoint.v then
                            return false
                        else
                            return true
                        end
                    end
                --DriveNoLicense
                    if rpcId == 26 then
                        local wVehicleID = bsWrap:Read16(bsData)
                        if Vehicle.DriveNoLicense.v and Vehicle.DriveNoLicenseFakeData.v then
                            local bIsPassenger = bsWrap:Read8(bsData)
                            local pos = vMy.Pos
                            bsWrap:Reset(bsData)

                            bsWrap:Write16(bsData, wVehicleID)
                            bsWrap:Write8(bsData, 1)
                            SendRPC(26,bsData)
                            bsWrap:Reset(bsData)
                            bsWrap:Write8(bsData, 209) 
                            bsWrap:Write16(bsData, wVehicleID) 
                            bsWrap:Write8(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, pos.fX) 
                            bsWrap:WriteFloat(bsData, pos.fY) 
                            bsWrap:WriteFloat(bsData, pos.fZ) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 0) 
                            bsWrap:WriteFloat(bsData, 999)
                            SendPacket(209,bsData)
                            return false
                        end
                    else
                        v.enteringvehicle = 0
                    end
                --CMDS
                    if (rpcId == 50 ) then
                        local commandlength = bsWrap:Read32(bsData)
                        local buf = ImBuffer(commandlength)
                        bsWrap:ReadBuf(bsData,buf,commandlength)
                        local splitted = get.Split(string.lower(buf.v), " ")
                    --CreateCar
                        if Commands.CreateVeh.v then
                            if Commands.CreateVehNormal.v == splitted[1] or Commands.CreateVehInvisible.v == splitted[1] then
                                local model, color1, color2
                                if splitted[2] == tostring(tonumber(splitted[2])) then
                                    model = tonumber(splitted[2])
                                else
                                    for i, v in pairs(vehicleInfo) do
                                        if read.containsSubstringIgnoreCase(vehicleInfo[i].name, splitted[2]) and not read.containsSubstringIgnoreCase(vehicleInfo[i].name, "weapon") then
                                            model = vehicleInfo[i].id
                                            break
                                        end
                                    end
                                end
                                if splitted[3] ~= nil then
                                    color1 = tonumber(splitted[3])
                                else
                                    color1 = math.random(0, 255)
                                end
                                if splitted[4] ~= nil then
                                    color2 = tonumber(splitted[4])
                                else
                                    color2 = math.random(0, 255)
                                end
                                if model == nil then
                                    return false
                                end
                                local vehicleId
                                if splitted[1] == Commands.CreateVehInvisible.v then
                                    vehicleId = 1999
                                else
                                    local ICData = vMy.ICData
                                    if not vAmI.Driver and not vAmI.Passenger then
                                        vehicleId = maths.getLowerIn(vehicles.dist)
                                    else
                                        if Godmode.InvisibleCar == 1 and vMy.Vehicle == 1999 then
                                            vehicleId = maths.getLowerIn(vehicles.dist)
                                        else
                                            vehicleId = vMy.Vehicle
                                        end
                                    end
                                end
                                if vehicleId ~= nil then
                                    CreateVehicle(vehicleId, model, vMy.Pos.fX+2, vMy.Pos.fY+2, vMy.Pos.fZ+0.7, color1, color2)
                                end
                                return false
                            end
                        end
                    --AddFilter
                        if Commands.Filters.v and splitted[1] == Commands.FiltersChosen.v then
                            local id = tonumber(splitted[2])
                            if Players:isPlayerOnServer(id) then
                                if id ~= nil then
                                    if Players:isPlayerInFilter(id) == false then
                                        SHAkMenu.Open = 1
                                        v.filterIdtoSHAk = id
                                        Timer.Configs[2] = 0
                                        Utils:AddFilterName(Players:getPlayerName(id))
                                    end
                                end
                            end
                            bsWrap:Reset(bsData)
                            return false
                        end
                    --SetSkin
                        if Commands.SetSkin.v and splitted[1] == Commands.SetSkinChosen.v then
                            local id = tonumber(splitted[2])
                            if id == nil then
                                id = math.random(0, 311)
                            end
                                if Movement.ForceSkin.v == true then
                                    Movement.ChosenSkin.v = id
                                end
                                bsWrap:Reset(bsData)
                                bsWrap:Write32(bsData, vMy.ID)
                                bsWrap:Write32(bsData, id) 
                                EmulRPC(153,bsData)
                                bsWrap:Reset(bsData)
                                EmulRPC(87,bsData)
                            bsWrap:Reset(bsData)
                            return false
                        end
                    --GiveWeapon
                        if Commands.GiveWeapon.v and splitted[1] == Commands.GiveWeaponChosen.v then
                            local weaponid
                            if splitted[2] == tostring(tonumber(splitted[2])) then
                                weaponid = tonumber(splitted[2])
                            else
                                for i, v in pairs(weaponInfo) do
                                    if read.containsSubstringIgnoreCase(weaponInfo[i].name, splitted[2]) and not read.containsSubstringIgnoreCase(weaponInfo[i].name, "vehicle") then
                                        weaponid = weaponInfo[i].id
                                        break
                                    end
                                end
                            end
                            local amount = tonumber(splitted[3])
                            if weaponid == 0 then
                                weaponid = 0
                            end
                            if amount == nil then
                                amount = 500
                            end
                            if weaponid ~= nil then
                                bsWrap:Reset(bsData)
                                if weaponid == 0 then
                                    --bsWrap:Write8(bsData, vMy.Weapon)
                                   -- bsWrap:Write16(bsData, 0)
                                    --EmulRPC(145,bsData) 
                                    set.RemovePlayerWeapon(vMy.Weapon)
                                else
                                    bsWrap:Write32(bsData, weaponid)
                                    bsWrap:Write32(bsData, amount) 
                                    EmulRPC(22,bsData) 
                                end
                                bsWrap:Reset(bsData)
                            end
                            return false
                        end
                    --SpecialAction
                        if Commands.SetSpecialAction.v and splitted[1] == Commands.SetSpecialActionChosen.v then 
                            local id = tonumber(splitted[2])
                            if id ~= nil then
                                bsWrap:Reset(bsData)
                                bsWrap:Write8(bsData, id) 
                                EmulRPC(88,bsData)
                                bsWrap:Reset(bsData)
                            end
                            return false
                        end
                    end
                --NOPS
                    if NOPs.Send[rpcId] ~= nil then
                        if NOPs.Send[rpcId].v then
                            local message = ImBuffer("NOPs OnSendRPC - ".. RPC[rpcId] .." ID: (".. rpcId ..")",155) send.Message(message, 0xFF000000)
                            PrintConsole("NOPs OnSendRPC - ".. RPC[rpcId] .." ID: (".. rpcId ..")")
                            return false
                        end
                    end
                    end
                return true
            end
--
--! Syncs
    local function BulletSync(data)
        if Panic.EveryThingExceptVisuals.v == false and unload == false then
    --Slide
        if Movement.Slide.PerWeap.v then
            Timer.GunC = -1
        end
        if Timer.GunC ~= data.WeaponID then
            Timer.GunC = data.WeaponID
        end
    --Silent
        if KeyToggle.Silent.v == 1 and Utils:IsKeyDown(2) then 
                --Crosshair
                    local distance = Utils:Get3Ddist(CVector(data.Target.fX,data.Target.fY,data.Target.fZ), CVector(data.Origin.fX,data.Origin.fY,data.Origin.fZ))
                    if distance < 300 then
                        local VectorCrosshair = CVector(data.Target.fX, data.Target.fY, data.Target.fZ)
                        vMyScreen = CVector()
                        Utils:GameToScreen(VectorCrosshair, vMyScreen)
                        if vMy.Weapon == 24 then
                            --if data.Target.fX - SilentCrosshair.fX > 150 or data.Target.fY - SilentCrosshair.fX > 150 then
                                v.getCrosshair = 0
                                SilentCrosshair = vMyScreen
                                v.CrosshairTimer = 1
                            --end
                        end
                    end
                    get.NearestBoneFrom(SilentCrosshair)
                    get.TargetSilent()
                    SilentStuff.ShotsCounter = SilentStuff.ShotsCounter + 1
            if SilentStuff.BoneHead == true or SilentStuff.BoneChest == true or SilentStuff.BoneStomach == true or SilentStuff.BoneLeftA == true or 
            SilentStuff.BoneRightA == true or SilentStuff.BoneLeftL == true or SilentStuff.BoneRightL == true then
                if v.SilentPlayerID ~= -1 and data.Type ~= 1 and players.bone[v.SilentPlayerID] ~= nil then
                    local chance
                    if SilentStuff.FirstShots == 0 then
                        chance = maths.Chance(SilentStuff.Chance)
                    else
                        chance = maths.Chance(SilentStuff.Chance2)
                    end
                    if chance == true then
                        local Weapon = vMy.Weapon
                        local hittype
                        local origin = CVector(data.Origin.fX,data.Origin.fY,data.Origin.fZ)
                        local amount = weaponInfo[vMy.Weapon].damage
                        local bone = get.GameBoneFromCheat(players.bone[v.SilentPlayerID] )
                        local vEnBone = Players:getBonePosition(v.SilentPlayerID, players.bone[v.SilentPlayerID])
                        local distance = Utils:Get3Ddist(vMy.Pos, vEnBone)
                        local offset = CVector()
                        local vEnPos = Players:getPlayerPosition(v.SilentPlayerID)
                        if SilentStuff.ChangedDMG == true then
                            amount = SilentStuff.Dmg
                        end
                        if Silent.OnlyGiveTakeDamage.v then
                            hittype = 0
                        else
                            hittype = 1
                        end

                        local vEnDriver = Players:isDriver(v.SilentPlayerID)
                        local vEnPassenger = false
                        if not vEnDriver then
                            vEnPassenger = Players:Driving(v.SilentPlayerID)
                        end

                        if Silent.InVehicle.v and not vEnDriver and not vEnPassenger or Silent.InVehicle.v == false then 
                            local viewcars = false
                            if Silent.Pistols.VisibleCheck.Vehicles.v == true then
                                viewcars = true
                            end
                            if Silent.InVehicle.v and not vEnDriver and not vEnPassenger then 
                                viewcars = true
                            end
                            if Utils:IsLineOfSightClear(origin, vEnPos, SilentStuff.VisibleCheck, viewcars, false, SilentStuff.VisibleObjects, false, false, false) or Silent.WallShot.v then
                                send.CameraTarget(v.SilentPlayerID)
                                for i = 1, SilentStuff.Bullets do
                                    local rand = CVector(maths.randomFloat(SilentStuff.MinSpread, SilentStuff.MaxSpread), maths.randomFloat(SilentStuff.MinSpread, SilentStuff.MaxSpread), maths.randomFloat(SilentStuff.MinSpread, SilentStuff.MaxSpread))
                                    offset = vEnBone - vEnPos + rand
                                    local pos = CVector(vEnPos.fX+offset.fX, vEnPos.fY+offset.fY, vEnPos.fZ+offset.fZ)
                                    if Silent.OnlyGiveTakeDamage.v and Silent.OnlyGiveTakeDamageType.v == 0 then
                                        pos = CVector(data.Target.fX, data.Target.fY, data.Target.fZ)
                                    end
                                --Build BulletData
                                    local myBulletData = get.BulletData()
                                    BulletData.type = hittype
                                    BulletData.hitid = v.SilentPlayerID
                                    BulletData.originX = origin.fX
                                    BulletData.originY = origin.fY
                                    BulletData.originZ = origin.fZ
                                    BulletData.posX = pos.fX
                                    BulletData.posY = pos.fY
                                    BulletData.posZ = pos.fZ
                                    BulletData.offsetX = offset.fX
                                    BulletData.offsetY = offset.fY
                                    BulletData.offsetZ = offset.fZ
                                    BulletData.weapon = vMy.Weapon
                                --send.WeaponUpdate(vMy.Weapon, v.SilentPlayerID)
                                    send.BulletSync(BulletData)
                                    send.GiveTakeDamage(false, v.SilentPlayerID, amount, vMy.Weapon, bone)
                                end
                                return false
                            else
                                v.SilentPlayerID = -1
                                return true
                            end
                        end
                    end
                end
            end
        end
        end
        return true
    end
--
--! Mainloop
    local function Mainloop()
        if unload then
            collectgarbage("collect")
            return false
        end
        calculateDeltaTime()
        if vehicleInfo[400] == nil then
            get.vehicleInfoFix()
        end
    --VecCrosshair
        if vMy.Weapon ~= 34 and vMy.Weapon ~= 35 and vMy.Weapon ~= 36 and vMy.Vehicle ~= 432 then
            vecCrosshair.fX = Utils:getResolutionX() * 0.5299999714
            vecCrosshair.fY = Utils:getResolutionY() * 0.4
        else
            vecCrosshair.fX = Utils:getResolutionX() * 0.5
            vecCrosshair.fY = Utils:getResolutionY() * 0.5
        end
        if SilentCrosshair == nil then
            SilentCrosshair = vecCrosshair
        end
        
    --Timers Variables
        if(getMyVars.update(deltaTime)) then
            get.AllMyVariables()
        end
        if(getNearests.update(deltaTime)) then
            get.NearestPlayersFromScreen()
            get.NearestVehiclesFromScreen()
            get.NearestObjectsFromScreen()
        end
        if(getSilentTarget.update(deltaTime)) then
            get.NearestBoneFrom(SilentCrosshair)
            get.TargetSilent()
        end
        if(getWeaponsTimer.update(deltaTime)) then
            read.Memories()
            get.PlayerWeapons()
            for slot, weapons in pairs(Extra.AutoDeleteWeapon) do
                for weapon, value in pairs(weapons) do
                    if value.v then
                        local weaponName = weapon:lower()
                        for _, weaponData in pairs(weaponInfo) do
                            if read.containsSubstringIgnoreCase(weaponData.name, weaponName) then
                                set.RemovePlayerWeapon(weaponData.id)
                                break
                            end
                        end
                    end
                end
            end
        end
        if(CollectGarbage.update(deltaTime)) then
            collectgarbage("collect")
            if SHAkMenu.RefreshHZ.v then
                local Hertz = Utils:readMemory(0xC9C070, 1, false)
                if Hertz ~= 0 then
                    Utils:writeMemory(0xC9C070, 0, 1, false)
                end
            end
            SHAcKvar.damagerhitMyPos = 0
            SHAcKvar.damagerhitEnPos = 0 
        end
        if(Visuals.update(deltaTime)) then
            Timer.Visuals = Timer.Visuals + 1
            if Timer.Visuals > 100 then
                SHAcKvar.Menu = 0
                Timer.Visuals = 0
            end
            local startInterval, endInterval
            local color1, color2, corInterpolada1, corInterpolada2, alpha, shackledBuffer
            for _, interval in ipairs(v.IndicatorIntervals) do

                startInterval = interval[1]
                endInterval = interval[2]

                if Timer.Visuals > startInterval and Timer.Visuals < endInterval then

                    alpha = _ / 33

                    if alpha <= 0.25 then
                        color1 = color(0, 0, 0, 255)
                        color2 = color(255, 255, 255, 0)
                    elseif alpha < 0.4 then
                        color1 = color(0, 0, 0, 255)
                        color2 = color(255, 255, 255, 255)
                    elseif alpha < 0.6 then
                        color1 = color(0, 0, 0, 255)
                        color2 = color(255, 255, 255, 200)
                    else
                        color1 = color(0, 0, 0, 1)
                        color2 = color(255, 255, 255, 255)
                    end

                    corInterpolada1 = lerpColor(color1, color2, alpha)
                    corInterpolada2 = lerpColor(color2, color1, alpha)
                    v.colorShackled = corInterpolada1
                    v.colorBorder1 = corInterpolada2
                    v.colorBorder2 = corInterpolada2

                    shackledBuffer = Shackled[_]
                    if shackledBuffer ~= nil then
                        v.BuffShackled = shackledBuffer.v
                    end
                    break
                end
            end
        end
        if(Timerss.update(deltaTime)) then
            if v.getCrosshair == 1 then
                SilentCrosshair = vecCrosshair
                v.CrosshairTimer = 0
            end
            if v.CrosshairTimer > 0 then
                v.CrosshairTimer = v.CrosshairTimer + 1
                if v.CrosshairTimer > 25 then
                    v.getCrosshair = 1
                end
            end
            Timer.second[0] = Timer.second[0] + 1
                if Timer.second[0] == 35 or Timer.second[0] == 70 or Timer.second[0] == 100 then
                    if v.HideDraws[0] == nil then
                        v.HideDraws[0] = 0
                    end
                    if v.ShowDraws[0] ~= nil and v.ShowDraws[0] ~= 0 then
                        v.HideDraws[0] = v.HideDraws[0] + 1
                        if v.HideDraws[0] > 5 then
                            set.HideTextDraw(v.ShowDraws[0])
                            set.HideTextDraw(v.ShowDraws[0]+1)
                            v.ShowDraws[0] = 0
                        end
                    end
                    if v.HideDraws[1] == nil then
                        v.HideDraws[1] = 0
                    end
                    if v.ShowDraws[1] ~= nil and v.ShowDraws[1] ~= 0 then
                        v.HideDraws[1] = v.HideDraws[1] + 1
                        if v.HideDraws[1] > 5 then
                            set.HideTextDraw(v.ShowDraws[1])
                            v.ShowDraws[1] = 0
                        end
                    end
                    if Timer.second[0] == 100 then
                        if SHAcKvar.canSlide == 0 and v.Hww2 ~= 0 then
                            v.Hww2 = 0
                        end
                        Timer.second[0] = 0
                    end
                end
            if Panic.Visuals.v == false then    
                if Timer.ChangeColor1 == 1 then
                    Timer.ChangeColor1 = Timer.Visuals
                end
            end
            if SHAcKvar.DesyncTimer > 0 then
                if SHAcKvar.DesyncTimer > Movement.FakeLagPeek.Time.v then
                    v.shooting = 0
                    SHAcKvar.DesyncDelay = 0
                    SHAcKvar.DesyncTimer = 0
                else
                    SHAcKvar.DesyncTimer = SHAcKvar.DesyncTimer + 1
                end
            end
            if SHAcKvar.DesyncDelay > 0 then
                if SHAcKvar.DesyncDelay > Movement.FakeLagPeek.Delay.v then
                    SHAcKvar.DesyncDelay = 1
                else
                    SHAcKvar.DesyncDelay = SHAcKvar.DesyncDelay + 1
                end
            end
        end
        if SHAcKvar.Teleporting[1] == 1 or SHAcKvar.Teleporting[1] == 2 then
            if  SHAcKvar.Delayed[1] >= Teleport.PersonalDelay.v then
                v.Bypass = 1
                local elapsedTime = (os.clock() - Timer.Teleport) * 1000 
                if elapsedTime > (Teleport.ACDelay.v) then
                    v.Bypass = 0;
                    v.ACBypass = 0;
                    SHAcKvar.Delayed[1] = 0
                end
            else
                Timer.Teleport = os.clock()
            end
        else
            SHAcKvar.Delayed[1] = 0
        end
        if Utils:IsKeyDown(1) or Utils:IsKeyDown(2) or Utils:IsKeyDown(67) then 
            v.shooting = 1
        else
            v.shooting = 0
        end
    --Invisible Car
        if Godmode.InvisibleCar == 1 then
            local bsData = BitStream()
            if vMy.Vehicle ~= 1999 then
                if Cars:isCarStreamed(1999) then
                    RemoveVehicle(1999)
                end
                SHAcKvar.InvCar = -1
                SHAcKvar.InvTimer = 0
                Godmode.InvisibleCar = 0;
            else
                SHAcKvar.InvTimer = 0
            end
            if Utils:IsKeyDown(13) or Utils:IsKeyDown(70) or SHAcKvar.InvCar == 0 and vMy.Vehicle ~= 1999 and vAmI.Driver then
                set.PlayerPos(vMy.Pos.fX, vMy.Pos.fY, vMy.Pos.fZ)
                local mem = Utils:readMemory(0xB6F980, 4, false)
                Utils:writeMemory(mem+0x42, 0, 1, false)
                SHAcKvar.InvTimer = 0;
            end
        end
    --Toggle Keys
        --Panic Keys
            --Visuals
                if Utils:IsKeyChecked(Panic.VisualsKey.v, 0) then
                    if Panic.Visuals.v == true then Panic.Visuals.v = false else Panic.Visuals.v = true end
                end
            --EveryThingExceptVisual
                if Utils:IsKeyChecked(Panic.EveryThingExceptVisualsKey.v, 0) then
                    if Panic.EveryThingExceptVisuals.v == true then Panic.EveryThingExceptVisuals.v = false else Panic.EveryThingExceptVisuals.v = true end
                end
        --MacroRun
            if Movement.MacroRun.Enable.v then
                if Movement.MacroRun.OnKey.v then
                    if Movement.MacroRun.KeyType.v == 1 then
                        if Utils:IsKeyChecked(Movement.MacroRun.Key.v, 0) then
                            if KeyToggle.MacroRun.v == 0 then
                                KeyToggle.MacroRun = ImInt(1)
                            else
                                KeyToggle.MacroRun = ImInt(0)
                            end
                        end
                    else
                        if Utils:IsKeyDown(Movement.MacroRun.Key.v) then
                            KeyToggle.MacroRun = ImInt(1)
                        else
                            KeyToggle.MacroRun = ImInt(0)
                        end
                    end
                else
                    KeyToggle.MacroRun = ImInt(1)
                end
            else
                KeyToggle.MacroRun = ImInt(0)
            end
        --Extra WS
            if Extra.ExtraWS.Enable.v then
                if Extra.ExtraWS.OnKey.v then
                    if Extra.ExtraWS.KeyType.v == 1 then
                        if Utils:IsKeyChecked(Extra.ExtraWS.Key.v, 0) then
                            if KeyToggle.ExtraWS.v == 0 then
                                KeyToggle.ExtraWS = ImInt(1)
                            else
                                KeyToggle.ExtraWS = ImInt(0)
                                Utils:writeMemory(0x5109AC, 0x7a, 1, true)
                                Utils:writeMemory(0x5109C5, 0x7a, 1, true)
                                Utils:writeMemory(0x5231A6, 0x75, 1, true)
                                Utils:writeMemory(0x52322D, 0x75, 1, true)
                                Utils:writeMemory(0x5233BA, 0x75, 1, true)
                            end
                        end
                    else
                        if Utils:IsKeyDown(Extra.ExtraWS.Key.v) then
                            KeyToggle.ExtraWS = ImInt(1)
                        else
                            KeyToggle.ExtraWS = ImInt(0)
                        end
                    end
                else
                    KeyToggle.ExtraWS = ImInt(1)
                end
            else
                KeyToggle.ExtraWS = ImInt(0)
            end
        --Silent
            if Silent.Enable.v then
                if Silent.OnKey.v then
                    if Silent.KeyType.v == 1 then
                        if Utils:IsKeyChecked(Silent.Key.v, 0) then
                            if KeyToggle.Silent.v == 0 then
                                KeyToggle.Silent = ImInt(1)
                            else
                                SilentStuff.ShotsCounter = 0
                                KeyToggle.Silent = ImInt(0)
                            end
                        end
                    else
                        if Utils:IsKeyDown(Silent.Key.v) then
                            KeyToggle.Silent = ImInt(1)
                        else
                            SilentStuff.ShotsCounter = 0
                            KeyToggle.Silent = ImInt(0)
                        end
                    end
                else
                    KeyToggle.Silent = ImInt(1)
                end
            else
                KeyToggle.Silent = ImInt(0)
            end
        --AimAssist
            if AimAssist.Enable.v then
                if AimAssist.OnKey.v then
                    if AimAssist.KeyType.v == 1 then
                        if Utils:IsKeyChecked(AimAssist.Key.v, 0) then
                            if KeyToggle.AimAssist.v == 0 then
                                KeyToggle.AimAssist = ImInt(1)
                            else
                                KeyToggle.AimAssist = ImInt(0)
                            end
                        end
                    else
                        if Utils:IsKeyDown(AimAssist.Key.v) then
                            KeyToggle.AimAssist = ImInt(1)
                        else
                            KeyToggle.AimAssist = ImInt(0)
                        end
                    end
                else
                    KeyToggle.AimAssist = ImInt(1)
                end
            else
                KeyToggle.AimAssist = ImInt(0)
            end
            if KeyToggle.AimAssist.v == 0 then
                SHAcKvar.AimAssistAimingTime = 0
                SHAcKvar.AimAssistAiming = 1
            end
        --Damager
            if Damager.Enable.v then
                if Damager.OnKey.v then
                    if Damager.KeyType.v == 1 then
                        if Utils:IsKeyChecked(Damager.Key.v, 0) then
                            if KeyToggle.Damager.v == 0 then
                                KeyToggle.Damager = ImInt(1)
                            else
                                KeyToggle.Damager = ImInt(0)
                            end
                        end
                    else
                        if Utils:IsKeyDown(Damager.Key.v) then
                            KeyToggle.Damager = ImInt(1)
                        else
                            KeyToggle.Damager = ImInt(0)
                        end
                    end
                else
                    KeyToggle.Damager = ImInt(1) 
                end
            else
                KeyToggle.Damager = ImInt(0) 
            end
        --DamageChanger
            if DamageChanger.Enable.v then
                if DamageChanger.OnKey.v then
                    if DamageChanger.KeyType.v == 1 then
                        if Utils:IsKeyChecked(DamageChanger.Key.v, 0) then
                            if KeyToggle.DamageChanger.v == 0 then
                                KeyToggle.DamageChanger = ImInt(1)
                            else
                                KeyToggle.DamageChanger = ImInt(0)
                            end
                        end
                    else
                        if Utils:IsKeyDown(DamageChanger.Key.v) then
                            KeyToggle.DamageChanger = ImInt(1)
                        else
                            KeyToggle.DamageChanger = ImInt(0)
                        end
                    end
                else
                    KeyToggle.DamageChanger = ImInt(1) 
                end
            else
                KeyToggle.DamageChanger = ImInt(0) 
            end
        --Rvanka
            if Troll.RVanka.Enable.v then
                if Troll.RVanka.OnKey.v then
                    if Troll.RVanka.KeyType.v == 1 then
                        if Utils:IsKeyChecked(Troll.RVanka.Key.v, 0) then
                            if KeyToggle.RVanka.v == 0 then
                                KeyToggle.RVanka = ImInt(1)
                            else
                                KeyToggle.RVanka = ImInt(0)
                            end
                        end
                    else
                        if Utils:IsKeyDown(Troll.RVanka.Key.v) then
                            KeyToggle.RVanka = ImInt(1)
                        else
                            KeyToggle.RVanka = ImInt(0)
                        end
                    end
                else
                    KeyToggle.RVanka = ImInt(1)
                end
            else
                KeyToggle.RVanka = ImInt(0)
            end
            --if Panic.EveryThingExceptVisuals.v == false then
    --Aim
        --Silent
            if KeyToggle.Silent.v == 1 then
                --Settings
                    if SilentStuff.ShotsCounter >= SilentStuff.Shots then
                        SilentStuff.FirstShots = 0
                    else
                        if SilentStuff.FirstShots ~= 1 then
                            SilentStuff.FirstShots = 1
                        end
                    end
                    if v.lastweapon ~= vMy.Weapon then
                        get.SilentConfig(vMy.Weapon, vMy.VehicleModel)
                        SilentStuff.ShotsCounter = 0
                        v.lastweapon = vMy.Weapon
                    elseif vMy.Vehicle == 432 and v.lastweapon ~= vMy.Vehicle then
                        get.SilentConfig(vMy.Weapon, vMy.VehicleModel)
                        v.lastweapon = vMy.Vehicle
                    end
                    
                    --if Players:isPlayerStreamed(v.SilentPlayerID) then
                    --    send.AimSync(v.SilentPlayerID, vMy.Weapon)
                    --end
            end
            if KeyToggle.Silent.v == 0 then
                if SilentStuff.ShotsCounter ~= 0 then
                    SilentStuff.ShotsCounter = 0
                end
            end
        --AimAssist
            if KeyToggle.AimAssist.v == 1 then
                    if Utils:IsKeyDown(2) then
                        SHAcKvar.AimAssistAimingTime = SHAcKvar.AimAssistAimingTime + 1
                        if SHAcKvar.AimAssistAimingTime > 20 or Utils:IsKeyDown(1) then
                            SHAcKvar.AimAssistAiming = 0
                        else
                            SHAcKvar.AimAssistAimingTime = 0
                            SHAcKvar.AimAssistAiming = 1
                        end
                    else
                        SHAcKvar.AimAssistAiming = 0
                        SHAcKvar.AimAssistAimingTime = 0
                    end
                if SHAcKvar.AimAssist ~= nil then
                    if Players:isPlayerStreamed(SHAcKvar.AimAssist) == false then
                        SHAcKvar.AimAssist = nil
                    end
                    SHAcKvar.AimAssistDelay = SHAcKvar.AimAssistDelay + 1
                    if SHAcKvar.AimAssistDelay > 500 or get.isPlayerAlive(SHAcKvar.AimAssist) == false then
                        SHAcKvar.AimAssist = nil
                        SHAcKvar.AimAssistDelay = 0
                    end
                end
                local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                local target 
                if SHAcKvar.AimAssist ~= nil and AimAssist.ForceWhoDamaged.v or SHAcKvar.AimAssist2 ~= nil or SHAcKvar.AimAssist3 ~= nil then
                    local maxfov = AimAssist.FOVType.v
                    if SHAcKvar.AimAssist == nil then 
                        if SHAcKvar.AimAssist2 == nil then
                            target = SHAcKvar.AimAssist3
                        else
                            target = SHAcKvar.AimAssist2  
                        end
                    else 
                        target = SHAcKvar.AimAssist 
                        maxfov = 1
                    end
                    if target ~= nil then 
                        if Players:isPlayerStreamed(target) then
                            if AimAssist.FOVType.v == 1 or AimAssist.FOVType.v == 0 and Utils:isOnScreen(target) then
                                if AimAssist.IgnoreCList.v and Players:getPlayerColor(target) ~= vMy.Color or AimAssist.IgnoreCList.v == false then
                                    local vEnPos = Players:getPlayerPosition(target)
                                    Utils:GameToScreen(vEnPos, vEnScreen)
                                    local vEnPostoSight = vEnPos 
                                    vEnPostoSight.fZ = vEnPostoSight.fZ + 0.5
                                    local vMyPosPostoSight = vMyPos 
                                    vMyPosPostoSight.fZ = vMyPosPostoSight.fZ + 0.5
                                    if Utils:IsLineOfSightClear(vMyPosPostoSight, vEnPostoSight, true, true, false, true, false, false, false) then
                                        local Distance = Utils:Get3Ddist(vMyPos , vEnPos)
                                        local WeaponDist = weaponInfo[vMy.Weapon].distance
                                        local fov = Utils:Get3Ddist(vecCrosshair,vEnScreen)
                                        if maxfov == 0 and fov < AimAssist.FOV.v*20 or maxfov == 1 then
                                            if AimAssist.DrawFOV.v then
                                                Render:DrawLine(vecCrosshair.fX,vecCrosshair.fY,vEnScreen.fX,vEnScreen.fY,Players:getPlayerColor(target))
                                                Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, 3, true, Players:getPlayerColor(target))
                                            end
                                            if vMy.OFData.sCurrentAnimationID > 1157 and vMy.OFData.sCurrentAnimationID < 1165 or vMy.OFData.sCurrentAnimationID == 1167 then
                                                if Distance < WeaponDist then
                                                    local distance = Utils:Get2Ddist(SilentCrosshair , vEnScreen)
                                                    if SHAcKvar.AimAssistAiming == 1 and distance > 100 then
                                                        local deltaX = (vEnPos.fX) - (vMyPos.fX)
                                                        local deltaY = (vEnPos.fY) - (vMyPos.fY)
                                                        local angle = math.atan2(deltaY, deltaX)
                                                        angle = angle + math.pi 
                                                        Utils:MoveTarget(angle)
                                                        SHAcKvar.AimAssistAiming = 2
                                                    end
                                                end
                                            end
                                        else
                                            SHAcKvar.AimAssist = nil
                                            target = nil
                                            SHAcKvar.AimAssist2 = nil
                                        end
                                    else
                                        SHAcKvar.AimAssist = nil
                                        target = nil
                                        SHAcKvar.AimAssist2 = nil
                                    end
                                end
                            end
                        else
                            target = nil
                            SHAcKvar.AimAssist = nil
                            SHAcKvar.AimAssist2 = nil
                        end
                    end
                end
                if AimAssist.DrawFOV.v then
                    local color = 0
                    local FOV = AimAssist.FOV.v*20
                    if target ~= nil then
                        color = Players:getPlayerColor(target)
                    end
                    if AimAssist.FOVType.v == 1 then
                        FOV = 1200
                    end
                    Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, FOV, false, color)
                    Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, FOV, true, 0x199966f0)
                end
                if SHAcKvar.AimAssist == nil then
                    local vMyCam = Utils:getCameraPosition()
                    for i, _ in pairs(players.id) do
                        if Players:isPlayerStreamed(i) then
                            if Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(i) == false then
                                local vEnPos = Players:getPlayerPosition(i)
                                if get.isPlayerAlive(i) and Utils:IsLineOfSightClear(vMyPos, vEnPos, true, false, false, false, false, false, false) then
                                    Utils:GameToScreen(vEnPos, vEnScreen)
                                    local Distance = Utils:Get3Ddist(vMyPos , vEnPos)
                                    local PlayerDist = weaponInfo[vMy.Weapon].distance
                                    local fov = Utils:Get3Ddist(vecCrosshair,vEnScreen)
                                    if Distance < PlayerDist then
                                        if AimAssist.IgnoreCList.v and Players:getPlayerColor(i) ~= vMy.Color or AimAssist.IgnoreCList.v == false then
                                            if AimAssist.FOVType.v == 1 or AimAssist.FOVType.v == 0 and fov < AimAssist.FOV.v*20 then
                                                if Utils:isOnScreen(i) then
                                                    SHAcKvar.AimAssistTarget[i] = Utils:Get3Ddist(vecCrosshair, vEnScreen)
                                                    SHAcKvar.AimAssist2 = maths.getLowerIn(SHAcKvar.AimAssistTarget)
                                                else
                                                    if SHAcKvar.AimAssist2 == nil then
                                                        if AimAssist.FOVType.v == 1 then
                                                            local isvisible = get.PlayersFromCameraToTarget(vMyPos, vEnPos, vMyCam)
                                                            tableto[i] = isvisible
                                                            SHAcKvar.AimAssist3 = maths.getHigherIn( tableto)
                                                        end
                                                    end
                                                end
                                            else
                                                SHAcKvar.AimAssistTarget[i] = nil
                                            end
                                        else
                                            SHAcKvar.AimAssistTarget[i] = nil
                                        end
                                    else
                                        SHAcKvar.AimAssistTarget[i] = nil
                                    end
                                else
                                    SHAcKvar.AimAssistTarget[i] = nil
                                end
                            else
                                SHAcKvar.AimAssistTarget[i] = nil
                            end
                        else
                            SHAcKvar.AimAssistTarget[i] = nil
                        end
                    end
                end
            end
        --Damager
            if KeyToggle.Damager.v == 1 then
                if(DMGTimer.update(deltaTime)) then
                    local amount
                    local hittype
                    v.WaitFORFINISH = 0
                    local weapon = vMy.Weapon
                    if Damager.CurrentWeapon.v == false then
                        if Damager.Weapon.v == 51 then
                            weapon = math.random(0, 38)
                        else 
                            weapon = Damager.Weapon.v
                        end
                    end
                    if Damager.ChangeDamage.v then
                        amount = weapon
                    else
                        amount = weaponInfo[weapon].damage
                    end
                    if Damager.SyncBullet.Type.v == 0 then
                        hittype = 1
                    else
                        hittype = 0
                    end
                --Get Damager Target
                    local nearestplayer = {}
                    for i, _ in pairs(players.id) do
                        if Damager.OnlyStreamed.v then
                            if Players:isPlayerStreamed(i) then
                                local vEnPos = Players:getPlayerPosition(i)
                                local Distance = Utils:Get3Ddist(vEnPos , vMy.Pos)
                                local PlayerDist
                                if Damager.DistanceEnable.v then
                                    PlayerDist = Damager.Distance.v
                                else
                                    PlayerDist = weaponInfo[weapon].distance
                                end
                                if Distance < PlayerDist then
                                    local PlayerSkin = Players:getPlayerSkin(i)
                                    local vMyColor = vMy.Color
                                    local vEnColor = Players:getPlayerColor(i)
                                    if Damager.Clist.v and vMyColor ~= vEnColor or Damager.Clist.v == false then  
                                        if Damager.Force.v == false and Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(PlayerSkin) == false or Damager.Force.v and Players:isPlayerInFilter(i) == true or Damager.Force.v and Players:isSkinInFilter(PlayerSkin) == true then
                                            if Damager.AFK.v and Players:isPlayerAFK(i) == false or Damager.AFK.v == false then
                                                if Damager.Death.v and get.isPlayerAlive(i) == true or Damager.Death.v == false then
                                                    local vEnPos = Players:getPlayerPosition(i)
                                                    if Damager.VisibleChecks.v and Utils:IsLineOfSightClear(vMy.Pos, vEnPos, true, Damager.VisibleCheck.Vehicles.v, false, Damager.VisibleCheck.Objects.v, false, false, false) or Damager.VisibleChecks.v == false then
                                                        local   distance = Utils:Get3Ddist(vMy .Pos, vEnPos)
                                                        if Damager.TargetType.v == 0 then
                                                            nearestplayer[i] =  distance
                                                        elseif Damager.TargetType.v == 1 then
                                                            nearestplayer[i] = (Players:getPlayerHP(i) + Players:getPlayerArmour(i))
                                                        elseif Damager.TargetType.v == 2 then
                                                            nearestplayer[i] = i
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if Damager.gtdID.v ~= -1 then
                                i = Damager.gtdID.v
                            end
                            if Players:isPlayerOnServer(i) then
                                local vMyColor = vMy.Color
                                local vEnColor = Players:getPlayerColor(i)
                                if Damager.Clist.v and vMyColor ~= vEnColor or Damager.Clist.v == false then 
                                    if Damager.Force.v == false and Players:isPlayerInFilter(i) == false or Damager.Force.v and Players:isPlayerInFilter(i) == true then
                                        nearestplayer[i] = i
                                    end
                                end
                            end
                        end
                        if nearestplayer[i] == nil and v.DamagerPlayerID == i then
                            v.DamagerPlayerID = -1
                        end
                    end
                        local DamagerPlayer
                        if Damager.OnlyStreamed.v then
                            if Damager.TargetType.v == 0 or Damager.TargetType.v == 1 then
                                DamagerPlayer = maths.getLowerIn(nearestplayer)
                            elseif Damager.TargetType.v == 2 then
                                local validValues = {}
                                for _, value in pairs(nearestplayer) do
                                    if value ~= nil then
                                        table.insert(validValues, value)
                                    end
                                end
                                if #validValues > 0 then
                                    DamagerPlayer = validValues[math.random(#validValues)]
                                end
                            end
                        else
                            local validValues = {}
                            for _, value in pairs(nearestplayer) do
                                if value ~= nil then
                                    table.insert(validValues, value)
                                end
                            end
                            if #validValues > 0 then
                                DamagerPlayer = validValues[math.random(#validValues)]
                            end
                        end
                    if DamagerPlayer ~= nil then
                        v.DamagerPlayerID = DamagerPlayer
                        local message, color
                        local chanceddamager = maths.Chance(Damager.Chance.v)
                        local bool = false
                        if Damager.TakeDamage.v == true then
                            bool = true
                        end
                        
                        local bone = fPlayerBone[Damager.Bone.v+1]
                        if Damager.Bone.v == 7 then
                            bone = math.random(3, 9)
                        end

                        --Only Streamed
                            if Damager.OnlyStreamed.v then
                                local hitpos, origin

                                local vEnPos = Players:getPlayerPosition(v.DamagerPlayerID)
                                local Pos = Players:getPlayerPosition(Players:getLocalID())
                                if Damager.SyncPos.v then
                                    Pos = CVector(vEnPos.fX + 1, vEnPos.fY, vEnPos.fZ)
                                end

                                local cheatBone = get.CheatBoneFromGame(bone)
                                SHAcKvar.damagerBone = cheatBone
                                local vEnPos2 = Players:getBonePosition(v.DamagerPlayerID, cheatBone)
                                local message, color, hitpos
                                local r = 0
                                local distance = Utils:Get3Ddist(vMy.Pos,vEnPos)
                                local rand = CVector(maths.randomFloat(-0.05, 0.05), maths.randomFloat(-0.05, 0.05), maths.randomFloat(-0.02, 0.02))
                                local offset = vEnPos2 - vEnPos + rand

                                
                                if Damager.TakeDamage.v == false then
                                    local expectedPosition = vEnPos2
                                    -- build OnFootData
                                        local myOFData = get.onFootData()
                                        local rotpos
                                        local offsetX = 0
                                        local offsetY = 0
                                        if Troll.FakePos.Enable.v and Troll.FakePos.OnFoot.v then
                                            offsetX = Troll.FakePos.X.v
                                            offsetY = Troll.FakePos.Y.v
                                        end
                                        OnFootData.keys = 132

                                        OnFootData.weapon_id = weapon
                                        OnFootData.animation_id = weaponInfo[weapon].animations
                                        OnFootData.animation_flags = weaponInfo[weapon].animationsflag
                                        
                                        if Damager.SyncPos.v == false then
                                            OnFootData.X = Pos.fX + offsetX
                                            OnFootData.Y = Pos.fY + offsetY
                                            OnFootData.Z = Pos.fZ
                                            if weapon == 41 or weapon == 42 or weapon == 37 or weapon == 35 or weapon == 36 then
                                                expectedPosition = get.LagCompensatedPosition(CVector(OnFootData.X, OnFootData.Y, OnFootData.Z), v.DamagerPlayerID, 1.0)
                                                SHAcKvar.damagerhitEnPos = rotpos or vEnPos
                                            end
                                            SHAcKvar.damagerhitEnPos = expectedPosition or rotpos or vEnPos
                                        else
                                            OnFootData.keys = 4+8
                                            local vData = Players:getOnFootData(v.DamagerPlayerID)
                                            local PlayerPosLag = get.PlayerLag(v.DamagerPlayerID)
                                            OnFootData.X = PlayerPosLag.fX + offsetX
                                            OnFootData.Y = PlayerPosLag.fY + offsetY
                                            OnFootData.Z = PlayerPosLag.fZ
                                            OnFootData.velocity_x = vData.Speed.fX*1.3
                                            OnFootData.velocity_y = vData.Speed.fY*1.3
                                            OnFootData.velocity_z = vData.Speed.fZ
                                            expectedPosition = PlayerPosLag
                                            SHAcKvar.damagerhitEnPos = rotpos or vEnPos
                                        end
                                        if Damager.SyncRotation.v then
                                            if expectedPosition ~= nil then
                                                local qw, qx, qy, qz = set.PlayerFacing(CVector(OnFootData.X, OnFootData.Y, OnFootData.Z), expectedPosition)     
                                                OnFootData.quat_w = qw
                                                OnFootData.quat_z = qz
                                            end
                                        end
                                        SHAcKvar.damagerhitMyPos = CVector(OnFootData.X, OnFootData.Y, OnFootData.Z)
                                    --
                                    --Build AimData
                                        local myAimData = get.AimData()

                                        local vMyBone = Players:getBonePosition(Players:getLocalID(), 25)
                                        local vEnBone = CVector(expectedPosition.fX, expectedPosition.fY, expectedPosition.fZ)

                                        local direction = get.Direction(expectedPosition, CVector(OnFootData.X, OnFootData.Y, OnFootData.Z))
                                        local aimz = get.AimZ(vMyBone, CVector(expectedPosition.fX, expectedPosition.fY, expectedPosition.fZ))

                                        AimData.cammode = weaponInfo[weapon].cammode
                                        AimData.weaponstate = weaponInfo[weapon].weaponstate
                                        AimData.camfrontX = direction.fX
                                        AimData.camfrontY = direction.fY 
                                        AimData.camfrontZ = direction.fZ
                                        if Damager.SyncAim.v then
                                            AimData.aimZ = aimz
                                        end
                                    --
                                    if chanceddamager == false then
                                        hittype = 0
                                        hitpos = CVector(vEnPos.fX+offset.fX+math.random(1,5), vEnPos.fY+offset.fY+math.random(1,5), vEnPos.fZ+offset.fZ)
                                    else
                                        hitpos = CVector(vEnPos.fX+offset.fX, vEnPos.fY+offset.fY, vEnPos.fZ+offset.fZ)
                                    end

                                    if Damager.SyncPos.v then
                                        origin = CVector(hitpos.fX, hitpos.fY, hitpos.fZ)
                                    else
                                        local vMyBone = Players:getBonePosition(vMy.ID, 22)
                                        origin = CVector(vMyBone.fX, vMyBone.fY, vMyBone.fZ)
                                    end
                                    
                                    --Build BulletData
                                        local myBulletData = get.BulletData()
                                        BulletData.type = hittype
                                        BulletData.hitid = v.DamagerPlayerID
                                        BulletData.originX = origin.fX
                                        BulletData.originY = origin.fY
                                        BulletData.originZ = origin.fZ
                                        BulletData.posX = hitpos.fX
                                        BulletData.posY = hitpos.fY
                                        BulletData.posZ = hitpos.fZ
                                        BulletData.offsetX = offset.fX
                                        BulletData.offsetY = offset.fY
                                        BulletData.offsetZ = offset.fZ
                                        BulletData.weapon = weapon
                                    --

                                    send.CameraTarget( v.DamagerPlayerID)

                                    if weapon >= 22 and weapon ~= 46 and Damager.SyncWeapon.v then
                                        if weaponInfo[weapon].ammo == nil or weaponInfo[weapon].ammo > 0 then
                                            set.WeaponAmmo(weaponInfo[weapon].id, 1)
                                        end
                                        send.WeaponUpdate(weapon, v.DamagerPlayerID)
                                    end
                                    local data = Players:getOnFootData(Players:getLocalID())
                                    if weapon >= 22 and weapon <= 36 then
                                        if Damager.SyncOnfootData.v and not vAmI.Driver and not vAmI.Passenger then
                                            if Damager.EmulCbug.v and weapon ~= 35 and weapon ~= 36 then
                                                OnFootData.keys = OnFootData.keys + 2
                                                OnFootData.special_action = 1
                                            end
                                            send.onFootSync(OnFootData)
                                        end
                                    end
                                    send.AimSync(AimData)
                                    if weapon >= 22 and weapon <= 34 and Damager.SyncBullet.Enable.v then
                                        for l = 1, Damager.Bullets.v do
                                            send.BulletSync(BulletData)
                                        end
                                    end

                                    if Damager.SyncOnfootData.v and not vAmI.Driver then
                                        if vAmI.Passenger then
                                            send.PassengerSync(Pos.fX, Pos.fY, Pos.fZ, vEnPos, weapon)
                                        else
                                            send.onFootSync(OnFootData)
                                        end
                                    end

                                    if chanceddamager == true then
                                        if Damager.IgnoreGiveTakeDamage.v == false then
                                            for l = 1, Damager.Bullets.v do
                                                send.GiveTakeDamage(bool, v.DamagerPlayerID, amount, weapon, bone)
                                            end
                                        end
                                    end
                                    
                                else
                                    if Damager.DeathNotification.v then
                                        local bsData = BitStream()
                                        if Damager.Spawn.v then
                                            SendRPC(52, bsData)
                                        end
                                        bsWrap:Write8(bsData, weapon)
                                        bsWrap:Write16(bsData, v.DamagerPlayerID)
                                        SendRPC(53, bsData)
                                    end
                                    if chanceddamager == true then
                                        if Damager.IgnoreGiveTakeDamage.v == false then
                                            for l = 1, Damager.Bullets.v do
                                                send.GiveTakeDamage(bool, v.DamagerPlayerID, amount, weapon, bone)
                                            end
                                        end
                                    end
                                end
                            else
                        --Non Streamed
                                if Damager.IgnoreGiveTakeDamage.v == false then
                                    send.GiveTakeDamage(bool, v.DamagerPlayerID, amount, weapon, bone)
                                end
                                if Damager.TakeDamage.v and Damager.DeathNotification.v then
                                    local bsData = BitStream()
                                    if Damager.Spawn.v then
                                        SendRPC(52, bsData)
                                    end
                                    bsWrap:Write8(bsData, weapon)
                                    bsWrap:Write16(bsData, v.DamagerPlayerID)
                                    SendRPC(53, bsData)
                                end
                        end
                        --set.TextDraw
                            
                            if chanceddamager == false then
                                color = 0xFF0000FF
                            else
                                color = 0xFFff1100
                            end
                            message = ImBuffer("Damager - ".. Players:getPlayerName( v.DamagerPlayerID) .." (".. v.DamagerPlayerID ..")",155)
                            set.TextDraw(message, color, 2046, 15, 315)
                            message = ImBuffer("Weapon - ".. weaponInfo[weapon].name .." (".. weapon ..")" ,155)
                            set.TextDraw(message, 0xFF993366, 2047, 22, 325)
                    end
                    SHAcKvar.Delayed[0] = 0
                end
            end
    --Movement
        --Macro Run
            if KeyToggle.MacroRun.v == 1 then
                if not vAmI.Passenger and not vAmI.Driver or SHAcKvar.Timer[1] > 1 then
                    local hp = vMy.HP
                    memory.CPed.Anim = Utils:readMemory(CPedST+0x534, 1, false)
                    if memory.CPed.Anim == 7 then
                        SHAcKvar.IndTimer = SHAcKvar.Timer[1]
                    end
                    if vMy.OFData.SpecialAction ~= 2 then
                        if(Macro.update(deltaTime)) then
                            SHAcKvar.Timer[1] = SHAcKvar.Timer[1] + 1
                        end
                        if Movement.MacroRun.SpeedBasedOnHp.v then
                            if SHAcKvar.Timer[1] > SHAcKvar.RandSpeed then
                                if Movement.MacroRun.Key.v ~= 32 or not Movement.MacroRun.OnKey.v then
                                    set.KeyState(0xB73458+0x20, 255)
                                    Utils:emulateGTAKey(16, 255)
                                else
                                    set.KeyState(0xB72D08, 255)
                                    set.KeyState(0xb731e8, 255)
                                end
                                if hp > 75 then
                                    SHAcKvar.RandSpeed = math.random(28,32)
                                end
                                if hp > 50 and hp < 75 then
                                    SHAcKvar.RandSpeed = math.random(20,28)
                                end
                                if hp > 25 and hp < 50 then
                                    SHAcKvar.RandSpeed = math.random(10,20)
                                end
                                if hp > 0 and hp < 25 then
                                    SHAcKvar.RandSpeed = math.random(1,10)
                                end
                                Utils:emulateGTAKey(16, 255)
                                SHAcKvar.Timer[1] = 0
                            else
                                if Movement.MacroRun.Key.v ~= 32 or not Movement.MacroRun.OnKey.v then
                                    set.KeyState(0xB73458+0x20, 0)
                                else
                                    set.KeyState(0xB72D08, 0)
                                    set.KeyState(0xb731e8, 0)
                                end
                            end
                        end
                        if Movement.MacroRun.Legit.v then
                            if SHAcKvar.Timer[1] > SHAcKvar.RandSpeed then
                                Utils:emulateGTAKey(16, 255)
                                if Movement.MacroRun.Key.v ~= 32 or not Movement.MacroRun.OnKey.v then
                                    set.KeyState(0xB73458+0x20, 255)
                                    Utils:emulateGTAKey(16, 255)
                                else
                                    set.KeyState(0xB72D08, 255)
                                    set.KeyState(0xb731e8, 255)
                                end
                                if SHAcKvar.RandSpeed >= 1 and SHAcKvar.RandSpeed <= 5 then
                                    SHAcKvar.RandSpeed = math.random(10,15)
                                elseif SHAcKvar.RandSpeed >= 10 and SHAcKvar.RandSpeed <= 15 then
                                    SHAcKvar.RandSpeed = math.random(1,5)
                                end
                                SHAcKvar.Timer[1] = 0
                            else
                                if Movement.MacroRun.Key.v ~= 32 or not Movement.MacroRun.OnKey.v then
                                    set.KeyState(0xB73458+0x20, 0)
                                else
                                    set.KeyState(0xB72D08, 0)
                                    set.KeyState(0xb731e8, 0)
                                end
                            end
                        end
                        if Movement.MacroRun.Legit.v == false and Movement.MacroRun.SpeedBasedOnHp.v == false then
                            if SHAcKvar.Timer[1] > Movement.MacroRun.Speed.v then
                                if Movement.MacroRun.Key.v ~= 32 or not Movement.MacroRun.OnKey.v then
                                    set.KeyState(0xB73458+0x20, 255)
                                    Utils:emulateGTAKey(16, 255)
                                else
                                    set.KeyState(0xB72D08, 255)
                                    set.KeyState(0xb731e8, 255)
                                end
                                SHAcKvar.Timer[1] = 0
                            else
                                if Movement.MacroRun.Key.v ~= 32 or not Movement.MacroRun.OnKey.v then
                                    set.KeyState(0xB73458+0x20, 0)
                                else
                                    set.KeyState(0xB72D08, 0)
                                    set.KeyState(0xb731e8, 0)
                                end
                            end
                        end
                    end
                end
            end
        --Slide
            if Movement.Slide.Enable.v then
                if SHAcKvar.FiredGun == 34 then
                    Timer.SniperC = vMy.OFData.CamMode
                end
                if vAmI.Passenger or vAmI.Driver then
                    SHAcKvar.canSlide = 0
                else
                    if get.isPlayerAlive(vMy.ID) == false then
                        SHAcKvar.Aiming = 0
                        Timer.Slide[0] = 0
                        Timer.Slide[1] = 0
                        SHAcKvar.Switch = -2
                        SHAcKvar.canSlide = 0
                        Movement.Slide.GunC = 0
                        SHAcKvar.toSlide = 0
                        if SHAcKvar.Duration ~= 0 then
                            Utils:writeMemory(0xB7CB64, 1.000001, 4, false)
                            SHAcKvar.Duration = 0
                        end
                    else
                        local firedGun = SHAcKvar.FiredGun
                        local currentAnimationID = vMy.OFData.sCurrentAnimationID
            
                        if (Movement.Slide.DesertEagle.v and firedGun == 24) or
                            (Movement.Slide.SilencedPistol.v and firedGun == 23) or
                            (Movement.Slide.Shotgun.v and firedGun == 25) or
                            (Movement.Slide.Sawnoff.v and firedGun == 26) or
                            (Movement.Slide.CombatShotgun.v and firedGun == 27) or
                            (Movement.Slide.Mp5.v and firedGun == 29) or
                            (Movement.Slide.Ak47.v and firedGun == 30) or
                            (Movement.Slide.M4.v and firedGun == 31) or
                            (Movement.Slide.CountryRifle.v and firedGun == 33) or
                            (Movement.Slide.SniperRifle.v and firedGun == 34) or
                            (Movement.Slide.PerWeap.v == false)
                        then
                            if firedGun == 26 then
                                if SHAcKvar.canSlide == 0 then
                                    get.PlayerWeapons()
                                end
                                if weaponInfo[firedGun].clipammo ~= 4 then
                                    SHAcKvar.canSlide = 1
                                end
                                SHAcKvar.Aiming = 0
                            else
                                if currentAnimationID > 1157 and currentAnimationID < 1165 or currentAnimationID == 1167 then
                                    SHAcKvar.Aiming = 1
                                else
                                    SHAcKvar.Aiming = 0
                                end
                                if Timer.Slide[0] == 0 then
                                    if (currentAnimationID > 1070 and currentAnimationID < 1087) or
                                        (currentAnimationID > 1172 and currentAnimationID < 1179)
                                    then
                                        SHAcKvar.canSlide = 0
                                        SHAcKvar.toSlide = 1
                                    else
                                        if currentAnimationID > 1157 and currentAnimationID < 1164 or currentAnimationID == 1167 then
                                            SHAcKvar.toSlide = 1
                                            NoKey = 1
                                            SHAcKvar.canSlide = 0
                                        else
                                            NoKey = 0
                                            if SHAcKvar.toSlide == 1 and Timer.GunC == 0 then
                                                if Movement.Slide.OnKey.v == false then
                                                    if currentAnimationID == 1256 or
                                                        (currentAnimationID > 1221 and currentAnimationID < 1234) or
                                                        currentAnimationID == 1335
                                                    then
                                                        NoKey = 2
                                                        SHAcKvar.canSlide = 1
                                                        SHAcKvar.toSlide = 0
                                                    else
                                                        SHAcKvar.canSlide = 0
                                                    end
                                                else
                                                    SHAcKvar.canSlide = 1
                                                    SHAcKvar.toSlide = 0
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            SHAcKvar.Aiming = 0
                            Timer.Slide[0] = 0
                            Timer.Slide[1] = 0
                            SHAcKvar.Switch = -2
                            SHAcKvar.canSlide = 0
                            Movement.Slide.GunC = 0
                            SHAcKvar.toSlide = 0
                        end
                    end
                end
                if vMy.OFData.SpecialAction == 3 or vMy.OFData.SpecialAction == 1 or Utils:IsKeyDown(67) or vMy.Weapon == 26 and weaponInfo[vMy.Weapon].clipammo ~= 4 and not Utils:IsKeyDown(2) then
                    Timer.GunC = 0
                    Timer.SniperC = 0
                end
                if SHAcKvar.canSlide == 1 or SHAcKvar.toSlide == 1 then
                    if Movement.Slide.OnKey.v and Utils:IsKeyDown(Movement.Slide.Key.v) 
                    or Movement.Slide.OnKey.v == false and NoKey == 2 or Movement.Slide.OnKey.v == false and vMy.Weapon == 26 and not Utils:IsKeyDown(2) then
                        if Timer.Slide[2] ~= 1 and Timer.Slide[0] < 2 then
                            if Movement.Slide.PerWeap.v and (SHAcKvar.FiredGun == 25 or SHAcKvar.FiredGun == 27 or SHAcKvar.FiredGun == 30 or SHAcKvar.FiredGun == 31 or SHAcKvar.FiredGun == 33 or SHAcKvar.FiredGun == 34) then
                                SHAcKvar.SwitchVelocity[0] = math.random(tonumber(Movement.Slide.SwitchVelocity[2].v), tonumber(Movement.Slide.SwitchVelocity[3].v))
                                SHAcKvar.SwitchVelocity[1] = SHAcKvar.SwitchVelocity[0] + tonumber(Movement.Slide.SwitchVelocity[2].v) + math.random(2, 4)
                            else
                                SHAcKvar.SwitchVelocity[0] = math.random(tonumber(Movement.Slide.SwitchVelocity[0].v), tonumber(Movement.Slide.SwitchVelocity[1].v))
                            end
                            Timer.Slide[2] = 1
                        end
                        if Utils:IsKeyDown(87) or Utils:IsKeyDown(83) or Utils:IsKeyDown(65) or Utils:IsKeyDown(68) or vMy.Weapon == 26 then
                            if Movement.Slide.AutoC.v and not Utils:IsKeyDown(1) and not Utils:IsKeyDown(2) and SHAcKvar.toSlide == 1 then
                                if Timer.GunC > 0 or Timer.SniperC == 7 then
                                    Utils:emulateGTAKey(18, 255)
                                    Timer.GunC = 0
                                    Timer.SniperC = 0
                                end
                            end
                            if SHAcKvar.canSlide == 1 then
                                Timer.Slide[0] = Timer.Slide[0] + 1
                            end
                        end
                    end
                end
                if Timer.Slide[0] <= 1 then
                    if SHAcKvar.FiredGun ~= vMy.Weapon then
                        SHAcKvar.FiredGun = vMy.Weapon
                        if SHAcKvar.FiredGun == 26 then
                            SlideWeapon = get.ChangeWeapon(SHAcKvar.FiredGun, 1)
                        else
                            SlideWeapon = get.ChangeWeapon(SHAcKvar.FiredGun, 0)
                        end
                    end
                    if Movement.Slide.PerWeap.v then
                        SHAcKvar.CamMod = (SHAcKvar.FiredGun == 34) and 1 or 0
                    end
                end
                if Timer.GunC == 0 and Timer.Slide[0] > 1 and Movement.Slide.AutoC.v == false or
                Timer.GunC == 0 and Timer.Slide[0] > 2 and Movement.Slide.AutoC.v then
                    if not vAmI.Passenger and not vAmI.Driver then
                        if Movement.Slide.SpeedEnable.v then
                            if SpeedChance ~= true and SpeedChance ~= false then
                                SpeedChance = maths.Chance(Movement.Slide.SpeedChance.v)
                            end
                            if SHAcKvar.Duration < Movement.Slide.SpeedDuration.v and SpeedChance == true and get.isPlayerAlive(vMy.ID) ~= false then
                                if (ms.update(deltaTime)) then
                                    SHAcKvar.Duration = SHAcKvar.Duration + 1
                                end
                            end
                            if SHAcKvar.Duration < 2 then
                                SHAcKvar.SpeedX = vMy.OFData.Speed.fX * Movement.Slide.Speed.v
                                SHAcKvar.SpeedY = vMy.OFData.Speed.fY * Movement.Slide.Speed.v
                            end
                            if SHAcKvar.Duration ~= 0 and SHAcKvar.Duration < Movement.Slide.SpeedDuration.v and SpeedChance == true then
                                memory.CPed.Anim = Utils:readMemory(CPedST + 0x534, 1, false)
                                if memory.CPed.Anim == 4 or memory.CPed.Anim == 6 or memory.CPed.Anim == 7 then
                                    SHAcKvar.Speed = 1
                                    if Movement.Slide.SpeedGameSpeed.v == 0 then
                                        local bisInteger = maths.isInteger(Movement.Slide.Speed.v)
                                        local speedii = Movement.Slide.Speed.v
                                        if bisInteger then
                                            speedii = speedii + 0.000001
                                        end
                                        Utils:writeMemory(0xB7CB64, speedii, 4, false)
                                    else
                                        Utils:writeMemory(CPedST + 0x42, 16, 1, false)
                                        set.PlayerVelocity(SHAcKvar.SpeedX, SHAcKvar.SpeedY, vMy.OFData.Speed.fZ)
                                    end
                                end
                            else
                                if SHAcKvar.Duration < Movement.Slide.SpeedDuration.v + 20 then
                                    if Godmode.PlayerEnable.v == false or (Godmode.PlayerEnable.v and Godmode.PlayerCollision.v == false) then
                                        if v.NoFall == 0 then
                                            Utils:writeMemory(CPedST + 0x42, 0, 1, false)
                                            SHAcKvar.Speed = 0
                                        end
                                    end
                                end
                            end
                        end
                        SHAcKvar.canSlide = 0
                        SHAcKvar.toSlide = 0
                        if (ms.update(deltaTime)) then
                            SHAcKvar.Switch = SHAcKvar.Switch + 1
                        end
                        if SHAcKvar.FiredGun ~= 26 then
                            if not Utils:IsKeyDown(65) and not Utils:IsKeyDown(87) and not Utils:IsKeyDown(83) and not Utils:IsKeyDown(68) then
                                if SHAcKvar.Switch < SHAcKvar.SwitchVelocity[0] then
                                    if Timer.Slide[1] == 0 then
                                        v.cefini = SHAcKvar.SwitchVelocity[0]
                                        SHAcKvar.SwitchVelocity[0] = SHAcKvar.Switch
                                        SHAcKvar.SwitchVelocity[1] = SHAcKvar.SwitchVelocity[0] + 2
                                        Timer.Slide[1] = 1
                                    end
                                end
                            end
                        end
                        if SHAcKvar.Switch > -1 and SHAcKvar.Switch < 1 or 
                        SHAcKvar.Switch == SHAcKvar.SwitchVelocity[1] and weaponInfo[SHAcKvar.FiredGun].twohanded then
                            if SHAcKvar.FiredGun == 26 then
                                SlideWeapon = get.ChangeWeapon(SHAcKvar.FiredGun, 1)
                            else
                                SlideWeapon = get.ChangeWeapon(SHAcKvar.FiredGun, 0)
                            end
                            if Movement.Slide.PrioritizeFist1handedgun.v and not weaponInfo[SHAcKvar.FiredGun].twohanded or
                            Movement.Slide.PrioritizeFist2handedgun.v and weaponInfo[SHAcKvar.FiredGun].twohanded then
                                set.ArmedWeapon(0)
                            else
                                set.ArmedWeapon(SlideWeapon)
                            end
                        end
                        if SHAcKvar.Switch == SHAcKvar.SwitchVelocity[0] then
                            set.ArmedWeapon(SHAcKvar.FiredGun)
                            if not weaponInfo[SHAcKvar.FiredGun].twohanded then
                                SHAcKvar.slidecancel = 1
                            end
                        end
                        if Movement.Slide.PerWeap.v and SHAcKvar.Switch > SHAcKvar.SwitchVelocity[1] or
                        not Movement.Slide.PerWeap.v and SHAcKvar.Switch > SHAcKvar.SwitchVelocity[1] then
                            if not Utils:IsKeyDown(32) and SHAcKvar.FiredGun ~= 26 or SHAcKvar.FiredGun == 26 and SHAcKvar.slidecancel == 1 then
                                SHAcKvar.canSlide = 0
                                Timer.Slide[0] = 0
                                SHAcKvar.slidecancel = 0
                            end
                        end
                        if Timer.Slide[1] == 1 then
                            SHAcKvar.SwitchVelocity[0] = v.cefini
                            v.cefini = 0
                            Timer.Slide[1] = 0
                        end
                        Timer.Slide[2] = 0
                    end
                else
                    SHAcKvar.Duration = 0
                    if SHAcKvar.Switch ~= -2 then
                        SHAcKvar.Switch = -2
                    end
                    if Timer.Slide[1] == 1 then
                        if SHAcKvar.SwitchVelocity[0] ~= v.cefini then
                            SHAcKvar.SwitchVelocity[0] = v.cefini
                        end
                        if v.cefini ~= 0 then
                            v.cefini = 0
                        end
                        if Timer.Slide[1] ~= 0 then
                            Timer.Slide[1] = 0
                        end
                        SHAcKvar.SpeedSlide = 0
                    end
                    SHAcKvar.Duration = 0
                    SpeedChance = -1
                end
            end
        --Double Jump
            if Doublejump.Enable.v then
                if Doublejump.OnKey.v and Utils:IsKeyDown(Doublejump.Key.v) or Doublejump.OnKey.v == false and Utils:IsKeyDown(16) then
                    if SHAcKvar.KeyPressed == 0 then
                        local bsData = BitStream()
                        bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fX)
                        bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fY)
                        bsWrap:WriteFloat(bsData, Doublejump.Height.v)
                        EmulRPC(90, bsData)
                        bsWrap:ResetWritePointer(bsData)
                        SHAcKvar.KeyPressed = 1
                    end
                else
                    if SHAcKvar.KeyPressed ~= 0 then
                        SHAcKvar.KeyPressed = 0
                    end
                end
            end
        --AntiStun
            if Movement.AntiStun.Enable.v then

                if Movement.AntiStun.AFK.v then
                    if(vMy.OFData.Speed.fX == 0 and vMy.OFData.Speed.fY == 0 and vMy.OFData.Speed.fZ == 0) then
                        Timer.AFK = Timer.AFK + 1
                    else
                        Timer.AFK = 0
                    end
                    if Timer.AFK > 10 then
                        v.SniperProt = 1
                        Movement.AntiStun.On = 0
                    else
                        v.SniperProt = 0
                    end
                else
                    v.SniperProt = 0
                end
                if(vMy.OFData.sCurrentAnimationID > 1070) and (vMy.OFData.sCurrentAnimationID < 1087) or (vMy.OFData.sCurrentAnimationID > 1172) and (vMy.OFData.sCurrentAnimationID < 1179 ) then
                    if(v.StunTimer == 0) then
                        if v.SniperProt ~= 1 then
                            v.KBDraw2 = 1
                            v.StunCount = v.StunCount + Movement.AntiStun.IncreaseMinChance.v
                            v.SmartStunCount = 0
                            v.StunTimer = 1
                            Movement.AntiStun.On = 0
                        end
                    end
                else
                    v.StunTimer = 0
                end
                if(v.SniperProt == 1) then
                    if v.SniperProtEnable ~= 1 then v.SniperProtEnable = 1 end
                else
                    if v.SniperProtEnable ~= 0 then v.SniperProtEnable = 0 end
                end
                Timer.Indicator1 = Timer.Indicator1 + 1
                Timer.Indicator2 = Timer.Indicator2 + 1
                if Timer.Indicator1 > 250 then
                    v.KBDraw1 = 0
                    Timer.Indicator1 = 0
                end
                if Timer.Indicator2 > 250 then
                    v.KBDraw2 = 0
                    Timer.Indicator2 = 0
                end
                if v.StunCount > 99 then
                    v.StunCount = 100
                end
                if v.StunCount > Movement.AntiStun.MinChance.v then
                    v.SmartStunCount = v.SmartStunCount + 1
                end
                if v.StunCount < Movement.AntiStun.MinChance.v then
                    v.StunCount = Movement.AntiStun.MinChance.v
                end
                if Movement.AntiStun.Chance == true and v.SniperProt ~= 1 then
                    Movement.AntiStun.SaveDamageHP = vMy.OFData.Health
                    Movement.AntiStun.SaveDamageAR = vMy.OFData.Armor
                    if Godmode.PlayerEnable.v == false or Godmode.PlayerEnable.v and Godmode.PlayerBullet.v == false then
                        if Movement.AntiStun.On == 0 then    
                            memory.CPed.God = Utils:readMemory(CPedST+0x42, 1, false)
                            Utils:writeMemory(CPedST+0x42, memory.CPed.God+4, 1, false)
                            Movement.AntiStun.On = 1
                        end
                    end
                else
                    if Godmode.PlayerEnable.v == false or Godmode.PlayerEnable.v and Godmode.PlayerBullet.v == false then
                        if Movement.AntiStun.On == 1 then
                            memory.CPed.God = Utils:readMemory(CPedST+0x42, 1, false)
                            Utils:writeMemory(CPedST+0x42, memory.CPed.God-4, 1, false)
                            Movement.AntiStun.On = 0
                        end
                    end
                end
            end
        --FakeLag Peek
            if Movement.FakeLagPeek.Enable.v then
                local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                vMy.NearestWall4FakeLag = get.nearwall(vMyPos, Movement.FakeLagPeek.DistanceFromWall.v)
                --vMyLag.fZ = vMyLag.fZ + 0.5
                if not vAmI.Passenger and not vAmI.Driver then
                    if Movement.FakeLagPeek.AtTarget.v then 
                        for i, _ in pairs(players.id) do
                            if Players:isPlayerStreamed(i) then
                                if not vAmI.Passenger and not vAmI.Driver then
                                    if Players:getPlayerTarget(Movement.FakeLagPeek.Fov.v*20) == i then
                                        local vEnPos = Players:getPlayerPosition(i)
                                        if Utils:IsLineOfSightClear(vMyPos, vEnPos, true, true ,false, true, false, false, false) == false then
                                            if vMy.NearestWall4FakeLag then
                                                if v.TargetFakeLag == i then
                                                    SHAcKvar.DesyncDelay = 0
                                                    SHAcKvar.DesyncTimer = 0
                                                    Movement.FakeLagPeek.Ready[i] = -1
                                                    v.TargetFakeLag = -1
                                                else
                                                    Movement.FakeLagPeek.Ready[i] = i
                                                end
                                            end
                                        else
                                            if Movement.FakeLagPeek.Ready[i] == i then
                                                if SHAcKvar.DesyncTimer == 0 then
                                                    SHAcKvar.DesyncTimer = 1
                                                    SHAcKvar.DesyncDelay = 1
                                                    v.TargetFakeLag = i
                                                end
                                                Movement.FakeLagPeek.Ready[i] = -1
                                            end
                                        end
                                    else
                                        if Players:getPlayerTarget(Movement.FakeLagPeek.Fov.v*20) == -1 then
                                            SHAcKvar.DrawWall = 0
                                            v.TargetFakeLag = 1
                                            SHAcKvar.DesyncTimer = 0
                                            SHAcKvar.DesyncDelay = 0
                                            
                                            Movement.FakeLagPeek.Ready[i] = -1
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if vMy.NearestWall4FakeLag == true then
                            if v.TargetFakeLag ~= 1 then  v.TargetFakeLag = 1 end
                            if SHAcKvar.DesyncTimer ~= 0 then SHAcKvar.DesyncTimer = 0 end
                            if SHAcKvar.DesyncDelay ~= 0 then SHAcKvar.DesyncDelay = 0 end
                        else
                            if v.TargetFakeLag == 1 then
                                if SHAcKvar.DesyncTimer == 0 then
                                    SHAcKvar.DesyncTimer = 1
                                    SHAcKvar.DesyncDelay = 1
                                end
                                if v.TargetFakeLag ~= -1 then v.TargetFakeLag = -1 end
                            end
                        end
                    end
                end
            end
        --Skin
            if Movement.ForceSkin.v and Movement.ChosenSkin.v ~= Players:getPlayerSkin(vMy.ID) then
                set.ClearPlayerAnimations()
                set.PlayerSkin(Movement.ChosenSkin.v)
                set.ClearPlayerAnimations()
            end
        --NoFall
            if Movement.NoFall.v or v.NoFall >= 2 then
                if vMy.OFData.sCurrentAnimationID >= 1128 and vMy.OFData.sCurrentAnimationID <= 1130 and v.NoFall == 0 then
                    local vMyBone = Players:getBonePosition(vMy.ID, 44)
                    if Utils:IsLineOfSightClear(CVector(vMyBone.fX, vMyBone.fY, vMyBone.fZ), CVector(vMyBone.fX, vMyBone.fY, vMyBone.fZ-2.5), true, true ,false, true, false, false, false) == false then
                        if Movement.NoFallNodamage.v then
                            if Godmode.PlayerEnable.v == false or Godmode.PlayerEnable.v and Godmode.PlayerCollision.v == false then
                                Utils:writeMemory(CPedST+0x42, 16, 1, false)
                            end
                        end
                        v.NoFall = 1
                    end
                end
                if v.NoFall >= 2 then
                    if vMy.OFData.sCurrentAnimationID == 1208 or vMy.OFData.sCurrentAnimationID == 1129 then
                        set.ClearPlayerAnimations()
                    end
                    v.NoFall = v.NoFall + 1
                    if v.NoFall > 25 then
                        if Movement.NoFallNodamage.v then
                            if Godmode.PlayerEnable.v == false or Godmode.PlayerEnable.v and Godmode.PlayerCollision.v == false then
                                Utils:writeMemory(CPedST+0x42, 0, 1, false)
                            end
                        end
                        v.NoFall = 0 
                    end
                end
            end
    --Miscellaneous
        --Hide Temp Objects 
            local fX = Utils:getResolutionX() * 0.5
            local fY = Utils:getResolutionY() * 0.5
            local ObjScreen = CVector()
            local nearestfromcrosshair = maths.getLowerIn(objects.fov)
            if Extra.RemoveObjectTemp.Enable.v or SHAcKvar.SaveObjectTimer ~= 0 then
                if Utils:IsKeyDown(Extra.RemoveObjectTemp.Key.v) then
                    if nearestfromcrosshair ~= nil then
                        local ObjectLoc = Objects:getObjectPosition(nearestfromcrosshair)
                        Utils:GameToScreen(ObjectLoc, ObjScreen)
                        vMyScreen = CVector(fX+107, fY-107, 0)
                        if ObjScreen.fZ > 1 then
                            if SHAcKvar.SaveObjectPos[nearestfromcrosshair] == nil then
                                Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,ObjScreen.fX,ObjScreen.fY,0xFF000000)      
                                Render:DrawCircle(ObjScreen.fX, ObjScreen.fY, 10, true, 0x9F0040FF) 
                                local distance = Utils:Get3Ddist(vMy.Pos, ObjectLoc)
                                Render:DrawText("Remove Object "..nearestfromcrosshair, ObjScreen.fX,ObjScreen.fY+10,0x9F0040FF)
                                Render:DrawText("(dist: ".. distance .."m)",ObjScreen.fX,ObjScreen.fY+25,0x6F00FF00)
                                if Utils:IsKeyChecked(2, 100) then
                                    SHAcKvar.SaveObjectPos[nearestfromcrosshair] = ObjectLoc
                                    local bsData = BitStream()
                                    bsWrap:Write16(bsData, nearestfromcrosshair)
                                    bsWrap:WriteFloat(bsData, 0)
                                    bsWrap:WriteFloat(bsData, 0)
                                    bsWrap:WriteFloat(bsData, 122333444455555)
                                    EmulRPC(45,bsData)
                                    SHAcKvar.SaveObjectDelay[nearestfromcrosshair] = 1
                                    SHAcKvar.SaveObjectTimer = 1
                                    Utils:emulateGTAKey(2, 0)
                                end
                            end
                        end
                    end
                end
                for i = 0, SAMP_MAX_OBJECTS do
                    if SHAcKvar.SaveObjectDelay[i] ~= nil and SHAcKvar.SaveObjectPos[i] ~= nil then
                        SHAcKvar.SaveObjectDelay[i] = SHAcKvar.SaveObjectDelay[i] + 1
                        if SHAcKvar.SaveObjectDelay[i] > Extra.RemoveObjectTemp.Time.v then
                            local bsData = BitStream()
                            bsWrap:Write16(bsData, i)
                            bsWrap:WriteFloat(bsData, SHAcKvar.SaveObjectPos[i].fX)
                            bsWrap:WriteFloat(bsData, SHAcKvar.SaveObjectPos[i].fY)
                            bsWrap:WriteFloat(bsData, SHAcKvar.SaveObjectPos[i].fZ)
                            EmulRPC(45,bsData)
                            SHAcKvar.SaveObjectTimer = 0
                            SHAcKvar.SaveObjectPos[i] = nil
                            SHAcKvar.SaveObjectDelay[i] = nil
                        end
                    end
                end
            end
        --Vehicles
            --AntiCarFlip
                if Vehicle.AntiCarFlip.v then
                    if vAmI.Driver then
                        local Angle = math.atan((vehicles.Quats.w * vehicles.Quats.w) - (vehicles.Quats.x * vehicles.Quats.x) - (vehicles.Quats.y * vehicles.Quats.y) + (vehicles.Quats.z * vehicles.Quats.z))
                        memory.CVehicle.Surface = Utils:readMemory(CVehicleST+0x41, 1, false)
                        if vMy.ICData.VehicleID ~= 0 and Angle < -0.1 and memory.CVehicle.Surface == 2 then
                            local deltaX = (vMy.ICData.Speed.fX+vMy.ICData.Pos.fX)-vMy.ICData.Pos.fX
                            local deltaY = (vMy.ICData.Speed.fY+vMy.ICData.Pos.fY)-vMy.ICData.Pos.fY
                            local radians = math.atan2(deltaY, deltaX)
                            local degrees = (radians * 180) / math.pi - 90
                            local bsDatas = BitStream()
                            bsWrap:Write16(bsDatas, IC.VehicleID) 
                            bsWrap:WriteFloat(bsDatas, degrees)
                            EmulRPC(160, bsDatas)
                        end
                    end
                end
            --PerfectHandling
                if Vehicle.PerfectHandling.v then
                    memory.CVehicle.PerfectHandling = Utils:readMemory(0x96914C, 1, false)
                    if Vehicle.PerfectHandlingOnKey.v then
                        if Utils:IsKeyDown(Vehicle.PerfectHandlingKey.v) then
                            if memory.CVehicle.PerfectHandling == 0 then
                                Utils:writeMemory(0x96914C, 1, 1, false)
                            end
                        else
                            if memory.CVehicle.PerfectHandling == 1 then
                                Utils:writeMemory(0x96914C, 0, 1, false)
                            end
                        end
                    else
                        if memory.CVehicle.PerfectHandling == 0 then
                            Utils:writeMemory(0x96914C, 1, 1, false)
                        end
                    end 
                else
                    if memory.CVehicle.PerfectHandling ~= 0 then
                        Utils:writeMemory(0x96914C, 0, 1, false)
                    end
                end
            --Never Off Engine
                if vAmI.Driver then
                    if Vehicle.NeverOffEngine.v then
                        memory.CVehicle.Engine = Utils:readMemory(CVehicleST+0x428, 1, false)
                        if memory.CVehicle.Engine == 0 then
                            Utils:writeMemory(CVehicleST+0x428, 24, 4, false)
                        end
                    end
                    if Vehicle.NeverPopTire.v then
                        memory.CVehicle.CarTire1 = Utils:readMemory(CVehicleST+0x5A5, 1, false)
                        if memory.CVehicle.CarTire1 == 1 then
                            Utils:writeMemory(CVehicleST+0x5A5, 0, 1, false)
                        end
                        memory.CVehicle.CarTire2 = Utils:readMemory(CVehicleST+0x5A6, 1, false)
                        if memory.CVehicle.CarTire2 == 1 then
                            Utils:writeMemory(CVehicleST+0x5A6, 0, 1, false)
                        end
                        memory.CVehicle.CarTire3 = Utils:readMemory(CVehicleST+0x5A7, 1, false)
                        if memory.CVehicle.CarTire3 == 1 then
                            Utils:writeMemory(CVehicleST+0x5A7, 0, 1, false)
                        end
                        memory.CVehicle.CarTire4 = Utils:readMemory(CVehicleST+0x5A8, 1, false)
                        if memory.CVehicle.CarTire4 == 1 then
                            Utils:writeMemory(CVehicleST+0x5A8, 0, 1, false)
                        end
                        memory.CVehicle.BikeTire1 = Utils:readMemory(CVehicleST+0x65C, 1, false)
                        if memory.CVehicle.BikeTire1 == 1 then
                            Utils:writeMemory(CVehicleST+0x65C, 0, 1, false)
                        end
                        memory.CVehicle.BikeTire2 = Utils:readMemory(CVehicleST+0x65D, 1, false)
                        if memory.CVehicle.BikeTire2 == 1 then
                            Utils:writeMemory(CVehicleST+0x65D, 0, 1, false)
                        end
                    end
            --Freeze Rot
                local vModel = Cars:getCarModel(vMy.Vehicle)
                if Vehicle.FreezeRot.v then
                    if vehicleInfo[vModel].type ~= VehicleType.Heli and vehicleInfo[vModel].type ~= VehicleType.Plane then
                        --PrintConsole("model: "..vehicleInfo[vModel].name)
                        local ptr2 = CVehicleST + 185
                        local value = Utils:readMemory(ptr2,1,false)
                        if value == 0 then
                            ptr2 = CVehicleST + 0x50
                            ptr3 = ptr2 + 4
                            ptr4 = ptr3 + 4
                            local value1 = Utils:readMemory(ptr2,1,false)
                            local value2 = Utils:readMemory(ptr3,1,false)
                            local value3 = Utils:readMemory(ptr4,1,false)
                            Utils:writeMemory(ptr2,0,4,false)
                            Utils:writeMemory(ptr3,0,4,false)
                            Utils:writeMemory(ptr4,0,4,false)
                        end
                    end
                end
            --VehicleSpam
                if Utils:IsKeyDown(87) then
                    memory.CVehicle.Surface = Utils:readMemory(CVehicleST+0x41, 1, false)
                    if memory.CVehicle.Surface ~= 0 then
                        local car = Players:getVehicleID(Players:getLocalID())
                        local vModel = Cars:getCarModel(car)
                        if vehicleInfo[vModel].type == VehicleType.Bike then
                            if Vehicle.AutoMotorbike.v then
                                if (ms.update(deltaTime)) then
                                    SHAcKvar.VehicleSpam = SHAcKvar.VehicleSpam + 1
                                end
                                if SHAcKvar.VehicleSpam > Vehicle.MotorbikeDelay.v then
                                    SHAcKvar.VehicleSpam = 0
                                end
                                if SHAcKvar.VehicleSpam < Vehicle.MotorbikeDelay.v*0.5 then
                                    Utils:writeMemory(0xB72ED6, 0, 1, false)
                                else
                                    Utils:writeMemory(0xB72ED6, 255, 1, false)
                                end
                            end
                        else
                            if vehicleInfo[vModel].type == VehicleType.Bicycle then
                                if Vehicle.AutoBike.v then
                                    if (ms.update(deltaTime)) then
                                        SHAcKvar.VehicleSpam = SHAcKvar.VehicleSpam + 1
                                    end
                                    if SHAcKvar.VehicleSpam > Vehicle.BikeDelay.v then
                                        SHAcKvar.VehicleSpam = 0
                                    end
                                    if SHAcKvar.VehicleSpam < Vehicle.BikeDelay.v*0.5 then
                                        Utils:writeMemory(0xB72D76, 0, 1, false)
                                    else
                                        Utils:writeMemory(0xB72D76, 255, 1, false)
                                    end
                                end
                            end
                        end
                    else
                        if SHAcKvar.VehicleSpam > Vehicle.MotorbikeDelay.v*0.5 then
                            Utils:writeMemory(0xB72ED6, 0, 1, false)
                        end
                    end
                else
                    if SHAcKvar.VehicleSpam > Vehicle.MotorbikeDelay.v*0.5 or SHAcKvar.VehicleSpam > Vehicle.BikeDelay.v*0.5 then
                        Utils:writeMemory(0xB72ED6, 0, 1, false)
                        Utils:writeMemory(0xB72D76, 0, 1, false)
                        SHAcKvar.VehicleSpam = 0
                    end
                end
            --VehicleGod
                if Vehicle.Recovery.v then
                    local bsData = BitStream()
                    if vMy.Vehicle == 65535 then
                        vMy.Vehicle = 0
                    end
                    if vMy.ICData.HealthCar + Vehicle.HPAmount.v < 999 then
                        SHAcKvar.Timer[0] = SHAcKvar.Timer[0] + 1
                        if SHAcKvar.Timer[0] > Vehicle.ChosenTimer.v and vMy.ICData.HealthCar + Vehicle.HPAmount.v < 999 then
                            bsWrap:Write16(bsData, vMy.Vehicle) 
                            bsWrap:WriteFloat(bsData, vMy.OFData.HealthCar + Vehicle.HPAmount.v) 
                            EmulRPC(147,bsData)
                            bsWrap:ResetWritePointer(bsData)
                            SHAcKvar.Timer[0] = 0
                        end
                    else
                        if vMy.ICData.HealthCar < 999 then
                            SHAcKvar.Timer[0] = SHAcKvar.Timer[0] + 1
                            if SHAcKvar.Timer[0] > Vehicle.ChosenTimer.v then
                                bsWrap:Write16(bsData, vMy.Vehicle) 
                                bsWrap:WriteFloat(bsData, 999) 
                                EmulRPC(147,bsData)
                                bsWrap:ResetWritePointer(bsData)
                            end
                        else
                            if SHAcKvar.Timer[0] ~= 0 then
                                if Vehicle.RecoverParts.v then
                                    set.VehicleParts(vMy.Vehicle, 0, 0, 0, 0)
                                end
                                SHAcKvar.Timer[0] = 0
                            end
                        end
                    end
                    bsWrap:Reset(bsData)
                end
            --InfinityNitrous
                if Vehicle.InfinityNitrous.v then
                    local bsData = BitStream()
                    if vMy.Vehicle == 65535 then
                        vMy.Vehicle = 0
                    end
                    if Utils:IsKeyChecked(1, 0) or Utils:IsKeyChecked(17, 0) then
                        if Vehicle.InfinityNitrousType.v == 0 then 
                            bsWrap:Write16(bsData, 65535)
                            bsWrap:Write32(bsData, 2)
                            bsWrap:Write32(bsData, vMy.Vehicle)
                            bsWrap:Write32(bsData, 1010)
                            EmulRPC(96,bsData)
                        else
                            Utils:writeMemory(0x969165, 1, 1, false)
                        end
                    else
                        if Utils:IsKeyDown(1) == false and Utils:IsKeyDown(17) == false then
                            bsWrap:Write16(bsData, vMy.Vehicle)
                            bsWrap:Write16(bsData, 1010)
                            EmulRPC(57,bsData)
                            if Vehicle.InfinityNitrousType.v ~= 0 then 
                                Utils:writeMemory(0x969165, 0, 1, false)
                            end
                        end
                    end
                end
            --FastStop
                    --if Utils:IsKeyDown(32) then
                    --    if Surface ~= 0 then
                    --        local bsData = BitStream()
                    --        local data = vMy.ICData
                    --        bsWrap:Write8(bsData, 0)
                    --        bsWrap:WriteFloat(bsData, data.Speed.fX/1.2)
                    --        bsWrap:WriteFloat(bsData, data.Speed.fY/1.2)
                    --        bsWrap:WriteFloat(bsData, data.Speed.fZ/1.2)
                    --        EmulRPC(91, bsData)
                    --    end
                    --end
            --No Collision with OtherCars
                if Vehicle.NoCarCollision.v then
                    if Utils:IsKeyDown(Vehicle.NoCarCollisionKey.v) then
                        local bsData = BitStream()
                        bsWrap:WriteBool(bsData, true)
                        EmulRPC(167, bsData)
                    else
                        local bsData = BitStream()
                        bsWrap:WriteBool(bsData, false)
                        EmulRPC(167, bsData)
                    end
                end
                else
                    if SHAcKvar.VehicleSpam > Vehicle.MotorbikeDelay.v*0.5 or SHAcKvar.VehicleSpam > Vehicle.BikeDelay.v*0.5 then
                        Utils:writeMemory(0xB72ED6, 0, 1, false)
                        Utils:writeMemory(0xB72D76, 0, 1, false)
                        SHAcKvar.VehicleSpam = 0
                    end
                end
            --Car Jump
                if Vehicle.CarJump.v then
                    if Utils:IsKeyDown(Vehicle.CarJumpKey.v) and vAmI.Driver then
                        if SHAcKvar.CanJump == 0 then
                            local bsData = BitStream()
                            bsWrap:Write8(bsData, 0)
                            bsWrap:WriteFloat(bsData, vMy.ICData.Speed.fX)
                            bsWrap:WriteFloat(bsData, vMy.ICData.Speed.fY)
                            bsWrap:WriteFloat(bsData, Vehicle.Height.v)
                            EmulRPC(91, bsData)
                            bsWrap:ResetWritePointer(bsData)
                            SHAcKvar.CanJump = 1
                        end
                    else
                        if SHAcKvar.CanJump ~= 0 then
                            SHAcKvar.CanJump = 0
                        end
                    end
                end
        --Godmode
            --Vehicle
                if Godmode.VehicleEnable.v or Godmode.InvisibleCar == 1 then
                    if vAmI.Driver then
                        if Vehicle ~= 0 then
                            local CVehicle = Utils:readMemory(0xB6F980, 4, false)
                            local value = 0
                            if Godmode.VehicleCollision.v or Godmode.InvisibleCar == 1 then
                                value = value + 16
                            end
                            if Godmode.VehicleMelee.v or Godmode.InvisibleCar == 1 then
                                value = value + 32
                            end
                            if Godmode.VehicleBullet.v or Godmode.InvisibleCar == 1 then
                                value = value + 4
                            end
                            if Godmode.VehicleFire.v or Godmode.InvisibleCar == 1 then
                                value = value + 8
                            end
                            if Godmode.VehicleExplosion.v or Godmode.InvisibleCar == 1 then
                                value = value + 128
                            end
                            --values = Utils:readMemory(CVehicle+0x42, 1, true)
                            CVehicleST = Utils:readMemory(0xB6F980, 4, false)
                            memory.CVehicle.Godcar = Utils:readMemory(CVehicleST+0x42, 1, false)
                            if memory.CVehicle.Godcar ~= value then
                                Utils:writeMemory(CVehicleST+0x42, value, 1, false)
                            end
                        end
                    end
                end
            --Player
                if Godmode.PlayerEnable.v or v.NoFall ~= 0 and Movement.NoFallNodamage.v then
                    local value = 0
                    if Godmode.PlayerEnable.v and Godmode.PlayerCollision.v or v.NoFall ~= 0 and Movement.NoFallNodamage.v then
                        value = value + 16
                    end
                    if Godmode.PlayerEnable.v and Godmode.PlayerMelee.v then
                        value = value + 32
                    end
                    if Godmode.PlayerEnable.v and Godmode.PlayerBullet.v then
                        value = value + 4
                    end
                    if Godmode.PlayerEnable.v and Godmode.PlayerFire.v then
                        value = value + 8
                    end
                    if Godmode.PlayerEnable.v and Godmode.PlayerExplosion.v then
                        value = value + 128
                    end
                    CPedST = Utils:readMemory(0xB6F5F0, 4, false)
                    memory.CPed.God = Utils:readMemory(CPedST+0x42, 1, false)
                    if memory.CPed.God ~= value then
                        Utils:writeMemory(CPedST+0x42, value, 1, false)
                    end
                end
        --AntiFreeze
            if Extra.AntiFreeze.v then
                memory.CPed.Movement = Utils:readMemory(CPedST+0x41, 1, false)
                if memory.CPed.Movement == 34 or memory.CPed.Movement == 32 then
                    local bsData = BitStream()
                    bsWrap:Write8(bsData, 1)
                    EmulRPC(15,bsData)
                end
            end
        --Send CMD
            if Extra.SendCMD.Enable.v and get.isPlayerAlive(vMy.ID) then
                local health = Players:getPlayerHP(vMy.ID)
                local armour = Players:getPlayerArmour(vMy.ID)
                if Extra.SendCMD.HP.v < 100 and armour == 0 and health < Extra.SendCMD.HP.v or
                Extra.SendCMD.HP.v >= 100 and armour < Extra.SendCMD.Armour.v then
                    if(SendCMD.update(deltaTime)) and v.SendCMD < Extra.SendCMD.Times.v then
                        local cmd = Extra.SendCMD.Command.v
                        if not string.find(cmd, "/") then
                            cmd = "/" .. cmd
                        end
                        Utils:SayChat(cmd)
                        v.SendCMD = v.SendCMD + 1
                        SendCMD = Timers(Extra.SendCMD.Delay.v)
                    end
                else
                    v.SendCMD = 0
                    SendCMD = Timers(1)
                end
            end
        --PickUP
            if Extra.PickUP.Enable.v and get.isPlayerAlive(vMy.ID) then
                local health = Players:getPlayerHP(vMy.ID)
                local armour = Players:getPlayerArmour(vMy.ID)
                if Extra.PickUP.HP.v < 100 and armour == 0 and health < Extra.PickUP.HP.v or
                Extra.PickUP.HP.v >= 100 and armour < Extra.PickUP.Armour.v then
                    if(PickUP.update(deltaTime)) then
                        local vMyPos = Players:getPlayerPosition(Players:getLocalID())

                        local closestPickupID = nil
                    
                        local poolPtr = get.PickupPool()
                        local ptwo = Utils:readMemory(poolPtr, 4, false)
                        if ptwo > 0 then
                            ptwo = poolPtr + 0x4
                            local pthree = poolPtr + 0xF004
                            for id = 1, 4096 do
                                local pfive = Utils:readMemory(ptwo + id * 4, 4, false)
                                if pfive < 0 or pfive > 0 then
                                    pfive = Utils:readMemory(pthree + id * 20, 4, false)
                                    if pfive == Extra.PickUP.Model1.v or pfive == Extra.PickUP.Model2.v or pfive == Extra.PickUP.Model3.v then
                                        closestPickupID = modelID
                                        local bData = BitStream()
                                        bsWrap:Write32(bData, id)
                                        SendRPC(131,bData)
                                        break 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        --Extra WS
            if KeyToggle.ExtraWS.v == 1 then
                memory.ExtraWS.v1 = Utils:readMemory(0x5109AC, 1, false)
                memory.ExtraWS.v2 = Utils:readMemory(0x5109C5, 1, false)
                memory.ExtraWS.v3 = Utils:readMemory(0x5231A6, 1, false)
                memory.ExtraWS.v4 = Utils:readMemory(0x52322D, 1, false)
                memory.ExtraWS.v5 = Utils:readMemory(0x5233BA, 1, false)
                if Extra.ExtraWS.X.v or Extra.ExtraWS.Y.v then
                    if Extra.ExtraWS.PerCategory.Enable.v and Extra.ExtraWS.PerCategory.Pistols.v and weaponInfo[vMy.Weapon].slot == 2 or
                    Extra.ExtraWS.PerCategory.Enable.v and Extra.ExtraWS.PerCategory.Shotguns.v and weaponInfo[vMy.Weapon].slot == 3 or 
                    Extra.ExtraWS.PerCategory.Enable.v and Extra.ExtraWS.PerCategory.SMGs.v and weaponInfo[vMy.Weapon].slot == 4 or 
                    Extra.ExtraWS.PerCategory.Enable.v and Extra.ExtraWS.PerCategory.Rifles.v and weaponInfo[vMy.Weapon].slot == 5 or
                    Extra.ExtraWS.PerCategory.Enable.v and Extra.ExtraWS.PerCategory.Snipers.v and weaponInfo[vMy.Weapon].slot == 6 or 
                    Extra.ExtraWS.PerCategory.Enable.v == false then
                        if Extra.ExtraWS.X.v and Extra.ExtraWS.Y.v then
                            if memory.ExtraWS.v1 ~= 235 then Utils:writeMemory(0x5109AC, 235, 1, true) end 
                            if memory.ExtraWS.v2 ~= 235 then Utils:writeMemory(0x5109C5, 235, 1, true) end
                            if memory.ExtraWS.v3 ~= 235 then Utils:writeMemory(0x5231A6, 235, 1, true) end
                            if memory.ExtraWS.v4 ~= 235 then Utils:writeMemory(0x52322D, 235, 1, true) end
                            if memory.ExtraWS.v5 ~= 235 then Utils:writeMemory(0x5233BA, 235, 1, true) end
                        elseif Extra.ExtraWS.X.v then
                            if memory.ExtraWS.v1 ~= 235 then Utils:writeMemory(0x5109AC, 235, 1, true) end 
                            if memory.ExtraWS.v2 ~= 235 then Utils:writeMemory(0x5109C5, 235, 1, true) end
                            if memory.ExtraWS.v3 ~= 235 then Utils:writeMemory(0x5231A6, 235, 1, true) end
                            if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, true) end
                            if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, true) end
                        elseif Extra.ExtraWS.Y.v then
                            if memory.ExtraWS.v1 ~= 235 then Utils:writeMemory(0x5109AC, 235, 1, true) end 
                            if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, true) end
                            if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, true) end
                            if memory.ExtraWS.v4 ~= 235 then Utils:writeMemory(0x52322D, 235, 1, true) end
                            if memory.ExtraWS.v5 ~= 235 then Utils:writeMemory(0x5233BA, 235, 1, true) end
                        end
                    else
                        if memory.ExtraWS.v1 == 235 then Utils:writeMemory(0x5109AC, 0x7a, 1, true) end
                        if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, true) end
                        if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, true) end
                        if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, true) end
                        if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, true) end
                    end
                else
                    if memory.ExtraWS.v1 == 235 then Utils:writeMemory(0x5109AC, 0x7a, 1, true) end
                    if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, true) end
                    if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, true) end
                    if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, true) end
                    if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, true) end
                end
            else
                if memory.ExtraWS.v1 == 235 then Utils:writeMemory(0x5109AC, 0x7a, 1, true) end
                if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, true) end
                if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, true) end
                if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, true) end
                if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, true) end
            end
        --Teleports
            if Teleport.Enable.v then
            --Teleport To Objects
                if Teleport.toObject.v or SHAcKvar.Teleporting[5] == 1 then
                    local ObjScreen = CVector()
                    if Utils:IsKeyDown(Teleport.ObjectKey.v) then
                        for j = 0, SAMP_MAX_OBJECTS do 
                            if Objects:isObjectOnServer(j) then
                                local ObjectLoc = Objects:getObjectPosition(j)
                                Utils:GameToScreen(ObjectLoc, ObjScreen)
                                vMyScreen = CVector(fX+107, fY-107, 0)
                                local distance = Utils:Get2Ddist(vMy .Pos, ObjectLoc)
                                if  distance < 1000 then
                                    if ObjScreen.fZ > 1 then
                                        if j == nearestfromcrosshair then
                                            if SHAcKvar.Teleporting[5] ~= 1 then
                                                local ObjectLoc = Objects:getObjectPosition(j)
                                                Utils:GameToScreen(ObjectLoc, ObjScreen)
                                                vMyScreen = CVector(fX+107, fY-107, 0)
                                            else
                                                local ObjectLoc = Objects:getObjectPosition(SHAcKvar.Object)
                                                Utils:GameToScreen(ObjectLoc, ObjScreen)
                                                vMyScreen = CVector(fX+107, fY-107, 0)
                                            end
                                            local i 
                                            if SHAcKvar.Object ~= nil then i = SHAcKvar.Object end
                                            Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,ObjScreen.fX,ObjScreen.fY,0xFF000000)      
                                            Render:DrawText("TELEPORT TO OBJECT: ID[".. j .."]",ObjScreen.fX,ObjScreen.fY+60,0x9F0040FF)
                                            Render:DrawCircle(ObjScreen.fX, ObjScreen.fY, 10, true, 0x9F0040FF) 
                                            if Utils:IsKeyChecked(2, 0) and SHAcKvar.Teleporting[5] ~= 1 then
                                                SHAcKvar.Object = j
                                                SHAcKvar.Teleporting[5] = 1
                                            end
                                        else
                                            if SHAcKvar.Teleporting[5] ~= 1 then
                                                Render:DrawCircle(ObjScreen.fX, ObjScreen.fY, 2, true, 0x6FFF0000) 
                                                Render:DrawText(""..j, ObjScreen.fX,ObjScreen.fY,0x6F00FF00)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if SHAcKvar.Teleporting[5] == 1 then
                        if Utils:IsKeyDown(Teleport.ObjectKey.v) == false then
                            SHAcKvar.Teleporting[1] = 2
                            local ObjectLoc = Objects:getObjectPosition(SHAcKvar.Object)
                            TeleportPlayerTo(ObjectLoc)
                        else
                            local ObjectLoc = Objects:getObjectPosition(SHAcKvar.Object)
                            TeleportPlayerTo(ObjectLoc)
                        end
                    end
                end
            --Attach To Vehicle (Surfing)
                if Teleport.AttachToVehicle.v then
                    local vehpos = CVector()
                    if not vAmI.Passenger then
                        if vMy.OFData.sSurfingVehicleID ~= 0 then
                            if not Utils:IsKeyDown(87) and not Utils:IsKeyDown(83) and not Utils:IsKeyDown(65) and not Utils:IsKeyDown(68) then
                                SHAcKvar.AttachToVehicleID = vMy.OFData.sSurfingVehicleID
                                vehpos = Cars:getCarPosition(SHAcKvar.AttachToVehicleID)
                                vehpos.fZ = vehpos.fZ + 1
                                --local distance = Utils:Get3Ddist(vehpos , vMy.Pos)
                                SHAcKvar.Attached = 1
                                if vehpos.fZ > vMy.Pos.fZ+3 then 
                                    Players:setPosition(vehpos)
                                end
                            else
                                SHAcKvar.Attached = 0
                            end
                        else
                            if SHAcKvar.Attached == 1 then
                                if Utils:IsKeyDown(87) or Utils:IsKeyDown(83) or Utils:IsKeyDown(65) or Utils:IsKeyDown(68) then
                                    SHAcKvar.Attached = 0
                                end
                                local passenger = Cars:getHavePassenger(SHAcKvar.AttachToVehicleID,0)
                                vehpos = Cars:getCarPosition(SHAcKvar.AttachToVehicleID)
                                vehpos.fZ = vehpos.fZ + math.random(1,2)
                                if passenger == true then
                                    Players:setPosition(vehpos)
                                else
                                    SHAcKvar.Attached = 0
                                end
                            end
                        end
                    else
                        SHAcKvar.Attached = 0
                    end
                end        
            --Teleport To Players
                if Teleport.toPlayer.v and Utils:IsKeyDown(Teleport.toPlayerKey.v) or SHAcKvar.Teleporting[3] == 1 then 
                    local nearestfromcrosshair = maths.getLowerIn(players.fov)
                    if nearestfromcrosshair ~= nil then
                        for i, _ in pairs(players.id) do
                            if Players:isPlayerStreamed(i) then
                                local names = Players:getPlayerName(i)
                                local center = string.len(names) * 4
                                if Utils:isOnScreen(i) then
                                    local TeleportBone = Players:getBonePosition(i, 2)
                                    local NameToScreen = CVector()
                                    Utils:GameToScreen(TeleportBone, NameToScreen)
                                    NameToScreen.fX = NameToScreen.fX - center
                                    Utils:GameToScreen(TeleportBone, vEnScreen)
                                    if Utils:IsKeyDown(Teleport.toPlayerKey.v) or SHAcKvar.Teleporting[3] == 1 then
                                        if i == nearestfromcrosshair or i == nearestfromcrosshair and SHAcKvar.Teleporting[3] == 1 then  
                                            Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,vEnScreen.fX,vEnScreen.fY,0xFF000000)      
                                            Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 10, true, 0x7F0040FF) 
                                            Render:DrawText( names.." ("..i..")", NameToScreen.fX-25,NameToScreen.fY+25,Players:getPlayerColor(i))
    
                                            local vEnDriver = Players:isDriver(i)
                                            if vEnDriver then
                                                Render:DrawText("DRIVING",NameToScreen.fX-25,NameToScreen.fY+45,0xFF0040FF)
                                            end  
                                            if Utils:IsKeyChecked(2, 0) and SHAcKvar.Teleporting[3] ~= 1 then
                                                SHAcKvar.Player = i
                                                SHAcKvar.Teleporting[3] = 1
                                            end
                                        else   
                                            if SHAcKvar.Teleporting[3] ~= 1 then
                                                Render:DrawText( names.." ("..i..")", NameToScreen.fX-10,NameToScreen.fY+10,Players:getPlayerColor(i))
                                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 5, true, 0x6Ff040FF) 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if SHAcKvar.Teleporting[3] == 1 then
                            if Utils:IsKeyDown(Teleport.toPlayerKey.v) == false then
                                SHAcKvar.Teleporting[1] = 2
                                TeleportPlayerTo(LastPosPlayer)
                            elseif Players:isPlayerStreamed(SHAcKvar.Player) then
                                LastPosPlayer = Players:getPlayerPosition(SHAcKvar.Player)
                                TeleportPlayerTo(LastPosPlayer)
                            else
                                SHAcKvar.Teleporting[1] = 2
                                TeleportPlayerTo(LastPosPlayer)
                            end
                        end
                    end
                end
            --Teleport to Vehicles
                if Teleport.toVehicle.v and Utils:IsKeyDown(Teleport.toVehicleKey.v) or SHAcKvar.Teleporting[6] == 1 then
                    local nearestfromcrosshair = maths.getLowerIn(vehicles.fov)
                    if nearestfromcrosshair ~= nil then
                        for i = 1, SAMP_MAX_VEHICLES do 
                            if Cars:isCarStreamed(i) then
                                local model = Cars:getCarModel(i)  
                                local center = string.len(vehicleInfo[model].name) * 3
                                local carHP = Cars:getCarHP(i)  
                                local Car = Cars:getCarPosition(i)
                                Utils:GameToScreen(Car, vEnScreen)
                                if vEnScreen.fZ > 1 then
                                    local NameToScreen = CVector()
                                    Utils:GameToScreen(Car, NameToScreen)
                                    NameToScreen.fX = NameToScreen.fX - center
                                    local nearestCar = nearestfromcrosshair
                                    if Utils:IsKeyDown(Teleport.toVehicleKey.v) or SHAcKvar.Teleporting[6] == 1 then
                                        if i == nearestCar or i == nearestCar and SHAcKvar.Teleporting[6] == 1 then
                                            local isSeatAvailable = Cars:getHavePassenger(nearestCar,0)
                                            local seat
                                            if Teleport.toVehicleDriver.v and nearestCar ~= vMy.Vehicle or not isSeatAvailable then
                                                seat = " [ Driver ] "
                                            else
                                                seat = " [ Passenger ] "
                                            end
                                            Render:DrawText( vehicleInfo[model].name.." (".. model ..") "..seat, NameToScreen.fX-25,NameToScreen.fY+25,0xFF0040FF)
                                            Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,vEnScreen.fX,vEnScreen.fY,0xFF000000)      
                                            Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 10, true, 0xFF0040FF)
                                            if Utils:IsKeyChecked(2, 0) then
                                                if SHAcKvar.SaveVehicle == 0 and SHAcKvar.Teleporting[6] ~= 1 then
                                                    SHAcKvar.Vehicle = nearestCar
                                                    SHAcKvar.Teleporting[6] = 1
                                                end
                                                SHAcKvar.SaveVehicle = 1
                                            else
                                                SHAcKvar.SaveVehicle = 0
                                            end
                                        else
                                            if SHAcKvar.Teleporting[6] ~= 1 then
                                                Render:DrawText( vehicleInfo[model].name.." (".. model ..")",NameToScreen.fX-25,NameToScreen.fY+10,0x9Ff040FF)
                                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 5, true, 0x8Ff040FF) 
                                            end
                                        end
                                    else
                                        if Utils:IsKeyDown(Teleport.toVehicleKey.v) == false then
                                            SHAcKvar.SaveVehicle = 0
                                        end
                                    end
                                end
                            end
                        end
                        if SHAcKvar.Teleporting[6] == 1 then
                            if Utils:IsKeyDown(Teleport.toVehicleKey.v) == false then
                                local pos = Cars:getCarPosition(SHAcKvar.Vehicle)
                                SHAcKvar.Teleporting[1] = 2
                                TeleportPlayerTo(pos)
                            elseif Cars:isCarStreamed(SHAcKvar.Vehicle) then
                                local pos = Cars:getCarPosition(SHAcKvar.Vehicle)
                                TeleportPlayerTo(pos)
                            else
                                SHAcKvar.Teleporting[1] = 2
                                TeleportPlayerTo(pos)
                            end
                        end
                    end
                else
                    if Utils:IsKeyDown(Teleport.toVehicleKey.v) == false then
                        SHAcKvar.SaveVehicle = 0
                    end
                end
            --Rage Teleport (HVH)
                if Teleport.HvH.v then
                    for i, _ in pairs(players.id) do
                        if Players:isPlayerStreamed(i) then
                            if Utils:IsKeyDown(Teleport.HvHKey.v) then
                                if Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(i) == false then
                                    SHAcKvar.HvHid[i] = i
                                    local HvHHealth = Players:getPlayerHP(SHAcKvar.HvHid[i])
                                    if Teleport.HVHDeath.v and HvHHealth > 0 or Teleport.HVHDeath.v == false then
                                        if Teleport.HVHAFK.v and Players:isPlayerAFK(SHAcKvar.HvHid[i]) == false or Teleport.HVHAFK.v == false then
                                            if SHAcKvar.HVHSavePos == 0 then
                                                SHAcKvar.HVHSavePos = vMy.Pos
                                            end
                                            if SHAcKvar.HVHWaitW[i] == nil or SHAcKvar.HVHWaitW[i] == NULL then
                                                SHAcKvar.HVHWaitW[i] = -1
                                            end
                                            SHAcKvar.HVHWaitW[i] = SHAcKvar.HVHWaitW[i] + 1 
                                            v.Wait = v.Wait + 1 
                                            if SHAcKvar.HVHWaitW[i] > Teleport.HVHWait.v and v.Wait > Teleport.HVHWait.v then
                                                SHAcKvar.HvHpos[i] = Players:getPlayerPosition(SHAcKvar.HvHid[i])
                                                if Players:Driving(SHAcKvar.HvHid[i]) then
                                                    SHAcKvar.HvHpos[i].fZ = SHAcKvar.HvHpos[i].fZ + 4
                                                end
                                                Players:setPosition(SHAcKvar.HvHpos[i])
                                                v.Wait = 0
                                                SHAcKvar.HVHWaitW[i] = -1
                                            end
                                        end
                                    end
                                end
                            else
                                if SHAcKvar.HVHSavePos ~= 0 then
                                    Players:setPosition(SHAcKvar.HVHSavePos)
                                    if vAmI.Passenger then
                                        set.VehicleZAngle(0)
                                    end
                                    SHAcKvar.HVHSavePos = 0
                                end
                                SHAcKvar.HVHWaitW[i] = 0
                                v.Wait = 0
                                SHAcKvar.HVHSavePos = 0
                            end
                        end
                    end
                end
            --Checkpoint
                if Teleport.toCheckpoint.v then
                    if SHAcKvar.CheckpointSave ~= 0.0 then 
                        if Utils:IsKeyDown(Teleport.CheckpointKey.v) then
                            SHAcKvar.Teleporting[4] = 1
                            TeleportPlayerTo(SHAcKvar.CheckpointSave)
                        else
                            if SHAcKvar.Teleporting[4] == 1 then
                                SHAcKvar.Teleporting[1] = 2
                                TeleportPlayerTo(SHAcKvar.CheckpointSave)
                            end
                        end
                    end
                end
            --AutoAttach
                if Vehicle.AutoAttachWaiting == 1 and Vehicle.AutoAttachTrailer.v then
                    Vehicle.AttachDelay = Vehicle.AttachDelay + 1
                    if Vehicle.SaveTrailer ~= -1 and Vehicle.AttachDelay > 100 and vMy.ICData.VehicleID == Vehicle.TrailerToVehicle then
                        local Angle = math.atan2(2 * ((vehicles.Quats.y * vehicles.Quats.z) + (vehicles.Quats.w * vehicles.Quats.x)), (vehicles.Quats.w * vehicles.Quats.w) - (vehicles.Quats.x * vehicles.Quats.x) - (vehicles.Quats.y * vehicles.Quats.y) + (vehicles.Quats.z * vehicles.Quats.z));
                        if Angle > -0.34 and Angle < 0.34  then
                            local bsDatas = BitStream()
                            bsWrap:Write16(bsDatas, Vehicle.SaveTrailer) 
                            bsWrap:Write16(bsDatas, Vehicle.TrailerToVehicle)
                            EmulRPC(148, bsDatas)
                            bsWrap:Reset(bsDatas)
                            bsWrap:Write16(bsDatas, Vehicle.SaveTrailer)
                            bsWrap:WriteFloat(bsDatas, 1000)
                            EmulRPC(147, bsDatas)
                            Vehicle.AutoAttachWaiting = 0; Vehicle.AttachDelay = 0
                        end
                    end
                end
            --Saved Pos
               for i, _ in pairs(Teleport.DelSaveTeleports) do
                    --if Teleport.DelSaveTeleports[i] ~= nil then
                        if Teleport.DelSaveTeleports[i] ~= nil and Teleport.DelSaveTeleports[i].v == true then
                            Teleport.SavedPos[i] = CVector()
                            Teleport.PosToScreen[i].fZ = 0
                            Teleport.DelSaveTeleports[i].v = false
                        end
                        if Teleport.SaveTeleports[i] ~= nil and Teleport.SaveTeleports[i].v == true then
                            Teleport.SavedPos[i] = Players:getPlayerPosition(Players:getLocalID())
                            Teleport.SaveTeleports[i].v = false
                        end
                        if Teleport.LoadTeleports[i] ~= nil and Teleport.LoadTeleports[i].v == true then
                            TeleportPlayerTo(Teleport.SavedPos[i])
                        end
                        if Teleport.ShowSaveTeleports.v and Teleport.SavedPos[i].fX ~= 0.0 then
                            Utils:GameToScreen(Teleport.SavedPos[i], Teleport.PosToScreen[i])
                        end
                    --end
                end
            end
    --Troll
        --VehicleSlapper
            if Troll.Slapper.Enable.v and (Utils:IsKeyDown(Troll.Slapper.Key.v) and Troll.Slapper.OnKey.v or not Troll.Slapper.OnKey.v) then
                local nearestVehicle = maths.getLowerIn(vehicles.crasher)
                if nearestVehicle and nearestVehicle ~= 65535 then
                    for i, _ in pairs(players.id) do
                        if not vAmI.Driver and not vAmI.Passenger and Players:isPlayerStreamed(i) and not Players:isPlayerInFilter(i) and not Players:isPlayerAFK(i) then
                            local names = Players:getPlayerName(i)
                            local center = string.len(names) * 4
                            local car = Cars:getCarPosition(nearestVehicle)
                            local   distance = Utils:Get3Ddist(car , vMy.Pos)
                            if Utils:isOnScreen(i) and  distance < 5 then
                                local nameToScreen = CVector()
                                local teleportBone = Players:getBonePosition(i, 2)
                                Utils:GameToScreen(teleportBone, nameToScreen)
                                Utils:GameToScreen(teleportBone, vEnScreen)
                                nameToScreen.fX = nameToScreen.fX - center
                                local nearestFromCrosshair = maths.getLowerIn(players.fov)
                                if nearestFromCrosshair and i == nearestFromCrosshair then
                                    local carToScreen = CVector()
                                    Utils:GameToScreen(car, carToScreen)
                                    Render:DrawLine(carToScreen.fX, carToScreen.fY, vEnScreen.fX, vEnScreen.fY, 0xFF000000)
                                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 10, true, 0x7F0040FF)
                                    Render:DrawText( names.."%s ID: "..i, nameToScreen.fX - 25, nameToScreen.fY + 25, Players:getPlayerColor(i))

                                    local vEnDriver = Players:isDriver(i)
                                    if vEnDriver then
                                        Render:DrawText("DRIVING", nameToScreen.fX - 25, nameToScreen.fY + 45, 0xFF0040FF)
                                    end
                                    if Utils:IsKeyChecked(2, 0) and SHAcKvar.KeyDelay == 0 then
                                        local pos = get.PlayerLag(i)
                                        local message = ImBuffer("Slapper - ".. Players:getPlayerName(i) .."(".. i ..")", 155)
                                        set.TextDraw(message, 0xFF8700FF, 2045, 15, 300)
                                        --if not vEn.Driver[i] andt not vEn.Passenger[i] then
                                        pos.fZ = pos.fZ - maths.randomFloat(1.3, 1.8)
                                    -- end
                                        send.UnoccupiedSync(nearestVehicle, pos.fX, pos.fY, pos.fZ, 0, 0, 10)
                                        --set.VehiclePos(nearestVehicle, pos.fX, pos.fY, pos.fZ)
                                        SHAcKvar.KeyDelay = 1
                                    else
                                        SHAcKvar.KeyDelay = 0
                                    end
                                else
                                    Render:DrawText( names.."%s ID: "..i ,nameToScreen.fX - 10, nameToScreen.fY + 10, Players:getPlayerColor(i))
                                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 5, true, 0x6Ff040FF)
                                end
                            end
                        end
                    end
                end
            end
        --RVanka
            if KeyToggle.RVanka.v == 1 or SHAcKvar.rVankanEWVAR > 0 then
                if SHAcKvar.rVankanEWVAR == 0 then
                    if(RVankaTimer1.update(deltaTime)) or SHAcKvar.rVankanEWVAR > 0 then
                        for i, _ in pairs(players.id) do
                            if Players:isPlayerStreamed(i) then
                                if Players:isPlayerInFilter(i) == false and Players:isPlayerAFK(i) == false then
                                    local vEnLag = get.PlayerLag(i)
                                    local   distance = Utils:Get3Ddist(vMy .Pos, vEnLag)
                                    if  distance < Troll.RVanka.Distance.v then
                                        Troll.RVanka.PlayerTimer[i] = (Troll.RVanka.PlayerTimer[i] or 0) + 1
                                        local vEnOFData = Players:getOnFootData(i)
                                        if vEnOFData.sSurfingVehicleID == 65535 then
                                            if Troll.RVanka.PlayerTimer[i] > Troll.RVanka.Timer.v then
                                                for j = 0, 1003 do
                                                    if j ~= i then
                                                        Troll.RVanka.PlayerTimer[j] = 0
                                                    else
                                                        local a = math.random(1,6)
                                                        local pos = CVector()
                                                        local bsData = BitStream()
                                                        pos = vEnLag
                                                        local vEnPos = Players:getPlayerPosition(i)
                                                        local randX = maths.randomFloat(-2, 2)
                                                        local randY = maths.randomFloat(-2, 2)
                                                        local vMyPos = CVector(pos.fX+randX, pos.fY+randY, pos.fZ)
                                                        
                                                        local vehicle = vMy.Vehicle
                                                        local vModel = Cars:getCarModel(vehicle)
                                                        local rVankatype

                                                        local qw,qx,qy, qz ,aa = 0
                                                        
                                                        qw, qx, qy, qz = set.PlayerFacing(vMyPos, vEnPos)
                                                        local quaternions = {}
                                                        quaternions.w = qw
                                                        quaternions.x = 0
                                                        quaternions.y = 0
                                                        quaternions.z = qz
                                                        local velocity = {x = 0.02, y = 0.02, z = -0.0000001}
                                                        local angle = maths.quaternionToAngle(quaternions)
                                                        aa = maths.increaseVelocityByAngle(velocity, angle, Troll.RVanka.Speed.v)

                                                        if vModel == 417 or vModel == 425 or vModel == 447 or vModel == 487 or vModel == 488 or vModel == 501 or vModel == 548 or vModel == 563 then
                                                            vMyPos = CVector(pos.fX+1.5, pos.fY+1.5, pos.fZ+maths.randomInt(2,4))
                                                            aa.x = 0
                                                            aa.y = 0
                                                            pos.fZ = pos.fZ - 3
                                                            rVankatype = "Heli"
                                                        elseif vehicle ~= 65535 then
                                                            rVankatype = "InCar"
                                                        else
                                                            rVankatype = "OnFoot"
                                                        end
                                                        
                                                        vMyPos = CVector((pos.fX-aa.x)+randX, (pos.fY-aa.y)+randY, pos.fZ)


                                                        local message = ImBuffer("RVanka ".. rVankatype .." - ".. Players:getPlayerName(i) .."(".. i ..")",155)
                                                        if message then
                                                            set.TextDraw(message, 0xFFF300FF, 2045, 15, 305)
                                                        end
                                                        if vAmI.Driver then
                                                            qx = 0
                                                            qy = 0
                                                            bsWrap:Write8(bsData, 200) 
                                                            bsWrap:Write16(bsData, vMy.ICData.VehicleID)
                                                            bsWrap:Write16(bsData, 8)
                                                            bsWrap:Write16(bsData, 8)
                                                            bsWrap:Write16(bsData, 8)
                                                            bsWrap:WriteFloat(bsData, qw)  
                                                            bsWrap:WriteFloat(bsData, qx)   
                                                            bsWrap:WriteFloat(bsData, qy) 
                                                            bsWrap:WriteFloat(bsData, qz)  
                                                            bsWrap:WriteFloat(bsData, vMyPos.fX)
                                                            bsWrap:WriteFloat(bsData, vMyPos.fY)
                                                            bsWrap:WriteFloat(bsData, vMyPos.fZ)
                                                            bsWrap:WriteFloat(bsData, aa.x)
                                                            bsWrap:WriteFloat(bsData, aa.y)
                                                            bsWrap:WriteFloat(bsData, aa.z)
                                                            bsWrap:WriteFloat(bsData, vMy.ICData.HealthCar)
                                                            bsWrap:Write8(bsData, vMy.HP)
                                                            bsWrap:Write8(bsData, vMy.Armor)
                                                            bsWrap:Write8(bsData, 0)
                                                            bsWrap:Write8(bsData, 0)
                                                            bsWrap:Write8(bsData, 0)
                                                            bsWrap:Write8(bsData, 0)
                                                            bsWrap:Write8(bsData, 0)
                                                            bsWrap:WriteFloat(bsData, 0)
                                                            SendPacket(200, bsData)
                                                            bsWrap:Reset(bsData) 
                                                        else
                                                            local vEnData = Players:getOnFootData(i)
                                                            if Players:isDriver(i) or Players:Driving(i) then
                                                                vEnData = Players:getInCarData(i)
                                                            end
                                                            local velocityX = vEnData.Speed.fX
                                                            local velocityY = vEnData.Speed.fY
                                                            local velocityZ = Troll.RVanka.Speed.v
                                                            local ofData = get.onFootData()

                                                            OnFootData.lrkey = 8
                                                            OnFootData.udkey = 8
                                                            OnFootData.keys = 8
                                                            OnFootData.X = pos.fX
                                                            OnFootData.Y = pos.fY
                                                            OnFootData.Z = pos.fZ
                                                            OnFootData.quat_w = 0
                                                            OnFootData.quat_x = -0.7
                                                            OnFootData.quat_y = 0
                                                            OnFootData.quat_z = 0
                                                            OnFootData.velocity_x = velocityX
                                                            OnFootData.velocity_y = velocityY
                                                            OnFootData.velocity_z = velocityZ
                                                            send.onFootSync(OnFootData)
                                                        end
                                                        Troll.RVanka.PlayerTimer[i] = -1
                                                        SHAcKvar.rVankanEWVAR = 1
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        Troll.RVanka.PlayerTimer[i] = -1
                                    end
                                else
                                    Troll.RVanka.PlayerTimer[i] = -1
                                end
                            end
                        end
                    end
                else
                    SHAcKvar.rVankanEWVAR = SHAcKvar.rVankanEWVAR + 1
                    if SHAcKvar.rVankanEWVAR > Troll.RVanka.Timer.v*2 then
                        SHAcKvar.rVankanEWVAR = 0
                    end
                end
            end
        --VehicleTroll
            if Troll.VehicleTroll.v and Troll.VehicleTrollType.v ~= 0 then
                for i = 1, SAMP_MAX_VEHICLES do
                    if Cars:isCarStreamed(i) then
                        local vCarPos = Cars:getCarPosition(i)
                        local   distance = Utils:Get3Ddist(vMy .Pos, vCarPos)
                        if Cars:getHavePassenger(i,0) == false then
                                if v.fuckerpertimer[i] == nil or v.fuckerpertimer[i] == NULL then
                                    v.fuckerpertimer[i] = 0
                                end
                                v.fuckerpertimer[i] = v.fuckerpertimer[i] + 1
                                if v.fuckerpertimer[i] > 3 then
                                    for j = 1, SAMP_MAX_VEHICLES do
                                        if j ~= i then
                                            v.fuckerpertimer[j] = 0
                                        end
                                    end
                                    vehiclefucker(i, Player)
                                    fuckerTimer = 0;
                                    v.fuckerpertimer[i] = 0
                                end
                        else
                            if v.fuckerpertimer[i] ~= 0 then v.fuckerpertimer[i] = 0 end
                        end
                    else
                        if v.fuckerpertimer[i] ~= 0 then v.fuckerpertimer[i] = 0 end
                    end
                end
            end
        --Throw Driver
            if Troll.RainCars.v then
                local bsData = BitStream()
                local stop = 0
                local Player = {}
                local Drivers = {}
                local PlayerID = -1 
                
                if Utils:IsKeyDown(2) then
                    for i, _ in pairs(players.id) do
                        if Players:isPlayerStreamed(i) then
                            local vEnDriver = Players:isDriver(i)
                            if vEnDriver then
                                local vEnPos = Players:getPlayerPosition(i)
                                Drivers[i] = i
                                Utils:GameToScreen(vEnPos, vEnScreen)
                                Player[i] = Utils:Get2Ddist(vecCrosshair,vEnScreen)
                                PlayerID = maths.getLowerIn(Player)
                            else
                                Player[i] = nil
                                Drivers[i] = nil
                            end
                        else
                            Player[i] = nil
                            Drivers[i] = nil
                        end
                    end
                    if Player[PlayerID] ~= nil then
                        local vEnPos = Players:getPlayerPosition(PlayerID)
                        local Target = vEnPos
                        Utils:GameToScreen(Target, vEnScreen)
                        if vEnScreen.fZ > 1 then
                            Render:DrawLine(vecCrosshair.fX,vecCrosshair.fY,vEnScreen.fX,vEnScreen.fY,0xFF9966f0)
                            if Utils:IsKeyChecked(66, 300) and stop == 0 then
                                local veh = Players:getVehicleID(PlayerID)
                                send.Vehicle(veh)
                                stop = 1
                            else
                                if stop ~= 0 then
                                    stop = 0
                                end
                            end
                        end
                    end
                end
            end
    --Anti Troller / Troller
        if v.DrivingPlayerID ~= -1 then
            if Players:isPlayerStreamed(v.DrivingPlayerID) == false then
                v.DrivingPlayerID = -1
            end
        end
        if v.Troller ~= -1 then
            if Players:isPlayerStreamed(v.Troller) == false then
                v.Troller = -1
            end
        end
        --end
    end
--
--! Render
    local function RenderVisuals()
        if unload then
            return false
        end
        if Panic.Visuals.v == true then
            return false
        end
    --Damager ShowPrediction
        if KeyToggle.Damager.v == 1 and Damager.ShowHitPos.v and SHAcKvar.damagerhitEnPos ~= 0 then
            Utils:GameToScreen(SHAcKvar.damagerhitMyPos, vMyScreenToDamager)
            Utils:GameToScreen(SHAcKvar.damagerhitEnPos, vEnScreenToDamager)
            if vEnScreenToDamager.fZ > 0 and v.DamagerPlayerID ~= -1 then
                Render:DrawCircle(vEnScreenToDamager.fX, vEnScreenToDamager.fY, 5, true, Players:getPlayerColor( v.DamagerPlayerID))
                Render:DrawLine(vMyScreenToDamager.fX,vMyScreenToDamager.fY,vEnScreenToDamager.fX,vEnScreenToDamager.fY,Players:getPlayerColor( v.DamagerPlayerID))
            end
        end
    --Draw Fakelag Wall
        if Movement.FakeLagPeek.Enable.v and not vAmI.Passenger and not vAmI.Driver then
            if Movement.FakeLagPeek.DrawWalls.v then
                if SHAcKvar.DrawWall ~= 0 and v.WaitForPickLag == 0 then
                    local vMyPos = Players:getPlayerPosition(vMy.ID)
                    vMyPos.fZ = vMyPos.fZ + 0.5
                    Utils:GameToScreen(vMyPos, vMyScreen)
                    Utils:GameToScreen(SHAcKvar.DrawWall, vEnScreen)
                    if vEnScreen.fZ > 1 then
                        Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 20, true, 0x899966f0)
                        Render:DrawLine(vMyScreen.fX,vMyScreen.fY,vEnScreen.fX,vEnScreen.fY,0xF99966f0)
                    end
                    if Movement.FakeLagPeek.AtTarget.v then
                        Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, Movement.FakeLagPeek.Fov.v*20, true, 0x299966f0)
                    end
                end
            end
        end
    --Silent DrawFov
        if KeyToggle.Silent.v == 1 then
            local aim 
            if SilentStuff.FirstShots == 0 then
                aim = SilentStuff.Fov
            else
                aim = SilentStuff.Fov2
            end
            if SilentStuff.BoneHead == true or SilentStuff.BoneChest == true or SilentStuff.BoneStomach == true or SilentStuff.BoneLeftA == true or 
            SilentStuff.BoneRightA == true or SilentStuff.BoneLeftL == true or SilentStuff.BoneRightL == true then
                local CFGBone = players.bone[v.SilentPlayerID]
                if v.SilentPlayerID ~= -1 then
                    if Players:isPlayerStreamed(v.SilentPlayerID) then
                        local vEnBone = Players:getBonePosition(v.SilentPlayerID, CFGBone)
                        Utils:GameToScreen(vEnBone, vEnScreen)
                        local fov = Utils:Get2Ddist(SilentCrosshair,vEnScreen)
                        if KeyToggle.Silent.v == 1 then
                            if fov < aim  then 
                                if Silent.DrawFov.v then
                                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, aim, false, Players:getPlayerColor(v.SilentPlayerID))
                                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, aim, true, 0x199966f0)
                                    Render:DrawLine(SilentCrosshair.fX,SilentCrosshair.fY,vEnScreen.fX,vEnScreen.fY,Players:getPlayerColor(v.SilentPlayerID))
                                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 3, true, Players:getPlayerColor(v.SilentPlayerID))
                                end
                            else
                                v.SilentPlayerID = -1
                            end
                        else
                            v.SilentPlayerID = -1
                            if Silent.DrawFov.v then
                                Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                                Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                            end
                        end
                    else
                        v.SilentPlayerID = -1
                        if Silent.DrawFov.v then
                            Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                            Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                        end
                    end
                else
                    if Silent.DrawFov.v then
                        Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                        Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                    end
                end
            else
                if Silent.DrawFov.v then
                    Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                    Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                end
                v.SilentPlayerID = -1
            end
        end
    --LagCompWall
        if WallHack.Enable.v then
            local vEnScreen = CVector()
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    local vEnLag = get.PlayerLag(i)
                    Utils:GameToScreen(vEnLag, vEnScreen)
                    if vEnScreen.fZ > 1 then
                        Render:DrawCircle(vEnScreen.fX, vEnScreen.fY-5, 7, true, Players:getPlayerColor(i))
                    end
                end
            end
        end
    --Filters
        if Filters.Enable.v then
            if v.filteringid ~= -1 then
                local fX = Filters.X.v
                local fY = Filters.Y.v
                local Heigh = 225
                local Height = 65
                if Players:isPlayerStreamed(v.filteringid) then
                    Heigh = Heigh + 20
                    Height = Height + 15
                end
                Render:DrawBoxBorder(fX, fY, 100, 20, 0xFF000000, 0x9F8A33FF)
                Render:DrawText("FILTER",fX+10,fY,0xFFFFFFFF)
                Render:DrawBoxBorder(fX, fY+20, Heigh, Height, 0xFF000000, 0x9F000000)
                Render:DrawText( Players:getPlayerName(v.filteringid).." (".. v.filteringid ..")",fX+5,fY+25,Players:getPlayerColor(v.filteringid))
                if Players:isPlayerInFilter(v.filteringid) then
                    Render:DrawText("Player In Filter",fX+5,fY+50,0xFFFFFFFF)
                else
                    Render:DrawText("Press 1 To Add Name to Filter",fX+5,fY+50,0xFFFFFFFF)
                end
                fY = fY + 20 
                if Players:isPlayerStreamed(v.filteringid) then
                    if Players:isSkinInFilter(Players:getPlayerSkin(v.filteringid)) then
                        Render:DrawText("Skin In Filter",fX+5,fY+50,0xFFFFFFFF)
                    else
                        Render:DrawText("Press 2 To Add Skin ".. Players:getPlayerSkin(v.filteringid) .." to Filter",fX+5,fY+50,0xFFFFFFFF)
                    end
                end
                if Players:isPlayerInFilter(v.filteringid) == false then
                    if Utils:IsKeyChecked(49,0) then
                        SHAkMenu.Open = 1
                        v.filterIdtoSHAk = v.filteringid
                        Timer.Configs[2] = 0
                        Utils:AddFilterName(Players:getPlayerName(v.filteringid))
                    end
                end
                if Players:isPlayerStreamed(v.filteringid) then
                    if Players:isSkinInFilter(v.filteringid) == false then
                        if Utils:IsKeyChecked(50,0) then
                            SHAkMenu.Open = 1
                            v.filterSkintoSHAk = v.filteringid
                            Timer.Configs[2] = 0
                            Utils:AddFilterSkinID(Players:getPlayerSkin(v.filteringid))
                        end
                    end
                end
                v.filtertimer = v.filtertimer + 1
                if v.filtertimer >= 500 then
                    v.filteringid = -1
                    v.filtertimer = 0
                end
            end
        end
    --Stream WallHack
        if StreamWall.Enable.v then
            local Xw = StreamWall.X.v
            local Yw = StreamWall.Y.v
            local Ww = 150
            local Hw = 20
            local showmax = ImBuffer("",5)
            local passthrumax = 0
            local LimitSW = 0
            if LimitSW > 2 then
                Xw = Xw + 500
            end
            local fX = Utils:getResolutionX() * 0.5
            local fY = Utils:getResolutionY() * 0.5
            
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    local names = Players:getPlayerName(i)
                    local HP = Players:getPlayerHP(i)
                    local Armor = Players:getPlayerArmour(i)
                    local HPw = 0
                    local Armorw = 0
                    if StreamWall.AFK.v or StreamWall.AFK.v == false and Players:isPlayerAFK(i) == false then
                        LimitSW = LimitSW + 1
                        if LimitSW < StreamWall.MaxPlayers.v then

                            local buff = ImBuffer("",5)
                            if Players:isPlayerInFilter(i) or Players:isSkinInFilter(i) then
                                buff = ImBuffer("[F] ",5)
                            end

                            Yw = Yw - 15
                            Xfh = Xw
                            Yfh = Yw
                            if StreamWall.HP.v then
                                if Armor == 0 then
                                    Yfh = Yw - 2
                                end
                                Volume = 52
                                HPw = HP *0.5
                                Armorw = Armor *0.5
                                if HPw > 50 then
                                    HPw = 50
                                end
                                if Armorw > 50 then
                                    Armorw = 50
                                end
                                if Players:isPlayerAFK(i) == false and StreamWall.AFK.v == false or StreamWall.AFK.v then
                                    if get.isPlayerAlive(i) == true then
                                        Render:DrawBoxBorder(Xw, Yfh+8, Volume, 8, 0xFF000000, 0xFF660000)
                                        Render:DrawBox(Xw+1, Yfh+9, HPw, 6, 0xFFDc0505)    
                                        if Armor > 0 then
                                            Render:DrawBoxBorder(Xw, Yfh+4, Volume, 6, 0xFF000000, 0xFF282429)
                                            Render:DrawBox(Xw+1, Yfh+5, Armorw, 4, 0xFF8d7f90)
                                        end
                                    end
                                    if get.isPlayerAlive(i) == true then
                                        if HP > 100 or HP < 0 then
                                            Render:DrawText(("GOD"),Xfh+8,Yfh+1,0xFFFFFFFF)
                                        end
                                    else
                                        Render:DrawText(("DEAD"),Xfh+8,Yfh+1,0xFF322f2f)
                                    end
                                end
                            end
                            if Players:isPlayerAFK(i) then
                                if StreamWall.AFK.v then
                                    local vEnPos = Players:getPlayerPosition(i)
                                    if Utils:isOnScreen(i) then
                                        if Utils:IsLineOfSightClear(vMy.Pos, vEnPos, true, false ,false, true, false, false, false) then
                                            Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFF00FF00)
                                        else
                                            Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFF003300)
                                        end
                                    else
                                        if Utils:IsLineOfSightClear(vMy.Pos, vEnPos, true, false ,false, true, false, false, false) then
                                            Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFFFF0000)
                                        else
                                            Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFF96492b)
                                        end
                                    end
                                    Render:DrawText("[AFK]",Xw+60,Yw,0xFF141414)
                                    Render:DrawText(buff.v.. names.."  (".. i ..")",Xw+105,Yw,Players:getPlayerColor(i))
                                else
                                    Yw = Yw + 15
                                end
                            else
                                local color 
                                local vEnPos = Players:getPlayerPosition(i)
                                if Utils:isOnScreen(i) then
                                    if Utils:IsLineOfSightClear(vMy.Pos, vEnPos, true, false ,false, true, false, false, false) then
                                        color = 0xFF00FF00
                                    else
                                        color = 0xFF003300
                                    end
                                else
                                    if Utils:IsLineOfSightClear(vMy.Pos, vEnPos, true, false ,false, true, false, false, false) then
                                        color = 0xFFFF0000
                                    else
                                        color = 0xFF96492b
                                    end
                                end
                                Render:DrawCircle(Xw-13, Yw+10, 5, true, color)
                                local vEnDriver = Players:isDriver(i)
                                local vEnPassenger = false
                                if not vEnDriver then
                                    vEnPassenger = Players:Driving(i)
                                end
                                local newX = Xw + 60
                                local newX2 = Xw
                                color = 0xFF5c5c5c
                                local driverpassenger = ImBuffer("",2)

                                if StreamWall.HP.v then
                                    if vEnDriver then
                                        driverpassenger = ImBuffer("[DRIVING]",25)
                                        newX2 = newX2 + 60
                                        newX = newX + 75

                                        if Players:isPlayerInFilter(i) or Players:isSkinInFilter(i) then
                                            buff = ImBuffer("[F] ",5)
                                        end
                                    elseif vEnPassenger then
                                        color = 0xFFcfc6c6

                                        driverpassenger = ImBuffer("[PASSENGER]",25)

                                        newX2 = newX2 + 60
                                        newX = newX + 100
                                    end
                                end
                                Render:DrawText(""..driverpassenger.v, newX2,Yw,color)
                                Render:DrawText(buff.v .. names.."  (".. i ..")",newX,Yw,Players:getPlayerColor(i))
                            end
                        else
                            passthrumax = passthrumax + 1
                        end
                    end
                end
            end
            local showmax = ImBuffer("+ ".. passthrumax ,12)
            if passthrumax == 0 then
                showmax = ImBuffer("")
            end
            Yw = Yw - 30
                    
                --Render:DrawBoxBorder(Xw-5, Yw, Ww, Hw, v.colorBorder1, v.colorBorder2)
                Render:DrawText("STREAM WALLHACK   "..showmax.v ,Xw,Yw,v.colorShackled)
        end
    --RadarHack
        if RadarHack.Enable.v then
            local vMyPos
            if RadarHack.LinkedToChar.v then
                vMyPos = Players:getBonePosition(vMy.ID,RadarHack.Bone.v)
            else
                vMyPos = Players:getPlayerPosition(vMy.ID)
            end
            Utils:GameToScreen(vMyPos, vMyScreen)
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    if SHAcKvar.AfterDamageDelayPer[i] ~= nil and SHAcKvar.AfterDamageDelayPer[i] > 1500 then
                        SHAcKvar.AfterDamage[i] = nil
                        SHAcKvar.AfterDamageDelayPer[i] = 0
                    end
                    if SHAcKvar.AfterDamage[i] ~= nil and RadarHack.AfterDamage.v or 
                    RadarHack.AfterDamage.v == false then
                        get.PlayerToRadar(i, vMyPos)
                        if RadarHack.PlayerPos[i] ~= nil then
                            if RadarHack.AfterDamage.v then
                                if SHAcKvar.AfterDamageDelayPer[i] == nil then
                                    SHAcKvar.AfterDamageDelayPer[i] = 0
                                end
                                SHAcKvar.AfterDamageDelayPer[i] = SHAcKvar.AfterDamageDelayPer[i] + 1
                                if SHAcKvar.AfterDamageDelayPer[i] > 2000 then
                                    SHAcKvar.AfterDamage[i] = nil
                                    SHAcKvar.AfterDamageName[i] = nil
                                    SHAcKvar.AfterDamageDelayPer[i] = 0
                                end
                            end
                            local vEnNormalPos = Players:getPlayerPosition(i)
                            local vEnPos = RadarHack.PlayerPos[i]
                            Utils:GameToScreen(vEnPos, vEnScreen)
                            local zground = Utils:FindGroundZForCoord(vEnNormalPos.fX,vEnNormalPos.fY)
                            
                            local LimitRH = 0
                            local maxLength = RadarHack.maxDistance.v
                            local Distance3d = Utils:Get2Ddist(vMyPos, vEnNormalPos)
                            if Distance3d > RadarHack.lowDistance.v and Distance3d < RadarHack.maxDistance.v then
                                local visiblecheck = true
                                if RadarHack.Onlyoutofview.v then
                                    if Utils:isOnScreen(i) then
                                        if Utils:IsLineOfSightClear(vMyPos, vEnPos, true, false ,false, true, false, false, false) then
                                            visiblecheck = false
                                        end
                                    end
                                end
                                if visiblecheck == true then
                                    LimitRH = LimitRH + 1
                                    if LimitRH < RadarHack.MaxPlayers.v then
                                        if RadarHack.ShowLine.v then
                                            Render:DrawLine(vMyScreen.fX+RadarHack.X.v,vMyScreen.fY+RadarHack.Y.v,vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v,0x2FFFFFFF)
                                        end
                                        if Utils:isOnScreen(i) then
                                            if Utils:IsLineOfSightClear(vMyPos, vEnNormalPos, true, false ,false, true, false, false, false) then
                                                Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFF00FF00)
                                            else
                                                Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFF003300)
                                            end
                                        else
                                            if Utils:IsLineOfSightClear(vMyPos, vEnNormalPos, true, false ,false, true, false, false, false) then
                                                Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFFFF0000)
                                            else
                                                Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFF96492b)
                                            end
                                        end
                                        if RadarHack.ShowHP.v then
                                            if vEnScreen.fZ > 1 then
                                                vEnScreen.fY = vEnScreen.fY - RadarHack.HPHeight.v + 5
                                            else
                                                vEnScreen.fY = vEnScreen.fY + RadarHack.HPHeight.v - 10
                                            end
                                        end
                                        local bufname = ImBuffer(" ",1)
                                        local buffriend = ImBuffer("",0)
                                        if Players:isPlayerInFilter(i) or Players:isSkinInFilter(i) then
                                            buffriend = ImBuffer("[F] ",4)
                                        end
                                        if RadarHack.ShowName.v then
                                            bufname = ImBuffer( Players:getPlayerName(i).." ",25)
                                        end
                                        Render:DrawText(buffriend.v .. bufname.v.."(".. i ..")",vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v-20,Players:getPlayerColor(i))
                                                
                                        if zground + 3 < vEnNormalPos.fZ then
                                            Render:DrawBox(vEnScreen.fX+RadarHack.X.v-7, vEnScreen.fY+RadarHack.Y.v-3, 15, 2, 0xFFFFFFFF)  
                                        end
                                        Render:DrawCircle(vMyScreen.fX+RadarHack.X.v,vMyScreen.fY+RadarHack.Y.v, 2, true, 0xFFFFFFFF)
                                        if RadarHack.ShowHP.v then
                                            local HPRh = Players:getPlayerHP(i)
                                            local ArmorRh = Players:getPlayerArmour(i)
                                            if vEnScreen.fZ > 1 and ArmorRh > 0 then 
                                                vEnScreen.fY = vEnScreen.fY + 5
                                            end
                                            vEnScreen.fY = vEnScreen.fY + RadarHack.Y.v - 15
                                            vEnScreen.fX = vEnScreen.fX + RadarHack.X.v + 8
                                            
                                            VolumeRh = RadarHack.HPSize.v
                                            
                                            HPRh =  (RadarHack.HPSize.v * 0.01) * HPRh
                                            ArmorRh = (RadarHack.HPSize.v * 0.01) * ArmorRh
                                            if HPRh > VolumeRh then
                                                HPRh = VolumeRh - 2
                                            end
                                            if ArmorRh > VolumeRh then
                                                ArmorRh = VolumeRh - 2
                                            end
                                            Render:DrawBoxBorder(vEnScreen.fX-3, vEnScreen.fY+16, VolumeRh, RadarHack.HPHeight.v, 0xFF000000, 0xFF660000)
                                            Render:DrawBox(vEnScreen.fX-2, vEnScreen.fY+17, HPRh-2, RadarHack.HPHeight.v-2, 0xFFE70606)    
                                            if ArmorRh > 0 then
                                                Render:DrawBoxBorder(vEnScreen.fX-3, vEnScreen.fY+16-RadarHack.HPHeight.v, VolumeRh, RadarHack.HPHeight.v, 0xFF000000, 0xFF282429)
                                                Render:DrawBox(vEnScreen.fX-2, vEnScreen.fY+17-RadarHack.HPHeight.v, ArmorRh-2, RadarHack.HPHeight.v-2, 0xFF8d7f90)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if SHAcKvar.AfterDamage[i] ~= nil then
                        if Players:isPlayerOnServer(i) then
                            if SHAcKvar.AfterDamageName[i] ~= Players:getPlayerName(i) then
                                SHAcKvar.AfterDamage[i] = nil
                                SHAcKvar.AfterDamageName[i] = nil
                            end
                        end
                    end
                end
            end
        end
    --Save/Load & Others
        local X = SHAkMenu.X.v
        local Y = SHAkMenu.Y.v
        local W = 104
        local H = 20
        if SHAkMenu.Saved == 1 or SHAcKvar.Teleporting[1] == 1 then
            if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
            Timer.Configs[0] = Timer.Configs[0] + 1
                if Timer.Configs[0] < 300 then ConfigSaveColor = 0xFFFFFFFF else
                if Timer.Configs[0] < 400 then ConfigSaveColor = 0x9FFFFFFF else
                if Timer.Configs[0] < 500 then ConfigSaveColor = 0x8FFFFFFF else
                if Timer.Configs[0] < 600 then ConfigSaveColor = 0x7FFFFFFF else
                if Timer.Configs[0] < 750 then ConfigSaveColor = 0x6FFFFFFF else
                if Timer.Configs[0] < 800 then ConfigSaveColor = 0x5FFFFFFF else
                if Timer.Configs[0] < 850 then ConfigSaveColor = 0x4FFFFFFF else
                if Timer.Configs[0] < 900 then ConfigSaveColor = 0x3FFFFFFF else
                if Timer.Configs[0] < 950 then ConfigSaveColor = 0x2FFFFFFF else
                if Timer.Configs[0] < 1000 then ConfigSaveColor = 0x1FFFFFFF end 
                end end end end end end end end end
            if Timer.Configs[0] > 1000 then
                SHAkMenu.Saved = 0 
                Timer.Configs[0] = 0
            end
            if SHAcKvar.Teleporting[1] == 1 then
                ConfigSaveOnScreen = Render:DrawText("[TELEPORTING]",X,Y+15,0xFF8A33FF)
                ConfigSaveOnScreen = Render:DrawText("dist:(".. v.TeleportCounter ..")!",X+110,Y+15,0xFFFFFFFF)
                Y = Y - 15
            end
            if SHAkMenu.Saved == 1 then
                ConfigSaveOnScreen = Render:DrawText("Config: ".. SHAkMenu.ConfigName.v .." Saved",X,Y+15,ConfigSaveColor)
                Y = Y - 15
            end
        else
            if SHAkMenu.Loaded == 1 then
                if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
                Timer.Configs[1] = Timer.Configs[1] + 1
                    if Timer.Configs[1] < 300 then ConfigLoadColor = 0xFFFFFFFF else
                    if Timer.Configs[1] < 400 then ConfigLoadColor = 0x9FFFFFFF else
                    if Timer.Configs[1] < 500 then ConfigLoadColor = 0x8FFFFFFF else
                    if Timer.Configs[1] < 600 then ConfigLoadColor = 0x7FFFFFFF else
                    if Timer.Configs[1] < 750 then ConfigLoadColor = 0x6FFFFFFF else
                    if Timer.Configs[1] < 800 then ConfigLoadColor = 0x5FFFFFFF else
                    if Timer.Configs[1] < 850 then ConfigLoadColor = 0x4FFFFFFF else
                    if Timer.Configs[1] < 900 then ConfigLoadColor = 0x3FFFFFFF else
                    if Timer.Configs[1] < 950 then ConfigLoadColor = 0x2FFFFFFF else
                    if Timer.Configs[1] < 1000 then ConfigLoadColor = 0x1FFFFFFF end 
                    end end end end end end end end end
                    if v.Cfgbrokenlines == 1 then
                        ConfigLoadeOnScreen = Render:DrawText("Config: ".. SHAkMenu.ConfigName.v .." Broken Config! (".. v.Cfgbrokenlines .." Errors)",X,Y+15,ConfigLoadColor)
                    else
                        if v.Cfgbrokenlines > 1 then
                            ConfigLoadeOnScreen = Render:DrawText("Config: ".. SHAkMenu.ConfigName.v .." Broken Config! (".. v.Cfgbrokenlines .." Errors)",X,Y+15,ConfigLoadColor)
                        else
                            ConfigLoadeOnScreen = Render:DrawText("Config: ".. SHAkMenu.ConfigName.v .." Loaded",X,Y+15,ConfigLoadColor)
                        end
                    end
                if Timer.Configs[1] > 1000 then
                    SHAkMenu.Open = 0
                    SHAkMenu.Loaded = 0 
                    Timer.Configs[1] = 0
                end
                Y = Y - 15
            else
                if SHAkMenu.Open == 1 or v.filterIdtoSHAk ~= -1 or v.filterSkintoSHAk ~= -1 then
                    if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
                    Timer.Configs[2] = Timer.Configs[2] + 1
                    if Timer.Configs[2] < 300 then ConfigLoadColor = 0xFFFFFFFF else
                    if Timer.Configs[2] < 400 then ConfigLoadColor = 0x9FFFFFFF else
                    if Timer.Configs[2] < 500 then ConfigLoadColor = 0x8FFFFFFF else
                    if Timer.Configs[2] < 600 then ConfigLoadColor = 0x7FFFFFFF else
                    if Timer.Configs[2] < 750 then ConfigLoadColor = 0x6FFFFFFF else
                    if Timer.Configs[2] < 800 then ConfigLoadColor = 0x5FFFFFFF else
                    if Timer.Configs[2] < 850 then ConfigLoadColor = 0x4FFFFFFF else
                    if Timer.Configs[2] < 900 then ConfigLoadColor = 0x3FFFFFFF else
                    if Timer.Configs[2] < 950 then ConfigLoadColor = 0x2FFFFFFF else
                    if Timer.Configs[2] < 1000 then ConfigLoadColor = 0x1FFFFFFF end 
                    if Timer.Configs[2] > 1000 then
                        v.filterIdtoSHAk = -1
                        v.filterSkintoSHAk = -1
                        SHAkMenu.Open = 0
                        Timer.Configs[2] = 0
                    end
                    end end end end end end end end end
                    if v.filterIdtoSHAk ~= -1 then
                        Render:DrawText("Player ".. Players:getPlayerName(v.filterIdtoSHAk) .." (".. v.filterIdtoSHAk ..") added to filters",X,Y+15,ConfigLoadColor)
                        Y = Y - 15
                    end
                    if v.filterSkintoSHAk ~= -1 then
                        Render:DrawText("Skin (".. Players:getPlayerSkin(v.filterSkintoSHAk) ..") added to filters",X,Y+15,ConfigLoadColor)
                        Y = Y - 15
                    end
                end
            end
            if v.DrivingPlayerID ~= -1 then
                if Players:isPlayerStreamed(v.DrivingPlayerID) then
                    if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
                    Timer.Configs[3] = Timer.Configs[3] + 1
                    if Timer.Configs[3] < 300 then ConfigLoadColor = 0xFFFFFFFF else
                    if Timer.Configs[3] < 400 then ConfigLoadColor = 0x9FFFFFFF else
                    if Timer.Configs[3] < 500 then ConfigLoadColor = 0x8FFFFFFF else
                    if Timer.Configs[3] < 600 then ConfigLoadColor = 0x7FFFFFFF else
                    if Timer.Configs[3] < 750 then ConfigLoadColor = 0x6FFFFFFF else
                    if Timer.Configs[3] < 800 then ConfigLoadColor = 0x5FFFFFFF else
                    if Timer.Configs[3] < 850 then ConfigLoadColor = 0x4FFFFFFF else
                    if Timer.Configs[3] < 900 then ConfigLoadColor = 0x3FFFFFFF else
                    if Timer.Configs[3] < 950 then ConfigLoadColor = 0x2FFFFFFF else
                    if Timer.Configs[3] < 1000 then ConfigLoadColor = 0x1FFFFFFF end 
                    if Timer.Configs[3] > 1000 then
                        v.DrivingPlayerID = -1
                        Timer.Configs[3] = 0
                    end
                    end end end end end end end end end
                    Render:DrawText("[EXPLOIT]",X,Y+15,0xFF3399CC)
                    Render:DrawText("Controlling Vehicle of Player",X+75,Y+15,ConfigLoadColor)
                    Render:DrawText( Players:getPlayerName(v.DrivingPlayerID).."(".. v.DrivingPlayerID ..")",X+285,Y+15,Players:getPlayerColor(v.DrivingPlayerID))
                    Y = Y - 15
                else
                    v.DrivingPlayerID = -1
                end
            end
            if v.Troller ~= -1 and Vehicle.AntiCarJack.v then
                if Players:isPlayerStreamed(v.Troller) then
                    if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
                    Timer.Configs[4] = Timer.Configs[4] + 1
                    if Timer.Configs[4] < 300 then ConfigLoadColor = 0xFFFFFFFF else
                    if Timer.Configs[4] < 400 then ConfigLoadColor = 0x9FFFFFFF else
                    if Timer.Configs[4] < 500 then ConfigLoadColor = 0x8FFFFFFF else
                    if Timer.Configs[4] < 600 then ConfigLoadColor = 0x7FFFFFFF else
                    if Timer.Configs[4] < 750 then ConfigLoadColor = 0x6FFFFFFF else
                    if Timer.Configs[4] < 800 then ConfigLoadColor = 0x5FFFFFFF else
                    if Timer.Configs[4] < 850 then ConfigLoadColor = 0x4FFFFFFF else
                    if Timer.Configs[4] < 900 then ConfigLoadColor = 0x3FFFFFFF else
                    if Timer.Configs[4] < 950 then ConfigLoadColor = 0x2FFFFFFF else
                    if Timer.Configs[4] < 1000 then ConfigLoadColor = 0x1FFFFFFF end 
                    if Timer.Configs[4] > 1000 then
                        v.Troller = -1
                        Timer.Configs[4] = 0
                    end
                    end end end end end end end end end
                    Render:DrawText("[Anti CarJack]",X,Y+15,0xFF3399CC)
                    Render:DrawText("Is trying to control your vehicle",X+105,Y+15,ConfigLoadColor)
                    Render:DrawText( Players:getPlayerName(v.Troller).."%s(".. v.Troller ..")",X+315,Y+15,Players:getPlayerColor(v.Troller))
                    Y = Y - 15
                else
                    v.Troller = -1
                end
            end
        end
    --shackled.lua Indicator
        if Timer.ChangeColor1 > 1 then
            if SHAkMenu.Loaded == 1 or SHAkMenu.Saved == 1 or SHAcKvar.Teleporting[1] == 1 or SHAkMenu.Open == 1 or v.DrivingPlayerID ~= -1 or v.Troller ~= -1 and Vehicle.AntiCarJack.v then

               -- Render:DrawBoxBorder(X-5, Y, W, H, v.colorBorder1, v.colorBorder2)
                Render:DrawText(v.BuffShackled..".lua",X,Y,v.colorShackled)
            end
        end
    --Indicators
        if Indicator.Enable.v then
            local X = Indicator.X.v
            local Y = Indicator.Y.v
            local W = 76
            local H = 20
            local W2 = 162
            local H2 = 35
            local Hww = 150
            local Hww3 = 0
            local Hww4 = 0
            local Hww5 = 0
            local Hww6 = 0
            local Hww7 = 0
            memory.CPed.Anim = Utils:readMemory(CPedST+0x534, 1, false)
            if Indicator.MacroRun.v and KeyToggle.MacroRun.v == 1 and memory.CPed.Anim == 7 and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Indicator.Damager.v and KeyToggle.Damager.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 32
            end
            if Indicator.Silent.v and KeyToggle.Silent.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 32
            end
            local slide = 0
            if Movement.Slide.PerWeap.v == false then slide = 1 
            elseif Movement.Slide.SilencedPistol.v and vMy.Weapon == 23 then slide = 1
            elseif Movement.Slide.DesertEagle.v and vMy.Weapon == 24 then slide = 1 
            elseif Movement.Slide.Shotgun.v and vMy.Weapon == 25 then slide = 1 
            elseif Movement.Slide.Sawnoff.v and vMy.Weapon == 26 then slide = 1 
            elseif Movement.Slide.CombatShotgun.v and vMy.Weapon == 27 then slide = 1 
            elseif Movement.Slide.Mp5.v and vMy.Weapon == 29 then slide = 1 
            elseif Movement.Slide.Ak47.v and vMy.Weapon == 30 then slide = 1 
            elseif Movement.Slide.M4.v and vMy.Weapon == 31 then slide = 1 
            elseif Movement.Slide.CountryRifle.v and vMy.Weapon == 33 then slide = 1 
            elseif Movement.Slide.SniperRifle.v and vMy.Weapon == 34 then slide = 1 end
            
            if Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Indicator.FakeLagPeek.v and v.shooting == 0 and SHAcKvar.DesyncTimer > 1 and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Indicator.SlideSpeed.v and slide == 1 and Movement.Slide.Enable.v and Movement.Slide.SpeedEnable.v and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Indicator.AntiStun.v and Movement.AntiStun.Enable.v and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Indicator.Godmode.v and Godmode.PlayerEnable.v and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Indicator.Godmode.v and Godmode.VehicleEnable.v and Panic.EveryThingExceptVisuals.v == false then
                H2 = H2 + 18
            end
            if Panic.EveryThingExceptVisuals.v == false then
                if Indicator.Damager.v and KeyToggle.Damager.v == 1 or 
                Indicator.Silent.v and KeyToggle.Silent.v == 1 or SHAcKvar.Menu == 1 or
                Indicator.MacroRun.v and KeyToggle.MacroRun.v == 1 and memory.CPed.Anim == 7 or 
                Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v  or
                Indicator.FakeLagPeek.v and v.shooting == 0 and SHAcKvar.DesyncTimer > 1 or
                Indicator.SlideSpeed.v and slide == 1 and Movement.Slide.Enable.v or Indicator.AntiStun.v and Movement.AntiStun.Enable.v or 
                Indicator.Godmode.v and Godmode.PlayerEnable.v or Indicator.Godmode.v and Godmode.VehicleEnable.v
                then
                    indicatorX = X
                    if X > Utils:getResolutionX() * 0.5 then
                        indicatorX = indicatorX + 90
                    end

                    Render:DrawBox(X-5, Y, W2, H2, 0x8F3a3d3b)
                    Render:DrawBoxBorder(X-5, Y, W2, H2, v.colorBorder1, 0x00000000)
                    Render:DrawBoxBorder(indicatorX-5, Y, W2, H, v.colorBorder1, 0)
                    Render:DrawText("".. v.BuffShackled ,indicatorX,Y,v.colorShackled)

                    X = Indicator.X.v
                    Y = Indicator.Y.v
                end
            end
        --Damager
            if Indicator.Damager.v and KeyToggle.Damager.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                Y = Y + 17
                local color = 0xFF000000 
                Y = Y + 15
                Hww6 = (Damager.Delay.v * 0.148)
                if Hww6 > 148 then
                    Hww6 = 148
                end
                Render:DrawBoxBorder(X, Y+5, Hww, 10, color, 0x2FFFA533)
                Render:DrawBox(X+1, Y+6, Hww6, 8, 0xFFFCC65B)
                Y = Y + 7
                Hww6 = (Damager.Chance.v * 1.49)
                if Hww6 > 148 then
                    Hww6 = 148
                end

                Render:DrawBoxBorder(X, Y+8.5, Hww, 10, color, 0x4fA975C7)
                Render:DrawBox(X+1, Y+9.7, Hww6, 8, 0xFFFB8DE2)
                
                Render:DrawText(("Delay"),X+53,Y-6.7,0xFfFC5B7B)
                Render:DrawText(("Chance"),X+48,Y+3.7,0xFfFF3FA2)
                Y = Y + 7
            else
                if Indicator.Damager.v == false or KeyToggle.Damager.v == 0 then
                    Y = Y + 10
                end
            end
        --Silent
                if Indicator.Silent.v and KeyToggle.Silent.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                    local color = 0xFF000000 
                    Y = Y + 17
                    if SilentStuff.FirstShots == 0 then
                        Hww6 = (SilentStuff.Fov*0.05 * 2.5)
                    else
                        Hww6 = (SilentStuff.Fov2*0.05 * 2.5)
                    end
                    if Hww6 > 148 then
                        Hww6 = 148
                    end
                    Render:DrawBoxBorder(X, Y+5, Hww, 10, color, 0x2F00898F)
                    Render:DrawBox(X+1, Y+6, Hww6, 8, 0xFF089f8f)
                    Y = Y + 7
                    if SilentStuff.FirstShots == 0 then
                        Hww6 = (SilentStuff.Chance * 1.49)
                    else
                        Hww6 = (SilentStuff.Chance2 * 1.49)
                    end
                    if Hww6 > 148 then
                        Hww6 = 148
                    end
                    Render:DrawBoxBorder(X, Y+8.5, Hww, 10, color, 0x4f64c987)
                    Render:DrawBox(X+1, Y+9.7, Hww6, 8, 0xFF64c987)
                    
                    Render:DrawText(("Fov"),X+59,Y-6.7,0xFf59FF00)
                    Render:DrawText(("Chance"),X+48,Y+3.7,0xFffafa6e)
                    Y = Y + 7
                end
        --MacroRun
                if Indicator.MacroRun.v and KeyToggle.MacroRun.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                    memory.CPed.Anim = Utils:readMemory(CPedST+0x534, 1, false)
                    if memory.CPed.Anim == 7 then
                        Y = Y + 20
                        local color = 0xFF00FF00
                        local color2 = 0xFF000000
                        Render:DrawBoxBorder(X, Y+5, Hww, 10, color2, 0x3F24464a)
                        if not Utils:IsKeyDown(65) and not Utils:IsKeyDown(87) and not Utils:IsKeyDown(83) and not Utils:IsKeyDown(68) then
                            Hww5 = 0
                        else
                            if KeyToggle.MacroRun.v == 1 then
                                if SHAcKvar.IndTimer == 1 then
                                    Hww5 = 147
                                else
                                    if SHAcKvar.IndTimer == 0 then
                                        Hww5 = 0
                                    else
                                        Hww5 = 149 - (SHAcKvar.IndTimer) * 4.8
                                    end
                                end
                                if Hww5 > 147 then
                                    Hww5 = 147
                                end
                            else
                                Hww5 = 0
                            end
                        end
                        Render:DrawBoxBorder(X, Y+5, Hww, 10, color2, 0x002b62FF)
                        Render:DrawBox(X+1, Y+6, Hww5, 8, 0xff4da6FF)
                        Render:DrawText(("Run"),X+59,Y,0xFF2b62FF)
                    end
                end
        --Slide
                if Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v and Panic.EveryThingExceptVisuals.v == false then
                    Y = Y + 20
                    Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3Fb34700)
                    if SHAcKvar.SwitchVelocity[0] == 10 then
                        if v.Hww2 ~= 3 then v.Hww2 = math.random(1,5) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 9 then
                        if v.Hww2 ~= 19 then v.Hww2 = math.random(16,22) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 8 then
                        if v.Hww2 ~= 35 then v.Hww2 = math.random(30,40) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 7 then
                        if v.Hww2 ~= 51 then v.Hww2 = math.random(45,61) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 6 then
                        if v.Hww2 ~= 67 then v.Hww2 = math.random(66,76) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 5 then
                        if v.Hww2 ~= 83 then v.Hww2 = math.random(82,93) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 4 then
                        if v.Hww2 ~= 99 then v.Hww2 = math.random(97,110) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 3 then
                        if v.Hww2 ~= 115 then v.Hww2 = math.random(113,125) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 2 then
                        if v.Hww2 ~= 131 then v.Hww2 = math.random(128,135) end
                    end
                    if SHAcKvar.SwitchVelocity[0] == 1 then
                        if v.Hww2 ~= 147 then v.Hww2 = math.random(136,148) end
                    end
                    if v.Hww2 > 147 then
                        v.Hww2 = 147
                    end
                    Render:DrawBox(X+1, Y+6, v.Hww2, 8, 0xFFffc199)
                    Render:DrawText(("Slide"),X+56,Y,0xFFDC7531)
                end
        --SlideSpeed
                if Indicator.SlideSpeed.v and slide == 1 and Movement.Slide.Enable.v and Movement.Slide.SpeedEnable.v and Panic.EveryThingExceptVisuals.v == false then
                    if Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v then
                        Y = Y + 9
                    else
                        Y = Y + 20
                    end
                    GSSpeedometer = ImFloat(1)
                    if SHAcKvar.SpeedSlide ~= 0 and SHAcKvar.Switch < Movement.Slide.SpeedDuration.v/0.2 and SHAcKvar.Switch > 0 and SHAcKvar.Switch < 50 then
                        if Movement.Slide.Speed.v then
                            GSSpeedometer = (Movement.Slide.Speed.v - 1) * 36.5
                        end
                        if GSSpeedometer > 146 then
                            GSSpeedometer = 147
                        end
                    else
                        GSSpeedometer = 0
                    end
                    Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x7F3c5232)
                    Render:DrawBox(X+1, Y+6, GSSpeedometer, 8, 0xFF5F8D4B)
                    Render:DrawText(("Speed"),X+53,Y+1,0xFF73EC3E)
                end
        --FakeLagPeek
                if Indicator.FakeLagPeek.v and v.shooting == 0 and SHAcKvar.DesyncTimer > 1 and Panic.EveryThingExceptVisuals.v == false then
                    Y = Y + 20
                    Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F800033)
                    Hww7 = (Movement.FakeLagPeek.Delay.v - SHAcKvar.DesyncDelay) / 3.355
                    Render:DrawBox(X+1, Y+6, Hww7, 8, 0xFFff0066)
                    Render:DrawText(("FakeLag"),X+50,Y,0xFFD62a6e)
                end    
        --AntiStun
                if Indicator.AntiStun.v and Panic.EveryThingExceptVisuals.v == false then
                    if Movement.AntiStun.Enable.v then
                        Y = Y + 20
                        if v.SniperProtEnable == 1 then
                            Hww4 = 0
                        else
                            Hww4 = v.StunCount * 1.48
                        end
                        Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F5a4d2f)
                        Render:DrawBox(X+1, Y+6, Hww4, 8, 0xFFA28D5B)
                        Render:DrawText(("Stun"),X+58,Y,0xFFCC9F34)
                    end
                end
        --Godmode
                if Indicator.Godmode.v and Panic.EveryThingExceptVisuals.v == false then
                    if Godmode.PlayerEnable.v then
                        Y = Y + 20
                        X = X + 15
                        Render:DrawText(("Godmode"),X,Y,0xFF00FF00)
                        if Godmode.PlayerCollision.v then
                            Render:DrawText(("I"),X+75,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+75,Y,0xFFFF0000)
                        end
                        if Godmode.PlayerMelee.v then
                            Render:DrawText(("I"),X+85,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+85,Y,0xFFFF0000)
                        end
                        if Godmode.PlayerBullet.v then
                            Render:DrawText(("I"),X+95,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+95,Y,0xFFFF0000)
                        end
                        if Godmode.PlayerFire.v then
                            Render:DrawText(("I"),X+105,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+105,Y,0xFFFF0000)
                        end
                        if Godmode.PlayerExplosion.v then
                            Render:DrawText(("I"),X+115,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+115,Y,0xFFFF0000)
                        end
                    end
                    if Godmode.VehicleEnable.v then
                        Y = Y + 15
                        Render:DrawText(("Godcar"),X,Y,0xFF00FF00)
                        if Godmode.VehicleCollision.v then
                            Render:DrawText(("I"),X+75,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+75,Y,0xFFFF0000)
                        end
                        if Godmode.VehicleMelee.v then
                            Render:DrawText(("I"),X+85,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+85,Y,0xFFFF0000)
                        end
                        if Godmode.VehicleBullet.v then
                            Render:DrawText(("I"),X+95,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+95,Y,0xFFFF0000)
                        end
                        if Godmode.VehicleFire.v then
                            Render:DrawText(("I"),X+105,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+105,Y,0xFFFF0000)
                        end
                        if Godmode.VehicleExplosion.v then
                            Render:DrawText(("I"),X+115,Y,0xFF00FF00)
                        else
                            Render:DrawText(("0"),X+115,Y,0xFFFF0000)
                        end
                    end
                end  
    --SavedPos Position
            if Teleport.ShowSaveTeleports.v then
                if Teleport.PosToScreen[1].fZ > 1 then
                    Render:DrawCircle(Teleport.PosToScreen[1].fX, Teleport.PosToScreen[1].fY, 10, true, 0x7F0040FF) 
                    Render:DrawText("Pos (1)" ,Teleport.PosToScreen[1].fX-25,Teleport.PosToScreen[1].fY+25,0xFF0040FF)
                end
                if Teleport.PosToScreen[2].fZ > 1 then
                    Render:DrawCircle(Teleport.PosToScreen[2].fX, Teleport.PosToScreen[2].fY, 10, true, 0x7F0040FF) 
                    Render:DrawText("Pos (2)" ,Teleport.PosToScreen[2].fX-25,Teleport.PosToScreen[2].fY+25,0xFF0040FF)
                end
                if Teleport.PosToScreen[3].fZ > 1 then
                    Render:DrawCircle(Teleport.PosToScreen[3].fX, PosToScreen[3].fY, 10, true, 0x7F0040FF) 
                    Render:DrawText("Pos (3)" ,Teleport.PosToScreen[3].fX-25,Teleport.PosToScreen[3].fY+25,0xFF0040FF)
                end 
                if Teleport.PosToScreen[4].fZ > 1 then
                    Render:DrawCircle(PosToScreen[4].fX, Teleport.PosToScreen[4].fY, 10, true, 0x7F0040FF) 
                    Render:DrawText("Pos (4)" ,Teleport.PosToScreen[4].fX-25,Teleport.PosToScreen[4].fY+25,0xFF0040FF)
                end
            end
        end
    end
--
--! Menu
    local function Menus()
        if unload then
            return false
        end
    --Format
        if SHAkMenu.Menu.v == -1 then
            SHAkMenu.Menu.v = 0
        end
        
        if SHAkMenu.menutransitor < 135 then
            if SHAkMenu.menutransitor + 4.50 < 135 then
                SHAkMenu.menutransitor = SHAkMenu.menutransitor + 4.50
            else
                SHAkMenu.menutransitor = SHAkMenu.menutransitor + 0.25
            end
        end
        if SHAkMenu.menutransitorstatic < 136 then
            if SHAkMenu.menutransitorstatic - 12.50 < 136 then
                SHAkMenu.menutransitorstatic = SHAkMenu.menutransitorstatic + 12.50
            else
                SHAkMenu.menutransitorstatic = SHAkMenu.menutransitorstatic + 0.75
            end
        end
        if SHAkMenu.menutransitorstaticreversed > 5 then
            if SHAkMenu.menutransitorstaticreversed - 12.50 > 5 then
                SHAkMenu.menutransitorstaticreversed = SHAkMenu.menutransitorstaticreversed - 12.50
            else
                SHAkMenu.menutransitorstaticreversed = SHAkMenu.menutransitorstaticreversed - 0.75
            end
        end
        if SHAkMenu.menutransitorstaticreversed2 > 5 then
            if SHAkMenu.menutransitorstaticreversed2 - 12.50 > 5 then
                SHAkMenu.menutransitorstaticreversed2 = SHAkMenu.menutransitorstaticreversed2 - 12.50
            else
                SHAkMenu.menutransitorstaticreversed2 = SHAkMenu.menutransitorstaticreversed2 - 0.75
            end
        end
        Menu:PushItemWidth(100)
        Menu:CheckBox("Unload",SHAkMenu.unload)
        if SHAkMenu.unload.v then
            unloadScript()
            return false
        end
        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo(" ",SHAkMenu.Menu,"MENU\0AIM\0MOVEMENT\0MISCELLANEOUS\0VISUALS\0TROLL\0NOPS\0\0",6)
        Menu:Separator()
    --Aim
        if SHAkMenu.Menu.v == 1 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            --AimAssistOnlyDeagle
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-10,SHAkMenu.menutransitor-2) 
                    if Menu:Button("| Aim Assist |") then
                        SHAkMenu.resetMenuTimerStaticReversed()
                        if AimAssists == true then
                            AimAssists = false
                        else
                            SHAkMenu.menuOpened = 0
                            AimAssists = true
                            SilentList = false
                            DamagerList = false
                            Rebuff = false
                            DamageChangerList = false
                        end
                    end
                    if AimAssists == true then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("AimAssist", AimAssist.Enable)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey", AimAssist.OnKey)
                        if AimAssist.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("   ", AimAssist.Key, 200, 20) end
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                            if Menu:Button("(?)") then
                                if reindirectbutton == true then
                                    reindirectbutton = false
                                else
                                    reindirectbutton = true
                                end
                            end
                            if reindirectbutton == true then
                                Hotkeys = true; SHAkMenu.Menu.v = 0;
                                reindirectbutton = false
                            end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Draw Fov", AimAssist.DrawFOV)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type", AimAssist.FOVType,"FOV\0.360º\0\0",6)
                        if AimAssist.FOVType.v == 0 then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("FOV", AimAssist.FOV, 0, 60)
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force who you damaged", AimAssist.ForceWhoDamaged)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore CList", AimAssist.IgnoreCList)
                    end
            --Silent
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+8,SHAkMenu.menutransitor+8) 
                if Menu:Button("| Silent |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if SilentList == true then
                        SilentList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AimAssists = false
                        SilentList = true
                        DamagerList = false
                        Rebuff = false
                        DamageChangerList = false
                    end
                end
                if SilentList == true then
                    get.FovfromConfig()
                    get.SilentConfig(vMy.Weapon, vMy.VehicleModel)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Silent", Silent.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##23", Silent.OnKey)
                    if Silent.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("     ", Silent.Key, 200, 20) end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                        if Menu:Button("(?)") then
                            if reindirectbutton == true then
                                reindirectbutton = false
                            else
                                reindirectbutton = true
                            end
                        end
                        if reindirectbutton == true then
                            Hotkeys = true; SHAkMenu.Menu.v = 0;
                            reindirectbutton = false
                        end
                    Menu:Separator()
                    if Silent.WeaponClass.v > 5 then
                        Silent.WeaponClass = 5
                    end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Weapon Class",Silent.WeaponClass,"Pistols\0Shotguns\0SMG\0Rifles\0Snipers\0Rockets\0\0",9)
                        
                    local FirstShots, Fov, Fov2, Chance, Chance2, Bullets, DistanceEnable, Distance, DamageEnable, Damage, VisibleCheck, Vehicles, Objects, minspread, maxspread
                    local bones = {}
                    if Silent.WeaponClass.v == 0 then -- Pistols
                        FirstShots = Silent.Pistols.FirstShots.Shots
                        Fov = Silent.Pistols.Fov
                        Fov2 = Silent.Pistols.FirstShots.Fov
                        Chance = Silent.Pistols.Chance
                        Chance2 = Silent.Pistols.FirstShots.Chance
                        Bullets = Silent.Pistols.Bullets
                        DistanceEnable = Silent.Pistols.DistanceEnable
                        Distance = Silent.Pistols.Distance 
                        DamageEnable = Silent.Pistols.ChangeDamage
                        Damage = Silent.Pistols.Damage
                        VisibleCheck = Silent.Pistols.VisibleCheck.Buildings
                        Vehicles = Silent.Pistols.VisibleCheck.Vehicles
                        Objects = Silent.Pistols.VisibleCheck.Objects
                        bones.head = Silent.Pistols.Bones.Head
                        bones.chest = Silent.Pistols.Bones.Chest
                        bones.stomach = Silent.Pistols.Bones.Stomach
                        bones.lefta = Silent.Pistols.Bones.LeftArm
                        bones.righta = Silent.Pistols.Bones.RightArm
                        bones.leftl = Silent.Pistols.Bones.LeftLeg
                        bones.rightl = Silent.Pistols.Bones.RightLeg
                        minspread = Silent.Pistols.Spread.Min
                        maxspread = Silent.Pistols.Spread.Max
                    end
                    if Silent.WeaponClass.v == 1 then -- Shotguns
                        FirstShots = Silent.Shotguns.FirstShots.Shots
                        Fov = Silent.Shotguns.Fov
                        Fov2 = Silent.Shotguns.FirstShots.Fov
                        Chance = Silent.Shotguns.Chance
                        Chance2 = Silent.Shotguns.FirstShots.Chance
                        Bullets = Silent.Shotguns.Bullets
                        DistanceEnable = Silent.Shotguns.DistanceEnable
                        Distance = Silent.Shotguns.Distance 
                        DamageEnable = Silent.Shotguns.ChangeDamage
                        Damage = Silent.Shotguns.Damage
                        VisibleCheck = Silent.Shotguns.VisibleCheck.Buildings
                        Vehicles = Silent.Shotguns.VisibleCheck.Vehicles
                        Objects = Silent.Shotguns.VisibleCheck.Objects
                        bones.head = Silent.Shotguns.Bones.Head
                        bones.chest = Silent.Shotguns.Bones.Chest
                        bones.stomach = Silent.Shotguns.Bones.Stomach
                        bones.lefta = Silent.Shotguns.Bones.LeftArm
                        bones.righta = Silent.Shotguns.Bones.RightArm
                        bones.leftl = Silent.Shotguns.Bones.LeftLeg
                        bones.rightl = Silent.Shotguns.Bones.RightLeg
                        minspread = Silent.Shotguns.Spread.Min
                        maxspread = Silent.Shotguns.Spread.Max
                    end
                    if Silent.WeaponClass.v == 2 then -- SMG
                        FirstShots = Silent.Smgs.FirstShots.Shots
                        Fov = Silent.Smgs.Fov
                        Fov2 = Silent.Smgs.FirstShots.Fov
                        Chance = Silent.Smgs.Chance
                        Chance2 = Silent.Smgs.FirstShots.Chance
                        Bullets = Silent.Smgs.Bullets
                        DistanceEnable = Silent.Smgs.DistanceEnable
                        Distance = Silent.Smgs.Distance 
                        DamageEnable = Silent.Smgs.ChangeDamage
                        Damage = Silent.Smgs.Damage
                        VisibleCheck = Silent.Smgs.VisibleCheck.Buildings
                        Vehicles = Silent.Smgs.VisibleCheck.Vehicles
                        Objects = Silent.Smgs.VisibleCheck.Objects
                        bones.head = Silent.Smgs.Bones.Head
                        bones.chest = Silent.Smgs.Bones.Chest
                        bones.stomach = Silent.Smgs.Bones.Stomach
                        bones.lefta = Silent.Smgs.Bones.LeftArm
                        bones.righta = Silent.Smgs.Bones.RightArm
                        bones.leftl = Silent.Smgs.Bones.LeftLeg
                        bones.rightl = Silent.Smgs.Bones.RightLeg
                        minspread = Silent.Smgs.Spread.Min
                        maxspread = Silent.Smgs.Spread.Max
                    end
                    if Silent.WeaponClass.v == 3 then -- Rifles
                        FirstShots = Silent.Rifles.FirstShots.Shots
                        Fov = Silent.Rifles.Fov
                        Fov2 = Silent.Rifles.FirstShots.Fov
                        Chance = Silent.Rifles.Chance
                        Chance2 = Silent.Rifles.FirstShots.Chance
                        Bullets = Silent.Rifles.Bullets
                        DistanceEnable = Silent.Rifles.DistanceEnable
                        Distance = Silent.Rifles.Distance 
                        DamageEnable = Silent.Rifles.ChangeDamage
                        Damage = Silent.Rifles.Damage
                        VisibleCheck = Silent.Rifles.VisibleCheck.Buildings
                        Vehicles = Silent.Rifles.VisibleCheck.Vehicles
                        Objects = Silent.Rifles.VisibleCheck.Objects
                        bones.head = Silent.Rifles.Bones.Head
                        bones.chest = Silent.Rifles.Bones.Chest
                        bones.stomach = Silent.Rifles.Bones.Stomach
                        bones.lefta = Silent.Rifles.Bones.LeftArm
                        bones.righta = Silent.Rifles.Bones.RightArm
                        bones.leftl = Silent.Rifles.Bones.LeftLeg
                        bones.rightl = Silent.Rifles.Bones.RightLeg
                        minspread = Silent.Rifles.Spread.Min
                        maxspread = Silent.Rifles.Spread.Max
                    end
                    if Silent.WeaponClass.v == 4 then -- Snipers
                        FirstShots = Silent.Snipers.FirstShots.Shots
                        Fov = Silent.Snipers.Fov
                        Fov2 = Silent.Snipers.FirstShots.Fov
                        Chance = Silent.Snipers.Chance
                        Chance2 = Silent.Snipers.FirstShots.Chance
                        Bullets = Silent.Snipers.Bullets
                        DistanceEnable = Silent.Snipers.DistanceEnable
                        Distance = Silent.Snipers.Distance 
                        DamageEnable = Silent.Snipers.ChangeDamage
                        Damage = Silent.Snipers.Damage
                        VisibleCheck = Silent.Snipers.VisibleCheck.Buildings
                        Vehicles = Silent.Snipers.VisibleCheck.Vehicles
                        Objects = Silent.Snipers.VisibleCheck.Objects
                        bones.head = Silent.Snipers.Bones.Head
                        bones.chest = Silent.Snipers.Bones.Chest
                        bones.stomach = Silent.Snipers.Bones.Stomach
                        bones.lefta = Silent.Snipers.Bones.LeftArm
                        bones.righta = Silent.Snipers.Bones.RightArm
                        bones.leftl = Silent.Snipers.Bones.LeftLeg
                        bones.rightl = Silent.Snipers.Bones.RightLeg
                        minspread = Silent.Snipers.Spread.Min
                        maxspread = Silent.Snipers.Spread.Max
                    end
                    if Silent.WeaponClass.v == 5 then -- Rockets
                        FirstShots = Silent.Rockets.FirstShots.Shots
                        Fov = Silent.Rockets.Fov
                        Fov2 = Silent.Rockets.FirstShots.Fov
                        Chance = Silent.Rockets.Chance
                        Chance2 = Silent.Rockets.FirstShots.Chance
                        Bullets = Silent.Rockets.Bullets
                        DistanceEnable = Silent.Rockets.DistanceEnable
                        Distance = Silent.Rockets.Distance 
                        DamageEnable = Silent.Rockets.ChangeDamage
                        Damage = Silent.Rockets.Damage
                        VisibleCheck = Silent.Rockets.VisibleCheck.Buildings
                        Vehicles = Silent.Rockets.VisibleCheck.Vehicles
                        Objects = Silent.Rockets.VisibleCheck.Objects
                        bones.head = Silent.Rockets.Bones.Head
                        bones.chest = Silent.Rockets.Bones.Chest
                        bones.stomach = Silent.Rockets.Bones.Stomach
                        bones.lefta = Silent.Rockets.Bones.LeftArm
                        bones.righta = Silent.Rockets.Bones.RightArm
                        bones.leftl = Silent.Rockets.Bones.LeftLeg
                        bones.rightl = Silent.Rockets.Bones.RightLeg
                        minspread = Silent.Rockets.Spread.Min
                        maxspread = Silent.Rockets.Spread.Max
                    end
                    
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Wall Shot", Silent.WallShot)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Draw Fov", Silent.DrawFov)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+13, SHAkMenu.menutransitorstaticreversed+13) Menu:Text("Min Spread")
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90, SHAkMenu.menutransitorstaticreversed+90) Menu:Text("Max Spread")
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5, SHAkMenu.menutransitorstaticreversed+5) Menu:SliderFloat("##24", minspread, -0.15, 0)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+82, SHAkMenu.menutransitorstaticreversed+82) Menu:SliderFloat("###54", maxspread, 0, 0.15)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+25, SHAkMenu.menutransitorstaticreversed+30) Menu:Text("| FOV |") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95, SHAkMenu.menutransitorstaticreversed+95) Menu:Text("| CHANCE |") 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("##2323", Fov, 0, 60.0)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85,SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("##2", Chance, 0, 100)
                        
                    if FirstShots.v > 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50, SHAkMenu.menutransitorstaticreversed+45) Menu:Text("| FIRST SHOTS |") 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("##32131", Fov2, 0, 60)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85,SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("##4", Chance2, 0, 100)
                        
                    else
                        Menu:Separator()
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15, SHAkMenu.menutransitorstaticreversed+15) Menu:SliderInt("First Shots##23", FirstShots, 0, 40)
                    if FirstShots.v > 0 then   
                        Menu:Separator()
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5, SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Send Bullets##23", Bullets, 1, 100)
                    
                    if DistanceEnable.v == false and DamageEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| ------- BONES ------- |")
                    end
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Change Distance##323", DistanceEnable)
                    if DistanceEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85, SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("Distance##323", Distance, 0, 350.0)
                    else
                        if DamageEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Modified Damage##231", DamageEnable)
                    if DistanceEnable.v == true then
                        if DamageEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| ------- BONES ------- |")
                        end
                    else
                        if DamageEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85, SHAkMenu.menutransitorstaticreversed+85) Menu:SliderFloat("Damage##3", Damage, 0, 2000)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Visible Check##3", VisibleCheck)
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| ------- BONES ------- |")
                    else
                        if DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            if DistanceEnable.v == true then
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            end
                        end
                    end
                    if VisibleCheck.v == true then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Vehicles##33", Vehicles)
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            if DistanceEnable.v == false then
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            else
                                if DistanceEnable.v == true then
                                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                                end
                            end
                        end 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Objects##3", Objects)
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            if DistanceEnable.v == false then
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            else
                                if DistanceEnable.v == true then
                                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                                end
                            end
                        end
                    end

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore CLIST", Silent.Clist)
                    
                    if VisibleCheck.v == true then
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore AFK", Silent.AFK)
                    
                    if VisibleCheck.v == true then
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore Death", Silent.Death)
                    
                    if VisibleCheck.v == true then
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                        end
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore InVehicle", Silent.InVehicle)
                    
                    if VisibleCheck.v == true then
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            
                        end
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force Players/Skins In Filters", Silent.Force)
                    if VisibleCheck.v == true then
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                        end
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Sync Rotation", Silent.SyncRotation)
                    if VisibleCheck.v == true then
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                        end
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        elseif DistanceEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Sync AimZ", Silent.SyncAimZ)
                    if VisibleCheck.v == true then
                    else
                        if DamageEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                        elseif DistanceEnable.v == true then
                             Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Only GiveTakeDamage", Silent.OnlyGiveTakeDamage)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Hit Type##3",Silent.OnlyGiveTakeDamageType,"Type1\0Type2\0\0",25) 
                end
            --Damager
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-2,SHAkMenu.menutransitor-2) 
                if Menu:Button("| Damager |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if DamagerList == true then
                        DamagerList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AimAssists = false
                        SilentList = false
                        DamagerList = true
                        Rebuff = false
                        DamageChangerList = false
                    end
                end
                if DamagerList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Damager", Damager.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##9", Damager.OnKey)
                    if Damager.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", Damager.Key, 200, 20) end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                        if Menu:Button("(?)") then
                            if reindirectbutton == true then
                                reindirectbutton = false
                            else
                                reindirectbutton = true
                            end
                        end
                        if reindirectbutton == true then
                            Hotkeys = true; SHAkMenu.Menu.v = 0;
                            reindirectbutton = false
                        end
                    if Damager.OnlyStreamed.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Target",Damager.TargetType,"Nearest\0Lowest HP\0Random\0\0",20)
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Only Streamed", Damager.OnlyStreamed)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Take Damage", Damager.TakeDamage)
                    if Damager.TakeDamage.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Send DeathNotification", Damager.DeathNotification)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Send Spawn", Damager.Spawn)
                    end
                    if Damager.OnlyStreamed.v == false then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("PlayerID", Damager.gtdID, -1, 1004)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:SliderInt("Delay",Damager.Delay, 1, 1000) then
                        get.ScriptTimers()
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance", Damager.Chance, 1, 100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Current Weapon", Damager.CurrentWeapon)
                    if Damager.CurrentWeapon.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Weapon",Damager.Weapon, fWeaponName,20)
                    end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Bone",Damager.Bone,"Chest\0Stomach\0Left Arm\0Right Arm\0Left Leg\0Right Leg\0Head\0Random\0\0",20)
                    if Damager.OnlyStreamed.v and Damager.TakeDamage.v == false then     
                        --if Damager.Weapon.v >= 19 or Damager.CurrentWeapon.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send Bullet Sync", Damager.SyncBullet.Enable)
                            if Damager.SyncBullet.Enable.v then 
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Bullet Type",Damager.SyncBullet.Type,"Normal\0Bypass WeaponConfig\0\0",20)
                            end
                        --end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send OnFoot Sync", Damager.SyncOnfootData)
                        if Damager.SyncOnfootData.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Emulate CBug", Damager.EmulCbug)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Sync Rotation", Damager.SyncRotation)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Send Position to Player", Damager.SyncPos)
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send AimZ", Damager.SyncAim)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send Weapon Sync", Damager.SyncWeapon)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Visible Check", Damager.VisibleChecks)
                        if Damager.VisibleChecks.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Vehicles", Damager.VisibleCheck.Vehicles)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Objects", Damager.VisibleCheck.Objects)
                            Menu:Separator()
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:CheckBox2("Ignore CLIST", Damager.Clist)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore AFK", Damager.AFK)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore Death", Damager.Death)
                    end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force Players/Skins In Filters", Damager.Force)
                    if Damager.OnlyStreamed.v then
                        if Damager.SyncBullet.Enable.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Send Bullets",Damager.Bullets, 0, 10)
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Change Distance", Damager.DistanceEnable)
                        if Damager.DistanceEnable.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Distance",Damager.Distance, 0, 350)
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Show Hit Pos", Damager.ShowHitPos)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore GiveTakeDamage", Damager.IgnoreGiveTakeDamage)
                    if Damager.IgnoreGiveTakeDamage.v == false then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Modified Damage", Damager.ChangeDamage)
                        if Damager.ChangeDamage.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Damage",Damager.Damage, 0, 2000)
                        end
                    end
                end
            --DamageChanger
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-25,SHAkMenu.menutransitor-25) 
                if Menu:Button("| Damage Changer |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if DamageChangerList == true then
                        DamageChangerList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AimAssists = false
                        SilentList = false
                        DamageChangerList = true
                        Rebuff = false
                        DamagerList = false
                    end
                end
                if DamageChangerList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Damage Changer", DamageChanger.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##234", DamageChanger.OnKey)
                    if DamageChanger.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", DamageChanger.Key, 200, 20) end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)") then
                        if reindirectbutton == true then
                            reindirectbutton = false
                        else
                            reindirectbutton = true
                        end
                    end
                    if reindirectbutton == true then
                        Hotkeys = true; SHAkMenu.Menu.v = 0;
                        reindirectbutton = false
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Pistols", DamageChanger.Pistols.Enable)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##11",DamageChanger.Pistols.DMG, 0, 2000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Shotguns", DamageChanger.Shotguns.Enable)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##22",DamageChanger.Shotguns.DMG, 0, 2000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("SMGs", DamageChanger.SMGs.Enable)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##33",DamageChanger.SMGs.DMG, 0, 2000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Rifles", DamageChanger.Rifles.Enable)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##44",DamageChanger.Rifles.DMG, 0, 2000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Snipers", DamageChanger.Snipers.Enable)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##55",DamageChanger.Snipers.DMG, 0, 2000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Get Current Weapon Max DMG |") then
                        if WeaponDAMAGE == true then
                            WeaponDAMAGE = false
                        else
                            WeaponDAMAGE = true
                        end
                    end
                    if WeaponDAMAGE == true  then
                        local WeaponID = vMy.Weapon
                        if WeaponID >= 22 and WeaponID <= 24 then 
                            DamageChanger.Pistols.DMG.v = weaponInfo[WeaponID].damage
                        elseif WeaponID >= 25 and WeaponID <= 27 then 
                            DamageChanger.Shotguns.DMG.v = weaponInfo[WeaponID].damage
                        elseif WeaponID >= 28 and WeaponID <= 29 or WeaponID == 32 then 
                            DamageChanger.SMGs.DMG.v = weaponInfo[WeaponID].damage
                        elseif WeaponID >= 30 and WeaponID <= 31 then 
                            DamageChanger.Rifles.DMG.v = weaponInfo[WeaponID].damage
                        elseif WeaponID >= 33 and WeaponID <= 34 then 
                            DamageChanger.Snipers.DMG.v = weaponInfo[WeaponID].damage
                        elseif WeaponID >= 35 and WeaponID <= 38 then 
                            DamageChanger.Rifles.DMG.v = weaponInfo[WeaponID].damage
                        end
                        WeaponDAMAGE = false
                    end
                end
            --Bullet Rebuff
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-13,SHAkMenu.menutransitor-13) 
                if Menu:Button("| Bullet Rebuff |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if Rebuff == true then
                        Rebuff = false
                    else
                        SHAkMenu.menuOpened = 0
                        AimAssists = false
                        SilentList = false
                        DamagerList = false
                        Rebuff = true
                        DamageChangerList = false
                    end
                end
                if Rebuff == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Rebuff", BulletRebuff.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Copy Weapon Category", BulletRebuff.SameWeapon)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send Weapon Sync", BulletRebuff.SyncWeapon)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore CLIST", BulletRebuff.Clist)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force Players/Skins In Filters", BulletRebuff.Force)
                end
                Menu:Separator()
        else
            SilentList = false
            DamagerList = false
            Rebuff = false
            AimAssists = false
            DamageChangerList = false
        end
    --Movement
        if SHAkMenu.Menu.v == 2 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            --Player
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+5,SHAkMenu.menutransitor+6) 
                if Menu:Button("| Player |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if Others == true then
                        Others = false
                    else
                        SHAkMenu.menuOpened = 0
                        Others = true
                        JumpList = false
                        AntiStunList = false
                        FakeLagList = false
                        SlideList = false
                        MacrosList = false
                    end
                end
                if Others == true then
                    if m_offsets.m_samp_info[v.SampVer] ~= 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("bUseCJWalk", Movement.bUseCJWalk) then
                            set.CJWalk()
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("RunningPatch", Movement.RunEverywhere) then
                        if Movement.RunEverywhere.v then
                            Utils:writeMemory(0x55E874, 4, 2, false)
                        else
                            Utils:writeMemory(0x55E874, 1165, 2, false)
                        end
                    end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+55,SHAkMenu.menutransitorstaticreversed+55) 
                    if Menu:Button("(?)") then
                        if InfoButton == true then
                            InfoButton = false
                        else
                            InfoButton = true
                        end
                    end
                    if InfoButton == true then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                        Menu:Text("Able to run in any surface")
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Fall", Movement.NoFall)
                    if Movement.NoFall.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("No Damage", Movement.NoFallNodamage)
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Change Fight Style", Movement.Fight)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:Combo("  ",Movement.FightStyle,"NORMAL\0BOXING\0KUNGFU\0KNEEHEAD\0GRABKICK\0ELBOW\0\0",8)
                    if Movement.Fight.v then
                        set.FightStyle()
                    end
                else
                    InfoButton = false
                end
            --Macros
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+5,SHAkMenu.menutransitor+2) 
                if Menu:Button("| Macros |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if MacrosList == true then
                        MacrosList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AntiStunList = false
                        FakeLagList = false
                        MacrosList = true
                        SlideList = false
                        JumpList = false
                        Others = false
                    end
                end
                if MacrosList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:CheckBox("Macro Run", Movement.MacroRun.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##12312", Movement.MacroRun.OnKey)
                    if Movement.MacroRun.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("     ", Movement.MacroRun.Key, 200, 20) end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)") then
                        if reindirectbutton == true then
                            reindirectbutton = false
                        else
                            reindirectbutton = true
                        end
                    end
                    if reindirectbutton == true then
                        Hotkeys = true; SHAkMenu.Menu.v = 0;
                        reindirectbutton = false
                    end
                    Menu:Separator()
                    if Movement.MacroRun.SpeedBasedOnHp.v == false then 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:CheckBox2("Run Legit", Movement.MacroRun.Legit)
                    end
                    if Movement.MacroRun.Legit.v and Movement.MacroRun.SpeedBasedOnHp.v then
                        Movement.MacroRun.Legit.v = false Movement.MacroRun.SpeedBasedOnHp.v = false 
                    end
                    if Movement.MacroRun.Legit.v == false and Movement.MacroRun.SpeedBasedOnHp.v == false then
                        Menu:Separator()
                        Menu:PushItemWidth(125)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+35,SHAkMenu.menutransitorstaticreversed+35) Menu:Text("  Run Velocity")
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+35,SHAkMenu.menutransitorstaticreversed+35) if Menu:SliderInt("                                                        ", Movement.MacroRun.Speed, 1, 500) then
                            get.ScriptTimers()
                        end
                        Menu:Separator()
                    end
                    if Movement.MacroRun.Legit.v == false then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) 
                        Menu:CheckBox2("Velocity Based on HP", Movement.MacroRun.SpeedBasedOnHp)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:CheckBox2("Bypass",Movement.MacroRun.Bypass)
                end
            --Slide
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+12,SHAkMenu.menutransitor+9) 
                if Menu:Button("| Slide |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if SlideList == true then
                        SlideList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AntiStunList = false
                        FakeLagList = false
                        SlideList = true
                        MacrosList = false
                        JumpList = false
                        Others = false
                    end
                end
                if SlideList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Slide-Master", Movement.Slide.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##2131", Movement.Slide.OnKey)
                    if Movement.Slide.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("       ", Movement.Slide.Key, 200, 20) end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)") then
                        if reindirectbutton == true then
                            reindirectbutton = false
                        else
                            reindirectbutton = true
                        end
                    end
                    if reindirectbutton == true then
                        Hotkeys = true; SHAkMenu.Menu.v = 0;
                        reindirectbutton = false
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) 
                    Menu:CheckBox2("Weapon Detection",Movement.Slide.PerWeap)
                    if Movement.Slide.PerWeap.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:Button("| Weapon List |") then
                            if WeaponList == true then
                                WeaponList = false
                            else
                                WeaponList = true
                            end
                        end
                        if WeaponList == true then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Silenced-Pistol",Movement.Slide.SilencedPistol)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Desert-Eagle",Movement.Slide.DesertEagle)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Shotgun",Movement.Slide.Shotgun)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sawnoff",Movement.Slide.Sawnoff)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Combat Shotgun",Movement.Slide.CombatShotgun)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("MP5",Movement.Slide.Mp5)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("AK47",Movement.Slide.Ak47)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("M4",Movement.Slide.M4)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Country Rifle",Movement.Slide.CountryRifle)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sniper Rifle",Movement.Slide.SniperRifle)
                        end
                    else
                        WeaponList = false
                    end
                    Menu:PushItemWidth(100)
                        Menu:Separator()
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)
                        if Movement.Slide.PerWeap.v then
                            if Menu:Button("| One Handed Gun |") then
                                if handedgun == true then
                                    handedgun = false
                                else
                                    handedgun = true
                                end
                            end
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Prioritize Fist ##1", Movement.Slide.PrioritizeFist1handedgun)
                        if handedgun == true or Movement.Slide.PerWeap.v == false then
                            Menu:Text("     Min. Velocity") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+62, SHAkMenu.menutransitorstaticreversed+62) Menu:Text("  Max. Velocity")
                            Menu:SliderInt("  ", Movement.Slide.SwitchVelocity[0], 1, Movement.Slide.SwitchVelocity[1].v) Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60, SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("   ", Movement.Slide.SwitchVelocity[1], Movement.Slide.SwitchVelocity[0].v, 10)
                            if Movement.Slide.SwitchVelocity[0].v > Movement.Slide.SwitchVelocity[1].v then
                                Movement.Slide.SwitchVelocity[0].v = Movement.Slide.SwitchVelocity[1].v
                            end
                        end
                        Menu:Separator()
                    if Movement.Slide.PerWeap.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)
                        if Menu:Button("| Two Handed Gun |") then
                            if handedsgun == true then
                                handedsgun = false
                            else
                                handedsgun = true
                            end
                        end 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Prioritize Fist ##2", Movement.Slide.PrioritizeFist2handedgun)
                        if handedsgun == true then
                            Menu:Text("     Min. Velocity") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+62, SHAkMenu.menutransitorstaticreversed+62) Menu:Text("  Max. Velocity")
                            Menu:SliderInt("     ", Movement.Slide.SwitchVelocity[2], 1, Movement.Slide.SwitchVelocity[3].v) Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60, SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("      ", Movement.Slide.SwitchVelocity[3], Movement.Slide.SwitchVelocity[2].v, 10)
                            if Movement.Slide.SwitchVelocity[2].v > Movement.Slide.SwitchVelocity[3].v then
                                Movement.Slide.SwitchVelocity[2].v = Movement.Slide.SwitchVelocity[3].v
                            end
                        end
                        Menu:Separator()
                    end
                    if Movement.Slide.OnKey.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Auto C", Movement.Slide.AutoC)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Slide Speed", Movement.Slide.SpeedEnable)
                    if Movement.Slide.SpeedEnable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Fake Sync", Movement.Slide.SpeedFakeSync)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Speed", Movement.Slide.Speed, 1.000, 5)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Chance", Movement.Slide.SpeedChance, 1, 100)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Duration", Movement.Slide.SpeedDuration, 5, 50)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Type",Movement.Slide.SpeedGameSpeed,"Gamespeed\0SetPlayerVelocity\0\0",1)
                    end
                end
            --FakeLag
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
                if Menu:Button("| FakeLag |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if FakeLagList == true then
                        FakeLagList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AntiStunList = false
                        FakeLagList = true
                        SlideList = false
                        MacrosList = false
                        JumpList = false
                        Others = false
                    end
                end
                if FakeLagList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("FakeLag On Peek", Movement.FakeLagPeek.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Distance From Wall", Movement.FakeLagPeek.DistanceFromWall, 1, 5)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("At Target", Movement.FakeLagPeek.AtTarget)
                    if Movement.FakeLagPeek.AtTarget.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderFloat("Field Of View", Movement.FakeLagPeek.Fov, 0, 60) 
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Desync Delay", Movement.FakeLagPeek.Delay, 1, 500)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("FakeLag Time", Movement.FakeLagPeek.Time, 1, 500)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Draw Wall", Movement.FakeLagPeek.DrawWalls)
                end
            --AntiStun
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
                if Menu:Button("| AntiStun |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if AntiStunList == true then
                        AntiStunList = false
                    else
                        SHAkMenu.menuOpened = 0
                        AntiStunList = true
                        FakeLagList = false
                        SlideList = false
                        MacrosList = false
                        JumpList = false
                        Others = false
                    end
                end
                if AntiStunList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Smart AntiStun", Movement.AntiStun.Enable)
                    Menu:Separator()
                    Menu:PushItemWidth(100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed-5, SHAkMenu.menutransitorstaticreversed) Menu:Text("  Minimum Chance") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+116, SHAkMenu.menutransitorstaticreversed) Menu:Text("  Reset After Shots")
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+237, SHAkMenu.menutransitorstaticreversed) Menu:Text("Increase After Stun")
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed, SHAkMenu.menutransitorstaticreversed) if Menu:SliderInt("       ", Movement.AntiStun.MinChance, 0, 100) then
                        v.StunCount = Movement.AntiStun.MinChance.v
                    end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60, SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("        ", Movement.AntiStun.Timer, 1, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+120, SHAkMenu.menutransitorstaticreversed+120) Menu:SliderInt("             ", Movement.AntiStun.IncreaseMinChance, 0, 100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("AntiStun AFK Check", Movement.AntiStun.AFK)
                end
            --Jump
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+9,SHAkMenu.menutransitor+7) 
                if Menu:Button("| Jump |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if JumpList == true then
                        JumpList = false
                    else
                        SHAkMenu.menuOpened = 0
                        JumpList = true
                        AntiStunList = false
                        FakeLagList = false
                        SlideList = false
                        MacrosList = false
                        Others = false
                    end
                end
                if JumpList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Jump", Doublejump.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##198233", Doublejump.OnKey)
                    if Doublejump.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", Doublejump.Key, 200, 20) end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderFloat("Height", Doublejump.Height, 0.1, 1)
                end
                Menu:Separator()
        else
            AntiStunList = false
            FakeLagList = false
            SlideList = false
            MacrosList = false
            JumpList = false
            Others = false
        end
    --Misc
        if SHAkMenu.Menu.v == 3 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            --Vehicle
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+3,SHAkMenu.menutransitor+3) 
                if Menu:Button("| Vehicle |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if VehicleList == true then
                        VehicleList = false
                    else
                        SHAkMenu.menuOpened = 0
                        TeleportList = false
                        GodmodeList = false
                        VehicleList = true
                        ExtraList = false
                    end
                end
                if VehicleList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Drive No License", Vehicle.DriveNoLicense)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Dont Send EnterVehicle", Vehicle.DriveNoLicenseFakeData)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fast Exit", Vehicle.FastExit)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) if Menu:Button("| Set Hydraulics |") then
                        local vehicleid = vMy.Vehicle
                        local bsData = BitStream()
                        bsWrap:Reset(bsData)
                        bsWrap:Write16(bsData, 65535)
                        bsWrap:Write32(bsData, 2)
                        bsWrap:Write32(bsData, vehicleid)
                        bsWrap:Write32(bsData, 1087)
                        EmulRPC(96,bsData)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti CarJack", Vehicle.AntiCarJack)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Flip", Vehicle.AntiCarFlip)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Never Pop Tires", Vehicle.NeverPopTire) then
                        if  vehicleParts.panels[vMy.ICData.VehicleID] ~= nil then
                                set.VehicleParts(vMy.ICData.VehicleID, vehicleParts.panels[vMy.ICData.VehicleID], vehicleParts.doors[vMy.ICData.VehicleID], vehicleParts.lights[vMy.ICData.VehicleID], 0)
                                v.savedNoTirePop = 1
                        end
                    end
                    if Vehicle.NeverPopTire.v == false and v.savedNoTirePop == 1 then 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) if Menu:Button("| Normal State |") then
                            set.VehicleParts(vMy.ICData.VehicleID, vehicleParts.panels[vMy.ICData.VehicleID], vehicleParts.doors[vMy.ICData.VehicleID], vehicleParts.lights[vMy.ICData.VehicleID], vehicleParts.tires[vMy.ICData.VehicleID])
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Infinity Nitrous", Vehicle.InfinityNitrous)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Nitrous Type",Vehicle.InfinityNitrousType,"Normal\0Invisible\0\0",25) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Boat Fly", Vehicle.BoatFly) then
                       if Vehicle.BoatFly.v then
                            Utils:writeMemory(0x969153, 1, 1, false)
                            Utils:writeMemory(0x969160, 1, 1, false)
                        else
                            Utils:writeMemory(0x969153, 0, 1, false)
                            Utils:writeMemory(0x969160, 0, 1, false)
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Potato Cars", Vehicle.PotatoCars) then
                        if Vehicle.PotatoCars.v then
                            if Vehicle.PotatoType.v == 0 then
                                Utils:writeMemory(0x52C9EE, 1, 1, false)
                                Utils:writeMemory(0x96914B, 0, 1, false)
                            else
                                Utils:writeMemory(0x96914B, 1, 1, false)
                                Utils:writeMemory(0x52C9EE, 0, 1, false)
                            end
                        else
                            Utils:writeMemory(0x96914B, 0, 1, false)
                            Utils:writeMemory(0x52C9EE, 0, 1, false)
                        end
                    end
                    if Vehicle.PotatoCars.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("CarType",Vehicle.PotatoType,"Potato\0Only Wheels\0\0",25)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Perfect Handling", Vehicle.PerfectHandling)
                    if Vehicle.PerfectHandling.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("On Key##2", Vehicle.PerfectHandlingOnKey)
                        if Vehicle.PerfectHandlingKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey(" ", Vehicle.PerfectHandlingKey, 200, 20) end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Deattach Trailer", Vehicle.AutoAttachTrailer)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Freeze Rotation", Vehicle.FreezeRot)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Bike Spam", Vehicle.AutoBike)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65)Menu:SliderInt("Delay##2", Vehicle.BikeDelay, 1, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Motorbike Spam", Vehicle.AutoMotorbike)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65)Menu:SliderInt("Delay##3", Vehicle.MotorbikeDelay, 1, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Auto Unlock Vehicles", Vehicle.Unlock)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Never Off Engine", Vehicle.NeverOffEngine)

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Collision To Other Vehicles (With Players)", Vehicle.NoCarCollision)
                    if Vehicle.NoCarCollision.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("       ", Vehicle.NoCarCollisionKey, 200, 20)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Recover Over Time", Vehicle.Recovery)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Recover Parts at Max HP", Vehicle.RecoverParts)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15)Menu:SliderInt("Delay", Vehicle.ChosenTimer, 1, 1000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15)Menu:SliderFloat("HP Amount", Vehicle.HPAmount, 1, 200.0)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Limit Velocity", Vehicle.LimitVelocity)
                    if Vehicle.LimitVelocity.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Limit at Vehicle Top Speed", Vehicle.SmartLimitMaxVelocity)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderInt("Velocity KM/H", Vehicle.Velocity, 0, 300)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("On Key##4", Vehicle.LimitVelocityOnKey)
                        if Vehicle.LimitVelocityOnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("      ", Vehicle.LimitVelocityKey, 200, 20) end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Car Jump", Vehicle.CarJump)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("   ", Vehicle.CarJumpKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderFloat("Height", Vehicle.Height, 0.1, 1)
                end
            --Godmode
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-4,SHAkMenu.menutransitor-4) 
                if Menu:Button("| Godmode |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if GodmodeList == true then
                        GodmodeList = false
                    else
                        SHAkMenu.menuOpened = 0
                        TeleportList = false
                        GodmodeList = true
                        VehicleList = false
                        ExtraList = false
                    end
                end
                if GodmodeList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox("Godmode", Godmode.PlayerEnable) then
                        if Godmode.PlayerEnable.v == false then
                            local mem = Utils:readMemory(0xB6F5F0, 4, false)
                            Utils:writeMemory(mem+0x42, 0, 1, false)
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Collision Proof", Godmode.PlayerCollision) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Melee Proof", Godmode.PlayerMelee) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Bullet Proof", Godmode.PlayerBullet) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Fire Proof", Godmode.PlayerFire) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Explosion Proof", Godmode.PlayerExplosion) 
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox("GodCar", Godmode.VehicleEnable) then
                        if Godmode.VehicleEnable.v == false then
                            local mem = Utils:readMemory(0xB6F980, 4, false)
                            Utils:writeMemory(mem+0x42, 0, 1, false)
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Collision Proof##2", Godmode.VehicleCollision) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Melee Proof##2", Godmode.VehicleMelee) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Bullet Proof##2", Godmode.VehicleBullet) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Fire Proof##2", Godmode.VehicleFire) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Explosion Proof##2", Godmode.VehicleExplosion) 
                end   
            --Teleport
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
                if Menu:Button("| Teleport |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if TeleportList == true then
                        TeleportList = false
                    else
                        SHAkMenu.menuOpened = 0
                        TeleportList = true
                        GodmodeList = false
                        VehicleList = false
                        ExtraList = false
                    end
                end
                if TeleportList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Teleport", Teleport.Enable)
                    Menu:Separator()
                    
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("From Ground", Teleport.FromGround)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+35,SHAkMenu.menutransitorstaticreversed+35) Menu:Text("Teleport Speed")
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("OnFoot Velocity", Teleport.OnFootVelocity, 0.1, 1000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("InCar Velocity", Teleport.InCarVelocity, 0.1, 1000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Teleports before triggering AC Delay", Teleport.PersonalDelay, 1, 200)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("AC Delay", Teleport.ACDelay, 1, 5000)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Player", Teleport.toPlayer)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                 ", Teleport.toPlayerKey, 200, 20)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Vehicle", Teleport.toVehicle)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                ", Teleport.toVehicleKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox("PutPlayerInVehicle", Teleport.toInside)
                    if Teleport.toInside.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox("as Driver", Teleport.toVehicleDriver)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Type##92",Teleport.toVehicleType,"Send EnterVehicle\0Invisible\0\0",6)
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Object", Teleport.toObject)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("               ", Teleport.ObjectKey, 200, 20)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Checkpoint", Teleport.toCheckpoint)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("              ", Teleport.CheckpointKey, 200, 20)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("Rage (HvH)", Teleport.HvH)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("             ", Teleport.HvHKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Ignore Dead", Teleport.HVHDeath)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Ignore AFK", Teleport.HVHAFK)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderInt("##23", Teleport.HVHWait, 1, 200)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("No PlayerSync", Teleport.HvHAntiKick)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("Attach To Vehicle", Teleport.AttachToVehicle)
                    Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                    if Menu:Button("(?)") then
                        if AttachToVehiclemenu == true then
                            AttachToVehiclemenu = false
                        else
                            AttachToVehiclemenu = true
                        end
                    end
                    if AttachToVehiclemenu == true then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                        Menu:Text("Keep teleporting back to vehicle that you are surfing")
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (1)")
                    if Teleport.SavedPos[0].fX == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos", Teleport.SaveTeleports[0])
                    else
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos", Teleport.LoadTeleports[0]) 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos", Teleport.DelSaveTeleports[0])
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (2)")
                    if Teleport.SavedPos[1].fX == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos ", Teleport.SaveTeleports[1])
                    else
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos ", Teleport.LoadTeleports[1]) 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos ", Teleport.DelSaveTeleports[1])
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (3)")
                    if Teleport.SavedPos[2].fX == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos  ", Teleport.SaveTeleports[2])
                    else
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos  ", Teleport.LoadTeleports[2]) 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos  ", Teleport.DelSaveTeleports[2])
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (4)")
                    if Teleport.SavedPos[3].fX == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos   ", Teleport.SaveTeleports[3])
                    else
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos   ", Teleport.LoadTeleports[3])
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos   ", Teleport.DelSaveTeleports[3])
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+40,SHAkMenu.menutransitorstaticreversed+40) Menu:CheckBox2("Show Pos Position ", Teleport.ShowSaveTeleports) 
                end
            --Extra
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+10,SHAkMenu.menutransitor+8) 
                if Menu:Button("| Extra |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if ExtraList == true then
                        ExtraList = false
                    else
                        SHAkMenu.menuOpened = 0
                        TeleportList = false
                        GodmodeList = false
                        VehicleList = false
                        ExtraList = true
                    end
                end
                if ExtraList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Hide Temp Object", Extra.RemoveObjectTemp.Enable)
                    if Extra.RemoveObjectTemp.Enable.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("      ", Extra.RemoveObjectTemp.Key, 200, 20) 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Time to add the object back", Extra.RemoveObjectTemp.Time, 200, 5000)end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fuck KeyStrokes", Extra.fuckKeyStrokes.Enable)
                    if Extra.fuckKeyStrokes.Enable.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Mode   ",Extra.fuckKeyStrokes.Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                        if Extra.fuckKeyStrokes.Mode.v ~= 2 then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                                if Menu:Button("| Key List |") then
                                    if KeyList == true then
                                        KeyList = false
                                    else
                                        KeyList = true
                                        WeaponList = false
                                    end
                                end
                                if KeyList == true then
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Key.fire)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Key.aim)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Key.horn_crouch)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Key.enterExitCar)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Key.sprint)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Key.walk)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Key.jump)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Key.landingGear_lookback)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Key.tab)
                                end
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                    if Menu:Button("| Auto Weapon Deletion |") then
                        if WeaponList == true then
                            WeaponList = false
                        else
                            WeaponList = true
                            KeyList = false
                        end
                    end
                    if WeaponList == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Slot",SHAcKvar.WeaponSlotCombo,"All Slots\0Slot 0\0Slot 1\0Slot 2\0Slot 3\0Slot 4\0Slot 5\0Slot 6\0Slot 7\0Slot 8\0Slot 9\0Slot 10\0Slot 11\0Slot 12\0\0",25) 
                        if SHAcKvar.WeaponSlotCombo.v == 1 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Brass Knuckles",Extra.AutoDeleteWeapon.Slot0.brass)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 2 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Gold Club",Extra.AutoDeleteWeapon.Slot1.golf)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Night Stick",Extra.AutoDeleteWeapon.Slot1.nitestick)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Knife",Extra.AutoDeleteWeapon.Slot1.knife)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Bat",Extra.AutoDeleteWeapon.Slot1.bat)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Shovel",Extra.AutoDeleteWeapon.Slot1.shovel)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Pool Cue",Extra.AutoDeleteWeapon.Slot1.pool)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Katana",Extra.AutoDeleteWeapon.Slot1.katana)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Chainsaw",Extra.AutoDeleteWeapon.Slot1.chainsaw)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 3 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Colt 9mm",Extra.AutoDeleteWeapon.Slot2.colt)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Silenced 9mm",Extra.AutoDeleteWeapon.Slot2.silenced)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Desert Eagle",Extra.AutoDeleteWeapon.Slot2.desert)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 4 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Shotgun",Extra.AutoDeleteWeapon.Slot3.shotgun)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sawnoff",Extra.AutoDeleteWeapon.Slot3.sawnoff)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Combat",Extra.AutoDeleteWeapon.Slot3.spas)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 5 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Micro SMG/Uzi",Extra.AutoDeleteWeapon.Slot4.uzi)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("MP5",Extra.AutoDeleteWeapon.Slot4.mp5)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tec-9",Extra.AutoDeleteWeapon.Slot4.tec9)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 6 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("AK-47",Extra.AutoDeleteWeapon.Slot5.ak47)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("m4",Extra.AutoDeleteWeapon.Slot5.m4)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 7 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Country-Rifle",Extra.AutoDeleteWeapon.Slot6.cuntgun)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sniper-Rifle",Extra.AutoDeleteWeapon.Slot6.sniper)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 8 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Rocket Launcher",Extra.AutoDeleteWeapon.Slot7.rocket)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Heatseeker",Extra.AutoDeleteWeapon.Slot7.heatseeker)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Flamethrower",Extra.AutoDeleteWeapon.Slot7.flamethrower)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Minigun",Extra.AutoDeleteWeapon.Slot7.minigun)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 9 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Satchel Charge",Extra.AutoDeleteWeapon.Slot8.satchel)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Grenade",Extra.AutoDeleteWeapon.Slot8.grenade)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tear Gas",Extra.AutoDeleteWeapon.Slot8.teargas)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 10 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Spray Can",Extra.AutoDeleteWeapon.Slot9.spraycan)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire Extinguisher",Extra.AutoDeleteWeapon.Slot9.extinguisher)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Camera",Extra.AutoDeleteWeapon.Slot9.camera)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 11 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Purple Dildo",Extra.AutoDeleteWeapon.Slot10.purple)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Dildo",Extra.AutoDeleteWeapon.Slot10.dildo)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Vibrator",Extra.AutoDeleteWeapon.Slot10.vibrator)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Silver Vibrator",Extra.AutoDeleteWeapon.Slot10.silver)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Flowers",Extra.AutoDeleteWeapon.Slot10.flowers)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Cane",Extra.AutoDeleteWeapon.Slot10.cane)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 12 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Night Vision",Extra.AutoDeleteWeapon.Slot11.night)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Thermal Vision",Extra.AutoDeleteWeapon.Slot11.thermal)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Parachute",Extra.AutoDeleteWeapon.Slot11.Parachute)
                        end
                        if SHAcKvar.WeaponSlotCombo.v == 13 or SHAcKvar.WeaponSlotCombo.v == 0 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Detonator",Extra.AutoDeleteWeapon.Slot12.detonator)
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fake Mobile", Extra.Mobile)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Request Spawn", Extra.RequestSpawn)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Health", Extra.RequestSpawnHP, 0, 100)
                    if Extra.RequestSpawnHP.v >= 100 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Armour", Extra.RequestSpawnArmour, 0, 99)
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Send CMD", Extra.SendCMD.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Health##2", Extra.SendCMD.HP, 0, 100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("Message:##2",Extra.SendCMD.Command)
                    if Extra.SendCMD.HP.v >= 100 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Armour##2", Extra.SendCMD.Armour, 0, 99)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Times##2", Extra.SendCMD.Times, 1, 20)
                    if Extra.SendCMD.Times.v > 1 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay##2", Extra.SendCMD.Delay, 0, 20000)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) 
                        if Menu:Button("(?)##192") then
                            if InfoButton2 == true then
                                InfoButton2 = false
                            else
                                InfoButton2 = true
                            end
                        end
                        if InfoButton2 == true then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                            Menu:Text("Delay for the next Time (First one will be instant)")
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Pick PickUP", Extra.PickUP.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Health##5", Extra.PickUP.HP, 0, 100)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:SliderInt("PickUP##111",Extra.PickUP.Model1, 0, 100000)
                        
                    if Extra.PickUP.HP.v >= 100 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Armour##678", Extra.PickUP.Armour, 0, 99)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:SliderInt("PickUP##222",Extra.PickUP.Model2, 0, 100000)
                    end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:SliderInt("Delay##678", Extra.PickUP.Delay, 0, 20000) then
                            get.ScriptTimers()
                        end
                        if Extra.PickUP.HP.v < 100 then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:SliderInt("PickUP##222",Extra.PickUP.Model2, 0, 100000)
                        end
                        if Extra.PickUP.HP.v < 100 then
                            Menu:Text("") 
                        end
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:SliderInt("PickUP##780",Extra.PickUP.Model3, 0, 100000)

                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Auto Reply", Extra.AutoReply[0])
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("To Message", Extra.AutoReply[1])
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:Text("  Message: ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Text("  Reply With: ") 
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) 
                    Menu:InputText("##1", Extra.Message[1])
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SameLine(SHAkMenu.menutransitorstaticreversed+100,SHAkMenu.menutransitorstaticreversed+100) 
                    Menu:InputText("##2", Extra.Reply[1])
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("To TextDraw", Extra.AutoReply[2])
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:Text("  Message: ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Text("  Reply With: ") 
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) 
                    Menu:InputText("##4", Extra.Message[2])
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SameLine(SHAkMenu.menutransitorstaticreversed+100,SHAkMenu.menutransitorstaticreversed+100)
                    Menu:InputText("##3", Extra.Reply[2])
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Weapon Skill", Extra.SetWeaponSkill) then
                        set.PlayerWeaponSkill()
                    end
                    if Extra.SetWeaponSkill.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) if Menu:SliderInt("Level", Extra.SetWeaponSkillLevel, 0, 999) then
                            set.PlayerWeaponSkill()
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Extra WS", Extra.ExtraWS.Enable)
                    if Extra.ExtraWS.Enable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey", Extra.ExtraWS.OnKey)
                        if Extra.ExtraWS.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("        ", Extra.ExtraWS.Key, 200, 20) end
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                        if Menu:Button("(?)") then
                            if reindirectbutton == true then
                                reindirectbutton = false
                            else
                                reindirectbutton = true
                                InfoButton2 = false
                            end
                        end
                        if reindirectbutton == true then
                            Hotkeys = true; SHAkMenu.Menu.v = 0;
                            reindirectbutton = false
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("X##2", Extra.ExtraWS.X)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Y##2", Extra.ExtraWS.Y)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Per Weapon Category", Extra.ExtraWS.PerCategory.Enable)
                        if Extra.ExtraWS.PerCategory.Enable.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Pistols", Extra.ExtraWS.PerCategory.Pistols)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Shotguns", Extra.ExtraWS.PerCategory.Shotguns)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("SMGs", Extra.ExtraWS.PerCategory.SMGs)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Rifles", Extra.ExtraWS.PerCategory.Rifles)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Snipers", Extra.ExtraWS.PerCategory.Snipers)
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Sniper", Extra.AntiSniper) Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Chance ##102", Extra.AntiSniperChance, 0, 100)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type ##2",Extra.AntiSniperTypeMode,"SpecialAction\0Surf\0\0",25) 
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Force Skin", Movement.ForceSkin)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60)Menu:SliderInt("ID", Movement.ChosenSkin, 0, 311)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Force Gravity", Extra.ForceGravity)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderFloat("Gravity", Extra.GravityFloat, 0.001, 0.010)
                    if Extra.ForceGravity.v then
                        set.PlayerGravity()
                    else
                        if Extra.GravityFloat.v ~= 0.008 then
                            set.PlayerGravity()
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Ignore Water Physic", Extra.IgnoreWater) then
                        if Extra.IgnoreWater.v then
                            Utils:writeMemory(0x6C2759, 1, 1, true)
                        else
                            Utils:writeMemory(0x6C2759, 0, 1, true)
                        end
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Apply Animations", Movement.NoAnimations)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Slapper", Extra.AntiSlapper)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Freeze", Extra.AntiFreeze)
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Anti AFK", Extra.AntiAFK) then
                        if Extra.AntiAFK.v then
                            set.EscState()
                        else
                            Utils:writeMemory(0x747FB6, 0x0, 1, false)
                            Utils:writeMemory(0x74805A, 0x0, 1, false)

                            local v1 = {0x0f, 0x84, 0x7b, 0x01, 0x00, 0x00}
                            local v2 = {0x50, 0x51, 0xff, 0x15, 0x00, 0x83, 0x85, 0x00}
                            local index = 0
                            for _, value in ipairs(v1) do
                                Utils:writeMemory(0x53EA88 + index, value, 1, false)
                                index = index + 1
                            end
                            index = 0

                            for _, value in ipairs(v2) do
                                Utils:writeMemory(0x74542B + index, value, 1, false)
                                index = index + 1
                            end
                        end
                    end
                    Menu:Separator()
                    Menu:SameLine(0,0)Menu:Separator()Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) if Menu:Button("| SpecialAction |") then
                        local SpecialACT = 0
                        if Extra.SpecialAction.v == 0 then SpecialACT = 0 end
                        if Extra.SpecialAction.v == 1 then SpecialACT = 2 end
                        if Extra.SpecialAction.v == 2 then SpecialACT = 5 end
                        if Extra.SpecialAction.v == 3 then SpecialACT = 6 end
                        if Extra.SpecialAction.v == 4 then SpecialACT = 7 end
                        if Extra.SpecialAction.v == 5 then SpecialACT = 8 end
                        if Extra.SpecialAction.v == 6 then SpecialACT = 10 end
                        if Extra.SpecialAction.v == 7 then SpecialACT = 11 end
                        if Extra.SpecialAction.v == 8 then SpecialACT = 13 end
                        if Extra.SpecialAction.v == 9 then SpecialACT = 20 end
                        if Extra.SpecialAction.v == 10 then SpecialACT = 21 end
                        if Extra.SpecialAction.v == 11 then SpecialACT = 22 end
                        if Extra.SpecialAction.v == 12 then SpecialACT = 23 end
                        if Extra.SpecialAction.v == 13 then SpecialACT = 68 end
                        if Extra.SpecialAction.v == 14 then SpecialACT = 24 end
                        if Extra.SpecialAction.v == 15 then SpecialACT = 25 end
                        if Jetpack == true then
                            Jetpack = false
                            local bsData = BitStream()
                            bsWrap:Write8(bsData, SpecialACT) 
                            EmulRPC(88,bsData)
                        else
                            Jetpack = true
                        end
                    end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:Combo("    ",Extra.SpecialAction,
                    "NONE\0JETPACK\0DANCE1\0DANCE2\0DANCE3\0DANCE4\0HANDSUP\0CELLPHONE\0STOPCELLPHONE\0DRINK_BEER\0SMOKE_CIGGY\0DRINK_WINE\0DRINK_SPRUNK\0PISSING\0CUFFED\0CARRY\0\0",21)
                end
                Menu:Separator()
        else
            AttachToVehiclemenu = false
            TeleportList = false
            GodmodeList = false
            VehicleList = false
            ExtraList = false
            InfoButton2 = false 
        end
    --Visuals
        if SHAkMenu.Menu.v == 4 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            --Filters
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+6,SHAkMenu.menutransitor+7) 
                if Menu:Button("| Filters |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if FiltersList == true then
                        FiltersList = false
                    else
                        SHAkMenu.menuOpened = 0
                        FiltersList = true
                        IndicatorsList = false
                        WallHackList = false
                        StreamList = false
                        RadarList = false
                    end
                end
                if FiltersList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Filters", Filters.Enable)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed-5, SHAkMenu.menutransitorstaticreversed-5) Menu:Text("    X") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) 
                    if Menu:SliderFloat("                  ", Filters.X, 0, Utils:getResolutionX()) then
                        if Filters.Enable.v then
                            v.filteringid = vMy.ID
                            v.filtertimer = 0
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed-5, SHAkMenu.menutransitorstaticreversed-5) Menu:Text("    Y") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) 
                    if Menu:SliderFloat("               ", Filters.Y, 0, Utils:getResolutionY()) then
                        if Filters.Enable.v then
                            v.filteringid = vMy.ID
                            v.filtertimer = 0
                        end
                    end
                end
            --Indicators
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-4,SHAkMenu.menutransitor-4) 
                if Menu:Button("| Indicators |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if IndicatorsList == true then
                        IndicatorsList = false
                    else
                        SHAkMenu.menuOpened = 0
                        FiltersList = false
                        IndicatorsList = true
                        WallHackList = false
                        StreamList = false
                        RadarList = false
                    end
                end
                if IndicatorsList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Indicators", Indicator.Enable)
                    if Indicator.Enable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Silent", Indicator.Silent)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Damager", Indicator.Damager)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Macro Run", Indicator.MacroRun)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Slide-Master", Indicator.Slide)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Slide-Master Speed", Indicator.SlideSpeed)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show FakeLag Peek", Indicator.FakeLagPeek)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Smart AntiStun", Indicator.AntiStun)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Godmode", Indicator.Godmode)
                        Menu:Text("") Menu:SameLine(0, 0) Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:SliderFloat("         ", Indicator.X, 0, Utils:getResolutionX()) then
                            SHAcKvar.Menu = 1
                        end
                        Menu:Text("") Menu:SameLine(0, 0) Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) 
                        if Menu:SliderFloat("       ", Indicator.Y, 0, Utils:getResolutionY()) then
                            SHAcKvar.Menu = 1
                        end
                    end
                end
            --WallHack
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-15,SHAkMenu.menutransitor-15) 
                if Menu:Button("| Lag WallHack |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if WallHackList == true then
                        WallHackList = false
                    else
                        SHAkMenu.menuOpened = 0
                        FiltersList = false
                        IndicatorsList = false
                        WallHackList = true
                        StreamList = false
                        RadarList = false
                    end
                end
                if WallHackList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)Menu:CheckBox("Lagshot Wallhack", WallHack.Enable)
                    if WallHack.Enable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Sceleton", WallHack.Sceleton)
                    end
                end
            --Stream
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+3,SHAkMenu.menutransitor+3) 
                if Menu:Button("| Stream |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if StreamList == true then
                        StreamList = false
                    else
                        SHAkMenu.menuOpened = 0
                        FiltersList = false
                        IndicatorsList = false
                        WallHackList = false
                        StreamList = true
                        RadarList = false
                    end
                end
                if StreamList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)Menu:CheckBox("Stream Wallhack", StreamWall.Enable)
                    if StreamWall.Enable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show HP/Armor Bar", StreamWall.HP)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("AFK Players", StreamWall.AFK)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Max Players", StreamWall.MaxPlayers, 0, 1004)
                        Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                    ", StreamWall.X, 0, Utils:getResolutionX())
                        Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                              ", StreamWall.Y, 0, Utils:getResolutionY())
                    end
                end
            --Radar
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+6,SHAkMenu.menutransitor+7) 
                if Menu:Button("| Radar |") then
                    SHAkMenu.resetMenuTimerStaticReversed()
                    if RadarList == true then
                        RadarList = false
                    else
                        SHAkMenu.menuOpened = 0
                        FiltersList = false
                        IndicatorsList = false
                        WallHackList = false
                        StreamList = false
                        RadarList = true
                    end
                end
                if RadarList == true then
                    if m_offsets.m_samp_info[v.SampVer] ~= 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox("Show Player Markers", RadarHack.PlayerMarkers) then
                            set.RadarHacks()
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)Menu:CheckBox("3D Radar", RadarHack.Enable)
                    if RadarHack.Enable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Only Who Damaged you", RadarHack.AfterDamage)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Only Out Of View", RadarHack.Onlyoutofview)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Line", RadarHack.ShowLine)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Name", RadarHack.ShowName)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show HP/Armor Bar ", RadarHack.ShowHP)
                        if RadarHack.ShowHP.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderInt("Bar Size", RadarHack.HPSize, 10, 52)
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderInt("Bar Height", RadarHack.HPHeight, 3, 10)
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Link To Bone", RadarHack.LinkedToChar)
                        if RadarHack.LinkedToChar.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderInt("Bone ID", RadarHack.Bone, 1, 54)
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Max Players ", RadarHack.MaxPlayers, 0, 1004)
                        Menu:Text("    Radar Distance")
                        Menu:Separator()
                        Menu:Text("    Low Distance") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50, SHAkMenu.menutransitorstaticreversed+50) Menu:SliderInt("                          ", RadarHack.lowDistance, 0, 350)
                        Menu:Text("    High Distance") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50, SHAkMenu.menutransitorstaticreversed+50) Menu:SliderInt("                       ", RadarHack.maxDistance, 1, 350)
                        Menu:Separator()
                        Menu:Text("    Radar Size") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+40, SHAkMenu.menutransitorstaticreversed+40) Menu:SliderFloat("                            ", RadarHack.maxLength, 0, 30)
                        Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                ", RadarHack.X, 0-Utils:getResolutionX()*0.5, Utils:getResolutionX()*0.5)
                        Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                 ", RadarHack.Y, 0-Utils:getResolutionY()*0.5, Utils:getResolutionY()*0.5)
                    end
                end
                Menu:Separator()
        else
            FiltersList = false
            IndicatorsList = false
            WallHackList = false
            StreamList = false
            RadarList = false
        end
    --Troll
        if SHAkMenu.Menu.v == 5 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("| Troll |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                if TrollList == true then
                    TrollList = false
                else
                    SHAkMenu.menuOpened = 0
                    TrollList = true
                end
            end
            if TrollList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Throw Driver", Troll.RainCars)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)") then
                    if ThrowDrivermenu == true then
                        ThrowDrivermenu = false
                    else
                        ThrowDrivermenu = true
                        reindirectbutton = false
                        RVankamenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                        RVankaSpeed = false
                    end
                end
                if ThrowDrivermenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Throw Vehicle with Driver to the sky (Key B)")
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Fake Pos", Troll.FakePos.Enable)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##1") then
                    if FakePoSHAkMenu == true then
                        FakePoSHAkMenu = false
                    else
                        FakePoSHAkMenu = true
                        reindirectbutton = false
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                        RVankaSpeed = false
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("On Foot", Troll.FakePos.OnFoot)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("In Car", Troll.FakePos.InCar)
                if Troll.FakePos.Enable.v and Troll.FakePos.OnFoot.v or Troll.FakePos.Enable.v and Troll.FakePos.InCar.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox("Randomize Pos", Troll.FakePos.RandomPos)
                    if Troll.FakePos.RandomPos.v == false then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("X##999", Troll.FakePos.X, -10.0, 10.0) 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Y##999", Troll.FakePos.Y, -10.0, 10.0)
                    end
                end 
                if FakePoSHAkMenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Send InCar/OnFoot position + the Fake Pos Slider")
                end
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Quaternion Fucker",Troll.FuckSync)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##2") then
                    if FuckSyncmenu == true then
                        FuckSyncmenu = false
                    else
                        FuckSyncmenu = true
                        reindirectbutton = false
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                        RVankaSpeed = false
                    end
                end
                if FuckSyncmenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Send InCar/OnFoot data about quaternions wrong")
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Parachute Walk",Troll.TrollWalk)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##3") then
                    if TrollWalkmenu == true then
                        TrollWalkmenu = false
                    else
                        TrollWalkmenu = true
                        reindirectbutton = false
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                        RVankaSpeed = false
                    end
                end
                if TrollWalkmenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Send OnFoot stretched parachute animation")
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Vehicle Slapper",Troll.Slapper.Enable)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##4") then
                    if VehicleSlappermenu == true then
                        VehicleSlappermenu = false
                    else
                        VehicleSlappermenu = true
                        reindirectbutton = false
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleTrollmenu = false
                        RVankaSpeed = false
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##1", Troll.Slapper.OnKey)
                if Troll.Slapper.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", Troll.Slapper.Key, 200, 20) end
                if VehicleSlappermenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Send Unoccupied Sync to slap player")
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Fuck Unoccupied",Troll.VehicleTroll)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##5") then
                    if VehicleTrollmenu == true then
                        VehicleTrollmenu = false
                    else
                        VehicleTrollmenu = true
                        reindirectbutton = false
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        RVankaSpeed = false
                    end
                end
                if Troll.VehicleTroll.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type",Troll.VehicleTrollType,"OnSend\0Normal\0Hardcore\0\0",6)
                end
                if VehicleTrollmenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Send Unoccupied Sync to make cars go crazy")
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("RVanka",Troll.RVanka.Enable)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##6") then
                    if RVankamenu == true then
                        RVankamenu = false
                    else
                        RVankamenu = true
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                        reindirectbutton = false
                        RVankaSpeed = false
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##2", Troll.RVanka.OnKey)
                if Troll.RVanka.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("    ", Troll.RVanka.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)##231") then
                    if reindirectbutton == true then
                        reindirectbutton = false
                    else
                        reindirectbutton = true
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                        RVankaSpeed = false
                    end
                end
                if reindirectbutton == true then
                    Hotkeys = true; SHAkMenu.Menu.v = 0;
                    reindirectbutton = false
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Speed##9555",Troll.RVanka.Speed, 0.0, 10)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)##565") then
                    if RVankaSpeed == true then
                        RVankaSpeed = false
                    else
                        RVankaSpeed = true
                        reindirectbutton = false
                        RVankamenu = false
                        ThrowDrivermenu = false
                        FakePoSHAkMenu = false
                        FuckSyncmenu = false
                        TrollWalkmenu = false
                        VehicleSlappermenu = false
                        VehicleTrollmenu = false
                    end
                end
                if RVankaSpeed == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Speed will only work OnFoot and InCar, doesn't affect Heli")
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Distance##2323", Troll.RVanka.Distance, 10, 300) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) if Menu:SliderInt("Delay##2323", Troll.RVanka.Timer, 1, 50) then
                    get.ScriptTimers()
                end
                
                if RVankamenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Send InCar/OnFoot data to go to players and Slap them")
                end
                --Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Detonator Crasher",Troll.Crasher.Detonator)
            end
            Menu:Separator()
        else
            ThrowDrivermenu = false
            FakePoSHAkMenu = false
            FuckSyncmenu = false
            TrollWalkmenu = false
            VehicleSlappermenu = false
            RVankamenu = false
            VehicleTrollmenu = false
            TrollList = false
        end
    --NOPs
        if SHAkMenu.Menu.v == 6 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
            if Menu:Button("| Receive |") then
                
                SHAkMenu.resetMenuTimerStaticReversed()
                if Outgoing == true then
                    Outgoing = false
                else
                    SHAkMenu.menuOpened = 0
                    Incoming = false
                    Outgoing = true
                end
            end
            if Outgoing == true then
                for i = 0, #RPC do
                    if NOPs.Receive[i] ~= nil and RPC[i] ~= "nil" then
                        if NOPs.Receive[i].v or NOPs.Receive[i].v == false then
                            Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("##"..i,NOPs.Receive[i])
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+20,SHAkMenu.menutransitorstaticreversed+20) Menu:Text(""..RPC[i]) 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+145,SHAkMenu.menutransitorstaticreversed+145) Menu:Text("ID: "..i)
                        end
                    end
                end
            end
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+8,SHAkMenu.menutransitor+7) 
            if Menu:Button("| Send |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                if Incoming == true then
                    Incoming = false
                else
                    Outgoing = false
                    Incoming = true
                end
            end
            if Incoming == true then
                for i = 0, #RPC do
                    if NOPs.Send[i] ~= nil and RPC[i] ~= "nil" then
                        if NOPs.Send[i].v or NOPs.Send[i].v == false then
                            Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("##"..i,NOPs.Send[i])
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+20,SHAkMenu.menutransitorstaticreversed+20) Menu:Text(""..RPC[i]) 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+145,SHAkMenu.menutransitorstaticreversed+145) Menu:Text("ID: "..i)
                        end
                    end
                end
            end
            Menu:Separator()
        else
            Outgoing = false
            Incoming = false
        end
    --Config
        if SHAkMenu.Menu.v == 0 then
            SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
            --Save
                Menu:Text("") 
                if SHAkMenu.Folder == -2 then
                    SHAkMenu.Folder = -4;
                end
                if v.Cfgbrokenlines > 0 then Menu:Text("shackled.lua - Broken Config (".. SHAkMenu.ConfigChoosen ..") ".. v.Cfgbrokenlines .." errors!") end
                if SHAkMenu.Folder == -3 or SHAkMenu.Folder == -2 or SHAkMenu.Folder == -4 then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:Text("Config Folder not Found \nv.Waiting for new one!")
                    get.Folder(Config_path)
                    Menu:Text("") 
                end
                if SHAkMenu.Folder > 0 then
                    
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)
                        Menu:Combo("Config",SHAkMenu.Configs,v.ConfigsDefaults,0)
                        if SHAkMenu.Configs.v == 0 then if SHAkMenu.ConfigName.v ~= "Default.SHAk" then SHAkMenu.ConfigName = ImBuffer("Default.SHAk", 255); get.Folder(Config_path) end
                        elseif SHAkMenu.Configs.v == 1 then if SHAkMenu.ConfigName.v ~= "Config1.SHAk" then SHAkMenu.ConfigName = ImBuffer("Config1.SHAk", 255); get.Folder(Config_path) end
                        elseif SHAkMenu.Configs.v == 2 then if SHAkMenu.ConfigName.v ~= "Config2.SHAk" then SHAkMenu.ConfigName = ImBuffer("Config2.SHAk", 255); get.Folder(Config_path) end
                        elseif SHAkMenu.Configs.v == 3 then if SHAkMenu.ConfigName.v ~= "Config3.SHAk" then SHAkMenu.ConfigName = ImBuffer("Config3.SHAk", 255); get.Folder(Config_path) end
                        elseif SHAkMenu.Configs.v == 4 then if SHAkMenu.ConfigName.v ~= "Config4.SHAk" then SHAkMenu.ConfigName = ImBuffer("Config4.SHAk", 255); get.Folder(Config_path) end
                        elseif SHAkMenu.Configs.v == 5 then if SHAkMenu.ConfigName.v ~= "Config5.SHAk" then SHAkMenu.ConfigName = ImBuffer("Config5.SHAk", 255); get.Folder(Config_path) end
                        end
                        
                            v.ConfigsDefaults = string.format("Default\n \0%s\0%s\0%s\0%s\0%s\0\0",v.ConfigsDefault[1],v.ConfigsDefault[2],v.ConfigsDefault[3],v.ConfigsDefault[4],v.ConfigsDefault[5])
                            local updater = ImBool(false)
                            Menu:Text("  ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:CheckBox("Check Updates",updater)
                                if updater.v == true then
                                    get.updateInfo()
                                    updater = false
                                end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)
                    local text1 = "SAVE"
                    if v.Cfgbrokenlines > 0 and SHAkMenu.ConfigName.v == SHAkMenu.ConfigChoosen then
                        text1 = "RESTORE"
                    end
                    if SHAkMenu.Save.v == false then
                        if Menu:Button(text1) then
                            get.Config()
                            if active == true then
                                SHAkMenu.Save.v = false
                            else
                                if SHAkMenu.Config == 0 then
                                    SHAkMenu.Save.v = false
                                    if SHAkMenu.Folder > 0 then
                                        SHAkMenu.SaveF()
                                    end
                                else
                                    SHAkMenu.Save.v = true
                                end
                            end
                        end
                    else
                        if SHAkMenu.Config ~= 0 then
                            if SHAkMenu.Save.v then
                                v.Overwritetimer = v.Overwritetimer + 1
                                if v.Overwritetimer > 250 then
                                    SHAkMenu.Save.v = false;
                                    SHAkMenu.SaveOverWrite.v = false;
                                    v.Overwritetimer = 0
                                end
                                if Menu:Button("OverWrite?") then
                                    get.Config()
                                    if active == true then
                                        v.Overwritetimer = 0
                                        SHAkMenu.SaveOverWrite.v = false
                                    else
                                        v.Overwritetimer = 0
                                        SHAkMenu.SaveOverWrite.v = true
                                        SHAkMenu.Save.v = false
                                    end
                                end 
                            end
                        end
                    end
                    if SHAkMenu.SaveOverWrite.v then
                        if SHAkMenu.Folder > 0 then
                            SHAkMenu.SaveF()
                        end
                        SHAkMenu.SaveOverWrite.v = false
                    end
            --Load
                    if SHAkMenu.Config ~= 0 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45)
                        if Menu:Button("LOAD") then
                            get.Config()
                            if active == true then
                                SHAkMenu.Load.v = false
                            else
                                SHAkMenu.Load.v = true
                            end
                        end
                        if SHAkMenu.Load.v and SHAkMenu.Folder > 0 then
                            SHAkMenu.IsLoading = 1
                            get.Config()
                            get.File(SHAkMenu.ConfigDisk)
                            Timer.Configs[1] = 0
                            SHAkMenu.Loaded = 1
                            if Timer.ChangeColor1 == 0 then Timer.ChangeColor1 = 1 end
                            SHAkMenu.Saved = 0
                        end
                        if SHAkMenu.IsLoading == 0 then
                            SHAkMenu.Load.v = false
                        end
            --Delete
                        if SHAkMenu.Delete.v == false then
                            Menu:Text("  ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:CheckBox("Panic Visuals",Panic.Visuals) 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)
                            if Menu:Button("DELETE") then
                                get.Config()
                                if active == true then
                                    SHAkMenu.Delete.v = false
                                else
                                    SHAkMenu.Delete.v = true
                                end
                            end
                            if SHAkMenu.DeleteYes.v then
                                os.remove(SHAkMenu.ConfigDisk)
                                get.Config()
                                SHAkMenu.DeleteYes.v = false
                            end
                            if SHAkMenu.DeleteNo.v then
                                SHAkMenu.DeleteNo.v = false
                            end
                        else
                            Menu:Text("  ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:Text("Delete Config??")
                            Menu:Text("  ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)
                            if Menu:Button("YES") then
                                get.Config()
                                if active == true then
                                    SHAkMenu.DeleteYes.v = false
                                else
                                    SHAkMenu.DeleteYes.v = true
                                end
                            end
                            Menu:SameLine(35,35)
                            if Menu:Button("NO") then
                                if active == true then
                                    SHAkMenu.DeleteNo.v = false
                                else
                                    SHAkMenu.DeleteNo.v = true
                                end
                            end
                            if SHAkMenu.DeleteYes.v then
                                SHAkMenu.Delete.v = false
                            end
                            if SHAkMenu.DeleteNo.v then
                                    SHAkMenu.Delete.v = false
                            end
                        end
                    else
                        Menu:Text("  ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:CheckBox("Panic Visuals",Panic.Visuals) 
                    end
                end
                Menu:Text("  ") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:CheckBox("Panic Everything no Visuals",Panic.EveryThingExceptVisuals) 
            --shackled.lua Indicator
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:Text("shackled.lua Indicator \n(Save / Load & Others)")
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) if Menu:CheckBox("FPS Boost",SHAkMenu.FpsBoost) then
                    if SHAkMenu.FpsBoost.v then
                        Utils:writeMemory2(0x53E227, "\xC3", 1, false)
                    else
                        Utils:writeMemory2(0x53E227, "\xE9", 1, false)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed-5, SHAkMenu.menutransitorstaticreversed-5) Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) 
                if Menu:SliderFloat("              ", SHAkMenu.X, 0, Utils:getResolutionX()) then SHAkMenu.Open = 1 end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) if Menu:CheckBox("Refresh Rate",SHAkMenu.RefreshHZ) then
                    if SHAkMenu.RefreshHZ.v  then
                        Utils:writeMemory(0xC9C070, 0, 1, false)
                    else
                        Utils:writeMemory(0xC9C070, 60, 1, false)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed-5, SHAkMenu.menutransitorstaticreversed-5) Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) 
                if Menu:SliderFloat("            ", SHAkMenu.Y, 0, Utils:getResolutionY()) then SHAkMenu.Open = 1 end            
                Menu:Separator()
            --Hotkeys
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-2,SHAkMenu.menutransitor-3) 
                if Menu:Button("  | Hotkeys |") then
                    if Hotkeys == true then
                        Hotkeys = false
                    else
                        SHAkMenu.menuOpened = 0
                        CommandsList = false
                        Hotkeys = true
                    end
                end
                if Hotkeys == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Panic Visuals") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##1", Panic.VisualsKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Panic Aimbot & Others") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##2", Panic.EveryThingExceptVisualsKey, 200, 20)
                    Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Aim Assist") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##3", AimAssist.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##3",AimAssist.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Silent") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##4", Silent.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##4",Silent.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Damager") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##5", Damager.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##5",Damager.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Damage Changer") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##6", DamageChanger.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##6",DamageChanger.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Extra WS") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##7", Extra.ExtraWS.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##7",Extra.ExtraWS.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Macro Run") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##8", Movement.MacroRun.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##8",Movement.MacroRun.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("RVanka") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##9", Troll.RVanka.Key, 200, 20)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##9",Troll.RVanka.KeyType,"Hold\0Toggle\0\0",9)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Separator()

                    
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Teleport To Player") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##23", Teleport.toPlayerKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Teleport To Vehicle") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##24", Teleport.toVehicleKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Teleport To Object") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##25", Teleport.ObjectKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Teleport To Checkpoint") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##26", Teleport.CheckpointKey, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Teleport Rage (HvH)") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##27", Teleport.HvHKey, 200, 20)
                    Menu:Separator()

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Slide") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##28", Movement.Slide.Key, 200, 20) 
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Slapper") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##29", Troll.Slapper.Key, 200, 20) 
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Player Jump") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##30", Doublejump.Key, 200, 20) 
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Car Jump") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##31", Vehicle.CarJumpKey, 200, 20) 
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Limit Vehicle Velocity") 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Hotkey("##32", Vehicle.LimitVelocityKey, 200, 20) 
                end
                Menu:Separator()
            --Commands
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-12,SHAkMenu.menutransitor-12) 
                if Menu:Button("  | Commands |") then
                    if CommandsList == true then
                        CommandsList = false
                    else
                        SHAkMenu.menuOpened = 0
                        Hotkeys = false
                        CommandsList = true
                    end
                end
                if CommandsList == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Add Filter ", Commands.Filters)
                    if Commands.Filters.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:Text("cmd:") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+110,SHAkMenu.menutransitorstaticreversed+110) 
                        if Menu:InputText("#1", Commands.FiltersChosen) then
                            Commands.FiltersChosen.v = string.lower(Commands.FiltersChosen.v)
                        end 
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Create Vehicle", Commands.CreateVeh)
                    if Commands.CreateVeh.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+69) Menu:Text("Normal cmd:") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+110,SHAkMenu.menutransitorstaticreversed+110) 
                        if Menu:InputText("#2", Commands.CreateVehNormal) then
                            Commands.CreateVehNormal.v = string.lower(Commands.CreateVehNormal.v)
                        end 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+69) Menu:Text("Invisible cmd:") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+110,SHAkMenu.menutransitorstaticreversed+110) 
                        if Menu:InputText("#3", Commands.CreateVehInvisible) then
                            Commands.CreateVehInvisible.v = string.lower(Commands.CreateVehInvisible.v)
                        end 
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Set Skin", Commands.SetSkin)
                    if Commands.SetSkin.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:Text("cmd:") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+110,SHAkMenu.menutransitorstaticreversed+110) 
                        if Menu:InputText("#4", Commands.SetSkinChosen) then
                            Commands.SetSkinChosen.v = string.lower(Commands.SetSkinChosen.v)
                        end 
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Give Weapon", Commands.GiveWeapon)
                    if Commands.GiveWeapon.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:Text("cmd:") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+110,SHAkMenu.menutransitorstaticreversed+110) 
                        if Menu:InputText("#5", Commands.GiveWeaponChosen) then
                            Commands.GiveWeaponChosen.v = string.lower(Commands.GiveWeaponChosen.v)
                        end 
                    end
                    Menu:Separator()
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Set Special Action", Commands.SetSpecialAction)
                    if Commands.SetSpecialAction.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90,SHAkMenu.menutransitorstaticreversed+90) Menu:Text("cmd:") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+110,SHAkMenu.menutransitorstaticreversed+110) 
                        if Menu:InputText("#6", Commands.SetSpecialActionChosen) then
                            Commands.SetSpecialActionChosen.v = string.lower(Commands.SetSpecialActionChosen.v)
                        end 
                    end
                end
                Menu:Separator()
            --Credits
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
                if Menu:Button("  | Credits |") then
                    if Credits == true then
                        Credits = false
                    else
                        Credits = true
                    end
                end
                if Credits == true then
                    if Menu:Button("    | shackled.lua Discord |") then
                        os.execute("start https://discord.gg/Bu99V9MQQF")
                    end
                    if Menu:Button("    | Youtube Channel |") then
                        os.execute("start https://youtube.com/c/unfadedLIGHT")
                    end
                    if Menu:Button("    | ExtremeCheats Profile |") then
                        os.execute("start https://extremecheats.me/members/saddam27.4005/")
                    end
                    if Menu:Button("    | Donation |") then
                        os.execute("start https://www.paypal.com/donate/?hosted_button_id=RFYCSBMLM7BYA")
                    end
                end
            --SendChatMessages
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox(" Send Chat Messages", SHAkMenu.ChatMessage)
            Menu:Separator()
        else
            CommandsList = false
            Hotkeys = false
            SHAkMenu.Open = 0
        end
    end
--
--!  HOOKS
        Hooks:Register(HOOK_MENU, Menus) 
        Hooks:Register(HOOK_RENDER, RenderVisuals)
        Hooks:Register(HOOK_MAINLOOP, Mainloop)
        Hooks:Register(HOOK_BULLETSYNC, BulletSync)
        Hooks:Register(HOOK_SENDRPC, OnSendRPC)   
        Hooks:Register(HOOK_SENDPACKET, OnSendPacket)   
        Hooks:Register(HOOK_RECEIVERPC, OnReceiveRPC)
        Hooks:Register(HOOK_RECEIVEPACKET, OnReceivePacket)
--
--Checkers
    get.Config()
    set.PlayerWeaponSkill()
    set.PlayerGravity()
    set.FightStyle()
    set.CJWalk()
--
