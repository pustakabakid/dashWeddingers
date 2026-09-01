-- ====================================================================
-- SUPABASE SCHEMA UNTUK WEVITATION MULTI-INVITATION WEDDING SYSTEM
-- ====================================================================
-- Salin dan jalankan skrip ini di: Supabase Console -> SQL Editor -> Run
-- Mendukung arsitektur Multi-Undangan (Mempelai Wanita & Mempelai Pria)
-- ====================================================================

-- 1. TABEL UTAMA PERNIKAHAN (weddings)
CREATE TABLE IF NOT EXISTS public.weddings (
    id TEXT PRIMARY KEY DEFAULT 'default',
    name TEXT NOT NULL DEFAULT 'Pernikahan Eviana (Via) & Andra',
    slug TEXT NOT NULL DEFAULT 'via-andra',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

INSERT INTO public.weddings (id, name, slug)
VALUES ('default', 'Pernikahan Eviana (Via) & Andra', 'via-andra')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- 2. TABEL PENGATURAN UNDANGAN MULTI-KONTEKS (invitation_settings)
-- Mendukung baris: 'bride' (Mempelai Wanita), 'groom' (Mempelai Pria), dan legacy 'default'
CREATE TABLE IF NOT EXISTS public.invitation_settings (
    id TEXT PRIMARY KEY DEFAULT 'default',
    wedding_id TEXT DEFAULT 'default',
    invitation_type TEXT DEFAULT 'bride',
    name TEXT DEFAULT 'Undangan Mempelai Wanita',
    slug TEXT DEFAULT 'via',
    couple JSONB NOT NULL DEFAULT '{
      "groom": {
        "name": "Andra Gunawan",
        "nickname": "Andra",
        "parents": "Putra Bapak Arya Gunawan & Ibu Djenar Widiati",
        "avatar": "/assets/images/groom-andra.jpg",
        "instagram": "wevitation",
        "instagramUrl": "https://instagram.com/wevitation"
      },
      "bride": {
        "name": "Eviana Saskia",
        "nickname": "Via",
        "parents": "Putri Bapak Danang Hendra & Ibu Siti Laela",
        "avatar": "/assets/images/bride-eviana.jpg",
        "instagram": "wevitation",
        "instagramUrl": "https://instagram.com/wevitation"
      },
      "combinedTitle": "Via & Andra"
    }'::jsonb,
    wedding_date TEXT NOT NULL DEFAULT '2026-09-21T16:00:00+07:00',
    day_name TEXT NOT NULL DEFAULT 'Senin',
    formatted_date TEXT NOT NULL DEFAULT 'Senin, 21 September 2026',
    formatted_date_short TEXT NOT NULL DEFAULT '21 • 09 • 2026',
    default_guest TEXT NOT NULL DEFAULT 'Lia',
    audio_url TEXT NOT NULL DEFAULT '/assets/audio/romantic-wedding-soundtrack.mp3',
    live_stream_url TEXT DEFAULT 'https://youtube.com/wevitation',
    schedules JSONB NOT NULL DEFAULT '[
      {
        "id": "akad",
        "title": "Akad Nikah",
        "date": "Senin, 21 September 2026",
        "time": "16:00 - 17:00",
        "venue": "Maximo Resto & Garden",
        "address": "Jl. Dr. Setiabudi No. 378",
        "calendarUrl": "https://www.google.com/calendar/event?action=TEMPLATE&text=+Eviana+Saskia+%26+Andra+Gunawan&details=Maximo+Resto+%26+Garden&dates=20260921T090000.0Z/20260921T100000.0Z&location=https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9",
        "mapsUrl": "https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9?g_st=ipc"
      },
      {
        "id": "resepsi",
        "title": "Resepsi",
        "date": "Senin, 21 September 2026",
        "time": "18:30 - 20:30",
        "venue": "Maximo Resto & Garden",
        "address": "Jl. Dr. Setiabudi No. 378",
        "calendarUrl": "https://www.google.com/calendar/event?action=TEMPLATE&text=+Eviana+Saskia+%26+Andra+Gunawan&details=Maximo+Resto+%26+Garden&dates=20260921T113000.0Z/20260921T133000.0Z&location=https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9",
        "mapsUrl": "https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9?g_st=ipc"
      }
    ]'::jsonb,
    love_stories JSONB NOT NULL DEFAULT '[
      {
        "id": "pertemuan",
        "title": "Pertemuan Pertama",
        "image": "/assets/images/story-first-meet.jpg",
        "description": "Pertama kali kami bertemu saat menjadi anggota sebuah organisasi di kampus. Kebetulan kami berada di divisi yang sama, yang menjadikan kami lebih akrab."
      },
      {
        "id": "lamaran",
        "title": "Lamaran",
        "image": "/assets/images/story-proposal.jpg",
        "description": "Walaupun kami sempat menjalani hubungan jarak jauh selama 2 tahun terakhir, namun hal itu bukan menjadi halangan untuk hubungan kami."
      }
    ]'::jsonb,
    bank_accounts JSONB NOT NULL DEFAULT '[
      {
        "bankName": "Bank BCA",
        "accountHolder": "Eviana Saskia",
        "accountNumber": "12345678",
        "logo": "/assets/svg/bca-logo.svg",
        "qrisImage": "/assets/images/qris-bca.jpg"
      }
    ]'::jsonb,
    gallery_images JSONB NOT NULL DEFAULT '[
      {"id": "1", "src": "/assets/images/gallery-1.jpg", "alt": "Gallery 1"},
      {"id": "2", "src": "/assets/images/gallery-2.jpg", "alt": "Gallery 2"},
      {"id": "3", "src": "/assets/images/gallery-3.jpg", "alt": "Gallery 3"},
      {"id": "4", "src": "/assets/images/gallery-4.jpg", "alt": "Gallery 4"}
    ]'::jsonb,
    feature_flags JSONB NOT NULL DEFAULT '{
      "showGateCover": true,
      "showCountdown": true,
      "showQuote": true,
      "showCoupleProfile": true,
      "showEventSchedule": true,
      "showLoveStory": true,
      "showGallery": true,
      "showGift": true,
      "showGuestbook": true,
      "showIGStoryGenerator": true,
      "showMusic": true,
      "showGoogleCal": true,
      "showAppleCal": true,
      "showGoogleMaps": true,
      "showWaze": true,
      "showLiveStream": true,
      "showBrideInstagram": true,
      "showGroomInstagram": true,
      "showParentsInfo": true,
      "showBankTransfer": true,
      "showQrisCode": true,
      "showRsvpButton": true,
      "showWishLikes": true,
      "showFloatingNav": true,
      "showBotanicalCorners": true
    }'::jsonb,
    invitation_url TEXT,
    wa_template TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Migrasi skema penambahan kolom baru jika tabel sudah ada
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS wedding_id TEXT DEFAULT 'default';
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS invitation_type TEXT DEFAULT 'bride';
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS name TEXT DEFAULT 'Undangan Mempelai Wanita';
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS slug TEXT DEFAULT 'via';
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS invitation_url TEXT;
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS wa_template TEXT;

