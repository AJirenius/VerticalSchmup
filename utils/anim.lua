local M = {}

function M.play_animation(self, anim)
	if anim == self.current_anim then return end
	msg.post("#sprite", "play_animation", { id = hash(anim) })
	self.current_anim = anim
end

return M

