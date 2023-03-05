require 'rails_helper'

RSpec.describe 'Trips', type: :request do
  before(:each) do
    Rails.application.routes.default_url_options[:host] = 'localhost:4000'

    post '/api/v1/auth/sign_up', params: {
      user: {
        name: 'user',
        email: 'test@example.com',
        password: 'password'
      }
    }
    post '/api/v1/auth/log_in', params: {
      user: {
        email: 'test@example.com',
        password: 'password'
      }
    }
  end

  before(:each) do
    body = JSON.parse(response.body)
    user = body['user']
    @token = body['token']
    trip_params[:user_id] = user['id']
  end

  let!(:trip) do
    Trip.create(
      price: 100,
      rating: 5,
      destination_city: 'test city',
      description: 'test description',
      image: fixture_file_upload('test.png', 'image/png'),
      user_id: User.last.id
    )
  end

  let!(:trip_params) do
    { trip:
      {
        price: 100,
        rating: 5,
        destination_city: 'test city 2',
        description: 'test description 2',
        user_id: User.last.id
      } }
  end

  let(:trip_id) { trip.id }

  describe 'GET /trips' do
    before(:each) do
      get '/api/v1/trips/', headers: { Authorization: "Bearer #{@token}" }
    end

    it 'returns a list of all trips' do
      expect(response.body).to_not be_empty
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /trips/:id' do
    before(:each) do
      get "/api/v1/trips/#{trip_id}", headers: { Authorization: "Bearer #{@token}" }
    end

    context 'when trip is present' do
      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct trip' do
        body = JSON.parse(response.body)
        expect(body['id']).to eq(trip_id)
      end
    end

    context 'when token is not present' do
      before(:each) do
        get "/api/v1/trips/#{trip_id}", headers:
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'cannot get a trip' do
        expect(response.body).to eq({
          msg: 'Unable to access token',
          error: 'Token not found'
        }.to_json)
      end
    end
  end

  describe 'POST /trips' do
    context 'with missing parameters' do
      before(:each) do
        trip_params[:trip][:price] = nil
        trip_params[:trip][:image] = nil
        post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
      end

      # rubocop:disable Lint/EmptyBlock
      it 'does not create a new trip' do
        expect do
        end.to_not change(Trip, :count)
      end
      # rubocop:enable Lint/EmptyBlock

      it 'returns a JSON response with errors' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to eq({
          price: [
            "can't be blank",
            'is not a number'
          ],
          image: [
            "can't be blank"
          ]
        }.to_json)
      end
    end

    context 'with invalid image' do
      before(:each) do
        trip_params[:trip][:image] = fixture_file_upload('text.txt', 'text/plain')
        post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
      end

      it 'does not creates a new trip' do
        expect do
          post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
        end.to_not change(Trip, :count)
      end

      it 'returns a JSON response with errors' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to eq({
          image: [
            'has an invalid content type'
          ]
        }.to_json)
      end
    end

    context 'with valid parameters' do
      before(:each) do
        trip_params[:trip][:image] = fixture_file_upload('test.png', 'image/png')
        post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
      end

      it 'creates a new trip' do
        expect do
          post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
        end.to change(Trip, :count).by(1)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with valid image' do
      before(:each) do
        trip_params[:trip][:image] = fixture_file_upload('test.png', 'image/png')
        post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
      end

      it 'creates a new trip with image attachment' do
        expect do
          post '/api/v1/trips', params: trip_params, headers: { Authorization: "Bearer #{@token}" }
        end.to change(Trip, :count).by(1)
        expect(Trip.last.image.attached?).to be true
      end

      it 'returns a JSON response with errors' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when token is not present' do
      before(:each) do
        post '/api/v1/trips', headers:
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'cannot cretae a trip' do
        expect(response.body).to eq({
          msg: 'Unable to access token',
          error: 'Token not found'
        }.to_json)
      end
    end
  end

  describe 'DELETE /trip/:id' do
    before(:each) do
      delete "/api/v1/trips/#{trip_id}", headers: { Authorization: "Bearer #{@token}" }
    end

    context 'when trip exists' do
      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to eq({
          success: 'Trip destroyed successfully'
        }.to_json)
        expect(response.body).to include('Trip destroyed successfully')
      end
    end

    context 'when trip does not exists' do
      it 'returns a not_found status' do
        delete '/api/v1/trips/999', headers: { Authorization: "Bearer #{@token}" }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        delete '/api/v1/trips/999', headers: { Authorization: "Bearer #{@token}" }
        expect(response.body).to include("Couldn't find Trip with 'id'=999")
      end
    end

    context 'when token is not present' do
      before(:each) do
        delete "/api/v1/trips/#{trip_id}", headers:
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'cannot delete a trip' do
        expect(response.body).to eq({
          msg: 'Unable to access token',
          error: 'Token not found'
        }.to_json)
      end
    end
  end
end
