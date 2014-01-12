class TemplatesController < ApplicationController

  AddPropertyParams = {
    "template" => {"id" => ""},
    "property" => {"name" => "", "type" => "", "validation" => ""}
  }

  before_action :set_template, only: [:show, :edit, :update, :destroy, :add_property, :update_property, :delete_property]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
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
    if @template
      @template.add_property actual_params["property"]
      if @template.errors.empty?
        if @template.save
          respond_to do |format|
            format.html { redirect_to @template, notice: 'Template was successfully updated.' }
            format.json { render json: json_ok_response("template", @template) }
          end
          return
        end
      end
    else
      msgs = "i18> template #{params[:id]} does not exist"
    end
    msgs = @template.errors.messages if @template
    respond_to do |format|
      format.html { render action: 'edit' }
      format.json { render json: json_error_response("template", msgs) }
    end
  end

  def update_property
    @template.update_property(template_property_params)
  end
  def delete_property
    @template.delete_property(template_property_params)
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render json: json_ok_response("template", @template) }
      else
        format.html { render action: 'new' }
        format.json { render json: json_error_response("template", details:@template.errors)}
      end
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
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id]||params[:template_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:name, :action)
    end
end
