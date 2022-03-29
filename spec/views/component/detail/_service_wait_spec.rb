require 'rails_helper'

RSpec.describe 'component/detail/service_wait', debt: true do
  let(:service) { build(:service) }
  let(:user) { build(:user) }

  before do
    allow(view).to receive(:user_signed_in?) { true }
    render 'component/detail/service_wait', service: service
  end

  it 'will show the wait time estimate label' do
    expect(rendered).to have_content(t('service_fields.availability.service_wait_estimate'))
  end

  it 'will show the correct icon' do
    expect(rendered).to have_selector('.fa.fa-check-circle-o.available')
  end

  context "when the wait time is 'Available Today'" do
    let(:service) { build(:service, wait_time: 'Available Today') }

    before do
      render 'component/detail/service_wait', service: service
    end

    it 'will show the correct wait time' do
      expect(rendered).to have_content('Available Today')
    end
  end

  context "when the wait time is 'Next Day Service'" do
    let(:service) { build(:service, wait_time: 'Next Day Service') }

    before do
      render 'component/detail/service_wait', service: service
    end

    it 'will show the correct wait time' do
      expect(rendered).to have_content('Next Day Service')
    end
  end

  context "when the wait time is '2-3 Day Wait'" do
    let(:service) { build(:service, wait_time: '2-3 Day Wait') }

    before do
      render 'component/detail/service_wait', service: service
    end

    it 'will show the correct wait time' do
      expect(rendered).to have_content('2-3 Day Wait')
    end
  end

  context "when the wait time is '1 Week Wait'" do
    let(:service) { build(:service, wait_time: '1 Week Wait') }

    before do
      render 'component/detail/service_wait', service: service
    end

    it 'will show the correct wait time' do
      expect(rendered).to have_content('1 Week Wait')
    end
  end

  context "when the wait time is 'Unknown'" do
    let(:service) { build(:service, wait_time: 'Unknown') }

    before do
      render 'component/detail/service_wait', service: service
    end

    it 'will show the correct wait time' do
      expect(rendered).to have_content('Unknown')
    end
  end
end
