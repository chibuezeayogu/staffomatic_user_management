require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:headers) do
    {
      'Authentication' => "Bearer #{auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  describe 'when user is not authenticated' do
    it 'returns error message' do
      get user_path(auth_user), headers: {}

      expect(json['message']).to eq 'Please log in'
    end
  end

  describe 'GET /index' do
    it 'returns http success' do
      get users_path, headers: headers

      expect(response).to have_http_status(:success)
    end

    context 'when no filters applied' do
      it 'returns the users' do
        get users_path, headers: headers

        expect(json['data'].length).to eq 6 # that is plus the authenticted user
      end
    end

    context 'when filters are applied' do
      it 'returns the users' do
        get users_path(archived: true), headers: headers

        expect(json['data']).to eq []
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when user is authenticated and invalid user id is provided' do
      it 'returns a not found error' do
        get user_path('ttt'), headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json['message']).to eq "Couldn't find User with 'id'=ttt"
      end
    end

    context 'when user is authenticated and provides a user id' do
      it 'returns the user' do
        get user_path(auth_user), headers: headers

        expect(response).to have_http_status(:success)
        expect(json['data']['id']).to eq auth_user.id.to_s
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:user) { users.first }

    context 'when a user tries to archive/unarchive/delete his/her account' do
      it 'returns error message' do
        put user_path(auth_user), headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(json['message']).to eq 'You cannot archive/unarchive/delete your account'
      end
    end

    context 'when a user tries to archive another users account' do
      it 'should archive the user' do
        put user_path(user),
            headers: headers,
            params: { user: { archived: true } }.to_json
        expect(response).to have_http_status(:success)
        expect(json['data']['attributes']['archived']).to eq true
        expect(json['data']['attributes']['user_updates']).not_to be_empty
      end
    end
  end
end
