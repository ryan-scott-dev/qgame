Game::Application.configure do
  config.asset_mode = :compile

  config.output = :file
  config.output_file = 'log.txt'

  config.scripts.compile = true
  config.scripts.hotload = false
end