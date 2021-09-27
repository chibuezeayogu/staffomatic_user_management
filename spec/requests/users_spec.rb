require 'swagger_helper'

RSpec.describe 'users', type: :request do
  let(:Authentication) { "Bearer #{auth_token}" }
  let(:archived) { '' }
  let(:deleted) { '' }

  path '/users' do
    get('list users') do
      security [bearer_auth: []]
      parameter name: :Authentication, in: :header, type: :string, description: 'Client token'
      parameter name: :archived, in: :query, type: :string, description: 'Archived filter value true/false'
      parameter name: :deleted, in: :query, type: :string, description: 'Deleted filter value true/false'


      response(401, 'unauthorized') do
        let(:Authentication) { 'Bearer' }

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['message']).to eq('Please log in')
        end
      end

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get('show user') do
      security [bearer_auth: []]
      parameter name: :Authentication, in: :header, type: :string, description: 'Client token'
      parameter name: 'id', in: :path, type: :string, description: 'user id'

      response(200, 'successful') do
        let(:id) { users.first.id }

        run_test! do |response|
          data = JSON.parse(response.body)['data']

          expect(data).not_to be_empty
          expect(data['id']).to eq users.first.id.to_s
        end
      end
    end

    put('update user') do
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :Authentication, in: :header, type: :string, description: 'Client token'
      parameter name: 'id', in: :path, type: :string, description: 'user id'
      parameter name: :user, in: :body, schema: { '$ref' => '#/components/user_update' }

      response(200, 'successful') do
        let(:id) { users.first.id }
        let(:user) { { user: { archived: true } } }

        run_test! do |response|
          data = JSON.parse(response.body)['data']

          expect(data).not_to be_empty
          expect(data['id']).to eq users.first.id.to_s
          expect(data['attributes']['archived']).to eq true
          expect(data['attributes']['user_updates'][0]['modifier']).to eq auth_user.email
          # before update
          expect(data['attributes']['user_updates'][0]['changes']['archived']).to eq false
        end
      end
    end
  end
end
