require 'rails_helper'

RSpec.describe 'Reservaton', type: :model do
  subject do
    @user = User.create!(name: 'someone', email: 'user@user.com', password: 'password')
    @trip = Trip.create!(price: 100, rating: 5, destination_city: "test city", description: "test destination", image: @image_file, user_id: @user.id)
    @reservation = Reservation.create!(date: "Thu, 25 Feb 2021", time: "Sat, 01 Jan 2000 12:00:00.000000000 UTC +00:00", departure_city: "San Francisco", user_id: @user.id, trip_id: @trip.id)
  end

  before do
    @image_file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.png'), 'image/png')
    subject
  end

  it 'date should be present' do
    subject.date = nil
    expect(subject).to_not be_valid
    expect(subject.errors.full_messages).to include("Date can't be blank")
  end
  
  it 'time should be present' do
    subject.time = nil
    expect(subject).to_not be_valid
    expect(subject.errors.full_messages).to include("Time can't be blank")
  end

  context "departure city" do
    it "should to be present" do
      subject.departure_city = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:departure_city]).to include("can't be blank")
    end
  
    it "should be between 2 and 75 characters in length" do
      invalid_cities = ["", "a", "A" * 76]
      invalid_cities.each do |city|
        @reservation.departure_city = city
        expect(@reservation).to_not be_valid
      end
    end
  
    it "should be between 2 and 75 characters in length" do
      invalid_cities = ["aa", "AAA", * 75]
      invalid_cities.each do |city|
        @reservation.departure_city = city
        expect(@reservation).to be_valid
      end
    end
  end
end