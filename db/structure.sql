SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


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


SET default_tablespace = '';

SET default_with_oids = false;

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
    date_of_birth date NOT NULL,
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
    deleted_at timestamp without time zone,
    override_certificate_type integer,
    admin_status integer DEFAULT 0 NOT NULL,
    admin_invitation_token character varying
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admin_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_profiles_id_seq
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
-- Name: background_checks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.background_checks (
    id integer NOT NULL,
    candidate_id character varying NOT NULL,
    report_id character varying NOT NULL,
    account_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: background_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.background_checks_id_seq
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
-- Name: expertises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expertises (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: expertises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expertises_id_seq
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
-- Name: global_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.global_invitations (
    id bigint NOT NULL,
    token character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: global_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.global_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: global_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.global_invitations_id_seq OWNED BY public.global_invitations.id;


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
    requestor_id integer NOT NULL,
    requestor_type character varying NOT NULL,
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
    join_virtual boolean,
    survey_completed boolean,
    onboarded boolean DEFAULT false,
    quarterfinals_scores_count integer DEFAULT 0 NOT NULL,
    semifinals_scores_count integer DEFAULT 0
);


--
-- Name: judge_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_profiles_id_seq
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
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id integer NOT NULL,
    member_id integer NOT NULL,
    member_type character varying NOT NULL,
    team_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
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
    mentor_profile_id integer NOT NULL,
    expertise_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mentor_profile_expertises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_profile_expertises_id_seq
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
    connect_with_mentors boolean DEFAULT true NOT NULL,
    user_invitation_id bigint,
    mentor_type integer
);


--
-- Name: mentor_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_profiles_id_seq
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
    regarding_id integer,
    regarding_type character varying,
    sent_at timestamp without time zone,
    delivered_at timestamp without time zone
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
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
    sender_id integer NOT NULL,
    sender_type character varying NOT NULL,
    regarding_id integer NOT NULL,
    regarding_type character varying NOT NULL,
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
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: parental_consents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parental_consents_id_seq
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
-- Name: regional_ambassador_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_ambassador_profiles (
    id integer NOT NULL,
    organization_company_name character varying NOT NULL,
    ambassador_since_year character varying NOT NULL,
    job_title character varying NOT NULL,
    account_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bio text,
    intro_summary text,
    secondary_regions character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: regional_ambassador_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_ambassador_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regional_ambassador_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regional_ambassador_profiles_id_seq OWNED BY public.regional_ambassador_profiles.id;


--
-- Name: regional_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_links (
    id bigint NOT NULL,
    regional_ambassador_profile_id bigint,
    name integer,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    custom_label character varying
);


--
-- Name: regional_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regional_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regional_links_id_seq OWNED BY public.regional_links.id;


--
-- Name: regional_pitch_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_pitch_events (
    id integer NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    ends_at timestamp without time zone NOT NULL,
    regional_ambassador_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    division_id integer,
    city character varying,
    venue_address character varying,
    eventbrite_link character varying,
    name character varying,
    unofficial boolean DEFAULT false,
    seasons text[] DEFAULT '{}'::text[],
    teams_count integer DEFAULT 0
);


--
-- Name: regional_pitch_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_pitch_events_id_seq
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
-- Name: requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.requests (
    id bigint NOT NULL,
    requestor_id integer NOT NULL,
    requestor_type character varying NOT NULL,
    target_id integer NOT NULL,
    target_type character varying NOT NULL,
    request_type integer NOT NULL,
    request_status integer DEFAULT 0 NOT NULL,
    requestor_meta json,
    requestor_message text,
    status_updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.requests_id_seq OWNED BY public.requests.id;


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
-- Name: signup_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signup_attempts (
    id integer NOT NULL,
    email character varying,
    activation_token character varying NOT NULL,
    account_id integer,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    signup_token character varying,
    pending_token character varying,
    password_digest character varying,
    admin_permission_token character varying,
    wizard_token character varying,
    terms_agreed_at timestamp without time zone
);


--
-- Name: signup_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.signup_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signup_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.signup_attempts_id_seq OWNED BY public.signup_attempts.id;


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
    onboarded boolean DEFAULT false
);


--
-- Name: student_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_profiles_id_seq
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
    evidence_of_problem integer DEFAULT 0,
    problem_addressed integer DEFAULT 0,
    app_functional integer DEFAULT 0,
    demo_video integer DEFAULT 0,
    business_plan_short_term integer DEFAULT 0,
    business_plan_long_term integer DEFAULT 0,
    market_research integer DEFAULT 0,
    viable_business_model integer DEFAULT 0,
    problem_clearly_communicated integer DEFAULT 0,
    compelling_argument integer DEFAULT 0,
    passion_energy integer DEFAULT 0,
    pitch_specific integer DEFAULT 0,
    business_plan_feasible integer DEFAULT 0,
    submission_thought_out integer DEFAULT 0,
    cohesive_story integer DEFAULT 0,
    solution_originality integer DEFAULT 0,
    solution_stands_out integer DEFAULT 0,
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
    sdg_alignment integer DEFAULT 0,
    seasons text[] DEFAULT '{}'::text[],
    ideation_comment_positivity numeric(4,3) DEFAULT 0,
    ideation_comment_negativity numeric(4,3) DEFAULT 0,
    ideation_comment_neutrality numeric(4,3) DEFAULT 0,
    ideation_comment_word_count integer DEFAULT 0,
    ideation_comment_bad_word_count integer DEFAULT 0,
    technical_comment_positivity numeric(4,3) DEFAULT 0,
    technical_comment_negativity numeric(4,3) DEFAULT 0,
    technical_comment_neutrality numeric(4,3) DEFAULT 0,
    technical_comment_word_count integer DEFAULT 0,
    technical_comment_bad_word_count integer DEFAULT 0,
    pitch_comment_positivity numeric(4,3) DEFAULT 0,
    pitch_comment_negativity numeric(4,3) DEFAULT 0,
    pitch_comment_neutrality numeric(4,3) DEFAULT 0,
    pitch_comment_word_count integer DEFAULT 0,
    pitch_comment_bad_word_count integer DEFAULT 0,
    entrepreneurship_comment_positivity numeric(4,3) DEFAULT 0,
    entrepreneurship_comment_negativity numeric(4,3) DEFAULT 0,
    entrepreneurship_comment_neutrality numeric(4,3) DEFAULT 0,
    entrepreneurship_comment_word_count integer DEFAULT 0,
    entrepreneurship_comment_bad_word_count integer DEFAULT 0,
    overall_comment_positivity numeric(4,3) DEFAULT 0,
    overall_comment_negativity numeric(4,3) DEFAULT 0,
    overall_comment_neutrality numeric(4,3) DEFAULT 0,
    overall_comment_word_count integer DEFAULT 0,
    overall_comment_bad_word_count integer DEFAULT 0,
    completed_too_fast boolean DEFAULT false,
    completed_too_fast_repeat_offense boolean DEFAULT false,
    seems_too_low boolean DEFAULT false,
    approved_at timestamp without time zone
);


--
-- Name: submission_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_scores_id_seq
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
    demo_video_link character varying,
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
    seasons text[] DEFAULT '{}'::text[],
    app_inventor_app_name character varying,
    app_inventor_gmail character varying,
    published_at timestamp without time zone,
    business_plan character varying,
    percent_complete integer DEFAULT 0 NOT NULL,
    pitch_presentation character varying,
    lowest_score_dropped_at timestamp without time zone
);


