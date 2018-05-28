class TaggedTaggablesController < ApplicationController
  before_action :set_tagged_taggable, only: [:show, :update, :destroy]

  # GET /tagged_taggables
  # GET /tagged_taggables.json
  def index
    @tagged_taggables = TaggedTaggable.all
  end

  # GET /tagged_taggables/1
  # GET /tagged_taggables/1.json
  def show
  end

  # POST /tagged_taggables
  # POST /tagged_taggables.json
  def create
    @tagged_taggable = TaggedTaggable.new(tagged_taggable_params)

    if @tagged_taggable.save
      render :show, status: :created, location: @tagged_taggable
    else
      render json: @tagged_taggable.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tagged_taggables/1
  # PATCH/PUT /tagged_taggables/1.json
  def update
    if @tagged_taggable.update(tagged_taggable_params)
      render :show, status: :ok, location: @tagged_taggable
    else
      render json: @tagged_taggable.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tagged_taggables/1
  # DELETE /tagged_taggables/1.json
  def destroy
    @tagged_taggable.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tagged_taggable
      @tagged_taggable = TaggedTaggable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tagged_taggable_params
      params.require(:tagged_taggable).permit(:tag_id, :taggable_id, :taggable_type)
    end
end
