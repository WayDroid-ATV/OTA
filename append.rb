#!/usr/bin/env ruby
require 'json'
require 'digest/sha2'

ASB_LEVEL = ARGV[0]

%w[system vendor].each do |img|
  %w[arm64 x86_64].each do |arch|
    %w[GAPPS VANILLA MAINLINE].each do |type|
      next unless File.exist?("#{img}/waydroid_tv_#{arch}/#{type}.json")

      json = JSON.load_file("#{img}/waydroid_tv_#{arch}/#{type}.json", symbolize_names: true)

      Dir["lineage-*-#{type}-waydroid_tv_#{arch}-#{img}.zip"].each do |zip|
        stat = File.stat(zip)

        json[:response].delete_if { |e| e[:filename] == zip }
        json[:response] << {
          datetime: stat.mtime.to_i,
          filename: zip,
          id:       Digest::SHA256.file(zip),
          romtype:  type,
          asb:      ASB_LEVEL,
          size:     stat.size,
          url:      "https://sourceforge.net/projects/waydroid-atv/files/images/#{img}/waydroid_tv_#{arch}/#{zip}/download",
          version:  zip[/^lineage-(.+?)-/, 1]
        }
      end

      json[:response].sort_by! { |e| - e[:datetime] }

      File.write("#{img}/waydroid_tv_#{arch}/#{type}.json", JSON.pretty_generate(json))
    end
  end
end
