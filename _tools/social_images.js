// Εικόνες για τα social: εικόνα προφίλ, εξώφυλλο Facebook και αναρτήσεις 1080×1350.
// Χρήση (από τη ρίζα του repo): node _tools/social_images.js [όνομα ...]
// Χρειάζεται Playwright με Chromium και τη γραμματοσειρά Inter. Έξοδος: _social/images/.
// Κείμενο πάνω στις εικόνες μόνο στα αγγλικά (το κείμενο σε εικόνα δεν μεταφράζεται αυτόματα).

const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

const ROOT = path.resolve(__dirname, '..');
const OUT = path.join(ROOT, '_social', 'images');
const url = (p) => 'file://' + path.join(ROOT, p);

const APPS = {
  chronos: { name: 'Chronos', kind: 'Calendar', accent: '#2747B8', status: 'Coming in December' },
  apollo: { name: 'Apollo', kind: 'Family photo album', accent: '#B07D0A', status: 'Coming soon' },
  iris: { name: 'Iris', kind: 'Photo companion for Mac', accent: '#9A7240', status: 'Coming soon' },
  hestia: { name: 'Hestia', kind: 'Booking management', accent: '#3F6B4D', status: 'In development' },
  athena: { name: 'Athena', kind: 'Notes & notebooks', accent: '#5B47D6', status: 'In development' },
  argus: { name: 'Argus', kind: 'Document scanner', accent: '#4F5B67', status: 'In development' },
};
const ORDER = ['chronos', 'apollo', 'iris', 'hestia', 'athena', 'argus'];

// Αναρτήσεις: ίδια σειρά με το _social/README.md. shot: phone (κάθετο screenshot) ή mac (με crop σε px πηγής).
const POSTS = [
  { file: '01-countdown', app: 'chronos', title: 'How many days until…?',
    sub: 'Countdowns with a photo for birthdays, trips and everything you’re waiting for.',
    phone: 'assets/screens/chronos/iphone/en/chronos-iphone-08-countdown.webp' },
  { file: '02-remove-location', app: 'iris', title: 'Your photo may know where you live.',
    sub: 'Strip the location and every other trace before you share it.',
    mac: 'assets/screens/iris/mac/en/iris-mac-02-privacy.webp', crop: [600, 400, 800, 600] },
  { file: '03-trips', app: 'apollo', title: 'Your photos already know every trip.',
    sub: 'Turn them into a map, with countries and distances.',
    phone: 'assets/screens/apollo/iphone/en/apollo-iphone-09-trips.webp' },
  { file: '04-subscriptions', app: 'chronos', title: 'What do your subscriptions really cost?',
    sub: 'All of them in one list, with a reminder before every charge.',
    phone: 'assets/screens/chronos/iphone/en/chronos-iphone-12-subs.webp', shift: 660 },
  { file: '05-fix-photo-dates', app: 'iris', title: 'Your 2015 trip, filed under 2023?',
    sub: 'Fix wrong photo dates on your Mac, many at once.',
    mac: 'assets/screens/iris/mac/en/iris-mac-03-missing.webp', crop: [12, 150, 1180, 560], scale: 0.95 },
  { file: '06-cloud-albums', app: 'apollo', title: 'Your cloud photos, as a real album.',
    sub: 'pCloud, Dropbox, OneDrive or a NAS. Nothing is copied.',
    phone: 'assets/screens/apollo/iphone/en/apollo-iphone-01-timeline.webp' },
  { file: '07-car-reminders', app: 'chronos', title: 'Never miss a car inspection again.',
    sub: 'Service, insurance, tyres: a reminder and a full history for each.',
    phone: 'assets/screens/chronos/iphone/en/chronos-iphone-13-car.webp' },
  { file: '08-add-location', app: 'iris', title: 'Photos missing from the map?',
    sub: 'Give hundreds of them a location in one go, on your Mac.',
    mac: 'assets/screens/iris/mac/en/iris-mac-04-location.webp', crop: [720, 700, 1020, 550] },
  { file: '09-family-album', app: 'apollo', title: 'A family photo album, without iCloud.',
    sub: 'On the cloud your family already shares.',
    phone: 'assets/screens/apollo/iphone/en/apollo-iphone-08-albums.webp' },
];