--
-- Name: team_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_submissions_id_seq
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
    city character varying,
    state_province character varying,
    country character varying,
    deleted_at timestamp without time zone,
    seasons text[] DEFAULT '{}'::text[],
    has_students boolean DEFAULT false NOT NULL,
    has_mentor boolean DEFAULT false NOT NULL,
    all_students_onboarded boolean DEFAULT false
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
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
-- Name: technical_checklists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.technical_checklists (
    id integer NOT NULL,
    used_strings boolean,
    used_strings_explanation character varying,
    used_numbers boolean,
    used_numbers_explanation character varying,
    used_variables boolean,
    used_variables_explanation character varying,
    used_lists boolean,
    used_lists_explanation character varying,
    used_booleans boolean,
    used_booleans_explanation character varying,
    used_loops boolean,
    used_loops_explanation character varying,
    used_conditionals boolean,
    used_conditionals_explanation character varying,
    used_local_db boolean,
    used_local_db_explanation character varying,
    used_external_db boolean,
    used_external_db_explanation character varying,
    used_location_sensor boolean,
    used_location_sensor_explanation character varying,
    used_camera boolean,
    used_camera_explanation character varying,
    used_accelerometer boolean,
    used_accelerometer_explanation character varying,
    used_sms_phone boolean,
    used_sms_phone_explanation character varying,
    used_sound boolean,
    used_sound_explanation character varying,
    used_sharing boolean,
    used_sharing_explanation character varying,
    paper_prototype character varying,
    team_submission_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_flow_chart character varying,
    used_clock boolean,
    used_clock_explanation character varying,
    used_canvas boolean,
    used_canvas_explanation character varying
);


