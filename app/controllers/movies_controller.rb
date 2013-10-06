class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_movies = Movie.all_ratings
    if params[:ratings]
      @selected_movies = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @selected_movies = session[:ratings].keys
    end

    if params[:sort]
      session[:sort] = params[:sort]
    end

    if (!params[:ratings] and session[:ratings]) or (!params[:sort] and session[:sort])
      flash.keep
      redirect_to :sort => session[:sort], :ratings => session[:ratings]
    end

    @movies = Movie.find(:all, :conditions => ["rating IN (?)", @selected_movies], :order => [session[:sort]])
    @class = session[:sort]
    @all_ratings = Movie.all_ratings
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
