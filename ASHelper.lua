require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local se = require 'samp.events'
local config = require "config"
local res_imgui, imgui = pcall(require, 'imgui')
local key = require 'vkeys'
local encoding = require 'encoding'
local inicfg = require 'inicfg'

update_state = false
local script_vers = 3
local script_vers_text = "1.1"

local update_url = "https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/Nazar1ky/ASHelper/raw/main/ASHelper.lua"
local script_path = thisScript().path

encoding.default = 'CP1251'
u8 = encoding.UTF8
local tag = "{62E200}[ASHelper]: {FFFFFF}"
local inprocess = false
local gender = 0

-- if not _ then
--         sampAddChatMessage("Áèáëèîòåêà imgui íå íàéäåíà... Óñòàíîâèì!", -1)
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
local isp_menu = imgui.ImBool(false)
local lic_menu = imgui.ImBool(false)
local other_menu = imgui.ImBool(false)
local anim_cheat = imgui.ImBool(false)
local arr_lic = {u8"Ìàøèíà", u8"Ìîòîöèêëû", u8"Ðûáàëêà", u8"Ëîäêè", u8"Îðóæèå", u8"Ðàñêîïêè", u8"Òàêñè"}
local selected_item = imgui.ImInt(0)

local ex, ey = getScreenResolution()
function imgui.OnDrawFrame()
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(580, 200), imgui.Cond.FirstUseEver)
        imgui.Begin('AutoSchool helper', main_window_state)
        imgui.InputText(u8'ID Èãðîêà äëÿ ìàíèïóëÿöèé', playerID)
        imgui.Checkbox(u8'Ïðè íàöåëèâàíèå playerID çàïîëíÿåòüñÿ àéäè â òîãî êîãî öåëèòåñü', checkbox2)
        imgui.Checkbox(u8'PRICE LIST', isp_menu)
        imgui.Checkbox(u8'Ïðîäàæà Ëèöåíçèé', lic_menu)
        imgui.Checkbox(u8'Ïðî÷åå', other_menu)
        imgui.Checkbox(u8'Ñáèâ àíèìêè äóáèíêè (×ÈÒ)', anim_cheat)
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
        imgui.SetNextWindowSize(imgui.ImVec2(430, 230), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || Ïðîäàæà ëèöåíçèé', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'Ïðè ïðîäàæå ëèöåíçèè íà îðóæèå íóæíî ïðîâåðèòü ìåä. êàðòó!')
        if imgui.Button(u8'Ïðèñòàâèòüñÿ') then
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
        end
        if imgui.Button(u8'Ïîæåëàòü õîðîøåãî äíÿ') then
            if inprocess == false then
                sampSendChat('/todo Óäà÷íîãî âàì äíÿ*óëûáíóâøèñü ïîñåòèòåëþ')
            else
                sampAddChatMessage(tag .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
            end

        end
        imgui.Checkbox(u8'Ïèñàòü ïðè óñïåøíîé ïîêóïêè â ÷àò ïîæåëàíèå', checkbox1)
        imgui.Checkbox(u8'Àâòîëèöåíçèÿ (BETA)', checkbox3)
        if checkbox3.v then
            if imgui.Combo(u8'Âûáåðèòå ëèöåíçèþ', selected_item, arr_lic, 2) then
                print(selected_item.v)
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
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(tag .. "Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateIni.info.vers_text, 0xFFFF00)
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
                    sampAddChatMessage(tag .. "Ñêðèïò óñïåøíî îáíîâëåí! Ïåðåçàïóñêàþ...")
                    thisScript():reload()
                end
            end)
            break
        end
            if wasKeyPressed(key.VK_X) then
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
    end
end
function privet()
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Âûïîëíÿþ...", 0xFFFF00)
            sampSendChat('Ïðèâåòñòâóþ, ÿ "' .. config.settings.rank .. '" äàííîãî ëèöåíçèðîâàííîãî öåíòðà, ÷åì ìîãó âàì ïîìî÷ü?')
            wait(1500)
            sampSendChat('/do Íà ãðóäè âåñèò áåéäæèê ñ íàäïèñüþ "' .. config.settings.rank .. ' - '.. config.settings.name .. '.')
            wait(500)
            sampAddChatMessage(tag .. "Âûïîëíåíî!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(tag .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
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
        sampAddChatMessage(tag .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
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
            sampAddChatMessage(tag .. "Âûïîëíåíî! Óáåäèòåñü ÷òî â Ìåä. êàðòå íàïèñàíî 'Ïîëíîñòüþ çäîðîâûé(àÿ)'", 0xFFFF00)
            inprocess = not inprocess
            wait(500)
            if checkbox3.v then
                selected_item.v = 4
                sampAddChatMessage(tag .. "Àâòîëèöåíçèÿ âûáðàíà: Îðóæèå'", 0xFFFF00)
            end
        end)
    else
        sampAddChatMessage(tag .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
    end
end
function licgive(id)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Âûïîëíÿþ...", 0xFFFF00)
            sampSendChat('Ñåêóíäó...')
            wait(1500)
            sampSendChat('/do Íà ñòîëå ëåæèò ïå÷àòü è ëèöåíçèÿ ñ áëàíêîì.')
            wait(1500)
            sampSendChat('/me áåðåò ñî ñòîëà áëàíê è äîñòàåò èç êàðìàíà ðóáàøêè ðó÷êó')
            wait(1500)
            sampSendChat('/me çàïîëíÿåò áëàíê íà ïîëó÷åíèå ëèöåíçèè')
            wait(1500)
            sampSendChat('/me íà÷èíàåò çàïîëíÿòü ëèöåíçèþ')
            wait(1500)
            sampSendChat('/do Ëèöåíçèÿ çàïîëíåíà.')
            wait(1500)
            sampSendChat('/me âçÿë ïå÷àòü â ðóêè è ïîñòàâèë îòòåñê ñ íàçâàíèåì "ÃÖË"')
            wait(1500)
            sampSendChat('/givelicense '.. id)
            wait(500)
            sampAddChatMessage(tag .. "Âûïîëíåíî! Âûáåðèòå íóæíóþ ëèöåíçèþ:", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(tag .. "Âû óæå ÷òîòî âûïîëíÿåòå, ïîäîæäèòå!", 0xFFFF00)
    end
end
function se.onServerMessage(color, text)
    if text:find('%[Èíôîðìàöèÿ%]%s+%{%w+%}Âû óñïåøíî ïðîäàëè ëèöåíçèþ') then
        if checkbox1.v then
            lua_thread.create(function()
                sampSendChat('/todo Óäà÷íîãî âàì äíÿ*óëûáíóâøèñü ïîñåòèòåëþ')
                wait(500)
                sampAddChatMessage(tag .. "Êëèåíò êóïèë ëèöåíçèþ, äåíüãè íà÷èñëåíû.", 0xFFFF00)
            end)
        end
    end
end
-- function se.onShowDialog(dialogId, style, title, button1, button2, text)
--     if dialogId == 6 then
--         sampSendDialogResponse(6, 1, 0, nil)
--     end
-- end
-- function se.onShowDialog(dialogId, style, title, button1, button2, text)
--     if title:find("%Âûáåðèòå ëèöåíçèþ") then
--         if dialogId == 6 then
--             lua_thread.create(function()
--                 wait(500)
--                 sampSendDialogResponse(sampGetCurrentDialogId(), 1, 4, _)
--             end)
--             return false
--         end
--     end
-- end
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
