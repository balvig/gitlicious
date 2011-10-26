# encoding: utf-8
require 'rails_best_practices/reviews/review'


module RailsBestPractices
  module Plugins
    module Reviews
      class NoInlineStylingReview < RailsBestPractices::Reviews::Review

        def debug

        end
        def interesting_nodes
          [:block, :dstr]
        end

        def interesting_files
          VIEW_FILES
        end

        #dstr contains the result of the haml compilation.
        #haml compilation results in one or more junks of HTML strings. The
        #strings are splitted by any call to ruby code we have in the file.
        #node[1] contains all the html from the top of the file till some
        #ruby code is used in that page
        #The rest of the html code is written in the first nodes of every :str
        def start_dstr(node)
          texts_to_check = []

          texts_to_check << node[1]
          node.grep_nodes(:sexp_type => :str) do |child|
            if child.sexp_type == :str
              texts_to_check << child[1].inspect
            end
          end

          texts_to_check.each do |text|
            if text.include? "style="
              add_error "No inline styles in views"
            end
          end
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
