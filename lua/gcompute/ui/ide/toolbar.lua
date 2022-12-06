function GCompute.IDE.Toolbar (self)
	local toolbar = vgui.Create ("GToolbar", self)
	
	-- File Operations
	toolbar:AddButton ("New")
		:SetAction ("New")
	toolbar:AddButton ("Open")
		:SetAction ("Open")
	toolbar:AddButton ("Save")
		:SetAction ("Save")
	toolbar:AddButton ("Save All")
		:SetAction ("Save All")
	
	toolbar:AddSeparator ()
	
	-- Clipboard
	toolbar:AddButton ("Cut")
		:SetEnabled (false)
		:SetAction ("Cut")
	toolbar:AddButton ("Copy")
		:SetEnabled (false)
		:SetAction ("Copy")
	toolbar:AddButton ("Paste")
		:SetAction ("Paste")
	
	toolbar:AddSeparator ()
	
	-- Undo / Redo
	-- Don't register click handlers for undo / redo.
	-- They should get registered with an UndoRedoController which will
	-- register click handlers.
	toolbar:AddSplitButton ("Undo")
		:SetIcon ("icon16/arrow_undo.png")
		:AddEventListener ("DropDownClosed",
			function (_, dropDownMenu)
				dropDownMenu:Clear ()
			end
		)
		:AddEventListener ("DropDownOpening",
			function (_, dropDownMenu)
				local undoRedoStack = self:GetActiveUndoRedoStack ()
				if not undoRedoStack then return end
				local stack = undoRedoStack:GetUndoStack ()
				for i = 0, 19 do
					local item = stack:Peek (i)
					if not item then return end
					
					dropDownMenu:AddItem (item:GetDescription ())
						:AddEventListener ("Click",
							function ()
								undoRedoStack:Undo (i + 1)
							end
						)
				end
			end
		)
	toolbar:AddSplitButton ("Redo")
		:SetIcon ("icon16/arrow_redo.png")
		:AddEventListener ("DropDownClosed",
			function (_, dropDownMenu)
				dropDownMenu:Clear ()
			end
		)
		:AddEventListener ("DropDownOpening",
			function (_, dropDownMenu)
				local undoRedoStack = self:GetActiveUndoRedoStack ()
				if not undoRedoStack then return end
				local stack = undoRedoStack:GetRedoStack ()
				for i = 0, 19 do
					local item = stack:Peek (i)
					if not item then return end
					
					dropDownMenu:AddItem (item:GetDescription ())
						:AddEventListener ("Click",
							function ()
								undoRedoStack:Redo (i + 1)
							end
						)
				end
			end
		)
	
	toolbar:AddSeparator ()
	
	toolbar:AddButton ("Run Code")
		:SetAction ("Run Code")
	
	toolbar:AddSeparator ()
	
	toolbar:AddButton ("Namespace Browser")
		:SetIcon ("icon16/application_side_list.png")
		:AddEventListener ("Click",
			function ()
				if not self.RootNamespaceBrowserView then
					self.RootNamespaceBrowserView = self:CreateNamespaceBrowserView (namespace)
					self.RootNamespaceBrowserView:AddEventListener ("Removed",
						function ()
							self.RootNamespaceBrowserView = nil
						end
					)
				end
				self.RootNamespaceBrowserView:Select ()
			end
		)
	
	toolbar:AddSeparator ()
	
	toolbar:AddButton ("Reload GCompute")
		:SetIcon ("icon16/arrow_refresh.png")
		:AddEventListener ("Click",
			function ()
				RunConsoleCommand ("gcompute_reload")
				RunConsoleCommand ("gcompute_show_ide")
			end
		)
	
	return toolbar
end
