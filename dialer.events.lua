-- Dialer, by Roy Curtis
-- Using original code by KJ4IPS @
-- files.haun.guru/ComputerCraft/

function onKey(key)
  if key == 207 then exiting = true
  end
end

function onTouch(side, x, y)
  for _, button in ipairs(state.buttons) do
    if  x >= button.x
    and x <= button.xEnd
    and y == button.y
    then
      setPortal()
      drawBanner('Switching destination...')
      blinkButton(button)
      
      setPortal(button.book, button.slot)
      drawBanner()
      return
    end
  end
end