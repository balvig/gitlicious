module ProjectsHelper
  def format_score(score)
    str = "#{score} "
    if score < 500
      str += '<span class="label success">Great!</span>'
    elsif score < 1000
      str += '<span class="label warning">Warning</span>'
    else
      str += '<span class="label important">Critical</span>'
    end
    str.html_safe
  end
end
