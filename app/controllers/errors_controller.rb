class ErrorsController < ApplicationController
  def five_hundred
    raise "That's a 500"
  end
end
