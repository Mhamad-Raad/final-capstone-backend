class Api::V1::ReservationsController < ApplicationController
  # DEAR CoWroker is the line below this comment is needed,
  # I believe it has to do something with authentication
  # token as the name says but the code doesnt seed to work without it ????

  # skip_before_action :verify_authenticity_token

  def index
    @reservations = Reservation.find_by(user_id: current_user.id)
    render json: @reservations
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      render json: @reservation, status: :created
    else
      render json: { error: @reservation.errors.full_messages }, status: 400
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:user_id, :date, :time, :departure_city, :trip_id)
  end
end
