SWI.Sets = {}
SWI.Sets.__index = SWI.Sets

function SWI.Sets.init(fileName)
    local self = setmetatable({}, SWI.Sets)

    self.sets = {}
    self.file = fileName or "swi_sets.json"
    self.ignoredSets = {
        "spawn"
    }

    return self
end

function SWI.Sets:add(set) 
    self.sets[set.name] = set
end

function SWI.Sets:remove(set)
    if type(set) == "table" then
        self.sets[set.name] = nil
    elseif type(set) == "string" then
        self.sets[set] = nil
    end
end

function SWI.Sets:find(setName)
    if self.sets[setName] ~= nil then
        return self.sets[setName]
    end

    for _, set in pairs(self.sets) do
        if set.name == setName then 
            return set 
        end
    end
end

function SWI.Sets:save(fileName) 
    if not fileName then
        fileName = self.file
    end

    local jsonTable = {}

    for _, set in pairs(self.sets) do
        if not table.HasValue(self.ignoredSets, set.name) then
            jsonTable[set.name] = {
                weapons = set.weapons, 
                ammo = set.ammo
            }
        end
    end

    file.Write(fileName, util.TableToJSON(jsonTable, true))
end

function SWI.Sets:load(fileName) 
    if not fileName then
        fileName = self.file
    end

    local jsonTable = util.JSONToTable(file.Read(fileName, "DATA"))

    self.sets = {}

    for setName, setContent in pairs(jsonTable) do
        local set = SWI.Set.init(setName, setContent.weapons, setContent.ammo)
        self:add(set)
    end
end