namespace :compile do
  def default_platform
    case 
    when RUBY_PLATFORM.downcase.include?("darwin")
      return :osx
    when RUBY_PLATFORM.downcase.include?("linux")
      return :linux
    when RUBY_PLATFORM.downcase.include?("mswin")
      return :win
    end
  end

  PROJECT_ROOT = Dir.pwd
  MRUBY_ROOT = ENV['MRUBY_ROOT'] || "#{PROJECT_ROOT}/build/mruby"
  PLATFORM = ENV['PLATFORM'] || default_platform
  MRUBY_BUILD_HOST_IS_CYGWIN = RUBY_PLATFORM.include?('cygwin')

  # load build systems
  load "#{MRUBY_ROOT}/tasks/ruby_ext.rake"
  load "#{MRUBY_ROOT}/tasks/mruby_build.rake"
  load "#{MRUBY_ROOT}/tasks/mrbgem_spec.rake"

  # load configuration file
  load "#{PROJECT_ROOT}/config/build_config.rb"
  MRUBY_CONFIG = (ENV['BUILD_CONFIG'] && ENV['BUILD_CONFIG'] != '') ? ENV['BUILD_CONFIG'] : "#{PROJECT_ROOT}/config/platforms/#{PLATFORM.to_s}/build_config.rb"
  load MRUBY_CONFIG

  # load basic rules
  MRuby.each_target do |build|
    build.define_rules
  end

  # load custom rules
  load "#{QGAME_ROOT}/lib/qgame/src/qgame_core.rake"
  load "#{QGAME_ROOT}/lib/qgame/mrblib/mrblib.rake"
  load "#{QGAME_ROOT}/lib/qgame/tasks/libqgame.rake"

  depfiles = MRuby.targets['host'].bins.map do |bin|
    install_path = MRuby.targets['host'].exefile("#{QGAME_ROOT}/bin/#{bin}")
    source_path = MRuby.targets['host'].exefile("#{MRuby.targets['host'].build_dir}/bin/#{bin}")
    
    file install_path => source_path do |t|
      FileUtils.rm_f t.name, { :verbose => $verbose }
      FileUtils.cp t.prerequisites.first, t.name, { :verbose => $verbose }
    end
    
    install_path
  end

  depfiles += MRuby.targets.map { |n, t|
    [t.libfile("#{t.build_dir}/lib/libqgame")]
  }.flatten

  depfiles += MRuby.targets.reject { |n, t| n == 'host' }.map { |n, t|
    t.bins.map { |bin| t.exefile("#{t.build_dir}/bin/#{bin}") }
  }.flatten

  desc "build all targets, install (locally) in-repo"
  task :qgame => depfiles do |args|
    
  end
end