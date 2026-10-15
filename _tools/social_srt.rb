# Υπότιτλοι .srt (αγγλικά και ελληνικά) για τα Shorts, από το _social/shorts.yml.
# Χρήση (από τη ρίζα του repo): ruby _tools/social_srt.rb
# Έξοδος: _social/subtitles/<id>.en.srt και <id>.el.srt, για ανέβασμα στο YouTube Studio → Υπότιτλοι.

require 'yaml'
require 'fileutils'

root = File.expand_path('..', __dir__)
out = File.join(root, '_social', 'subtitles')
FileUtils.mkdir_p(out)

def stamp(sec)
  ms = (sec * 1000).round
  format('%02d:%02d:%02d,%03d', ms / 3_600_000, ms / 60_000 % 60, ms / 1000 % 60, ms % 1000)
end

YAML.load_file(File.join(root, '_social', 'shorts.yml')).each do |short|
  %w[en el].each do |lang|
    srt = short['scenes'].each_with_index.map do |s, i|
      from, to = s['t']
      "#{i + 1}\n#{stamp(from)} --> #{stamp(to)}\n#{s[lang]}\n"
    end.join("\n")
    path = File.join(out, "#{short['id']}.#{lang}.srt")
    File.write(path, srt)
    puts "✓ #{path.sub(root + '/', '')}"
  end
end