const BASE_CSS = `
  *{box-sizing:border-box;margin:0;padding:0}
  html,body{background:#101820}
  body{font-family:"Inter Display","Inter","Helvetica Neue",Arial,sans-serif;color:#EDF1EE;
    -webkit-font-smoothing:antialiased;overflow:hidden;position:relative}
  .glow{position:absolute;inset:0;pointer-events:none}
`;

const head = (w, h, css) => `<!doctype html><html><head><meta charset="utf-8">
  <style>${BASE_CSS} body{width:${w}px;height:${h}px} ${css}</style></head><body>`;

function profile() {
  return head(1080, 1080, `
    .glow{background:radial-gradient(circle at 50% 46%,rgba(199,42,44,.22),rgba(16,24,32,0) 58%)}
    img{position:absolute;left:50%;top:50%;width:560px;height:560px;transform:translate(-50%,-50%)}
  `) + `<div class="glow"></div><img src="${url('assets/dimakis-strawberry.svg')}"></body></html>`;
}

function cover() {
  const icons = ORDER.map((k) => `<img src="${url(`assets/icons/${k}.png`)}" alt="">`).join('');
  return head(1640, 624, `
    .glow{background:radial-gradient(ellipse at 50% 30%,rgba(199,42,44,.16),rgba(16,24,32,0) 60%)}
    .in{position:absolute;left:50%;top:0;bottom:0;width:1060px;transform:translateX(-50%);
      display:flex;flex-direction:column;align-items:center;justify-content:center;gap:30px;padding-bottom:20px}
    .logo{height:110px;width:auto}
    p{font-family:"Inter";font-size:34px;font-weight:500;color:#A7B4BB;letter-spacing:-.01em}
    .icons{display:flex;gap:26px;margin-top:6px}
    .icons img{width:84px;height:84px;border-radius:19px;box-shadow:0 6px 20px rgba(0,0,0,.5)}
  `) + `<div class="glow"></div><div class="in">
    <img class="logo" src="${url('assets/dimakis-logo-dark.svg')}">
    <p>Apps for iPhone, iPad, Mac and Apple Watch</p>
    <div class="icons">${icons}</div></div></body></html>`;
}

function intro() {
  const cards = ORDER.map((k) => {
    const a = APPS[k];
    // Χρυσά εμβλήματα (ίδια με το εξώφυλλο Facebook και το banner YouTube), όχι τα έγχρωμα εικονίδια.
    return `<div class="card"><div class="emb"><img src="${url(`assets/logos/${k}-emblem.svg`)}"></div>
      <b>${a.name}</b><span>${a.kind}</span><i>${a.status}</i></div>`;
  }).join('');
  return head(1080, 1350, `
    .glow{background:radial-gradient(circle at 20% 8%,rgba(199,42,44,.20),rgba(16,24,32,0) 50%)}
    .top{position:absolute;left:80px;top:84px}
    .top img{height:62px}
    h1{position:absolute;left:80px;right:80px;top:200px;font-size:84px;line-height:1.04;font-weight:600;letter-spacing:-.03em;text-wrap:balance}
    .sub{position:absolute;left:80px;right:80px;top:400px;font-family:"Inter";font-size:34px;line-height:1.35;color:#A7B4BB;text-wrap:balance}
    .grid{position:absolute;left:80px;right:80px;top:560px;display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
    .card{background:#1A2831;border:1px solid rgba(237,241,238,.10);border-radius:30px;padding:30px 26px;
      display:flex;flex-direction:column;align-items:flex-start;gap:6px;height:330px}
    .card .emb{width:104px;height:104px;border-radius:24px;margin-bottom:16px;display:flex;align-items:center;justify-content:center;
      background:radial-gradient(circle at 50% 35%,#1F2B38,#121A23);box-shadow:0 6px 18px rgba(0,0,0,.45),inset 0 0 0 1px rgba(233,202,136,.10)}
    .card .emb img{width:76px;height:76px}
    .card b{font-size:36px;font-weight:600;letter-spacing:-.02em}
    .card span{font-family:"Inter";font-size:22px;color:#A7B4BB;line-height:1.25}
    .card i{font-style:normal;font-family:"Inter";font-size:19px;font-weight:600;color:#E9CA88;margin-top:auto}
  `) + `<div class="glow"></div>
    <div class="top"><img src="${url('assets/dimakis-logo-dark.svg')}"></div>
    <h1>Apps for iPhone, iPad, Mac and Apple Watch.</h1>
    <p class="sub">Made in Greece, for everyone. Each app speaks 32 languages.</p>
    <div class="grid">${cards}</div></body></html>`;
}

