-- Dialer, by Roy Curtis
-- Using original code by KJ4IPS @
-- files.haun.guru/ComputerCraft/

function onKey(key)
  if     key == 199 then onHelp()
  elseif key == 207 then exiting = true
  elseif key == 200 then adjustScale( 0.5)
  elseif key == 208 then adjustScale(-0.5)
  elseif key == 205 then adjustColWidth( 1)
  elseif key == 203 then adjustColWidth(-1)
  end
end

function onHelp()
  print '# Controls:'
  print '  UP to grow text size'
  print '  DOWN to shrink text size'
  print '  LEFT to grow column size'
  print '  RIGHT to shrink column size'
  print '  END to restart machine'
  print '  CTRL+T for 5 seconds to kill'
end

function onTouch(side, x, y)
  for _, button in ipairs(state.buttons) do
    if  x >= button.x
    and x <= button.xEnd
    and y == button.y
    then
      pMusic.playSound('random.orb', 1, 1)
      setPortal()
      drawBanner('Switching destination...')
      blinkButton(button)
      setPortal(button.book, button.slot)
      return
    end
  end
end

function onResize(side)
  prepareUI()
end

function onPeripheral(side)
  discoverPeripherals()
  prepareUI()
end