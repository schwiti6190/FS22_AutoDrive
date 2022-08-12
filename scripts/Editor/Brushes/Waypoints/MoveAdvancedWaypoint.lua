
--- Moves a waypoint relative to the mouse position.
---@class ADBrushMoveAdvanced : ADBrush
ADBrushMoveAdvanced = {

}
local ADBrushMoveAdvanced_mt = Class(ADBrushMoveAdvanced,ADBrush)
function ADBrushMoveAdvanced.new(customMt,cursor)
	local self =  ADBrush.new(customMt or ADBrushMoveAdvanced_mt, cursor)
	self.supportsPrimaryButton = true
	self.supportsPrimaryDragging = true
	self.supportsSecondaryButton = true
	self.supportsSecondaryDragging = true
	self.supportsTertiaryButton = true
	self.selectedNodes = {}
	self.lastPosition = {}
	return self
end

function ADBrushMoveAdvanced:onButtonPrimary(isDown, isDrag, isUp)
	local x, y, z = self.cursor:getPosition() 
	if isDown then 
		self.lastPosition = {x, y, z}
	end
	if isDrag then
		if next(self.lastPosition) 	~= nil then
			local dx, dy, dz = unpack(self.lastPosition)
			local nx, ny, nz = x - dx, y - dy, z - dz 
			for nodeId, _ in pairs(self.selectedNodes) do 
				self.graphWrapper:translateTo(nodeId, nx, ny, nz)
			end
		end
		self.lastPosition = {x, y, z}
	end 
end

function ADBrushMoveAdvanced:onButtonSecondary(isDown, isDrag, isUp)
	if isDown or isDrag then 
		local selectedNodeId = self:getHoveredNodeId()
		if selectedNodeId then
			self.graphWrapper:setSelected(selectedNodeId)
			self.selectedNodes[selectedNodeId] = true
		end
	end
end

function ADBrushMoveAdvanced:onButtonTertiary()
	self.selectedNodes = {}
	self.lastPosition = {}
	self.graphWrapper:resetSelected()
end

function ADBrushMoveAdvanced:activate()
	self.selectedNodes = {}
	self.lastPosition = {}
	self.graphWrapper:resetSelected()
end

function ADBrushMoveAdvanced:deactivate()
	self.selectedNodes = {}
	self.lastPosition = {}
	self.graphWrapper:resetSelected()
end

function ADBrushMoveAdvanced:getButtonPrimaryText()
	return self:getTranslation(self.primaryButtonText)
end

function ADBrushMoveAdvanced:getButtonSecondaryText()
	return self:getTranslation(self.secondaryButtonText)
end

function ADBrushMoveAdvanced:getButtonTertiaryText()
	return self:getTranslation(self.tertiaryButtonText)
end
