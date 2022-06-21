SWI.Gui = {}
SWI.Gui.__index = SWI.Gui

SWI.Gui.popupIsAlive = false

function SWI.Gui.popupText(table)
    if SWI.Gui.popupIsAlive then
        return
    end

    SWI.Gui.popupIsAlive = true

    -- frame, title, placeholder, onClick, onClose
    if table.frame then 
        table.frame:SetMouseInputEnabled(false)
        table.frame:SetKeyboardInputEnabled(false)
    end 

    local width, height = 228, 100

    local popup = vgui.Create("DFrame")
    popup:SetTitle(table.title or "Popup")
    popup:SetSize(width, height)
    popup:Center()
    popup:ShowCloseButton(true)
    popup:MakePopup()
    popup:SetDraggable(false)

    function endPopup()
        SWI.Gui.popupIsAlive = false  

        if table.frame then 
            table.frame:MakePopup() 
        end

        popup.OnClose = function() end
        popup:Close()
    end

    popup.OnClose = function() 
        if onClose then onClose() end
        endPopup()
    end

    local button = vgui.Create("DButton", popup)
    button:SetSize(64, 22)
    button:SetPos(width/2-32, height-22*1.5)
    button:SetText("OK")

    local input = vgui.Create("DTextEntry", popup)
    input:SetSize(width-20, 22)
    input:SetPos(10, height/2-17)
    input:SetPlaceholderText(table.placeholder or " ")

    function error(text)
        input:SetValue("")
        input:SetPlaceholderColor(Color(255, 0, 0))
        input:SetPlaceholderText(text)
    end

    button.DoClick = function()
        if table.onClick and type(table.onClick) == "function" then
            local exit = table.onClick(input:GetValue(), error)

            if exit then
                endPopup()
            end
        end
    end

    input.OnChange = function()
        input:SetPlaceholderColor()
        input:SetPlaceholderText(table.placeholder or " ")
    end
end

