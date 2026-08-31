-- ====================================================================
-- SUPABASE SCHEMA UNTUK WEVITATION MILDNESS WEDDING INVITATION
-- ====================================================================
-- Salin dan jalankan skrip ini di: Supabase Console -> SQL Editor -> Run
-- ====================================================================

-- 1. TABEL PENGATURAN UNDANGAN & FITUR (invitation_settings)
CREATE TABLE IF NOT EXISTS public.invitation_settings (
    id TEXT PRIMARY KEY DEFAULT 'default',
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
      "showMusic": true
    }'::jsonb,
    invitation_url TEXT,
    wa_template TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Insert default row if not exists
INSERT INTO public.invitation_settings (id) 
VALUES ('default')
ON CONFLICT (id) DO NOTHING;

-- 2. TABEL PENERIMA UNDANGAN & WHATSAPP (guests)
CREATE TABLE IF NOT EXISTS public.guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    slug TEXT NOT NULL,
    custom_note TEXT,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_guests_name ON public.guests(name);
CREATE INDEX IF NOT EXISTS idx_guests_slug ON public.guests(slug);

-- 3. TABEL BUKU TAMU & DOA RESTU (wishes)
CREATE TABLE IF NOT EXISTS public.wishes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    comment TEXT NOT NULL,
    attending BOOLEAN DEFAULT true,
    attendance_status TEXT DEFAULT 'hadir',
    likes_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Migration safety for existing tables
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS invitation_url TEXT;
ALTER TABLE public.invitation_settings ADD COLUMN IF NOT EXISTS wa_template TEXT;
ALTER TABLE public.wishes ADD COLUMN IF NOT EXISTS attendance_status TEXT DEFAULT 'hadir';
ALTER TABLE public.wishes ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0;
ALTER TABLE public.guests ADD COLUMN IF NOT EXISTS is_sent BOOLEAN DEFAULT false;
ALTER TABLE public.guests ADD COLUMN IF NOT EXISTS sent_at TIMESTAMP WITH TIME ZONE;

-- 4. ATUR ROW LEVEL SECURITY (RLS) AGAR DAPAT DIAKSES DARI WEBSITE
ALTER TABLE public.invitation_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wishes ENABLE ROW LEVEL SECURITY;

-- Policy untuk invitation_settings (Bebas baca, Bebas simpan/update)
DROP POLICY IF EXISTS "Public Read Settings" ON public.invitation_settings;
CREATE POLICY "Public Read Settings" ON public.invitation_settings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public Update Settings" ON public.invitation_settings;
CREATE POLICY "Public Update Settings" ON public.invitation_settings FOR ALL USING (true) WITH CHECK (true);

-- Policy untuk guests (Bebas baca, tambah, ubah, hapus)
DROP POLICY IF EXISTS "Public Full Access Guests" ON public.guests;
CREATE POLICY "Public Full Access Guests" ON public.guests FOR ALL USING (true) WITH CHECK (true);

-- Policy untuk wishes (Bebas baca & kirim ucapan)
DROP POLICY IF EXISTS "Public Full Access Wishes" ON public.wishes;
CREATE POLICY "Public Full Access Wishes" ON public.wishes FOR ALL USING (true) WITH CHECK (true);

-- 5. STORAGE BUCKET UNTUK FOTO & AUDIO (wedding-media)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('wedding-media', 'wedding-media', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Policy Storage: Publik dapat melihat & mengunggah/mengganti file
DROP POLICY IF EXISTS "Public Access Wedding Media" ON storage.objects;
CREATE POLICY "Public Access Wedding Media" ON storage.objects
FOR ALL USING (bucket_id = 'wedding-media')
WITH CHECK (bucket_id = 'wedding-media');