-- 3. INISIALISASI DATA AWAL DUA UNDANGAN (Mempelai Wanita & Mempelai Pria)
-- Rekord 1: Mempelai Wanita (Bride)
INSERT INTO public.invitation_settings (
    id, wedding_id, invitation_type, name, slug, couple, wedding_date, day_name, formatted_date, formatted_date_short, default_guest, audio_url, live_stream_url, schedules, love_stories, bank_accounts, gallery_images, feature_flags, invitation_url, wa_template
) 
VALUES (
    'bride',
    'default',
    'bride',
    'Undangan Mempelai Wanita (Via)',
    'via',
    '{
      "groom": {
        "name": "Andra Gunawan",
        "nickname": "Andra",
        "parents": "Putra Bapak Arya Gunawan & Ibu Djenar Widiati",
        "avatar": "/assets/images/groom-andra.jpg",
        "instagram": "wevitation",
        "instagramUrl": "https://instagram.com/wevitation"
      },
      "bride": {
        "name": "Eviana Saskia",
        "nickname": "Via",
        "parents": "Putri Bapak Danang Hendra & Ibu Siti Laela",
        "avatar": "/assets/images/bride-eviana.jpg",
        "instagram": "wevitation",
        "instagramUrl": "https://instagram.com/wevitation"
      },
      "combinedTitle": "Via & Andra"
    }'::jsonb,
    '2026-09-21T16:00:00+07:00',
    'Senin',
    'Senin, 21 September 2026',
    '21 • 09 • 2026',
    'Lia',
    '/assets/audio/romantic-wedding-soundtrack.mp3',
    'https://youtube.com/wevitation',
    '[
      {
        "id": "akad",
        "title": "Akad Nikah",
        "date": "Senin, 21 September 2026",
        "time": "16:00 - 17:00",
        "venue": "Maximo Resto & Garden",
        "address": "Jl. Dr. Setiabudi No. 378",
        "calendarUrl": "https://www.google.com/calendar/event?action=TEMPLATE&text=+Eviana+Saskia+%26+Andra+Gunawan&details=Maximo+Resto+%26+Garden&dates=20260921T090000.0Z/20260921T100000.0Z&location=https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9",
        "mapsUrl": "https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9?g_st=ipc"
      },
      {
        "id": "resepsi",
        "title": "Resepsi",
        "date": "Senin, 21 September 2026",
        "time": "18:30 - 20:30",
        "venue": "Maximo Resto & Garden",
        "address": "Jl. Dr. Setiabudi No. 378",
        "calendarUrl": "https://www.google.com/calendar/event?action=TEMPLATE&text=+Eviana+Saskia+%26+Andra+Gunawan&details=Maximo+Resto+%26+Garden&dates=20260921T113000.0Z/20260921T133000.0Z&location=https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9",
        "mapsUrl": "https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9?g_st=ipc"
      }
    ]'::jsonb,
    '[
      {
        "id": "pertemuan",
        "title": "Pertemuan Pertama",
        "image": "/assets/images/story-first-meet.jpg",
        "description": "Pertama kali kami bertemu saat menjadi anggota sebuah organisasi di kampus. Kebetulan kami berada di divisi yang sama, yang menjadikan kami lebih akrab."
      },
      {
        "id": "lamaran",
        "title": "Lamaran",
        "image": "/assets/images/story-proposal.jpg",
        "description": "Walaupun kami sempat menjalani hubungan jarak jauh selama 2 tahun terakhir, namun hal itu bukan menjadi halangan untuk hubungan kami."
      }
    ]'::jsonb,
    '[
      {
        "bankName": "Bank BCA",
        "accountHolder": "Eviana Saskia",
        "accountNumber": "12345678",
        "logo": "/assets/svg/bca-logo.svg",
        "qrisImage": "/assets/images/qris-bca.jpg"
      }
    ]'::jsonb,
    '[
      {"id": "1", "src": "/assets/images/gallery-1.jpg", "alt": "Gallery 1"},
      {"id": "2", "src": "/assets/images/gallery-2.jpg", "alt": "Gallery 2"},
      {"id": "3", "src": "/assets/images/gallery-3.jpg", "alt": "Gallery 3"},
      {"id": "4", "src": "/assets/images/gallery-4.jpg", "alt": "Gallery 4"}
    ]'::jsonb,
    '{
      "showGateCover": true,
      "showCountdown": true,
      "showQuote": true,
      "showCoupleProfile": true,
      "showEventSchedule": true,
      "showLoveStory": true,
      "showGallery": true,
      "showGift": true,
      "showGuestbook": true,
      "showIGStoryGenerator": true,
      "showMusic": true,
      "showGoogleCal": true,
      "showAppleCal": true,
      "showGoogleMaps": true,
      "showWaze": true,
      "showLiveStream": true,
      "showBrideInstagram": true,
      "showGroomInstagram": true,
      "showParentsInfo": true,
      "showBankTransfer": true,
      "showQrisCode": true,
      "showRsvpButton": true,
      "showWishLikes": true,
      "showFloatingNav": true,
      "showBotanicalCorners": true
    }'::jsonb,
    '',
    ''
)
ON CONFLICT (id) DO NOTHING;

