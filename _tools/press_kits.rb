# Φτιάχνει τα zip του Press Kit, ένα ανά έτοιμη εφαρμογή (ready: true) και γλώσσα (el, en),
# με τα πρωτότυπα σε πλήρη ανάλυση από τους φακέλους Marketing των εφαρμογών (~/Developer/...).
#
#   ruby _tools/press_kits.rb            # φτιάχνει τα zip στο ~/Library/Caches/dimakis-press-kits/
#   ruby _tools/press_kits.rb --upload   # και τα ανεβάζει στο GitHub Release «press-kit» (χρειάζεται gh)
#
# Τα zip είναι μεγάλα (δεκάδες MB), γι' αυτό φιλοξενούνται στο GitHub Release και όχι στο repo.
# Οι σύνδεσμοι μένουν ίδιοι σε κάθε νέο ανέβασμα. Μεγέθη και πλήθος εικόνων γράφονται στο
# _data/press_kits.yml, που διαβάζει η σελίδα /press/.
#
# Περιεχόμενα: README (ελληνικά και αγγλικά), εικονίδιο 1024 (φωτεινό και σκούρο όπου υπάρχει),
# λογότυπα SVG, εικόνα κοινοποίησης και screenshots: «App Store» (με λεζάντες) και «Plain» (σκέτα), ανά συσκευή.
# Τα screenshots πάνω από 2 MB (με φωτογραφίες) γίνονται JPG 92%, τα υπόλοιπα μένουν PNG.
# Χρειάζεται macOS (zip) και τους φακέλους των εφαρμογών δίπλα στο site.

require "yaml"
require "fileutils"
require "tmpdir"

ROOT = File.expand_path("..", __dir__)
DEV = File.expand_path("..", ROOT) # ~/Developer
REPO = "chrisdim2/chrisdim2.github.io"
TAG = "press-kit"
def src(path) = File.join(ROOT, path.sub(%r{\A/}, ""))

# Από πού παίρνει εικονίδια και screenshots κάθε εφαρμογή. {lang} = el ή en.
SOURCES = {
  "chronos" => {
    "icons" => {
      "light" => "CalendarApp/CalendarApp/Resources/Assets.xcassets/AppIcon/AppIcon.appiconset/Chronos-Blue-Light.png",
      "dark" => "CalendarApp/CalendarApp/Resources/Assets.xcassets/AppIcon/AppIcon.appiconset/Chronos-Blue-Dark.png",
    },
    "shots" => [
      ["App Store", "iPhone", "CalendarApp/Marketing/screenshots/{lang}/app-store"],
      ["App Store", "iPad", "CalendarApp/Marketing/screenshots/{lang}/ipad/app-store"],
      ["App Store", "iPad landscape", "CalendarApp/Marketing/screenshots/{lang}/ipad-landscape/app-store"],
      ["App Store", "Mac", "CalendarApp/Marketing/screenshots/{lang}/mac/app-store"],
      ["Plain", "iPhone", "CalendarApp/Marketing/screenshots/{lang}/plain"],
      ["Plain", "iPad", "CalendarApp/Marketing/screenshots/{lang}/ipad/plain"],
      ["Plain", "iPad landscape", "CalendarApp/Marketing/screenshots/{lang}/ipad-landscape/plain"],
      ["Plain", "Mac", "CalendarApp/Marketing/screenshots/{lang}/mac/plain"],
      ["Plain", "Apple Watch", "CalendarApp/Marketing/screenshots/{lang}/watch/plain"],
    ],
  },
  "apollo" => {
    "icons" => {
      "light" => "PhotoApp/PhotoApp/Assets.xcassets/AppIcon/AppIcon.appiconset/apollo-blue-L.png",
      "dark" => "PhotoApp/PhotoApp/Assets.xcassets/AppIcon/AppIcon.appiconset/apollo-blue-D.png",
    },
    "shots" => [
      ["App Store", "iPhone", "PhotoApp/Marketing/screenshots/{lang}/app-store"],
      ["App Store", "iPad", "PhotoApp/Marketing/screenshots/{lang}/ipad/app-store"],
      ["App Store", "iPad landscape", "PhotoApp/Marketing/screenshots/{lang}/ipad-landscape/app-store"],
      ["App Store", "Mac", "PhotoApp/Marketing/screenshots/{lang}/mac/app-store"],
      ["Plain", "iPhone", "PhotoApp/Marketing/screenshots/{lang}/plain"],
      ["Plain", "iPad", "PhotoApp/Marketing/screenshots/{lang}/ipad/plain"],
      ["Plain", "iPad landscape", "PhotoApp/Marketing/screenshots/{lang}/ipad-landscape/plain"],
      ["Plain", "Mac", "PhotoApp/Marketing/screenshots/{lang}/mac/plain"],
    ],
  },
  "iris" => {
    "icons" => { "light" => "EXIFeditor/EXIFeditor/Assets.xcassets/AppIcon.appiconset/Iris-1024.png" },
    "shots" => [
      ["App Store", "Mac", "EXIFeditor/Marketing/Screenshots/out/{lang}"],
      # Τα σκέτα του Iris είναι σε έναν φάκελο με πρόθεμα γλώσσας (el-1-overview.png).
      ["Plain", "Mac", "EXIFeditor/Marketing/Screenshots/raw", "{lang}-"],
    ],
  },
}

