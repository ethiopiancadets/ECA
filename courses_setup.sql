-- ================================================================
-- ECA — Course Uploads & Enrollments Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- ----------------------------------------------------------------
-- TABLE: courses
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS courses (
  id              BIGSERIAL PRIMARY KEY,
  title           TEXT NOT NULL,
  instructor_name TEXT NOT NULL,
  instructor_email TEXT NOT NULL,
  category        TEXT,                    -- e.g. Deck, Engine, Safety, Management, Other
  level           TEXT DEFAULT 'Beginner', -- Beginner, Intermediate, Advanced
  description     TEXT,
  external_link   TEXT,                    -- YouTube / Zoom / Google Drive link
  pdf_url         TEXT,                    -- Link to uploaded PDF in Supabase Storage
  duration        TEXT,                    -- e.g. "4 weeks", "10 hours"
  price           TEXT DEFAULT 'Free',
  status          TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE courses ENABLE ROW LEVEL SECURITY;

-- Anyone can view approved courses
CREATE POLICY "Anyone can view approved courses"
  ON courses FOR SELECT
  USING (status = 'approved');

-- Admins can view all courses (including pending/rejected)
CREATE POLICY "Admins can view all courses"
  ON courses FOR SELECT
  USING (true);

-- Anyone (instructors) can submit a course — goes in as pending
CREATE POLICY "Anyone can submit a course"
  ON courses FOR INSERT
  WITH CHECK (true);

-- Admins can update course status (approve/reject)
CREATE POLICY "Admins can update courses"
  ON courses FOR UPDATE
  USING (true);

-- Admins can delete courses
CREATE POLICY "Admins can delete courses"
  ON courses FOR DELETE
  USING (true);


-- ----------------------------------------------------------------
-- TABLE: course_enrollments
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS course_enrollments (
  id              BIGSERIAL PRIMARY KEY,
  course_id       BIGINT REFERENCES courses(id) ON DELETE CASCADE,
  full_name       TEXT NOT NULL,
  email           TEXT NOT NULL,
  phone           TEXT,
  current_rank    TEXT,
  message         TEXT,
  status          TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'enrolled')),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE course_enrollments ENABLE ROW LEVEL SECURITY;

-- Anyone can submit an enrollment
CREATE POLICY "Anyone can enroll"
  ON course_enrollments FOR INSERT
  WITH CHECK (true);

-- Admins can view all enrollments
CREATE POLICY "Admins can view enrollments"
  ON course_enrollments FOR SELECT
  USING (true);

-- Admins can update enrollment status
CREATE POLICY "Admins can update enrollments"
  ON course_enrollments FOR UPDATE
  USING (true);

-- Admins can delete enrollments
CREATE POLICY "Admins can delete enrollments"
  ON course_enrollments FOR DELETE
  USING (true);


-- ================================================================
-- STORAGE BUCKET SETUP (for PDF uploads)
-- ================================================================
-- This part must be done in the Supabase Dashboard UI, NOT SQL:
--
-- 1. Go to Supabase → Storage (left sidebar)
-- 2. Click "New bucket"
-- 3. Name it exactly:  course-materials
-- 4. Toggle "Public bucket" = ON (so PDFs can be viewed via link)
-- 5. Click "Create bucket"
--
-- After creating the bucket, run the policies below so anyone
-- can upload PDFs when submitting a course:

-- Allow anyone to upload files to course-materials bucket
CREATE POLICY "Anyone can upload course materials"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'course-materials');

-- Allow anyone to view files in course-materials bucket
CREATE POLICY "Anyone can view course materials"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'course-materials');


-- ----------------------------------------------------------------
-- DONE! After running this:
-- 1. Go to Table Editor — you should see "courses" and "course_enrollments"
-- 2. Create the "course-materials" storage bucket as described above
-- 3. Use courses-portal.html for instructors to submit courses
-- 4. Use the updated admin.html to approve/reject courses
-- 5. Approved courses appear on courses.html for members to enroll
-- ----------------------------------------------------------------
