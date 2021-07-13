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
local inprocess = false
local gender = 0

-- if not _ then
--         sampAddChatMessage("Библиотека imgui не найдена... Установим!", -1)
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
local arr_lic = {u8"Машина", u8"Мотоциклы", u8"Рыбалка", u8"Лодки", u8"Оружие", u8"Раскопки", u8"Такси"}
local selected_item = imgui.ImInt(0)

local ex, ey = getScreenResolution()
function imgui.OnDrawFrame()
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(580, 200), imgui.Cond.FirstUseEver)
        imgui.Begin('AutoSchool helper', main_window_state)
        imgui.InputText(u8'ID Игрока для манипуляций', playerID)
        imgui.Checkbox(u8'При нацеливание playerID заполняеться айди в того кого целитесь', checkbox2)
        imgui.Checkbox(u8'PRICE LIST', isp_menu)
        imgui.Checkbox(u8'Продажа Лицензий', lic_menu)
        imgui.Checkbox(u8'Прочее', other_menu)
        imgui.Checkbox(u8'Сбив анимки дубинки (ЧИТ)', anim_cheat)
        imgui.Text(u8(string.format('Текущая дата: %s', os.date())))
        imgui.End()
    end
    if isp_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(300, 170), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || PRICE LIST', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'PRICE LIST:\nНа авто: 10.000\nНа мото: 12.000\nНа рыбалку: 21.000\nВодный транспорт: 20.000\nОружие: 50.000(Требуеться Мед. карта\nОхота: 100.000\nНа распопки: 200.000\nНа полеты 20.000 (Сдавать в авиашколе)')
        imgui.End()
    end
    if lic_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(430, 230), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || Продажа лицензий', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'При продаже лицензии на оружие нужно проверить мед. карту!')
        if imgui.Button(u8'Приставиться') then
            privet()
        end
        if imgui.Button(u8'Лицензия на пилота') then
            pilot()
        end
        if imgui.Button(u8'Проверить мед. карту') then
                med(myid)
        end
        if imgui.Button(u8'Выдать лицензию') then
            if playerID.v == '' then
                sampAddChatMessage(tag .. "Вы не указали playerID !", 0xFFFF00)
            else 
                licgive(playerID.v)
            end
        end
        if imgui.Button(u8'Выдать лицензию (nonRP)') then
            sampSendChat('/givelicense '.. playerID.v)
        end
        if imgui.Button(u8'Пожелать хорошего дня') then
            if inprocess == false then
                sampSendChat('/todo Удачного вам дня*улыбнувшись посетителю')
            else
                sampAddChatMessage(tag .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
            end

        end
        imgui.Checkbox(u8'Писать при успешной покупки в чат пожелание', checkbox1)
        imgui.Checkbox(u8'Автолицензия (BETA)', checkbox3)
        if checkbox3.v then
            if imgui.Combo(u8'Выберите лицензию', selected_item, arr_lic, 2) then
                print(selected_item.v)
            end
        end
            imgui.End()
        end
    if other_menu.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(200, 320), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'AutoSchool Helper || Прочее', nil, imgui.WindowFlags.NoCollapse)
        imgui.Text(u8'По работе:')
        imgui.InputText(u8'Причина', playerExpel)
        if imgui.Button(u8'Выгнать из автошколы') then
            if  playerID.v == '' or playerExpel.v == '' then
                sampAddChatMessage(tag .. "Вы не указали причину либо playerID !", 0xFFFF00)
                print(1)
            else
                print(0)
                sampSendChat('/expel '.. playerID.v .. ' ' .. u8:decode(playerExpel.v))
            end
        end
        if imgui.Button(u8'Рабочее портфолио') then
            sampSendChat('/jobprogress')
        end
        if imgui.Button(u8'Список во фракции(online)') then
            sampSendChat('/members')
        end
        if imgui.Button(u8'Посмотреть время') then
            sampSendChat('/time')
        end
        imgui.Text(u8'Другое:')
        if imgui.Button(u8'Меню') then
            sampSendChat('/mm')
        end
        if imgui.Button(u8'Настройки') then
            sampSendChat('/settings')
        end
        if imgui.Button(u8'Помощь') then
            sampSendChat('/help')
        end
        if imgui.Button(u8'Навигатор') then
            sampSendChat('/gps')
        end
        if imgui.Button(u8'Инвентарь') then
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
                sampAddChatMessage(tag .. "Есть обновление! Версия: " .. updateIni.info.vers_text, 0xFFFF00)
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
                    sampAddChatMessage(tag .. "Скрипт успешно обновлен! Перезапускаю...")
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
            sampAddChatMessage(tag .. "Выполняю...", 0xFFFF00)
            sampSendChat('Приветствую, я "' .. config.settings.rank .. '" данного лицензированного центра, чем могу вам помочь?')
            wait(1500)
            sampSendChat('/do На груди весит бейджик с надписью "' .. config.settings.rank .. ' - '.. config.settings.name .. '.')
            wait(500)
            sampAddChatMessage(tag .. "Выполнено!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(tag .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
    end
end
function pilot()
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Выполняю...", 0xFFFF00)
            sampSendChat('Получить лицензию на полёты Вы можете в авиашколе г. Лас-Вентурас')
            wait(1500)
            sampSendChat('/n /gps -> Важные места -> Следующая страница -> [LV] Авиашкола (9)')
            wait(500)
            sampAddChatMessage(tag .. "Выполнено!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(tag .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
    end
end
function med(myid)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Выполняю...", 0xFFFF00)
            sampSendChat('Для получения лицензии на оружие покажите вашу мед.карту ')
            wait(1000)
            sampSendChat('/b /showmc ' .. myid)
            wait(500)
            sampAddChatMessage(tag .. "Выполнено! Убедитесь что в Мед. карте написано 'Полностью здоровый(ая)'", 0xFFFF00)
            inprocess = not inprocess
            wait(500)
            if checkbox3.v then
                selected_item.v = 4
                sampAddChatMessage(tag .. "Автолицензия выбрана: Оружие'", 0xFFFF00)
            end
        end)
    else
        sampAddChatMessage(tag .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
    end
end
function licgive(id)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Выполняю...", 0xFFFF00)
            sampSendChat('Секунду...')
            wait(1500)
            sampSendChat('/do На столе лежит печать и лицензия с бланком.')
            wait(1500)
            sampSendChat('/me берет со стола бланк и достает из кармана рубашки ручку')
            wait(1500)
            sampSendChat('/me заполняет бланк на получение лицензии')
            wait(1500)
            sampSendChat('/me начинает заполнять лицензию')
            wait(1500)
            sampSendChat('/do Лицензия заполнена.')
            wait(1500)
            sampSendChat('/me взял печать в руки и поставил оттеск с названием "ГЦЛ"')
            wait(1500)
            sampSendChat('/givelicense '.. id)
            wait(500)
            sampAddChatMessage(tag .. "Выполнено! Выберите нужную лицензию:", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(tag .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
    end
end
function se.onServerMessage(color, text)
    if text:find('%[Информация%]%s+%{%w+%}Вы успешно продали лицензию') then
        if checkbox1.v then
            lua_thread.create(function()
                sampSendChat('/todo Удачного вам дня*улыбнувшись посетителю')
                wait(500)
                sampAddChatMessage(tag .. "Клиент купил лицензию, деньги начислены.", 0xFFFF00)
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
--     if title:find("%Выберите лицензию") then
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