module AppLab
  module Services
    module Insights
      class DetectorFactory
        def self.build(rule)
          case rule.name
          when "n_plus_one_queries"
            NPlusOneDetector.new(rule)
          when "missing_indexes"
            MissingIndexDetector.new(rule)
          when "large_files"
            LargeFileDetector.new(rule)
          when "todo_comments"
            TodoCommentDetector.new(rule)
          when "dead_code"
            DeadCodeDetector.new(rule)
          else
            GenericDetector.new(rule)
          end
        end
      end
    end
  end
end
