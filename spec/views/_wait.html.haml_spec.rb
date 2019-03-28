require 'rails_helper'

RSpec.describe 'admin/services/forms/_wait', type: :view do

  before do
    create_service
    render template: 'admin/services/edit'
  end

  it 'will show the wait time label' do
    expect(rendered).to have_content('Wait Time')
  end

  it 'will show the Unknown wait time option' do
    expect(rendered).to have_content('Unknown')
  end

  it 'will show the Available Today wait time option' do
    expect(rendered).to have_content('Available Today')
  end

  it 'will show the 2-3 Day Wait wait time option' do
    expect(rendered).to have_content('2-3 Day Wait')
  end

  it 'will show the 1 Week Wait wait time option' do
    expect(rendered).to have_content('1 Week Wait')
  end
end
