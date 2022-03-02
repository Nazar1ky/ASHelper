require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local se = require 'samp.events'
local imguicheck, imgui	= pcall(require, "imgui")
local vkeys = require 'vkeys'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local font = renderCreateFont('Arial',8,5)
local cheat_esp = false
local globalDistance = 100.0
local deagleDistance = 35.0
local m4Distance = 90.0

update_state = false
local script_vers = 12
local script_vers_text = "1.7 Mini-fix"

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

function activation()
	 cheat_esp = not cheat_esp
end


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
            sampAddChatMessage(tag .. "Áèáëèîòåêà imgui íå íàéäåíà... Óñòàíîâèì!", -1)
            DownloadFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/imgui.lua', 'moonloader/lib/imgui.lua')
            DownloadFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll')
            sampAddChatMessage(tag .. "Áèáëèîòåêà imgui áûëà óñòàíîâëåíà! Ïåðåçàïóñêàþ...!", -1)
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
    cheat_menu = imgui.ImBool(false)
    anim_cheat = imgui.ImBool(false)
    esp_cheat = imgui.ImBool(false)
    arr_lic = {u8"Ìàøèíà", u8"Ìîòîöèêëû", u8"Ïèëîò", u8"Ðûáàëêà", u8"Ëîäêè", u8"Îðóæèå", u8"Îõîòà", u8"Ðàñêîïêè", u8"Òàêñè"}
    lictype = imgui.ImInt(0)
    arr_gender = {u8"Ìóæ÷èíà", u8"Æåíùèíà"}
    gendertype = imgui.ImInt(configuration.main_settings.gender)

    local ex, ey = getScreenResolution()
    function imgui.OnDrawFrame()
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if main_window_state.v then
            imgui.SetNextWindowSize(imgui.ImVec2(580, 250), imgui.Cond.FirstUseEver)
            imgui.Begin('AutoSchool helper', main_window_state)
            imgui.InputText(u8'ID Èãðîêà äëÿ ìàíèïóëÿöèé', playerID)
            imgui.Checkbox(u8'Ïðè íàöåëèâàíèå playerID çàïîëíÿåòüñÿ àéäè â òîãî êîãî öåëèòåñü', checkbox2)
            imgui.Checkbox(u8'PRICE LIST', isp_menu)
            imgui.Checkbox(u8'Ïðîäàæà Ëèöåíçèé', lic_menu)
            imgui.Checkbox(u8'Ïðî÷åå', other_menu)
            imgui.Checkbox(u8'Íàñòðîéêè äëÿ ðàáîòû', settings_menu)
            imgui.Checkbox(u8'Cheat Functions', cheat_menu)
            imgui.Text(u8'Âåðñèÿ ñêðèïòà: ' .. script_vers_text)
            imgui.Text(u8"Âàø ðàíã: "..u8(configuration.main_settings.myrank).." ("..configuration.main_settings.myrankint..")")
            imgui.Text(u8(string.format('Òåêóùàÿ äàòà: %s', os.date())))
            imgui.End()
        end
        if isp_menu.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowSize(imgui.ImVec2(300, 170), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || PRICE LIST', nil, imgui.WindowFlags.NoCollapse)
            imgui.Text(u8'PRICE LIST:\nÍà àâòî: 10.000\nÍà ìîòî: 12.000\nÍà ðûáàëêó: 21.000\nÂîäíûé òðàíñïîðò: 20.000\nÎðóæèå: 50.000(Òðåáóåòüñÿ Ìåä. êàðòà\nÎõîòà: 100.000\nÍà ðàñïîïêè: 200.000\nÍà ïîëåòû 20.000 (Ñäàâàòü â àâèàøêîëå)')
            imgui.End()
        end
        if lic_menu.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowSize(imgui.ImVec2(430, 275), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || Ïðîäàæà ëèöåíçèé', nil, imgui.WindowFlags.NoCollapse)
            imgui.Text(u8'Ïðè ïðîäàæå ëèöåíçèè íà îðóæèå íóæíî ïðîâåðèòü ìåä. êàðòó!')
            if imgui.Button(u8'Ïðåäñòàâèòüñÿ') then
                privet()
            end
            if imgui.Button(u8'Ëèöåíçèÿ íà ïèëîòà') then
                pilot()
            end
            if imgui.Button(u8'Ïðîâåðèòü ìåä. êàðòó') then
                    med(myid)
            end
            if imgui.Button(u8'Âûäàòü ëèöåíçèþ') then
                if playerID.v == '' then
                    sampAddChatMessage(tag .. "Âû íå óêàçàëè playerID !", 0xFFFF00)
                else 
                    licgive(playerID.v)
                end
            end
            if imgui.Button(u8'Âûäàòü ëèöåíçèþ (nonRP)') then
                sampSendChat('/givelicense '.. playerID.v)
                print(sampGetPlayerNickname(playerID.v))
            end
            if imgui.Button(u8'Ïîæåëàòü õîðîøåãî äíÿ') then
                if inprocess == false then
                    sampSendChat('/todo Óäà÷íîãî âàì äíÿ*óëûáíóâøèñü ïîñåòèòåëþ')
                else
                    sampAddChatMessage(tag .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
                end

            end
            imgui.Checkbox(u8'Ïèñàòü ïðè óñïåøíîé ïîêóïêè â ÷àò ïîæåëàíèå', checkbox1)
            imgui.Checkbox(u8'Àâòîñèñòåìà', checkbox3)
            if checkbox3.v then
                if imgui.Combo(u8'Âûáåðèòå ëèöåíçèþ', lictype, arr_lic, 9) then
                    print(lictype.v)
                end
            end
                imgui.End()
            end
        if other_menu.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowSize(imgui.ImVec2(200, 320), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || Ïðî÷åå', nil, imgui.WindowFlags.NoCollapse)
            imgui.Text(u8'Ïî ðàáîòå:')
            imgui.InputText(u8'Ïðè÷èíà', playerExpel)
            if imgui.Button(u8'Âûãíàòü èç àâòîøêîëû') then
                if  playerID.v == '' or playerExpel.v == '' then
                    sampAddChatMessage(tag .. "Âû íå óêàçàëè ïðè÷èíó ëèáî playerID !", 0xFFFF00)
                    print(1)
                else
                    print(0)
                    sampSendChat('/expel '.. playerID.v .. ' ' .. u8:decode(playerExpel.v))
                end
            end
            if imgui.Button(u8'Ðàáî÷åå ïîðòôîëèî') then
                sampSendChat('/jobprogress')
            end
            if imgui.Button(u8'Ñïèñîê âî ôðàêöèè(online)') then
                sampSendChat('/members')
            end
            if imgui.Button(u8'Ïîñìîòðåòü âðåìÿ') then
                sampSendChat('/time')
            end
            imgui.Text(u8'Äðóãîå:')
            if imgui.Button(u8'Ìåíþ') then
                sampSendChat('/mm')
            end
            if imgui.Button(u8'Íàñòðîéêè') then
                sampSendChat('/settings')
            end
            if imgui.Button(u8'Ïîìîùü') then
                sampSendChat('/help')
            end
            if imgui.Button(u8'Íàâèãàòîð') then
                sampSendChat('/gps')
            end
            if imgui.Button(u8'Èíâåíòàðü') then
                sampSendChat('/invent')
            end
            imgui.End()
        end
        if settings_menu.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowSize(imgui.ImVec2(500, 150), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || Íàñòðîéêè', nil, imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Êíîïêà îòêðûòèÿ ìåíþ', openmenu)
            if imgui.Combo(u8'Âûáåðèòå ïîë', gendertype, arr_gender, 2) then
            end
            if imgui.Button(u8'Ñîõðàíèòü') then
                configuration.main_settings.gender = gendertype.v
                configuration.main_settings.fastmenu = openmenu.v
                inicfg.save(configuration,"AS Helper")
            end
            if imgui.Button(u8'Ïåðåçàãðóçèòü ñêðèïò') then
                thisScript():reload()
            end
            if imgui.Button(u8'Âûãðóçèòü ñêðèïò') then
                thisScript():unload()
            end
            imgui.End()
        end
        if cheat_menu.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowSize(imgui.ImVec2(500, 150), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || Cheat Functions', nil, imgui.WindowFlags.NoCollapse)
            imgui.Text(u8'X: '..X)
            imgui.Text(u8'Y: '..Y)
            imgui.Text(u8'Z: '..Z)
            imgui.Checkbox(u8'Ñáèâ àíèìêè äóáèíêè (×ÈÒ)', anim_cheat)
            if imgui.Checkbox(u8'Easy ESP', esp_cheat) then
                activation()
            end
            if imgui.Button(u8'Çàïðåùåíàÿ àíèìàöèÿ - PISSING') then
                sampSetSpecialAction(68)  
            end
            imgui.End()
        end
    end
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(200) end
    checker()
    repeat
        wait(0)
    until sampIsLocalPlayerSpawned()
    lua_thread.create(function()
        wait(3000)
        getmyrank = true
        sampSendChat('/stats')
    end)
    
    name = string.gsub(sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))), "_", " ")
    if not doesFileExist('moonloader/config/AS Helper.ini') then
        if inicfg.save(configuration, 'AS Helper.ini') then
			sampAddChatMessage(tag .. "Ñîçäàí ôàéë êîíôèãóðàöèè.")
		end
    end
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(tag .. "Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateIni.info.vers_text .. ", Ïîïûòàþñü óñòàíîâèòü", 0xFFFF00)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    sampRegisterChatCommand("devmaxrank", function()
        if sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) == "Sergey_Fedovich" then
            devmaxrankp = not devmaxrankp
            sampAddChatMessage("{ff6633}[Ðåæèì ðàçðàáîò÷èêà] {FFFFFF}Èìèòèðîâàòü ìàêñèìàëüíûé ðàíã: " ..(devmaxrankp and "{00FF00}Âêëþ÷åíî" or "{FF0000}Âûêëþ÷åíî"), 0xff6633)
            getmyrank = true
            sampSendChat("/stats")
        else
            sampAddChatMessage("{ff6347}[Îøèáêà] {FFFFFF}Íåèçâåñòíàÿ êîìàíäà! Ââåäèòå /help äëÿ ïðîñìîòðà äîñòóïíûõ ôóíêöèé.",0xff6347)
        end
    end)
    while true do
        wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tag .. "Ñêðèïò óñïåøíî îáíîâëåí! Ïåðåçàïóñêàþ...")
                    thisScript():reload()
                end
            end)
            break
        end
            if wasKeyPressed(vkeys.name_to_id(configuration.main_settings.fastmenu,true)) then
                if imguicheck then
                    main_window_state.v = not main_window_state.v
                else
                    sampAddChatMessage(tag .. "Ó âàñ íå óñòàíîâëåíà áèáëèîòåêà imgui...")
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
            X, Y, Z = getCharCoordinates(PLAYER_PED)
            if cheat_esp then
                if wasKeyPressed(VK_F8) then
                    activation()
                    wait(1000)
                    activation()
                end
                local pPosX, pPosY, pPosZ = getCharCoordinates(PLAYER_PED)
			    local sPosX, sPosY = convert3DCoordsToScreen(pPosX, pPosY, pPosZ)
			    renderFontDrawText(font, '{00FF00}+', sPosX, sPosY, -1)

			    local charsTable = getAllChars()
			    table.remove(charsTable, 1)

			    for k,v in ipairs(charsTable) do 
			    	local posX, posY, posZ = getCharCoordinates(v)
			    	if getDistanceBetweenCoords3d(posX, posY, posZ, pPosX, pPosY, pPosZ) <= globalDistance then
			    		local wPosX, wPosY = convert3DCoordsToScreen(posX, posY, posZ)
			    		res, id = sampGetPlayerIdByCharHandle(v)
			    		hp = sampGetPlayerHealth(id)
			    		armor = sampGetPlayerArmor(id)
			    		globalHealth = hp + armor
			    		if res then
			    			if getDistanceBetweenCoords3d(posX, posY, posZ, pPosX, pPosY, pPosZ) >= deagleDistance and getDistanceBetweenCoords3d(posX, posY, posZ, pPosX, pPosY, pPosZ) <= m4Distance then
			    				renderDrawBoxWithBorder(wPosX - 35, wPosY - 40, 65, 95, 0x00FFFFFF, 1, 0xFFFFFF00)
			    			elseif getDistanceBetweenCoords3d(posX, posY, posZ, pPosX, pPosY, pPosZ) <= deagleDistance then
			    				renderDrawBoxWithBorder(wPosX - 35, wPosY - 40, 65, 95, 0x00FFFFFF, 1, 0xFFF00F00)
			    			else
			    				renderDrawBoxWithBorder(wPosX - 35, wPosY - 40, 65, 95, 0x00FFFFFF, 1, 0xFFFFFFFF)
			    			end
			    			renderFontDrawText(font, '{FFF000}'..math.ceil((globalHealth)/47), wPosX + 10, wPosY + 20, -1)
			    			renderFontDrawText(font, globalHealth, wPosX, wPosY + 35, -1)
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
            sampAddChatMessage(tag .. "Âûïîëíÿþ...", 0xFFFF00)
            sampSendChat('Ïðèâåòñòâóþ, ÿ "' .. configuration.main_settings.myrank .. '" äàííîãî ëèöåíçèðîâàííîãî öåíòðà, ÷åì ìîãó âàì ïîìî÷ü?')
            wait(1500)
            sampSendChat('/do Íà ãðóäè âåñèò áåéäæèê ñ íàäïèñüþ "' .. configuration.main_settings.myrank .. ' - '.. name .. '.')
            wait(500)
            sampAddChatMessage(tag .. "Âûïîëíåíî!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
    end
end
function pilot()
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Âûïîëíÿþ...", 0xFFFF00)
            sampSendChat('Ïîëó÷èòü ëèöåíçèþ íà ïîë¸òû Âû ìîæåòå â àâèàøêîëå ã. Ëàñ-Âåíòóðàñ')
            wait(1500)
            sampSendChat('/n /gps -> Âàæíûå ìåñòà -> Ñëåäóþùàÿ ñòðàíèöà -> [LV] Àâèàøêîëà (9)')
            wait(500)
            sampAddChatMessage(tag .. "Âûïîëíåíî!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
    end
end
function med(myid)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Âûïîëíÿþ...", 0xFFFF00)
            sampSendChat('Äëÿ ïîëó÷åíèÿ ëèöåíçèè íà îðóæèå ïîêàæèòå âàøó ìåä.êàðòó ')
            wait(1000)
            sampSendChat('/b /showmc ' .. myid)
            wait(500)
            sampAddChatMessage(tag .. "Âûïîëíåíî!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
    end
end
function licgive(id)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Âûïîëíÿþ...", 0xFFFF00)
            sampSendChat('Ñåêóíäó...')
            wait(2000)
            sampSendChat('/me {gender:âçÿë|âçÿëà} ñî ñòîëà áëàíê è {gender:çàïîëíèë|çàïîëíèëà} ðó÷êîé áëàíê íà ïîëó÷åíèå ëèöåíçèè')
            wait(2000)
            sampSendChat('/do Ñïóñòÿ íåêîòîðîå âðåìÿ áëàíê íà ïîëó÷åíèå ëèöåíçèè áûë çàïîëíåí.')
            wait(2000)
            sampSendChat('/me ðàñïå÷àòàâ ëèöåíçèþ è {gender:ïåðåäàë|ïåðåäàëà} å¸ ÷åëîâåêó íàïðîòèâ')
            wait(1700)
            sampSendChat('/givelicense '.. playerID.v)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
    end
end
function se.onServerMessage(color, text)
    if text:find('%[Èíôîðìàöèÿ%]%s+%{%w+%}Âû óñïåøíî ïðîäàëè ëèöåíçèþ') then
        if checkbox1.v then
            if inprocess == false then
                lua_thread.create(function()
                    sampSendChat('/todo Óäà÷íîãî âàì äíÿ*óëûáíóâøèñü ïîñåòèòåëþ')
                    wait(500)
                    sampAddChatMessage(tag .. "Êëèåíò êóïèë ëèöåíçèþ, äåíüãè íà÷èñëåíû.", 0xFFFF00)
                end)
            else
                sampAddChatMessage(color_err .. "Âû ÷òîòî âûïîëíÿåòå, âûïîëíèòü ïîæåëàíèå íå óäàëîñü!", 0xFFFF00)
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
            if text:find("Èìÿ: "..sampGetPlayerNickname(playerID.v)) then
                if text:find("Ïîëíîñòüþ çäîðîâûé") then
                    lua_thread.create(function()
                        while inprocess do
                            wait(0)
                        end
                        inprocess = true
                        lictype.v = 5
                        sampSendChat("/me âçÿâ ìåä.êàðòó â ðóêè íà÷àë å¸ ïðîâåðÿòü")
                        wait(2000)
                        sampSendChat("/do Ìåä.êàðòà â íîðìå.")
                        wait(2000)
                        sampSendChat("/todo Âñ¸ â ïîðÿäêå* îòäàâàÿ ìåä.êàðòó îáðàòíî")
                        wait(2000)
                        sampSendChat('/me {gender:âçÿë|âçÿëà} ñî ñòîëà áëàíê è {gender:çàïîëíèë|çàïîëíèëà} ðó÷êîé áëàíê íà ïîëó÷åíèå ëèöåíçèè íà îðóæèå')
                        wait(2000)
                        sampSendChat('/do Ñïóñòÿ íåêîòîðîå âðåìÿ áëàíê íà ïîëó÷åíèå ëèöåíçèè áûë çàïîëíåí.')
                        wait(2000)
                        sampSendChat('/me ðàñïå÷àòàâ ëèöåíçèþ íà îðóæèå {gender:ïåðåäàë|ïåðåäàëà} å¸ ÷åëîâåêó íàïðîòèâ')
                        wait(1700)
                        sampSendChat('/givelicense ' .. playerID.v)
                        inprocess = false
                    end)
                else 
                    lua_thread.create(function()
                        inprocess = true
                        ASHelperMessage('×åëîâåê íå ïîëíîñòüþ çäîðîâûé, òðåáóåòñÿ ïîìåíÿòü ìåä.êàðòó!')
                        sampSendChat("/me âçÿâ ìåä.êàðòó â ðóêè íà÷àë å¸ ïðîâåðÿòü")
                        wait(2000)
                        sampSendChat("/do Ìåä.êàðòà íå â íîðìå.")
                        wait(2000)
                        sampSendChat("/todo Ê ñîæàëåíèþ, â ìåä.êàðòå íàïèñàíî, ÷òî ó âàñ åñòü îòêëîíåíèÿ.* îòäàâàÿ ìåä.êàðòó îáðàòíî")
                        wait(2000)
                        sampSendChat("Îáíîâèòå å¸ è ïðèõîäèòå ñíîâà!")
                        inprocess = false
                    end)
                end
                return false
            end
        end
    elseif dialogId == 235 and getmyrank then
        if text:find('Èíñòðóêòîðû') then
            for DialogLine in text:gmatch('[^\r\n]+') do
                local nameRankStats, getStatsRank = DialogLine:match('Äîëæíîñòü: {B83434}(.+)%p(%d+)%p')
                if tonumber(getStatsRank) then
                    local rangint = tonumber(getStatsRank)
                    local rang = nameRankStats
                    if rangint ~= configuration.main_settings.myrankint then
                        sampAddChatMessage(tag .. "Âàø ðàíã áûë îáíîâë¸í íà "..rang.." ("..rangint..")")
                    end
                    configuration.main_settings.myrank = rang
                    configuration.main_settings.myrankint = rangint
                    if nameRankStats:find('Óïðàëÿþùèé') or devmaxrankp then
                        getStatsRank = 10
                        configuration.main_settings.myrank = "Óïðàëÿþùèé"
                        configuration.main_settings.myrankint = 10
                    end
                    inicfg.save(configuration,"AS Helper")
                end
            end
        else
            sampAddChatMessage(color_err .. "Âû íå ðàáîòàåòå â àâòîøêîëå, ñêðèïò âûãðóæåí!")
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
