require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:user) { create(:user) }
  let(:label) { create(:label, user: user) }

  describe '#name' do
    it 'is invalid without name' do
      label.name = nil
      expect(label).not_to be_valid
      expect(label.errors.messages[:name]).to eq ['Name must be filled in']
    end

    it 'is invalid with the same name' do
      name = label.name
      label = build(:label, name: name, user: user)
      expect(label).not_to be_valid
      expect(label.errors.messages[:name]).to eq ['The same name has already been taken']
    end

    it 'is valid even with the same name because its owner is different' do
      another = create(:user)
      name = label.name
      expect(build(:label, name: name, user: another)).to be_valid
    end
  end

  describe '#color' do
    it 'is invalid without color' do
      label.color = nil
      expect(label).not_to be_valid
      expect(label.errors.messages[:color]).to eq ['Color is required']
    end

    it 'is invalid with incompatible color notation' do
      ['rgb(0, 0, 0)', '#mmxxzz', '#nmo', 'hsla(0, 0, 0, 1)'].each do |val|
        label.color = val
        expect(label).not_to be_valid
        expect(label.errors.messages[:color]).to eq ['Only hexadecimal notation, such as #ef00b3, is supported']
      end
    end

    it 'is valid with hexadecimal notation' do
      %w[#000 #fff #ff9900 #fbdbdbaa #00aa1189].each do |val|
        label.color = val
        expect(label).to be_valid
      end
    end
  end
end
