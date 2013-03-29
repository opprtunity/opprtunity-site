class MatchMailer < ActionMailer::Base
  default from: "Opprtunity <info@opprtunity.com>"

  def send_match(source_user, target_user, matched_needs, matched_offerings, match_type)

    @source_user = source_user
    @target_user = target_user

    @matched_needs = matched_needs.dup
    @matched_offerings = matched_offerings.dup

    @match_type = match_type

    if @matched_needs.length > 1
      @last_matched_needs = @matched_needs.pop 
      @matched_needs = @matched_needs.join(", ") +' and '+ @last_matched_needs
    else
      @matched_needs = @matched_needs.join(", ")
    end

    if @matched_offerings.length > 1
      @last_matched_offerings = @matched_offerings.pop 
      @matched_offerings = @matched_offerings.join(", ") +' and '+ @last_matched_offerings
    else
      @matched_offerings = @matched_offerings.join(", ")
    end

    Rails.logger.info "========= sending #{@match_type} match with #{@target_user.first_name} #{@target_user.last_name} to #{@source_user.first_name} #{@source_user.last_name} (#{@source_user.email})"
    Rails.logger.info  "========= sending #{@match_type} match ... needs are #{@matched_needs} ... offerings are #{@matched_offerings}"

    if ENV['MAILER_ENABLED'].eql?('true')
      mail(:to => @source_user.email, :subject => "Opprtunity - We found a match!").deliver
    else
      Rails.logger.info  "========= MATCHING EMAIL NOT SENT OUT. MAILER IS CURRENTLY DISABLED."
    end    
  end   

  def test_mailer
    mail(:to => 'jeff@jeffdouglas.com', :subject => "Opprtunity - We found a match!").deliver
  end     

end