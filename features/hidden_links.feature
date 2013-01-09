Scenario: New ticket link is shown to a user with permission
Given "user@ticketee.com" can view the "TextMate 2" project
And "user@ticketee.com" can create tickets on the "TextMate 2" project
And I am signed in as "user@ticketee.com"
When I follow "TextMate 2"
Then I should see "New Ticket"
Scenario: New ticket link is hidden from a user without permission
Given "user@ticketee.com" can view the "TextMate 2" project
And I am signed in as "user@ticketee.com"
When I follow "TextMate 2"
Then I should not see the "New Ticket" link
Scenario: New ticket link is shown to admins
Given I am signed in as "admin@ticketee.com"
When I follow "TextMate 2"
Then I should see the "New Ticket" link