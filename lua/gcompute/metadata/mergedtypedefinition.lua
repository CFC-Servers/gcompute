local self = {}GCompute.MergedTypeDefinition = GCompute.MakeConstructor (self, GCompute.MergedNamespaceDefinition, GCompute.TypeDefinition)function self:ctor (name, typeParameterList)	self.SourceTypes = {}endfunction self:AddSourceType (typeDefinition)	if not typeDefinition:IsTypeDefinition () then return end		self.SourceTypes [#self.SourceTypes + 1] = typeDefinition		if not typeDefinition:IsNullable () then		self:SetNullable (false)	end	self:SetIsTop (self:IsTop () or typeDefinition:IsTop ())	self:SetNativelyAllocated (self:IsNativelyAllocated () or typeDefinition:IsNativelyAllocated ())	self:SetPrimitive (self:IsPrimitive () or typeDefinition:IsPrimitive ())	self.DefaultValueCreator = self.DefaultValueCreator or typeDefinition:GetDefaultValueCreator ()		for baseType in typeDefinition:GetBaseTypeEnumerator () do		local correspondingType = baseType:GetCorrespondingDefinition (self:GetRootNamespace ())		if not baseType:IsTop () then			self:AddBaseType ()		end	end	for constructor in typeDefinition:GetConstructorEnumerator () do		self.Constructors [#self.Constructors + 1] = constructor	end	for explicitCast in typeDefinition:GetExplicitCastEnumerator () do		self.ExplicitCasts [#self.ExplicitCasts + 1] = explicitCast	end	for implicitCast in typeDefinition:GetImplicitCastEnumerator () do		self.ImplicitCasts [#self.ImplicitCasts + 1] = implicitCast	end		self:AddSourceNamespace (typeDefinition)endfunction self:BuildFunctionTable ()	for _, sourceType in ipairs (self.SourceTypes) do		for memberName, memberDefinition, _ in sourceType:GetEnumerator () do			if memberDefinition:IsOverloadedFunctionDefinition () or memberDefinition:IsFunction () then				self:ResolveMember (memberName)			end		end	end	self.__base2.BuildFunctionTable (self)endfunction self:IsMergedTypeDefinition ()	return trueendfunction self:IsNamespace ()	return falseend