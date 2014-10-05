module( "WaveGenerator", package.seeall )

waves = {
  wave1 = {
    stage1 = { 2, "orc" },
    stage2 = { 3, "goblin", "orc" },
    stage3 = { 2, "orc" },
    stage4 = { 3, "goblin", "orc", "orc" },
    stage5 = { 3, "goblin", "orc", "orc" },
    stage6 = { 3, "goblin", "orc", "orc" },
  },
  wave2 = {
    stage1 = { 2, "orc", "orc" },
    stage2 = { 3, "goblin", "orc" },
    stage3 = { 2, "orc" },
    stage4 = { 3, "goblin", "orc", "orc" },
    stage5 = { 3, "goblin", "orc", "orc" },
    stage6 = { 3, "goblin", "orc", "orc" },
  },
  wave3 = {
    stage1 = { 2, "orc", "orc", "orc" },
    stage2 = { 3, "goblin", "orc" },
    stage3 = { 2, "orc" },
    stage4 = { 3, "goblin", "orc", "orc" },
    stage5 = { 3, "goblin", "orc", "orc" },
    stage6 = { 3, "goblin", "orc", "orc" },
  },
  wave4 = {
    stage1 = { 2, "orc", "orc", "orc", "orc" },
    stage2 = { 3, "goblin", "orc" },
    stage3 = { 2, "orc" },
    stage4 = { 3, "goblin", "orc", "orc" },
    stage5 = { 3, "goblin", "orc", "orc" },
    stage6 = { 3, "goblin", "orc", "orc" },
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
  if table.getn( self.waves["wave" .. self.wave] ) > self.stage then
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