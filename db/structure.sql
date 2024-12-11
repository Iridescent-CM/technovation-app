SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: chapter_ambassador_organization_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.chapter_ambassador_organization_status AS ENUM (
    'employee',
    'volunteer'
);


--
-- Name: document_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.document_status AS ENUM (
    'sent',
    'signed',
    'off-platform',
    'voided'
);


--
-- Name: judge_recusal_from_submission_reason; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.judge_recusal_from_submission_reason AS ENUM (
    'submission_not_in_english',
    'knows_team',
    'content_does_not_belong_to_team',
    'other'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    auth_token character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    date_of_birth date,
    city character varying,
    state_province character varying,
    country character varying,
    referred_by integer,
    referred_by_other character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    latitude double precision,
    longitude double precision,
    consent_token character varying,
    profile_image character varying,
    pre_survey_completed_at timestamp without time zone,
    password_reset_token character varying,
    password_reset_token_sent_at timestamp without time zone,
    gender integer,
    last_login_ip character varying,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    timezone character varying,
    browser_name character varying,
    browser_version character varying,
    os_name character varying,
    os_version character varying,
    email_confirmed_at timestamp without time zone,
    deleted_at timestamp without time zone,
    last_logged_in_at timestamp without time zone,
    seasons text[] DEFAULT '{}'::text[],
    session_token character varying,
    mailer_token character varying,
    icon_path character varying,
    division_id bigint,
    survey_completed_at timestamp without time zone,
    reminded_about_survey_at timestamp without time zone,
    reminded_about_survey_count integer DEFAULT 0 NOT NULL,
    season_registered_at timestamp without time zone,
    admin_status integer DEFAULT 0 NOT NULL,
    admin_invitation_token character varying,
    geocoding_city_was character varying,
    geocoding_state_was character varying,
    geocoding_country_was character varying,
    geocoding_fixed_at timestamp without time zone,
    terms_agreed_at timestamp without time zone,
    parent_registered boolean DEFAULT false NOT NULL,
    meets_minimum_age_requirement boolean,
    background_check_exemption boolean DEFAULT false NOT NULL,
    phone_number character varying,
    no_chapterable_selected boolean,
    no_chapterables_available boolean
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    trackable_type character varying,
    trackable_id integer,
    owner_type character varying,
    owner_id integer,
    key character varying,
    parameters text,
    recipient_type character varying,
    recipient_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: admin_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_profiles (
    id integer NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    super_admin boolean DEFAULT false NOT NULL
);


--
-- Name: admin_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_profiles_id_seq OWNED BY public.admin_profiles.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: availability_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.availability_slots (
    id bigint NOT NULL,
    "time" character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: availability_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.availability_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: availability_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.availability_slots_id_seq OWNED BY public.availability_slots.id;


--
-- Name: background_checks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.background_checks (
    id integer NOT NULL,
    candidate_id character varying,
    report_id character varying,
    account_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invitation_id character varying,
    invitation_status integer,
    invitation_url character varying,
    internal_invitation_status integer,
    error_message text
);


--
-- Name: background_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.background_checks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: background_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.background_checks_id_seq OWNED BY public.background_checks.id;


--
-- Name: business_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_plans (
    id integer NOT NULL,
    uploaded_file character varying,
    team_submission_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.business_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.business_plans_id_seq OWNED BY public.business_plans.id;


--
-- Name: certificates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificates (
    id bigint NOT NULL,
    account_id bigint,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    season integer,
    cert_type integer,
    team_id bigint
);


--
-- Name: certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificates_id_seq OWNED BY public.certificates.id;


--
-- Name: chapter_ambassador_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_ambassador_profiles (
    id integer NOT NULL,
    organization_company_name character varying,
    job_title character varying NOT NULL,
    account_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bio text,
    intro_summary text,
    secondary_regions character varying[] DEFAULT '{}'::character varying[],
    program_name character varying,
    chapter_id bigint,
    organization_status public.chapter_ambassador_organization_status,
    viewed_community_connections boolean DEFAULT false NOT NULL,
    training_completed_at timestamp without time zone,
    onboarded boolean DEFAULT false
);


--
-- Name: chapter_ambassador_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_ambassador_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_ambassador_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_ambassador_profiles_id_seq OWNED BY public.chapter_ambassador_profiles.id;


--
-- Name: chapter_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_links (
    id bigint NOT NULL,
    chapter_ambassador_profile_id bigint,
    name integer,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    custom_label character varying,
    chapter_id bigint
);


--
-- Name: chapter_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_links_id_seq OWNED BY public.chapter_links.id;


--
-- Name: chapter_program_information; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_program_information (
    id bigint NOT NULL,
    chapter_id bigint,
    child_safeguarding_policy_and_process text,
    team_structure text,
    external_partnerships text,
    start_date date,
    launch_date date,
    program_model text,
    number_of_low_income_or_underserved_calculation text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    program_length_id bigint,
    participant_count_estimate_id bigint,
    low_income_estimate_id bigint
);


--
-- Name: chapter_program_information_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_program_information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_program_information_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_program_information_id_seq OWNED BY public.chapter_program_information.id;


--
-- Name: chapter_program_information_meeting_facilitators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_program_information_meeting_facilitators (
    id bigint NOT NULL,
    chapter_program_information_id bigint,
    meeting_facilitator_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chapter_program_information_meeting_facilitators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_program_information_meeting_facilitators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_program_information_meeting_facilitators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_program_information_meeting_facilitators_id_seq OWNED BY public.chapter_program_information_meeting_facilitators.id;


--
-- Name: chapter_program_information_meeting_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_program_information_meeting_times (
    id bigint NOT NULL,
    chapter_program_information_id bigint,
    meeting_time_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chapter_program_information_meeting_times_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_program_information_meeting_times_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_program_information_meeting_times_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_program_information_meeting_times_id_seq OWNED BY public.chapter_program_information_meeting_times.id;


--
-- Name: chapter_program_information_organization_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_program_information_organization_types (
    id bigint NOT NULL,
    chapter_program_information_id bigint,
    organization_type_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chapter_program_information_organization_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_program_information_organization_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_program_information_organization_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_program_information_organization_types_id_seq OWNED BY public.chapter_program_information_organization_types.id;


--
-- Name: chapterable_account_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapterable_account_assignments (
    id bigint NOT NULL,
    chapterable_id bigint,
    account_id bigint,
    profile_type character varying,
    profile_id bigint,
    season smallint,
    "primary" boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    chapterable_type character varying
);


--
-- Name: chapterable_account_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapterable_account_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapterable_account_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapterable_account_assignments_id_seq OWNED BY public.chapterable_account_assignments.id;


--
-- Name: chapters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapters (
    id bigint NOT NULL,
    name character varying,
    summary text,
    organization_name character varying,
    city character varying,
    state_province character varying,
    country character varying,
    primary_contact_id bigint,
    visible_on_map boolean DEFAULT true,
    organization_headquarters_location character varying,
    onboarded boolean DEFAULT false,
    latitude double precision,
    longitude double precision,
    primary_account_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: chapters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapters_id_seq OWNED BY public.chapters.id;


--
-- Name: club_ambassador_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.club_ambassador_profiles (
    id bigint NOT NULL,
    account_id bigint,
    job_title character varying,
    training_completed_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: club_ambassador_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.club_ambassador_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: club_ambassador_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.club_ambassador_profiles_id_seq OWNED BY public.club_ambassador_profiles.id;


--
-- Name: clubs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clubs (
    id bigint NOT NULL,
    name character varying,
    summary text,
    headquarters_location character varying,
    visible_on_map boolean DEFAULT true,
    city character varying,
    state_province character varying,
    country character varying,
    latitude double precision,
    longitude double precision,
    primary_account_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clubs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clubs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clubs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clubs_id_seq OWNED BY public.clubs.id;


--
-- Name: community_connection_availability_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_connection_availability_slots (
    id bigint NOT NULL,
    community_connection_id bigint,
    availability_slot_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: community_connection_availability_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.community_connection_availability_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_connection_availability_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.community_connection_availability_slots_id_seq OWNED BY public.community_connection_availability_slots.id;


--
-- Name: community_connections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_connections (
    id bigint NOT NULL,
    topic_sharing_response text,
    chapter_ambassador_profile_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: community_connections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.community_connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.community_connections_id_seq OWNED BY public.community_connections.id;


--
-- Name: consent_waivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consent_waivers (
    id integer NOT NULL,
    electronic_signature character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    voided_at timestamp without time zone
);


--
-- Name: consent_waivers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consent_waivers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consent_waivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consent_waivers_id_seq OWNED BY public.consent_waivers.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.divisions (
    id integer NOT NULL,
    name integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.divisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.divisions_id_seq OWNED BY public.divisions.id;


--
-- Name: divisions_regional_pitch_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.divisions_regional_pitch_events (
    division_id integer,
    regional_pitch_event_id integer
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    full_name character varying NOT NULL,
    email_address character varying NOT NULL,
    signer_type character varying,
    signer_id bigint,
    active boolean,
    signed_at timestamp without time zone,
    season_signed smallint,
    docusign_envelope_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    voided_at timestamp without time zone,
    sent_at timestamp without time zone,
    status public.document_status,
    season_expires smallint
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: expertises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expertises (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "order" integer
);


--
-- Name: expertises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expertises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expertises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expertises_id_seq OWNED BY public.expertises.id;


--
-- Name: exports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exports (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    file character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    download_token character varying,
    job_id character varying,
    downloaded boolean DEFAULT false NOT NULL,
    owner_type character varying
);


--
-- Name: exports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exports_id_seq OWNED BY public.exports.id;


--
-- Name: gadget_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gadget_types (
    id bigint NOT NULL,
    name character varying,
    "order" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: gadget_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gadget_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gadget_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gadget_types_id_seq OWNED BY public.gadget_types.id;


--
-- Name: honor_code_agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.honor_code_agreements (
    id integer NOT NULL,
    account_id integer NOT NULL,
    electronic_signature character varying NOT NULL,
    agreement_confirmed boolean DEFAULT false NOT NULL,
    voided_at date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: honor_code_agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.honor_code_agreements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: honor_code_agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.honor_code_agreements_id_seq OWNED BY public.honor_code_agreements.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    job_id character varying,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner_type character varying,
    owner_id bigint,
    payload json DEFAULT '{}'::json
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: join_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.join_requests (
    id integer NOT NULL,
    requestor_type character varying NOT NULL,
    requestor_id integer NOT NULL,
    team_id integer NOT NULL,
    accepted_at timestamp without time zone,
    declined_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    review_token character varying
);


--
-- Name: join_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.join_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: join_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.join_requests_id_seq OWNED BY public.join_requests.id;


--
-- Name: judge_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_assignments (
    id integer NOT NULL,
    team_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assigned_judge_type character varying,
    assigned_judge_id integer,
    seasons text[] DEFAULT '{}'::text[]
);


--
-- Name: judge_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_assignments_id_seq OWNED BY public.judge_assignments.id;


--
-- Name: judge_profile_judge_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_profile_judge_types (
    id bigint NOT NULL,
    judge_profile_id bigint,
    judge_type_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: judge_profile_judge_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_profile_judge_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_profile_judge_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_profile_judge_types_id_seq OWNED BY public.judge_profile_judge_types.id;


--
-- Name: judge_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_profiles (
    id integer NOT NULL,
    account_id integer,
    company_name character varying NOT NULL,
    job_title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    user_invitation_id bigint,
    completed_training_at timestamp without time zone,
    industry integer,
    industry_other character varying,
    skills character varying,
    degree character varying,
    survey_completed boolean,
    onboarded boolean DEFAULT false,
    quarterfinals_scores_count integer DEFAULT 0 NOT NULL,
    semifinals_scores_count integer DEFAULT 0,
    suspended boolean DEFAULT false,
    recusal_scores_count integer DEFAULT 0 NOT NULL
);


--
-- Name: judge_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_profiles_id_seq OWNED BY public.judge_profiles.id;


--
-- Name: judge_profiles_regional_pitch_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_profiles_regional_pitch_events (
    judge_profile_id integer,
    regional_pitch_event_id integer
);


--
-- Name: judge_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_types (
    id bigint NOT NULL,
    name character varying,
    "order" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: judge_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_types_id_seq OWNED BY public.judge_types.id;


--
-- Name: legal_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_contacts (
    id bigint NOT NULL,
    chapter_id bigint,
    full_name character varying NOT NULL,
    email_address character varying NOT NULL,
    phone_number character varying,
    job_title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: legal_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legal_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legal_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legal_contacts_id_seq OWNED BY public.legal_contacts.id;


--
-- Name: low_income_estimates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.low_income_estimates (
    id bigint NOT NULL,
    percentage character varying,
    "order" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: low_income_estimates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.low_income_estimates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_income_estimates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.low_income_estimates_id_seq OWNED BY public.low_income_estimates.id;


--
-- Name: media_consents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_consents (
    id bigint NOT NULL,
    student_profile_id integer NOT NULL,
    season smallint NOT NULL,
    consent_provided boolean,
    electronic_signature character varying,
    signed_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    uploaded_consent_form character varying,
    uploaded_at timestamp without time zone,
    upload_approval_status integer DEFAULT 0,
    upload_approved_at timestamp without time zone,
    upload_rejected_at timestamp without time zone
);


--
-- Name: media_consents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_consents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_consents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_consents_id_seq OWNED BY public.media_consents.id;


--
-- Name: meeting_facilitators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meeting_facilitators (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: meeting_facilitators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meeting_facilitators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meeting_facilitators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meeting_facilitators_id_seq OWNED BY public.meeting_facilitators.id;


--
-- Name: meeting_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meeting_times (
    id bigint NOT NULL,
    "time" character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: meeting_times_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meeting_times_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meeting_times_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meeting_times_id_seq OWNED BY public.meeting_times.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id integer NOT NULL,
    member_type character varying NOT NULL,
    member_id integer NOT NULL,
    team_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: mentor_profile_expertises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_profile_expertises (
    id integer NOT NULL,
    mentor_profile_id integer,
    expertise_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mentor_profile_expertises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_profile_expertises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_profile_expertises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_profile_expertises_id_seq OWNED BY public.mentor_profile_expertises.id;


--
-- Name: mentor_profile_mentor_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_profile_mentor_types (
    id bigint NOT NULL,
    mentor_profile_id bigint,
    mentor_type_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: mentor_profile_mentor_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_profile_mentor_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_profile_mentor_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_profile_mentor_types_id_seq OWNED BY public.mentor_profile_mentor_types.id;


--
-- Name: mentor_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_profiles (
    id integer NOT NULL,
    account_id integer,
    school_company_name character varying NOT NULL,
    job_title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bio text,
    searchable boolean DEFAULT false NOT NULL,
    accepting_team_invites boolean DEFAULT true NOT NULL,
    virtual boolean DEFAULT true NOT NULL,
    connect_with_mentors boolean DEFAULT false NOT NULL,
    user_invitation_id bigint,
    training_completed_at timestamp without time zone,
    former_student boolean DEFAULT false
);


--
-- Name: mentor_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_profiles_id_seq OWNED BY public.mentor_profiles.id;


--
-- Name: mentor_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_types (
    id bigint NOT NULL,
    name character varying,
    "order" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: mentor_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_types_id_seq OWNED BY public.mentor_types.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    recipient_id integer,
    recipient_type character varying,
    sender_id integer,
    sender_type character varying,
    subject character varying,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    regarding_type character varying,
    regarding_id integer,
    sent_at timestamp without time zone,
    delivered_at timestamp without time zone
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: multi_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multi_messages (
    id integer NOT NULL,
    sender_type character varying NOT NULL,
    sender_id integer NOT NULL,
    regarding_type character varying NOT NULL,
    regarding_id integer NOT NULL,
    recipients public.hstore NOT NULL,
    subject character varying,
    body text NOT NULL,
    sent_at timestamp without time zone,
    delivered_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: multi_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.multi_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: multi_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.multi_messages_id_seq OWNED BY public.multi_messages.id;


--
-- Name: organization_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organization_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_types_id_seq OWNED BY public.organization_types.id;


--
-- Name: parental_consents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parental_consents (
    id integer NOT NULL,
    electronic_signature character varying,
    student_profile_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    newsletter_opt_in boolean,
    seasons text[] DEFAULT '{}'::text[],
    status integer DEFAULT 0 NOT NULL,
    uploaded_consent_form character varying,
    uploaded_at timestamp without time zone,
    upload_approval_status integer DEFAULT 0,
    upload_approved_at timestamp without time zone,
    upload_rejected_at timestamp without time zone
);


--
-- Name: parental_consents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parental_consents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parental_consents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parental_consents_id_seq OWNED BY public.parental_consents.id;


--
-- Name: participant_count_estimates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participant_count_estimates (
    id bigint NOT NULL,
    range character varying,
    "order" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: participant_count_estimates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participant_count_estimates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participant_count_estimates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participant_count_estimates_id_seq OWNED BY public.participant_count_estimates.id;


--
-- Name: pitch_presentations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pitch_presentations (
    id integer NOT NULL,
    uploaded_file character varying,
    team_submission_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pitch_presentations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pitch_presentations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pitch_presentations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pitch_presentations_id_seq OWNED BY public.pitch_presentations.id;


--
-- Name: program_lengths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_lengths (
    id bigint NOT NULL,
    length character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: program_lengths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.program_lengths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: program_lengths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.program_lengths_id_seq OWNED BY public.program_lengths.id;


--
-- Name: regional_pitch_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_pitch_events (
    id integer NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    ends_at timestamp without time zone NOT NULL,
    chapter_ambassador_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    division_id integer,
    city character varying,
    venue_address character varying,
    event_link character varying,
    name character varying,
    unofficial boolean DEFAULT true,
    seasons text[] DEFAULT '{}'::text[],
    teams_count integer DEFAULT 0,
    capacity integer
);


--
-- Name: regional_pitch_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_pitch_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regional_pitch_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regional_pitch_events_id_seq OWNED BY public.regional_pitch_events.id;


--
-- Name: regional_pitch_events_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_pitch_events_teams (
    regional_pitch_event_id integer,
    team_id integer
);


--
-- Name: regional_pitch_events_user_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_pitch_events_user_invitations (
    id bigint NOT NULL,
    regional_pitch_event_id bigint,
    user_invitation_id bigint
);


--
-- Name: regional_pitch_events_user_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_pitch_events_user_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regional_pitch_events_user_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regional_pitch_events_user_invitations_id_seq OWNED BY public.regional_pitch_events_user_invitations.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: saved_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_searches (
    id bigint NOT NULL,
    searcher_type character varying NOT NULL,
    searcher_id bigint NOT NULL,
    name character varying NOT NULL,
    search_string character varying NOT NULL,
    param_root character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: saved_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saved_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saved_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saved_searches_id_seq OWNED BY public.saved_searches.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: screenshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.screenshots (
    id integer NOT NULL,
    team_submission_id integer,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sort_position integer DEFAULT 0 NOT NULL
);


--
-- Name: screenshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.screenshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: screenshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.screenshots_id_seq OWNED BY public.screenshots.id;


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_profiles (
    id integer NOT NULL,
    account_id integer,
    parent_guardian_email character varying,
    parent_guardian_name character varying,
    school_name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    onboarded boolean DEFAULT false,
    deleted_at timestamp without time zone,
    chapter_id bigint
);


--
-- Name: student_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_profiles_id_seq OWNED BY public.student_profiles.id;


--
-- Name: submission_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_scores (
    id integer NOT NULL,
    team_submission_id integer,
    judge_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ideation_comment text,
    technical_comment text,
    entrepreneurship_comment text,
    pitch_comment text,
    overall_comment text,
    completed_at timestamp without time zone,
    event_type character varying,
    deleted_at timestamp without time zone,
    round integer DEFAULT 0 NOT NULL,
    official boolean DEFAULT true,
    seasons text[] DEFAULT '{}'::text[],
    ideation_comment_word_count integer DEFAULT 0,
    technical_comment_word_count integer DEFAULT 0,
    pitch_comment_word_count integer DEFAULT 0,
    entrepreneurship_comment_word_count integer DEFAULT 0,
    overall_comment_word_count integer DEFAULT 0,
    completed_too_fast boolean DEFAULT false,
    completed_too_fast_repeat_offense boolean DEFAULT false,
    seems_too_low boolean DEFAULT false,
    approved_at timestamp without time zone,
    dropped_at timestamp without time zone,
    ideation_1 integer DEFAULT 0,
    ideation_2 integer DEFAULT 0,
    ideation_3 integer DEFAULT 0,
    ideation_4 integer DEFAULT 0,
    technical_1 integer DEFAULT 0,
    technical_2 integer DEFAULT 0,
    technical_3 integer DEFAULT 0,
    technical_4 integer DEFAULT 0,
    pitch_1 integer DEFAULT 0,
    pitch_2 integer DEFAULT 0,
    entrepreneurship_1 integer DEFAULT 0,
    entrepreneurship_2 integer DEFAULT 0,
    entrepreneurship_3 integer DEFAULT 0,
    entrepreneurship_4 integer DEFAULT 0,
    overall_1 integer DEFAULT 0,
    overall_2 integer DEFAULT 0,
    clicked_pitch_video boolean DEFAULT false NOT NULL,
    clicked_demo_video boolean DEFAULT false NOT NULL,
    downloaded_source_code boolean DEFAULT false NOT NULL,
    downloaded_business_plan boolean DEFAULT false NOT NULL,
    judge_recusal boolean DEFAULT false NOT NULL,
    judge_recusal_reason public.judge_recusal_from_submission_reason,
    judge_recusal_comment character varying,
    project_details_1 integer DEFAULT 0,
    pitch_3 integer DEFAULT 0,
    pitch_4 integer DEFAULT 0,
    pitch_5 integer DEFAULT 0,
    pitch_6 integer DEFAULT 0,
    pitch_7 integer DEFAULT 0,
    pitch_8 integer DEFAULT 0,
    demo_1 integer DEFAULT 0,
    demo_2 integer DEFAULT 0,
    demo_3 integer DEFAULT 0,
    project_details_comment text,
    project_details_comment_word_count integer DEFAULT 0,
    demo_comment text,
    demo_comment_word_count integer DEFAULT 0,
    demo_4 integer DEFAULT 0
);


--
-- Name: submission_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_scores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submission_scores_id_seq OWNED BY public.submission_scores.id;


--
-- Name: team_member_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_member_invites (
    id integer NOT NULL,
    inviter_id integer NOT NULL,
    team_id integer NOT NULL,
    invitee_email character varying,
    invitee_id integer,
    invite_token character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invitee_type character varying,
    inviter_type character varying
);


--
-- Name: team_member_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_member_invites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_member_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_member_invites_id_seq OWNED BY public.team_member_invites.id;


--
-- Name: team_submission_gadget_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_submission_gadget_types (
    id bigint NOT NULL,
    team_submission_id bigint,
    gadget_type_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: team_submission_gadget_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_submission_gadget_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_submission_gadget_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_submission_gadget_types_id_seq OWNED BY public.team_submission_gadget_types.id;


--
-- Name: team_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_submissions (
    id integer NOT NULL,
    integrity_affirmed boolean DEFAULT false NOT NULL,
    team_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_code character varying,
    app_description text,
    app_name character varying,
    pitch_video_link character varying,
    development_platform_other character varying,
    development_platform integer,
    slug character varying,
    submission_scores_count integer,
    judge_opened_id integer,
    judge_opened_at timestamp without time zone,
    quarterfinals_average_score numeric(5,2) DEFAULT 0.0 NOT NULL,
    average_unofficial_score numeric(5,2) DEFAULT 0.0 NOT NULL,
    contest_rank integer DEFAULT 0 NOT NULL,
    complete_semifinals_submission_scores_count integer DEFAULT 0 NOT NULL,
    complete_quarterfinals_submission_scores_count integer DEFAULT 0 NOT NULL,
    semifinals_average_score numeric(5,2) DEFAULT 0.0 NOT NULL,
    complete_semifinals_official_submission_scores_count integer DEFAULT 0 NOT NULL,
    complete_quarterfinals_official_submission_scores_count integer DEFAULT 0 NOT NULL,
    pending_semifinals_submission_scores_count integer DEFAULT 0 NOT NULL,
    pending_quarterfinals_submission_scores_count integer DEFAULT 0 NOT NULL,
    pending_semifinals_official_submission_scores_count integer DEFAULT 0 NOT NULL,
    pending_quarterfinals_official_submission_scores_count integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    percent_complete integer DEFAULT 0 NOT NULL,
    seasons text[] DEFAULT '{}'::text[],
    app_inventor_app_name character varying,
    app_inventor_gmail character varying,
    published_at timestamp without time zone,
    business_plan character varying,
    pitch_presentation character varying,
    thunkable_account_email character varying,
    thunkable_project_url character varying,
    source_code_external_url character varying,
    quarterfinals_score_range integer DEFAULT 0,
    semifinals_score_range integer DEFAULT 0,
    demo_video_link character varying,
    ai boolean,
    ai_description character varying,
    climate_change boolean,
    climate_change_description character varying,
    game boolean,
    game_description character varying,
    judge_recusal_count integer DEFAULT 0 NOT NULL,
    submission_type integer,
    learning_journey text,
    uses_open_ai boolean,
    uses_open_ai_description character varying,
    solves_hunger_or_food_waste boolean,
    solves_hunger_or_food_waste_description character varying,
    solves_health_problem boolean,
    solves_health_problem_description character varying,
    solves_education boolean,
    solves_education_description character varying,
    scratch_project_url character varying,
    uses_gadgets boolean,
    uses_gadgets_description character varying
);


--
-- Name: team_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_submissions_id_seq OWNED BY public.team_submissions.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    division_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    team_photo character varying,
    legacy_id character varying,
    accepting_student_requests boolean DEFAULT true NOT NULL,
    accepting_mentor_requests boolean DEFAULT true NOT NULL,
    latitude double precision,
    longitude double precision,
    seasons text[] DEFAULT '{}'::text[],
    city character varying,
    state_province character varying,
    country character varying,
    deleted_at timestamp without time zone,
    has_students boolean DEFAULT false NOT NULL,
    has_mentor boolean DEFAULT false NOT NULL,
    all_students_onboarded boolean DEFAULT false
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: unconfirmed_email_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unconfirmed_email_addresses (
    id bigint NOT NULL,
    email character varying,
    account_id bigint,
    confirmation_token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unconfirmed_email_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unconfirmed_email_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unconfirmed_email_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unconfirmed_email_addresses_id_seq OWNED BY public.unconfirmed_email_addresses.id;


--
-- Name: user_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_invitations (
    id bigint NOT NULL,
    admin_permission_token character varying NOT NULL,
    email character varying NOT NULL,
    account_id integer,
    profile_type integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    register_at_any_time boolean,
    invited_by_id integer,
    chapter_id bigint
);


--
-- Name: user_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_invitations_id_seq OWNED BY public.user_invitations.id;


--
-- Name: webhook_payloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhook_payloads (
    id bigint NOT NULL,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: webhook_payloads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.webhook_payloads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webhook_payloads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.webhook_payloads_id_seq OWNED BY public.webhook_payloads.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: admin_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_profiles ALTER COLUMN id SET DEFAULT nextval('public.admin_profiles_id_seq'::regclass);


--
-- Name: availability_slots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability_slots ALTER COLUMN id SET DEFAULT nextval('public.availability_slots_id_seq'::regclass);


--
-- Name: background_checks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.background_checks ALTER COLUMN id SET DEFAULT nextval('public.background_checks_id_seq'::regclass);


--
-- Name: business_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_plans ALTER COLUMN id SET DEFAULT nextval('public.business_plans_id_seq'::regclass);


--
-- Name: certificates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates ALTER COLUMN id SET DEFAULT nextval('public.certificates_id_seq'::regclass);


--
-- Name: chapter_ambassador_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_ambassador_profiles ALTER COLUMN id SET DEFAULT nextval('public.chapter_ambassador_profiles_id_seq'::regclass);


--
-- Name: chapter_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_links ALTER COLUMN id SET DEFAULT nextval('public.chapter_links_id_seq'::regclass);


--
-- Name: chapter_program_information id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information ALTER COLUMN id SET DEFAULT nextval('public.chapter_program_information_id_seq'::regclass);


--
-- Name: chapter_program_information_meeting_facilitators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_facilitators ALTER COLUMN id SET DEFAULT nextval('public.chapter_program_information_meeting_facilitators_id_seq'::regclass);


--
-- Name: chapter_program_information_meeting_times id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_times ALTER COLUMN id SET DEFAULT nextval('public.chapter_program_information_meeting_times_id_seq'::regclass);


--
-- Name: chapter_program_information_organization_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_organization_types ALTER COLUMN id SET DEFAULT nextval('public.chapter_program_information_organization_types_id_seq'::regclass);


--
-- Name: chapterable_account_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapterable_account_assignments ALTER COLUMN id SET DEFAULT nextval('public.chapterable_account_assignments_id_seq'::regclass);


--
-- Name: chapters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapters ALTER COLUMN id SET DEFAULT nextval('public.chapters_id_seq'::regclass);


--
-- Name: club_ambassador_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_ambassador_profiles ALTER COLUMN id SET DEFAULT nextval('public.club_ambassador_profiles_id_seq'::regclass);


--
-- Name: clubs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clubs ALTER COLUMN id SET DEFAULT nextval('public.clubs_id_seq'::regclass);


--
-- Name: community_connection_availability_slots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connection_availability_slots ALTER COLUMN id SET DEFAULT nextval('public.community_connection_availability_slots_id_seq'::regclass);


--
-- Name: community_connections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connections ALTER COLUMN id SET DEFAULT nextval('public.community_connections_id_seq'::regclass);


--
-- Name: consent_waivers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consent_waivers ALTER COLUMN id SET DEFAULT nextval('public.consent_waivers_id_seq'::regclass);


--
-- Name: divisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions ALTER COLUMN id SET DEFAULT nextval('public.divisions_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: expertises id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expertises ALTER COLUMN id SET DEFAULT nextval('public.expertises_id_seq'::regclass);


--
-- Name: exports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports ALTER COLUMN id SET DEFAULT nextval('public.exports_id_seq'::regclass);


--
-- Name: gadget_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gadget_types ALTER COLUMN id SET DEFAULT nextval('public.gadget_types_id_seq'::regclass);


--
-- Name: honor_code_agreements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.honor_code_agreements ALTER COLUMN id SET DEFAULT nextval('public.honor_code_agreements_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: join_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.join_requests ALTER COLUMN id SET DEFAULT nextval('public.join_requests_id_seq'::regclass);


--
-- Name: judge_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_assignments ALTER COLUMN id SET DEFAULT nextval('public.judge_assignments_id_seq'::regclass);


--
-- Name: judge_profile_judge_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profile_judge_types ALTER COLUMN id SET DEFAULT nextval('public.judge_profile_judge_types_id_seq'::regclass);


--
-- Name: judge_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profiles ALTER COLUMN id SET DEFAULT nextval('public.judge_profiles_id_seq'::regclass);


--
-- Name: judge_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_types ALTER COLUMN id SET DEFAULT nextval('public.judge_types_id_seq'::regclass);


--
-- Name: legal_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_contacts ALTER COLUMN id SET DEFAULT nextval('public.legal_contacts_id_seq'::regclass);


--
-- Name: low_income_estimates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.low_income_estimates ALTER COLUMN id SET DEFAULT nextval('public.low_income_estimates_id_seq'::regclass);


--
-- Name: media_consents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_consents ALTER COLUMN id SET DEFAULT nextval('public.media_consents_id_seq'::regclass);


--
-- Name: meeting_facilitators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_facilitators ALTER COLUMN id SET DEFAULT nextval('public.meeting_facilitators_id_seq'::regclass);


--
-- Name: meeting_times id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_times ALTER COLUMN id SET DEFAULT nextval('public.meeting_times_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: mentor_profile_expertises id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_expertises ALTER COLUMN id SET DEFAULT nextval('public.mentor_profile_expertises_id_seq'::regclass);


--
-- Name: mentor_profile_mentor_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_mentor_types ALTER COLUMN id SET DEFAULT nextval('public.mentor_profile_mentor_types_id_seq'::regclass);


--
-- Name: mentor_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles ALTER COLUMN id SET DEFAULT nextval('public.mentor_profiles_id_seq'::regclass);


--
-- Name: mentor_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_types ALTER COLUMN id SET DEFAULT nextval('public.mentor_types_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: multi_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_messages ALTER COLUMN id SET DEFAULT nextval('public.multi_messages_id_seq'::regclass);


--
-- Name: organization_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_types ALTER COLUMN id SET DEFAULT nextval('public.organization_types_id_seq'::regclass);


--
-- Name: parental_consents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parental_consents ALTER COLUMN id SET DEFAULT nextval('public.parental_consents_id_seq'::regclass);


--
-- Name: participant_count_estimates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_count_estimates ALTER COLUMN id SET DEFAULT nextval('public.participant_count_estimates_id_seq'::regclass);


--
-- Name: pitch_presentations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_presentations ALTER COLUMN id SET DEFAULT nextval('public.pitch_presentations_id_seq'::regclass);


--
-- Name: program_lengths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_lengths ALTER COLUMN id SET DEFAULT nextval('public.program_lengths_id_seq'::regclass);


--
-- Name: regional_pitch_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events ALTER COLUMN id SET DEFAULT nextval('public.regional_pitch_events_id_seq'::regclass);


--
-- Name: regional_pitch_events_user_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_user_invitations ALTER COLUMN id SET DEFAULT nextval('public.regional_pitch_events_user_invitations_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: saved_searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_searches ALTER COLUMN id SET DEFAULT nextval('public.saved_searches_id_seq'::regclass);


--
-- Name: screenshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.screenshots ALTER COLUMN id SET DEFAULT nextval('public.screenshots_id_seq'::regclass);


--
-- Name: student_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles ALTER COLUMN id SET DEFAULT nextval('public.student_profiles_id_seq'::regclass);


--
-- Name: submission_scores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_scores ALTER COLUMN id SET DEFAULT nextval('public.submission_scores_id_seq'::regclass);


--
-- Name: team_member_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_member_invites ALTER COLUMN id SET DEFAULT nextval('public.team_member_invites_id_seq'::regclass);


--
-- Name: team_submission_gadget_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submission_gadget_types ALTER COLUMN id SET DEFAULT nextval('public.team_submission_gadget_types_id_seq'::regclass);


--
-- Name: team_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submissions ALTER COLUMN id SET DEFAULT nextval('public.team_submissions_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: unconfirmed_email_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unconfirmed_email_addresses ALTER COLUMN id SET DEFAULT nextval('public.unconfirmed_email_addresses_id_seq'::regclass);


--
-- Name: user_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations ALTER COLUMN id SET DEFAULT nextval('public.user_invitations_id_seq'::regclass);


--
-- Name: webhook_payloads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_payloads ALTER COLUMN id SET DEFAULT nextval('public.webhook_payloads_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: admin_profiles admin_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_profiles
    ADD CONSTRAINT admin_profiles_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: availability_slots availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability_slots
    ADD CONSTRAINT availability_slots_pkey PRIMARY KEY (id);


--
-- Name: background_checks background_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.background_checks
    ADD CONSTRAINT background_checks_pkey PRIMARY KEY (id);


--
-- Name: business_plans business_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_plans
    ADD CONSTRAINT business_plans_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: chapter_ambassador_profiles chapter_ambassador_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_ambassador_profiles
    ADD CONSTRAINT chapter_ambassador_profiles_pkey PRIMARY KEY (id);


--
-- Name: chapter_links chapter_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_links
    ADD CONSTRAINT chapter_links_pkey PRIMARY KEY (id);


--
-- Name: chapter_program_information_meeting_facilitators chapter_program_information_meeting_facilitators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_facilitators
    ADD CONSTRAINT chapter_program_information_meeting_facilitators_pkey PRIMARY KEY (id);


--
-- Name: chapter_program_information_meeting_times chapter_program_information_meeting_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_times
    ADD CONSTRAINT chapter_program_information_meeting_times_pkey PRIMARY KEY (id);


--
-- Name: chapter_program_information_organization_types chapter_program_information_organization_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_organization_types
    ADD CONSTRAINT chapter_program_information_organization_types_pkey PRIMARY KEY (id);


--
-- Name: chapter_program_information chapter_program_information_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information
    ADD CONSTRAINT chapter_program_information_pkey PRIMARY KEY (id);


--
-- Name: chapterable_account_assignments chapterable_account_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapterable_account_assignments
    ADD CONSTRAINT chapterable_account_assignments_pkey PRIMARY KEY (id);


--
-- Name: chapters chapters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (id);


--
-- Name: club_ambassador_profiles club_ambassador_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_ambassador_profiles
    ADD CONSTRAINT club_ambassador_profiles_pkey PRIMARY KEY (id);


--
-- Name: clubs clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT clubs_pkey PRIMARY KEY (id);


--
-- Name: community_connection_availability_slots community_connection_availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connection_availability_slots
    ADD CONSTRAINT community_connection_availability_slots_pkey PRIMARY KEY (id);


--
-- Name: community_connections community_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connections
    ADD CONSTRAINT community_connections_pkey PRIMARY KEY (id);


--
-- Name: consent_waivers consent_waivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consent_waivers
    ADD CONSTRAINT consent_waivers_pkey PRIMARY KEY (id);


--
-- Name: divisions divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: expertises expertises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expertises
    ADD CONSTRAINT expertises_pkey PRIMARY KEY (id);


--
-- Name: exports exports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports
    ADD CONSTRAINT exports_pkey PRIMARY KEY (id);


--
-- Name: gadget_types gadget_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gadget_types
    ADD CONSTRAINT gadget_types_pkey PRIMARY KEY (id);


--
-- Name: honor_code_agreements honor_code_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.honor_code_agreements
    ADD CONSTRAINT honor_code_agreements_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: join_requests join_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.join_requests
    ADD CONSTRAINT join_requests_pkey PRIMARY KEY (id);


--
-- Name: judge_assignments judge_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_assignments
    ADD CONSTRAINT judge_assignments_pkey PRIMARY KEY (id);


--
-- Name: judge_profile_judge_types judge_profile_judge_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profile_judge_types
    ADD CONSTRAINT judge_profile_judge_types_pkey PRIMARY KEY (id);


--
-- Name: judge_profiles judge_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profiles
    ADD CONSTRAINT judge_profiles_pkey PRIMARY KEY (id);


--
-- Name: judge_types judge_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_types
    ADD CONSTRAINT judge_types_pkey PRIMARY KEY (id);


--
-- Name: legal_contacts legal_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_contacts
    ADD CONSTRAINT legal_contacts_pkey PRIMARY KEY (id);


--
-- Name: low_income_estimates low_income_estimates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.low_income_estimates
    ADD CONSTRAINT low_income_estimates_pkey PRIMARY KEY (id);


--
-- Name: media_consents media_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_consents
    ADD CONSTRAINT media_consents_pkey PRIMARY KEY (id);


--
-- Name: meeting_facilitators meeting_facilitators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_facilitators
    ADD CONSTRAINT meeting_facilitators_pkey PRIMARY KEY (id);


--
-- Name: meeting_times meeting_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_times
    ADD CONSTRAINT meeting_times_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: mentor_profile_expertises mentor_profile_expertises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_expertises
    ADD CONSTRAINT mentor_profile_expertises_pkey PRIMARY KEY (id);


--
-- Name: mentor_profile_mentor_types mentor_profile_mentor_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_mentor_types
    ADD CONSTRAINT mentor_profile_mentor_types_pkey PRIMARY KEY (id);


--
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


--
-- Name: mentor_types mentor_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_types
    ADD CONSTRAINT mentor_types_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: multi_messages multi_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_messages
    ADD CONSTRAINT multi_messages_pkey PRIMARY KEY (id);


--
-- Name: organization_types organization_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_types
    ADD CONSTRAINT organization_types_pkey PRIMARY KEY (id);


--
-- Name: parental_consents parental_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parental_consents
    ADD CONSTRAINT parental_consents_pkey PRIMARY KEY (id);


--
-- Name: participant_count_estimates participant_count_estimates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_count_estimates
    ADD CONSTRAINT participant_count_estimates_pkey PRIMARY KEY (id);


--
-- Name: pitch_presentations pitch_presentations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_presentations
    ADD CONSTRAINT pitch_presentations_pkey PRIMARY KEY (id);


--
-- Name: program_lengths program_lengths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_lengths
    ADD CONSTRAINT program_lengths_pkey PRIMARY KEY (id);


--
-- Name: regional_pitch_events regional_pitch_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events
    ADD CONSTRAINT regional_pitch_events_pkey PRIMARY KEY (id);


--
-- Name: regional_pitch_events_user_invitations regional_pitch_events_user_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_user_invitations
    ADD CONSTRAINT regional_pitch_events_user_invitations_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: saved_searches saved_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_searches
    ADD CONSTRAINT saved_searches_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: screenshots screenshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT screenshots_pkey PRIMARY KEY (id);


--
-- Name: student_profiles student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- Name: submission_scores submission_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_scores
    ADD CONSTRAINT submission_scores_pkey PRIMARY KEY (id);


--
-- Name: team_member_invites team_member_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_member_invites
    ADD CONSTRAINT team_member_invites_pkey PRIMARY KEY (id);


--
-- Name: team_submission_gadget_types team_submission_gadget_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submission_gadget_types
    ADD CONSTRAINT team_submission_gadget_types_pkey PRIMARY KEY (id);


--
-- Name: team_submissions team_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submissions
    ADD CONSTRAINT team_submissions_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: unconfirmed_email_addresses unconfirmed_email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unconfirmed_email_addresses
    ADD CONSTRAINT unconfirmed_email_addresses_pkey PRIMARY KEY (id);


--
-- Name: user_invitations user_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations
    ADD CONSTRAINT user_invitations_pkey PRIMARY KEY (id);


--
-- Name: webhook_payloads webhook_payloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_payloads
    ADD CONSTRAINT webhook_payloads_pkey PRIMARY KEY (id);


--
-- Name: events_invites_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_invites_event_id ON public.regional_pitch_events_user_invitations USING btree (regional_pitch_event_id);


--
-- Name: events_invites_invite_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_invites_invite_id ON public.regional_pitch_events_user_invitations USING btree (user_invitation_id);


--
-- Name: index_accounts_on_admin_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_admin_invitation_token ON public.accounts USING btree (admin_invitation_token);


--
-- Name: index_accounts_on_auth_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_auth_token ON public.accounts USING btree (auth_token);


--
-- Name: index_accounts_on_consent_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_consent_token ON public.accounts USING btree (consent_token);


--
-- Name: index_accounts_on_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_division_id ON public.accounts USING btree (division_id);


--
-- Name: index_accounts_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_email ON public.accounts USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: index_accounts_on_mailer_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_mailer_token ON public.accounts USING btree (mailer_token);


--
-- Name: index_accounts_on_password_reset_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_password_reset_token ON public.accounts USING btree (password_reset_token);


--
-- Name: index_accounts_on_session_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_session_token ON public.accounts USING btree (session_token);


--
-- Name: index_activities_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_owner_id_and_owner_type ON public.activities USING btree (owner_id, owner_type);


--
-- Name: index_activities_on_recipient_id_and_recipient_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_recipient_id_and_recipient_type ON public.activities USING btree (recipient_id, recipient_type);


--
-- Name: index_activities_on_trackable_id_and_trackable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_trackable_id_and_trackable_type ON public.activities USING btree (trackable_id, trackable_type);


--
-- Name: index_as_on_as_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_as_on_as_id ON public.community_connection_availability_slots USING btree (availability_slot_id);


--
-- Name: index_background_checks_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_background_checks_on_account_id ON public.background_checks USING btree (account_id);


--
-- Name: index_business_plans_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_plans_on_team_submission_id ON public.business_plans USING btree (team_submission_id);


--
-- Name: index_ccas_on_cc_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ccas_on_cc_id ON public.community_connection_availability_slots USING btree (community_connection_id);


--
-- Name: index_certificates_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_account_id ON public.certificates USING btree (account_id);


--
-- Name: index_certificates_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_team_id ON public.certificates USING btree (team_id);


--
-- Name: index_chapter_account_assignments_on_chapter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_account_assignments_on_chapter ON public.chapterable_account_assignments USING btree (chapterable_type, chapterable_id);


--
-- Name: index_chapter_account_assignments_on_profile; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_account_assignments_on_profile ON public.chapterable_account_assignments USING btree (profile_type, profile_id);


--
-- Name: index_chapter_ambassador_profiles_on_chapter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_ambassador_profiles_on_chapter_id ON public.chapter_ambassador_profiles USING btree (chapter_id);


--
-- Name: index_chapter_ambassador_profiles_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_ambassador_profiles_on_status ON public.chapter_ambassador_profiles USING btree (status);


--
-- Name: index_chapter_links_on_chapter_ambassador_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_links_on_chapter_ambassador_profile_id ON public.chapter_links USING btree (chapter_ambassador_profile_id);


--
-- Name: index_chapter_links_on_chapter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_links_on_chapter_id ON public.chapter_links USING btree (chapter_id);


--
-- Name: index_chapter_program_information_on_chapter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_program_information_on_chapter_id ON public.chapter_program_information USING btree (chapter_id);


--
-- Name: index_chapter_program_information_on_low_income_estimate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_program_information_on_low_income_estimate_id ON public.chapter_program_information USING btree (low_income_estimate_id);


--
-- Name: index_chapter_program_information_on_program_length_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapter_program_information_on_program_length_id ON public.chapter_program_information USING btree (program_length_id);


--
-- Name: index_chapterable_account_assignments_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapterable_account_assignments_on_account_id ON public.chapterable_account_assignments USING btree (account_id);


--
-- Name: index_chapterable_account_assignments_on_chapterable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapterable_account_assignments_on_chapterable_id ON public.chapterable_account_assignments USING btree (chapterable_id);


--
-- Name: index_chapters_on_primary_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapters_on_primary_account_id ON public.chapters USING btree (primary_account_id);


--
-- Name: index_chapters_on_primary_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapters_on_primary_contact_id ON public.chapters USING btree (primary_contact_id);


--
-- Name: index_club_ambassador_profiles_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_club_ambassador_profiles_on_account_id ON public.club_ambassador_profiles USING btree (account_id);


--
-- Name: index_clubs_on_primary_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clubs_on_primary_account_id ON public.clubs USING btree (primary_account_id);


--
-- Name: index_community_connections_on_chapter_ambassador_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_connections_on_chapter_ambassador_profile_id ON public.community_connections USING btree (chapter_ambassador_profile_id);


--
-- Name: index_consent_waivers_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consent_waivers_on_account_id ON public.consent_waivers USING btree (account_id);


--
-- Name: index_cpi_mf_on_chapter_program_information_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cpi_mf_on_chapter_program_information_id ON public.chapter_program_information_meeting_facilitators USING btree (chapter_program_information_id);


--
-- Name: index_cpi_mt_on_chapter_program_information_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cpi_mt_on_chapter_program_information_id ON public.chapter_program_information_meeting_times USING btree (chapter_program_information_id);


--
-- Name: index_cpi_ot_on_chapter_program_information_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cpi_ot_on_chapter_program_information_id ON public.chapter_program_information_organization_types USING btree (chapter_program_information_id);


--
-- Name: index_documents_on_docusign_envelope_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_docusign_envelope_id ON public.documents USING btree (docusign_envelope_id);


--
-- Name: index_documents_on_signer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_signer ON public.documents USING btree (signer_type, signer_id);


--
-- Name: index_honor_code_agreements_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_honor_code_agreements_on_account_id ON public.honor_code_agreements USING btree (account_id);


--
-- Name: index_jobs_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_owner_type_and_owner_id ON public.jobs USING btree (owner_type, owner_id);


--
-- Name: index_join_requests_on_requestor_type_and_requestor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_join_requests_on_requestor_type_and_requestor_id ON public.join_requests USING btree (requestor_type, requestor_id);


--
-- Name: index_join_requests_on_review_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_join_requests_on_review_token ON public.join_requests USING btree (review_token);


--
-- Name: index_join_requests_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_join_requests_on_team_id ON public.join_requests USING btree (team_id);


--
-- Name: index_judge_assignments_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_assignments_on_team_id ON public.judge_assignments USING btree (team_id);


--
-- Name: index_judge_profile_judge_types_on_judge_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_profile_judge_types_on_judge_profile_id ON public.judge_profile_judge_types USING btree (judge_profile_id);


--
-- Name: index_judge_profile_judge_types_on_judge_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_profile_judge_types_on_judge_type_id ON public.judge_profile_judge_types USING btree (judge_type_id);


--
-- Name: index_judge_profiles_on_recusal_scores_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_profiles_on_recusal_scores_count ON public.judge_profiles USING btree (recusal_scores_count);


--
-- Name: index_judge_profiles_on_user_invitation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_profiles_on_user_invitation_id ON public.judge_profiles USING btree (user_invitation_id);


--
-- Name: index_legal_contacts_on_chapter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legal_contacts_on_chapter_id ON public.legal_contacts USING btree (chapter_id);


--
-- Name: index_media_consents_on_student_profile_id_and_season; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_media_consents_on_student_profile_id_and_season ON public.media_consents USING btree (student_profile_id, season);


--
-- Name: index_memberships_on_member_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_member_type ON public.memberships USING btree (member_type);


--
-- Name: index_memberships_on_member_type_and_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_member_type_and_member_id ON public.memberships USING btree (member_type, member_id);


--
-- Name: index_memberships_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_team_id ON public.memberships USING btree (team_id);


--
-- Name: index_mentor_profile_expertises_on_mentor_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_profile_expertises_on_mentor_profile_id ON public.mentor_profile_expertises USING btree (mentor_profile_id);


--
-- Name: index_mentor_profile_mentor_types_on_mentor_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_profile_mentor_types_on_mentor_profile_id ON public.mentor_profile_mentor_types USING btree (mentor_profile_id);


--
-- Name: index_mentor_profile_mentor_types_on_mentor_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_profile_mentor_types_on_mentor_type_id ON public.mentor_profile_mentor_types USING btree (mentor_type_id);


--
-- Name: index_mentor_profiles_on_user_invitation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_profiles_on_user_invitation_id ON public.mentor_profiles USING btree (user_invitation_id);


--
-- Name: index_parental_consents_on_seasons_and_upload_approval_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parental_consents_on_seasons_and_upload_approval_status ON public.parental_consents USING btree (seasons, upload_approval_status);


--
-- Name: index_parental_consents_on_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parental_consents_on_student_profile_id ON public.parental_consents USING btree (student_profile_id);


--
-- Name: index_regional_pitch_events_on_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regional_pitch_events_on_division_id ON public.regional_pitch_events USING btree (division_id);


--
-- Name: index_saved_searches_on_searcher_type_and_searcher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_searches_on_searcher_type_and_searcher_id ON public.saved_searches USING btree (searcher_type, searcher_id);


--
-- Name: index_screenshots_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_screenshots_on_team_submission_id ON public.screenshots USING btree (team_submission_id);


--
-- Name: index_student_profiles_on_chapter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_student_profiles_on_chapter_id ON public.student_profiles USING btree (chapter_id);


--
-- Name: index_student_profiles_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_student_profiles_on_deleted_at ON public.student_profiles USING btree (deleted_at);


--
-- Name: index_submission_scores_on_completed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_completed_at ON public.submission_scores USING btree (completed_at);


--
-- Name: index_submission_scores_on_judge_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_judge_profile_id ON public.submission_scores USING btree (judge_profile_id);


--
-- Name: index_submission_scores_on_judge_recusal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_judge_recusal ON public.submission_scores USING btree (judge_recusal);


--
-- Name: index_submission_scores_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_team_submission_id ON public.submission_scores USING btree (team_submission_id);


--
-- Name: index_table_chapter_account_assignments_on_account_chapter_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_table_chapter_account_assignments_on_account_chapter_ids ON public.chapterable_account_assignments USING btree (account_id, chapterable_id);


--
-- Name: index_table_chapter_account_assignments_on_chapter_account_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_table_chapter_account_assignments_on_chapter_account_ids ON public.chapterable_account_assignments USING btree (chapterable_id, account_id);


--
-- Name: index_team_member_invites_on_invite_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_team_member_invites_on_invite_token ON public.team_member_invites USING btree (invite_token);


--
-- Name: index_team_member_invites_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_member_invites_on_status ON public.team_member_invites USING btree (status);


--
-- Name: index_team_submission_gadget_types_on_gadget_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_submission_gadget_types_on_gadget_type_id ON public.team_submission_gadget_types USING btree (gadget_type_id);


--
-- Name: index_team_submission_gadget_types_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_submission_gadget_types_on_team_submission_id ON public.team_submission_gadget_types USING btree (team_submission_id);


--
-- Name: index_team_submissions_on_judge_recusal_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_submissions_on_judge_recusal_count ON public.team_submissions USING btree (judge_recusal_count);


--
-- Name: index_teams_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_teams_on_legacy_id ON public.teams USING btree (legacy_id);


--
-- Name: index_unconfirmed_email_addresses_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_unconfirmed_email_addresses_on_account_id ON public.unconfirmed_email_addresses USING btree (account_id);


--
-- Name: index_user_invitations_on_chapter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_invitations_on_chapter_id ON public.user_invitations USING btree (chapter_id);


--
-- Name: meeting_facilitator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meeting_facilitator_id ON public.chapter_program_information_meeting_facilitators USING btree (meeting_facilitator_id);


--
-- Name: meeting_time_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meeting_time_id ON public.chapter_program_information_meeting_times USING btree (meeting_time_id);


--
-- Name: organization_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organization_type_id ON public.chapter_program_information_organization_types USING btree (organization_type_id);


--
-- Name: participant_count_estimate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX participant_count_estimate_id ON public.chapter_program_information USING btree (participant_count_estimate_id);


--
-- Name: pitch_events_team_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pitch_events_team_ids ON public.regional_pitch_events_teams USING btree (team_id);


--
-- Name: pitch_events_teams; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX pitch_events_teams ON public.regional_pitch_events_teams USING btree (regional_pitch_event_id, team_id);


--
-- Name: trgm_email_indx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trgm_email_indx ON public.accounts USING gist (email public.gist_trgm_ops);


--
-- Name: trgm_first_name_indx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trgm_first_name_indx ON public.accounts USING gist (first_name public.gist_trgm_ops);


--
-- Name: trgm_last_name_indx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trgm_last_name_indx ON public.accounts USING gist (last_name public.gist_trgm_ops);


--
-- Name: trgm_team_name_indx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trgm_team_name_indx ON public.teams USING gist (name public.gist_trgm_ops);


--
-- Name: uniq_admins_accounts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_admins_accounts ON public.admin_profiles USING btree (account_id);


--
-- Name: uniq_ambassadors_accounts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_ambassadors_accounts ON public.chapter_ambassador_profiles USING btree (account_id);


--
-- Name: uniq_judges_accounts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_judges_accounts ON public.judge_profiles USING btree (account_id) WHERE (deleted_at IS NULL);


--
-- Name: uniq_mentors_accounts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_mentors_accounts ON public.mentor_profiles USING btree (account_id);


--
-- Name: uniq_students_accounts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_students_accounts ON public.student_profiles USING btree (account_id);


--
-- Name: chapter_program_information_meeting_facilitators fk_rails_04ff66b53d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_facilitators
    ADD CONSTRAINT fk_rails_04ff66b53d FOREIGN KEY (chapter_program_information_id) REFERENCES public.chapter_program_information(id);


--
-- Name: community_connection_availability_slots fk_rails_0b8f604e0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connection_availability_slots
    ADD CONSTRAINT fk_rails_0b8f604e0a FOREIGN KEY (community_connection_id) REFERENCES public.community_connections(id);


--
-- Name: chapter_program_information_organization_types fk_rails_0d8e315484; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_organization_types
    ADD CONSTRAINT fk_rails_0d8e315484 FOREIGN KEY (organization_type_id) REFERENCES public.organization_types(id);


--
-- Name: divisions_regional_pitch_events fk_rails_1064d06b86; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions_regional_pitch_events
    ADD CONSTRAINT fk_rails_1064d06b86 FOREIGN KEY (division_id) REFERENCES public.divisions(id);


--
-- Name: judge_profiles fk_rails_185397937b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profiles
    ADD CONSTRAINT fk_rails_185397937b FOREIGN KEY (user_invitation_id) REFERENCES public.user_invitations(id);


--
-- Name: judge_assignments fk_rails_23ffe332fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_assignments
    ADD CONSTRAINT fk_rails_23ffe332fd FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: judge_profile_judge_types fk_rails_246badf43f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profile_judge_types
    ADD CONSTRAINT fk_rails_246badf43f FOREIGN KEY (judge_profile_id) REFERENCES public.judge_profiles(id);


--
-- Name: regional_pitch_events_teams fk_rails_24f0c96e18; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_teams
    ADD CONSTRAINT fk_rails_24f0c96e18 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: divisions_regional_pitch_events fk_rails_285ce9b10b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions_regional_pitch_events
    ADD CONSTRAINT fk_rails_285ce9b10b FOREIGN KEY (regional_pitch_event_id) REFERENCES public.regional_pitch_events(id);


--
-- Name: chapter_program_information fk_rails_30f8030d7a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information
    ADD CONSTRAINT fk_rails_30f8030d7a FOREIGN KEY (program_length_id) REFERENCES public.program_lengths(id);


--
-- Name: team_submissions fk_rails_34e7653c32; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submissions
    ADD CONSTRAINT fk_rails_34e7653c32 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: mentor_profile_mentor_types fk_rails_38b0d3141a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_mentor_types
    ADD CONSTRAINT fk_rails_38b0d3141a FOREIGN KEY (mentor_type_id) REFERENCES public.mentor_types(id);


--
-- Name: chapter_program_information_organization_types fk_rails_38f0326fd3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_organization_types
    ADD CONSTRAINT fk_rails_38f0326fd3 FOREIGN KEY (chapter_program_information_id) REFERENCES public.chapter_program_information(id);


--
-- Name: regional_pitch_events_user_invitations fk_rails_3bbe8623e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_user_invitations
    ADD CONSTRAINT fk_rails_3bbe8623e3 FOREIGN KEY (user_invitation_id) REFERENCES public.user_invitations(id);


--
-- Name: chapter_program_information fk_rails_41d22ed899; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information
    ADD CONSTRAINT fk_rails_41d22ed899 FOREIGN KEY (participant_count_estimate_id) REFERENCES public.participant_count_estimates(id);


--
-- Name: user_invitations fk_rails_4e77e2e432; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations
    ADD CONSTRAINT fk_rails_4e77e2e432 FOREIGN KEY (chapter_id) REFERENCES public.chapters(id);


--
-- Name: accounts fk_rails_55bc732a9a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_55bc732a9a FOREIGN KEY (division_id) REFERENCES public.divisions(id);


--
-- Name: regional_pitch_events_user_invitations fk_rails_6040809c97; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_user_invitations
    ADD CONSTRAINT fk_rails_6040809c97 FOREIGN KEY (regional_pitch_event_id) REFERENCES public.regional_pitch_events(id);


--
-- Name: team_submission_gadget_types fk_rails_69b9473c55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submission_gadget_types
    ADD CONSTRAINT fk_rails_69b9473c55 FOREIGN KEY (gadget_type_id) REFERENCES public.gadget_types(id);


--
-- Name: consent_waivers fk_rails_6dd1d3738c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consent_waivers
    ADD CONSTRAINT fk_rails_6dd1d3738c FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: community_connections fk_rails_714931f495; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connections
    ADD CONSTRAINT fk_rails_714931f495 FOREIGN KEY (chapter_ambassador_profile_id) REFERENCES public.chapter_ambassador_profiles(id);


--
-- Name: team_submission_gadget_types fk_rails_7528bbfcc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submission_gadget_types
    ADD CONSTRAINT fk_rails_7528bbfcc1 FOREIGN KEY (team_submission_id) REFERENCES public.team_submissions(id);


--
-- Name: certificates fk_rails_75edbeede4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_75edbeede4 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: chapter_ambassador_profiles fk_rails_793dbc1d27; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_ambassador_profiles
    ADD CONSTRAINT fk_rails_793dbc1d27 FOREIGN KEY (chapter_id) REFERENCES public.chapters(id);


--
-- Name: join_requests fk_rails_7fd972d7ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.join_requests
    ADD CONSTRAINT fk_rails_7fd972d7ce FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: mentor_profile_expertises fk_rails_805b007c4f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_expertises
    ADD CONSTRAINT fk_rails_805b007c4f FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id);


--
-- Name: parental_consents fk_rails_837621b019; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parental_consents
    ADD CONSTRAINT fk_rails_837621b019 FOREIGN KEY (student_profile_id) REFERENCES public.student_profiles(id);


--
-- Name: chapter_program_information fk_rails_8d148a7c2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information
    ADD CONSTRAINT fk_rails_8d148a7c2c FOREIGN KEY (low_income_estimate_id) REFERENCES public.low_income_estimates(id);


--
-- Name: mentor_profile_expertises fk_rails_9231fb852d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_expertises
    ADD CONSTRAINT fk_rails_9231fb852d FOREIGN KEY (expertise_id) REFERENCES public.expertises(id);


--
-- Name: regional_pitch_events_teams fk_rails_96288d546f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_teams
    ADD CONSTRAINT fk_rails_96288d546f FOREIGN KEY (regional_pitch_event_id) REFERENCES public.regional_pitch_events(id);


--
-- Name: unconfirmed_email_addresses fk_rails_99a8a3bded; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unconfirmed_email_addresses
    ADD CONSTRAINT fk_rails_99a8a3bded FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: mentor_profiles fk_rails_9a3cf8d620; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT fk_rails_9a3cf8d620 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: judge_profile_judge_types fk_rails_9ad24ddcf6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profile_judge_types
    ADD CONSTRAINT fk_rails_9ad24ddcf6 FOREIGN KEY (judge_type_id) REFERENCES public.judge_types(id);


--
-- Name: community_connection_availability_slots fk_rails_9e00216d41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_connection_availability_slots
    ADD CONSTRAINT fk_rails_9e00216d41 FOREIGN KEY (availability_slot_id) REFERENCES public.availability_slots(id);


--
-- Name: screenshots fk_rails_9f5eed79ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT fk_rails_9f5eed79ce FOREIGN KEY (team_submission_id) REFERENCES public.team_submissions(id);


--
-- Name: submission_scores fk_rails_afdf541e79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_scores
    ADD CONSTRAINT fk_rails_afdf541e79 FOREIGN KEY (judge_profile_id) REFERENCES public.judge_profiles(id);


--
-- Name: chapters fk_rails_b047a2142a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT fk_rails_b047a2142a FOREIGN KEY (primary_contact_id) REFERENCES public.chapter_ambassador_profiles(id);


--
-- Name: chapters fk_rails_b0d5340759; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT fk_rails_b0d5340759 FOREIGN KEY (primary_account_id) REFERENCES public.accounts(id);


--
-- Name: chapter_program_information_meeting_times fk_rails_b3eaf5a58a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_times
    ADD CONSTRAINT fk_rails_b3eaf5a58a FOREIGN KEY (chapter_program_information_id) REFERENCES public.chapter_program_information(id);


--
-- Name: chapter_program_information_meeting_times fk_rails_b66230ffb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_times
    ADD CONSTRAINT fk_rails_b66230ffb6 FOREIGN KEY (meeting_time_id) REFERENCES public.meeting_times(id);


--
-- Name: mentor_profile_mentor_types fk_rails_b776f096c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_mentor_types
    ADD CONSTRAINT fk_rails_b776f096c9 FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id);


--
-- Name: chapter_links fk_rails_b88e121da0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_links
    ADD CONSTRAINT fk_rails_b88e121da0 FOREIGN KEY (chapter_ambassador_profile_id) REFERENCES public.chapter_ambassador_profiles(id);


--
-- Name: mentor_profiles fk_rails_beb02031d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT fk_rails_beb02031d5 FOREIGN KEY (user_invitation_id) REFERENCES public.user_invitations(id);


--
-- Name: submission_scores fk_rails_c08133669a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_scores
    ADD CONSTRAINT fk_rails_c08133669a FOREIGN KEY (team_submission_id) REFERENCES public.team_submissions(id);


--
-- Name: student_profiles fk_rails_c18d1e4562; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT fk_rails_c18d1e4562 FOREIGN KEY (chapter_id) REFERENCES public.chapters(id);


--
-- Name: regional_pitch_events fk_rails_c377215e38; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events
    ADD CONSTRAINT fk_rails_c377215e38 FOREIGN KEY (division_id) REFERENCES public.divisions(id);


--
-- Name: admin_profiles fk_rails_c70dd3b9e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_profiles
    ADD CONSTRAINT fk_rails_c70dd3b9e0 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: chapter_links fk_rails_ca99b2153e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_links
    ADD CONSTRAINT fk_rails_ca99b2153e FOREIGN KEY (chapter_id) REFERENCES public.chapters(id);


--
-- Name: certificates fk_rails_ddedb55856; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_ddedb55856 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: club_ambassador_profiles fk_rails_de21d3b8fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_ambassador_profiles
    ADD CONSTRAINT fk_rails_de21d3b8fb FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: business_plans fk_rails_de87026bfd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_plans
    ADD CONSTRAINT fk_rails_de87026bfd FOREIGN KEY (team_submission_id) REFERENCES public.team_submissions(id);


--
-- Name: clubs fk_rails_e24e16d93e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT fk_rails_e24e16d93e FOREIGN KEY (primary_account_id) REFERENCES public.accounts(id);


--
-- Name: legal_contacts fk_rails_e57ad14bd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_contacts
    ADD CONSTRAINT fk_rails_e57ad14bd5 FOREIGN KEY (chapter_id) REFERENCES public.chapters(id);


--
-- Name: chapter_program_information_meeting_facilitators fk_rails_f261bac187; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information_meeting_facilitators
    ADD CONSTRAINT fk_rails_f261bac187 FOREIGN KEY (meeting_facilitator_id) REFERENCES public.meeting_facilitators(id);


--
-- Name: background_checks fk_rails_f5be68f7c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.background_checks
    ADD CONSTRAINT fk_rails_f5be68f7c1 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: teams fk_rails_f5e3e59211; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_rails_f5e3e59211 FOREIGN KEY (division_id) REFERENCES public.divisions(id);


--
-- Name: chapter_program_information fk_rails_ff5375610f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_program_information
    ADD CONSTRAINT fk_rails_ff5375610f FOREIGN KEY (chapter_id) REFERENCES public.chapters(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170330022645'),
('20170403171506'),
('20170404211311'),
('20170411155706'),
('20170411163946'),
('20170412153616'),
('20170418143205'),
('20170418155147'),
('20170418155148'),
('20170420210612'),
('20170421141723'),
('20170425094152'),
('20170425143550'),
('20170501141721'),
('20170503170451'),
('20170503185441'),
('20170504203342'),
('20170505205808'),
('20170505213902'),
('20170511160540'),
('20170511160750'),
('20170515171335'),
('20170515173429'),
('20170517233723'),
('20170605205707'),
('20170613141734'),
('20170620233704'),
('20170803212027'),
('20170816030651'),
('20170817184332'),
('20170817204655'),
('20170817231442'),
('20170817231443'),
('20170817231444'),
('20170830153923'),
('20170830154137'),
('20170830205237'),
('20170831151120'),
('20170831151121'),
('20170831151122'),
('20170913143813'),
('20170913163542'),
('20170913190928'),
('20170913190935'),
('20170920161533'),
('20170921152527'),
('20171003153733'),
('20171003154720'),
('20171003154750'),
('20171011180054'),
('20171017220818'),
('20171018170002'),
('20171018184701'),
('20171019162859'),
('20171019230800'),
('20171020085320'),
('20171020135709'),
('20171026165624'),
('20171028162512'),
('20171031184535'),
('20171031184604'),
('20171103213524'),
('20171107171527'),
('20171107174332'),
('20171107224419'),
('20171107225231'),
('20171107233018'),
('20171108140911'),
('20171113170115'),
('20171113170150'),
('20171113215850'),
('20171113221502'),
('20171113232015'),
('20171114163826'),
('20171114175205'),
('20171114182734'),
('20171114183901'),
('20171114185301'),
('20171115152731'),
('20171117134239'),
('20171117142253'),
('20171117150649'),
('20171120200105'),
('20171120200106'),
('20171120200239'),
('20171121175628'),
('20171204220222'),
('20171204220418'),
('20171207180553'),
('20180102162930'),
('20180117190150'),
('20180126195041'),
('20180129165533'),
('20180129165702'),
('20180202143954'),
('20180202145820'),
('20180206152207'),
('20180206184914'),
('20180206193752'),
('20180209162551'),
('20180216172108'),
('20180216172742'),
('20180228150454'),
('20180228172449'),
('20180301140524'),
('20180313204753'),
('20180314144804'),
('20180322201531'),
('20180328171732'),
('20180409220653'),
('20180410160317'),
('20180410171021'),
('20180410201244'),
('20180411134940'),
('20180418162816'),
('20180418193758'),
('20180419155950'),
('20180419164217'),
('20180419181556'),
('20180420141640'),
('20180501194208'),
('20180516145423'),
('20180614140324'),
('20180618152654'),
('20180619154728'),
('20180619194316'),
('20180622151517'),
('20180622152409'),
('20180622161117'),
('20180626200957'),
('20180703153546'),
('20180716151350'),
('20180724171119'),
('20180725175239'),
('20180725175328'),
('20180727200157'),
('20180731150846'),
('20180731162422'),
('20180803154914'),
('20180803163656'),
('20180814162134'),
('20180814163118'),
('20180814163651'),
('20180914192841'),
('20180919140514'),
('20180925143744'),
('20180925184416'),
('20180926192206'),
('20180927235304'),
('20180927235305'),
('20181001181253'),
('20181108210955'),
('20181115163525'),
('20181218164555'),
('20190111171657'),
('20190206213251'),
('20190206213309'),
('20190207223128'),
('20190213212436'),
('20190228185145'),
('20190328190221'),
('20190403154655'),
('20190506212403'),
('20191008152233'),
('20191014194309'),
('20191120151220'),
('20191120151819'),
('20191220170611'),
('20200115211026'),
('20200303221521'),
('20200508185107'),
('20200720223724'),
('20200720234612'),
('20200722212401'),
('20200903161022'),
('20200914131700'),
('20200928215117'),
('20201014203947'),
('20201109234926'),
('20210128191135'),
('20210201224232'),
('20210222231733'),
('20210319163016'),
('20210407015203'),
('20210426215502'),
('20210430203443'),
('20210831162123'),
('20211125180122'),
('20211204185710'),
('20220105203716'),
('20220106224855'),
('20220114040538'),
('20220114040857'),
('20220405040709'),
('20220406163528'),
('20220406164442'),
('20220426020533'),
('20220914184120'),
('20220929165539'),
('20221220211548'),
('20230104033534'),
('20230104212325'),
('20230112172357'),
('20230118232040'),
('20230119163655'),
('20230530190322'),
('20230609162008'),
('20230609172147'),
('20230609172434'),
('20230609190316'),
('20230613163115'),
('20230626193226'),
('20230727123214'),
('20230809190653'),
('20230810134239'),
('20230905194750'),
('20230914204523'),
('20230921190613'),
('20230925171243'),
('20231005145350'),
('20231016140526'),
('20231016221100'),
('20231017170356'),
('20231115134722'),
('20231205164341'),
('20231211204753'),
('20231215163819'),
('20231216014610'),
('20240202203152'),
('20240202203636'),
('20240206173222'),
('20240208195151'),
('20240221211159'),
('20240229195416'),
('20240229200318'),
('20240229201836'),
('20240305223902'),
('20240312195853'),
('20240318172542'),
('20240318201053'),
('20240321122732'),
('20240321122808'),
('20240321123201'),
('20240326155545'),
('20240415201850'),
('20240417195826'),
('20240418152235'),
('20240424214507'),
('20240425120120'),
('20240502005925'),
('20240502192037'),
('20240503184829'),
('20240506124949'),
('20240507200320'),
('20240507200453'),
('20240507202124'),
('20240507213257'),
('20240507213510'),
('20240507213707'),
('20240508141732'),
('20240508144836'),
('20240508145108'),
('20240508171216'),
('20240509222317'),
('20240509222533'),
('20240509222711'),
('20240513145452'),
('20240513145812'),
('20240513150037'),
('20240513182351'),
('20240513182546'),
('20240513182837'),
('20240527201537'),
('20240528203743'),
('20240528203908'),
('20240528204229'),
('20240529011028'),
('20240605033203'),
('20240614132749'),
('20240620151755'),
('20240625173653'),
('20240702145233'),
('20240708200855'),
('20240709133548'),
('20240712182156'),
('20240719141738'),
('20240722174124'),
('20240723134333'),
('20240723134706'),
('20240806155230'),
('20240806155409'),
('20240819184734'),
('20240819184824'),
('20240819191052'),
('20240822181726'),
('20240827125548'),
('20240829193423'),
('20240830132508'),
('20240911191634'),
('20240912161211'),
('20240924161806'),
('20240926154900'),
('20240930201646'),
('20241029161303'),
('20241118204108'),
('20241122025956'),
('20241202210231'),
('20241204142027'),
('20241211141114'),
('20241211222824'),
('20241211230435');


