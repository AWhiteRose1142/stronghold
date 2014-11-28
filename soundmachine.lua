module( "SoundMachine", package.seeall )

  function SoundMachine:initialize()
    --ResourceDefinitions:setDefinitions( audio_definition )
    self.sounds = {}
    MOAIUntzSystem.initialize()
  end
  
  function SoundMachine:get( name )
    local audio = self.sounds[name]
    if not audio then
      audio = ResourceManager:get( name )
      self.sounds[name] = audio
    end
    return audio
  end
  
  function SoundMachine:play( name, loop )
    local audio = SoundMachine:get( name )
    if loop ~= nil then
      audio:setLooping( loop )
    end
    audio:play()
  end
  
  function SoundMachine:stop( name )
    local audio = SoundMachine:get( name )
    audio:stop()
  end