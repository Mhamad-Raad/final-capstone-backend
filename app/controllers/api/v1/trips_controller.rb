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
    end
  end
end
