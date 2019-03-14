require 'rails_helper'

RSpec.describe 'admin/services/forms/_categories', type: :view do
  let(:category) { create(:category) }
  let(:service) { create(:service) }
  let(:location) { create(:location) }

  before do
    create_service
    @taxonomy_ids = ['101']
    category
    render template: 'admin/services/edit'
  end

  it 'will show the services label' do
    expect(rendered).to have_content('Services')
  end

  it 'will show the situations label' do
    expect(rendered).to have_content('Situations')
  end

  it 'will show the categories' do
    expect(rendered).to have_content(category.name)
  end
end
