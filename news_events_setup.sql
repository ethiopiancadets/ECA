-- ================================================================
-- ECA — News & Events Table Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

CREATE TABLE IF NOT EXISTS news_events (
  id              BIGSERIAL PRIMARY KEY,
  type            TEXT NOT NULL CHECK (type IN ('news', 'event')),
  title           TEXT NOT NULL,
  content         TEXT NOT NULL,
  excerpt         TEXT,
  image_url       TEXT,
  video_url       TEXT,
  author_name     TEXT DEFAULT 'ECA Team',
  event_date      DATE,
  event_end_date  DATE,
  event_location  TEXT,
  event_link      TEXT,
  status          TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  posted_by       TEXT DEFAULT 'admin',
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE news_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view approved news"
  ON news_events FOR SELECT USING (status = 'approved');

CREATE POLICY "Admins can view all news"
  ON news_events FOR SELECT USING (true);

CREATE POLICY "Anyone can submit news"
  ON news_events FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins can update news"
  ON news_events FOR UPDATE USING (true);

CREATE POLICY "Admins can delete news"
  ON news_events FOR DELETE USING (true);

-- ================================================================
-- STORAGE: Create "news-images" bucket in Supabase Storage UI first,
-- set it as Public, then run these two policies:
-- ================================================================

CREATE POLICY "Anyone can upload news images"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'news-images');

CREATE POLICY "Anyone can view news images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'news-images');
