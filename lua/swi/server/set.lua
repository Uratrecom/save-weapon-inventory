Swi.GlobalSets = {}

CreateConVar("swi_sv_save_after_exit", "0", {
    FCVAR_ARCHIVE,
    FCVAR_CLIENTDLL,
    FCVAR_NOTIFY,
    
}, "", 0, 1)

hook.Add("PlayerInitialSpawn", "init_player_sets", function(player)
    local id = player:SteamID()

    if not Swi.GlobalSets[id] then
        Swi.GlobalSets[id] = {}
    end
end)

hook.Add("PlayerDisconnect", "remove_player_sets", function(player)
    if GetConVar()

    local id = player:SteamID()

    Swi.GlobalSets[id] = nil
end)

function setMeta:giveAmmo(player, cleanupAmmo)    
    if cleanupAmmo then
        player:StripAmmo()
    end

    for ammoType, ammoAmount in pairs(self.ammo) do
        player:GiveAmmo(ammoAmount, ammoType, true)
    end
end

function setMeta:giveWeapons(player, cleanupWeapons, noBaseAmmo)
    noBaseAmmo = noBaseAmmo and true or false

    if cleanupWeapons then
        player:StripWeapons()
    end

    for _, weapon in pairs(self.weapons) do
        player:Give(weapon, noBaseAmmo)
    end
end

function setMeta:give(player, selectWeapon, cleanupAmmo, cleanupWeapons, noBaseAmmo)
    self:giveAmmo(player, cleanupAmmo)
    self:giveWeapons(player, cleanupWeapons, noBaseAmmo)

    if selectWeapon and self.selectedWeapon ~= nil then
        player:SelectWeapon(self.selectedWeapon)
    end
end

function Swi.set(name)
    return setmetatable({
        name = type(name) == "string" and name or "",
        weapons = {},
        ammo = {},
        selectedWeapon = nil
    }, setMeta)
end

local wait

function Swi.getPlayerSet(player, name, callback)

end

hook.Add("Think", "getPlayerSet", function()

end)

Swi.getPlayerSet(88, "lol", function(set) 
    
end)

tempSet = Swi.set("temp")