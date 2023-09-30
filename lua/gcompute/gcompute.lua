if GCompute then return end
GCompute = GCompute or {}

if not _G.GLib then
	include ("glib/glib.lua")
	GLib.Debug ("Loading GLib in GCompute")
end

local t = GLib.LoadTimer ("GCompute")

if not _G.Gooey then
	include ("gooey/gooey.lua")
	t.step ("Gooey")
end

if not _G.VFS then
	include ("vfs/vfs.lua")
	t.step ("VFS")
end

GLib.Initialize ("GCompute", GCompute)
GLib.AddCSLuaPackSystem ("GCompute")
GLib.AddCSLuaPackFile ("autorun/gcompute.lua")
GLib.AddCSLuaPackFolderRecursive ("gcompute")

GCompute.Reflection = GCompute.Reflection or {}

GCompute.GlobalNamespace = nil

t.step ("Init")

function GCompute.ClearDebug ()
end

function GCompute.PrintDebug (message)
	if message == nil then return end
	Msg (message .. "\n")
end

function GCompute.ToDeferredTypeResolution (typeName, localDefinition)
	if typeName == nil then
		return nil
	elseif type (typeName) == "string" or typeName:IsASTNode () then
		return GCompute.DeferredObjectResolution (typeName, GCompute.ResolutionObjectType.Type, localDefinition)
	elseif typeName:IsDeferredObjectResolution () then
		typeName:SetLocalNamespace (typeName:GetLocalNamespace () or localDefinition)
		return typeName
	elseif typeName:UnwrapAlias ():IsType () then
		return typeName:ToType ()
	end
	GCompute.Error ("GCompute.ToDeferredTypeResolution : Given argument was not a string, DeferredObjectResolution or Type (" .. typeName:ToString () .. ")")
end

function GCompute.ToFunction (f)
	if type (f) == "string" then
		return function (self, ...)
			return self [f] (self, ...)
		end
	end
	return f
end

