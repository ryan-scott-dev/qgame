module Game
  def self.reload
    path_blacklist = ['.', '..', 'application.rb']

    Dir.entries('./game/lib').each do |file|
      next if path_blacklist.include?(file)
      next unless file.include? '.rb'

      file_path = "./game/lib/#{file}"
      puts file_path
      self.reload_file(file_path)
    end

    true
  end
end