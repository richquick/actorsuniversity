ENV["RAILS_ENV"] ||= 'test'
require 'rspec/core'
require './lib/hexagonal'

RSpec.configure do |config|
  config.order = "random"
end
