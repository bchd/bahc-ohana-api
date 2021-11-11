require 'rails_helper'

describe Admin::RecommendedTagsController do

  describe 'new' do
    it 'allows super admin to see new recommended tag form' do
      log_in_as_admin(:super_admin)

      get :new

      expect(response).to render_template(:new)
    end

    it 'does not allow admins to see new tag form' do
      log_in_as_admin(:admin)

      get :new

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'create' do
    it 'allows super admin to create a tag' do
      create(:tag, name: 'tag')

      log_in_as_admin(:super_admin)

      post :create, params: {
        recommended_tag: {
          name: 'New_Tag',
          tag_list: ['tag']
        }
      }

      expect(response).to redirect_to admin_recommended_tags_path
    end

    it 'does not allow admins to create a tag' do
      log_in_as_admin(:admin)

      post :create, params: {
        recommended_tag: {
          name: 'New_Tag',
          tag_list: ['tag']
        }
      }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'edit' do
    let(:tag) { create(:tag, name: 'tag') }
    let(:recommended_tag) { create(:recommended_tag, tag_list: ['tag']) }

    it 'allows super admin to see the edit tag form' do
      log_in_as_admin(:super_admin)

      get :edit, params: { id: recommended_tag.id }

      expect(response).to render_template(:edit)
    end

    it 'does not allow admins to see the edit tag form' do
      log_in_as_admin(:admin)

      get :edit, params: { id: recommended_tag.id }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'update' do
    let(:tag) { create(:tag, name: 'tag') }
    let(:recommended_tag) { create(:recommended_tag, tag_list: ['tag']) }

    it 'allows super admin to Edit a tag' do
      log_in_as_admin(:super_admin)

      post :update, params: { id: recommended_tag.id, recommended_tag: { name: 'Updated_tag' } }

      expect(response).to redirect_to admin_recommended_tags_path
    end

    it 'does not allow admins to edit a tag' do
      log_in_as_admin(:admin)

      post :update, params: { id: recommended_tag.id, recommended_tag: { name: 'Updated_tag' } }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'destroy' do
    let(:tag) { create(:tag, name: 'tag') }
    let(:recommended_tag) { create(:recommended_tag, tag_list: ['tag']) }

    it 'allows super admin to destroy a tag' do
      log_in_as_admin(:super_admin)

      delete :destroy, params: { id: recommended_tag.id }

      expect(response).to redirect_to admin_recommended_tags_path
    end

    it 'does not allow admins to destroy a tag' do
      log_in_as_admin(:admin)

      delete :destroy, params: { id: recommended_tag.id }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end
end
