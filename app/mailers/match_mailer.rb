class MatchMailer < ActionMailer::Base
  default from: "Opprtunity <bill@opprtunity.com>"

  def send_match(user, target_user)

    @user = user
    @target_user = target_user

    Rails.logger.info "========= sending match to #{@user.to_yaml}"
    Rails.logger.info "========= sending match to #{@target_user.to_yaml}"

    @matching_needs = []
    for n in @user.needs
      for t_o in @target_user.offerings
      @matching_needs.push(n.name) if n.name == t_o.name
      end
    end

    @matching_offerings = []
    for o in @user.offerings
      for t_n in @target_user.needs
      @matching_offerings.push(o.name) if o.name == t_n.name
      end
    end

    mail(:to => @user.email, :subject => "Opprtunity - found a match").deliver
  end   

end