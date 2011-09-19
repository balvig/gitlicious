module CommitsHelper
  
  def change_indicator(diagnosis)
    change = diagnosis.change
    str = change.to_s
    
    if change > 0
      str = "+#{str}"
    elsif change < 0
      str = "#{str}"
    end
    content_tag :span, str.html_safe, :class => 'change'
  end
end
