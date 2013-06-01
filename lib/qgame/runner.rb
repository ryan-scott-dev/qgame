require 'rake'

load "#{QGAME_ROOT}/tasks/new_project.rb"
load "#{QGAME_ROOT}/tasks/run.rb"
load "#{QGAME_ROOT}/tasks/compile.rb"

module QGame
  module Runner
    def self.start(given_args=ARGV)
      p "Executing task #{given_args[0]}"
      Rake.verbose(true)
      Rake::Task[given_args[0]].invoke(given_args[1..-1])
    end
  end
end