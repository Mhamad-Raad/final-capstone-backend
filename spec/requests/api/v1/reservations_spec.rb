RSpec.describe 'api/v1/trips', type: :request do
  path '/api/v1/reservations/' do
    post 'create a reservation' do
      tags 'Reservations'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          trip_id: { type: :integer },
          user_id: { type: :integer },
          date: { type: :string },
          time: { type: :string },
          departure_city: { type: :string }
        },
        required: %w[trip_id user_id date time departure_city]
      }
      response '200', 'successful' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 trip_id: { type: :integer },
                 user_id: { type: :integer },
                 date: { type: :string },
                 time: { type: :string },
                 departure_city: { type: :string }
               },
               required: %w[id trip_id user_id date time departure_city]

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }
        let(:reservation) do
          { reservation: { trip_id: 1, user_id: 1, date: '2020-12-12', time: '12:00', departure_city: 'test city' } }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 msg: { type: :string },
                 error: { type: :string }
               },
               required: ['reservation']

        let(:reservation) do
          { reservation: { trip_id: 1, user_id: 1, date: '2020-12-12', time: '12:00', departure_city: 'test city' } }
        end
        run_test!
      end
    end

    get 'list all reservations' do
      tags 'Reservations'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'successful' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 trip_id: { type: :integer },
                 user_id: { type: :integer },
                 date: { type: :string },
                 time: { type: :string },
                 departure_city: { type: :string }
               },
               required: %w[id trip_id user_id date time departure_city]

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }
        run_test!
      end
    end
  end
end
