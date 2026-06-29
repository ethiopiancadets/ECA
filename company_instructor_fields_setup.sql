-- ================================================================
-- ECA — Add Company & Instructor specific fields to members table
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- Company-specific fields
ALTER TABLE members ADD COLUMN IF NOT EXISTS company_name TEXT;
ALTER TABLE members ADD COLUMN IF NOT EXISTS company_type TEXT;
ALTER TABLE members ADD COLUMN IF NOT EXISTS contact_person_name TEXT;
ALTER TABLE members ADD COLUMN IF NOT EXISTS contact_position TEXT;
ALTER TABLE members ADD COLUMN IF NOT EXISTS office_address TEXT;
ALTER TABLE members ADD COLUMN IF NOT EXISTS company_website TEXT;

-- Instructor/Expert-specific fields
ALTER TABLE members ADD COLUMN IF NOT EXISTS expertise_area TEXT;
ALTER TABLE members ADD COLUMN IF NOT EXISTS years_experience INTEGER;
ALTER TABLE members ADD COLUMN IF NOT EXISTS bio TEXT;

-- ----------------------------------------------------------------
-- DONE! After running this:
-- 1. Go to Table Editor → members — you should see 9 new columns
-- 2. Upload the new register.html
-- 3. Cadets fill maritime fields, Companies fill company fields,
--    Experts fill expertise fields — all in the same "members" table
-- ----------------------------------------------------------------