-- Rekord 2: Mempelai Pria (Groom)
INSERT INTO public.invitation_settings (
    id, wedding_id, invitation_type, name, slug, couple, wedding_date, day_name, formatted_date, formatted_date_short, default_guest, audio_url, live_stream_url, schedules, love_stories, bank_accounts, gallery_images, feature_flags, invitation_url, wa_template
) 
VALUES (
    'groom',
    'default',
    'groom',
    'Undangan Mempelai Pria (Andra)',
    'andra',
    '{
      "groom": {
        "name": "Andra Gunawan",
        "nickname": "Andra",
        "parents": "Putra Bapak Arya Gunawan & Ibu Djenar Widiati",
        "avatar": "/assets/images/groom-andra.jpg",
        "instagram": "wevitation",
        "instagramUrl": "https://instagram.com/wevitation"
      },
      "bride": {
        "name": "Eviana Saskia",
        "nickname": "Via",
        "parents": "Putri Bapak Danang Hendra & Ibu Siti Laela",
        "avatar": "/assets/images/bride-eviana.jpg",
        "instagram": "wevitation",
        "instagramUrl": "https://instagram.com/wevitation"
      },
      "combinedTitle": "Andra & Via"
    }'::jsonb,
    '2026-09-21T16:00:00+07:00',
    'Senin',
    'Senin, 21 September 2026',
    '21 • 09 • 2026',
    'Sahabat Andra',
    '/assets/audio/romantic-wedding-soundtrack.mp3',
    'https://youtube.com/wevitation',
    '[
      {
        "id": "akad",
        "title": "Akad Nikah",
        "date": "Senin, 21 September 2026",
        "time": "16:00 - 17:00",
        "venue": "Maximo Resto & Garden",
        "address": "Jl. Dr. Setiabudi No. 378",
        "calendarUrl": "https://www.google.com/calendar/event?action=TEMPLATE&text=+Andra+Gunawan+%26+Eviana+Saskia&details=Maximo+Resto+%26+Garden&dates=20260921T090000.0Z/20260921T100000.0Z&location=https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9",
        "mapsUrl": "https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9?g_st=ipc"
      },
      {
        "id": "resepsi",
        "title": "Resepsi",
        "date": "Senin, 21 September 2026",
        "time": "18:30 - 20:30",
        "venue": "Maximo Resto & Garden",
        "address": "Jl. Dr. Setiabudi No. 378",
        "calendarUrl": "https://www.google.com/calendar/event?action=TEMPLATE&text=+Andra+Gunawan+%26+Eviana+Saskia&details=Maximo+Resto+%26+Garden&dates=20260921T113000.0Z/20260921T133000.0Z&location=https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9",
        "mapsUrl": "https://maps.app.goo.gl/vwB5zqwGS2P4cPaY9?g_st=ipc"
      }
    ]'::jsonb,
    '[
      {
        "id": "pertemuan",
        "title": "Pertemuan Pertama",
        "image": "/assets/images/story-first-meet.jpg",
        "description": "Pertama kali kami bertemu saat menjadi anggota sebuah organisasi di kampus. Kebetulan kami berada di divisi yang sama, yang menjadikan kami lebih akrab."
      },
      {
        "id": "lamaran",
        "title": "Lamaran",
        "image": "/assets/images/story-proposal.jpg",
        "description": "Walaupun kami sempat menjalani hubungan jarak jauh selama 2 tahun terakhir, namun hal itu bukan menjadi halangan untuk hubungan kami."
      }
    ]'::jsonb,
    '[
      {
        "bankName": "Bank Mandiri",
        "accountHolder": "Andra Gunawan",
        "accountNumber": "87654321",
        "logo": "/assets/svg/mandiri-logo.svg",
        "qrisImage": "/assets/images/qris-mandiri.jpg"
      }
    ]'::jsonb,
    '[
      {"id": "1", "src": "/assets/images/gallery-1.jpg", "alt": "Gallery 1"},
      {"id": "2", "src": "/assets/images/gallery-2.jpg", "alt": "Gallery 2"},
      {"id": "3", "src": "/assets/images/gallery-3.jpg", "alt": "Gallery 3"},
      {"id": "4", "src": "/assets/images/gallery-4.jpg", "alt": "Gallery 4"}
    ]'::jsonb,
    '{
      "showGateCover": true,
      "showCountdown": true,
      "showQuote": true,
      "showCoupleProfile": true,
      "showEventSchedule": true,
      "showLoveStory": true,
      "showGallery": true,
      "showGift": true,
      "showGuestbook": true,
      "showIGStoryGenerator": true,
      "showMusic": true,
      "showGoogleCal": true,
      "showAppleCal": true,
      "showGoogleMaps": true,
      "showWaze": true,
      "showLiveStream": true,
      "showBrideInstagram": true,
      "showGroomInstagram": true,
      "showParentsInfo": true,
      "showBankTransfer": true,
      "showQrisCode": true,
      "showRsvpButton": true,
      "showWishLikes": true,
      "showFloatingNav": true,
      "showBotanicalCorners": true
    }'::jsonb,
    '',
    ''
)
ON CONFLICT (id) DO NOTHING;