--
-- Name: technical_checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.technical_checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: technical_checklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.technical_checklists_id_seq OWNED BY public.technical_checklists.id;


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
    name character varying
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
-- Name: consent_waivers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consent_waivers ALTER COLUMN id SET DEFAULT nextval('public.consent_waivers_id_seq'::regclass);


--
-- Name: divisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions ALTER COLUMN id SET DEFAULT nextval('public.divisions_id_seq'::regclass);


--
-- Name: expertises id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expertises ALTER COLUMN id SET DEFAULT nextval('public.expertises_id_seq'::regclass);


--
-- Name: exports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports ALTER COLUMN id SET DEFAULT nextval('public.exports_id_seq'::regclass);


--
-- Name: global_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_invitations ALTER COLUMN id SET DEFAULT nextval('public.global_invitations_id_seq'::regclass);


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
-- Name: judge_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profiles ALTER COLUMN id SET DEFAULT nextval('public.judge_profiles_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: mentor_profile_expertises id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profile_expertises ALTER COLUMN id SET DEFAULT nextval('public.mentor_profile_expertises_id_seq'::regclass);


--
-- Name: mentor_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles ALTER COLUMN id SET DEFAULT nextval('public.mentor_profiles_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: multi_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_messages ALTER COLUMN id SET DEFAULT nextval('public.multi_messages_id_seq'::regclass);


--
-- Name: parental_consents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parental_consents ALTER COLUMN id SET DEFAULT nextval('public.parental_consents_id_seq'::regclass);


--
-- Name: pitch_presentations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_presentations ALTER COLUMN id SET DEFAULT nextval('public.pitch_presentations_id_seq'::regclass);


--
-- Name: regional_ambassador_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_ambassador_profiles ALTER COLUMN id SET DEFAULT nextval('public.regional_ambassador_profiles_id_seq'::regclass);


--
-- Name: regional_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_links ALTER COLUMN id SET DEFAULT nextval('public.regional_links_id_seq'::regclass);


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
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requests ALTER COLUMN id SET DEFAULT nextval('public.requests_id_seq'::regclass);


--
-- Name: saved_searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_searches ALTER COLUMN id SET DEFAULT nextval('public.saved_searches_id_seq'::regclass);


--
-- Name: screenshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.screenshots ALTER COLUMN id SET DEFAULT nextval('public.screenshots_id_seq'::regclass);


--
-- Name: signup_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signup_attempts ALTER COLUMN id SET DEFAULT nextval('public.signup_attempts_id_seq'::regclass);


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
-- Name: team_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submissions ALTER COLUMN id SET DEFAULT nextval('public.team_submissions_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: technical_checklists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technical_checklists ALTER COLUMN id SET DEFAULT nextval('public.technical_checklists_id_seq'::regclass);


--
-- Name: unconfirmed_email_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unconfirmed_email_addresses ALTER COLUMN id SET DEFAULT nextval('public.unconfirmed_email_addresses_id_seq'::regclass);


--
-- Name: user_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations ALTER COLUMN id SET DEFAULT nextval('public.user_invitations_id_seq'::regclass);


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
-- Name: global_invitations global_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_invitations
    ADD CONSTRAINT global_invitations_pkey PRIMARY KEY (id);


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
-- Name: judge_profiles judge_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_profiles
    ADD CONSTRAINT judge_profiles_pkey PRIMARY KEY (id);


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
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


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
-- Name: parental_consents parental_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parental_consents
    ADD CONSTRAINT parental_consents_pkey PRIMARY KEY (id);


--
-- Name: pitch_presentations pitch_presentations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_presentations
    ADD CONSTRAINT pitch_presentations_pkey PRIMARY KEY (id);


--
-- Name: regional_ambassador_profiles regional_ambassador_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_ambassador_profiles
    ADD CONSTRAINT regional_ambassador_profiles_pkey PRIMARY KEY (id);


--
-- Name: regional_links regional_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_links
    ADD CONSTRAINT regional_links_pkey PRIMARY KEY (id);


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
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: saved_searches saved_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_searches
    ADD CONSTRAINT saved_searches_pkey PRIMARY KEY (id);


--
-- Name: screenshots screenshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT screenshots_pkey PRIMARY KEY (id);


--
-- Name: signup_attempts signup_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signup_attempts
    ADD CONSTRAINT signup_attempts_pkey PRIMARY KEY (id);


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
-- Name: technical_checklists technical_checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technical_checklists
    ADD CONSTRAINT technical_checklists_pkey PRIMARY KEY (id);


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

CREATE UNIQUE INDEX index_accounts_on_email ON public.accounts USING btree (email) WHERE (deleted_at IS NOT NULL);


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
-- Name: index_background_checks_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_background_checks_on_account_id ON public.background_checks USING btree (account_id);


--
-- Name: index_business_plans_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_plans_on_team_submission_id ON public.business_plans USING btree (team_submission_id);


--
-- Name: index_certificates_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_account_id ON public.certificates USING btree (account_id);


--
-- Name: index_certificates_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_team_id ON public.certificates USING btree (team_id);


--
-- Name: index_consent_waivers_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consent_waivers_on_account_id ON public.consent_waivers USING btree (account_id);


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
-- Name: index_judge_profiles_on_user_invitation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_profiles_on_user_invitation_id ON public.judge_profiles USING btree (user_invitation_id);


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
-- Name: index_mentor_profiles_on_user_invitation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_profiles_on_user_invitation_id ON public.mentor_profiles USING btree (user_invitation_id);


--
-- Name: index_parental_consents_on_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parental_consents_on_student_profile_id ON public.parental_consents USING btree (student_profile_id);


--
-- Name: index_regional_ambassador_profiles_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regional_ambassador_profiles_on_status ON public.regional_ambassador_profiles USING btree (status);


--
-- Name: index_regional_links_on_regional_ambassador_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regional_links_on_regional_ambassador_profile_id ON public.regional_links USING btree (regional_ambassador_profile_id);


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
-- Name: index_signup_attempts_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_signup_attempts_on_status ON public.signup_attempts USING btree (status);


--
-- Name: index_submission_scores_on_completed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_completed_at ON public.submission_scores USING btree (completed_at);


--
-- Name: index_submission_scores_on_judge_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_judge_profile_id ON public.submission_scores USING btree (judge_profile_id);


--
-- Name: index_submission_scores_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submission_scores_on_team_submission_id ON public.submission_scores USING btree (team_submission_id);


--
-- Name: index_team_member_invites_on_invite_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_team_member_invites_on_invite_token ON public.team_member_invites USING btree (invite_token);


--
-- Name: index_team_member_invites_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_member_invites_on_status ON public.team_member_invites USING btree (status);


--
-- Name: index_teams_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_teams_on_legacy_id ON public.teams USING btree (legacy_id);


--
-- Name: index_technical_checklists_on_team_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_technical_checklists_on_team_submission_id ON public.technical_checklists USING btree (team_submission_id);


--
-- Name: index_unconfirmed_email_addresses_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_unconfirmed_email_addresses_on_account_id ON public.unconfirmed_email_addresses USING btree (account_id);


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

CREATE UNIQUE INDEX uniq_ambassadors_accounts ON public.regional_ambassador_profiles USING btree (account_id);


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
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


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
-- Name: technical_checklists fk_rails_306da78d6d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technical_checklists
    ADD CONSTRAINT fk_rails_306da78d6d FOREIGN KEY (team_submission_id) REFERENCES public.team_submissions(id);


--
-- Name: team_submissions fk_rails_34e7653c32; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_submissions
    ADD CONSTRAINT fk_rails_34e7653c32 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: regional_pitch_events_user_invitations fk_rails_3bbe8623e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_pitch_events_user_invitations
    ADD CONSTRAINT fk_rails_3bbe8623e3 FOREIGN KEY (user_invitation_id) REFERENCES public.user_invitations(id);


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
-- Name: consent_waivers fk_rails_6dd1d3738c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consent_waivers
    ADD CONSTRAINT fk_rails_6dd1d3738c FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: certificates fk_rails_75edbeede4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_75edbeede4 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


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
-- Name: signup_attempts fk_rails_86a8845c55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signup_attempts
    ADD CONSTRAINT fk_rails_86a8845c55 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


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
-- Name: regional_links fk_rails_b88e121da0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_links
    ADD CONSTRAINT fk_rails_b88e121da0 FOREIGN KEY (regional_ambassador_profile_id) REFERENCES public.regional_ambassador_profiles(id);


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
-- Name: certificates fk_rails_ddedb55856; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_ddedb55856 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: business_plans fk_rails_de87026bfd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_plans
    ADD CONSTRAINT fk_rails_de87026bfd FOREIGN KEY (team_submission_id) REFERENCES public.team_submissions(id);


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
('20171019230759'),
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
('20171110224550'),
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
('20180202145104'),
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
('20180316182251'),
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
('20180725175328');


