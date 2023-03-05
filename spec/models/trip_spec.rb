require 'rails_helper'

RSpec.describe Trip, type: :model do
  subject do
    @user = User.create!(name: 'someone', email: 'user@user.com', password: 'password')
    @trip = Trip.create!(price: 100, rating: 5, destination_city: 'test city', description: 'test destination',
                         image: @image_file, user_id: @user.id)
  end

  before do
    @image_file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.png'), 'image/png')
    subject
  end

  context 'price' do
    it 'should be present' do
      subject.price = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Price can't be blank", 'Price is not a number')
    end

    it 'should not be less than 0' do
      subject.price = -1.1
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include('Price must be greater than or equal to 0')
    end

    it 'should be a float' do
      invalid_prices = ['a', nil]
      invalid_prices.each do |price|
        @trip.price = price
        expect(@trip).not_to be_valid
        expect(@trip.errors[:price]).to include('is not a number')
      end
    end

    it 'should be a float' do
      valid_prices = [0, 1.99, 100.00]
      valid_prices.each do |price|
        @trip.price = price
        expect(@trip).to be_valid
      end
    end
  end

  context 'rating' do
    it 'should be present' do
      subject.rating = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Rating can't be blank", 'Rating is not a number')
    end

    it 'requires a rating to be less than or equal to 5' do
      invalid_ratings = [6, 10, 100]
      invalid_ratings.each do |rating|
        @trip.rating = rating
        expect(@trip).to_not be_valid
        expect(@trip.errors[:rating]).to include('must be less than or equal to 5')
      end
    end

    it 'should to be an integer between 0 and 5' do
      valid_ratings = [0, 1, 2, 3, 4, 5]
      valid_ratings.each do |rating|
        @trip.rating = rating
        expect(@trip).to be_valid
      end
    end
  end

  context 'destination city' do
    it 'should to be present' do
      subject.destination_city = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:destination_city]).to include("can't be blank")
    end

    it 'should be between 2 and 75 characters in length' do
      invalid_cities = ['', 'a', 'A' * 76]
      invalid_cities.each do |city|
        @trip.destination_city = city
        expect(@trip).to_not be_valid
      end
    end
  end

  context 'description' do
    it 'should to be present' do
      subject.destination_city = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:destination_city]).to include("can't be blank")
    end

    it 'should be between 2 and 300 characters in length' do
      invalid_descriptions = ['', 'a', 'A' * 301]
      invalid_descriptions.each do |description|
        @trip.description = description
        expect(@trip).to_not be_valid
      end
    end
  end

  context 'image' do
    it 'should to be present' do
      subject.image = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:image]).to include("can't be blank")
    end

    it 'is valid with a correct type' do
      Trip.new(image: fixture_file_upload('test.jpg'))
      expect(subject).to be_valid
    end
  end
end
