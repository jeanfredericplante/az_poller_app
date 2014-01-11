module UsersHelper
  
  def gravatar_for(user, options={size: 40} )
    email_md5_hash = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{email_md5_hash}?s=#{options[:size]}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
end
