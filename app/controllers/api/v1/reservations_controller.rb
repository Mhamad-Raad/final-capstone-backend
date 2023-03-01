class Api::V1::ReservationsController < Api::ApiController
  def index
    @reservations = Reservation.where(user_id: @current_user.id)
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