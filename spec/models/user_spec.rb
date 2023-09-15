require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.create :user }

  it { is_expected.to be_valid }
  
  describe "#name" do
    before { subject.name = "a" * 51 }
    it { is_expected.not_to be_valid }

    it "requires a name" do
      subject.name = nil
      subject.valid?
      expect(subject.errors.size).to eq 1
      expect(subject.errors[:name]).to include("can't be blank")
    end
  end
  
  describe "#email" do
    subject { FactoryBot.build :user }
    before { @another_user = FactoryBot.create :user, email: "testemail@gmail.com" }
    it { is_expected.not_to be_valid}
  end

  describe "#role" do
    it "has valid role values" do
      expect(User.roles.keys).to include("user", "admin")
    end

    it "has a default role of 'user'" do
      user = User.new
      expect(user.role).to eq("user")
    end
  end

  describe "associations" do
    it "has many orders" do
      association = User.reflect_on_association(:orders)
      expect(association.macro).to eq(:has_many)
    end
  end
end
