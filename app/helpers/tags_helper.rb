module TagsHelper
  
  def tag_url(tag)
    "#{tag.project.ci_server_url}#{tag.build_number}"
  end
  
  def change_indicator(tag)
    str = tag.change.to_s
    
    if tag.change > 0
      str = "+#{str}#{image_tag('up.png')}"
    elsif tag.change < 0
      str = "#{str}#{image_tag('down.png')}"
    end
    str.html_safe
  end
end
