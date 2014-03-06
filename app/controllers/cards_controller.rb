require 'lookups'
class CardsController < ApplicationController

  SetPropertyParams = {
    "card" => {"id" => ""},
    "property" => {"name" => "", "value" => ""}
  }
  IndexParams = {"title" => ""}
  QueryParams = {"properties" => ""}
  CreateCardParams =  {"template" => "", "title" => "", "properties" => ""}

  # before action : clean params by action
  before_action :set_card, only: [:show, :edit, :update, :destroy, :set, :get]
  before_action :set_template, only:[:create, :index]

  # GET /cards
  # GET /cards.json
  def index
    begin
      actual_params = clean_params IndexParams, params
      @cards = Lookups.cards_with_properties(actual_params)

      if @cards.empty?
        respond_err "card", Card.new, "i18> No cards found"
      else
        respond_ok "card", @cards
      end
    rescue Exception => e
      respond_err "card", Card.new, e.message
    end
  end

  # POST /cards/query
  def query
    begin
      actual_params = clean_params QueryParams, params
      puts ">>>>> #{actual_params["properties"]}"
      @cards = Lookups.cards_with_properties(actual_params["properties"])
      if @cards.empty?
        respond_err "card", Card.new, "i18> No cards found"
      else
        respond_ok "card", @cards
      end
    rescue Exception => e
      respond_err "card", Card.new, e.message
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    respond_ok "card", @card
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
    actual_params = clean_params CreateCardParams, params
    @card = Card.new(actual_params)
    if @card.save
      respond_ok "card", @card
    else
      respond_err "card", @card, @card.errors
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
    if @card.destroy
      respond_ok "card", @card
    else
      respond_err "card", @card, @card.errors
    end
  end

  private
    def set_card
      @card = Card.find_by_id(params[:id])
      respond_err "card", Card.new, "i18> Card '#{params[:id]}' not found." unless @card
    end
    def card_create_params
      params.require(:card).permit(:template, :title, :properties)
    end
    def card_update_params
      params.require(:card).permit(:title, :properties)
    end
    def set_template
      template = Template.find_by_name(params[:template_name])
      if template
        params[:template] = template
      else
        respond_err "card", Card.new, "i18> Template '#{params[:template_name]}' not found."
      end
    end
end