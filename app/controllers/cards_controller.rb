class CardsController < ApplicationController

  SetPropertyParams = {
    "card" => {"id" => ""},
    "property" => {"name" => "", "value" => ""}
  }

  before_action :set_card, only: [:show, :edit, :update, :destroy, :set, :get]
  before_action :set_template, only:[:create]

  # GET /cards
  # GET /cards.json
  def index
    if params['template'] && !params['template'].empty? 
      @cards = Card.from_template params['template']
      if @cards.empty?
        respond_err "card", Card.new, "i18> No cards found"
      else
        respond_ok "card", @cards
      end
    else
      respond_err "card", Card.new, "i18> Must specify template"
    end
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

  def set
    actual_params = clean_params SetPropertyParams, params
    @card.set actual_params["property"]["name"], actual_params["property"]["value"]
    if @card.errors.empty? && @card.save
      respond_ok "card", @card
    else
      respond_err "card", @card, @card.errors
    end
  end

  # POST /cards
  # POST /cards.json
  def create
    if !@template
      respond_err "card", Card.new, "i18> Template '#{params[:template_name]}' not found."
    else
      @card = Card.new(card_create_params)
      if @card.save
        respond_ok "card", @card
      else
        respond_err "card", @card, @card.errors
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    if @card.update(card_update_params)
      respond_ok "card", @card
    else
      respond_err "card", @card, @card.errors
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    if @card
      if @card.destroy
        respond_ok "card", @card
      else
        respond_err "card", @card, @card.errors
      end
    else
      respond_err "card", nil, "i18> Not found"
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