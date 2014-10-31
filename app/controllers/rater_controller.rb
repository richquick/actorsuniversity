class RaterController < ApplicationController
  def create
    if current_user.present?
      to_rate.rate(*rating_attributes)
      render :json => true
    else
      render :json => false
    end
  end

  private

  def klass_to_rate
    allowed_params[:klass].constantize
  end

  def to_rate
    klass_to_rate.find(allowed_params[:id])
  end

  def rating_attributes
    [allowed_params[:score].to_i, current_user.id].tap do |a|
      dimension = allowed_params[:dimension]

      a << dimension if dimension.present?
    end
  end

  def allowed_params
    params.permit :rate, :dimension, :klass, :id, :score
  end

end
