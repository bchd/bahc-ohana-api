require 'rails_helper'

describe Admin::TagsController do

  describe 'new' do
    it 'allows super admin to see new tag form' do
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
      log_in_as_admin(:super_admin)
      post :create, params: {
        tag: {
          name: 'New_Tag'
        }
      }

      tag = Location.find_by(name: 'New_Tag')
      expect(response).to redirect_to admin_tags_path
    end

    it 'does not allow admins to create a tag' do
      log_in_as_admin(:admin)

      post :create, params: {
        tag: {
          name: 'New_Tag'
        }
      }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'edit' do
    before do
      @tag = create(:tag)
    end
    it 'allows super admin to see the edit tag form' do
      log_in_as_admin(:super_admin)

      get :edit, params: { id: @tag.id }

      expect(response).to render_template(:edit)
    end

    it 'does not allow admins to see the edit tag form' do
      log_in_as_admin(:admin)

      get :edit, params: { id: @tag.id }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'update' do
    before do
      @tag = create(:tag)
    end
    it 'allows super admin to Edit a tag' do
      log_in_as_admin(:super_admin)
      
      post :update, params: { id: @tag.id, tag: { name: 'Updated_tag' } }

      tag = Location.find_by(name: 'Updated_tag')
      expect(response).to redirect_to admin_tags_path
    end

    it 'does not allow admins to edit a tag' do
      log_in_as_admin(:admin)

      post :update, params: { id: @tag.id, tag: { name: 'Updated_tag' } }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end

  describe 'destroy' do
    before do
      @tag = create(:tag)
    end
    it 'allows super admin to destroy a tag' do
      log_in_as_admin(:super_admin)
      
      delete :destroy, params: { id: @tag.id }

      expect(response).to redirect_to admin_tags_path
    end

    it 'does not allow admins to destroy a tag' do
      log_in_as_admin(:admin)

      delete :destroy, params: { id: @tag.id }

      expect(response).to redirect_to admin_dashboard_url
      expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
    end
  end
end
