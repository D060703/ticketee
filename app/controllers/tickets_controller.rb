class TicketsController < ApplicationController
  before_filter :find_project
  before_filter :find_ticket, :only => [:show, :edit, :update, :destroy]
  
  def new
    @ticket = @project.tickets.build
  end
#  The build method simply instantiates a new record for the tickets association on the @project object, working in much the same way as the following code would
#Ticket.new(:project_id => @project.id  

  def edit
  end

def create
  @ticket = @project.tickets.build(params[:ticket])
  if @ticket.save
    flash[:notice] = "Ticket has been created."
    redirect_to [@project, @ticket] #<- specify array - Rails determine that you want this helper: project_ticket_path(@project, @ticket), You could have been explicit and specifically used project_ticket_path in the action, but using an array is DRYer.
  else
    flash[:alert] = "Ticket has not been created."
    render :action => "new"
  end
end

def show
end

def destroy
  @ticket.destroy
  flash[:notice] = "Ticket has been deleted."
  redirect_to @project
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
end

def find_ticket
@ticket = @project.tickets.find(params[:id])
end

#Where does params[:project_id] come from? It’s made available through the wonders of Rails’s routing, just as params[:id] was.
#It’s called project_id instead of id because you could (and later will) have a route that you want to pass through an ID for a ticket as well, and that would be params[:id].
end
