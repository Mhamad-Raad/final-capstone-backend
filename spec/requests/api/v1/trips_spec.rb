RSpec.describe 'api/v1/trips', type: :request do
  path '/api/v1/trips/' do
    post('create a trip') do
      tags 'Trips'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :trip, in: :formData, schema: {
        type: :object,
        properties: {
          'trip[price]': { type: :integer },
          'trip[rating]': { type: :integer },
          'trip[destination_city]': { type: :string },
          'trip[description]': { type: :string },
          'trip[user_id]': { type: :integer },
          image: { type: :file }
        },
        required: ['trip[price]', 'trip[rating]', 'trip[destination_city]', 'trip[description]', 'image',
                   'trip[user_id]']
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 price: { type: :integer },
                 rating: { type: :integer },
                 destination_city: { type: :string },
                 description: { type: :string },
                 image_url: { type: :string }
               },
               required: ['trip']

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }

        let(:trip) do
          {
            price: 10,
            rating: 5,
            destination_city: 'Bismillah Colony',
            description: 'A coloy of Churail',
            user_id: 1,
            image: ''
          }
        end

        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 msg: { type: :string },
                 error: { type: :string }
               },
               required: ['trip']

        let(:trip) do
          {
            price: 10,
            rating: 5,
            destination_city: 'Bismillah Colony',
            description: 'A coloy of Churail',
            user_id: 1,
            image: ''
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/trips/{id}' do
    delete('delete a trip') do
      tags 'Trips'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, sxhema: {
        type: :string
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 success: { type: :string }
               },
               required: ['trip']

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }

        let(:id) do
          1
        end

        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['trip']

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }

        let(:id) do
          1
        end

        run_test!
      end
    end
  end

  path '/api/v1/trips/' do
    get('list all trips') do
      tags 'Trips'
      produces 'application/json'
      security [bearer_auth: []]

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 trips: { type: :array, items: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     price: { type: :integer },
                     rating: { type: :integer },
                     destination_city: { type: :string },
                     description: { type: :string },
                     image_url: { type: :string }
                   },
                   required: %w[id price rating destination_city description image_url]
                 } }
               },
               required: ['trips']

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }

        run_test!
      end
    end
  end

  path '/api/v1/trips/{id}' do
    get('show a trip') do
      tags 'Trips'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      security [bearer_auth: []]

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 price: { type: :integer },
                 rating: { type: :integer },
                 destination_city: { type: :string },
                 description: { type: :string },
                 image_url: { type: :string }
               },
               required: %w[id price rating destination_city description image_url]

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }
        let(:id) do
          Trip.create(price: 10, rating: 5, destination_city: 'Bismillah Colony', description: 'A coloy of Churail', user_id: 1,
                      image_url: '').id
        end

        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 msg: { type: :string },
                 error: { type: :string }
               },
               required: %w[msg error]

        let(:Authorization) { "Basic #{JSONWebToken.encode(user_id: 1)}" }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
