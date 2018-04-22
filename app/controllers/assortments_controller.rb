class AssortmentsController < ApplicationController
  before_action :set_assortment, only: [:show, :update, :destroy]

  # GET /assortments
  def index
    @assortments = Assortment.all

    render json: @assortments
  end

  # GET /assortments/1
  def show
    render json: @assortment
  end

  # POST /assortments
  def create
    @assortment = Assortment.new(assortment_params)

    if @assortment.save
      render json: @assortment, status: :created, location: @assortment
    else
      render json: @assortment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /assortments/1
  def update
    if @assortment.update(assortment_params)
      render json: @assortment
    else
      render json: @assortment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /assortments/1
  def destroy
    @assortment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assortment
      @assortment = Assortment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def assortment_params
      params.require(:assortment).permit(:name, :description)
    end
end
