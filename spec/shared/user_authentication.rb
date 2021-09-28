# frozen_string_literal: true

RSpec.shared_context 'user_authentication' do
  let(:auth_user) do
    User.create(
      email: 'danie@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
    )
  end
  let(:auth_token) { authenticate_user(auth_user) }
  let!(:users) { create_list(:user, 5) }
end
