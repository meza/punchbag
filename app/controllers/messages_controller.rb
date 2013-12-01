class MessagesController < ApplicationController

  before_action :signed_in_user, only: [:sendit, :compose, :read]

  def compose
    followers = User.find(current_user.id).followers



    peeps = Array.new

    followers.each do |f|
      peeps.push(f)
    end

    @peeps_array = peeps.map { |user| [user.username, user.original_id] }

    if @peeps_array.empty?
      redirect_to users_path, :flash => {:error => sprintf("You don't have any followers. Sod off and make some friends")} and return
    end

  end

  def sendit
    to = follower_from_id(user_params[:to])
    message = user_params[:message]
    from = follower_from_id(current_user.id)

    Message.create(:to=>to, :from=>from, :message=>message)
    redirect_to users_path, :flash => {:info => sprintf("Message sent")} and return
  end

  def read
    @messages = Message.where('to.username' => current_user.username).all
  end

  private
  def user_params
    params.permit(:to, :message)
  end

end
