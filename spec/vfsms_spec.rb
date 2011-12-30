require 'spec_helper'

describe Vfsms do
  describe "Initialization" do
  
    it "should successfully initialize with the correct version" do
      Vfsms.config(:opts => {}).should_not be_nil
    end
  end
  
  describe "Send SMS" do
    
    it "should send SMS when correct parameters" do
      Vfsms.send_sms({:from => 'JUSTBOOK', :send_to => '9880597292', :message => 'Test Message'}).should be_true
    end
  end
    
  describe "To Number validations" do
    
    it "should not send SMS without 'to' number" do 
      Vfsms.send_sms({:from => 'JUSTBOOK', :message => 'Test Message'}).should == ([false, "Phone Number is too short"])
    end
    
    it "should not send SMS when 'to' number is less than 10 integers" do 
      Vfsms.send_sms({:from => 'JUSTBOOK', :send_to => '98805', :message => 'Test Message'}).should == ([false, "Phone Number is too short"])
    end
    
    it "should not send SMS when 'to' number is more than 10 integers" do 
      Vfsms.send_sms({:from => 'JUSTBOOK', :send_to => '98805972921', :message => 'Test Message'}).should == ([false, "Phone Number is too long"])
    end
    
    it "should not send SMS when 'to' number is not numeric" do
      Vfsms.send_sms({:from => 'JUSTBOOK', :send_to => '988059729A', :message => 'Test Message'}).should == ([false, "Phone Number should be numerical value"])
    end
    
  end
  
  describe "Message validations" do
    
    it "should not send SMS without message" do
      Vfsms.send_sms({:from => 'JUSTBOOK', :send_to => '9880597292'}).should == ([false, "Message should be at least 10 characters long"])
    end
    
    it "should not send SMS if message is bigger than 200 characters" do
      Vfsms.send_sms({:from => 'JUSTBOOK', :send_to => '9880597292', :message => '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'})
        .should == ([false, "Message should be less than 200 characters long"])
    end
    
  end
end