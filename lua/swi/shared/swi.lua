function Swi.createSetFromPlayer(player)            
    local set = Swi.set(player:Nick() .. "'s set")

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