-- ================================================================
-- ECA — Contact Messages + Admin Email Notifications Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- ----------------------------------------------------------------
-- TABLE: contact_messages
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contact_messages (
  id          BIGSERIAL PRIMARY KEY,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  email       TEXT NOT NULL,
  subject     TEXT NOT NULL,
  message     TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied')),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can submit contact message"
  ON contact_messages FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins can view contact messages"
  ON contact_messages FOR SELECT USING (true);

CREATE POLICY "Admins can update contact messages"
  ON contact_messages FOR UPDATE USING (true);

CREATE POLICY "Admins can delete contact messages"
  ON contact_messages FOR DELETE USING (true);


-- ================================================================
-- ADMIN EMAIL NOTIFICATIONS — Using Supabase Edge Functions
-- ================================================================
--
-- Supabase can automatically send you an email when:
--   • A new member registers
--   • A new job application arrives
--   • A course is submitted for review
--   • A contact message is sent
--
-- HOW TO SET UP (No code needed — just follow these steps):
--
-- STEP 1 — Go to Supabase Dashboard
-- STEP 2 — Click "Database" → "Webhooks" in the left sidebar
-- STEP 3 — Click "Create a new webhook"
-- STEP 4 — Fill in:
--
--   Name: notify-new-member
--   Table: members
--   Events: INSERT (check this box only)
--   Type: HTTP Request
--   Method: POST
--   URL: https://plxsxxdkumpuehzpemco.supabase.co/functions/v1/notify-admin
--
-- STEP 5 — Repeat for other tables:
--   notify-new-application  → job_applications → INSERT
--   notify-new-course       → courses          → INSERT
--   notify-contact-message  → contact_messages → INSERT
--
-- ================================================================
-- SIMPLER ALTERNATIVE: Use Zapier (FREE, no code)
-- ================================================================
--
-- If webhooks feel complicated, use Zapier instead:
--
-- 1. Go to zapier.com → Sign up free
-- 2. Create a new "Zap"
-- 3. Trigger: "Supabase" → "New Row" → select table "members"
-- 4. Action: "Gmail" or "Email by Zapier" → Send Email to yourself
-- 5. Turn on the Zap → done!
--
-- Repeat for job_applications, courses, contact_messages tables.
-- This requires no coding and works perfectly with your setup.
--
-- ================================================================

-- NOTE: Run the courses_setup.sql file BEFORE this one if you
-- haven't already, so the courses and enrollments tables exist.
-- ================================================================
