require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local se = require 'samp.events'
local imguicheck, imgui	= pcall(require, "imgui")
local vkeys = require 'vkeys'
local encoding = require 'encoding'
local inicfg = require 'inicfg'

update_state = false
local script_vers = 9
local script_vers_text = "1.7 BETA"

local update_url = "https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/Nazar1ky/ASHelper/raw/main/ASHelper.lua"
local script_path = thisScript().path

encoding.default = 'CP1251'
u8 = encoding.UTF8
local tag = "{62E200}[ASHelper]: {FFFFFF}"
local color_err = "{62E200}[ASHelper]: {FF0000}"
local inprocess = false

local configuration = inicfg.load({
	main_settings = {
		myrankint = 0,
        myrank = '',
        gender = 0,
        fastmenu = "X"
    },
}, "AS Helper")

function checker()
    local function DownloadFile(url, file)
		downloadUrlToFile(url,file,function(id,status)
			if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			end
		end)
		while not doesFileExist(file) do
			wait(1000)
		end
	end
    if not imguicheck then
            sampAddChatMessage(tag .. "���������� imgui �� �������... ���������!", -1)
            DownloadFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/imgui.lua', 'moonloader/lib/imgui.lua')
            DownloadFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll')
            sampAddChatMessage(tag .. "���������� imgui ���� �����������! ������������...!", -1)
            thisScript():reload()
            return false
    end
end


if imguicheck then
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
    colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
    colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
    colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
    colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
    colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
    colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
    colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
    colors[clr.CloseButton] = ImVec4(1.00, 0.10, 0.24, 0.00)
    colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.10, 0.24, 0.00)
    colors[clr.CloseButtonActive] = ImVec4(1.00, 0.10, 0.24, 0.00)
    colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
    main_window_state = imgui.ImBool(false)
    playerID = imgui.ImBuffer(256)
    playerExpel = imgui.ImBuffer(256)
    licID = imgui.ImBuffer(256)
    openmenu = imgui.ImBuffer(''..configuration.main_settings.fastmenu, 256)
    checkbox1 = imgui.ImBool(false)
    checkbox2 = imgui.ImBool(false)
    checkbox3 = imgui.ImBool(false)
    isp_menu = imgui.ImBool(false)
    lic_menu = imgui.ImBool(false)
    other_menu = imgui.ImBool(false)
    settings_menu = imgui.ImBool(false)
    settings_menu = imgui.ImBool(false)
    anim_cheat = imgui.ImBool(false)
    arr_lic = {u8"������", u8"���������", u8"�����", u8"�������", u8"�����", u8"������", u8"�����", u8"��������", u8"�����"}
    lictype = imgui.ImInt(0)
    arr_gender = {u8"�������", u8"�������"}
    gendertype = imgui.ImInt(configuration.main_settings.gender)

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
            imgui.Checkbox(u8'��������� ��� ������', settings_menu)
            imgui.Checkbox(u8'���� ������ ������� (���)', anim_cheat)
            imgui.Text(u8'������ �������: ' .. script_vers_text)
            imgui.Text(u8"��� ����: "..u8(configuration.main_settings.myrank).." ("..configuration.main_settings.myrankint..")")
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
            if imgui.Button(u8'�������������') then
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
            imgui.Checkbox(u8'�����������', checkbox3)
            if checkbox3.v then
                if imgui.Combo(u8'�������� ��������', lictype, arr_lic, 9) then
                    print(lictype.v)
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
            imgui.InputText(u8'������ �������� ����', openmenu)
            if imgui.Combo(u8'�������� ���', gendertype, arr_gender, 2) then
            end
            if imgui.Button(u8'���������') then
                configuration.main_settings.gender = gendertype.v
                configuration.main_settings.fastmenu = openmenu.v
                inicfg.save(configuration,"AS Helper")
            end
            if imgui.Button(u8'������������� ������') then
                thisScript():reload()
            end
            if imgui.Button(u8'��������� ������') then
                thisScript():unload()
            end
            imgui.End()
        end
    end
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    checker()
    name = string.gsub(sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))), "_", " ")
    getmyrank = true
    sampSendChat("/stats")
    if not doesFileExist('moonloader/config/AS Helper.ini') then
        if inicfg.save(configuration, 'AS Helper.ini') then
			sampAddChatMessage(tag .. "������ ���� ������������.")
		end
    end
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
    sampRegisterChatCommand("devmaxrank", function()
        if sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) == "Sergey_Fedovich" then
            devmaxrankp = not devmaxrankp
            sampAddChatMessage("{ff6633}[����� ������������] {FFFFFF}����������� ������������ ����: " ..(devmaxrankp and "{00FF00}��������" or "{FF0000}���������"), 0xff6633)
            getmyrank = true
            sampSendChat("/stats")
        else
            sampAddChatMessage("{ff6347}[������] {FFFFFF}����������� �������! ������� /help ��� ��������� ��������� �������.",0xff6347)
        end
    end)
    while true do
        wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tag .. "������ ������� ��������! ������������...")
                    thisScript():reload()
                end
            end)
            break
        end
            if wasKeyPressed(vkeys.name_to_id(configuration.main_settings.fastmenu,true)) then
                if imguicheck then
                    main_window_state.v = not main_window_state.v
                else
                    sampAddChatMessage(tag .. "� ��� �� ����������� ���������� imgui...")
                end
            end
            if imguicheck then
                imgui.Process = main_window_state.v
            end
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
            if valid and doesCharExist(ped) then
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    if imguicheck then
                        if checkbox2.v then
                            playerID.v = tostring(id)
                        end
                    end
                end
            end
        
    end
