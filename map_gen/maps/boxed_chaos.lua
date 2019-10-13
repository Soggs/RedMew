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

local ntiles = #tiles

local function map(x, y, world)
    local bx = math.floor(world.x / square_size)
    local by = math.floor(world.y / square_size)
    
    local r_seed = bit32.band(bx * 374761393 + by * 668265263 + seed, 4294967295)
    random.re_seed(r_seed)
    
    return tiles[random(1, ntiles) )](x, y, world)
end

m = b.single_grid_pattern(map, square_size, square_size)
m = b.translate(m, square_size/2, square_size/2)
m = b.if_else(m, b.full_shape)


Global.register_init(
    {},
    function(tbl)
        tbl.seed = seed or RS.get_surface().map_gen_settings.seed
        tbl.random = game.create_random_generator()
    end,
    function(tbl)
        seed = tbl.seed
        random = tbl.random
    end
)

return m
