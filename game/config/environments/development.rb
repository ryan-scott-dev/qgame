Game::Application.configure do
  config.asset_mode = :copy

  config.output = :stdout

  config.scripts.compile = true
  config.scripts.hotload = false
end