# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event, user: user) }

  describe 'GET #index' do
    it 'assigns policy scoped events and renders index' do
      expect(EventPolicy::Scope).to receive(:new).and_call_original
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).to eq(Event.all)
    end
  end

  describe 'GET #show' do
    context 'when authorized' do
      before { sign_in user }

      it 'assigns the requested event and renders show' do
        expect(Pundit).to receive(:authorize).and_call_original
        get :show, params: { id: event.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:event)).to eq(event)
      end
    end

    context 'when not authorized' do
      it 'renders password_form with unauthorized status' do
        get :show, params: { id: event.id, pincode: 'wrong' }
        expect(response).to render_template('password_form')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #new' do
    before { sign_in user }

    it 'assigns a new event and renders new' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'creates a new event and redirects to show' do
        expect {
          post :create, params: { event: attributes_for(:event) }
        }.to change(Event, :count).by(1)
        expect(response).to redirect_to(assigns(:event))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the event and renders new' do
        expect {
          post :create, params: { event: attributes_for(:event, title: nil) }
        }.not_to change(Event, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'updates the event and redirects to show' do
        patch :update, params: { id: event.id, event: { title: 'Updated' } }
        expect(event.reload.title).to eq('Updated')
        expect(response).to redirect_to(event)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the event and renders edit' do
        patch :update, params: { id: event.id, event: { title: nil } }
        expect(event.reload.title).not_to eq(nil)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    it 'destroys the event and redirects to index' do
      delete :destroy, params: { id: event.id }
      expect(Event.exists?(event.id)).to be_falsey
      expect(response).to redirect_to(events_path)
    end
  end
end
