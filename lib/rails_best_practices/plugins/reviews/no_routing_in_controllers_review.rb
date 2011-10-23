# encoding: utf-8
require 'rails_best_practices/reviews/review'

module RailsBestPractices
  module Plugins
    module Reviews
      class NoRoutingInControllersReview < RailsBestPractices::Reviews::Review

        def debug
        end

        def interesting_nodes
          [:call, :if, :unless, :elsif]
         end

        def interesting_files
          CONTROLLER_FILES
        end

        def start_if(node)
          got_params = false
          got_submit = false

          node.grep_nodes (:sexp_type => :call ) do |child|
            got_params = true if child.message.to_s == "params"
          end

          node.grep_nodes(:sexp_type =>:arglist ) do |child|
            got_submit = true if child.sexp_type == :lit && child.value == :submit_flag
          end

          if got_params && got_submit
            add_error 'No routing inside controllers'
          end
        end

        def start_call(node)

          if node[1] && node[2]
            if node[1].message == :request && node[2] == :post?
              add_error 'No routing inside controllers'
            end
          end

        end
      end
    end
  end
end


