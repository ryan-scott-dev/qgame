require 'rake'

load 'qgame/tasks/new_project.rb'

module QGame
  module Runner
    def self.start(given_args=ARGV)
      Rake::Task[given_args[0]].execute(given_args[1..-1])
    end
  end
end