upload = ARGV.include?("--upload")
apps = YAML.load_file(src("_data/apps.yml"))["list"].select { |a| a["ready"] }
site = YAML.load_file(src("_data/site.yml"))
langs = YAML.load_file(src("_data/languages.yml"))
press_email = site["press_email"].to_s.empty? ? site["contact_email"] : site["press_email"]
owner = site["owner_name"].to_s.empty? ? "dimakis" : site["owner_name"]
DEVICE = { "iphone" => "iPhone", "ipad" => "iPad", "mac" => "Mac", "watch" => "Apple Watch" }

# Εκτός ~/Developer: ο φάκελος συγχρονίζεται με cloud, που «μπερδεύεται» με μεγάλα αρχεία που ξαναγράφονται.
out_dir = File.join(Dir.home, "Library/Caches/dimakis-press-kits")
FileUtils.mkdir_p(out_dir)
summary = {}
built = []

def readme(app, name, owner, langs, press_email)
  platforms = app["platforms"].map { |p| DEVICE[p] }.join(", ")
  price = ->(l) { app["price"].to_s.empty? ? (l == "el" ? "Θα ανακοινωθεί" : "To be announced") : "#{app['price']} €" }
  store = app["appstore_url"].to_s.empty? && !app["appstore_id"].to_s.empty? ? "https://apps.apple.com/app/id#{app['appstore_id']}" : app["appstore_url"].to_s
  store_line = store.empty? ? "" : "App Store: #{store}\n"
  <<~TXT
    #{name}
    #{'=' * name.size}

    ΕΛΛΗΝΙΚΑ

    #{app['kind_el']}. #{app['tagline_el']}

    Σύντομη περιγραφή
    #{app['description_el']}

    Μεγάλη περιγραφή
    #{app['press_long_el'].to_s.strip}

    Developer: #{owner}
    Συσκευές: #{platforms}
    Γλώσσες: #{langs.size}
    Τιμή: #{price.('el')}
    Κυκλοφορία: #{app['status_el']}
    Σελίδα: https://dimakis.app/#{app['slug']}/
    #{store_line}Επικοινωνία για τύπο: #{press_email}

    Screenshots: «App Store» = με λεζάντες, όπως στο App Store. «Plain» = χωρίς κείμενο.


    ENGLISH

    #{app['kind_en']}. #{app['tagline_en']}

    Short description
    #{app['description_en']}

    Long description
    #{app['press_long_en'].to_s.strip}

    Developer: #{owner}
    Platforms: #{platforms}
    Languages: #{langs.size}
    Price: #{price.('en')}
    Release: #{app['status_en']}
    Website: https://dimakis.app/en/#{app['slug']}/
    #{store_line}Press contact: #{press_email}

    Screenshots: "App Store" = with captions, as on the App Store. "Plain" = no text.

    Apple, the Apple logo, iPhone, iPad, Mac and Apple Watch are trademarks of Apple Inc.
  TXT
end