local includeBatches = {
	function()
		-- Meta
		include ("gcompute/callbackchain.lua")
		include ("gcompute/compilermessagetype.lua")
		include ("gcompute/icompilermessagesink.lua")
		include ("gcompute/nullcompilermessagesink.lua")
		include ("gcompute/ieditorhelper.lua")
		include ("gcompute/iobject.lua")
		include ("gcompute/isavable.lua")

		include ("gcompute/substitutionmap.lua")
	end,

	function()
		-- Text
		GCompute.Text = {}
		include ("gcompute/text/itextsink.lua")
		include ("gcompute/text/itextsource.lua")
		include ("gcompute/text/icoloredtextsink.lua")
		include ("gcompute/text/icoloredtextsource.lua")
		include ("gcompute/text/nullcoloredtextsink.lua")

		include ("gcompute/text/consoletextsink.lua")
		include ("gcompute/text/coloredtextbuffer.lua")
		include ("gcompute/text/pipe.lua")
		include ("gcompute/text/nullpipe.lua")
	end,

	function()
		-- Syntax trees
		include ("gcompute/astnode.lua")
		include ("gcompute/ast.lua")
	end,

	function()
		-- Visitors
		include ("gcompute/visitor.lua")
		include ("gcompute/astvisitor.lua")
		include ("gcompute/namespacevisitor.lua")
	end,

	function()
		-- Compilation
		include ("gcompute/compiler/compilationgroup.lua")
		include ("gcompute/compiler/compilationunit.lua")

		-- Regex
		-- include ("gcompute/regex/regex.lua")
	end,

	function()
		-- Lexing
		GCompute.Lexing = {}
		include ("gcompute/lexer/keywordtype.lua")
		include ("gcompute/lexer/tokentype.lua")
		include ("gcompute/lexer/symbolmatchtype.lua")

		include ("gcompute/lexer/ikeywordclassifier.lua")
		include ("gcompute/lexer/keywordclassifier.lua")
		include ("gcompute/lexer/token.lua")
		include ("gcompute/lexer/itokenizer.lua")
		include ("gcompute/lexer/tokenizer.lua")

		-- TODO: Fix the lexer mess
		include ("gcompute/lexer/ilexer.lua")
		include ("gcompute/lexer/lexer.lua")
		include ("gcompute/lexer/itokenstream.lua")          -- This is stupid, it should be an optional buffer.
		include ("gcompute/lexer/tokenstream.lua")           -- This is stupid by extension.
		include ("gcompute/lexer/linkedlisttokenstream.lua") -- This too.
		include ("gcompute/lexer/lexertokenstream.lua")      -- And this.
	end,

	function()
		-- Compiler output
		include ("gcompute/compiler/compilermessage.lua")
		include ("gcompute/compiler/compilermessagecollection.lua")
		include ("gcompute/compiler/compilermessagetype.lua")

		-- Compiler passes
		include ("gcompute/compiler/compilerpasstype.lua")

		include ("gcompute/compiler/preprocessor.lua")
		include ("gcompute/compiler/parserjobgenerator.lua")
		include ("gcompute/compiler/parser.lua")
		include ("gcompute/compiler/blockstatementinserter.lua")
		include ("gcompute/compiler/namespacebuilder.lua")
		include ("gcompute/compiler/uniquenameassigner.lua")
		include ("gcompute/compiler/aliasresolver.lua")
		include ("gcompute/compiler/simplenameresolver.lua")
		include ("gcompute/compiler/typeinferer.lua")
		include ("gcompute/compiler/typeinferer_typeassigner.lua")
		include ("gcompute/compiler/localscopemerger.lua")

		include ("gcompute/namespaceset.lua")
		include ("gcompute/uniquenamemap.lua")

		include ("gcompute/assignmenttype.lua")
		include ("gcompute/assignmentplan.lua")
		include ("gcompute/variablereadtype.lua")
		include ("gcompute/variablereadplan.lua")
	end,

	function()
		-- Source files
		include ("gcompute/sourcefilecache.lua")
		include ("gcompute/sourcefile.lua")
	end,

	function()
		-- Type system
		include ("gcompute/type/typesystem.lua")

		include ("gcompute/type/typeconversionmethod.lua")
		include ("gcompute/type/typeparser.lua")
		include ("gcompute/type/type.lua")

		include ("gcompute/type/errortype.lua")

		include ("gcompute/type/aliasedtype.lua")
		include ("gcompute/type/classtype.lua")
		include ("gcompute/type/functiontype.lua")
		include ("gcompute/type/typeparametertype.lua")
		include ("gcompute/type/referencetype.lua")
	end,

	function()
		-- Type inference
		include ("gcompute/type/inferredtype.lua")

		-- Object resolution
		include ("gcompute/objectresolution/resolutionobjecttype.lua")
		include ("gcompute/objectresolution/resolutionresulttype.lua")
		include ("gcompute/objectresolution/resolutionresult.lua")
		include ("gcompute/objectresolution/resolutionresults.lua")
		include ("gcompute/objectresolution/deferredobjectresolution.lua")
		include ("gcompute/objectresolution/objectresolver.lua")
	end,

	function()
		-- Compile time and reflection
		include ("gcompute/metadata/namespacetype.lua")
		include ("gcompute/metadata/membervisibility.lua")

		include ("gcompute/metadata/module.lua")

		include ("gcompute/metadata/usingdirective.lua")
		include ("gcompute/metadata/usingcollection.lua")

		include ("gcompute/metadata/objectdefinition.lua")
		include ("gcompute/metadata/namespace.lua")
		include ("gcompute/metadata/classnamespace.lua")

		include ("gcompute/metadata/namespacedefinition.lua")
		include ("gcompute/metadata/classdefinition.lua")

		include ("gcompute/metadata/aliasdefinition.lua")
		include ("gcompute/metadata/eventdefinition.lua")
		include ("gcompute/metadata/propertydefinition.lua")
		include ("gcompute/metadata/typeparameterdefinition.lua")
		include ("gcompute/metadata/variabledefinition.lua")

		include ("gcompute/metadata/methoddefinition.lua")
		include ("gcompute/metadata/constructordefinition.lua")
		include ("gcompute/metadata/explicitcastdefinition.lua")
		include ("gcompute/metadata/implicitcastdefinition.lua")
		include ("gcompute/metadata/propertyaccessordefinition.lua")

		include ("gcompute/metadata/overloadedclassdefinition.lua")
		include ("gcompute/metadata/overloadedmethoddefinition.lua")

		include ("gcompute/metadata/typecurriedclassdefinition.lua")
		include ("gcompute/metadata/typecurriedmethoddefinition.lua")
	end,

	function()
		-- Mirror
		include ("gcompute/metadata/mirror/mirrornamespace.lua")

		include ("gcompute/metadata/mirror/mirrornamespacedefinition.lua")
		include ("gcompute/metadata/mirror/mirrorclassdefinition.lua")
		include ("gcompute/metadata/mirror/mirroroverloadedclassdefinition.lua")
		include ("gcompute/metadata/mirror/mirroroverloadedmethoddefinition.lua")

		-- Parameters and arguments
		include ("gcompute/metadata/parameterlist.lua")
		GCompute.EmptyParameterList = GCompute.ParameterList ()

		include ("gcompute/metadata/typeparameterlist.lua")
		include ("gcompute/metadata/typeargumentlist.lua")
		include ("gcompute/metadata/typeargumentlistlist.lua")
		include ("gcompute/metadata/emptytypeparameterlist.lua")
		include ("gcompute/metadata/emptytypeargumentlist.lua")

		include ("gcompute/metadata/mergedlocalscope.lua")
	end,

	function()
		-- Lua
		GCompute.Lua = {}
		include ("gcompute/metadata/lua/table.lua")
		include ("gcompute/metadata/lua/class.lua")
		include ("gcompute/metadata/lua/function.lua")
		include ("gcompute/metadata/lua/constructor.lua")
		include ("gcompute/metadata/lua/variable.lua")

		include ("gcompute/metadata/lua/functionparameterlist.lua")
		include ("gcompute/metadata/lua/tablenamespace.lua")
		include ("gcompute/metadata/lua/classnamespace.lua")
	end,

	function()
		-- Other
		GCompute.Other = {}

		-- Runtime function calls
		include ("gcompute/functioncalls/functionresolutiontype.lua")
		include ("gcompute/functioncalls/overloadedfunctionresolver.lua")
		include ("gcompute/functioncalls/functioncall.lua")
		include ("gcompute/functioncalls/memberfunctioncall.lua")

		-- Runtime
		include ("gcompute/compilercontext.lua")
		include ("gcompute/executioncontext.lua")

		-- Languages
		include ("gcompute/languagedetector.lua")
		include ("gcompute/languages.lua")
		include ("gcompute/language.lua")
		include ("gcompute/languages/glua.lua")

		-- Runtime
		include ("gcompute/astrunner.lua")

		include ("gcompute/runtime/runtimeobject.lua")

		include ("gcompute/runtime/processlist.lua")
		include ("gcompute/runtime/process.lua")
		include ("gcompute/runtime/thread.lua")

		include ("gcompute/runtime/localprocesslist.lua")
	end,

	function()
		-- Native code emission
		include ("gcompute/nativegen/icodeemitter.lua")
		include ("gcompute/nativegen/luaemitter.lua")

		-- Syntax coloring
		GCompute.SyntaxColoring = {}
		include ("gcompute/colorscheme.lua")
		include ("gcompute/syntaxcoloring/syntaxcoloringscheme.lua")
		include ("gcompute/syntaxcoloring/placeholdersyntaxcoloringscheme.lua")
	end,

	function()
		-- GLua
		GCompute.GLua = {}
		include ("gcompute/glua/luacompiler.lua")

		-- GLua printing
		GCompute.GLua.Printing = {}
		include ("gcompute/glua/printing/alignmentcontroller.lua")
		include ("gcompute/glua/printing/nullalignmentcontroller.lua")
		include ("gcompute/glua/printing/printingoptions.lua")
		include ("gcompute/glua/printing/printer.lua")
		include ("gcompute/glua/printing/typeprinter.lua")
		include ("gcompute/glua/printing/referencetypeprinter.lua")
		include ("gcompute/glua/printing/defaulttypeprinter.lua")

		include ("gcompute/glua/printing/nilprinter.lua")
		include ("gcompute/glua/printing/booleanprinter.lua")
		include ("gcompute/glua/printing/numberprinter.lua")
		include ("gcompute/glua/printing/stringprinter.lua")
		include ("gcompute/glua/printing/functionprinter.lua")
		include ("gcompute/glua/printing/tableprinter.lua")

		include ("gcompute/glua/printing/colorprinter.lua")
		include ("gcompute/glua/printing/angleprinter.lua")
		include ("gcompute/glua/printing/vectorprinter.lua")

		include ("gcompute/glua/printing/entityprinter.lua")
		include ("gcompute/glua/printing/playerprinter.lua")
		include ("gcompute/glua/printing/panelprinter.lua")

		include ("gcompute/glua/printing/soundpatchprinter.lua")

		include ("gcompute/glua/printing/meshprinter.lua")
		include ("gcompute/glua/printing/textureprinter.lua")

		include ("gcompute/glua/printing/defaultprinter.lua")
	end,

	function()
		-- Services
		GCompute.Services = {}
		include ("gcompute/returncode.lua")
		include ("gcompute/services/services.lua")
		include ("gcompute/services/remoteserviceregistry.lua")
		include ("gcompute/services/remoteservicemanagermanager.lua")
		include ("gcompute/services/remoteservicemanager.lua")
	end,

	function()
		-- Execution
		GCompute.Execution = {}
		include ("gcompute/execution/iexecutionservice.lua")
		include ("gcompute/execution/iexecutioncontext.lua")
		include ("gcompute/execution/iexecutioninstance.lua")
		include ("gcompute/execution/executioncontext.lua")
		include ("gcompute/execution/executioncontextoptions.lua")
		include ("gcompute/execution/executioninstanceoptions.lua")
		include ("gcompute/execution/executioninstancestate.lua")
		include ("gcompute/execution/aggregateexecutionservice.lua")
		include ("gcompute/execution/aggregateexecutioncontext.lua")
		include ("gcompute/execution/aggregateexecutioninstance.lua")
		include ("gcompute/execution/local/localexecutionservice.lua")
		include ("gcompute/execution/local/localexecutioncontext.lua")
		include ("gcompute/execution/local/localexecutioninstance.lua")
		include ("gcompute/execution/local/consoleexecutioncontext.lua")
		include ("gcompute/execution/local/consoleexecutioninstance.lua")
		include ("gcompute/execution/local/gluaexecutioncontext.lua")
		include ("gcompute/execution/local/gluaexecutioninstance.lua")
		include ("gcompute/execution/remote/remoteexecutionservice.lua")
		include ("gcompute/execution/remote/gcomputeremoteexecutionservice.lua")
		include ("gcompute/execution/remote/remoteexecutionservicehost.lua")
		include ("gcompute/execution/remote/remoteexecutionserviceclient.lua")
		include ("gcompute/execution/remote/remoteexecutioncontexthost.lua")
		include ("gcompute/execution/remote/remoteexecutioncontextclient.lua")
		include ("gcompute/execution/remote/remoteexecutioninstancehost.lua")
		include ("gcompute/execution/remote/remoteexecutioninstanceclient.lua")
		include ("gcompute/execution/luadev/luadevexecutionservice.lua")
		include ("gcompute/execution/luadev/luadevexecutioncontext.lua")
		include ("gcompute/execution/luadev/luadevexecutioninstance.lua")

		include ("gcompute/execution/iexecutionfilterable.lua")
		include ("gcompute/execution/executionserviceexecutionfilterable.lua")

		include ("gcompute/execution/executionservice.lua")
		include ("gcompute/execution/executionfilterable.lua")

		include ("gcompute/execution/executionlogger.lua")
	end,

	function()
		GCompute.ExecutionLogger = GCompute.Execution.ExecutionLogger ()
		GCompute.ExecutionLogger:AddExecutionFilterable (GCompute.Execution.ExecutionFilterable)
		GCompute.ExecutionLogger:AddOutputTextSink (GCompute.Text.ConsoleTextSink)

		GCompute.AddReloadCommand ("gcompute/gcompute.lua", "gcompute", "GCompute")

		GCompute.PlayerMonitor = GCompute.PlayerMonitor ("GCompute")
	end
}

