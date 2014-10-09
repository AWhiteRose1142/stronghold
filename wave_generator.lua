module( "WaveGenerator", package.seeall )

waves = {
  wave1 = {
    stage1 = { 2, "orc" },
    stage2 = { 1, "imp" },
    stage3 = { 4, "orc" },
    stage4 = { 6, "goblin" },
    stage5 = { 1, "orc" },
    stage6 = { 1, "goblin" },
  },
  wave2 = {
    stage1 = { 2, "orc" },
    stage2 = { 1, "goblin" },
    stage3 = { 4, "orc" },
    stage4 = { 6, "goblin" },
    stage5 = { 1, "orc" },
    stage6 = { 2, "orc" },
    stage7 = { 1, "orc" },
    stage8 = { 1, "goblin" },
  },
  wave3 = {
    stage1 = { 2, "orc" },
    stage2 = { 1, "goblin" },
    stage3 = { 4, "orc" },
    stage4 = { 6, "goblin" },
    stage5 = { 1, "orc" },
    stage6 = { 1, "goblin" },
    stage7 = { 3, "goblin" },
    stage8 = { 1, "orc" },
    stage9 = { 2, "orc" },
    stage10 = { 1, "orc" },
  },
  wave4 = {
    stage1 = { 2, "orc" },
    stage2 = { 1, "goblin" },
    stage3 = { 4, "orc" },
    stage4 = { 6, "goblin" },
    stage5 = { 1, "orc" },
    stage6 = { 1, "goblin" },
    stage7 = { 1, "goblin" },
    stage8 = { 2, "goblin" },
    stage9 = { 1, "orc" },
    stage10 = { 1, "orc" },
    stage11 = { 1, "orc" },
    stage12 = { 2, "goblin" },
    stage13 = { 1, "goblin" },
  },
}

SPAWN_POSITION = { 250, -120 }

function WaveGenerator:initialize( wave, stage )
  self.wave = wave
  self.stage = stage
  self.timer = nil
  self.isThisWaveOver = false
end

-- Kicks off a new wave
function WaveGenerator:startWave()
  if self.waves["wave" .. self.wave] == nil then
    print( "there's no wave for that index D: Make one, you lazy bastard!" )
    return
  end
  self.timer = MOAITimer.new()
  self.timer:setMode( MOAITimer.NORMAL )
  self.timer:setSpan( self.waves["wave" .. self.wave]["stage" .. self.stage][1] )
  self.timer:setListener( MOAITimer.EVENT_TIMER_END_SPAN, bind( self, "doStage" ) )
  self.timer:start()
end

-- Sets up for the next wave
function WaveGenerator:setupNextWave()
  self.wave = self.wave + 1
  self.stage = 1
  Player.progress.waveNum = self.wave
end

-- Executes a stage
function WaveGenerator:doStage( )
  local stage = self.waves["wave" .. self.wave]["stage" .. self.stage]
  for i = 2, table.getn( stage ) do
    self:spawn( stage[i] )
  end
  self.stage = self.stage + 1
  if self.waves["wave" .. self.wave]["stage" .. self.stage] == nil then
    self:setupNextWave()
    -- Tell the level the wave is over. Then let the level check if all enemies are dead
    self.isThisWaveOver = true
    --Game:startNewState( "upgrademenu" )
  else
    self:nextStage()
  end
end

function WaveGenerator:nextStage()
  self.timer = MOAITimer.new()
  self.timer:setMode( MOAITimer.NORMAL )
  self.timer:setSpan( self.waves["wave" .. self.wave]["stage" .. self.stage][1] )
  self.timer:setListener( MOAITimer.EVENT_TIMER_END_SPAN, bind( self, "doStage" ) )
  self.timer:start()
end

function WaveGenerator:spawn( enemyType )
  if enemyType == "orc" then
    Orc:new( SPAWN_POSITION, Level.layers.active )
  end
  
  if enemyType == "goblin" then
    Goblin:new( SPAWN_POSITION, Level.layers.active )
  end
  
  if enemyType == "skeleton" then
    Skeleton:new( SPAWN_POSITION, Level.layers.active )
  end
  
  if enemyType == "imp" then
    Imp:new( SPAWN_POSITION, Level.layers.active )
  end
end