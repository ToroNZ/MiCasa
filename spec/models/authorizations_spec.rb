require 'rails_helper'

RSpec.describe Authorization, type: :model do
    let(:oauth_data){
    Hashie::Mash.new({
      credentials: {
        expires: true,
        expires_at: 1366644101,
        token: "AAAHuZCwF61OkBAOmLTwrhv52pZCriPnTGIasdasdasdascNhZCZApsZCSg6POZCQqolxYjnqLSVH67TaRDONx72fXXXB7N7ZBByLZCV7ldvagm"
      },
      extra: {
        raw_info: {
          bio: "I'm simply not here",
          email: "tomas@sensaway.co.nz",
          first_name: "Tomas",
          gender: "male",
          id: "547955110",
          last_name: "Maggio",
          link: "http://www.facebook.com/tomas.maggio",
          locale: "es_LA",
          name: "Tomas, Maggio",
          timezone: -3,
          updated_time: "2017-03-01T18:22:50+0000",
          username: "tomas.maggio",
          verified: true
        },
      },
      info: {
        description: "I'm simply not there",
        email: "tomas@sensaway.co.nz",
        first_name: "Tomas",
        image: "http://graph.facebook.com/547955110/picture?type:, square",
        last_name: "Maggio",
        name: "Tomas, Maggio",
        urls: {
          Facebook: "http://www.facebook.com/tomas.maggio"
        },
        verified: true
      },
      provider: "facebook",
      uid: "547955110"
    })
  }

  describe "Associations" do
    it{ is_expected.to belong_to :user }
    it{ is_expected.to belong_to :oauth_provider }
  end

  describe "Validations" do
    it{ is_expected.to validate_presence_of :oauth_provider }
    it{ is_expected.to validate_presence_of :user }
    it{ is_expected.to validate_presence_of :uid }
  end

  describe ".find_from_hash" do
    before do
      provider = create(:oauth_provider, name: oauth_data[:provider])
      @authotization = create(:authorization, oauth_provider: provider, uid: oauth_data[:uid])
      create(:authorization, oauth_provider: provider)
    end
    subject{ Authorization.find_from_hash(oauth_data) }
    it{ is_expected.to eq(@authotization) }
  end

  describe ".create_from_hash" do
    before do
      create(:oauth_provider, name: oauth_data[:provider])
    end
    subject{ Authorization.create_from_hash(oauth_data, user) }
    context "when user exists" do
      let(:user){ create(:user, email: oauth_data['info']['email']) }
      it{ is_expected.to be_persisted }
      its(:uid){ should == oauth_data['uid'] }
      its(:user){ should == user }
    end

    context "when user is new" do
      let(:user){}
      it{ is_expected.to be_persisted }
      its(:uid){ should == oauth_data['uid'] }
      its(:user){ should be_persisted }
    end
  end
end
