require 'rails_helper'

RSpec.describe 'ReservationsController', type: :request do
  before(:each) do
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

  let!(:reservation_params) do
    {
      reservation: {
        user_id: User.last.id,
        date: 'Thu, 25 Feb 2021',
        time: 'Sat, 01 Jan 2000 12:00:00.000000000 UTC +00:00',
        departure_city: 'test city',
        trip_id: Trip.last.id
      }
    }
  end

  describe 'GET /reservations' do
    before(:each) do
      get '/api/v1/reservations/', headers: { Authorization: "Bearer #{@token}" }
    end

    it 'returns a list of all reservations' do
      expect(response.body).to_not be_empty
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /reservations' do
    context 'with missing parameters' do
      before(:each) do
        reservation_params[:reservation][:date] = nil
        post '/api/v1/reservations', params: reservation_params, headers: { Authorization: "Bearer #{@token}" }
      end

      it 'does not create a new reservation' do
        expect do
        end.to_not change(Reservation, :count)
      end

      it 'returns a JSON response with errors' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include({
          error: [
            "Date can't be blank"
          ]
        }.to_json)
      end
    end

    context 'with valid parameters' do
      before(:each) do
        post '/api/v1/reservations', params: reservation_params, headers: { Authorization: "Bearer #{@token}" }
      end

      it 'creates a new reservation' do
        expect do
          post '/api/v1/reservations', params: reservation_params, headers: { Authorization: "Bearer #{@token}" }
        end.to change(Reservation, :count).by(1)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end
    end
  end
end
