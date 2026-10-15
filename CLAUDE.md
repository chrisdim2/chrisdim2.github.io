# dimakis.app

Το site των εφαρμογών του Χρήστου Δημάκη: Jekyll σε GitHub Pages, ελληνικά (ρίζα) και αγγλικά (`/en/`).
Ο χρήστης μιλά ελληνικά. Δουλεύει από δύο λογαριασμούς Claude, άρα **ό,τι αποφασίζεται γράφεται εδώ**,
όχι μόνο στη συζήτηση. Το πλάνο της κυκλοφορίας είναι στο `../ΠΛΑΝΟ_ΚΥΚΛΟΦΟΡΙΑΣ.md`.
Ιστορικό της πρώτης δουλειάς (8-13/10/2026): `../ΙΣΤΟΡΙΚΟ_SITE_2026-10.md`.

## Πώς δουλεύουμε

- Στην αρχή κάθε session `git pull`, στο τέλος commit. Ο ίδιος φάκελος αλλάζει και από άλλες sessions.
- Δουλειά σε νέο branch. **Push στο main μόνο με ρητή έγκριση του χρήστη**, κάθε φορά.
  Πριν από την έγκριση, προεπισκόπηση με `jekyll serve` (ρύθμιση «site» στο `.claude/launch.json`).
- Μετά το push: `gh api repos/chrisdim2/chrisdim2.github.io/pages/builds/latest` μέχρι «built», και έλεγχος στο live.
- Έλεγχος σε κινητό (375px, χωρίς οριζόντια κύλιση) και σε σκούρο θέμα.
- Ο `~/Developer` συγχρονίζεται με cloud: μεγάλα αρχεία που ξαναγράφονται βγαίνουν «[conflicted]».
  Γι' αυτό τα zip του Press Kit φτιάχνονται στο `~/Library/Caches/dimakis-press-kits/`.

## Δομή

- `_data/apps.yml`: όλες οι εφαρμογές. Πεδία: `full_name` (π.χ. «Chronos Calendar», μπαίνει στο `<title>`,
  JSON-LD, Press Kit), `description_el/en` (meta description), `status_el/en`, `ready` (εμφανίζεται στο Press Kit),
  `appstore_id`/`appstore_url`/`price` (με την κυκλοφορία), `suite` (ενότητα «N εφαρμογές σε 1»), `press_long_el/en`.
  Σχόλια στην κορυφή του αρχείου.
- `_data/site.yml`: κείμενα site, `newsletter_action` (Brevo), `social` (κενά = κρυφά), `owner_name`, `press_email`.
- `_data/showcase/<app>.yml`: screenshots και βίντεο ανά συσκευή. `only: el` = μόνο στην ελληνική σελίδα.
- `_layouts/default.html`: `<title>`, canonical, hreflang (x-default → αγγλικά), Smart App Banner, footer, κουμπί «πάνω».
- `_includes/jsonld.html`, `notify.html` (φόρμα Brevo), `press-zip.html`.
- `sitemap.xml` και `robots.txt`: δικά μας Liquid (όχι jekyll-sitemap, γιατί δεν γράφει hreflang).
- `_posts/`: άρθρα, ένα αρχείο ανά γλώσσα, με `lang`, `alt` (η άλλη γλώσσα), `app`, `permalink`.
- `admin/config.yml`: Decap CMS. Κάθε νέο πεδίο στα `_data` μπαίνει κι εδώ, αλλιώς το CMS το σβήνει.

## Κανόνες περιεχομένου

