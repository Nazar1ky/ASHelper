require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local se = require 'samp.events'
local config = require "config"
local res_imgui, imgui = pcall(require, 'imgui')
local key = require 'vkeys'
local encoding = require 'encoding'
local inicfg = require 'inicfg'

update_state = false
local script_vers = 4
local script_vers_text = "1.2"

local update_url = "https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/Nazar1ky/ASHelper/raw/main/ASHelper.lua"
local script_path = thisScript().path

encoding.default = 'CP1251'
u8 = encoding.UTF8
local tag = "{62E200}[ASHelper]: {FFFFFF}"
local color_err = "{62E200}[ASHelper]: {FF0000}"
local inprocess = false


local confige = config.settings
local gender = confige.gender
local keyr = confige.keyr

-- if not _ then
--         sampAddChatMessage("���������� imgui �� �������... ���������!", -1)
--         downloadUrlToFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/imgui.lua', 'moonloader/lib/imgui.lua')
--         downloadUrlToFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll')
--         thisScript():reload()
--         return false
-- end


local main_window_state = imgui.ImBool(false)
local playerID = imgui.ImBuffer(256)
local playerExpel = imgui.ImBuffer(256)
local licID = imgui.ImBuffer(256)
local checkbox1 = imgui.ImBool(false)
local checkbox2 = imgui.ImBool(false)
local checkbox3 = imgui.ImBool(false)
local checkbox4 = imgui.ImBool(false)
local isp_menu = imgui.ImBool(false)
local lic_menu = imgui.ImBool(false)
local other_menu = imgui.ImBool(false)
local settings_menu = imgui.ImBool(false)
local anim_cheat = imgui.ImBool(false)
local arr_lic = {u8"������", u8"���������", u8"�����", u8"�������", u8"�����", u8"������", u8"��������", u8"�����"}
local lictype = imgui.ImInt(0)

