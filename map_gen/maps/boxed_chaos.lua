local b = require 'map_gen.shared.builders'
local RS = require 'map_gen.shared.redmew_surface'
local ceil = math.ceil
local random = math.random
local Event = require 'utils.event'
local Global = require 'utils.global'

-- Disable Landfill
Event.add(
    defines.events.on_player_created,
    function()
        local player_force = game.forces.player
        player_force.technologies["landfill"].enabled = false
    end
)

local seed = nil --271618794 -- Set to number to force seed.
local random
local real_map


function make_map()
    -- Even numbers work best
    local square_size = 64
    local connector_width = 4
    local divider_width = 4
    local divider_tile = "water-shallow"
    local tiles = {}
    
    -- No connection
    local Zero = b.any  
        {
            b.rectangle(square_size, divider_width),
            b.rectangle(divider_width,square_size)
        }
    Zero = b.change_tile(Zero, true, divider_tile)
    table.insert(tiles, Zero)
    
    -- Connectors
    local N_connector = b.translate(b.rectangle(divider_width, connector_width), 0, -divider_width)
    local E_connector = b.translate(b.rectangle(connector_width, divider_width), -divider_width, 0)
    local S_connector = b.translate(b.rectangle(divider_width, connector_width), 0, divider_width)
    local W_connector = b.translate(b.rectangle(connector_width, divider_width), divider_width, 0)
    
    -- Singles
    local N = b.if_else(N_connector, Zero)
    table.insert(tiles, N)
    local E = b.if_else(E_connector, Zero)
    table.insert(tiles, E)
    local S = b.if_else(S_connector, Zero)
    table.insert(tiles, S)
    local W = b.if_else(W_connector, Zero)
    table.insert(tiles, W)
    
    -- Corners
    local NE = b.if_else(b.any {N_connector, E_connector}, Zero)
    table.insert(tiles, NE)
    local SE = b.if_else(b.any {S_connector, E_connector}, Zero)
    table.insert(tiles, SE)
    local SW = b.if_else(b.any {S_connector, W_connector}, Zero)
    table.insert(tiles, SW)
    local NW = b.if_else(b.any {N_connector, W_connector}, Zero)
    table.insert(tiles, NW)
    
    -- Parallels
    local NS = b.if_else(b.any {S_connector, N_connector}, Zero)
    table.insert(tiles, NS)
    local WE = b.if_else(b.any {E_connector, W_connector}, Zero)
    table.insert(tiles, WE)
    
    -- U-Connections
    local NES = b.if_else(b.any {N_connector, E_connector, S_connector}, Zero)
    table.insert(tiles, NES)
    local ESW = b.if_else(b.any {S_connector, E_connector, W_connector}, Zero)
    table.insert(tiles, ESW)
    local SWN = b.if_else(b.any {S_connector, W_connector, N_connector}, Zero)
    table.insert(tiles, SWN)
    local WNE = b.if_else(b.any {N_connector, W_connector, E_connector}, Zero)
    table.insert(tiles, WNE)
    
    -- 4-Way
    local NESW = b.if_else(b.any {N_connector, E_connector, S_connector, W_connector}, Zero)
    table.insert(tiles, NESW)
    
    local function map(x, y, world)
        local bx = math.floor(x / square_size)
        local by = math.floor(y / square_size)
        
        local r_seed = bit32.band(bx * 374761393 + by * 668265263 + seed, 4294967295)
        random.re_seed(r_seed)
        
        return tiles[math.ceil(random() * #tiles)](bx, by, world)
    end
    
    m = b.translate(map, square_size/2, square_size/2)
    m = b.if_else(m, b.full_shape)
    return m 
end

Global.register_init(
    {},
    function(tbl)
        tbl.seed = seed or RS.get_surface().map_gen_settings.seed
        tbl.random = game.create_random_generator()
    end,
    function(tbl)
        seed = tbl.seed
        random = tbl.random

        real_map = make_map()
    end
)

return real_map

--[[local seed = nil --271618794 -- Set to number to force seed.
local random
local real_map

-- Even numbers work best
local square_size = 64
local connector_width = 4
local divider_width = 4

local Zero = b.any
    {
        b.rectangle(square_size, divider_width),
        b.rectangle(divider_width,square_size)
    }
Zero = b.change_tile(Zero, true, 'water-shallow')

local N_connector = b.translate(b.rectangle(divider_width, connector_width), 0, -divider_width)
local E_connector = b.translate(b.rectangle(connector_width, divider_width), -divider_width, 0)
local S_connector = b.translate(b.rectangle(divider_width, connector_width), 0, divider_width)
local W_connector = b.translate(b.rectangle(connector_width, divider_width), divider_width, 0)

local N = b.if_else(N_connector, Zero)
local E = b.if_else(E_connector, Zero)
local S = b.if_else(S_connector, Zero)
local W = b.if_else(W_connector, Zero)

local tiles = {N, E, S, W}

local function choose_tile(x,y,world,tile)
    random.re_seed(r_seed)
    return tiles[ceil(#tiles * random())](x,y,world,tile)
end

local grid = b.single_grid_pattern(choose_tile, square_size, square_size)
local map = b.if_else(grid, b.full_shape)


return map]]