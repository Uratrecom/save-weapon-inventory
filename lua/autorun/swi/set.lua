SWI.SetClass = {}
SWI.SetClass.__index = SWI.SetClass

function SWI.Set(name, weapons, ammo) 
    local self = setmetatable({}, SWI.SetClass)

    self.name = name
    self.weapons = weapons or {}
    self.ammo = ammo or {}
    self.selectedWeapon = nil

    return self
end

function SWI.SetClass:copyFromPlayer(player)
    self:copyFrom(SWI.createSet(player))
end

function SWI.SetClass:giveAmmo(player, cleanupAmmo)
    if cleanupAmmo then
        player:StripAmmo()
    end

    for ammoType, ammoAmount in pairs(self.ammo) do
        player:GiveAmmo(ammoAmount, ammoType, true)
    end
end

function SWI.SetClass:giveWeapons(player, cleanupWeapons, noBaseAmmo)
    if not noBaseAmmo then
        noBaseAmmo = false
    end

    if cleanupWeapons then 
        player:StripWeapons() 
    end

    for _, weapon in pairs(self.weapons) do
        player:Give(weapon, noBaseAmmo)
    end
end

function SWI.SetClass:give(player, selectWeapon, cleanupAmmo, cleanupWeapons, noBaseAmmo)
    self:giveWeapons(player, cleanupWeapons, noBaseAmmo)
    self:giveAmmo(player, cleanupAmmo)

    if selectWeapon and self.selectedWeapon ~= nil then
        player:SelectWeapon(self.selectedWeapon)
    end
end

function SWI.SetClass:copyFrom(set) 
    table.CopyFromTo(set.weapons, self.weapons)
    table.CopyFromTo(set.ammo, self.ammo)
end