-- Dialer, by Roy Curtis
-- Using original code by KJ4IPS @
-- files.haun.guru/ComputerCraft/

dofile('dialer.lib.lua')
dofile('dialer.events.lua')
dofile('dialer.paintutils.lua')

exiting   = false
debugging = true

state = {
  width  = 0,  -- Screen width
  height = 0,  -- Screen height
  entryX = 0,  -- Entry columns X
  entryY = 0,  -- Entry columns Y
  entryW = 24, -- Entry column width

  buttons  = {},
  selected = nil -- Selected book
}

pMonitor = nil
pChest   = nil

function Init()
  print('Dialer Server 0.1')

  pMonitor = requirePeripheral('monitor')
  pChest   = requirePeripheral('container_chest')
  debug('Discovered perhiperals')

  prepareUI()
  setPortal()

  Loop()
end

function Loop()
  print 'Running. Press END to terminate.'
  repeat
    -- Draw UI
    clearUI()
    updateButtons()
    drawBanner()
    drawButtons()

    -- Handle events
    event, p1, p2, p3, p4 = os.pullEvent()

    debug('Event: ', event)

    -- Events handled in dialer.events.lua
    if     event == 'key' then onKey(p1)
    elseif event == 'monitor_touch'
      then onTouch(p1, p2, p3)
    end

  until exiting
  Exit()
end

function Exit()
  destroyUI()
  print 'Goodbye.'
end

Init()