apps.each do |app|
  slug = app["slug"]
  cfg = SOURCES[slug] or abort("Λείπει το SOURCES[#{slug}] στο script")
  name = app["full_name"] || app["title"]
  summary[slug] = {}

  { "el" => "Greek", "en" => "English" }.each do |lang, lang_name|
    folder = "#{name.gsub(/[^\w&-]+/, ' ').strip.gsub(' ', '-')}-Press-Kit-#{lang.upcase}"
    file = "#{slug}-press-kit-#{lang}.zip"
    zip_path = File.join(out_dir, file)
    shots = 0

    Dir.mktmpdir do |tmp|
      base = File.join(tmp, folder)
      FileUtils.mkdir_p(%W[#{base}/Icon #{base}/Logos])
      cfg["icons"].each do |kind, path|
        suffix = kind == "light" ? "" : "-#{kind}"
        FileUtils.cp(File.join(DEV, path), "#{base}/Icon/#{slug}-icon-1024#{suffix}.png")
      end
      FileUtils.cp(src(app["emblem"]), "#{base}/Logos/#{slug}-emblem.svg") if app["emblem"]
      FileUtils.cp(src(app["logo"]), "#{base}/Logos/#{slug}-logo.svg") if app["logo"]
      FileUtils.cp(src("/assets/dimakis-logo.svg"), "#{base}/Logos/dimakis-logo-light-background.svg")
      FileUtils.cp(src("/assets/dimakis-logo-dark.svg"), "#{base}/Logos/dimakis-logo-dark-background.svg")
      FileUtils.cp(src(app["og_image"]), "#{base}/#{slug}-share-1200x630.jpg") if app["og_image"]

      cfg["shots"].each do |kind, device, dir, prefix|
        d = File.join(DEV, dir.gsub("{lang}", lang))
        pre = prefix.to_s.gsub("{lang}", lang)
        files = Dir.glob(File.join(d, "#{pre}*.png")).sort
        next if files.empty?
        dest = "#{base}/Screenshots/#{kind}/#{device}"
        FileUtils.mkdir_p(dest)
        files.each do |f|
          out = File.join(dest, File.basename(f).delete_prefix(pre))
          # Screenshots με φωτογραφίες (π.χ. Apollo) βγαίνουν PNG 3-5 MB: σε JPG 92% δεν φαίνεται διαφορά.
          if File.size(f) > 2_000_000
            system("sips", "-s", "format", "jpeg", "-s", "formatOptions", "92", f, "--out", out.sub(/\.png\z/, ".jpg"),
              out: File::NULL, err: File::NULL) or abort("sips failed: #{f}")
          else
            FileUtils.cp(f, out)
          end
        end
        shots += files.size
      end

      File.write("#{base}/README.txt", readme(app, name, owner, langs, press_email))
      FileUtils.rm_f(zip_path)
      Dir.chdir(tmp) { system("zip", "-q", "-r", "-X", zip_path, folder) or abort("zip failed") }
    end

    bytes = File.size(zip_path)
    summary[slug][lang] = {
      "file" => "https://github.com/#{REPO}/releases/download/#{TAG}/#{file}",
      "bytes" => bytes, "screenshots" => shots,
    }
    built << zip_path
    puts format("%-8s %s %6.1f MB  %3d screenshots", slug, lang, bytes / 1_048_576.0, shots)
  end
end

File.write(src("_data/press_kits.yml"),
  "# Παράγεται από το _tools/press_kits.rb. Μην το αλλάζεις με το χέρι.\n" + summary.to_yaml.sub(/\A---\n/, ""))

if upload
  unless system("gh", "release", "view", TAG, "--repo", REPO, out: File::NULL, err: File::NULL)
    system("gh", "release", "create", TAG, "--repo", REPO, "--title", "Press Kit",
      "--notes", "Press Kit των εφαρμογών του dimakis. Δες https://dimakis.app/press/") or abort("gh release create failed")
  end
  system("gh", "release", "upload", TAG, *built, "--repo", REPO, "--clobber") or abort("gh release upload failed")
  puts "Ανέβηκαν στο https://github.com/#{REPO}/releases/tag/#{TAG}"
end
