class RatingsController <ApplicationController
    def index
        @ratings = Rating.all
        @rating_count = Rating.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ratings }
     end
    
    end
end