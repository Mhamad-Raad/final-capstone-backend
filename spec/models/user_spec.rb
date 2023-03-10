require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    @user = User.create!(name: 'someone', email: 'user@user.com', password: 'password')
    @user1 = User.create(name: 'user1', email: 'user@user.com', password: 'newpassword')
    @user2 = User.create(name: 'user2', email: 'user2@user.com', password: '12345')
    @user3 = User.create(name: 'user3', email: 'user3@user.com', password: '123456')
  end

  before { subject.save }

  context 'name' do
    it 'should be present' do
      subject.name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Name can't be blank",
                                                      'Name is too short (minimum is 2 characters)')
    end

    it 'should be between 2 and 50 characters' do
      valid_names = ['John', 'Jane Doe', 'A' * 50]
      valid_names.each do |name|
        new_user = User.new(name:, email: 'test@example.com', password: 'password')
        expect(new_user).to be_valid
      end
    end
  end

  context 'email' do
    it 'should be present' do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Email can't be blank", 'Email is invalid')
    end

    it 'should be unique' do
      expect(@user1).to_not be_valid
      expect(@user1.errors[:email]).to include('has already been taken')
    end

    it 'requires a valid email format' do
      invalid_emails = ['userexample.com', 'user@', 'user']
      invalid_emails.each do |email|
        new_user = User.create(name: 'new_user', email:, password: 'new_password')
        expect(new_user).to_not be_valid
      end
    end

    it 'allows a valid email format' do
      valid_emails = ['user@example.com', 'user.name@example.com']
      valid_emails.each do |email|
        new_user = User.create(name: 'new_user', email:, password: 'new_password')
        expect(new_user).to be_valid
      end
    end
  end

  context 'password' do
    it 'password should be present' do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password can't be blank")
    end

    it 'password with at least 6 characters' do
      expect(@user2).to_not be_valid
      expect(@user2.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

    it 'allows a password with 6 or more characters' do
      expect(@user3).to be_valid
    end
  end
end
