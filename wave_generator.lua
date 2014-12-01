module( "WaveGenerator", package.seeall )

enemies = {
  [1] = "imp",
  [2] = "orc",
  [3] = "goblin"
}

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

SPAWN_POSITION = { 350, -135 }

function WaveGenerator:initialize( )
  --self.wave = wave
  self.stageCounter = 1
  self:generateWave( Player.progress.waveNum )
  self.timer = nil
  self.isThisWaveOver = false
  HUD.wave:setString("WAVE: " .. Player.progress.waveNum )
end

-- returns an array suited for generating enemies
function WaveGenerator:generateWave( waveNum )
  self.generatedWave = {}
  
  -- calculate the number of stages
  local stages = 6 + ( waveNum * 2 )
  
  for i = 1, stages do
    -- selects the monster type
    local monsterType = math.floor( math.random(1, table.getn(self.enemies) ) )
    -- selects the spawn delay
    local delay = ( math.random(5, 40) / 10 )
    -- Insert the monsterType & spawn delay
    table.insert( self.generatedWave, { delay, self.enemies[monsterType] } )
    print( "stage " .. i .. " spawns " .. self.enemies[monsterType] .. " after " .. delay .. " seconds" )
  end
end

-- Kicks off a new wave
function WaveGenerator:startWave()
  --[[if self.waves["wave" .. self.wave] == nil then
    print( "there's no wave for that index D: Make one, you lazy bastard!" )
    return
  end]]--
  self.timer = MOAITimer.new()
  self.timer:setMode( MOAITimer.NORMAL )
  --self.timer:setSpan( self.waves["wave" .. self.wave]["stage" .. self.stage][1] )
  self.timer:setSpan( self.generatedWave[1][1] )
  self.timer:setListener( MOAITimer.EVENT_TIMER_END_SPAN, bind( self, "doStage" ) )
  self.timer:start()
end

-- Executes a stage
function WaveGenerator:doStage( )
  if self.generatedWave[self.stageCounter + 1] == nil then
    print("spawning is over")
    self:setupNextWave()
    self.isThisWaveOver = true
    return
  end
  
  self:spawn( self.generatedWave[self.stageCounter][2] )
  self.stageCounter = self.stageCounter + 1
  self:prepNextStage()
  
  --[[local stage = self.waves["wave" .. self.wave]["stage" .. self.stage]
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
  end]]--
end

-- Sets up for the next wave
function WaveGenerator:setupNextWave()
  --self.wave = self.wave + 1
  Player.progress.waveNum = Player.progress.waveNum + 1
  self.stageCounter = 1
  --Player.progress.waveNum = self.wave
end

function WaveGenerator:prepNextStage()
  self.timer = MOAITimer.new()
  self.timer:setMode( MOAITimer.NORMAL )
  self.timer:setSpan( self.generatedWave[self.stageCounter][1] )
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
  
  if enemyType == "troll" then
    Troll:new( SPAWN_POSITION, Level.layers.active )
  end
end