-- Libraries
local function loadLibs()
	GCompute.System = GCompute.Module ()
	:SetName ("System")
	:SetFullName ("System")
	:SetOwnerId (GLib.GetSystemId ())

	GCompute.System:SetRootNamespace (GCompute.NamespaceDefinition ())

	GCompute.GlobalNamespace = GCompute.System:GetRootNamespace ()
	GCompute.GlobalNamespace:SetGlobalNamespace (GCompute.GlobalNamespace)
	GCompute.GlobalNamespace:SetNamespaceType (GCompute.NamespaceType.Global)

	include ("gcompute/corelibrary.lua")
	GCompute.IncludeDirectoryAsync ("gcompute/libraries", true)
	GCompute.GlobalNamespace:ResolveNames (
	GCompute.ObjectResolver (
	GCompute.NamespaceSet ()
	:AddNamespace (GCompute.GlobalNamespace)
	)
	)
end


local function after()
	if SERVER then loadLibs() end

	-- Only load the UI on gcompute-using clients
	if CLIENT and GetConVar("is_gcompute_user"):GetBool() then
		loadLibs() 
		GCompute.IncludeDirectoryAsync ("gcompute/ui")
	end
end

t.step ("Step 1")

for _, batch in ipairs(includeBatches) do
	GLib.CallDelayed( batch )
end

t.step ("Step 2")

GLib.CallDelayed(after)

t.step ("Step 3")
