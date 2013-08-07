task :profile, [:args] => :prepare_compile do |t, args|
  QGame::ProfileProjectTask.profile(COMPILE_PLATFORM.build_target, args)
end

module QGame
  module ProfileProjectTask
    def self.profile(desired_target, args)
      args[:args] << 'profile'
      
      Game.targets[desired_target.to_s].run(args)
    end
  end
end