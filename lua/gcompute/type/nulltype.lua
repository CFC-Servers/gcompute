local self = {}
GCompute.NullType = GCompute.MakeConstructor (self, GCompute.Type)

function self:ctor ()
end

function self:CanExplicitCastTo (destinationType)
	return false
end

function self:CanImplicitCastTo (destinationType)
	return false
end

function self:Equals (otherType)
	return false
end

function self:GetFullName ()
	return "[Error Type]"
end

function self:GetTypeDefinition ()
	return nil
end

function self:IsBaseType (supertype)
	return false
end

function self:ToString ()
	return "[Error Type]"
end