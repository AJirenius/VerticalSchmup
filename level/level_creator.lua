local def = require "level.def_level_1"
local enemies_controller = require "enemy.enemies_controller"
local config = require "main.config"
local M = {}

local function create_tilelayer(index, layer)
	for ii,vv in ipairs(layer.data) do
		local pos_x = (ii-1) % config.MAP_TILE_WIDTH + 1
		local pos_y = config.MAP_TILE_HEIGHT-(math.ceil(ii/config.MAP_TILE_WIDTH) -1)
		tilemap.set_tile("/level#tilemap", "layer"..tostring(index), pos_x, pos_y, vv, false, false)
	end
end

function M.create_level()
	
	
	config.MAP_TILE_HEIGHT = #def.layers[1].data / config.MAP_TILE_WIDTH
	config.MAP_PX_HEIGHT = config.MAP_TILE_HEIGHT * config.TILE_PX_HEIGHT
	
	for i,v in ipairs(def.layers) do
		if v.type == "tilelayer" then
			-- change tiles in tilemap
			create_tilelayer(i,v)
		elseif v.type == "objectgroup" then
			for ii,vv in ipairs(v.objects) do
				if vv.type == "static_object" then
					local pos = vmath.vector3( vv.x, config.MAP_PX_HEIGHT-vv.y, 0 )
					factory.create("/factories#"..vv.name, pos)
				elseif vv.type == "route" then
					enemies_controller.add_enemy(vv)
				end
			end
		end
	end
	
	
	
	
end


return M
