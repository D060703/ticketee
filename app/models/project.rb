class Project < ActiveRecord::Base
  
  attr_accessible :name, :description
  
  validates :name, :presence => true
  
  has_many :tickets
  
  has_many :permissions, :as => :thing

  
  def self.viewable_by(user)
      joins(:permissions).where(:permissions => { :action => "view",
                                :user_id => user.id })
  end
  
  def self.for(user)
    user.admin? ? Project : Project.viewable_by(user)
  end
  
  def last_ticket
    tickets.last
  end
  
  def title
     name
  end
   
  #The :as option on the has_many :permissions association B links your projects to the thing association on the Permission objects.
  

  #The build method is equivalent to new for the Ticket class (which you create in a moment) but associates the new object instantly with the @project object by setting a foreign key called project_id automatically
  
end



#dependent: nullify - Using this option would be helpful, for example, if you were building a tasktracking
#application and instead of projects and tickets you had users and tasks. If you
#delete a user, you may want to reassign rather than delete the tasks associated with that
#user, in which case you’d use the :dependent => :nullify option instead.