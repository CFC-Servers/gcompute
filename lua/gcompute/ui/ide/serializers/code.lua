local self, info = GCompute.IDE.SerializerRegistry:CreateType ("Code")
info:AddExtension ("txt")
info:AddExtension ("lua")
info:SetCanDeserialize (true)
info:SetCanSerialize (true)

function self:ctor (document)
end

function self:Serialize (outBuffer, callback, resource)
	callback = callback or GCompute.NullCallback
	outBuffer:Bytes (self:GetDocument ():GetText ())
	callback (true)
end

function self:Deserialize (inBuffer, callback, resource)
	callback = callback or GCompute.NullCallback
	self:GetDocument ():SetText (inBuffer:Bytes (inBuffer:GetBytesRemaining ()))
	callback (true)
end
