module QGame
  class Screen
  end

  class AnalysisScreen < Screen
  	def self.enable
      AnalysisScreen.new(:analyse) do
        object_count = {}
        
        ticker_graph(:frequency => 0.1, :color => :blue, :label => "Object Pool", :label_format => '%d') do
          ObjectSpace.count_objects(object_count)
          object_count[:TOTAL]
        end

        ticker_graph(:frequency => 0.1, :color => :red, :label => "Update Time", :label_format => '%.4f s') do
          QGame::Application.elapsed
        end
        
        ticker_graph(:frequency => 0.1, :color => :green, :label => "Render Time", :label_format => '%.4f s') do
          QGame::Application.render_manager.render_duration
        end
      end
  	end
  end
end
