require 'rails_helper'

RSpec.describe 'Api::V1::Authentication', type: :request do
  describe "POST #signup" do
    context "when valid params are provided" do
      let(:valid_params) do
        { user: { name: "test", email: "test@test.com", password: "password" } }
      end
      
      it "creates a new user" do
        expect do
          post '/api/v1/auth/sign_up', params: valid_params
        end.to change(User, :count).by(1)
      end

      it "returns a success response" do
        post '/api/v1/auth/sign_up', params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it "returns a JWT token" do
        post '/api/v1/auth/sign_up', params: valid_params
        expect(JSON.parse(response.body)["token"]).to be_present
      end

      it "returns the user's information" do
        post '/api/v1/auth/sign_up', params: valid_params
        user = User.find_by(email: valid_params[:user][:email])
        expect(JSON.parse(response.body)["user"]).to eq({
          "id" => user.id,
          "name" => user.name,
          "email" => user.email
        })
      end

      it "returns a token and user data in JSON format" do
        post '/api/v1/auth/sign_up', params: valid_params
        body = JSON.parse(response.body)
        expect(body).to include("token", "exp", "user")
        expect(body["user"]).to include("id", "name", "email")
      end    
    end

    context "when invalid params are provided" do
      let(:invalid_params) do
        { user: { name: "", email: "invalid-email", password: "short" } }
      end

      it "does not create a new user" do
        expect do
          post '/api/v1/auth/sign_up', params: invalid_params
        end.to_not change(User, :count)
      end

      it "returns a unprocessable_entity response" do
        post '/api/v1/auth/sign_up', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error message" do
        post '/api/v1/auth/sign_up', params: invalid_params
        expect(JSON.parse(response.body)["error"]["details"]).to include("Name can't be blank", "Email is invalid", "Password is too short (minimum is 6 characters)")
      end

      it 'returns a correct JSON response' do
        post '/api/v1/auth/sign_up', params: invalid_params
        expect(response.body).to eq({
          "msg": "Failed to create an account",
          "error": {
            "value": "Validation failed",
            "details": [
              "Name can't be blank",
              "Name is too short (minimum is 2 characters)",
              "Email is invalid",
              "Password is too short (minimum is 6 characters)"
            ]
          }
        }.to_json)
      end
    end

    context 'when user already exists' do
      let(:existing_user) { User.create(name: 'newuser', email: 'newuser@example.com', password: 'password') }
      let(:duplicate_params) { { user: { name: 'newuser', email: existing_user.email, password: 'password' } } }

      it "returns a Conflict status" do
        post '/api/v1/auth/sign_up', params: duplicate_params
        expect(response).to have_http_status(:conflict)
      end

      it "returns an error message" do
        post '/api/v1/auth/sign_up', params: duplicate_params
        body = JSON.parse(response.body)
        expect(body).to include("msg", "error")
        expect(body["error"]).to include("value", "details")
      end

      it 'returns a correct JSON response' do
        post '/api/v1/auth/sign_up', params: duplicate_params
        expect(response.body).to eq({
          "msg": "Failed to create a user",
          "error": {
            "value": "User already exists",
            "details": []
          }
        }.to_json)
      end
    end
  end
end
