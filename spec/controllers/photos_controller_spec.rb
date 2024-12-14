require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:photo) { create(:photo, event: event, user: user) }

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'creates a new photo and redirects to event' do
        expect {
          post :create, params: {
            event_id: event.id,
            photo: { photo: fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }
          }
        }.to change(event.photos, :count).by(1)

        expect(response).to redirect_to(event)
        expect(flash[:notice]).to eq(I18n.t('controllers.photos.created'))
      end
    end

    # context 'with invalid attributes' do
    #   it 'does not save the photo and renders events/show' do
    #     expect {
    #       post :create, params: { event_id: event.id, photo: { photo: nil } }
    #     }.not_to change(event.photos, :count)

    #     expect(response).to render_template('events/show')
    #   end
    # end
  end

  # describe 'DELETE #destroy' do
  #   before { sign_in user }

  #   context 'when user can edit the photo' do
  #     it 'destroys the photo and redirects to event' do
  #       photo

  #       expect {
  #         delete :destroy, params: { event_id: event.id, id: photo.id }
  #       }.to change(event.photos, :count).by(-1)

  #       expect(response).to redirect_to(event)
  #       expect(flash[:notice]).to eq(I18n.t('controllers.photos.destroyed'))
  #     end
  #   end

  #   context 'when user cannot edit the photo' do
  #     let(:another_user) { create(:user) }

  #     before { sign_in another_user }

  #     it 'does not destroy the photo and redirects to event with alert' do
  #       photo

  #       expect {
  #         delete :destroy, params: { event_id: event.id, id: photo.id }
  #       }.not_to change(event.photos, :count)

  #       expect(response).to redirect_to(event)
  #       expect(flash[:alert]).to eq(I18n.t('controllers.photos.error'))
  #     end
  #   end
  # end
end
