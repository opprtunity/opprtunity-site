class Api::IndustryController < Api::ApiController
  def offerings
    expose Industry.all
  end

  def needs
    expose Industry.all
  end
end
