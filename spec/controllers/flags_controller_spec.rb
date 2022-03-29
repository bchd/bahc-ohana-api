require 'rails_helper'

describe FlagsController, debt: true do
  describe "POST 'create'" do
    let(:subject) {
      post :create, params: { 
        flag: {
          resource_id: 1,
          resource_type: 'Location',
          email: 'abc@example.com',
          description: 'some text'
        }
      }
    }

    let(:dummy_loc) do
      class DummyLocation
        def name
          "dumy name"
        end
      end

      DummyLocation.new
    end

    it 'creates a flag issue' do
      stubbed_response = double("response", status: 200, body: "some data")
      allow(Faraday).to receive(:post).and_return(stubbed_response)

      expect(subject).to redirect_to root_path
      expect(subject.request.flash[:success] ).to eq('Thank you for reporting this issue! We will reach out to you shortly.')
    end

    it 'does not create a flag issue and gives an error message' do
      stubbed_response = double("response", status: 422, body: "some data")
      allow(Faraday).to receive(:post).and_return(stubbed_response)
      allow(Location).to receive(:get).and_return(dummy_loc)

      expect(subject).to render_template(:new)
      expect(subject.request.flash[:error] ).to eq('Could not report this issue! Please try after sometime.')
    end
  end
end