- **Ελληνικές λειτουργίες του Chronos** (γιορτές, εφημερεύοντα φαρμακεία και νοσοκομεία, τιμές φαρμάκων)
  φαίνονται μόνο με το «Μένω στην Ελλάδα» της εφαρμογής.
  - Ελληνική σελίδα: προβάλλονται κανονικά («7 εφαρμογές σε 1»), είναι δυνατό χαρτί για την Ελλάδα.
  - Αγγλική σελίδα: «5 apps in 1» και μόνο μια διακριτική γραμμή «Living in Greece? …». Όχι στην αγγλική
    περιγραφή ή στο «What it does», για να μη φαίνεται εφαρμογή μόνο για την Ελλάδα.
  - **Άρθρα: μόνο για λειτουργίες που υπάρχουν και χωρίς το «Μένω στην Ελλάδα»**, ίδια σε ελληνικά και αγγλικά.
- Άρθρα: πρώτα η λύση της Apple όπου υπάρχει, μετά η εφαρμογή, screenshot, «Μικρή συμβουλή».
  Χαρακτηριστικά μόνο από τον κώδικα, τη βοήθεια της εφαρμογής ή τις πολιτικές απορρήτου.
  Ό,τι δεν επιβεβαιώνεται (π.χ. τηλέφωνα) δεν γράφεται.

## Υπηρεσίες

- **Brevo**: λίστα #3 «dimakis.app – Ειδοποίηση κυκλοφορίας», φόρμα με double opt-in, πεδία `APP`
  (chronos, apollo, … ή all) και `LANGUAGE` (el/en). Email επιβεβαίωσης δίγλωσσο (πρότυπο #1).
  Μόνος αποστολέας `dimakis <hello@dimakis.app>`, domain επιβεβαιωμένο (DKIM, DMARC).
- **Google Search Console**: ιδιοκτησία Τομέα dimakis.app (λογαριασμός dimakis.4home@gmail.com),
  επαλήθευση με TXT στο Cloudflare (DNS), **να μη σβηστεί**. Sitemap υποβλήθηκε.
  «Σελίδα με ανακατεύθυνση» και «Εναλλακτική σελίδα με σωστή κανονική ετικέτα» είναι φυσιολογικά
  (www, http, /chronos → /chronos/).
- **GitHub Pages**: Enforce HTTPS ενεργό.
- **Press Kit**: zip ανά εφαρμογή και γλώσσα, από τα `Marketing` των εφαρμογών, στο GitHub Release «press-kit».
  Ενημέρωση: `ruby _tools/press_kits.rb --upload` (πηγές στο `SOURCES` του script).
- **Social** (Meta, Κέντρο διαχείρισης λογαριασμών, email `social@dimakis.app`):
  Instagram και Threads `dimakis.app`, σελίδα Facebook `dimakis.apps` (με «s»). Στο `site.yml` → `social`,
  εμφανίζονται στο footer και ως `sameAs` στο JSON-LD της αρχικής. Νέος λογαριασμός = νέα γραμμή εκεί.
- **GoatCounter**: στατιστικά επισκέψεων (dimakis.goatcounter.com).
- Email: `support@`, `press@`, `hello@` και ένα ανά εφαρμογή (`chronos@` κ.λπ.) στο dimakis.app.

## Με την κυκλοφορία μιας εφαρμογής

1. `_data/apps.yml`: `appstore_id` (ενεργοποιεί Smart App Banner, κουμπί App Store, JSON-LD), `price`, status.
   Η φόρμα «Ειδοποίησέ με» κρύβεται μόνη της.
2. `ruby _tools/press_kits.rb --upload` (τα README των zip παίρνουν τιμή και σύνδεσμο).
3. Brevo: καμπάνια στη λίστα #3 με φίλτρο `APP`, χωριστά για `LANGUAGE` el και en, από `hello@dimakis.app`.

## Εκκρεμότητες

- Social: όσοι λογαριασμοί ανοίξουν ακόμα (X, Bluesky, YouTube κ.λπ.) μπαίνουν στο `site.yml`.
- `owner_name` στο `site.yml` (ίδιο με το App Store): μπαίνει ως δημιουργός στο JSON-LD και στο Press Kit.
- Με την κυκλοφορία: ένδειξη «Νέο» για το Chronos στην αρχική.
- Προαιρετικά: `apple-app-site-association` για universal links.
