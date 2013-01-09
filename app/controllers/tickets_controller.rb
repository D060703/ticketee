class TicketsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project
  before_filter :find_ticket, :only => [:show, :edit, :update, :destroy, :watch]
  before_filter :authorize_create!, :only => [:new, :create]
  before_filter :authorize_update!, :only => [:edit, :update]
  before_filter :authorize_delete!, :only => :destroy
  
  def new
  @ticket = @project.tickets.build
  @ticket.assets.build #By building only one asset to begin with, you show users that they may upload a file. 
  end
  
#  The build method simply instantiates a new record for the tickets association on the @project object, working in much the same way as the following code would
#Ticket.new(:project_id => @project.id  

  def edit
  end
  
  def index
    respond_with(@project.tickets)
  end
  

  def create
  @ticket = @project.tickets.build(params[:ticket]) #The merge! method here is a Hash and HashWithIndifferentAccess method, which merges the provided keys into the hash and overrides any keys already specified.2
  @ticket.user = current_user
    if @ticket.save
      if can?(:tag, @project) || current_user.admin?
        @ticket.tag!(params[:tags])
      end
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket] #<- specify array - Rails determine that you want this helper: project_ticket_path(@project, @ticket), You could have been explicit and specifically used project_ticket_path in the action, but using an array is DRYer.
    else
      flash[:alert] = "Ticket has not been created."
      render :action => "new"
    end
  end
  def watch
    if @ticket.watchers.exists?(current_user)
        @ticket.watchers -= [current_user]
        flash[:notice] = "You are no longer watching this ticket."
    else
        @ticket.watchers << current_user
        flash[:notice] = "You are now watching this ticket."
      end
  redirect_to project_ticket_path(@ticket.project, @ticket)
  end


  def show
    @comment = @ticket.comments.build
    @states = State.all
  end

  def destroy
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."
    redirect_to @project
  end
  
  def search
  @tickets = @tickets.page(params[:page])
  render "projects/show"
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Tickets has not been updated"
      render :action => "edit"
    end
  end
#Remember that in this action you don’t have to find the @ticket or @project objects because a before_filter does it for the show, edit, update, and destroy actions.


private
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
       flash[:alert] = "The project you were looking for could not be found."
       redirect_to root_path
  end

  def find_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def authorize_create!
    if !current_user.admin? && cannot?("create tickets".to_sym, @project)
      flash[:alert] = "You cannot create tickets on this project."
      redirect_to @project
    end
  end

  def authorize_update!
      if !current_user.admin? && cannot?(:"edit tickets", @project)
        flash[:alert] = "You cannot edit tickets on this project."
        redirect_to @project
      end
  end

    def authorize_delete!
      if !current_user.admin? && cannot?(:"delete tickets", @project)
        flash[:alert] = "You cannot delete tickets from this project."
        redirect_to @project
      end
    end

#Where does params[:project_id] come from? It’s made available through the wonders of Rails’s routing, just as params[:id] was.
#It’s called project_id instead of id because you could (and later will) have a route that you want to pass through an ID for a ticket as well, and that would be params[:id].
end
