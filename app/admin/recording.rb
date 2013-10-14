ActiveAdmin.register Recording do

  index do
    column :original_url
    column :filename do |recording|
      line_break_filename recording.filename
    end
    column :mime_type
    column :size
    column :length
    column :state
    column :updated_at do |recording|
      l(recording.updated_at, format: :pretty_datetime)
    end
    default_actions
  end

  form do |f|
    f.inputs "Recording Details" do
      f.input :original_url
      f.input :filename
      f.input :mime_type
      f.input :size
      f.input :length
      f.input :event
    end
    f.actions
  end

  member_action :release, :method => :put do
    recording = Recording.find(params[:id])
    #Delayed::Worker.delay_jobs = false
    recording.release!
    redirect_to :action => :show
  end

  action_item only: :show do
    if File.readable? recording.get_recording_path
      link_to 'Create Pagefile', release_admin_recording_path(recording), method: :put
    end
  end

  controller do
    def permitted_params
      params.permit recording: [:original_url, :filename, :mime_type, :size, :length, :event_id]
    end
  end

end
