module Hexagonal
  attr_reader :framework, :dao

  def initialize framework, dao
    @framework, @dao = framework, dao
  end
end
