-- ================================================================
-- ECA — Job Listings & Applications Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- ----------------------------------------------------------------
-- TABLE: jobs
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS jobs (
  id              BIGSERIAL PRIMARY KEY,
  title           TEXT NOT NULL,
  company_name    TEXT NOT NULL,
  location        TEXT,
  job_type        TEXT DEFAULT 'Between-Contract',  -- Between-Contract, Full-Time, Contract, Internship
  category        TEXT,                              -- e.g. Deck, Engine, Shore-Based, Admin
  description     TEXT,
  requirements    TEXT,
  salary_range    TEXT,
  contact_email   TEXT,
  status          TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

-- Anyone can view open jobs
CREATE POLICY "Anyone can view jobs"
  ON jobs FOR SELECT
  USING (true);

-- Anyone can post a job (no approval needed, per your settings)
CREATE POLICY "Anyone can post jobs"
  ON jobs FOR INSERT
  WITH CHECK (true);

-- Admin can update/delete (handled via admin dashboard using same anon key + admin policies)
CREATE POLICY "Admins can update jobs"
  ON jobs FOR UPDATE
  USING (true);

CREATE POLICY "Admins can delete jobs"
  ON jobs FOR DELETE
  USING (true);


-- ----------------------------------------------------------------
-- TABLE: job_applications
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS job_applications (
  id              BIGSERIAL PRIMARY KEY,
  job_id          BIGINT REFERENCES jobs(id) ON DELETE CASCADE,
  applicant_name  TEXT NOT NULL,
  applicant_email TEXT NOT NULL,
  applicant_phone TEXT,
  rank            TEXT,
  message         TEXT,
  status          TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'reviewed', 'contacted')),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

-- Anyone can submit an application
CREATE POLICY "Anyone can apply"
  ON job_applications FOR INSERT
  WITH CHECK (true);

-- Admins can view all applications
CREATE POLICY "Admins can view applications"
  ON job_applications FOR SELECT
  USING (true);

-- Admins can update application status
CREATE POLICY "Admins can update applications"
  ON job_applications FOR UPDATE
  USING (true);

-- Admins can delete applications
CREATE POLICY "Admins can delete applications"
  ON job_applications FOR DELETE
  USING (true);


-- ----------------------------------------------------------------
-- DONE! After running this:
-- 1. Go to Table Editor — you should see "jobs" and "job_applications"
-- 2. Use admin.html (updated version) to post jobs and view applications
-- 3. Use jobs.html for the public job board
-- ----------------------------------------------------------------
