module( "WaveGenerator", package.seeall )

waves = {
  wave1 = {
    stage1 = { 2, "orc" },
    stage2 = { 1, "goblin" },
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
    stage6 = { 1, "orc" },
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
  },
  wave4 = {
    stage1 = { 2, "orc" },
    stage2 = { 1, "goblin" },
    stage3 = { 4, "orc" },
    stage4 = { 6, "goblin" },
    stage5 = { 1, "orc" },
    stage6 = { 1, "goblin" },
  },
}

SPAWN_POSITION = { 250, -120 }

function WaveGenerator:initialize( wave, stage )
  self.wave = wave
  self.stage = stage
  self.timer = nil
end

-- Kicks off a new wave
function WaveGenerator:newWave()
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
    -- Interrupt here, or in setupNextWave.
    self:newWave()
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
end