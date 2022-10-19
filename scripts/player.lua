local SkillStats = require('openmw.types').NPC.stats.skills
local AttributesStats = require('openmw.types').Actor.stats.attributes
local HealthStats = require('openmw.types').Actor.stats.dynamic.health
local MagickaStats = require('openmw.types').Actor.stats.dynamic.magicka
local LevelStats = require('openmw.types').Actor.stats.level
local Actor = require('openmw.self')
local NpcRecord = require('openmw.types').NPC.record(Actor)
local core = require('openmw.core')
local UI = require('openmw.ui')

local scriptVersion = 1
local debug = true

local attributePerSkill = 5

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

local skillsTree = {
    ["agility"] = {
        ["acrobatics"] = true,
        ["block"] = true,
        ["lightarmor"] = true,
        ["marksman"] = true,
        ["sneak"] = true
    },
    ["endurance"] = {
        ["heavyarmor"] = true,
        ["mediumarmor"] = true,
        ["spear"] = true
    },
    ["intelligence"] = {
        ["alchemy"] = true,
        ["conjuration"] = true,
        ["enchant"] = true,
        ["security"] = true
    },
    ["luck"] = {

    },
    ["personality"] = {
        ["illusion"] = true,
        ["mercantile"] = true,
        ["speechcraft"] = true
    },
    ["speed"] = {
        ["athletics"] = true,
        ["shortblade"] = true,
        ["unarmored"] = true
    },
    ["strength"] = {
        ["armorer"] = true,
        ["axe"] = true,
        ["bluntweapon"] = true,
        ["longblade"] = true,
        ["handtohand"] = true
    },
    ["willpower"] = {
        ["alteration"] = true,
        ["destruction"] = true,
        ["mysticism"] = true,
        ["restoration"] = true
    }
}

local skillsValues = {}
local attributesProgression = {}

local function updateAttributesProgression()
    print("***updateAttributesProgression()***")
    for attribute, skills in pairs(skillsTree) do
        for skill, _ in pairs(skills) do

            local currentValue = SkillStats[skill](Actor).base
            local previousValue = skillsValues[skill]

            local attributeProgression = currentValue - previousValue
            attributesProgression[attribute] = attributesProgression[attribute] + attributeProgression

            skillsValues[skill] = currentValue

            print(attribute.." - "..skill.." - "..attributeProgression)
        end
        print(attribute.." total progression: "..attributesProgression[attribute])
    end
end

local function getSex()
    print("***getSex()***")
    local headPath = NpcRecord.head
    local sex = nil

    if (string.find(string.lower(headPath), "f_head")) then
        sex = "female"
    else
        sex = "male"
    end

    return sex
end

local function progressAttributes()
    print("***progressAttributes()***")
    for attribute, progression in pairs(attributesProgression) do
        if (progression >= attributePerSkill) then
            local progressAttributeBy = math.floor(progression / attributePerSkill)
            local remainder = math.fmod(progression, attributePerSkill)

            AttributesStats[attribute](Actor).base = AttributesStats[attribute](Actor).base + progressAttributeBy
            attributesProgression[attribute] = remainder

            local max = raceBaseAttributes[NpcRecord.race][getSex()][attribute] + 50
            if ((AttributesStats[attribute](Actor).base) > max) then
                AttributesStats[attribute](Actor).base = max
            end

            print(attribute.." - "..progressAttributeBy.." - "..attributesProgression[attribute])
        end
    end
end

local function progressHealth(updateCurrentHealth)
    print("***progressHealth()***")
    local strength =  AttributesStats.strength(Actor).base
    local endurance = AttributesStats.endurance(Actor).base
    local level = LevelStats(Actor).current
    local birthsignBonus = 0

    local health = strength + endurance + (level - 1) + birthsignBonus

    HealthStats(Actor).base = health
    if (updateCurrentHealth) then
        HealthStats(Actor).current = health
    end
    print("New base health is: "..health)
end

local function progressMagicka(updateCurrentMagicka)
    print("***progressMagicka()***")
    local racialBonusTable = {
        ["Breton"] = 0.5,
        ["High Elf"] = 1.5
    }
    local birthSignBonusTable = {
        ["The Mage"] = 0.5,
        ["The Apprentice"] = 1.5,
        ["The Atronach"] = 2.0
    }

    local race = NpcRecord.race
    local racialBonus = racialBonusTable[race] or 0
    local npcBaseMagickaMult = core.getGMST("fNPCbaseMagickaMult") or 1
    local birthSignBonus = 0 --todo, get Birth Sign
    local intelligence =  AttributesStats.intelligence(Actor).base
    local magicka = (intelligence * npcBaseMagickaMult) + (intelligence * racialBonus) + (intelligence * birthSignBonus) --Todo, read global setting
    
    MagickaStats(Actor).base = magicka
    if (updateCurrentMagicka) then
        MagickaStats(Actor).current = magicka
    end
    print("New base magicka is: "..MagickaStats(Actor).base)
end

local function initialize()
    print("***initialize()***")
    for attribute, skills in pairs(skillsTree) do
        for skill, _ in pairs(skills) do
            skillsValues[skill] = SkillStats[skill](Actor).base
            print(attribute.." - "..skill.." - "..skillsValues[skill])
        end
        attributesProgression[attribute] = 0
    end

    progressHealth(true)
    -- progressMagicka(true)
end

local function onSave()
    print("***onSave()***")
    return {
        version = scriptVersion,
        skillsValues = skillsValues,
        attributesProgression = attributesProgression
    }
end

local function onLoad(data)
    print("***onLoad()***")
    if (not data or not data.version or data.version < scriptVersion) then
        print('Was saved with an old version of the script, initializing to default')
        initialize()
        return
    end

    if (data.version > scriptVersion) then
        error('Required update to a new version of the script')
    end

    skillsValues = data.skillsValues
    attributesProgression = data.attributesProgression
end

return {
    engineHandlers = {
        onKeyPress = function(key)
            if key.symbol == 'm' then
                initialize()
                UI.showMessage("INITIALIZE")
            end

            if key.symbol == 'u' then
                updateAttributesProgression()
                progressAttributes()
                progressHealth(false)
                -- progressMagicka(false)
                UI.showMessage("updateAttributesProgression")
            end
        end,
        onSave = onSave,
        onLoad = onLoad,
    }
}