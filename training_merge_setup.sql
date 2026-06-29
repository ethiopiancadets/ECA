-- ================================================================
-- ECA — Merge Training + Courses: Add new fields
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- Add new columns to the existing "courses" table
ALTER TABLE courses ADD COLUMN IF NOT EXISTS training_type TEXT DEFAULT 'Online Course'
  CHECK (training_type IN ('Pre-Sea Training', 'Post-Sea Training', 'Online Course'));

ALTER TABLE courses ADD COLUMN IF NOT EXISTS location TEXT;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS event_date DATE;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS event_end_date DATE;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS seats_available INTEGER;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS contact_phone TEXT;

-- ----------------------------------------------------------------
-- DONE! After running this:
-- 1. Go to Table Editor → courses — you should see 6 new columns:
--    training_type, location, event_date, event_end_date,
--    seats_available, contact_phone
-- 2. Upload the new course-submit.html and courses.html
-- 3. Existing courses will default to "Online Course" training_type
-- ----------------------------------------------------------------
