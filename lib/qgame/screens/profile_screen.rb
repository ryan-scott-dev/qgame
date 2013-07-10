module QGame
  class Screen
  end

  class ProfileScreen < Screen
  	def self.enable
  		(class << ScreenManager
  			alias_method :old_transition_to, :transition_to

  			define_method(:transition_to) do |screen_name|
  				puts "No more transistions!"
  				old_transition_to(screen_name)
  			end
  		 end)
  	end
  end
end
