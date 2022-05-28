--[[
	Brushes that can be used for waypoint selection/manipulation.
]]
---@class ADBrush : ConstructionBrush
ADBrush = {
	imageFilename ="textures/input_record_4.dds",
	name = "base",
	radius = 0.5,
	translationPrefix = "gui_ad_editor_brush_",
	primaryButtonText = "primary_text",
	primaryAxisText = "primary_axis_text",
	secondaryButtonText = "secondary_text",
	secondaryAxisText = "secondary_axis_text",
	tertiaryButtonText = "tertiary_text",
	inputTitle = "input_title",
	yesNoTitle = "yesNo_title"
}
local ADBrush_mt = Class(ADBrush, ConstructionBrush)
function ADBrush.new(customMt, cursor)
	local self =  ConstructionBrush.new(customMt or ADBrush_mt, cursor)
	self.cursor:setShapeSize(self.radius)
	self.cursor:setShape(GuiTopDownCursor.SHAPES.CIRCLE)
	return self
end

function ADBrush:isAtPos(position, x, y, z)
	if MathUtil.getPointPointDistance(position.x, position.z, x, z) < self.radius then 
		return math.abs(position.y - y) < 3
	end
end

function ADBrush:getHoveredNodeId()
	local x, y, z = self.cursor:getPosition()
	-- try to get a waypoint in mouse range
	for _, point in pairs(AdWaypointUtils.getWayPointsInRange(self.ad,0, math.huge)) do
		if self:isAtPos(point, x, y, z) then
			return point.id
		end
	end
end

function ADBrush:setParameters(ad,camera)
	self.ad = ad
	self.camera = camera
end

function ADBrush:cancel()

end

function ADBrush:activate()

end

function ADBrush:deactivate()

end

function ADBrush:openTextInput(callback,title,args)
	g_gui:showTextInputDialog({
			disableFilter = true,
			callback = callback,
			target = self,
			defaultText = "",
			dialogPrompt = title,
			imePrompt = title,
			maxCharacters = 50,
			confirmText = g_i18n:getText("button_ok"),
			args = args
		})
end

function ADBrush:showYesNoDialog(callback,title,args)
	g_gui:showYesNoDialog({
			text = title,
			callback = callback,
			target = self,
			args = args
		})
end

function ADBrush.getName(class)
	return g_i18n:getText(ADBrush.translationPrefix .. class.name .. "_name")
end

function ADBrush:getTranslation(translation, ...)
	return string.format(g_i18n:getText(ADBrush.translationPrefix .. self.name .. "_" .. translation), ...)
end