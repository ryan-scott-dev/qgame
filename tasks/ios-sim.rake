require 'fileutils'

current_dir = Dir.pwd
IOS_SIM_EXEC = "#{DEPENDENCIES_DIR}/ios-sim/build/Release/ios-sim"

namespace :ios_sim do
  def clone_source(url, path)
    FileUtils.sh "git clone #{url} #{path}"
  end

  IOS_SIM_URL = 'git://github.com/phonegap/ios-sim.git'
  IOS_SIM_CLONE_DIR = "#{DEPENDENCIES_DIR}/ios-sim"

  file IOS_SIM_CLONE_DIR do |t|
    clone_source(IOS_SIM_URL, IOS_SIM_CLONE_DIR)  
  end

  file IOS_SIM_EXEC => IOS_SIM_CLONE_DIR do |t|
    FileUtils.cd IOS_SIM_CLONE_DIR
    FileUtils.sh 'rake build'
    FileUtils.cd current_dir
  end
  
  task :build => IOS_SIM_EXEC do
  end
end