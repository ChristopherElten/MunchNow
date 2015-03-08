class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
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
# <<<<<<< HEAD
#     @restaurant = Restaurant.update_attributes(restaurant_params)
#   end
# =======
#     @restaurant = Restaurant.find(params[:id])
# >>>>>>> d873221faeff1c38450716a24db6f335d638adcb
@restaurant = Restaurant.update_attributes(restaurant_params)
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant
    else
      render 'edit'
    end
  end


#todo
  def destroy
  end

private

  def restaurant_params
    params.require(:restaurant).permit(:name, :type, :pricerange, :description)
  end

end
