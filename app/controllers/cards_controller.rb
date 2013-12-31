class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :set_template, only:[:create]

  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.all
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    respond_to do |format|
      if !@template
        format.json { render json: {status:'Error', details:"i18> Template '#{params[:template_name]}'' not found."} }
        format.html {
          flash.now[:error] = "i18> Template '#{params[:template_name]}'' not found."
          render action: 'new' 
        }
      else
        @card = Card.new(card_create_params)
        if @card.save
          format.html { redirect_to @card, notice: 'i18> Card was successfully created.' }
          format.json { render json: @card }
        else
          format.html { render action: 'new' }
          format.json { render json: {status:'Error', details:@card.errors}} #, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_update_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render json: @card.properties }
      else
        format.html { render action: 'edit' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  private
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_create_params
      params.require(:card).permit(:template_id, :template_name, :title, :properties)
    end
    def card_update_params
      params.require(:card).permit(:title, :properties)
    end
    def set_template
      if params[:template_name]
        @template = Template.find_by_name(params[:template_name])
        params[:card][:template_id] = @template.id if @template
      end
    end
end