function post(p) {
  const a = APPS[p.app];
  let device;
  if (p.phone) {
    // shift: πόσα px της πηγής (πλάτος 780) κρύβονται από πάνω, για να φανεί το κάτω μέρος της οθόνης.
    const top = p.shift ? `style="margin-top:${-Math.round(p.shift * 572 / 780)}px"` : '';
    device = `<div class="phone"><div class="screen"><img src="${url(p.phone)}" ${top}></div></div>`;
  } else {
    const [x, y, w, h] = p.crop;
    // scale: προαιρετικό, μεγαλύτερο παράθυρο που βγαίνει από τη δεξιά άκρη της εικόνας.
    const s = p.scale || 920 / w, W = Math.round(w * s);
    device = `<div class="mac${p.scale ? ' bleed' : ''}" style="width:${W}px;height:${Math.round(h * s)}px">
      <img src="${url(p.mac)}" style="width:${Math.round(2000 * s)}px;left:${-Math.round(x * s)}px;top:${-Math.round(y * s)}px"></div>`;
  }
  return head(1080, 1350, `
    .glow{background:radial-gradient(circle at 85% 0%,${a.accent}66,rgba(16,24,32,0) 55%),
      radial-gradient(circle at 50% 110%,${a.accent}40,rgba(16,24,32,0) 50%)}
    .top{position:absolute;left:80px;right:80px;top:72px;display:flex;align-items:center;justify-content:space-between}
    .app{display:flex;align-items:center;gap:20px}
    .app img{width:84px;height:84px;border-radius:19px;box-shadow:0 6px 18px rgba(0,0,0,.45)}
    .app b{display:block;font-size:36px;font-weight:600;letter-spacing:-.02em;line-height:1.1}
    .app span{display:block;font-family:"Inter";font-size:22px;color:#A7B4BB}
    .brand{display:flex;align-items:center;gap:10px;font-family:"Inter";font-size:24px;font-weight:600;color:#A7B4BB}
    .brand img{width:34px;height:34px}
    .flow{position:absolute;left:80px;right:80px;top:208px;display:flex;flex-direction:column;align-items:flex-start}
    h1{font-size:76px;line-height:1.05;font-weight:600;letter-spacing:-.03em;text-wrap:balance}
    .sub{margin-top:26px;padding-right:30px;font-family:"Inter";font-size:32px;line-height:1.35;color:#A7B4BB;text-wrap:balance}
    .pill{margin-top:26px;font-family:"Inter";font-size:22px;font-weight:600;color:#E9CA88;
      border:1.5px solid rgba(233,202,136,.55);border-radius:999px;padding:9px 20px}
    .phone{position:relative;align-self:center;margin-top:60px;width:600px;height:1300px;flex:none;
      background:#05080B;border-radius:78px;padding:14px;box-shadow:0 30px 80px rgba(0,0,0,.6),0 0 0 2px rgba(237,241,238,.14)}
    .phone .screen{height:100%;overflow:hidden;border-radius:64px}
    .phone img{width:100%;display:block}
    .mac{position:relative;align-self:center;margin-top:64px;flex:none;overflow:hidden;border-radius:26px;
      box-shadow:0 30px 80px rgba(0,0,0,.6),0 0 0 2px rgba(237,241,238,.14);background:#fff}
    .mac.bleed{align-self:flex-start}
    .mac img{position:absolute;max-width:none}
  `) + `<div class="glow"></div>
    <div class="top"><div class="app"><img src="${url(`assets/icons/${p.app}.png`)}"><div><b>${a.name}</b><span>${a.kind}</span></div></div>
      <div class="brand"><img src="${url('assets/dimakis-strawberry.svg')}">dimakis.app</div></div>
    <div class="flow"><h1>${p.title}</h1><p class="sub">${p.sub}</p><span class="pill">${a.status}</span>
    ${device}</div></body></html>`;
}

