require 'rake'

module QGame
  module Runner
    def self.start(given_args=ARGV)
      puts "Executing task #{given_args[0]} with arguments #{given_args[1..-1]}"
      other_args = given_args[1..-1]

      other_args.each do |arg|
        match_data = /--PLATFORM=(\S+)/.match(arg)
        ENV['PLATFORM'] = match_data[1] if match_data and match_data[1]
      end

      load "#{QGAME_ROOT}/tasks/helpers.rake"
      load "#{QGAME_ROOT}/tasks/new_project.rake"
      load "#{QGAME_ROOT}/tasks/run.rake"
      load "#{QGAME_ROOT}/tasks/compile.rake"
      load "#{QGAME_ROOT}/tasks/analyse.rake"
      load "#{QGAME_ROOT}/tasks/release.rake"

      Rake.verbose(true)
      Rake::Task[given_args[0]].invoke(other_args)
    end
  end
end