-- 4. TABEL PENERIMA UNDANGAN & WHATSAPP DENGAN ISOLASI UNDANGAN (guests)
CREATE TABLE IF NOT EXISTS public.guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invitation_id TEXT NOT NULL DEFAULT 'bride',
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    slug TEXT NOT NULL,
    custom_note TEXT,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Migrasi kolom & indeks untuk guests
ALTER TABLE public.guests ADD COLUMN IF NOT EXISTS invitation_id TEXT DEFAULT 'bride';
ALTER TABLE public.guests ADD COLUMN IF NOT EXISTS is_sent BOOLEAN DEFAULT false;
ALTER TABLE public.guests ADD COLUMN IF NOT EXISTS sent_at TIMESTAMP WITH TIME ZONE;

-- Backfill data lama agar terhubung ke undangan wanita (bride)
UPDATE public.guests SET invitation_id = 'bride' WHERE invitation_id IS NULL OR invitation_id = '';

CREATE INDEX IF NOT EXISTS idx_guests_invitation_id ON public.guests(invitation_id);
CREATE INDEX IF NOT EXISTS idx_guests_name ON public.guests(name);
CREATE INDEX IF NOT EXISTS idx_guests_slug ON public.guests(slug);

-- 5. TABEL BUKU TAMU & DOA RESTU DENGAN ISOLASI UNDANGAN (wishes)
CREATE TABLE IF NOT EXISTS public.wishes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invitation_id TEXT NOT NULL DEFAULT 'bride',
    name TEXT NOT NULL,
    comment TEXT NOT NULL,
    attending BOOLEAN DEFAULT true,
    attendance_status TEXT DEFAULT 'hadir',
    likes_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Migrasi kolom & indeks untuk wishes
