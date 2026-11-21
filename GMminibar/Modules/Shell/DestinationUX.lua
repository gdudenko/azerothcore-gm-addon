local A=AzerothAdminAC335
local create=A.CreateTeleportWindow
function A:CreateTeleportWindow()
 create(self)
 local f=self.teleportFrame
 if f.unresolvedInfo then return end
 local missing=self.UnresolvedBattlegrounds or {}
 local names={};for _,row in ipairs(missing)do names[#names+1]=row.name end
 local explanation='Поля боя, исключённые из списка перемещения (нет данных о внешнем входе):\n'..table.concat(names,'\n')
 local b=self.NativeUI:Button(f,self:L('DEST156_MISSING',#missing),140,23,function()A:Print(explanation)end)
 b:SetPoint('BOTTOMRIGHT',f,'BOTTOMRIGHT',-119,20);f.unresolvedInfo=b
 self.NativeUI:Hint(b,'Нужна проверка входа на поле боя',explanation)
end
