require 'rails_helper'

describe ServiceUploader do
    let(:good_file_path) do
      Rails.root.join("spec", "support", "fixtures", "service_upload.csv")
    end

    let!(:good_location) do
      create(:location, id: 1)
    end

    describe 'importing' do
      it 'imports services' do
        uploader = ServiceUploader.new(good_file_path)
        services = uploader.process
        
        expect(services).to be_present

        service = services.first
        expect(service.location_id).to eq good_location.id
        expect(service.name).to eq 'New Service'
        expect(service.audience).to eq 'Everybody'
        expect(service.description).to eq 'Uploaded service'
        expect(service.eligibility).to eq 'All'
        expect(service.languages).to eq ['English', 'Spanish']
        expect(service.address_details).to eq 'red door on the left'
        expect(service.website).to eq 'https://www.google.com'
        expect(service.email).to eq 'example@sample.com'
      end

      it 'should error if the location is not found' do
        location_not_found_csv = Rails.root.join("spec", "support", "fixtures", "service_upload_location_not_found.csv")
        uploader = ServiceUploader.new(location_not_found_csv)
        
        expect { uploader.process }.to raise_error(ServiceUploader::ServiceUploadError, 'Upload unsuccessful. Location with id: -1 not found')
      end

      # it 'should error if the service has a validation error'

      it 'should update a service if it exists already' do
        uploader = ServiceUploader.new(good_file_path)
        services = uploader.process
        service = services.first
        expect(service.description).to eq 'Uploaded service'

        service.update(description: 'Description of this service')

        uploader = ServiceUploader.new(good_file_path)
        uploader.process
        expect(service.reload.description).to eq 'Uploaded service'
      end

      it 'should create tags and attach them' do
        uploader = ServiceUploader.new(good_file_path)
        services = uploader.process
        service = services.first

        expect(service.tags.map(&:name)).to include('Test')
        expect(service.tags.map(&:name)).to include('Sample')
      end

      it 'should create a contact and attach them' do
        uploader = ServiceUploader.new(good_file_path)
        services = uploader.process
        service = services.first

        # testing = Rails.root.join("spec", "support", "fixtures", "service_uploader_test.csv")
        # uploader1 = ServiceUploader.new(testing)
        # services1 = uploader.process
        # service1 = services1.first

        # # p services
        # p service.contacts
        # # p services1
        # p service1.contacts

        expect(service.contacts.map(&:name)).to include("Jaime Tester")
        expect(service.contacts.map(&:title)).to include("Dev")
        expect(service.contacts.map(&:email)).to include("jaime@test.io")
      end

      it 'update a contact and attach them' do
        uploader = ServiceUploader.new(good_file_path)
        services = uploader.process
        service = services.first
        expect(service.contacts.map(&:name)).to include("Jaime Tester")

        # service.contacts.update(description: 'Description of this service')

        # uploader = ServiceUploader.new(good_file_path)
        # uploader.process
        # expect(service.reload.description).to eq 'Uploaded service'
      end
  end
end
