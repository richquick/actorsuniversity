module ActorsUniversityDeploy
  class Tagger
    def tag_current_sha_as_successful time
      puts 'unclean git status' and return false unless git.ok_status

      puts 'tagging successful build'
      tag 'success', git.current_sha, time
      git.checkout 'master'
    end

    def ci
      @ci ||= SuccessfulBuildFinder.new
    end

    def git
      @git ||= GitManager.new
    end

    def tag prefix, sha, time
      git.checkout sha do
        tag_name = "#{prefix}_#{format(time)}"

        git.tag tag_name
      end
      git.push_tags
    end

    def format time
      format = "%Y_%m_%d_%H:%M:%S-%A%l:%M%p"
      tag = Time.parse(time.to_s).strftime format
      tag.gsub(/\ |\-|\:/, "_").gsub(/-/,"_")
    end
  end
end
