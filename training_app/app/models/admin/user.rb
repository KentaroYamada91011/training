# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  role            :integer          default("normal")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Admin
  class User < User; end
end
