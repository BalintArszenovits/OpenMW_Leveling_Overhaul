local NPC = require('openmw.self')
local Actor = require('openmw.types').Actor
local LevelStats = require('openmw.types').Actor.stats.level
local HealthStats = require('openmw.types').Actor.stats.dynamic.health
local MagickaStats = require('openmw.types').Actor.stats.dynamic.magicka
local AttributesStats = require('openmw.types').Actor.stats.attributes
local NpcRecord = require('openmw.types').NPC.record(NPC)
local Core = require('openmw.core')

local scriptVersion = 1

local debug = true

local adjusted = false

local raceBaseAttributes = {
    ["Argonian"] = {
        ["male"] = {
            ["strength"] = 40,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 30,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 40,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 40,
            ["speed"] = 40,
            ["endurance"] = 30,
            ["personality"] = 30,
            ["luck"] = 40
        }
    },
    ["Breton"] = {
        ["male"] = {
            ["strength"] = 40,
            ["intelligence"] = 50,
            ["willpower"] = 50,
            ["agility"] = 30,
            ["speed"] = 30,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 30,
            ["intelligence"] = 50,
            ["willpower"] = 50,
            ["agility"] = 30,
            ["speed"] = 40,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        }
    },
    ["Dark Elf"] = {
        ["male"] = {
            ["strength"] = 40,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 40,
            ["speed"] = 50,
            ["endurance"] = 40,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 40,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 40,
            ["speed"] = 50,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        }
    },
    ["High Elf"] = {
        ["male"] = {
            ["strength"] = 30,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 40,
            ["speed"] = 30,
            ["endurance"] = 40,
            ["personality"] = 40,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 30,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 40,
            ["speed"] = 40,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        }
    },
    ["Imperial"] = {
        ["male"] = {
            ["strength"] = 40,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 30,
            ["speed"] = 40,
            ["endurance"] = 40,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 40,
            ["intelligence"] = 40,
            ["willpower"] = 40,
            ["agility"] = 30,
            ["speed"] = 30,
            ["endurance"] = 40,
            ["personality"] = 50,
            ["luck"] = 40
        }
    },
    ["Khajiit"] = {
        ["male"] = {
            ["strength"] = 40,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 40,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 30,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 40,
            ["endurance"] = 40,
            ["personality"] = 40,
            ["luck"] = 40
        }
    },
    ["Nord"] = {
        ["male"] = {
            ["strength"] = 50,
            ["intelligence"] = 30,
            ["willpower"] = 40,
            ["agility"] = 30,
            ["speed"] = 40,
            ["endurance"] = 50,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 50,
            ["intelligence"] = 30,
            ["willpower"] = 50,
            ["agility"] = 30,
            ["speed"] = 40,
            ["endurance"] = 40,
            ["personality"] = 30,
            ["luck"] = 40
        }
    },
    ["Orc"] = {
        ["male"] = {
            ["strength"] = 45,
            ["intelligence"] = 30,
            ["willpower"] = 50,
            ["agility"] = 35,
            ["speed"] = 30,
            ["endurance"] = 50,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 45,
            ["intelligence"] = 40,
            ["willpower"] = 45,
            ["agility"] = 35,
            ["speed"] = 30,
            ["endurance"] = 50,
            ["personality"] = 25,
            ["luck"] = 40
        }
    },
    ["Redguard"] = {
        ["male"] = {
            ["strength"] = 50,
            ["intelligence"] = 30,
            ["willpower"] = 30,
            ["agility"] = 40,
            ["speed"] = 40,
            ["endurance"] = 50,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 40,
            ["intelligence"] = 30,
            ["willpower"] = 30,
            ["agility"] = 40,
            ["speed"] = 40,
            ["endurance"] = 50,
            ["personality"] = 40,
            ["luck"] = 40
        }
    },
    ["Wood Elf"] = {
        ["male"] = {
            ["strength"] = 30,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        },
        ["female"] = {
            ["strength"] = 30,
            ["intelligence"] = 40,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 30,
            ["personality"] = 40,
            ["luck"] = 40
        }
    }
}

local function log(text)
    if (debug) then
        print(tostring(text))
    end
end

local function getSex()
    log("***getSex()***")
    local headPath = NpcRecord.head
    local sex = nil

    if (string.find(string.lower(headPath), "f_head")) then
        sex = "female"
    else
        sex = "male"
    end

    return sex
end

local function adjustAttributes()
    log("***adjustAttributes()***")
    local sex = getSex()
    log("SEX: "..sex)

    for attribute, pointer in pairs(AttributesStats) do
        local attributeStat = pointer(NPC)
        log(attribute.." - "..attributeStat.base)

        if (attributeStat.base > (raceBaseAttributes[NpcRecord.race][sex][attribute] + 50)) then
            attributeStat.base = raceBaseAttributes[NpcRecord.race][sex][attribute] + 50
            log("CORRECT ATTRIBUTE, NEW VALUE: "..attributeStat.base)
        end
    end
end

local function adjustHealth()
    log("***adjustHealth()***")

    local strength =  AttributesStats.strength(NPC).base
    local endurance = AttributesStats.endurance(NPC).base
    local level = LevelStats(NPC).current
    local health = strength + endurance + (level - 1)

    HealthStats(NPC).base = health
    HealthStats(NPC).current = health
    log("Adjusted health: "..HealthStats(NPC).base)
end

local function adjustMagicka()
    log("***adjustMagicka()***")

    local racialBonusTable = {
        ["Breton"] = 0.5,
        ["High Elf"] = 1.5
    }
    local race = NpcRecord.race
    local racialBonus = racialBonusTable[race] or 0 --todo, get Birth Sign
    log("RACE: "..race.." - "..racialBonus)
    local npcBaseMagickaMult = Core.getGMST("fNPCbaseMagickaMult") or 1
    local intelligence =  AttributesStats.intelligence(NPC).base
    local magicka = (intelligence * npcBaseMagickaMult) + (intelligence * racialBonus) --Todo, read global setting
    
    MagickaStats(NPC).base = magicka
    MagickaStats(NPC).current = magicka

    log("Adjusted magicka is: "..MagickaStats(NPC).base)
end

local function adjustNpc()
    log("***adjustNpc()***")
    log("NAME: "..NPC.recordId)

    if (not Actor.canMove(NPC)) then
        log("NPC is dead, skip")
        adjusted = true
        return
    end

    adjustAttributes()
    adjustHealth()
    adjustMagicka()

    adjusted = true
end

local function onSave()
    log("***onSave()***")
    return {
        version = scriptVersion,
        adjusted = adjusted
    }
end

local function onLoad(data)
    log("***onLoad()***")
    if (not data or not data.version or data.version < scriptVersion) then
        log('Was saved with an old version of the script, initializing to default')
        adjusted = false
        return
    end

    if (data.version > scriptVersion) then
        error('Required update to a new version of the script')
    end

    adjusted = data.adjusted
end

return {
    engineHandlers = {
        onActive = function()
            if (not adjusted) then
                adjustNpc()
            end
        end,
        onSave = onSave,
        onLoad = onLoad
    }
}