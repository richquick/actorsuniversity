class SuccessfulBuildFinder
  #TECHDEBT move token elsewhere
  Semaphoreapp.auth_token = 'reii12DWyhs45KxX5nCd'

  def actors_university
    Semaphoreapp::Project.find_by_name('ActorsUniversity')
  end

  def builds
    actors_university.get_branches.first.get_builds
  end

  def last_successful_build
    @last_successful_build ||= builds.detect {|b| b.result == 'passed'}
  end

  def last_successful_commit
    last_successful_build.try :commit
  end

  def last_successful_sha
    last_successful_commit.try :id
  end
end
