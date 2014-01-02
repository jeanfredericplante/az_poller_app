module UsersHelper
  
  def gravatar_for(user)
    email_md5_hash = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{email_md5_hash}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
end
