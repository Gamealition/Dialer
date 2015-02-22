-- Dialer, by Roy Curtis
-- Using original code by KJ4IPS @
-- files.haun.guru/ComputerCraft/

dofile('dialer.lib.lua')
dofile('dialer.events.lua')
dofile('dialer.paintutils.lua')

exiting   = false
debugging = false

state = {
  width  = 0,  -- Screen width
  height = 0,  -- Screen height
  scale  = 1.0,
  entryX = 0,  -- Entry columns X
  entryY = 0,  -- Entry columns Y
  entryW = 18, -- Entry column width

  buttons  = {},
  selected = nil -- Selected book
}

pMonitor = nil
pChest   = nil
pMusic   = nil

function Init()
  print('Dialer Server 0.21')

  redstone.setOutput('bottom', true)
  discoverPeripherals()
  prepareUI()
  setPortal()

  Loop()
end

function Loop()
  print 'Running. Press HOME for help.'
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
    elseif event == 'monitor_resize'
      then onResize(p1)
    elseif event == 'peripheral'
      then onPeripheral(p1)
    elseif event == 'peripheral_detach'
      then onPeripheral(p1)
    end

  until exiting
  Exit()
end

function Exit()
  setPortal()
  clearUI()
  redstone.setOutput('bottom', false)
  print 'Goodbye.'
end

function Panic(err)
  print("*** PANIC: ", err)
  print("*** Auto-reboot in 5 seconds...")
  sleep(5)
  os.reboot()
end

success, err = pcall(Init)
if not success then Panic(err) end