require 'rails_helper'

RSpec.describe 'User Management', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, name: 'Other User') }
  let(:event) { create(:event, user: user, title: 'Test Event') }

  describe 'Viewing User Profile' do
    context 'when user has events' do
     let!(:event) { create(:event, user: user, title: 'Test Event') }

      it 'displays user information' do
        visit user_path(user)

        expect(page).to have_content(user.name)
        expect(page).to have_content(I18n.t('form.creator'))
      end
    end

    it 'displays user events if available' do
      event
      visit user_path(user)

      expect(page).to have_content('Test Event')
    end

    it 'shows a message if the user has no events' do
      visit user_path(user)

      expect(page).to have_content(I18n.t('form.user_has_no_events'))
    end
  end

  describe 'Editing User Profile' do
    before do
      sign_in user
    end

    it 'allows editing user profile' do
      visit edit_user_path(user)

      fill_in 'user_name', with: 'New Name'
      fill_in 'Email', with: 'new@example.com'
      click_button I18n.t('buttons.save')

      expect(page).to have_content('New Name')
      expect(page).to have_content(I18n.t('controllers.users.updated'))
    end
  end

  describe 'Accessing Other Users' do
    before do
      sign_in user
    end

    it 'does not show edit option for other users' do
      visit user_path(other_user)

      expect(page).not_to have_link(I18n.t('actions.account.edit'))
    end
  end

  describe 'Unauthorized Access' do
    it 'redirects to login for edit page' do
      visit edit_user_path(user)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  describe 'Change Password Link' do
    before do
      sign_in user
    end

    it 'navigates to the change password page' do
      visit edit_user_path(user)

      click_link I18n.t('actions.change_password')

      expect(current_path).to eq(edit_user_registration_path)
    end
  end
end
