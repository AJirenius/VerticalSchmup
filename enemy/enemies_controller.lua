local config = require "main.config"


local M = {}

local enemies = {}


function M.add_enemy(data)
	print("adding enemy")
	local new_e = {}
	new_e.x = data.x
	new_e.y = config.MAP_PX_HEIGHT - data.y
	new_e.offset_y = data.properties.offset_y
	new_e.type = data.properties.enemy_type
	new_e.positions = {}
	for i,v in ipairs(data.polyline) do
		table.insert(new_e.positions,{ x = v.x + new_e.x, y = -v.y + new_e.y })
	end
	table.insert(enemies,new_e)
end

function M.check_for_enemy_start(cam_y)
	for i = #enemies,1,-1 do
		local enemy = enemies[i]
		if enemy.y-enemy.offset_y < cam_y then
			local en = table.remove(enemies,i)
			local first_entry = en.positions[1]
			local pos = vmath.vector3(first_entry.x, first_entry.y,0)
			local id = factory.create("/factories#"..en.type,pos,nil,{},1)
			msg.post(id,"start_route", { positions = en.positions } )
		end
	end
end


return M