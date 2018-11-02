module VizReview
  module Utils
    class GitUtils
      class << self
        def installed?
          res = `git rev-parse --git-dir 2> /dev/null`
          !res.empty?
        rescue
          false
        end

        def branch
          branch = `git symbolic-ref HEAD 2>/dev/null`
          return nil if branch.empty?
          branch.strip.gsub(/^refs\/heads\//, "")
        end
      end
    end
  end
end
