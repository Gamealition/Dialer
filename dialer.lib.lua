-- Dialer, by Roy Curtis
-- Using original code by KJ4IPS @
-- files.haun.guru/ComputerCraft/

function debug(...)
  if not debugging then return end
  print( unpack(arg) )
end

function debugTable(tbl)
  if not debugging then return end
  for key, value in pairs(tbl) do
    print(key, ': ', value)
  end
end

function requirePeripheral(type)
  return peripheral.find(type)
    or error('No ' .. type .. ' was found');
end

function prepareUI()
  clearUI()
  pMonitor.setTextScale(1.5)

  state.width,
  state.height = pMonitor.getSize()
  debug('UI prepared')
end

function clearUI()
  pMonitor.setBackgroundColor(colors.black)
  pMonitor.clear()
  debug('UI cleared')
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
    pChest.pushItem('UP', slot)
    state.selected = book
    debug('Portal set to: ', book.display_name)
  end
end

function updateButtons()
  state.entryX,
  state.entryY  = 2, 5
  state.buttons = {}
  
  stacks = pChest.getAllStacks()
  table.sort(stacks, sortBook)
  for slot, stack in pairs(stacks) do
    addButton(slot, stack)
  end
end

function sortBook(a, b)
  return a.display_name:lower()
       < b.display_name:lower()
end

function addButton(slot, book)
  if (book.name ~= "linkbook") then return end

  button   = {}
  bookName = book.display_name:sub(0, 20)

  button.x    = state.entryX
  button.y    = state.entryY
  button.name = ' '..bookName..' '
  button.xEnd = state.entryX + state.entryW
  button.book = book
  button.slot = slot

  table.insert(state.buttons, button)
  nextEntryPos()
end

function blinkButton(button)
  for i = 0,5 do
    pMonitor.setCursorPos(button.x, button.y)

    if (i % 2 == 0) then
      pMonitor.setBackgroundColor(colors.gray)
    else
      pMonitor.setBackgroundColor(colors.blue)
    end

    pMonitor.write(button.name)
    sleep(0.05)
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
  pMonitor.setBackgroundColor(colors.gray)

  for _, button in ipairs(state.buttons) do
    pMonitor.setCursorPos(button.x, button.y)
    pMonitor.write(button.name)
  end  
end