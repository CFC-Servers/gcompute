local self = {}
GCompute.PlaceholderType = GCompute.MakeConstructor (self, GCompute.Type)

function self:ctor ()
end

function self:GetFullName ()
	return "[PlaceholderType]"
end

function self:ToString ()
	return "[PlaceholderType]"
end