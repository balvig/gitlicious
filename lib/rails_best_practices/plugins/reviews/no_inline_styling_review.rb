# encoding: utf-8
require 'rails_best_practices/reviews/review'


module RailsBestPractices
  module Plugins
    module Reviews
      class NoInlineStylingReview < RailsBestPractices::Reviews::Review

        def interesting_nodes
          [:block]
        end

        def interesting_files
          VIEW_FILES
        end

        def start_block(node)
          node.grep_nodes(:sexp_type => [:str]) do |child_node|
            if  child_node.to_s.include? "style="
              add_error "No inline styles in views"
            end
          end

        end
      end
    end
  end
end
