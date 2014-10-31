module Auth
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate_user!

    [
      :admin?, :spoof!, :unspoof!, :normally_admin?,
      :non_admin_user?].each do |a|
        delegate a, to: :authorization
        helper_method a
      end

    helper_method :client_name
  end

  def authorization
    @authorization ||= Authorization.new(
      current_user: current_user, session: session)
  end

  def client_name
    ClientNameFinder.name_from request
  end


  class ClientNameFinder
    REGEXES = {
      svelte: /svelte/,
      health: /health/,
      client: /local|actors_university/
    }

    def self.name_from request
      return :client
      # return :client if Rails.env.test?

      # REGEXES.detect do |app, regex|
      #   !!(request.host =~ regex)
      # end.first
    end
  end
end
