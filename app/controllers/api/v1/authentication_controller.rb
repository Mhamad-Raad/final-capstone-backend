class Api::V1::AuthenticationController < Api::ApiController
  def signup
    @user = User.find_by_email(signup_params[:email])
    if @user.present?
      render json:
      {
        msg: 'Failed to create a user',
        error:
        {
          value: 'User already exists',
          details: []
        }
      },
             status: :conflict
    else
      @user = User.new(signup_params)
      if @user.save
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 30.days.to_i
        render json: {
          token:,
          exp: time.strftime('%m-%d-%Y %H:%M'),
          user: {
            id: @user.id,
            name: @user.name,
            email: @user.email
          }
        }, status: :ok
      else
        render json:
        {
          msg: 'Failed to create an account',
          error:
          {
            value: 'Validation failed',
            details: @user.errors.full_messages
          }
        },
               status: :unprocessable_entity
      end
    end
  end

  def login
    @user = User.find_by_email(login_params[:email])
    if @user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 30.days.to_i
      render json: {
        token:,
        exp: time.strftime('%m-%d-%Y %H:%M'),
        user: {
          id: @user.id,
          name: @user.name,
          email: @user.email
        }
      }, status: :ok
    elsif @user
      render json:
      {
        msg: 'You are not authorize to access this account',
        error:
        {
          value: 'Password not correct',
          details: []
        }
      },
             status: :unauthorized
    else
      render json:
      {
        msg: 'You are not authorize to access this account',
        error:
        {
          value: 'Email not correct',
          details: []
        }
      },
             status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def signup_params
    params.require(:user).permit(:name, :email, :password)
  end
end
