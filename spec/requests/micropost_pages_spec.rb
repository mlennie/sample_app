require 'spec_helper'

describe "Micropost Pages" do
  
  subject { page }

   let(:user) { FactoryGirl.create(:user) }
   before { sign_in user }

   describe "micropost creation" do 
	   	before { visit root_path }

	   	describe "with invalid information" do 

	   		it "should not create a micropost" do 
	   			expect { click_button "Post" }.should_not change(Micropost, :count)
	   		end

	   		describe "error messages" do 
	   			before { click_button "Post" }
	   			it { should have_content('error') }
	   		end
	   	end

	   	describe "with valid information" do 

	   		before { fill_in 'micropost_content', with: "Lorem ipsum" }
	   		it "should create a micropost" do 
	   			expect { click_button "Post" }.should change(Micropost, :count).by(1)
	   		end
	   	end

	   	describe "showing proper micropost count" do 
	   		before { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }

	        describe "for one micropost" do
	          specify {user.microposts.count == 1 }
	          it { should have_content('micropost') }
	        end
	        describe "for two microposts" do 
	          before { FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet") }

	          specify { user.microposts.count == 2 }
	          it { should have_content('microposts') }
	        end
	    end
	end
    	
	describe "micropost pagination" do 
      
		before { visit root_path }
		before(:all)  { 31.times { FactoryGirl.create(:micropost, user: user) } }
    	after(:all)   { Micropost.delete_all }

    	it { should have_selector('div.pagination') }

        it "should list each micropost" do 
        	Micropost.paginate(page: 1).each do |micropost|
            	page.should have_selector('li', text: micropost.content)
            end
        end
	end

	describe "micropost destruction" do 
		before { FactoryGirl.create(:micropost, user: user) }

		describe "as incorrect user" do 
			let(:wrong_user) { FactoryGirl.create(:user)}
			before do 
				sign_in wrong_user
				visit user_path(user) 
			end

			describe "should not show a delete link" do 
				it { should_not have_content('delete') }
			end
		end

		describe "as correct user" do 
			before { visit root_path }

			it "should delete a micropost" do 
				expect { click_link "delete" }.should change(Micropost, :count).by(-1)
			end
		end
	end
end














