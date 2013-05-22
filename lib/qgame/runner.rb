require 'rake'

load 'qgame/tasks/new_project.rb'
load 'qgame/tasks/run.rb'

module QGame
  module Runner
    def self.start(given_args=ARGV)
      p "Executing task #{given_args[0]}"
      Rake::Task[given_args[0]].execute(given_args[1..-1])
    end
  end
end