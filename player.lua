module( "Player", package.seeall )

function Player:initialize( )
  self.progress = {
    score = 9000,
    mana = 100,
    waveNum = 1,
    walls = 1,
    archers = 1,
    fireBall = true,
    lightning = true,
    iceBolt = true,
  }
  self.updateMana = true
  self.initialized = true
  self:manaUpdate()
end

function Player:update( )
  
end

function Player:manaUpdate()
  if self.updateMana == true then
    if self.manaTimer == nil then
      self.manaTimer = MOAITimer.new()
      self.manaTimer:setMode( MOAITimer.LOOP )
      self.manaTimer:setSpan( .15 )
      self.manaTimer:setListener(
        MOAITimer.EVENT_TIMER_END_SPAN,
        bind( self, "manaUpdate" )
      )
      self.manaTimer:start()
    else
      -- update mana score
      if self.progress.mana < 100 then self.progress.mana = self.progress.mana + 1 end
    end
  else
    self.manaTimer:stop()
    self.manaTimer = nil
  end
end

function Player:loadProgress( loadedProgress )
  if loadedProgress.score ~= nil then self.progress.score = loadedProgress.score end
  if loadedProgress.waveNum ~= nil then self.progress.waveNum = loadedProgress.waveNum end
  if loadedProgress.walls ~= nil then self.progress.walls = loadedProgress.walls end
  if loadedProgress.archers ~= nil then self.progress.archers = loadedProgress.archers end
  if loadedProgress.fireBolt ~= nil then self.progress.fireBolt = loadedProgress.fireBolt end
  if loadedProgress.lightning ~= nil then self.progress.lightning = loadedProgress.lightning end
  if loadedProgress.iceBolt ~= nil then self.progress.iceBolt = loadedProgress.iceBolt end
end

function Player:exportProgress( )
  
end

function Player:resetProgress()
  self.progress.score = 0
  self.progress.mana = 100
  self.progress.waveNum = 1
  self.progress.walls = 0
  self.progress.archers = 0
  self.progress.fireBall = true
  self.progress.lightning = false
  self.progress.iceBolt = false
end