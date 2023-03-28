class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_for_oauth(request.env['omniauth.auth'])

    redirect_authenticated_user(user, 'Github')
  end

  def yandex
    user = User.find_for_oauth(request.env['omniauth.auth'])

    redirect_authenticated_user(user, 'Yandex')
  end

  private

  def redirect_authenticated_user(user, provider)
    if user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: "#{provider}")

      sign_in user, event: :authentication
      redirect_to root_path
    else
      flash[:error] = I18n.t('devise.omniauth_callbacks.failure', kind: "#{provider}", reason: 'authentication error')

      redirect_to root_path
    end
  end
end
