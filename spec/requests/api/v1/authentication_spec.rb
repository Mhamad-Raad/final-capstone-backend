require 'swagger_helper'

RSpec.describe 'api/v1/authentication', type: :request do

  path '/api/v1/auth/sign_up' do

    post('signup authentication') do
      tags 'Users'
      consumes 'application/json'
      security [ bearer_auth: [] ]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user:  {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string, format: :email },
              password: { type: :string }
            },
            required: [ 'name', 'email', 'password' ]
          }
        },
        required: [ 'user' ]
      }

      response '200', 'user signed up' do
        schema type: :object,
          properties: {
            token: { type: :string },
            exp: { type: :string },
            user: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                email: { type: :string, format: :email }
              },
              required: [ 'name', 'email' ]
            }
          },
        required: [ 'token', 'user' ]
        
        let(:user) { { name: 'user', email: 'user@test.com', password: '123456' } }
        run_test!
      end

      response '409', 'user already exists' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            error: { 
              type: :object,
              properties: {
                value: { type: :string },
                details: { type: :array, items: { type: 'string' } }
              },
              required: [ 'value', 'details' ]
            }
          },
        required: [ 'msg', 'error' ]

        let(:user) { { name: 'user', email: 'user@test.com', password: '123456' } }
        run_test!
      end
      
      response '422', 'account creation failed validation error' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            error: { 
              type: :object,
              properties: {
                value: { type: :string },
                details: { type: :array, items: { type: 'string' } }
              },
              required: [ 'value', 'details' ]
            }
          },
        required: [ 'msg', 'error' ]

        let(:user) { { name: 'user', password: '123456' } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/log_in' do
    post('login authentication') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user:  {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string }
            },
            required: [ 'email', 'password' ]
          }
        },
        required: [ 'user' ]
      }

      response(200, 'successful') do
        schema type: :object,
          properties: {
            token: { type: :string },
            exp: { type: :string },
            user: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                email: { type: :string, format: :email }
              },
              required: [ 'name', 'email' ]
            }
          },
        required: [ 'token', 'user' ]
        
        let(:user) { { email: 'user@test.com', password: '123456' } }
        run_test!
      end

      response '401', 'email is incorrect' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            error: { 
              type: :object,
              properties: {
                value: { type: :string },
                details: { type: :array, items: { type: 'string' } }
              },
              required: [ 'value', 'details' ]
            }
          },
        required: [ 'msg', 'error' ]

        let(:user) { { email: 'user@test.com', password: '123456' } }
        run_test!
      end

      response '401', 'password is incorrect' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            error: { 
              type: :object,
              properties: {
                value: { type: :string },
                details: { type: :array, items: { type: 'string' } }
              },
              required: [ 'value', 'details' ]
            }
          },
        required: [ 'msg', 'error' ]

        let(:user) { { email: 'user@test.com', password: '123456' } }
        run_test!
      end
    end
  end
end
