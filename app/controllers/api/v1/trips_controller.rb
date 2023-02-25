module Api
  module V1
    class TripsController < ApiController
      def index
        trips = Trip.all
        render json: trips
      end

      def show
        trip = Trip.find(params[:id])
        render json: trip
      end

      def create
        user = User.find(params[:user_id])
        @trip = user.trips.build(trip_params)

        if @trip.save
          render json: @trip
        else
          render json: { error: 'Unable to create trip' }, status: :unprocessable_entity
        end
      end

      private

      def trip_params
        params.require(:trip).permit(:price, :rating, :destination_city, :description)
      end
    end
  end
end
