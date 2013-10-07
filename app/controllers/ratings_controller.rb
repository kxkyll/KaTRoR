class RatingsController <ApplicationController
    def index
        @ratings = Rating.all
        @rating_count = Rating.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ratings }
     end
    
    end

    def new
        @rating = Rating.new
        @beers = Beer.all
    end

    def create
        #rating = Rating.create params[:rating]
        @rating = Rating.new params[:rating]
        if @rating.save
            current_user.ratings << @rating
            redirect_to user_path current_user
        else
            @beers = Beer.all
            render :new
        end
        #session[:last_rating] = "#{Beer.find(params[:rating][:beer_id])} #{params[:rating][:score]} points"
        

    end

    def destroy
        rating = Rating.find params[:id]
        rating.delete if current_user == rating.user
        redirect_to :back
    end
end