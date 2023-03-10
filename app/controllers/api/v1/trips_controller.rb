module Api
  module V1
    class TripsController < ApiController
      def index
        trips = Trip.all.as_json(only: %i[id price rating destination_city description],
                                 methods: [:image_url])
        render json: trips
      end

      def show
        trip = Trip.find(params[:id])
        render json: trip
      end

      def create
        @trip = Trip.new(trip_params)

        @trip.image.attach(params[:image]) if params[:image].present?

        if @trip.save
          render json: @trip.as_json(only: %i[id price rating destination_city description],
                                     methods: [:image_url])
        else
          render json: @trip.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @trip = Trip.find(params[:id])
        @reservations = Reservation.where(trip_id: @trip.id)
        @reservations.each(&:destroy)
        if @trip.destroy
          render json: { success: 'Trip destroyed successfully' }, status: :ok
        else
          render :json, { error: 'Unable to destroy a trip' }, status: :unprocessable_entity
        end
      end

      private

      def trip_params
        params.require(:trip).permit(:price, :rating, :destination_city, :description,
                                     :user_id, :image)
      end
    end
  end
end
