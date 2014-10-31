module ActorsUniversityDeploy
  class GitManager
    def current_sha
      `git rev-parse HEAD`
    end

    def ok_status
      status = `git status -s`

      if status.present?
        status.split("\n").each do |s|
          gitmodule_change   = s['?? .gitmodules'].present?
          deploy_repo_change = s['?? actors-university-deploy/'].present?
          main_repo_change = !gitmodule_change && !deploy_repo_change

          if main_repo_change 
            puts "Can't tag with unstaged changes - as we may need to checkout the repo from a different commit"
            return false
          end
        end
      end

      return true
    end

    def tag name
      `git tag #{name}`
    end

    def push_tags
      `git push origin --tags`
    end

    def branch name
      `git checkout -b #{name}`
    end

    def commit_all message
      `git add .`
      `git commit -m #{message}`
    end

    def checkout sha
      puts "Checking out #{sha}"
      `git checkout #{sha}`
      yield if block_given?
    end
  end

end
