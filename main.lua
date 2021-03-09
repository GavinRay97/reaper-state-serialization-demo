-- Load json file from "./utils.json"
-- UNCOMMMENT FOR REAPER
-- package.path = package.path .. ";" .. string.match(({reaper.get_action_context()})[2], "(.-)([^\\/]-%.?([^%.\\/]*))$") .. "?.lua"
local json = require("utils.json")

-- Shorthand way for declaring types. Much easier, but no comments available for fields.
---@alias Preset { name: string, state: table }

--- "OOP" way of declaring table/class types. Supports comments, and inheritance/extending.
---@class PresetClass
---@field name string Name of the preset
---@field state table Table containing preset state

---@param name string Name of the preset file
---@param preset PresetClass
---@return boolean
local function save_preset_state(name, preset)
    local filepath = "./presets/" .. name .. ".json"
    local file = assert(io.open(filepath, "w+"))

    local serialized = json.encode(preset)
    assert(file:write(serialized))

    file:close()
    return true
end

---@param name string Name of the preset file to load
---@return table Preset state table
local function load_preset(name)
    local filepath = "./presets/" .. name .. ".json"
    local file = assert(io.open(filepath, "rb"))

    local raw_text = file:read("*all")
    file:close()

    return json.decode(raw_text)
end

local function test()
    local presets = {
        my_preset = {
            something = 1,
            mystring = "hello",
            list = {1, 2, 3},
            subtable = {
                goodbye = true
            }
        }
    }

    local saved_preset = save_preset_state("my_preset", presets.my_preset)
    if saved_preset then
        local loaded_preset = load_preset("my_preset")
        print("loaded preset:")
        print(loaded_preset)
    else
        print("Error saving preset")
    end
end

test()
