class MatchesController < ApplicationController

	# soe: should i put this in model?
	def self.update_match(user_id, target_id)
		match = Match.find_or_create_by(user_id: user_id, target_id: target_id)

		# if it is create, then mail it
		if match.new_record?
			match.save!

			@user = User.find(user_id)
			@target_user = User.find(target_id)

			# send mail to user
			mail = MatchMailer.send_match(@user, @target_user)			

			reciprocal_match = Match.find_or_create_by(target_id: user_id, user_id: target_id)

			if reciprocal_match.new_record?
				reciprocal_match.save!

				# also send mail to target user as well
				mail = MatchMailer.send_match(@target_user, @user)
			end

		end

	end

end
