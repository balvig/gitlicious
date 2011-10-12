# encoding: utf-8
require 'rails_best_practices/reviews/review'

module RailsBestPractices
  module Plugins
    module Reviews
      class OldSchoolBeforeFiltersReview < RailsBestPractices::Reviews::Review
        def interesting_nodes
          [:defn]
        end
        
        def interesting_files
          MODEL_FILES
        end

        def start_defn(node)
          add_error "Don't use badly named callbacks" if node.method_name.to_s =~ /^do_(before|after)_/
        end
      end
    end
  end
end