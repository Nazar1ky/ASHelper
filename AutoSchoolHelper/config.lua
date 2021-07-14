local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local key = require 'vkeys'

local _M = {}

_M.settings = {
    name = "Сергей Федович", 
    rank = "Мл. Инструктор",
    gender = 0, -- 0 - мужик 1 - женщина
    keyr = key.VK_X -- клавиша открытие меню вместо Х можно любую другую клавишу
}

return _M