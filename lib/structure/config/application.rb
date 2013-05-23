require 'qgame'

module $PROJ_NAME
  class Application < QGame::Application

    # Change the title of the window or the app
    conf.title = "$PROJ_NAME is the coolest game ever"

    conf.version = "1.0.0"
  end
end