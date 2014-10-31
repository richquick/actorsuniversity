require 'actors_university_deploy'

tagger = ActorsUniversityDeploy::Tagger.new
tagger.tag_current_sha_as_successful Time.now
