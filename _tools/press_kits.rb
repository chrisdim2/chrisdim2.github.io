# Φτιάχνει ένα zip Press Kit για κάθε έτοιμη εφαρμογή (ready: true στο _data/apps.yml):
#   assets/press/<εφαρμογή>-press-kit.zip
# και γράφει μέγεθος και περιεχόμενα στο _data/press_kits.yml (τα δείχνει η σελίδα /press/).
#
# Τρέξε το ξανά όταν αλλάζουν screenshots, λογότυπα ή κείμενα:
#   ruby _tools/press_kits.rb
#
# Περιεχόμενα: README (ελληνικά και αγγλικά) με περιγραφές και στοιχεία, εικονίδιο, λογότυπα,
# εικόνα κοινοποίησης και τα screenshots του site σε JPG, ανά γλώσσα και συσκευή.
# Τα βίντεο δεν μπαίνουν (είναι μεγάλα)· η σελίδα έχει ξεχωριστό σύνδεσμο.
# Χρειάζεται macOS (sips για τη μετατροπή WebP → JPG, zip).

require "yaml"
require "fileutils"
require "tmpdir"

ROOT = File.expand_path("..", __dir__)
def src(path) = File.join(ROOT, path.sub(%r{\A/}, ""))

apps = YAML.load_file(src("_data/apps.yml"))["list"].select { |a| a["ready"] }
site = YAML.load_file(src("_data/site.yml"))
langs = YAML.load_file(src("_data/languages.yml"))
press_email = site["press_email"].to_s.empty? ? site["contact_email"] : site["press_email"]
owner = site["owner_name"].to_s.empty? ? "dimakis" : site["owner_name"]
DEVICE = { "iphone" => "iPhone", "ipad" => "iPad", "mac" => "Mac", "watch" => "Apple Watch" }

out_dir = src("assets/press")
FileUtils.mkdir_p(out_dir)
summary = {}

apps.each do |app|
  slug = app["slug"]
  name = app["full_name"] || app["title"]
  folder = "#{name.gsub(/[^\w&-]+/, ' ').strip.gsub(' ', '-')}-Press-Kit"
  zip_path = File.join(out_dir, "#{slug}-press-kit.zip")
  shots = 0

  Dir.mktmpdir do |tmp|
    base = File.join(tmp, folder)
    FileUtils.mkdir_p(%W[#{base}/Icon #{base}/Logos])

    FileUtils.cp(src(app["icon"]), "#{base}/Icon/#{slug}-icon.png")
    FileUtils.cp(src(app["emblem"]), "#{base}/Logos/#{slug}-emblem.svg") if app["emblem"]
    FileUtils.cp(src(app["logo"]), "#{base}/Logos/#{slug}-logo.svg") if app["logo"]
    FileUtils.cp(src("/assets/dimakis-logo.svg"), "#{base}/Logos/dimakis-logo-light-background.svg")
    FileUtils.cp(src("/assets/dimakis-logo-dark.svg"), "#{base}/Logos/dimakis-logo-dark-background.svg")
    FileUtils.cp(src(app["og_image"]), "#{base}/#{slug}-share-1200x630.jpg") if app["og_image"]

    sc = File.exist?(src("_data/showcase/#{slug}.yml")) ? YAML.load_file(src("_data/showcase/#{slug}.yml")) : {}
    (sc["groups"] || []).reject { |g| g["video"] }.each do |g|
      { "el" => "Greek", "en" => "English" }.each do |lang, lang_dir|
        n = 0
        g["shots"].each do |s|
          next if s["only"] && s["only"] != lang
          file = lang == "en" ? (s["src_en"] || s["src"]) : s["src"]
          next unless file && File.exist?(src(file))
          n += 1
          dir = "#{base}/Screenshots/#{lang_dir}/#{g['label_en']}"
          FileUtils.mkdir_p(dir)
          out = File.join(dir, File.basename(file, ".*") + ".jpg")
          system("sips", "-s", "format", "jpeg", "-s", "formatOptions", "92", src(file), "--out", out, out: File::NULL, err: File::NULL) or abort("sips failed: #{file}")
          shots += 1
        end
      end
    end

    platforms = app["platforms"].map { |p| DEVICE[p] }
    price = ->(l) { app["price"].to_s.empty? ? (l == "el" ? "Θα ανακοινωθεί" : "To be announced") : "#{app['price']} €" }
    store = app["appstore_url"].to_s.empty? && !app["appstore_id"].to_s.empty? ? "https://apps.apple.com/app/id#{app['appstore_id']}" : app["appstore_url"].to_s
    readme = <<~TXT
      #{name}
      #{'=' * name.size}

      ΕΛΛΗΝΙΚΑ

      #{app['kind_el']}. #{app['tagline_el']}

      Σύντομη περιγραφή
      #{app['description_el']}

      Μεγάλη περιγραφή
      #{app['press_long_el'].to_s.strip}

      Developer: #{owner}
      Συσκευές: #{platforms.join(', ')}
      Γλώσσες: #{langs.size}
      Τιμή: #{price.('el')}
      Κυκλοφορία: #{app['status_el']}
      Σελίδα: https://dimakis.app/#{slug}/
      #{store.empty? ? '' : "App Store: #{store}\n"}Επικοινωνία για τύπο: #{press_email}


      ENGLISH

      #{app['kind_en']}. #{app['tagline_en']}

      Short description
      #{app['description_en']}

      Long description
      #{app['press_long_en'].to_s.strip}

      Developer: #{owner}
      Platforms: #{platforms.join(', ')}
      Languages: #{langs.size}
      Price: #{price.('en')}
      Release: #{app['status_en']}
      Website: https://dimakis.app/en/#{slug}/
      #{store.empty? ? '' : "App Store: #{store}\n"}Press contact: #{press_email}

      Apple, the Apple logo, iPhone, iPad, Mac and Apple Watch are trademarks of Apple Inc.
    TXT
    File.write("#{base}/README.txt", readme)

    FileUtils.rm_f(zip_path)
    Dir.chdir(tmp) { system("zip", "-q", "-r", "-X", zip_path, folder) or abort("zip failed") }
  end

  bytes = File.size(zip_path)
  summary[slug] = { "file" => "/assets/press/#{slug}-press-kit.zip", "bytes" => bytes, "screenshots" => shots }
  puts format("%-8s %5.1f MB  %d screenshots", slug, bytes / 1_048_576.0, shots)
end

File.write(src("_data/press_kits.yml"),
  "# Παράγεται από το _tools/press_kits.rb. Μην το αλλάζεις με το χέρι.\n" + summary.to_yaml.sub(/\A---\n/, ""))
