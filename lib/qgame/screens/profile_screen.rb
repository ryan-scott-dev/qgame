module QGame
  class Screen
  end

  class ProfileScreen < Screen
  	def self.enable
      ProfileScreen.new(:profile) do
        object_count = {}
        min_count = 10000
        max_count = 0

        dynamic_text(:frequency => 1) do
          ObjectSpace.count_objects(object_count)
          count = object_count[:TOTAL]
          min_count = count if count < min_count
          max_count = count if count > max_count

          "Current: #{count} | Min: #{min_count} | Max: #{max_count}"
        end
      end

  		(class << ScreenManager
  			alias_method :old_transition_to, :transition_to

  			define_method(:transition_to) do |screen_name|
  				screen = old_transition_to(screen_name)
          screen.overlay(:profile)
  			end
  		end)
  	end
  end
end
