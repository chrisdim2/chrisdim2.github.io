#!/usr/bin/env python3
# Trailer για YouTube από τα βίντεο του site: αλλάζει την τελική κάρτα «Available on the App Store»
# σε «Coming in December» / «Coming soon», μέχρι να κυκλοφορήσει η εφαρμογή.
# Χρήση (από τη ρίζα του repo): python3 _tools/social_trailers.py
# Χρειάζεται ffmpeg, Pillow, numpy και τη γραμματοσειρά Inter. Έξοδος: _social/video/.
# Με την κυκλοφορία: ανεβαίνει το αρχικό assets/video/<app>-en.mp4, που λέει ήδη «Available on the App Store».

import os, subprocess, tempfile
import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, '_social', 'video')

# card_at: στιγμή όπου η τελική κάρτα είναι ακίνητη· cut: από εδώ ξεκινά το σβήσιμο (0,5″) προς τη νέα κάρτα.
TRAILERS = [
    {'app': 'chronos', 'text': 'Coming in December', 'card_at': 116.5, 'cut': 113.6},
    {'app': 'apollo', 'text': 'Coming soon', 'card_at': 125.0, 'cut': 122.4},
]
BAND = (1238, 1300)        # γραμμές της φράσης «Available on the App Store» (1080×1920)
OLD_W = 803 - 275          # πλάτος της παλιάς φράσης σε px, για να βρεθεί το ίδιο μέγεθος γραμματοσειράς
HOLD = 3.2                 # δευτερόλεπτα της νέας κάρτας


def font_path():
    names = ('Inter-Medium.otf', 'Inter-Medium.ttf', 'Inter.ttc', 'Inter-Regular.otf', 'Inter-Regular.ttf')
    for d in ('/usr/share/fonts', '/usr/local/share/fonts', os.path.expanduser('~/Library/Fonts'), '/Library/Fonts'):
        for root, _, files in os.walk(d):
            for name in names:
                if name in files:
                    return os.path.join(root, name)
    raise SystemExit('Δεν βρέθηκε η γραμματοσειρά Inter')


FONT = font_path()


def font(size):
    return ImageFont.truetype(FONT, size)


def card(src, at, text, png):
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-ss', str(at), '-i', src, '-frames:v', '1', png], check=True)
    im = Image.open(png).convert('RGB')
    a = np.asarray(im).copy()
    y0, y1 = BAND
    band = a[y0:y1]
    lum = band.mean(axis=2)
    color = tuple(int(c) for c in band[lum < np.percentile(lum, 0.5)].mean(axis=0))
    # Η διαβάθμιση του φόντου είναι κάθετη: κάθε γραμμή της ζώνης παίρνει τα χρώματα από τα αριστερά άκρα της.
    for y in range(y0, y1):
        a[y, :] = a[y, 20:120].mean(axis=0)
    im = Image.fromarray(a)
    size = 10
    while font(size + 1).getlength('Available on the App Store') <= OLD_W:
        size += 1
    f = font(size)
    d = ImageDraw.Draw(im)
    d.text((540, (y0 + y1) / 2), text, font=f, fill=color, anchor='mm')
    im.save(png)


def main():
    os.makedirs(OUT, exist_ok=True)
    tmp = tempfile.mkdtemp()
    for t in TRAILERS:
        src = os.path.join(ROOT, 'assets', 'video', f"{t['app']}-en.mp4")
        png = os.path.join(tmp, f"{t['app']}-card.png")
        out = os.path.join(OUT, f"{t['app']}-trailer-en.mp4")
        card(src, t['card_at'], t['text'], png)
        cut = t['cut']
        graph = (f"[0:v]trim=0:{cut + 0.5},setpts=PTS-STARTPTS,settb=AVTB[a];"
                 f"[1:v]fps=30,format=yuv420p,settb=AVTB[b];"
                 f"[a][b]xfade=transition=fade:duration=0.5:offset={cut}[v]")
        subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', src, '-loop', '1', '-t', str(HOLD + 0.5), '-i', png,
                        '-filter_complex', graph, '-map', '[v]', '-c:v', 'libx264', '-crf', '18', '-preset', 'slow',
                        '-pix_fmt', 'yuv420p', '-movflags', '+faststart', out], check=True)
        print('✓', os.path.relpath(out, ROOT))


if __name__ == '__main__':
    main()