local ex, ey = getScreenResolution()
function imgui.OnDrawFrame()
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(580, 250), imgui.Cond.FirstUseEver)
        imgui.Begin('AutoSchool helper', main_window_state)
        imgui.InputText(u8'ID ������ ��� �����������', playerID)
        imgui.Checkbox(u8'��� ����������� playerID ������������ ���� � ���� ���� ��������', checkbox2)
        imgui.Checkbox(u8'PRICE LIST', isp_menu)
        imgui.Checkbox(u8'������� ��������', lic_menu)
        imgui.Checkbox(u8'������', other_menu)
        imgui.Checkbox(u8'���������', settings_menu)
        imgui.Checkbox(u8'���� ������ ������� (���)', anim_cheat)
        imgui.Text(u8'������ �������: ' .. script_vers_text)
        imgui.Text(u8(string.format('������� ����: %s', os.date())))
        imgui.End()
    end
    if isp_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(300, 170), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || PRICE LIST', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'PRICE LIST:\n�� ����: 10.000\n�� ����: 12.000\n�� �������: 21.000\n������ ���������: 20.000\n������: 50.000(���������� ���. �����\n�����: 100.000\n�� ��������: 200.000\n�� ������ 20.000 (������� � ���������)')
        imgui.End()
    end
    if lic_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(430, 275), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || ������� ��������', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'��� ������� �������� �� ������ ����� ��������� ���. �����!')
        if imgui.Button(u8'������������') then
            privet()
        end
        if imgui.Button(u8'�������� �� ������') then
            pilot()
        end
        if imgui.Button(u8'��������� ���. �����') then
                med(myid)
        end
        if imgui.Button(u8'������ ��������') then
            if playerID.v == '' then
                sampAddChatMessage(tag .. "�� �� ������� playerID !", 0xFFFF00)
            else 
                licgive(playerID.v)
            end
        end
        if imgui.Button(u8'������ �������� (nonRP)') then
            sampSendChat('/givelicense '.. playerID.v)
            print(sampGetPlayerNickname(playerID.v))
        end
        if imgui.Button(u8'�������� �������� ���') then
            if inprocess == false then
                sampSendChat('/todo �������� ��� ���*����������� ����������')
            else
                sampAddChatMessage(tag .. "�� ��� ����� ����������, ���������!", 0xFFFF00)
            end

        end
        imgui.Checkbox(u8'������ ��� �������� ������� � ��� ���������', checkbox1)
        imgui.Checkbox(u8'������������ ���. �����', checkbox4)
        imgui.Checkbox(u8'������������ (BETA)', checkbox3)
        if checkbox3.v then
            if imgui.Combo(u8'�������� ��������', lictype, arr_lic, 8) then
                print(selected_item.v)
            end
        end
            imgui.End()
        end
    if other_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(200, 320), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || ������', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'�� ������:')
        imgui.InputText(u8'�������', playerExpel)
        if imgui.Button(u8'������� �� ���������') then
            if  playerID.v == '' or playerExpel.v == '' then
                sampAddChatMessage(tag .. "�� �� ������� ������� ���� playerID !", 0xFFFF00)
                print(1)
            else
                print(0)
                sampSendChat('/expel '.. playerID.v .. ' ' .. u8:decode(playerExpel.v))
            end
        end
        if imgui.Button(u8'������� ���������') then
            sampSendChat('/jobprogress')
        end
        if imgui.Button(u8'������ �� �������(online)') then
            sampSendChat('/members')
        end
        if imgui.Button(u8'���������� �����') then
            sampSendChat('/time')
        end
        imgui.Text(u8'������:')
        if imgui.Button(u8'����') then
            sampSendChat('/mm')
        end
        if imgui.Button(u8'���������') then
            sampSendChat('/settings')
        end
        if imgui.Button(u8'������') then
            sampSendChat('/help')
        end
        if imgui.Button(u8'���������') then
            sampSendChat('/gps')
        end
        if imgui.Button(u8'���������') then
            sampSendChat('/invent')
        end
        imgui.End()
    end
    if settings_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(200, 100), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || ���������', nil, imgui.WindowFlags.NoCollapse)
        if imgui.Button(u8'������������� ������') then
            thisScript():reload()
        end
        if imgui.Button(u8'��������� ������') then
            thisScript():unload()
        end
        imgui.End()
    end
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(tag .. "���� ����������! ������: " .. updateIni.info.vers_text .. ", ��������� ����������", 0xFFFF00)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    while true do
        wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("������ ������� ��������! ������������...")
                    thisScript():reload()
                end
            end)
            break
        end
            if wasKeyPressed(keyr) then
                main_window_state.v = not main_window_state.v
            end
            imgui.Process = main_window_state.v
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
            if valid and doesCharExist(ped) then
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    if checkbox2.v then
                        playerID.v = tostring(id)
                    end
                end
            end
            local idGun = getCurrentCharWeapon(playerPed)
            -- if idGun == 24 then
            --     sampSendChat("/me ������ ����")
            -- else
            --     sampSendChat("/me ����� ����")
            -- end
    end
end
function privet()
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "��������...", 0xFFFF00)
            sampSendChat('�����������, � "' .. confige.rank .. '" ������� ���������������� ������, ��� ���� ��� ������?')
            wait(1500)
            sampSendChat('/do �� ����� ����� ������� � �������� "' .. confige.rank .. ' - '.. confige.name .. '.')
            wait(500)
            sampAddChatMessage(tag .. "���������!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "�� ��� ����� ����������, ���������!", 0xFFFF00)
    end
end
function pilot()
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "��������...", 0xFFFF00)
            sampSendChat('�������� �������� �� ����� �� ������ � ��������� �. ���-��������')
            wait(1500)
            sampSendChat('/n /gps -> ������ ����� -> ��������� �������� -> [LV] ��������� (9)')
            wait(500)
            sampAddChatMessage(tag .. "���������!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "�� ��� ����� ����������, ���������!", 0xFFFF00)
    end
end
function med(myid)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "��������...", 0xFFFF00)
            sampSendChat('��� ��������� �������� �� ������ �������� ���� ���.����� ')
            wait(1000)
            sampSendChat('/b /showmc ' .. myid)
            wait(500)
            sampAddChatMessage(tag .. "���������! ��������� ��� � ���. ����� �������� '��������� ��������(��)'", 0xFFFF00)
            inprocess = not inprocess
            wait(500)
            if checkbox3.v then
                selected_item.v = 4
                sampAddChatMessage(tag .. "������������ �������: ������'", 0xFFFF00)
            end
        end)
    else
        sampAddChatMessage(color_err .. "�� ��� ����� ����������, ���������!", 0xFFFF00)
    end
