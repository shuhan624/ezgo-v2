# frozen_string_literal: true

class Admin::RedirectRulesController < AdminController
  before_action :set_redirect_rule, only: %i[show edit update destroy sort]

  def import
    if params[:file].blank?
      redirect_to admin_redirect_rules_path, alert: I18n.t('admin.redirect_rules.index.import.choose')
      return
    end

    if RedirectRule.import(params[:file])
      redirect_to admin_redirect_rules_path, notice: I18n.t('admin.redirect_rules.index.import.success')
    else
      redirect_to admin_redirect_rules_path, alert: I18n.t('admin.redirect_rules.index.import.error')
    end
  end

  # GET /redirect_rules
  def index
    authorize RedirectRule
    @q = RedirectRule.ransack(params[:q])
    @q.sorts = ['position asc', 'updated_at desc']
    redirect_rules = @q.result
    @pagy, @redirect_rules = pagy(redirect_rules)
  end

  # GET /redirect_rules/:id
  def show; end

  # GET /redirect_rules/new
  def new
    @redirect_rule = RedirectRule.new
    authorize @redirect_rule
  end

  # GET /redirect_rules/:id/edit
  def edit; end

  # POST /redirect_rules
  def create
    @redirect_rule = RedirectRule.new(permitted_attributes(RedirectRule))
    authorize @redirect_rule

    if @redirect_rule.save
      redirect_to admin_redirect_rules_url, notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT /redirect_rules/:id
  def update
    if @redirect_rule.update(redirect_rule_params)
      redirect_to admin_redirect_rules_url, notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /redirect_rules/:id
  def destroy
    @redirect_rule.destroy
    redirect_to admin_redirect_rules_url, notice: successful_message
  end

  def sort
    @redirect_rule.insert_at(params[:to].to_i + 1) if @redirect_rule.valid?
    if !@redirect_rule.valid? || @redirect_rule.errors.present?
      render js: notify_script(:alert, @redirect_rule.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: RedirectRule, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_redirect_rule
    @redirect_rule = RedirectRule.find(params[:id])
    authorize @redirect_rule
  end

  # Only allow a list of trusted parameters through.
  def redirect_rule_params
    params.require(:redirect_rule).permit(policy(@redirect_rule).permitted_attributes)
  end
end
