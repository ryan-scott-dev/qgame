module Game
  def self.reload
    reload_path('./game/lib')
    
    true
  end

  def self.reload_path(path)
    path_blacklist = ['.', '..', 'application.rb']

    Dir.entries(path).each do |file|
      next if path_blacklist.include?(file)
      
      file_path = "#{path}/#{file}"

      if Dir.exists? file_path
        reload_path(file_path)
      else
        next unless file.include? '.rb'

        puts file_path
        self.reload_file(file_path)
      end
    end
  end
end