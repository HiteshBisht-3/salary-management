module Api
  module V1
    class SalariesController < ApplicationController
      before_action :set_employee

      # GET /api/v1/employees/:employee_id/salaries
      def index
        salaries = @employee.salaries.recent_first

        render json: salaries, status: :ok
      end

      # POST /api/v1/employees/:employee_id/salaries
      def create
        salary = @employee.salaries.new(salary_params)

        if salary.save
          render json: salary, status: :created
        else
          render json: {
            errors: salary.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_employee
        @employee = Employee.find(params[:employee_id])
      end

      def salary_params
        params.require(:salary).permit(
          :base_salary,
          :bonus,
          :currency,
          :effective_from
        )
      end
    end
  end
end