class ApplicationsController < ApplicationController
  def create
    application = Application.new(permitted_params)
    if application.save
      render json: application, status: :created
    else
      render json: application.errors, status: :unprocessable_entity
    end
  end

  def index
    applications = Application.all
    render json: applications
  end

  def show
    application = Application.find_by(token: params[:token])
    if application
      render json: application
    else
      render json: { error: "Application with token #{params[:token]} not found" }, status: :not_found
    end
  end
end