end
function privet()
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "��������...", 0xFFFF00)
            sampSendChat('�����������, � "' .. configuration.main_settings.myrank .. '" ������� ���������������� ������, ��� ���� ��� ������?')
            wait(1500)
            sampSendChat('/do �� ����� ����� ������� � �������� "' .. configuration.main_settings.myrank .. ' - '.. name .. '.')
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
            sampAddChatMessage(tag .. "���������!", 0xFFFF00)
            inprocess = not inprocess
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
            sampSendChat('/me ���������� �������� � {gender:�������|��������} � �������� ��������')
            wait(1700)
            sampSendChat('/givelicense '.. playerID.v)
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
function se.onShowDialog(dialogId, style, title, button1, button2, text)
    if dialogId == 6 then
        if checkbox3.v then
            sampSendDialogResponse(6, 1, lictype.v, _)
            return false
        end
    elseif dialogId == 1234 then
        if checkbox3.v and inprocess == false then
            if text:find("���: "..sampGetPlayerNickname(playerID.v)) then
                if text:find("��������� ��������") then
                    lua_thread.create(function()
                        while inprocess do
                            wait(0)
                        end
                        inprocess = true
                        lictype.v = 5
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
                        wait(1700)
                        sampSendChat('/givelicense ' .. playerID.v)
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
    elseif dialogId == 235 and getmyrank then
        if text:find('�����������') then
            for DialogLine in text:gmatch('[^\r\n]+') do
                local nameRankStats, getStatsRank = DialogLine:match('���������: {B83434}(.+)%p(%d+)%p')
                if tonumber(getStatsRank) then
                    local rangint = tonumber(getStatsRank)
                    local rang = nameRankStats
                    if rangint ~= configuration.main_settings.myrankint then
                        sampAddChatMessage(tag .. "��� ���� ��� ������� �� "..rang.." ("..rangint..")")
                    end
                    configuration.main_settings.myrank = rang
                    configuration.main_settings.myrankint = rangint
                    if nameRankStats:find('����������') or devmaxrankp then
                        getStatsRank = 10
                        configuration.main_settings.myrank = "����������"
                        configuration.main_settings.myrankint = 10
                    end
                    inicfg.save(configuration,"AS Helper")
                end
            end
        else
            sampAddChatMessage(color_err .. "�� �� ��������� � ���������, ������ ��������!")
            thisScript():unload()
        end
        getmyrank = false
        return false
    end
end

function se.onSendCommand(cmd)
    if cmd:find('{gender:%A+|%A+}') then
        local male, female = cmd:match('{gender:(%A+)|(%A+)}')
        if  configuration.main_settings.gender == 0 then
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
    if imguicheck then
        if anim_cheat.v then
            if playerId == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
                if animLib == 'CRACK' and animName == 'crckdeth2' then return false end
            end
        end
    end
end
