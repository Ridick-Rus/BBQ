class CommentsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_comment, only: %i[ destroy ]

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      # если сохранился успешно, редирект на страницу самого события
      redirect_to @event, notice: I18n.t('controllers.comments.created')
    else
      # если ошибки — рендерим здесь же шаблон события
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  def destroy
    message = {notice: I18n.t('controllers.comments.destroyed')}

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = {alert: I18n.t('controllers.comments.error')}
    end

    redirect_to @event, message
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  # Комментарий будем искать не по всей базе,
  # а у конкретного события
  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end
end
