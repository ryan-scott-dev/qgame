module QGame
  class Menu
    @@menus = {}

    def self.find(menu_name)
      @@menus[menu_name]
    end

    def initialize(menu_name, &block)
      @name = menu_name
      @components = []
      @configure = block
      
      @@menus[menu_name] = self
    end

    def build
      self.instance_eval(&@configure)
      self
    end

    def image(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)
      new_image = QGame::Sprite.new({:texture => texture, :scale => texture.size}.merge(args))
      @components << new_image
      new_image
    end

    def update
      @components.each do |component|
        component.update
      end

    end
  end
end
