module( "SoundMachine", package.seeall )

sounds = {
      Dying = MOAIUntzSound.new(),
      Explosion = MOAIUntzSound.new(),
      Crumble = MOAIUntzSound.new(),
      Punch = MOAIUntzSound.new(),
      Sword = MOAIUntzSound.new(),
      Zap = MOAIUntzSound.new(),
      Level = MOAIUntzSound.new(),
      Menu = MOAIUntzSound.new()
      }

  function SoundMachine:initialize()
    MOAIUntzSystem.initialize()
  end
  
  function SoundMachine:loadSound()
    self.sounds.Dying:load("res/sfx/dying.wav")
    self.sounds.Explosion:load("res/sfx/explosion.wav")
    self.sounds.Crumble:load("dev/sfx/hit_and_crumble.wav")
    self.sounds.Punch:load("dev/sfx/punch.wav")
    self.sounds.Sword:load("dev/sfx/sword.wav")
    self.sounds.Zap:load("dev/sfx/zap.wav")
    self.sounds.Level:load("dev/sfx/level.ogg")
    self.sounds.Main:load("dev/sfx/main.ogg")
  end
  
  function SoundMachine:playMusic( name )
    local audio = self.sounds[name]
    audio.setLooping( true )
    audio.play()
  end
  
  function SoundMachine:playSFX( name )
    local audio = self.sounds[name]
    audio.setLooping( false )
    audio.play()
  end