end
function licgive(id)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "��������...", 0xFFFF00)
            sampSendChat('�������...')
            wait(2000)
            sampSendChat('/me {gender:����|�����} �� ����� ����� � {gender:��������|���������} ������ ����� �� ��������� ��������')
            wait(2000)
            sampSendChat('/do ������ ��������� ����� ����� �� ��������� �������� ��� ��������.')
            wait(2000)
            sampSendChat('/me ���������� �������� �� ������ {gender:�������|��������} � �������� ��������')
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "�� ��� ����� ����������, ���������!", 0xFFFF00)
    end
end
function se.onServerMessage(color, text)
    if text:find('%[����������%]%s+%{%w+%}�� ������� ������� ��������') then
        if checkbox1.v then
            if inprocess == false then
                lua_thread.create(function()
                    sampSendChat('/todo �������� ��� ���*����������� ����������')
                    wait(500)
                    sampAddChatMessage(tag .. "������ ����� ��������, ������ ���������.", 0xFFFF00)
                end)
            else
                sampAddChatMessage(color_err .. "�� ����� ����������, ��������� ��������� �� �������!", 0xFFFF00)
            end
        end
    end
end
-- function se.onShowDialog(dialogId, style, title, button1, button2, text)
--     if dialogId == 6 then
--         sampSendDialogResponse(6, 1, 0, nil)
--     end
-- end
function se.onShowDialog(dialogId, style, title, button1, button2, text)
    if checkbox3.v then
        if dialogId == 6 then
            sampSendDialogResponse(sampGetCurrentDialogId(), 1, selected_item.v, _)
            return false
        end
    end
    if dialogId == 1234 then
        if checkbox4.v then
            if text:find("���: "..sampGetPlayerNickname(playerID.v)) then
                if text:find("��������� ��������") then
                    lua_thread.create(function()
                        while inprocess do
                            wait(0)
                        end
                        inprocess = true
                        sampSendChat("/me ���� ���.����� � ���� ����� � ���������")
                        wait(2000)
                        sampSendChat("/do ���.����� � �����.")
                        wait(2000)
                        sampSendChat("/todo �� � �������* ������� ���.����� �������")
                        wait(2000)
                        sampSendChat('/me {gender:����|�����} �� ����� ����� � {gender:��������|���������} ������ ����� �� ��������� �������� �� ������')
                        wait(2000)
                        sampSendChat('/do ������ ��������� ����� ����� �� ��������� �������� ��� ��������.')
                        wait(2000)
                        sampSendChat('/me ���������� �������� �� ������ {gender:�������|��������} � �������� ��������')
                        sampSendChat('/givelicense ' .. playerID)
                        inprocess = false
                    end)
                else 
                    lua_thread.create(function()
                        inprocess = true
                        ASHelperMessage('������� �� ��������� ��������, ��������� �������� ���.�����!')
                        sampSendChat("/me ���� ���.����� � ���� ����� � ���������")
                        wait(2000)
                        sampSendChat("/do ���.����� �� � �����.")
                        wait(2000)
                        sampSendChat("/todo � ���������, � ���.����� ��������, ��� � ��� ���� ����������.* ������� ���.����� �������")
                        wait(2000)
                        sampSendChat("�������� � � ��������� �����!")
                        inprocess = false
                    end)
                end
                return false
            end
        end
    end
end

function se.onSendCommand(cmd)
    if cmd:find('{gender:%A+|%A+}') then
        local male, female = cmd:match('{gender:(%A+)|(%A+)}')
        if  gender == 0 then
            local gendermsg = cmd:gsub('{gender:%A+|%A+}', male, 1)
            sampSendChat(tostring(gendermsg))
            return false
        else
            local gendermsg = cmd:gsub('{gender:%A+|%A+}', female, 1)
            sampSendChat(tostring(gendermsg))
            return false
        end
    end
end
function se.onApplyPlayerAnimation(playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time)
    if anim_cheat.v then
        if playerId == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
            if animLib == 'CRACK' and animName == 'crckdeth2' then return false end
        end
    end
end