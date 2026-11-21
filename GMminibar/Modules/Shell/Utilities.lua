local A=AzerothAdminAC335
local W,N,UI,P=A.Workbench,A.NativeUI,A.UI,A.PlayerActions
local isAC=A.interface==30300
-- Scope is part of the command contract, not inferred from the card's label.
local actions={
 {id='repair',name='Ремонт предметов',icon='Trade_BlackSmithing',group='Персонаж',scope='named',command=isAC and '.gear repair'or '.repairitems'},
 {id='cooldown',name='Сброс перезарядки',icon='Spell_Nature_TimeStop',group='Персонаж',scope='selected',command='.cooldown'},
 {id='combat',name='Остановить бой',icon='Ability_Rogue_Feint',group='Персонаж',scope='named',command='.combatstop'},
 {id='unstuck',name='Выбраться из застревания',icon='INV_Misc_Rune_01',group='Персонаж',scope=isAC and 'named'or 'self',command='.unstuck',suffix=isAC and ' inn'or nil,note=not isAC and 'В этом ядре команда выхода применяется только к вам.'or nil},
 {id='dismount',name='Спешиться',icon='Ability_Mount_RidingHorse',group='Персонаж',scope='self',command='.dismount'},
 {id='demorph',name='Сбросить облик',icon='Spell_Shadow_Twilight',group='Персонаж',scope='selected',command=isAC and '.morph reset'or '.demorph'},
 {id='waterwalk',name='Ходьба по воде ВКЛ/ВЫКЛ',icon='Spell_Frost_WindWalkOn',group='Перемещение',scope='self',command='.cheat waterwalk',toggle=true},
 {id='save',name='Сохранить персонажа',icon='INV_Misc_Book_09',group='Персонаж',scope='self',command='.save'},
 {id='level1',name='Повысить уровень на 1',icon='Spell_Holy_InnerFire',group='Развитие',scope='named',command='.levelup',suffix=' 1'},
 {id='leveldown1',name='Понизить уровень на 1',icon='Spell_Shadow_EnslaveDemon',group='Развитие',scope='named',command='.levelup',suffix=' -1'},
 {id='level10',name='Повысить уровень на 10',icon='Spell_Holy_InnerFire',group='Развитие',scope='named',command='.levelup',suffix=' 10'},
 {id='leveldown10',name='Понизить уровень на 10',icon='Spell_Shadow_EnslaveDemon',group='Развитие',scope='named',command='.levelup',suffix=' -10'},
 {id='explore',name='Открыть карту',icon='INV_Misc_Map_01',group='Перемещение',scope=isAC and 'selected'or 'self',command='.cheat explore 1'},
 {id='taxi',name='Ограничение полётов ВКЛ/ВЫКЛ',icon='Ability_Mount_Gryphon_01',group='Перемещение',scope='selected',command='.cheat taxi',toggle=true},
 {id='money',name='Добавить 1000 золота',icon='INV_Misc_Coin_01',group='Персонаж',scope='selected',command='.modify money 10000000'},
 {id='raid10',name='Рейд 10, обычный',icon='Achievement_Dungeon_UlduarRaid_Misc_03',group='Подземелья',scope='client',difficulty=isAC and 1 or 3},
 {id='raid25',name='Рейд 25, обычный',icon='Achievement_Dungeon_UlduarRaid_Misc_03',group='Подземелья',scope='client',difficulty=isAC and 2 or 4},
 {id='raid10h',name='Рейд 10, героический',icon='Achievement_Dungeon_UlduarRaid_Misc_03',group='Подземелья',scope='client',difficulty=isAC and 3 or 5},
 {id='raid25h',name='Рейд 25, героический',icon='Achievement_Dungeon_UlduarRaid_Misc_03',group='Подземелья',scope='client',difficulty=isAC and 4 or 6},
 {id='access',name='Снять требования входа',icon='INV_Misc_Key_14',group='Подземелья',scope='self',command='.gm on',note='Проходит проверку условий входа в режиме GM. Не сбрасывает привязку к подземелью.'},
 {id='gmspells',name='Изучить GM-заклинания',icon='INV_Misc_Gear_01',group='Развитие',scope='self',command='.learn all gm'},
 {id='crafts',name='Изучить все профессии и рецепты',icon='Trade_Engineering',group='Развитие',scope='selected',selfOnly=isAC,batch='crafts',command='.learn all crafts',note='Изучает уровни профессий, включая собирательство и рыбалку, все рецепты и ставит максимальный навык.'},
 {id='cooking',name='Изучить все рецепты кулинарии',icon='INV_Misc_Food_15',group='Развитие',scope='selected',recipeSkill=185,note='Изучает уровни кулинарии и рецепты, ставит максимальный навык.'},
 {id='recipes',name='Все рецепты по профессии',icon='INV_Misc_Book_08',group='Развитие',scope='recipes'},
 {id='class',name='Изучить навыки своего класса',icon='Spell_Holy_MagicalSentry',group='Развитие',scope='self',command=isAC and '.learn all my trainer'or '.learn all my spells'},
 {id='talents',name=isAC and 'Изучить все таланты класса'or 'Изучить все заклинания талантов класса',icon='Ability_Marksmanship',group='Развитие',scope=isAC and 'self'or 'selected',selfOnly=true,batch=not isAC and 'talents'or nil,command=isAC and '.learn all my talents'or nil,note=not isAC and 'Изучает только заклинания талантов вашего класса. Не меняет выбранный набор в окне талантов.'or nil},
 {id='maxskill',name='Максимум навыков и умений',icon='Trade_BlackSmithing',group='Развитие',scope='selected',command='.maxskill'},
 {id='summon',name='Вызвать цель',icon='Spell_Shadow_Twilight',group='Перемещение',scope='peer',command='.summon'},
 {id='appear',name='Переместиться к цели',icon='Spell_Arcane_TeleportStormWind',group='Перемещение',scope='peer',command='.appear'},
 {id='respawn',name='Возродить выбранное существо',icon='Spell_Holy_Resurrection',group='Подземелья',scope='creature',command='.respawn',note='Возрождает только одно выбранное мёртвое существо.'},
}
for i,name in ipairs({'Классика','The Burning Crusade','Wrath of the Lich King','Cataclysm','Mists of Pandaria'})do
 if i<=(isAC and 3 or 5)then actions[#actions+1]={id='expansion'..i,name='Дополнение аккаунта · '..name,icon='INV_Misc_Book_09',group='Аккаунт',scope='self',security=3,command='.account addon '..(i-1),note='Меняет уровень дополнений аккаунта. Влияет и на других персонажей этого аккаунта.'}end
end
A.UtilityActions=actions
local groups={'Все','Персонаж','Развитие','Перемещение','Подземелья','Аккаунт'}
local recipes={{'Кузнечное дело',164},{'Кожевничество',165},{'Алхимия',171},{'Портняжное дело',197},{'Инженерное дело',202},{'Наложение чар',333},{'Ювелирное дело',755},{'Начертание',773},{'Кулинария',185},{'Первая помощь',129},{'Горное дело',186}}
local function selfName()return UnitName('player')end
local function targetName()return UnitIsPlayer and UnitIsPlayer('target')and UnitName('target')or nil end
local function status(text)if W.utilityStatus then W.utilityStatus:SetText(text)end end
function W:UtilityNamePrompt(spec)
 if not self.utilityPrompt then
  local f=CreateFrame('Frame',A.WorkbenchAdapter.namespace..'UtilityTarget',UIParent);self.utilityPrompt=f
  f:SetSize(340,188);f:SetPoint('CENTER');f:SetFrameStrata('FULLSCREEN_DIALOG');f:EnableMouse(true);N:Panel(f);f:Hide()
  f.title=N:Text(f,'',302);f.title:SetPoint('TOPLEFT',f,'TOPLEFT',18,-18)
  f.info=N:Text(f,'Введите имя персонажа.',300,true);f.info:SetPoint('TOPLEFT',f,'TOPLEFT',18,-48);f.info:SetHeight(34)
  f.name=N:Edit(f,300);f.name:SetPoint('TOPLEFT',f,'TOPLEFT',18,-87)
  f.apply=N:Button(f,'Применить',130,26);f.apply:SetPoint('BOTTOMLEFT',f,'BOTTOMLEFT',18,18)
  local cancel=N:Button(f,'Отмена',130,26,function()f:Hide()end);cancel:SetPoint('BOTTOMRIGHT',f,'BOTTOMRIGHT',-18,18)
  local click=function()
   local name=A:Trim(f.name:GetText());if not P:ValidName(name)then f.info:SetText('Введите корректное имя персонажа.');return end
   if f.spec.scope=='selected'and (not targetName()or targetName()~=name)then f.info:SetText('Для этой команды выберите находящегося рядом игрока.');return end
   f:Hide();W:ExecuteUtility(f.spec,name)
  end
  P:Attach(f.apply,click,{prepare=function(b)
   local name=A:Trim(f.name:GetText())
   b:SetAttribute('*type1',f.spec and f.spec.scope=='selected'and 'macro'or nil)
   b:SetAttribute('*unit1',nil)
   b:SetAttribute('*macrotext1',P:ValidName(name)and '/targetexact '..name or '')
 end,leftOnly=true})
  -- Named commands, including combatstop, remain usable during combat.
  f.apply:SetScript('OnClick',function()if f.spec.scope~='selected'then click()else A:Print('Можно использовать после окончания боя.',true)end end)
  UISpecialFrames[#UISpecialFrames+1]=f:GetName()
 end
 local f=self.utilityPrompt;f.spec=spec;f.title:SetText(spec.name);f.info:SetText(spec.scope=='selected'and 'Имя персонажа · выберите находящегося рядом игрока и примените.'or 'Введите имя персонажа.')
 f.name:SetText('');f:Show();f.name:SetFocus();P:Refresh()
end
function W:RecipeChoices(mouse)
 if not self.recipeChoices then
  local f=CreateFrame('Frame',nil,UIParent);self.recipeChoices=f;f:SetSize(380,410);f:SetPoint('CENTER');f:SetFrameStrata('FULLSCREEN_DIALOG');N:Panel(f);f:EnableMouse(true);f:Hide()
  local title=N:Text(f,'Все рецепты · выбор профессии',330);title:SetPoint('TOPLEFT',f,'TOPLEFT',18,-18)
  for i,r in ipairs(recipes)do
   local item=r;local b=N:Choice(f,item[1],344,27,'Interface\\Icons\\INV_Misc_Book_08',function()
     f:Hide();local spec={id='recipe_'..i,name=item[1]..' · все рецепты',scope='selected',recipeSkill=item[2]}
    if f.other then local name=targetName();if name then W:ExecuteUtility(spec,name)else W:UtilityNamePrompt(spec)end else W:ExecuteUtility(spec,selfName())end
   end);b:SetPoint('TOPLEFT',f,'TOPLEFT',18,-48-(i-1)*29)
   P:Attach(b,b:GetScript('OnClick'),{prepare=function(overlay)overlay:SetAttribute('*unit1',f.other and 'target'or 'player')end})
  end
  local close=N:Button(f,'Закрыть',100,25,function()f:Hide()end);close:SetPoint('BOTTOM',f,'BOTTOM',0,12)
 end
 self.recipeChoices.other=mouse=='RightButton';self.recipeChoices:Show();P:Refresh()
end
local function recipeCommand(skill)
 local names=A.ProfessionCommandNames or {};local locale=GetLocale()
 local name=names[locale]and names[locale][skill]or names.enUS and names.enUS[skill]
 return name and '.learn all recipes '..name or nil
end
function W:RunUtilityBatch(spec,name)
 if self.utilityBatch then status('Дождитесь завершения текущего запроса обучения.');return false end
 local commands={};local own=name==selfName();local skills={};local expected={}
 if spec.batch=='talents'then
  local _,class,id=UnitClass('player')
  if not id then local classes={WARRIOR=1,PALADIN=2,HUNTER=3,ROGUE=4,PRIEST=5,DEATHKNIGHT=6,SHAMAN=7,MAGE=8,WARLOCK=9,MONK=10,DRUID=11};id=classes[class]end
  for _,spell in ipairs(A.ClassTalentSpells and A.ClassTalentSpells[id]or {})do
   expected[#expected+1]=spell
   if not P:Known(spell,true)then commands[#commands+1]='.learn '..spell end
  end
 else
  if spec.recipeSkill then skills[1]=spec.recipeSkill
  else for skill in pairs(A.UtilityProfessionTiers or {})do skills[#skills+1]=skill end;table.sort(skills)end
  for _,skill in ipairs(skills)do
   local tiers=A.UtilityProfessionTiers[skill]or{}
   for _,tier in ipairs(tiers)do
    if not own or not P:Known(tier.spell,true)then commands[#commands+1]='.learn '..tier.spell end
   end
   local highest=tiers[#tiers]
   if highest then commands[#commands+1]='.setskill '..skill..' '..highest.maximum..' '..highest.maximum end
  end
  local final=spec.recipeSkill and recipeCommand(spec.recipeSkill)or spec.command
  if not final then status('Не удалось определить серверное название этой профессии.');return false end
  commands[#commands+1]=final
 end
 if #commands==0 then status('Заклинание уже изучено.');return false end
 local job={name=name,commands=commands,index=0};self.utilityBatch=job
 local function step()
  if W.utilityBatch~=job then return end
  if InCombatLockdown()or targetName()~=job.name then W.utilityBatch=nil;status('Цель или боевое состояние изменились — оставшиеся запросы обучения отменены.');return end
  job.index=job.index+1
  if job.index>#job.commands then
   W.utilityBatch=nil
   if own then P:Track('utilityTraining',function()
    if spec.batch=='talents'then for _,id in ipairs(expected)do if not P:Known(id,true)then return false end end
    else for _,skill in ipairs(skills)do local t=A.UtilityProfessionTiers[skill];local state=A:GetPlayerProfessionState(skill,true);if state.current<t[#t].maximum then return false end end end
    return true
   end,W.utilityStatus)else status('Все запросы отправлены. Проверьте статус обучения и сообщения сервера.')end
   return
  end
  if not A:SendCommand(job.commands[job.index])then W.utilityBatch=nil;status('Отправка не удалась — оставшиеся запросы отменены.');return end
  status(spec.name..' · '..job.index..' / '..#job.commands)
  A:RunAfter(.2,step)
 end
 step();return true
end
function W:ExecuteUtility(spec,name)
 if A:GetAccountSecurity()<(spec.security or 2)then status('Недостаточно прав GM.');return false end
 if spec.scope=='selected'then
  if not targetName()or targetName()~=name then status('Не выбран игрок для применения.');return false end
 end
 if spec.selfOnly and name~=selfName()then status('Эта функция действует только на вас.');return false end
 if spec.batch or spec.recipeSkill then return self:RunUtilityBatch(spec,name)end
 local command=spec.command
 if spec.scope=='named'or spec.scope=='peer'then
  if not P:ValidName(name)then return false end
  command=command..' '..name..(spec.suffix or '')
 end
 if spec.toggle then
  self.utilityToggle=self.utilityToggle or {};local key=spec.id..':'..(name or selfName())
  local state=self.utilityToggle[key];local enable=state~=true
  if self.pendingUtility and self.pendingUtility.expires>GetTime()then status('Ожидается ответ сервера на предыдущий запрос.');return false end
  command=command..(enable and ' on'or ' off')
  self.pendingUtility={spec=spec,key=key,enable=enable,expires=GetTime()+6}
   A:RunAfter(6,function()if W.pendingUtility and W.pendingUtility.key==key then W.pendingUtility=nil;W.utilityToggle[key]=nil;status('Не удалось проверить состояние сервера. Повторное нажатие снова запросит ВКЛ.');W:RefreshUtilities()end end)
 end
 if spec.scope=='client'then
  local setter=isAC and SetRaidDifficulty or SetRaidDifficultyID
  if not setter then status('Этот клиент не поддерживает смену такой сложности.');return false end
  local ok=pcall(setter,spec.difficulty)
  if not ok then status('Не удалось сменить сложность.');return false end
  local getter=isAC and GetRaidDifficulty or GetRaidDifficultyID
  if getter then P:Track('raidDifficulty',function()return getter()==spec.difficulty end,self.utilityStatus)end
  return true
 end
 local ok=A:SendCommand(command)
 status(ok and (spec.name..' · '..(name or selfName()or '')..' · ожидание ответа сервера')or 'Не удалось отправить запрос.')
 if not ok then self.pendingUtility=nil end
 return ok
end
function W:RunUtility(spec,button,mouse)
 mouse=mouse or 'LeftButton'
 if spec.scope=='recipes'then return self:RecipeChoices(mouse)end
 if spec.scope=='creature'then
  if not UnitExists('target')or UnitIsPlayer('target')or not UnitIsDead('target')or (UnitIsUnit and UnitIsUnit('target','pet'))then status('Выберите мёртвое существо для возрождения.');return false end
  return self:ExecuteUtility(spec)
 end
 if spec.scope=='peer'then local name=targetName();if not name or name==selfName()then return self:UtilityNamePrompt(spec)end;return self:ExecuteUtility(spec,name)end
 if mouse=='RightButton'then
   if spec.selfOnly or spec.scope=='self'or spec.scope=='client'then status('Эта функция действует только на вас.');return false end
  local name=targetName();if not name then return self:UtilityNamePrompt(spec)end
  return self:ExecuteUtility(spec,name)
 end
 return self:ExecuteUtility(spec,selfName())
end
function W:RefreshUtilities()
 local f=self.utilityPanel;if not f then return end
 local filtered={};for _,spec in ipairs(actions)do if not f.group or f.group=='Все'or spec.group==f.group then filtered[#filtered+1]=spec end end
 local pages=math.max(1,math.ceil(#filtered/18));f.page=math.max(1,math.min(f.page or 1,pages))
 for i,b in ipairs(f.buttons)do
  local spec=filtered[(f.page-1)*18+i];b.spec=spec
  if spec then
   local state=spec.toggle and self.utilityToggle and self.utilityToggle[spec.id..':'..(selfName()or '')]
   b:SetText(spec.name..(state~=nil and (state and '  |cff55bbffON|r'or '  |cffaaaaaaOFF|r')or ''))
   b.icon:SetTexture('Interface\\Icons\\'..spec.icon)
    local hint=(spec.selfOnly or spec.scope=='self'or spec.scope=='client')and 'Только для себя'or 'ЛКМ: на себя · ПКМ: выбранный игрок / ввод имени'
   if spec.scope=='peer'then hint='Применяется к выбранному игроку · если не выбран, введите имя' end
   N:Hint(b,spec.name,(spec.note and spec.note..'\n'or '')..hint)
   UI:SetEnabled(b,A:GetAccountSecurity()>=(spec.security or 2));b:Show()
  else b:Hide()end
 end
 f.pageText:SetText(#filtered..' шт. · '..f.page..' / '..pages)
 UI:SetEnabled(f.prev,f.page>1);UI:SetEnabled(f.next,f.page<pages);P:Refresh()
end
function W:CreateUtilityPanel()
 if self.utilityPanel then return end
 local f=CreateFrame('Frame',A.WorkbenchAdapter.namespace..'Utilities',UIParent);self.utilityPanel=f
 f:SetSize(1080,700);f:SetFrameStrata('DIALOG');f:EnableMouse(true);N:Panel(f);f:Hide()
 local title=N:Text(f,A:L('UX_UTILITIES'),970);title:SetPoint('TOPLEFT',f,'TOPLEFT',18,-17)
 local close=CreateFrame('Button',nil,f,'UIPanelCloseButton');close:SetPoint('TOPRIGHT',f,'TOPRIGHT',-3,-3);close:SetScript('OnClick',function()W:Close()end)
 for i,group in ipairs(groups)do local value=group;local b=N:Button(f,value,120,25,function()f.group=value;f.page=1;W:RefreshUtilities()end);b:SetPoint('TOPLEFT',f,'TOPLEFT',18+(i-1)*128,-48)end
 f.buttons={}
 for i=1,18 do
  local b=N:Choice(f,'',513,48,'Interface\\Icons\\INV_Misc_Book_09');f.buttons[i]=b
  b:SetPoint('TOPLEFT',f,'TOPLEFT',18+(i-1)%2*530,-88-math.floor((i-1)/2)*55)
  b:RegisterForClicks('LeftButtonUp','RightButtonUp')
  local click=function(button,mouse)if button.spec then W:RunUtility(button.spec,button,mouse)end end
  local secure=P:Attach(b,click,{rightTarget=true,prepare=function(overlay,source)
   local needs=source.spec and source.spec.scope=='selected'
   overlay:SetAttribute('*type1',needs and 'target'or nil)
   overlay:SetAttribute('*unit1',needs and 'player'or nil)
  end})
  b:SetScript('OnClick',function(button,mouse)
   if not button.spec then return end
   if button.spec.scope=='selected'then status('Можно использовать после окончания боя.');return end
   click(button,mouse)
  end)
 end
 f.prev=N:Button(f,'Назад',90,25,function()f.page=f.page-1;W:RefreshUtilities()end);f.prev:SetPoint('BOTTOMLEFT',f,'BOTTOMLEFT',18,75)
 f.next=N:Button(f,'Далее',90,25,function()f.page=f.page+1;W:RefreshUtilities()end);f.next:SetPoint('BOTTOMRIGHT',f,'BOTTOMRIGHT',-18,75)
 f.pageText=N:Text(f,'',400,true);f.pageText:SetPoint('BOTTOM',f,'BOTTOM',0,81);f.pageText:SetJustifyH('CENTER')
 self.utilityStatus=N:Text(f,'ЛКМ: на себя · ПКМ: другой игрок',1030,true);self.utilityStatus:SetPoint('BOTTOMLEFT',f,'BOTTOMLEFT',18,20);self.utilityStatus:SetHeight(40)
 f:SetScript('OnDragStart',function()if not W:DB().windowLocked then f:StartMoving()end end)
 f:SetScript('OnDragStop',function()f:StopMovingOrSizing();W:SaveWindowPosition(f);W:AnchorDock();P:Refresh()end)
 self:Watch(f,'favorites');self:RefreshUtilities()
end
local messages=CreateFrame('Frame');messages:RegisterEvent('CHAT_MSG_SYSTEM')
messages:SetScript('OnEvent',function(_,_,message)
 if W.utilityPanel and W.utilityPanel:IsShown()then status(message)end
 local pending=W.pendingUtility;if not pending then return end
 local lower=message:lower();local state
 if pending.spec.id=='waterwalk'and (lower:find('waterwalk',1,true)or lower:find('수면',1,true))then
  if lower:find(' off',1,true)then state=false elseif lower:find(' on',1,true)then state=true end
 elseif pending.spec.id=='taxi'and (lower:find('taxi',1,true)or lower:find('비행',1,true))then
  if lower:find('remove',1,true)or lower:find('제거',1,true)then state=false
  elseif lower:find('given',1,true)or lower:find('give',1,true)or lower:find('추가',1,true)then state=true end
 end
 if state~=nil then W.utilityToggle[pending.key]=state;W.pendingUtility=nil;W:RefreshUtilities()end
end)
