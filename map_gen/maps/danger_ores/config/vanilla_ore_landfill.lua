local b = require 'map_gen.shared.builders'
local value = b.euclidean_value

return {
    ['copper-ore'] = {
        ['tiles'] = {
            [1] = 'landfill'
        },
        ['start'] = value(50, 0),
        ['weight'] = 1,
        ['ratios'] = {
            {resource = b.resource(b.full_shape, 'iron-ore', value(0, 0.75)), weight = 15},
            {resource = b.resource(b.full_shape, 'copper-ore', value(0, 0.75)), weight = 70},
            {resource = b.resource(b.full_shape, 'stone', value(0, 0.75)), weight = 7},
            {resource = b.resource(b.full_shape, 'coal', value(0, 0.75)), weight = 8}
        }
    },
    ['coal'] = {
        ['tiles'] = {
            [1] = 'landfill'
        },
        ['start'] = value(50, 0),
        ['weight'] = 1,
        ['ratios'] = {
            {resource = b.resource(b.full_shape, 'iron-ore', value(0, 0.75)), weight = 25},
            {resource = b.resource(b.full_shape, 'copper-ore', value(0, 0.75)), weight = 10},
            {resource = b.resource(b.full_shape, 'stone', value(0, 0.75)), weight = 7},
            {resource = b.resource(b.full_shape, 'coal', value(0, 0.75)), weight = 58}
        }
    },
    ['iron-ore'] = {
        ['tiles'] = {
            [1] = 'landfill'
        },
        ['start'] = value(50, 0),
        ['weight'] = 1,
        ['ratios'] = {
            {resource = b.resource(b.full_shape, 'iron-ore', value(0, 0.75)), weight = 70},
            {resource = b.resource(b.full_shape, 'copper-ore', value(0, 0.75)), weight = 15},
            {resource = b.resource(b.full_shape, 'stone', value(0, 0.75)), weight = 7},
            {resource = b.resource(b.full_shape, 'coal', value(0, 0.75)), weight = 8}
        }
    }
}