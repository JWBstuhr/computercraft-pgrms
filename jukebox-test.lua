term.clear()
term.setCursorPos(1,1)

drive = peripheral.find("drive")

local playing = 0
local played = 0
local loop = 0

local discDur = {
 d11 = 72,
 d13 = 179,
 dblocks = 346,
 dcat = 186,
 dchirp = 186,
 dfar = 175,
 dmall = 198,
 dmellohi = 97,
 dstal = 151,
 dstrad = 189,
 dwait = 238,
 dward = 252
}

local function prt(txt,col)
 term.setTextColor(col)
 print(txt)
 term.setTextColor(colors.white)
end

prt("Current Disc:", colors.white)

term.setCursorPos(1,3)
term.setBackgroundColor(colors.gray)
prt("[>",colors.white)
term.setCursorPos(4,3)
prt("||",colors.white)
term.setCursorPos(7,3)
prt("()",colors.white)
term.setCursorPos(10,3)
prt("X",colors.red)
term.setBackgroundColor(colors.black)

local function discCheck()
 while true do
  term.setCursorPos(1,2)
  if drive.hasAudio() then
   term.clearLine(2)
   prt(drive.getAudioTitle(),colors.yellow)
   local disc = drive.getAudioTitle()
   disc = string.sub(disc,8)
   disc = "d" .. disc
   dur = discDur[disc]
  else
   term.clearLine(2)
   prt("[No Disc]",colors.red)
   playing = 0
   term.setCursorPos(7,3)
   term.setBackgroundColor(colors.gray)
   prt("()",colors.white)
   term.setBackgroundColor(colors.black)
   loop = 0
  end
  sleep(0.02)
 end
end

local function clickCheck()
 while true do
  local evt, btn, x, y = os.pullEvent("mouse_click")
  if y == 3 and drive.hasAudio() then
   if x == 1 or x == 2 then
    drive.playAudio()
    playing = 1
   end
   if x == 4 or x == 5 then
    drive.stopAudio()
    playing = 0
   end
   if x == 7 or x == 8 then
    if loop == 0 then
     term.setCursorPos(7,3)
     term.setBackgroundColor(colors.lightGray)
     prt("()",colors.yellow)
     term.setBackgroundColor(colors.black)
     loop = 1
    else
     term.setCursorPos(7,3)
     term.setBackgroundColor(colors.gray)
     prt("()",colors.white)
     term.setBackgroundColor(colors.black)
     loop = 0
    end
   end
  end
  if y == 3 and x == 10 then
   if drive.hasAudio() then
    drive.stopAudio()
    playing = 0
   end
   term.clear()
   term.setCursorPos(1,1)
   return
  end
  sleep(0.02)
 end
end

local function checkLoop()
 while true do
  if playing == 1 and loop == 1 then
   sleep(dur - played)
   if playing == 1 and loop == 1 then
    drive.playAudio()
    played = 0
   end
  end
 sleep(0.02)
 end
end

local function playTime()
 while true do
  if playing == 1 then
   played = played + 1
   sleep(1)
   if played == dur then
    playing = 0
   end
  else
   played = 0
  end
  sleep(0.02)
 end
end

local ok, error = pcall(parallel.waitForAny(discCheck,clickCheck,checkLoop,playTime))
