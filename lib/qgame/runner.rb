require 'rake'

load "#{QGAME_ROOT}/tasks/new_project.rake"
load "#{QGAME_ROOT}/tasks/run.rake"
load "#{QGAME_ROOT}/tasks/compile.rake"

module QGame
  module Runner
    def self.start(given_args=ARGV)
      puts "Executing task #{given_args[0]} with arguments #{given_args[1..-1]}"
      Rake.verbose(true)
      Rake::Task[given_args[0]].invoke(given_args[1..-1])
    end
  end
end