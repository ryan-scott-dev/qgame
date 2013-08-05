task :profile, [:args] => :prepare_compile do |t, args|
  QGame::ProfileProjectTask.profile(:host, args)
end

namespace :profile do
  task :ios, [:args] => :prepare_compile do |t, args|
    QGame::ProfileProjectTask.profile(:ios, args)
  end
end

module QGame
  module ProfileProjectTask
    def self.profile(desired_target, args = {args: []})
      args[:args] << 'profile'
      
      Game.targets[desired_target.to_s].run(args)
    end
  end
end