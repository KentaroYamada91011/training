require 'rails_helper'

RSpec.describe LogoutController, type: :request do
  describe 'DELETE /logout' do
    it 'resets session' do
      user = create(:user)
      post '/login', params: { user: { name: user.name, password: user.password } }
      expect(request.session).to include(:user_id)
      delete '/logout'
      expect(request.session).not_to include(:user_id)
    end

    it 'resets session even for a non-authenticated user' do
      delete '/logout'
      expect(request.session).not_to include(:user_id)
    end
  end
end
