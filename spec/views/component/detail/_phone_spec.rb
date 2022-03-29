require 'rails_helper'

RSpec.describe 'component/detail/phone' do
  let(:test_phone) do
    OpenStruct.new(
      id: 1000,
      department: nil,
      extension: nil,
      number: test_phone_number,
      number_type: 'voice',
      vanity_number: nil,
    )
  end
  before do
    render 'component/detail/phone', phone: test_phone, show_phone_type_and_department: true
  end

  context 'when separated by dashes' do
    let(:test_phone_number) { '703-555-1212' }

    it 'will reformat the number correctly' do
      expect(rendered).to have_content('(703) 555-1212')
    end
  end

  context 'when all together' do
    let(:test_phone_number) { '7035551212' }

    it 'will reformat the number correctly' do
      expect(rendered).to have_content('(703) 555-1212')
    end
  end

  context 'when separated by dots' do
    let(:test_phone_number) { '703.555.1212' }

    it 'will reformat the number correctly' do
      expect(rendered).to have_content('(703) 555-1212')
    end
  end

  context 'when separated by spaces' do
    let(:test_phone_number) { '703 555 1212' }

    it 'will reformat the number correctly' do
      expect(rendered).to have_content('(703) 555-1212')
    end
  end

  context 'when less than 10 digits' do
    let(:test_phone_number) { '703-555-121' }

    it 'will reformat the number correctly' do
      expect(rendered).to have_content('703-555-121')
    end
  end

  context 'when more than 10 digits' do
    let(:test_phone_number) { '703-555-12123' }

    it 'will reformat the number correctly' do
      expect(rendered).to have_content('703-555-12123')
    end
  end
end