// YouTube: banner 2560×1440 με το περιεχόμενο στη «ζώνη ασφαλείας» 1546×423 στο κέντρο (φαίνεται σε κάθε συσκευή).
function ytBanner() {
  const icons = ORDER.map((k) => `<img src="${url(`assets/icons/${k}.png`)}" alt="">`).join('');
  return head(2560, 1440, `
    .glow{background:radial-gradient(ellipse at 50% 42%,rgba(199,42,44,.16),rgba(16,24,32,0) 45%)}
    .safe{position:absolute;left:507px;top:508px;width:1546px;height:423px;
      display:flex;align-items:center;justify-content:center;gap:56px}
    .logo{height:104px;width:auto}
    .txt{display:flex;flex-direction:column;gap:22px}
    p{font-family:"Inter";font-size:34px;font-weight:500;color:#A7B4BB;letter-spacing:-.01em}
    .icons{display:flex;gap:18px}
    .icons img{width:68px;height:68px;border-radius:15px;box-shadow:0 6px 18px rgba(0,0,0,.5)}
    .sep{width:2px;height:190px;background:rgba(237,241,238,.14)}
  `) + `<div class="glow"></div><div class="safe">
    <img class="logo" src="${url('assets/dimakis-logo-dark.svg')}"><div class="sep"></div>
    <div class="txt"><p>Apps for iPhone, iPad, Mac and Apple Watch</p><div class="icons">${icons}</div></div>
  </div></body></html>`;
}

// YouTube: υδατογράφημα 150×150, διάφανο φόντο.
function ytWatermark() {
  return `<!doctype html><html><head><style>html,body{margin:0;background:transparent;width:150px;height:150px}
    img{width:150px;height:150px;display:block}</style></head><body>
    <img src="${url('assets/dimakis-strawberry.svg')}"></body></html>`;
}

// YouTube: μικρογραφίες 1280×720 για τα οριζόντια βίντεο-οδηγούς.
const THUMBS = [
  // Χωρίς screenshot: το παράδειγμα του άρθρου (ημερομηνία από το όνομα του αρχείου), σε μεγάλα γράμματα.
  { file: 'yt-thumb-fix-photo-dates', app: 'iris', title: 'Wrong photo dates?', sub: 'Fix them all at once',
    graphic: `<div class="g"><code>IMG-20190814-WA0012.jpg</code><span>↓</span><b>14 August 2019</b></div>` },
  { file: 'yt-thumb-remove-location', app: 'iris', title: 'Remove the location', sub: 'before you share a photo',
    mac: 'assets/screens/iris/mac/en/iris-mac-02-privacy.webp', crop: [600, 400, 800, 600] },
  { file: 'yt-thumb-add-location', app: 'iris', title: 'Put old photos on the map', sub: 'all at once, on your Mac',
    mac: 'assets/screens/iris/mac/en/iris-mac-04-location.webp', crop: [720, 700, 1020, 550] },
];

function ytThumb(t) {
  const a = APPS[t.app];
  const [x, y, w, h] = t.crop || [0, 0, 1, 1];
  const H = 560, s = H / h, W = Math.round(w * s);
  return head(1280, 720, `
    .glow{background:radial-gradient(circle at 0% 0%,${a.accent}80,rgba(16,24,32,0) 55%)}
    .txt{position:absolute;left:64px;top:60px;width:560px;display:flex;flex-direction:column;gap:18px}
    .app{display:flex;align-items:center;gap:16px;font-size:34px;font-weight:600}
    .app img{width:72px;height:72px;border-radius:16px}
    h1{font-size:92px;line-height:.98;font-weight:700;letter-spacing:-.035em;text-wrap:balance;margin-top:24px}
    .sub{font-family:"Inter";font-size:36px;font-weight:500;color:#E9CA88}
    .mac{position:absolute;left:640px;top:80px;width:${W}px;height:${H}px;overflow:hidden;border-radius:22px;
      box-shadow:0 30px 80px rgba(0,0,0,.6),0 0 0 2px rgba(237,241,238,.14);background:#fff}
    .mac img{position:absolute;max-width:none;width:${Math.round(2000 * s)}px;left:${-Math.round(x * s)}px;top:${-Math.round(y * s)}px}
    .g{position:absolute;left:660px;top:150px;width:560px;height:420px;border-radius:28px;background:#1A2831;
      border:2px solid rgba(237,241,238,.14);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:26px}
    .g code{font-family:"DejaVu Sans Mono",Menlo,monospace;font-size:30px;color:#A7B4BB;background:#101820;
      padding:14px 20px;border-radius:12px}
    .g span{font-size:64px;color:#E9CA88;line-height:1}
    .g b{font-size:58px;font-weight:700;letter-spacing:-.02em}
  `) + `<div class="glow"></div>
    <div class="txt"><div class="app"><img src="${url(`assets/icons/${t.app}.png`)}">${a.name} for Mac</div>
      <h1>${t.title}</h1><p class="sub">${t.sub}</p></div>
    ${t.graphic || `<div class="mac"><img src="${url(t.mac)}"></div>`}</body></html>`;
}

