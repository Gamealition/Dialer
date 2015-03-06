-- Dialer, by Roy Curtis
-- Using original code by KJ4IPS @
-- files.haun.guru/ComputerCraft/

function debug(...)
  if not debugging then return end
  print('[Debug] ', unpack(arg) )
end

function debugTable(tbl)
  if not debugging then return end
  for key, value in pairs(tbl) do
    print(key, ': ', value)
  end
end

function discoverPeripherals()
  pMonitor = waitForPeripheral('monitor')
  pChest   = waitForPeripheral('iron')
  pMusic   = waitForPeripheral('music')
  debug('Discovered perhiperals')
end

function waitForPeripheral(type)
  unit = nil
  repeat
    unit = peripheral.find(type)

    if (unit == nil) then
      if (pMusic ~= nil) then
        pMusic.playSound('mob.bat.hurt', 1, 1)
      end
      print('Waiting for peripheral: ', type)
      sleep(2.5)
    end
  until unit ~= nil
  return unit
end

function prepareUI()
  pMonitor.setTextScale(state.scale)

  state.width,
  state.height = pMonitor.getSize()
  debug('UI prepared')
end

function clearUI()
  pMonitor.setBackgroundColor(colors.black)
  pMonitor.clear()
  debug('UI cleared')
end

function adjustScale(delta)
  state.scale = state.scale + delta
  if     state.scale > 5.0 then state.scale = 5
  elseif state.scale < 0.5 then state.scale = 0.5
  end
  prepareUI()
  print('Adjusted scale to ', state.scale)
end

function adjustColWidth(delta)
  state.entryW = state.entryW + delta
  if     state.entryW > 50 then state.entryW = 50
  elseif state.entryW < 1  then state.entryW = 1
  end
  print('Adjusted col. width to ', state.entryW)
end

function setPortal(book, slot)
  -- Structure of a link book:
  -- book.display_name
  -- book.myst_book.destination
  pChest.pullItem('UP', 1)
  state.selected = nil

  if (book == nil and slot == nil) then
    debug('Portal reset')
  else
    pMusic.playSound('portal.travel', 1, 1)
    pChest.pushItem('UP', slot)
    state.selected = book
    debug('Portal set to: ', book.display_name)
  end
end

function updateButtons()
  state.entryX,
  state.entryY  = 2, 5
  state.buttons = {}
  
  -- Have to sort book items using indicies than
  -- by table keys
  stacks = pChest.getAllStacks()
  books  = {}
  for slot, stack in pairs(stacks) do
    if (stack.name == "linkbook") then
      stack.name = getBookName(stack)
      stack.slot = slot
      table.insert(books, stack)
    end
  end

  table.sort(books, sortBook)
  for _, book in ipairs(books) do
    addButton(book)
  end
  debug('Updated buttons')
end

function getBookName(book)
  if (book.display_name == "Linking book") then
    return book.myst_book.destination
  else
    return book.display_name
  end
end

function sortBook(a, b)
  return a.name:lower()
       < b.name:lower()
end

function addButton(book)
  button   = {}

  button.x    = state.entryX
  button.y    = state.entryY
  button.name = book.name
  button.lbl  = ' '..book.name:sub(0, 20)..' '
  button.xEnd = state.entryX + state.entryW
  button.book = book
  button.slot = book.slot

  table.insert(state.buttons, button)
  nextEntryPos()
end

function blinkButton(button)
  for i = 0,3 do
    pMonitor.setCursorPos(button.x, button.y)

    if (i % 2 == 0) then
      pMonitor.setBackgroundColor(colors.gray)
    else
      pMonitor.setBackgroundColor(colors.blue)
    end

    pMonitor.write(button.lbl)
    sleep(0.1)
  end
end

function nextEntryPos()
  state.entryY = state.entryY + 2

  if (state.entryY >= state.height) then
    state.entryX = state.entryX + state.entryW
    state.entryY = 5
  end
end

function drawBanner(text)
  pMonitor.setCursorPos(1, 1)
  pMonitor.setBackgroundColor(colors.blue)
  pMonitor.setTextColor(colors.white)

  drawFilledBox(pMonitor, 1, 1, state.width, 3)
  pMonitor.setCursorPos(2, 2)

  if (text ~= nil) then
    pMonitor.write(text)
  elseif (state.selected ~= nil) then
    pMonitor.write('Destination: '
      .. state.selected.display_name)
  else
    pMonitor.write('Please select a destination')
  end
end

function drawButtons()
  for _, button in ipairs(state.buttons) do
    pMonitor.setBackgroundColor(colors.gray)

    -- Special cases
    if     (button.name == 'The End') then
      pMonitor.setTextColor(colors.lightBlue)
    elseif (button.name == 'The Nether') then
      pMonitor.setTextColor(colors.red)
    elseif (button.name == 'The Deep Dark') then
      pMonitor.setTextColor(colors.black)
    else
      pMonitor.setTextColor(colors.white)
    end

    pMonitor.setCursorPos(button.x, button.y)
    pMonitor.write(button.lbl)
  end  
end