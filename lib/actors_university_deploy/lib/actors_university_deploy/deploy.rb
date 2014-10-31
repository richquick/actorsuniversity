module ActorsUniversityDeploy
  class Deploy
    def initialize target, directory
      @target = target
      @directory = directory

      `cd #{@directory}`
    end

    def go
      check_for_clean_git_status

      on_release_branch do
        if recompile_assets?
          remove_assets
          compile_assets
        end
        deploy
      end
    end

    def recompile_assets?
      false
    end

    def check_for_clean_git_status
      exit(-1) unless git.ok_status
    end

    def on_release_branch
      git.checkout ci.last_successful_sha do
        formatted_time = Tagger.new.format(Time.now)
        git.branch "release_branch_#{formatted_time}"

        yield
      end
    end

    def deploy
      `git push #{@target} master`
      Tagger.new.tag 'release', git.current_sha, Time.now
    end

    private

    def remove_assets
      puts 'Removing existing assets'
      `rm -rf public/assets/*`
      git.commit_all "Deleting assets from deploy script #{__FILE__}:#{__LINE__}"
    end

    def compile_assets 
      puts 'Compiling assets'
      `RAILS_ENV=production rake assets:precompile`

      git.commit_all "Adding new assets from deploy script #{__FILE__}:#{__LINE__}"
    end


    def ci
      @ci ||=SuccessfulBuildFinder.new
    end

    def git
      @git ||= GitManager.new
    end
  end

end