ALTER TABLE public.wishes ADD COLUMN IF NOT EXISTS invitation_id TEXT DEFAULT 'bride';
ALTER TABLE public.wishes ADD COLUMN IF NOT EXISTS attendance_status TEXT DEFAULT 'hadir';
ALTER TABLE public.wishes ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0;

-- Backfill data ucapan lama
UPDATE public.wishes SET invitation_id = 'bride' WHERE invitation_id IS NULL OR invitation_id = '';

CREATE INDEX IF NOT EXISTS idx_wishes_invitation_id ON public.wishes(invitation_id);
CREATE INDEX IF NOT EXISTS idx_wishes_created_at ON public.wishes(created_at DESC);

-- 6. ROW LEVEL SECURITY (RLS) POLICIES
ALTER TABLE public.weddings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitation_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wishes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public Read Weddings" ON public.weddings;
CREATE POLICY "Public Read Weddings" ON public.weddings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public Read Settings" ON public.invitation_settings;
CREATE POLICY "Public Read Settings" ON public.invitation_settings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public Update Settings" ON public.invitation_settings;
CREATE POLICY "Public Update Settings" ON public.invitation_settings FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Access Guests" ON public.guests;
CREATE POLICY "Public Full Access Guests" ON public.guests FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Access Wishes" ON public.wishes;
CREATE POLICY "Public Full Access Wishes" ON public.wishes FOR ALL USING (true) WITH CHECK (true);

-- 7. STORAGE BUCKET UNTUK FOTO & AUDIO (wedding-media)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) 
VALUES (
    'wedding-media', 
    'wedding-media', 
    true,
    52428800, -- Limit 50MB per file
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml', 'audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/ogg']
)
ON CONFLICT (id) DO UPDATE SET 
    public = true,
    file_size_limit = 52428800;

-- Hapus policy lama jika ada untuk mencegah duplikasi
DROP POLICY IF EXISTS "Public Access Wedding Media" ON storage.objects;
DROP POLICY IF EXISTS "Allow All For Wedding Media" ON storage.objects;

-- Berikan izin penuh (Select, Insert, Update, Delete) untuk bucket wedding-media
CREATE POLICY "Allow All For Wedding Media" ON storage.objects
FOR ALL
TO public
USING (bucket_id = 'wedding-media')
WITH CHECK (bucket_id = 'wedding-media');
