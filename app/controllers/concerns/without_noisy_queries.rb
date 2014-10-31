module WithoutNoisyQueries
  def without_noisy_queries
    #TECHDEBT - reduce the number of queries we are generating
    #instead of quieting them
    logging = ActiveRecord::Base.logger.level
    ActiveRecord::Base.logger.level = 1
    result = yield
    ActiveRecord::Base.logger.level = logging

    result
  end
end
