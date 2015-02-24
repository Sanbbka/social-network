class MessagesController < ApplicationController
  expose(:message, attributes: :message_params)
  expose(:friends) { current_user.friends }
  expose(:received_messages) { current_user.received_messages.ordered.includes(:sender) }
  expose(:sent_messages) { current_user.sent_messages.ordered.includes(:receiver) }

  def index
  end

  def show
    message.update(status: 'read') if message.status == 'sent'
  end

  def new
  end

  def create
    if message.save
      redirect_to messages_path
    else
      render :new
    end
  end

  def destroy
    message.destroy
    redirect_to messages_path
  end

  private

  def message_params
    params.require(:message).permit(
      :receiver_id,
      :text
    ).merge(sender_id: current_user.id)
  end
end
