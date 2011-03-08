module TagsHelper
  def change_indicator(tag)
    prefix = ''
    if tag.score > 0
      prefix = image_tag('up.png') + '+'
    elsif tag.score < 0
      prefix = image_tag('down.png')
    end
    "#{prefix}#{tag.score}".html_safe
  end
end
