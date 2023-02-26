class Api::V1::ReservationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index 
    @reservations = Reservation.all
    render json: @reservations
  end

  def create
    p reservation_params
    p "hello there i am here"
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
