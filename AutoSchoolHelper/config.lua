local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local key = require 'vkeys'

local _M = {}

_M.settings = {
    name = "������ �������", 
    rank = "��. ����������",
    gender = 0, -- 0 - ����� 1 - �������
    keyr = key.VK_X -- ������� �������� ���� ������ � ����� ����� ������ �������
}

return _M