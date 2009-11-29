require File.dirname(__FILE__) + '/../spec_helper'

describe FrontController do
  
  describe "index" do
    before(:each) do
      controller.stub!(:current_site => 'site1')
    end
    
    it "renders the current site" do
      controller.should_receive(:render).with(:action => 'site1', :layout => 'site1')
      get :index
    end
  end
  
  describe "#current_site" do
      
    shared_examples_for 'absent data' do
      it "returns a random site" do
        controller.should_receive(:random_site)
        controller.send(:current_site)
      end
      
      it "stores the site in your cookie" do
        random_site = mock(:random_site)
        controller.stub!(:random_site => random_site)
        controller.send(:current_site)
        controller.session[:current_site].should == random_site
      end
    end
      
    context "on a repeat visit" do
      before(:each) do
        @session = {}
        controller.stub!(:session => @session)
      end
      
      context "with a valid stored site" do
        before(:each) do
          @stored_site = mock(:stored_site)
          @session[:current_site] = @stored_site
          controller.stub!(:controller_actions => [@stored_site])
        end
        
        it "returns the stored site" do
          controller.send(:current_site).should == @stored_site
        end
      end

      context "with an invalid stored site" do
        before(:each) do
          invalid_site = mock(:invalid_site)
          @session[:current_site] = invalid_site
          controller.stub!(:controller_actions => [])
        end
        
        it_should_behave_like 'absent data'
      end

      context "with no stored site" do
        before(:each) do
          controller.stub!(:controller_actions => [])
        end
        
        it_should_behave_like 'absent data'
      end
    end
    
    context "on your first visit" do
      before(:each) do
        @session = {}
        controller.stub!(:controller_actions => [])
      end
        
      it_should_behave_like 'absent data'
    end
  end
  
  describe "#random_site" do
    before(:each) do
      valid_sites = mock(:array)
      valid_sites.stub!(:choice).and_return('site1', 'site2', 'site3')
      controller.stub!(:controller_actions => valid_sites)
    end
    
    it "selects a valid site (action) at random" do
      controller.send(:random_site).should == 'site1'
      controller.send(:random_site).should == 'site2'
      controller.send(:random_site).should == 'site3'
    end
  end
  
  describe "#controller_actions" do
    it "defers to the class's public_instance_methods" do
      FrontController.should_receive(:public_instance_methods).with(false).and_return([])
      controller.send(:controller_actions)
    end
    
    it "excludes the index" do
      FrontController.stub!(:public_instance_methods).with(false).and_return(['index', 'a_method'])
      controller.send(:controller_actions).should == ['a_method']
    end
  end
end