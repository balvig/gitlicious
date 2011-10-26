# encoding: utf-8
require 'rails_best_practices/reviews/review'

module RailsBestPractices
  module Plugins
    module Reviews
      class NoFindInViewsReview < RailsBestPractices::Reviews::Review

        def interesting_nodes
          [:call]
        end

        def interesting_files
          VIEW_FILES
        end

        def start_call(node)
          if node[1] && node[2]
            if node[2].to_s =~ /find\w*|last|first|all/
              add_error("No model finds in views")
            end
          end
        end

      end
    end
  end
end


