FactoryGirl.define do 
	factory :user do 
		name    			  "Monty Lennie"
		email 				  "montylennie@gmail.com"
		password 			  "foobar"
		password_confirmation "foobar"
	end
end