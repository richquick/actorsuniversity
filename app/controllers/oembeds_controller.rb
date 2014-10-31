class OembedsController < ApplicationController
  def show
    @oembed = Oembed.for(params[:url])
    render json: @oembed
  end
end
