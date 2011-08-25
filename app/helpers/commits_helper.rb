module CommitsHelper
  
  def change_indicator(commit,metric)
    change = commit.change(metric)
    str = change.to_s
    
    if change > 0
      str = "+#{str}#{image_tag('up.png')}"
    elsif change < 0
      str = "#{str}#{image_tag('down.png')}"
    end
    content_tag :span, str.html_safe, :class => 'change'
  end
end
