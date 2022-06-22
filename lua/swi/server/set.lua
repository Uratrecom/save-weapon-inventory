Swi.globalSets = {}

hook.Add("PlayerDisconnect", "swi_remove_player_sets", function(player)
    Swi.globalSets[player:SteamID()] = nil
end)

hook.Add("DoPlayerDeath", "swi_grab_set", function(player)
    Swi.globalSets[player:SteamID()] = Swi.CreateSet(player)
end)

hook.Add("PlayerSpawn", "swi_give_set", function(player)
    local set = Swi.globalSets[player:SteamID()]

    if not set or 
       player:IsBot() or 
       not GetConVar("swi_sv_save_weapons"):GetBool() or 
       player:GetInfo("swi_save_weapons") == "0" then 
        return
    end

    timer.Simple(0, function() 
        Swi.Give(
            set,
            player,
            tobool(player:GetInfo("swi_select_weapon")),
            tobool(player:GetInfo("swi_base_ammo"))
        )
    end)
end)

function Swi.CreateSet(player) 
    if not IsValid(player) then
        return
    end
    
    local set = Swi.Set()
    local activeWeapon = player:GetActiveWeapon()

    if IsValid(activeWeapon) then
        set.selectedWeapon = activeWeapon:GetClass()
    end

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

function Swi.Set(name)
    return {
        name = name or "",
        weapons = {},
        ammo = {},
        selectedWeapon = nil
    }
end

function Swi.Give(set, player, selectWeapon, noBaseAmmo)
    player:StripWeapons()

    for _, weapon in pairs(set.weapons) do
        player:Give(weapon, noBaseAmmo)
    end

    if selectWeapon and set.selectedWeapon ~= nil then
        player:SelectWeapon(set.selectedWeapon)
    end

    player:StripAmmo()
    
    for ammoType, ammoAmount in pairs(set.ammo) do
        player:GiveAmmo(ammoAmount, ammoType, true)
    end
end