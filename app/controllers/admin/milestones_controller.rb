# frozen_string_literal: true

class Admin::MilestonesController < AdminController
  before_action :set_milestone, only: %i[show edit update destroy]

  # GET /milestones
  def index
    authorize Milestone
    @q = Milestone.ransack(params[:q])
    @q.sorts = 'date desc'
    milestones = @q.result
    @pagy, @milestones = pagy(milestones)
    @milestones = @milestones.decorate
  end

  # GET /milestones/:id
  def show
    @milestone = @milestone.decorate
  end

  # GET /milestones/new
  def new
    @milestone = Milestone.new
    authorize @milestone
  end

  # GET /milestones/:id/edit
  def edit; end

  # POST /milestones
  def create
    @milestone = Milestone.new(permitted_attributes(Milestone))
    authorize @milestone

    if @milestone.save
      redirect_to admin_milestone_path(@milestone), notice: successful_message
    else
      keep_images
      render :new
    end
  end

  # PATCH/PUT /milestones/:id
  def update
    if @milestone.update(milestone_params)
      redirect_to admin_milestone_path(@milestone), notice: successful_message
    else
      keep_images
      render :edit
    end
  end

  # DELETE /milestones/:id
  def destroy
    @milestone.destroy
    redirect_to admin_milestones_url, notice: successful_message
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_milestone
    @milestone = Milestone.find(params[:id])
    authorize @milestone
  end

  #without this, ActiveSupport::MessageVerifier::InvalidSignature
  def keep_images
    @milestone.attachment_changes.each do |_, change|
      if change.is_a?(ActiveStorage::Attached::Changes::CreateOne)
        change.upload
        change.blob.save
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def milestone_params
    params.require(:milestone).permit(policy(@milestone).permitted_attributes)
  end
end
