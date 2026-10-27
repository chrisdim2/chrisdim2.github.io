# YouTube

Κανόνας γλώσσας όπως παντού (`CLAUDE.md` → «Social»): τίτλοι και περιγραφές στα αγγλικά, και στο YouTube Studio
προσθέτουμε **μετάφραση στα ελληνικά** (Studio → Υπότιτλοι → το βίντεο → Προσθήκη γλώσσας → Ελληνικά → Τίτλος και περιγραφή).
Όποιος έχει το YouTube στα ελληνικά βλέπει αυτόματα τον ελληνικό τίτλο. Τα ελληνικά βίντεο του site
(`assets/video/*-el.mp4`) **δεν** ανεβαίνουν στο YouTube: μοιράζουν προβολές. Ανεβαίνουν απευθείας στο Facebook.

## Υλικό

| Αρχείο | Χρήση |
|---|---|
| `images/profile.png` | Εικόνα καναλιού |
| `images/youtube-banner.jpg` | Banner 2560×1440 (το περιεχόμενο στη ζώνη 1546×423, φαίνεται σε κινητό, υπολογιστή και TV) |
| `images/youtube-watermark.png` | Υδατογράφημα 150×150 (Προσαρμογή → Branding → Υδατογράφημα βίντεο, «Τέλος βίντεο») |
| `video/chronos-trailer-en.mp4`, `video/apollo-trailer-en.mp4` | Τα βίντεο του site με την τελική κάρτα «Available on the App Store»· ανεβαίνουν ΜΟΝΟ μετά την κυκλοφορία (ποτέ «Coming…» μέσα σε βίντεο, εντολή Χρήστου 27/10/2026) |
| `images/yt-thumb-*.jpg` | Μικρογραφίες 1280×720 για τους 3 οριζόντιους οδηγούς του Iris |
| `images/yt-endcard-*.png` | Τελική κάρτα 1080×1920 για τα Shorts (τα τελευταία 3″) |
| `shorts.yml` | Σενάρια των 9 Shorts: σκηνές, χρόνοι, κείμενο οθόνης, τι να εγγραφεί |
| `subtitles/*.srt` | Υπότιτλοι αγγλικά και ελληνικά για κάθε Short (`ruby _tools/social_srt.rb`) |

Τα trailer ξαναφτιάχνονται με `python3 _tools/social_trailers.py`. **Με την κυκλοφορία** κάθε εφαρμογής ανεβαίνει
ως νέο βίντεο το αρχικό `assets/video/<app>-en.mp4`, που λέει ήδη «Available on the App Store»
(το YouTube δεν αλλάζει αρχείο σε βίντεο που έχει ανέβει), και το παλιό trailer γίνεται «Ιδιωτικό».

---

## 1. Στήσιμο καναλιού

1. youtube.com με το `dimakis.4home@gmail.com` (ίδιος λογαριασμός με το Search Console) → Δημιουργία καναλιού
   → **με επωνυμία**: «dimakis». Γίνεται κανάλι επωνυμίας (Brand Account), στο οποίο μπαίνουν αργότερα διαχειριστές χωρίς κωδικό.
2. **Handle:** `@dimakisapps` (ίδιο όνομα σε όλα τα δίκτυα, απόφαση 16/10)
3. **Επαλήθευση** με τηλέφωνο: youtube.com/verify (χωρίς αυτήν δεν ανεβαίνουν μικρογραφίες).
4. **Προσαρμογή → Branding:** εικόνα, banner, υδατογράφημα.
5. **Προσαρμογή → Βασικές πληροφορίες:** περιγραφή (παρακάτω), σύνδεσμοι, email επικοινωνίας `hello@dimakis.app`.
   Εκεί και η **μετάφραση** ονόματος και περιγραφής στα ελληνικά.
6. **Ρυθμίσεις → Κανάλι:** χώρα Ελλάδα. **Προεπιλογές μεταφόρτωσης:** γλώσσα English, κατηγορία Science & Technology.
7. **Λίστες:** «Chronos», «Apollo», «Iris», «Tips».

**Περιγραφή καναλιού** (όριο 1000):

```
Apps made one at a time, by one person, in Greece.

Here: short tips, how-to guides and launch news.

Get notified on launch day: https://dimakis.app/en/
```

**Μετάφραση στα ελληνικά:**

```
Εφαρμογές φτιαγμένες μία μία, από έναν άνθρωπο, στην Ελλάδα.

Εδώ: σύντομες συμβουλές, οδηγοί και νέα για τις κυκλοφορίες.

Ειδοποίηση τη μέρα της κυκλοφορίας: https://dimakis.app/
```

**Σύνδεσμοι καναλιού:** Website `https://dimakis.app/en/` · Instagram `https://www.instagram.com/dimakisapps/` ·
Threads `https://www.threads.com/@dimakisapps` · Facebook `https://www.facebook.com/dimakisapps`