function SWI.Gui.menu()
    local player = LocalPlayer()

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Save Weapon Inventory")
    frame:SetSize(530, 420)
    frame:Center()
    frame:ShowCloseButton(true)
    frame:SetDraggable(true)
    frame:SetIcon('icon16/disk.png')
    frame:MakePopup()

    SWI.Gui.popupText {
        frame = frame,
        title = "Хлеб лучше есть с маслом. ГЛЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕНТ",
        placeholder = "Enter 666",
        onClick = function(value, error)
            print(value)

            if value == "666" then
                error("SATAN!!!")
            end
        end
    }

    -- local tabs = vgui.Create('DPropertySheet', frame)
    -- tabs:SetSize(500, 340)
    -- tabs:Dock(FILL)

    -- local sets_tab = vgui.Create('DPanel')
    -- sets_tab:SizeToContents()
    -- sets_tab.Paint = function(self, w, h) 
    --     draw.RoundedBox(0, 0, 0, w, h, Color(141, 145, 149, 1))
    -- end

    -- local set_list = vgui.Create('DComboBox', sets_tab)
    -- set_list:SetPos(0, 0)
    -- set_list:SetSize(265, 30)
    -- if player_sets:Len() == 0 then 
    --     set_list:SetValue('No weapon sets have been created yet')
    -- else
    --     set_list:SetValue('Select set')
    -- end

    -- for _, v in pairs(player_sets:GetNames()) do
    --     set_list:AddChoice(v)
    -- end

    -- local give = vgui.Create('DButton', sets_tab)
    -- give:SetPos(0, 310)
    -- give:SetSize(100, 30)
    -- give:SetText('Give set')
    -- give:SetIcon('icon16/accept.png')
    -- give:SetVisible(false)
    -- give.DoClick = function()
    --     local set = set_list:GetOptionText(set_list:GetSelectedID())
    --     player_sets:Give(set, self.ply, tobool(GetConVar("swi_add_weapons"):GetInt()))
    -- end

    -- local save_remove = vgui.Create('DButton', sets_tab)
    -- save_remove:SetPos(210, 310)
    -- save_remove:SetSize(109, 30)
    -- save_remove:SetVisible(false)

    -- local weapons_list = vgui.Create('DListView', sets_tab)
    -- weapons_list:AddColumn('Weapons')
    -- weapons_list:Center()
    -- weapons_list:SetPos(SWI:SplitPos(weapons_list:GetPos())[1], 40)
    -- weapons_list:SetSize(504, 260)
    -- weapons_list:SetVisible(false)

    -- local delete = vgui.Create("DButton", sets_tab)
    -- delete:SetPos(105, 310)
    -- delete:SetSize(100, 30)
    -- delete:SetText("Delete set")
    -- delete:SetIcon("icon16/delete.png")
    -- delete:SetVisible(false)
    -- delete.DoClick = function()
    --     local set = set_list:GetOptionText(set_list:GetSelectedID())

    --     player_sets:Del(set)

    --     CLIENT_C:ReplaceSets(player_sets:GetAll())

    --     set_list:Clear()
    --     for _, v in pairs(player_sets:GetNames()) do
    --         set_list:AddChoice(v)
    --     end

    --     if player_sets:Len() ~= 0 then
    --         set_list:ChooseOptionID(math.random(1, player_sets:Len()))
    --     else
    --         weapons_list:SetVisible(false)
    --         give:SetVisible(false)
    --         delete:SetVisible(false)    
    --         save_remove:SetVisible(false)
    --         set_list:SetValue('No weapon sets have been created yet')
    --     end
    -- end

    -- function set_list:OnSelect(index, text, data)
    --     weapons_list:Clear()

    --     player_saved_sets:Replace(CLIENT_C:GetSavedSets())

    --     for _, v in pairs(player_sets:Get(text)['weapons']) do
    --         weapons_list:AddLine(v)
    --     end
    --     save_remove:SetEnabled(true)
    --     weapons_list:SetVisible(true)
    --     give:SetVisible(true)
    --     delete:SetVisible(true)
    --     save_remove:SetVisible(true)
    --     if player_saved_sets:Get(text) == nil then
    --         save_remove:SetText('Save set')
    --         save_remove:SetIcon('icon16/folder_add.png')
    --         save_remove.DoClick = function()
    --             player_saved_sets:Add(text, player_sets:Get(text))
    --             file.Write('Swi_saved_sets.json', util.TableToJSON(player_saved_sets:GetAll(), true))
    --             CLIENT_C:ReplaceSavedSets(player_saved_sets:GetAll())
    --             save_remove:SetEnabled(false)
    --             save_remove:SetText('Saved!')
    --         end
    --     else
    --         save_remove:SetText('Delete save')
    --         save_remove:SetIcon('icon16/folder_delete.png')
    --         save_remove.DoClick = function()
    --             player_saved_sets:Del(text)
    --             file.Write('Swi_saved_sets.json', util.TableToJSON(player_saved_sets:GetAll(), true))
    --             CLIENT_C:ReplaceSavedSets(player_saved_sets:GetAll())
    --             save_remove:SetEnabled(false)
    --             save_remove:SetText('Delete!')
    --         end
    --     end
    -- end

    -- local set_research = vgui.Create('DButton', sets_tab)
    -- set_research:SetPos(269, 0)
    -- set_research:SetSize(91, 30)
    -- set_research:SetText('Refresh')
    -- set_research:SetIcon('icon16/arrow_refresh.png')
    -- set_research.DoClick = function()
    --     local selected = set_list:GetSelectedID()
    --     player_sets:Replace(CLIENT_C:GetSets())

    --     set_list:Clear()
    --     for _, v in pairs(player_sets:GetNames()) do
    --         set_list:AddChoice(v)
    --     end 
    --     if selected ~= nil then
    --         local sel_name = set_list:GetOptionText(selected)

    --         for i=0, player_sets:Len() do
    --             if set_list:GetOptionText(i) == sel_name then
    --                 set_list:ChooseOptionID(i)
    --             end
    --         end
    --     end

    --     if selected == nil then
    --         if player_sets:Len() == 0 then
    --             set_list:SetValue('No weapon sets have been created yet')
    --         else
    --             set_list:SetValue('Select set')
    --         end
    --     end
    -- end

    -- local set_make = vgui.Create('DButton', sets_tab)
    -- set_make:SetPos(364, 0)
    -- set_make:SetSize(140, 30)
    -- set_make:SetText('Create')
    -- set_make:SetIcon('icon16/add.png')
    -- set_make.DoClick = function()
    --     local popup = vgui.Create('DFrame')
    --     popup:SetSize(200, 100)
    --     popup:Center()
    --     popup:SetTitle('Create new set')
    --     popup:SetIcon('icon16/add.png')
    --     popup:SetVisible(true)
    --     popup:ShowCloseButton(true)
    --     popup:SetDraggable(true)
    --     popup:MakePopup()

    --     local error = vgui.Create('DLabel', popup)
    --     error:SetSize(300, 20)
    --     error:SetColor(Color(227, 97, 97))
    --     error:SetText('Name is already taken')
    --     error:SetPos(45, 25)
    --     error:SetVisible(false)

    --     local title = vgui.Create('DLabel', popup)
    --     title:SetSize(300, 20)
    --     title:SetText('Enter the name of the set')
    --     title:SetPos(35, 25)
        
    --     local name = vgui.Create('DTextEntry', popup)
    --     name:SetSize(105, 20)
    --     name:SetPos(45, 45)

    --     local create = vgui.Create('DButton', popup)
    --     create:SetText('Create')
    --     create:SetSize(50, 20)
    --     create:SetPos(45, 70)
    --     create:SetEnabled(false)
    --     create.DoClick = function()
    --         player_sets:Add(name:GetValue(), SWI:CreateSet(self.ply))
    --         CLIENT_C:ReplaceSets(player_sets:GetAll())
    --         popup:Close()
    --     end

    --     local cancel = vgui.Create('DButton', popup)
    --     cancel:SetText('Cancel')
    --     cancel:SetSize(50, 20)
    --     cancel:SetPos(100, 70)
    --     cancel.DoClick = function()
    --         popup:Close()
    --     end
        
    --     function name:OnChange()
    --         if player_sets:Get(name:GetValue()) ~= nil then
    --             error:SetVisible(true)
    --             title:SetVisible(false)
    --             create:SetEnabled(false)
    --         else
    --             if string.len(name:GetValue()) ~= 0 then
    --                 error:SetVisible(false)
    --                 title:SetVisible(true)
    --                 create:SetEnabled(true)
    --             else
    --                 create:SetEnabled(false)
    --             end
    --         end
    --     end
    -- end
        
    -- tabs:AddSheet("Sets", sets_tab, "icon16/package.png", false, false, "Sets of weapons")
end