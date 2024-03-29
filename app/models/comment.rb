class Comment < ActiveRecord::Base
  attr_accessible :text, :ticket_id, :user_id, :user, :state_id
  attr_accessor :tag_names
  
  after_create :set_ticket_state 
  before_create :set_previous_state
  
  after_create :creator_watches_ticket
  
  belongs_to :ticket
  belongs_to :user
  belongs_to :previous_state, :class_name => "State"
  belongs_to :state
  validates :text, :presence => true
  
  delegate :project, :to => :ticket
  
  private
  
    def set_ticket_state
      self.ticket.state = self.state
      self.ticket.save!
    end
    
    def set_previous_state
      self.previous_state = ticket.state
    end
    
    def creator_watches_ticket
      ticket.watchers << user
    end
    
end
