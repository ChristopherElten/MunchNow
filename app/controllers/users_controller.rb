class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index

    puts "*******************  Query  ***********************"
    puts params[:num_reviews]
    puts params[:email]

    @users = User.all
    @reviews = Review.all

    if params[:email] == nil and params[:num_reviews] == nil
          puts "display all"

    elsif params[:email] != nil

      puts "testing ****** case 1"
      puts "Email search" + params[:email]

       @users = User.where(
          ["email = ?", params[:email]]
        )

       @reviews = Review.where(
          ["user_id = ?", User]
        )
       # puts @reviews.select(:reviews)

     elsif params[:email] != nil and params[:num_reviews] == nil

      puts "testing ****** case 2"
        
     elsif params[:email] == nil and params[:num_reviews] != nil

      puts "testing ****** case 3"
     end

    #  if @users != nil 
    #     @total_reviews = 0
    #     @total_users = 0
    #      @users.each do |user|
    #       @total_users+=1
    #       @reviews.each do |review|
    #         if user.id == review.user_id
    #           @total_reviews+=1
    #       end
    #     end
    #     end
    # end
  end

  # GET /users/1
  # GET /users/1.json
  def show

    @reviews = Review.all

    @reviews = Review.where(
        ["user_id = ?", @user.id]
      )

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        auto_login(@user)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
