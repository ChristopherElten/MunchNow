class RestaurantsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  def index

    puts "*******************  Query  ***********************"
    puts params[:spec]
    puts params[:name]
    puts params[:pricerange]
    puts params[:restaurant_type]
    @restaurants = Restaurant.all


    if params[:spec] != "" and params[:pricerange] != nil and params[:restaurant_type] != nil

    puts "General Keyword search engaged w/ price range w/ restaurant type"

    @restaurants = Restaurant.where(
      ["name LIKE ? and pricerange = ? and restaurant_type = ?", "%#{params[:spec]}%", params[:pricerange], params[:restaurant_type]]
    )

    elsif params[:spec] != "" and params[:restaurant_type] != ""
      
      puts "General Keyword search engaged w/ restaurant type"

      @restaurants = Restaurant.where(
        ["name LIKE ? and restaurant_type = ?", "%#{params[:spec]}%", params[:restaurant_type]]
      )

    elsif params[:spec] != "" and params[:pricerange] != nil

      puts "General Keyword search engaged w/ price range"

      @restaurants = Restaurant.where(
        ["name LIKE ? and pricerange = ?", "%#{params[:spec]}%", params[:pricerange]]
      )

    elsif params[:spec] != ""

      puts "General Keyword search engaged"

      @restaurants = Restaurant.where(
        ["name LIKE ?", "%#{params[:spec]}%"]
      )

    # Neither price range or name
    elsif params[:pricerange] == nil and params[:name] == "" and params[:restaurant_type] ==""

      puts "no pricerange indicated. No name indicated. No restaurant_type indicated"
      puts "No filter"

    # No pricerange, name indicated
    elsif params[:pricerange] == nil and params[:name] != "" and params[:restaurant_type] ==""

      puts "no pricerange indicated, name indicated. No restaurant_type indicated"
      puts "checking name"

      @restaurants = Restaurant.where(
        ["name = ?", params[:name]]
        )
    # Pricerange indicated, no name
    elsif params[:pricerange] != nil and params[:name] == "" and params[:restaurant_type] ==""

      puts "pricerange indicated, no name indicated. no restaurant_type indicated"
      puts "checking pricerange"

      @restaurants = Restaurant.where(
        ["pricerange = ?", params[:pricerange]]
        )
    # Pricerange and name
    elsif params[:pricerange] != nil and params[:name] != "" and params[:restaurant_type] ==""

      puts "Pricerange indicated, name indicated no restaurant_type indicated"
      puts "Checking Pricerange and name"

      @restaurants = Restaurant.where(
        ["pricerange = ? and name = ?", params[:pricerange], params[:name]]  
      )

    elsif params[:pricerange] == nil and params[:name] == "" and params[:restaurant_type] !=""

      @restaurants = Restaurant.where(
        ["restaurant_type = ?", params[:restaurant_type]]
      )

    elsif params[:pricerange] != nil and params[:name] == "" and params[:restaurant_type] !=""

      @restaurants = Restaurant.where(
        ["restaurant_type = ? and pricerange = ?", params[:restaurant_type], params[:pricerange]]
      )

    end


      @restaurant_count = @restaurants.count

  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
        redirect_to @restaurant
    else
        render 'edit'
    end
  end


#todo
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path
  end

private

  def restaurant_params
    params.require(:restaurant).permit(:name, :restaurant_type, :pricerange, :description)
  end

  def not_authenticated
    redirect_to login_url, :alert => "First log in to view ↵
    this page."
  end
end
