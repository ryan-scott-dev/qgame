module QGame
  class NewProject < Task
    def new_project(project_name)
      create_folders(project_name)
      
      # Add standard assets
      
      clone_mruby(project_name, 'git://github.com/mruby/mruby.git')
    end

    def create_folders
      FileUtils.mkdir_p "#{project_name}/assets"
      FileUtils.mkdir_p "#{project_name}/build"
      FileUtils.mkdir_p "#{project_name}/config"
      FileUtils.mkdir_p "#{project_name}/game"
      FileUtils.mkdir_p "#{project_name}/libs"
    end

    def clone_mruby(git_url, options)
      mruby_dir = "#{project_name}/build/mruby"
      return mruby_dir if File.exists?(mruby_dir)

      options = [options] || []

      FileUtils.mkdir_p "#{project_name}/build/mruby"
      git.run_clone gemdir, git_url, options
    end
  end
end