class MessagesController < ApplicationController

  before_action :signed_in_user, only: [:sendit]
  before_action :correct_user, only: [:read]

  def compose
    @following = User.find(current_user.id).follows;
  end

  def sendit

  end

  def read
    @messages = Message.where(:to=>current_user).all

  end

end
