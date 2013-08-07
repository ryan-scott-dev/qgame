module QGame
  class Screen
  end

  class AnalysisScreen < Screen
  	def self.enable
      AnalysisScreen.new(:analyse) do
        object_count = {}
        min_count = 10000
        max_count = 0

        min_elapsed = 100000
        max_elapsed = 0

        dynamic_text(:frequency => 0.1, :position => Vec2.new(100, 100), :font_size => 10) do
          ObjectSpace.count_objects(object_count)
          count = object_count[:TOTAL]
          min_count = count if count < min_count
          max_count = count if count > max_count

          "#{count} / #{min_count} - #{max_count}"
        end

        dynamic_text(:frequency => 0, :position => Vec2.new(100, 110), :font_size => 10) do
          elapsed = (QGame::Application.elapsed * 1000).to_i
          min_elapsed = elapsed if elapsed < min_elapsed
          max_elapsed = elapsed if elapsed > max_elapsed
          
          "#{elapsed} / #{min_elapsed} - #{max_elapsed}"
        end
      end

  		(class << ScreenManager
  			alias_method :old_transition_to, :transition_to

  			define_method(:transition_to) do |screen_name|
  				screen = old_transition_to(screen_name)
          screen.overlay(:analyse)
  			end
  		end)
  	end
  end
end
