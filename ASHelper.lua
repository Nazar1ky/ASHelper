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
            sampAddChatMessage(tag .. "Библиотека imgui не найдена... Установим!", -1)
            DownloadFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/imgui.lua', 'moonloader/lib/imgui.lua')
            DownloadFile('https://raw.githubusercontent.com/Nazar1ky/ASHelper/main/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll')
            sampAddChatMessage(tag .. "Библиотека imgui была установлена! Перезапускаю...!", -1)
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
    arr_lic = {u8"Машина", u8"Мотоциклы", u8"Пилот", u8"Рыбалка", u8"Лодки", u8"Оружие", u8"Охота", u8"Раскопки", u8"Такси"}
    lictype = imgui.ImInt(0)
    arr_gender = {u8"Мужчина", u8"Женщина"}
    gendertype = imgui.ImInt(configuration.main_settings.gender)

    local ex, ey = getScreenResolution()
    function imgui.OnDrawFrame()
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if main_window_state.v then
            imgui.SetNextWindowSize(imgui.ImVec2(580, 250), imgui.Cond.FirstUseEver)
            imgui.Begin('AutoSchool helper', main_window_state)
            imgui.InputText(u8'ID Игрока для манипуляций', playerID)
            imgui.Checkbox(u8'При нацеливание playerID заполняеться айди в того кого целитесь', checkbox2)
            imgui.Checkbox(u8'PRICE LIST', isp_menu)
            imgui.Checkbox(u8'Продажа Лицензий', lic_menu)
            imgui.Checkbox(u8'Прочее', other_menu)
            imgui.Checkbox(u8'Настройки для работы', settings_menu)
            imgui.Checkbox(u8'Сбив анимки дубинки (ЧИТ)', anim_cheat)
            imgui.Text(u8'Версия скрипта: ' .. script_vers_text)
            imgui.Text(u8"Ваш ранг: "..u8(configuration.main_settings.myrank).." ("..configuration.main_settings.myrankint..")")
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
            imgui.SetNextWindowSize(imgui.ImVec2(430, 275), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || Продажа лицензий', nil, imgui.WindowFlags.NoCollapse)
            imgui.Text(u8'При продаже лицензии на оружие нужно проверить мед. карту!')
            if imgui.Button(u8'Представиться') then
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
                print(sampGetPlayerNickname(playerID.v))
            end
            if imgui.Button(u8'Пожелать хорошего дня') then
                if inprocess == false then
                    sampSendChat('/todo Удачного вам дня*улыбнувшись посетителю')
                else
                    sampAddChatMessage(tag .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
                end

            end
            imgui.Checkbox(u8'Писать при успешной покупки в чат пожелание', checkbox1)
            imgui.Checkbox(u8'Автосистема', checkbox3)
            if checkbox3.v then
                if imgui.Combo(u8'Выберите лицензию', lictype, arr_lic, 9) then
                    print(lictype.v)
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
        if settings_menu.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowSize(imgui.ImVec2(200, 100), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ex / 2 - 515, ey / 2 - 220), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'AutoSchool Helper || Настройки', nil, imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Кнопка открытия меню', openmenu)
            if imgui.Combo(u8'Выберите пол', gendertype, arr_gender, 2) then
            end
            if imgui.Button(u8'Сохранить') then
                configuration.main_settings.gender = gendertype.v
                configuration.main_settings.fastmenu = openmenu.v
                inicfg.save(configuration,"AS Helper")
            end
            if imgui.Button(u8'Перезагрузить скрипт') then
                thisScript():reload()
            end
            if imgui.Button(u8'Выгрузить скрипт') then
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
			sampAddChatMessage(tag .. "Создан файл конфигурации.")
		end
    end
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(tag .. "Есть обновление! Версия: " .. updateIni.info.vers_text .. ", Попытаюсь установить", 0xFFFF00)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    sampRegisterChatCommand("devmaxrank", function()
        if sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) == "Sergey_Fedovich" then
            devmaxrankp = not devmaxrankp
            sampAddChatMessage("{ff6633}[Режим разработчика] {FFFFFF}Имитировать максимальный ранг: " ..(devmaxrankp and "{00FF00}Включено" or "{FF0000}Выключено"), 0xff6633)
            getmyrank = true
            sampSendChat("/stats")
        else
            sampAddChatMessage("{ff6347}[Ошибка] {FFFFFF}Неизвестная команда! Введите /help для просмотра доступных функций.",0xff6347)
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
            if wasKeyPressed(vkeys.name_to_id(configuration.main_settings.fastmenu,true)) then
                if imguicheck then
                    main_window_state.v = not main_window_state.v
                else
                    sampAddChatMessage(tag .. "У вас не установлена библиотека imgui...")
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
            sampAddChatMessage(tag .. "Выполняю...", 0xFFFF00)
            sampSendChat('Приветствую, я "' .. configuration.main_settings.myrank .. '" данного лицензированного центра, чем могу вам помочь?')
            wait(1500)
            sampSendChat('/do На груди весит бейджик с надписью "' .. configuration.main_settings.myrank .. ' - '.. name .. '.')
            wait(500)
            sampAddChatMessage(tag .. "Выполнено!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
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
        sampAddChatMessage(color_err .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
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
            sampAddChatMessage(tag .. "Выполнено!", 0xFFFF00)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
    end
end
function licgive(id)
    if inprocess == false then
        lua_thread.create(function()
            inprocess = not inprocess
            sampAddChatMessage(tag .. "Выполняю...", 0xFFFF00)
            sampSendChat('Секунду...')
            wait(2000)
            sampSendChat('/me {gender:взял|взяла} со стола бланк и {gender:заполнил|заполнила} ручкой бланк на получение лицензии')
            wait(2000)
            sampSendChat('/do Спустя некоторое время бланк на получение лицензии был заполнен.')
            wait(2000)
            sampSendChat('/me распечатав лицензию и {gender:передал|передала} её человеку напротив')
            wait(1700)
            sampSendChat('/givelicense '.. playerID.v)
            inprocess = not inprocess
        end)
    else
        sampAddChatMessage(color_err .. "Вы уже чтото выполняете, подождите!", 0xFFFF00)
    end
end
function se.onServerMessage(color, text)
    if text:find('%[Информация%]%s+%{%w+%}Вы успешно продали лицензию') then
        if checkbox1.v then
            if inprocess == false then
                lua_thread.create(function()
                    sampSendChat('/todo Удачного вам дня*улыбнувшись посетителю')
                    wait(500)
                    sampAddChatMessage(tag .. "Клиент купил лицензию, деньги начислены.", 0xFFFF00)
                end)
            else
                sampAddChatMessage(color_err .. "Вы чтото выполняете, выполнить пожелание не удалось!", 0xFFFF00)
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
            if text:find("Имя: "..sampGetPlayerNickname(playerID.v)) then
                if text:find("Полностью здоровый") then
                    lua_thread.create(function()
                        while inprocess do
                            wait(0)
                        end
                        inprocess = true
                        lictype.v = 5
                        sampSendChat("/me взяв мед.карту в руки начал её проверять")
                        wait(2000)
                        sampSendChat("/do Мед.карта в норме.")
                        wait(2000)
                        sampSendChat("/todo Всё в порядке* отдавая мед.карту обратно")
                        wait(2000)
                        sampSendChat('/me {gender:взял|взяла} со стола бланк и {gender:заполнил|заполнила} ручкой бланк на получение лицензии на оружие')
                        wait(2000)
                        sampSendChat('/do Спустя некоторое время бланк на получение лицензии был заполнен.')
                        wait(2000)
                        sampSendChat('/me распечатав лицензию на оружие {gender:передал|передала} её человеку напротив')
                        wait(1700)
                        sampSendChat('/givelicense ' .. playerID.v)
                        inprocess = false
                    end)
                else 
                    lua_thread.create(function()
                        inprocess = true
                        ASHelperMessage('Человек не полностью здоровый, требуется поменять мед.карту!')
                        sampSendChat("/me взяв мед.карту в руки начал её проверять")
                        wait(2000)
                        sampSendChat("/do Мед.карта не в норме.")
                        wait(2000)
                        sampSendChat("/todo К сожалению, в мед.карте написано, что у вас есть отклонения.* отдавая мед.карту обратно")
                        wait(2000)
                        sampSendChat("Обновите её и приходите снова!")
                        inprocess = false
                    end)
                end
                return false
            end
        end
    elseif dialogId == 235 and getmyrank then
        if text:find('Инструкторы') then
            for DialogLine in text:gmatch('[^\r\n]+') do
                local nameRankStats, getStatsRank = DialogLine:match('Должность: {B83434}(.+)%p(%d+)%p')
                if tonumber(getStatsRank) then
                    local rangint = tonumber(getStatsRank)
                    local rang = nameRankStats
                    if rangint ~= configuration.main_settings.myrankint then
                        sampAddChatMessage(tag .. "Ваш ранг был обновлён на "..rang.." ("..rangint..")")
                    end
                    configuration.main_settings.myrank = rang
                    configuration.main_settings.myrankint = rangint
                    if nameRankStats:find('Упраляющий') or devmaxrankp then
                        getStatsRank = 10
                        configuration.main_settings.myrank = "Упраляющий"
                        configuration.main_settings.myrankint = 10
                    end
                    inicfg.save(configuration,"AS Helper")
                end
            end
        else
            sampAddChatMessage(color_err .. "Вы не работаете в автошколе, скрипт выгружен!")
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