Μετά: `_data/site.yml` → `social` → YouTube: `https://www.youtube.com/@dimakisapps` (εμφανίζεται μόνο του στο footer).

---

## 2. Τα δύο trailer (ανεβαίνουν την πρώτη μέρα)

Κάθετα και κάτω από 3 λεπτά, άρα το YouTube τα δείχνει ως Shorts. Χωρίς ήχο στο αρχείο: μουσική προστίθεται στο ανέβασμα από την εφαρμογή YouTube (Ήχος)
ή στο μοντάζ, με κομμάτι από την YouTube Audio Library (ελεύθερο για χρήση).

### Chronos

**Αρχείο:** `video/chronos-trailer-en.mp4` · **Λίστα:** Chronos · **Μικρογραφία:** καρέ από το βίντεο (στα Shorts δεν ανεβαίνει δική μας)

**Τίτλος** (όριο 100):
```
Chronos: a calendar for iPhone, iPad, Mac and Apple Watch that goes beyond appointments
```
**Περιγραφή:**
```
Chronos is a calendar for iPhone, iPad, Mac and Apple Watch that goes beyond appointments. Month, week, day, year or a simple list, with each day's weather next to your events. Type what you want the way you'd say it, and it's in your calendar.

It also keeps what usually ends up scattered across notes and reminders: countdowns you can send to a friend, medication reminders with interaction checks, car service and insurance, loans, subscriptions and home maintenance. Plus widgets for your Home Screen.

Your data stays on your devices and in your own iCloud. 32 languages.

Coming soon. Get notified: https://dimakis.app/en/chronos/

#Chronos #CalendarApp #iPhoneApps
```
**Ελληνική μετάφραση τίτλου:**
```
Chronos: ημερολόγιο για iPhone, iPad, Mac και Apple Watch που δεν σταματά στα ραντεβού
```
**Ελληνική μετάφραση περιγραφής:**
```
Το Chronos είναι ημερολόγιο για iPhone, iPad, Mac και Apple Watch που δεν σταματά στα ραντεβού. Μήνας, εβδομάδα, ημέρα, έτος ή απλή λίστα, με τον καιρό κάθε ημέρας δίπλα στα γεγονότα. Γράφεις ό,τι θέλεις όπως θα το έλεγες, και μπαίνει στο ημερολόγιο.

Κρατά και όσα συνήθως σκορπίζονται σε σημειώσεις και υπενθυμίσεις: αντίστροφη μέτρηση που τη στέλνεις σε φίλο, υπενθυμίσεις φαρμάκων με έλεγχο αλληλεπιδράσεων, service και ασφάλεια αυτοκινήτου, δάνεια, συνδρομές και συντήρηση σπιτιού. Και widgets για την αρχική οθόνη.

Τα δεδομένα σου μένουν στις συσκευές σου και στο δικό σου iCloud. 32 γλώσσες.

Έρχεται σύντομα. Ειδοποίηση: https://dimakis.app/chronos/

#Chronos #CalendarApp #iPhoneApps
```

### Apollo

**Αρχείο:** `video/apollo-trailer-en.mp4` · **Λίστα:** Apollo

**Τίτλος:**
```
Apollo: your photos from pCloud, Dropbox and OneDrive as one family album
```
**Περιγραφή:**
```
Apollo is a family photo album for iPhone, iPad and Mac that doesn't copy anything. It works directly on the photos you already keep in pCloud, Dropbox, OneDrive and other services, and organises them into albums by year and on a map, using the real capture dates and locations.

Smart analysis runs on your device only: type "birds" or "sea" to find photos, let it pick the best covers and spot duplicates. Trips are detected automatically from your photos, alongside boarding passes, ferry tickets and distance and country stats.

With Family mode, everyone in the family sees the same covers, folders and trips, on the same cloud.

Coming soon. Get notified: https://dimakis.app/en/apollo/

#Apollo #PhotoAlbum #iPhoneApps
```
**Ελληνική μετάφραση τίτλου:**
```
Apollo: οι φωτογραφίες σου από pCloud, Dropbox και OneDrive σε ένα οικογενειακό άλμπουμ
```
**Ελληνική μετάφραση περιγραφής:**
```
Το Apollo είναι οικογενειακό άλμπουμ φωτογραφιών για iPhone, iPad και Mac που δεν αντιγράφει τίποτα. Δουλεύει απευθείας πάνω στις φωτογραφίες που έχεις ήδη στο pCloud, στο Dropbox, στο OneDrive και σε άλλες υπηρεσίες, και τις οργανώνει σε άλμπουμ ανά έτος και σε χάρτη, με τις πραγματικές ημερομηνίες και τοποθεσίες λήψης.

Η έξυπνη ανάλυση γίνεται μόνο μέσα στη συσκευή: γράφεις «πουλιά» ή «θάλασσα» και βρίσκει τις φωτογραφίες, διαλέγει τα καλύτερα εξώφυλλα και εντοπίζει τις διπλές. Τα ταξίδια βγαίνουν μόνα τους από τις φωτογραφίες σου, μαζί με κάρτες επιβίβασης, ακτοπλοϊκά εισιτήρια και στατιστικά χιλιομέτρων και χωρών.

Με το Family mode, όλη η οικογένεια βλέπει τα ίδια εξώφυλλα, φακέλους και ταξίδια, πάνω στο ίδιο cloud.

Έρχεται σύντομα. Ειδοποίηση: https://dimakis.app/apollo/

#Apollo #PhotoAlbum #iPhoneApps
```

