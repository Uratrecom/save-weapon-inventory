util.AddNetworkString("swi_cleanup_all")
util.AddNetworkString("swi_cleanup_all_weapons")
util.AddNetworkString("swi_cleanup_all_ammo")
util.AddNetworkString("swi_cleanup_active_weapon")
util.AddNetworkString("swi_cleanup_active_ammo")

net.Receive("swi_cleanup_all", function(_, player)
    if not IsValid(player) then
        return
    end

    player:RemoveAllItems()
end)

net.Receive("swi_cleanup_all_weapons", function(_, player)
    if not IsValid(player) then
        return
    end

    player:StripWeapons()
end)

net.Receive("swi_cleanup_all_ammo", function(_, player)
    if not IsValid(player) then
        return
    end

    player:StripAmmo()
end)

net.Receive("swi_cleanup_active_weapon", function(_, player)
    if not IsValid(player) then
        return
    end

    local activeWeapon = player:GetActiveWeapon()

    if not IsValid(activeWeapon) then
        return
    end
    
    player:StripWeapon(activeWeapon:GetClass())
end)

net.Receive("swi_cleanup_active_ammo", function(_, player)
    if not IsValid(player) then
        return
    end

    local activeWeapon = player:GetActiveWeapon()

    if not IsValid(activeWeapon) then
        return
    end

    local primaryAmmo = activeWeapon:GetPrimaryAmmoType()
    local secondaryAmmo = activeWeapon:GetSecondaryAmmoType()

    if primaryAmmo ~= -1 then
        Player:RemoveAmmo(Player:GetAmmoCount(primaryAmmo), primaryAmmo)
    end

    if secondaryAmmo ~= -1 then
        Player:RemoveAmmo(Player:GetAmmoCount(secondaryAmmo), secondaryAmmo)
    end
end)