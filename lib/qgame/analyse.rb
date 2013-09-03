module QGame
  class Analyse
    @@running = {}

    def self.object_space(name, &block)
      @@running[name] = AnalyseObjectSpace.new(name, &block) unless @@running.has_key? name
      current_profiler = @@running[name]

      current_profiler.start
      yield
      current_profiler.end
      current_profiler.report

      @@running[name]
    end

    def initialize(name)
      @name = name
    end
  end

  class AnalyseObjectSpace < Analyse
    def initialize(name)
      super(name)

      @before_count = {}
      @after_count = {}
      @difference = {}
    end

    def start
      ObjectSpace.count_objects(@before_count)
    end

    def end
      ObjectSpace.count_objects(@after_count)

      @difference.clear
      @before_count.each do |key, value|
        difference = @after_count[key] - value
        @difference[key] = difference if difference > 0

      end
    end

    def report
      puts @difference.inspect
    end
  end
end
