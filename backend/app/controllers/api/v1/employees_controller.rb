module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: %i[show update destroy]

      # GET /api/v1/employees
      def index
        employees = Employee.order(created_at: :desc)

        render json: employees, status: :ok
      end

      # GET /api/v1/employees/:id
      def show
        render json: @employee, status: :ok
      end

      # POST /api/v1/employees
      def create
        employee = Employee.new(employee_params)

        if employee.save
          render json: employee, status: :created
        else
          render json: {
            errors: employee.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/employees/:id
      def update
        if @employee.update(employee_params)
          render json: @employee, status: :ok
        else
          render json: {
            errors: @employee.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/employees/:id
      def destroy
        @employee.destroy!

        head :no_content
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :employee_code,
          :first_name,
          :last_name,
          :email,
          :country,
          :department,
          :job_title,
          :joining_date
        )
      end
    end
  end
end