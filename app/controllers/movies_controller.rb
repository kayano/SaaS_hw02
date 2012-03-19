class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@sort_by ||= params[:sort]
    if params[:ratings].nil? && params[:commit]
      session[:checked_ratings] = nil
    end

    if (params[:sort].nil? && params[:ratings].nil?) &&(session[:sort_by] || session[:checked_ratings])
      redirect_to movies_path :sort => session[:sort_by], :ratings => session[:checked_ratings]
    end
    session[:sort_by] = params[:sort] if params[:sort]
    session[:checked_ratings] = params[:ratings] if params[:ratings]

    @sort_by = session[:sort_by]
    @checked_ratings = session[:checked_ratings]

    @all_ratings = Movie.get_ratings

    if @checked_ratings
      if @sort_by
        @movies = Movie.where(:rating => @checked_ratings.keys).order(@sort_by)
      else
        @movies = Movie.where(:rating => @checked_ratings.keys)
      end
    else
      if @sort_by
        @movies = Movie.order(@sort_by)
      else
        @movies = Movie.all
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
