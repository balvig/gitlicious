module AuthorsHelper
  def avatar_url(user,size = 30)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&r=PG"
  end
  
  def genitive(str)
    str+= str[str.length-1,1] == 's' ? "'" : "'s" if str.present?
  end
end