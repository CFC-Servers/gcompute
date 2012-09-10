local self = {}
GCompute.AliasDefinition = GCompute.MakeConstructor (self, GCompute.ObjectDefinition)

--- @param name The name of this alias
-- @param objectName The object this alias points to, as a string
function self:ctor (name, objectName)
	self.ObjectName = objectName
	self.Object = nil
	self.Metadata = nil
	
	if type (self.ObjectName) == "string" then
		self.Object = GCompute.DeferredNameResolution (self.ObjectName)
	elseif self.ObjectName:IsDeferredNameResolution () then
		self.Object = self.ObjectName
		self.ObjectName = self.Object:GetFullName ()
	else
		GCompute.Error ("AliasDefinition constructed with unknown object.")
	end
end

function self:GetMetadata ()
	return self.Metadata
end

function self:GetObject ()
	return self.Object
end

function self:GetType ()
	if self:GetObject () then
		return self:GetObject ():GetType ()
	end
	GCompute.Error ("AliasDefinition:GetType : This AliasDefinition is unresolved (" .. self:GetFullName () .. ", " .. self:ToString () .. ").")
end

--- Gets whether this object is an alias for another object
-- @return A boolean indicating whether this object is an alias for another object
function self:IsAlias ()
	return true
end

function self:IsResolved ()
	return not self.Object:IsDeferredNameResolution ()
end

function self:ResolveTypes (globalNamespace)
	if self:IsResolved () then return end
	
	local deferredNameResolution = self.Object
	if deferredNameResolution:IsResolved () then return end
	
	deferredNameResolution:Resolve ()
	if deferredNameResolution:IsResolved () then
		local resolvedObject = deferredNameResolution:GetObject ()
		if resolvedObject:IsObjectDefinition () then
			resolvedObject = resolvedObject:UnwrapAlias ()
			
			self.Object = resolvedObject
			self.Metadata = resolvedObject:GetMetadata ()
		else
			self.Object = resolvedObject
			self.Metadata = nil
		end
	end
end

function self:ToString ()
	local aliasDefinition = "[Alias] "
	aliasDefinition = aliasDefinition .. (self:GetName () or "[Unnamed]")
	aliasDefinition = aliasDefinition .. " = " .. self.ObjectName
	return aliasDefinition
end

local unwrapAlias = {}
--- Returns the target of this AliasDefinition
-- @return The target of this AliasDefinition
function self:UnwrapAlias ()
	if unwrapAlias [self] then
		GCompute.Error ("AliasDefinition:UnwrapAlias : Cycle in alias " .. self:ToString () .. " detected.")
		return nil
	end

	self:ResolveTypes ()
	local ret = self:GetObject ()
	if ret and ret:IsAlias () then
		unwrapAlias [self] = true
		ret = ret:UnwrapAlias ()
		unwrapAlias [self] = nil
	end
	return ret
end