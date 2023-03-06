require 'rails_helper'

RSpec.describe 'AuthenticationController', type: :request do
  # rubocop:disable Lint/UselessAssignment
  describe 'POST /login' do
    email = 'test@test.com'
    name = 'test'
    valid_credentials = { email:, password: 'password' }
    invalid_password = { email:, password: 'wrong' }
    invalid_email = { email: 'wrong@example.com', password: 'password' }

    # rubocop:enable Lint/UselessAssignment

    before(:each) do
      post '/api/v1/auth/sign_up', params: {
        user: {
          name:,
          email:,
          password: 'password'
        }
      }
      post '/api/v1/auth/log_in', params: {
        user: {
          email:,
          password: 'password'
        }
      }
    end

    context 'when valid credentials are provided' do
      it 'logs in a user' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a token' do
        body = JSON.parse(response.body)
        expect(body['token']).not_to be_nil
        expect(body['token']).not_to be_nil
      end

      it "returns the user's information" do
        body = JSON.parse(response.body)
        expect(body['user']['email']).to eq(email)
        expect(body['user']['name']).to eq(name)
      end
    end

    context 'when an invalid password is provided' do
      before { post '/api/v1/auth/log_in', params: { user: invalid_password }.to_json, headers: }

      it 'returns a unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({
          msg: 'You are not authorize to access this account',
          error: {
            value: 'Password not correct',
            details: []
          }
        }.to_json)
      end
    end

    context 'when an invalid email is provided' do
      before { post '/api/v1/auth/log_in', params: { user: invalid_email }.to_json, headers: }

      it 'returns a unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({
          msg: 'You are not authorize to access this account',
          error: {
            value: 'Email not correct',
            details: []
          }
        }.to_json)
      end
    end
  end
end
