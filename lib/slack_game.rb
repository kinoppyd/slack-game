require 'slack'

require 'slack_game/canvas'
require 'slack_game/controller'
require 'slack_game/game'
require "slack_game/version"

module SlackGame
  Slack.configure do |conf|
    conf.token = ENV['SLACK_TOKEN'] || raise(StandardError.new("environment variable 'SLACK_TOKEN' required"))
  end
end
