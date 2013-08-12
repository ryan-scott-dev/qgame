require 'fileutils'

PROJECT_ROOT = Dir.pwd

task :release, [:args] => :prepare_compile do |t, args|
  RELEASE_DIR = "#{PROJECT_ROOT}/release/#{COMPILE_PLATFORM.name}"
  FileUtils.mkdir_p RELEASE_DIR

  Rake::Task['bundle_assets'].invoke(args)
  Rake::Task['copy_executables'].invoke(args)
end

task :bundle_assets do
  # Copy all of the assets from the assets directory to the release directory
  FileUtils.mkdir_p RELEASE_DIR
  FileUtils.cp_r "#{PROJECT_ROOT}/assets", "#{RELEASE_DIR}/assets"
end

task :copy_executables => :compile do
  output = Game.targets[COMPILE_PLATFORM.build_target.to_s].output_application
  FileUtils.cp output, "#{RELEASE_DIR}"
end