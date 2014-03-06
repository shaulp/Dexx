class TemplatesController < ApplicationController

  AddPropertyParams = {
    "template" => {"id" => ""},
    "property" => {"name" => "", "type" => "", "validation" => ""}
  }
  RemovePropertyParams = {
    "template" => {"id" => ""},
    "property" => {"name" => "", "conf_key" => ""}
  }

  before_action :set_template, only: [:show, :edit, :update, :destroy, :add_property, :update_property, :delete_property]

  # GET /templates
  # GET /templates.json
  def index
    if params[:name]
      @template = Template.find_by_name(params[:name])
      if @template
        respond_ok "template", @template
      else
        respond_err "template", Template.new, "i18> No template found"
      end
    else
      @templates = Template.all
      if !@templates.empty?
        respond_ok "template", @templates
      else
        respond_err "template", @templates, "i18> No template found"
      end
    end
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    respond_ok "template", @templates
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  def add_property
    actual_params = clean_params AddPropertyParams, params
    @template.errors.clear
    @template.add_property actual_params["property"]
    if @template.errors.empty?
      if @template.save
        respond_ok "template", @template
        return
      end
    end
    respond_err "template", @template, @template.errors.messages
  end

  def update_property
    ####!!! find action name and unite all 3 actions (add/update/delete)
    @template.update_property(template_property_params)
  end
  def delete_property
    actual_params = clean_params(RemovePropertyParams, params)
    @template.errors.clear
    @template.delete_property(actual_params["property"])
    if @template.errors.empty?
      if @template.save
        respond_ok "template", @template
        return
      end
    end
    respond_err "template", @template, @template.errors.messages
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)
    if @template.save
      respond_ok "template", @template
    else
      respond_err "template", @template, @template.errors
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    if @template.destroy
      respond_ok "template", @template
    else
      respond_err "template", @template, @template.errors
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      tid = Integer(params[:id]) rescue nil
      if tid
        @template = Template.find_by_id(tid)
      else
        @template = Template.find_by_name(params[:id])
      end
      respond_err "template", @templates, "i18> Template #{params[:id]} not found" unless @template
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:name, :action)
    end
end