---

## 3. Shorts (ένα για κάθε άρθρο)

Σενάρια στο `shorts.yml`: για κάθε σκηνή χρόνος, κείμενο οθόνης (αγγλικά), ελληνικός υπότιτλος και τι να εγγραφεί.
Εσύ κάνεις την εγγραφή οθόνης, το μοντάζ γίνεται στο iMovie ή στο CapCut (καμβάς 9:16).

**Πώς:**
1. iPhone: Κέντρο ελέγχου → Εγγραφή οθόνης. Mac: Cmd+Shift+5 → Εγγραφή επιλεγμένου τμήματος.
2. Μοντάζ ανά σκηνή του `shorts.yml`, με το κείμενο `en` πάνω στην οθόνη (μεγάλα γράμματα, στο πάνω τρίτο,
   όχι στο κάτω μέρος που καλύπτουν τα κουμπιά του YouTube).
3. Τελευταία 3″: η κάρτα `images/yt-endcard-<app>.png`.
4. Τίτλος: `title_en` του `shorts.yml`, ελληνική μετάφραση το `title_el`.
   Περιγραφή: το κείμενο Threads της αντίστοιχης ανάρτησης από το `posts.md` (έχει και τον σύνδεσμο του άρθρου).
5. Υπότιτλοι: Studio → Υπότιτλοι → Αγγλικά: `subtitles/<id>.en.srt`, Ελληνικά: `subtitles/<id>.el.srt`.
   Αν άλλαξαν οι χρόνοι στο μοντάζ, διόρθωσε τα `t` στο `shorts.yml` και `ruby _tools/social_srt.rb`.
6. Το ίδιο αρχείο ανεβαίνει και ως **Reel** στο Instagram και στο Facebook, και στο **TikTok** όταν ανοίξει.

Τα Iris είναι από Mac (οριζόντια οθόνη): στο μοντάζ κόβεται κάθετα το σημείο που αλλάζει (λίστα, χάρτης, διάλογος).

---

## 4. Οδηγοί (οριζόντια, 2 έως 4′)

Για την αναζήτηση του YouTube, με κεφάλαια (chapters: γραμμές `0:00 Τίτλος` στην περιγραφή).
Τρεις για το Iris, που έχει έτοιμες μικρογραφίες. Ίδια δομή με τα άρθρα: πρώτα η λύση της Apple, μετά το Iris.

| Μικρογραφία | Τίτλος | Κεφάλαια |
|---|---|---|
| `yt-thumb-fix-photo-dates.jpg` | How to fix wrong dates on photos on a Mac | Why dates go wrong · Apple Photos: Adjust Date and Time · Iris: dates from file names · Shift many at once · Undo |
| `yt-thumb-remove-location.jpg` | How to remove the location from photos before you share them | What a photo reveals · iPhone: share Options · Mac: Export · Iris: Clean for Privacy |
| `yt-thumb-add-location.jpg` | How to add a location to many photos at once on a Mac | Photos without location · Apple Photos: Info window · Iris: find and fill · Photos and videos · Undo |

Περιγραφή κάθε οδηγού: η περιγραφή του αντίστοιχου άρθρου (`description` στο `_posts/`), τα κεφάλαια και ο σύνδεσμος του άρθρου.

---

## 5. Πρόγραμμα

| Πότε | Τι |
|---|---|
| Στήσιμο | Κανάλι, branding, τα 2 trailer, σύνδεσμος στο `site.yml` |
| Κάθε Τρίτη, 18:00 | Ένα Short με τη σειρά του `shorts.yml` (01 έως 09), μόλις υπάρχει εγγραφή. Ίδια μέρα ως Reel |
| Νοέμβριος | Οι 3 οδηγοί του Iris, ένας ανά 10 ημέρες |
| Κυκλοφορία Chronos | Νέο ανέβασμα του αρχικού `assets/video/chronos-en.mp4` με σύνδεσμο App Store, το παλιό trailer «Ιδιωτικό», Short κυκλοφορίας |
