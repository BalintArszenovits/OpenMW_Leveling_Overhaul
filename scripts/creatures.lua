local Creature = require('openmw.self')
local Actor = require('openmw.types').Actor
local LevelStats = require('openmw.types').Actor.stats.level
local HealthStats = require('openmw.types').Actor.stats.dynamic.health
local AttributesStats = require('openmw.types').Actor.stats.attributes

local scriptVersion = 1

local adjusted = false
local healthPerLevelMultiplier = 20

local creatureStats = {
    -- ALIT
    ["alit"] = {
        ["attributes"] = {
            ["strength"] = 80,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 5
    },
    ["alit_diseased"] = {
        ["attributes"] = {
            ["strength"] = 80,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 50,
            ["speed"] = 45,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 6
    },
    ["alit_blighted"] = {
        ["attributes"] = {
            ["strength"] = 80,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 50,
            ["speed"] = 40,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 7
    },
    -- CRAB
    ["mudcrab"] = {
        ["attributes"] = {
            ["strength"] = 15,
            ["intelligence"] = 15,
            ["willpower"] = 10,
            ["agility"] = 15,
            ["speed"] = 20,
            ["endurance"] = 15,
            ["personality"] = 75,
            ["luck"] = 40
        },
        ["level"] = 1
    },
    ["mudcrab-diseased"] = {
        ["attributes"] = {
            ["strength"] = 15,
            ["intelligence"] = 15,
            ["willpower"] = 10,
            ["agility"] = 15,
            ["speed"] = 15,
            ["endurance"] = 15,
            ["personality"] = 75,
            ["luck"] = 40
        },
        ["level"] = 2        
    },
    ["mr_rockcrab"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 15,
            ["willpower"] = 10,
            ["agility"] = 15,
            ["speed"] = 20,
            ["endurance"] = 15,
            ["personality"] = 75,
            ["luck"] = 40
        },
        ["level"] = 2        
    },
    -- DREUGH
    ["dreugh"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 70,
            ["agility"] = 50,
            ["speed"] = 60,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 6   
    },
    -- GUAR
    ["guar"] = {
        ["attributes"] = {
            ["strength"] = 70,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 4  
    },
    ["guar_feral"] = {
        ["attributes"] = {
            ["strength"] = 70,
            ["intelligence"] = 50,
            ["willpower"] = 40,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 4  
    },
    -- KAGOUTI
    ["kagouti"] = {
        ["attributes"] = {
            ["strength"] = 90,
            ["intelligence"] = 30,
            ["willpower"] = 50,
            ["agility"] = 60,
            ["speed"] = 50,
            ["endurance"] = 70,
            ["personality"] = 100,
            ["luck"] = 40
        },
        ["level"] = 6  
    },
    ["kagouti_diseased"] = {
        ["attributes"] = {
            ["strength"] = 90,
            ["intelligence"] = 30,
            ["willpower"] = 50,
            ["agility"] = 60,
            ["speed"] = 45,
            ["endurance"] = 70,
            ["personality"] = 100,
            ["luck"] = 40
        },
        ["level"] = 7  
    },
    ["kagouti_blighted"] = {
        ["attributes"] = {
            ["strength"] = 90,
            ["intelligence"] = 30,
            ["willpower"] = 50,
            ["agility"] = 60,
            ["speed"] = 40,
            ["endurance"] = 70,
            ["personality"] = 100,
            ["luck"] = 40
        },
        ["level"] = 8  
    },
    -- KWAMA
    ["scrib"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 30,
            ["willpower"] = 0,
            ["agility"] = 20,
            ["speed"] = 20,
            ["endurance"] = 30,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["level"] = 1   
    },
    ["scrib diseased"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 30,
            ["willpower"] = 0,
            ["agility"] = 20,
            ["speed"] = 15,
            ["endurance"] = 30,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["level"] = 2
    },
    ["scrib blighted"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 30,
            ["willpower"] = 0,
            ["agility"] = 20,
            ["speed"] = 10,
            ["endurance"] = 30,
            ["personality"] = 30,
            ["luck"] = 40
        },
        ["level"] = 2
    },
    ["kwama forager"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 15,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 1
    },
    ["kwama worker"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 20,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 3
    },
    ["kwama warrior"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 20,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 4
    },
    -- CLIFF RACER
    ["cliff racer"] = {
        ["attributes"] = {
            ["strength"] = 40,
            ["intelligence"] = 60,
            ["willpower"] = 30,
            ["agility"] = 60,
            ["speed"] = 200,
            ["endurance"] = 50,
            ["personality"] = 20,
            ["luck"] = 40
        },
        ["level"] = 3      
    },
    ["cliff racer_diseased"] = {
        ["attributes"] = {
            ["strength"] = 40,
            ["intelligence"] = 60,
            ["willpower"] = 30,
            ["agility"] = 60,
            ["speed"] = 200,
            ["endurance"] = 50,
            ["personality"] = 20,
            ["luck"] = 40
        },
        ["level"] = 4      
    },
    ["cliff racer_blighted"] = {
        ["attributes"] = {
            ["strength"] = 40,
            ["intelligence"] = 60,
            ["willpower"] = 30,
            ["agility"] = 60,
            ["speed"] = 200,
            ["endurance"] = 50,
            ["personality"] = 20,
            ["luck"] = 40
        },
        ["level"] = 5      
    },
    --NIX-HOUND
    ["nix-hound"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 60,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 3
    },
    ["mr_diseased_nix_hound"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 55,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 4
    },
    --RAT
    ["rat"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 25,
            ["willpower"] = 0,
            ["agility"] = 30,
            ["speed"] = 30,
            ["endurance"] = 70,
            ["personality"] = 10,
            ["luck"] = 40
        },
        ["level"] = 2
    },
    ["rat_diseased"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 25,
            ["willpower"] = 0,
            ["agility"] = 30,
            ["speed"] = 15,
            ["endurance"] = 70,
            ["personality"] = 10,
            ["luck"] = 40
        },
        ["level"] = 3
    },
    ["rat_blighted"] = {
        ["attributes"] = {
            ["strength"] = 20,
            ["intelligence"] = 25,
            ["willpower"] = 0,
            ["agility"] = 30,
            ["speed"] = 10,
            ["endurance"] = 70,
            ["personality"] = 10,
            ["luck"] = 40
        },
        ["level"] = 4
    },
    -- SLAUGHTERFISH
    ["slaughterfish_small"] = {
        ["attributes"] = {
            ["strength"] = 30,
            ["intelligence"] = 50,
            ["willpower"] = 50,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 1
    },
    ["slaughterfish"] = {
        ["attributes"] = {
            ["strength"] = 60,
            ["intelligence"] = 50,
            ["willpower"] = 50,
            ["agility"] = 50,
            ["speed"] = 50,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 2
    },
    ["mr_bull_netch_swamp"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 50,
            ["agility"] = 50,
            ["speed"] = 100,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 5       
    },
    ["mr_betty_netch_swamp"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 80,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 10        
    },
    ["netch_bull"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 50,
            ["agility"] = 50,
            ["speed"] = 100,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 5       
    },
    ["netch_betty"] = {
        ["attributes"] = {
            ["strength"] = 50,
            ["intelligence"] = 50,
            ["willpower"] = 30,
            ["agility"] = 50,
            ["speed"] = 80,
            ["endurance"] = 50,
            ["personality"] = 50,
            ["luck"] = 40
        },
        ["level"] = 10        
    },
}

local function adjustCreature()
    print("***adjustCreature()***")
    if (not Actor.canMove(Creature)) then
        print("Creature ["..Creature.recordId.."] is dead, skip")
        adjusted = true
        return
    end

    local stats = creatureStats[Creature.recordId]
    if (stats) then
        for attribute, value in pairs(stats.attributes) do
            local newValue = math.floor(value * (math.random(90, 110) / 100))
            AttributesStats[attribute](Creature).base = newValue
            print(attribute.." BASE: ["..value.."] NEW: ["..AttributesStats[attribute](Creature).base.."]")
        end

        local level = stats.level
        local health = math.floor(level * healthPerLevelMultiplier * (math.random(90, 110) / 100))
        HealthStats(Creature).base = health
        HealthStats(Creature).current = health

        print("Creature Rebalanced #1: ["..Creature.recordId.."] - Level: ["..level.."] - Health: ["..HealthStats(Creature).base.."]")
        adjusted = true
    else
        local level = LevelStats(Creature).current
        local health = level * healthPerLevelMultiplier
        HealthStats(Creature).base = health
        HealthStats(Creature).current = health

        print("Creature Rebalanced #2: ["..Creature.recordId.."] - Level: ["..level.."] - Health: ["..HealthStats(Creature).base.."]")
        adjusted = false
    end

    --adjusted = true
end

local function onSave()
    print("***onSave()***")
    return {
        version = scriptVersion,
        adjusted = adjusted
    }
end

local function onLoad(data)
    print("***onLoad()***")
    if (not data or not data.version or data.version < scriptVersion) then
        print('Was saved with an old version of the script, initializing to default')
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
                adjustCreature()
            end
        end,
        onSave = onSave,
        onLoad = onLoad
    }
}

