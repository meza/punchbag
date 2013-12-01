module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.username.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.where(:username=>params[:username]).first
    redirect_back_or(root_url) unless current_user?(@user)
  end

  def follower_from_id(id)
    user = User.find(id)

    return Follower.new(:username=>user.username, :original_id=>user.id)

  end

  def user_path(user, options={})
    user_url(user, options.merge(:only_path => true))
  end

  def edit_user_path(user, options={})
    edit_user_url(user, options.merge(:only_path => true))
  end

  def user_url(user, options={})
    url_for(options.merge(:controller => 'users', :action => 'show',
                          :username => user.username))
  end

  def edit_user_url(user, options={})
    url_for(options.merge(:controller => 'users', :action => 'edit',
                          :username => user.username))
  end

end
