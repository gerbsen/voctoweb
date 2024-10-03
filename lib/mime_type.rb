# frozen_string_literal: true

class MimeType
  AUDIO = %w(audio/ogg audio/mpeg audio/opus).freeze
  VIDEO = %w(video/mp4 video/ogg video/webm).freeze
  STREAM = %w(application/dash+xml application/vnd.apple.mpegurl).freeze

  PREFERRED_VIDEO = %w(video/mp4 video/webm video/ogg).freeze

  SLIDES = %w(application/pdf video/mp4).freeze
  SUBTITLE = %w(application/x-subrip text/vtt).freeze

  class << self
    def all
      (VIDEO + AUDIO + SLIDES + SUBTITLE + STREAM).uniq.freeze
    end

    def mime_type_slug(mime_type)
      humanized_mime_type(mime_type).to_param.downcase.freeze
    end

    def humanized_mime_type(mime_type)
      case mime_type
      when 'video/mp4'
        'mp4'
      when 'video/webm'
        'webm'
      when 'video/ogg'
        'ogg'
      when 'audio/mpeg'
        'mp3'
      when 'application/x-subrip'
        'srt'
      when 'text/vtt'
        'vtt'
      when 'application/dash+xml'
        'mpd'
      when 'application/vnd.apple.mpegurl'
        'hls'
      else
        mime_type.split('/'.freeze)[1]
      end
    end

    def is_video(mime_type)
      return mime_type.start_with?('video')
    end

    def is_audio(mime_type)
      return mime_type.start_with?('audio')
    end
  end

  RELEVANCE_COMPARATOR = ->(a,b) {
    if is_video(a) && ! is_video(b)
      -1
    elsif is_audio(a) && ! is_video(b) && ! is_audio(b)
      -1
    else
      a <=> b
    end
  }
end
