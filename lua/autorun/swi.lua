SWI = SWI or {}
SWI.__index = SWI

if SERVER then
    AddCSLuaFile("swi/set.lua")
    AddCSLuaFile("swi/sets.lua")
    AddCSLuaFile("swi/gui.lua")
    include("swi/set.lua")
    include("swi/sets.lua")
else
    include("swi/set.lua")
    include("swi/sets.lua")
    include("swi/gui.lua")
end

function SWI.createSet(player, name)
    local set = SWI.Set.init(name)

    for _, weapon in pairs(player:GetWeapons()) do
        table.insert(set.weapons, weapon:GetClass())

        local primary = weapon:GetPrimaryAmmoType()
        local secondary = weapon:GetSecondaryAmmoType()

        if primary ~= -1 then
            set.ammo[primary] = player:GetAmmoCount(primary)
        end

        if secondary ~= -1 then
            set.ammo[secondary] = player:GetAmmoCount(secondary)
        end
    end

    return set
end

SWI.defaultSet = SWI.Set.init("default_set")
SWI.defaultSet.weapons = {
    "weapon_crowbar",
    "weapon_physcannon",
    "weapon_physgun",
    "weapon_pistol",
    "weapon_357",
    "weapon_smg1",
    "weapon_ar2",
    "weapon_shotgun",
    "weapon_crossbow",
    "weapon_frag",
    "weapon_rpg",
    "gmod_camera",
    "gmod_tool"
}
SWI.defaultSet.ammo = {
    [1]	= 130,
    [2]	= 6,
    [3]	= 256,
    [4]	= 256,
    [5]	= 32,
    [6]	= 36,
    [7]	= 64,
    [8] = 3,
    [10] = 6
}