// Τελική κάρτα για τα Shorts (1080×1920), τα τελευταία 3 δευτερόλεπτα κάθε βίντεο.
function ytEndcard(k) {
  const a = APPS[k];
  return head(1080, 1920, `
    .glow{background:radial-gradient(circle at 50% 42%,${a.accent}70,rgba(16,24,32,0) 50%)}
    .in{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:26px}
    .icon{width:280px;height:280px;border-radius:62px;box-shadow:0 20px 60px rgba(0,0,0,.55)}
    h1{font-size:110px;font-weight:600;letter-spacing:-.03em;margin-top:30px}
    .kind{font-family:"Inter";font-size:40px;color:#A7B4BB}
    .pill{margin-top:30px;font-family:"Inter";font-size:38px;font-weight:600;color:#E9CA88;
      border:2px solid rgba(233,202,136,.55);border-radius:999px;padding:14px 34px}
    .brand{position:absolute;left:0;right:0;bottom:200px;display:flex;justify-content:center;align-items:center;gap:16px;
      font-family:"Inter";font-size:40px;font-weight:600;color:#EDF1EE}
    .brand img{width:56px;height:56px}
  `) + `<div class="glow"></div><div class="in">
    <img class="icon" src="${url(`assets/icons/${k}.png`)}"><h1>${a.name}</h1><span class="kind">${a.kind}</span>
    <span class="pill">${a.status}</span></div>
    <div class="brand"><img src="${url('assets/dimakis-strawberry.svg')}">dimakis.app</div></body></html>`;
}

const JOBS = [
  { name: 'profile', w: 1080, h: 1080, html: profile, type: 'png' },
  { name: 'facebook-cover', w: 1640, h: 624, html: cover, type: 'png' },
  { name: '00-intro', w: 1080, h: 1350, html: intro, type: 'jpeg' },
  ...POSTS.map((p) => ({ name: p.file, w: 1080, h: 1350, html: () => post(p), type: 'jpeg' })),
  { name: 'youtube-banner', w: 2560, h: 1440, html: ytBanner, type: 'jpeg' },
  { name: 'youtube-watermark', w: 150, h: 150, html: ytWatermark, type: 'png', transparent: true },
  ...THUMBS.map((t) => ({ name: t.file, w: 1280, h: 720, html: () => ytThumb(t), type: 'jpeg' })),
  ...['chronos', 'apollo', 'iris'].map((k) => ({ name: `yt-endcard-${k}`, w: 1080, h: 1920, html: () => ytEndcard(k), type: 'png' })),
];

(async () => {
  const only = process.argv.slice(2);
  fs.mkdirSync(OUT, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage();
  for (const j of JOBS) {
    if (only.length && !only.includes(j.name)) continue;
    const tmp = path.join(OUT, `.${j.name}.html`);
    fs.writeFileSync(tmp, j.html());
    await page.setViewportSize({ width: j.w, height: j.h });
    await page.goto('file://' + tmp, { waitUntil: 'networkidle' });
    await page.evaluate(() => document.fonts.ready);
    const out = path.join(OUT, `${j.name}.${j.type === 'png' ? 'png' : 'jpg'}`);
    await page.screenshot({ path: out, type: j.type, omitBackground: !!j.transparent, ...(j.type === 'jpeg' ? { quality: 90 } : {}) });
    fs.unlinkSync(tmp);
    console.log('✓', path.relative(ROOT, out));
  }
  await browser.close();
})();
