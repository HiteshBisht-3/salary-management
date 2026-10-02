module Api
  module V1
    class AnalyticsController < ApplicationController
      def summary
        render json: analytics.summary, status: :ok
      end

      def by_department
        render json: analytics.by_department, status: :ok
      end

      def by_country
        render json: analytics.by_country, status: :ok
      end

      private

      def analytics
        @analytics ||= SalaryAnalyticsQuery.new
      end
    end
  end
end