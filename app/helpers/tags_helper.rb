module TagsHelper
  
  def tag_url(tag)
    "#{tag.project.ci_server_url}#{tag.build_number}"
  end
  
  def change_indicator(tag,metric)
    change = tag.change(metric)
    str = change.to_s
    
    if change > 0
      str = "+#{str}#{image_tag('up.png')}"
    elsif change < 0
      str = "#{str}#{image_tag('down.png')}"
    end
    content_tag :span, str.html_safe, :class => 'change'
  end
end
