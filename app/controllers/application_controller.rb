class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    UserContext.new(current_user, { cookies: cookies, pincode: params[:pincode] })
  end


  # Настройка для девайза — разрешаем обновлять профиль, но обрезаем
  # параметры, связанные со сменой пароля.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  private

  def current_user_can_edit?(model)
    user_signed_in? && (
      model.user == current_user ||
        (model.try(:event).present? && model.event.user == current_user)
    )
  end

  def user_not_authorized(error)
    policy_name = error.policy.class.to_s.underscore

    flash[:alert] = t "#{policy_name}.#{error.query}", scope: "pundit", default: t("pundit.not_authorized")
    redirect_back(fallback_location: root_path)
  end
end
