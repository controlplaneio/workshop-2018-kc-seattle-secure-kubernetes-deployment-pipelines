--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 9.6.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vulnerability_notification DROP CONSTRAINT vulnerability_notification_old_vulnerability_id_fkey;
ALTER TABLE ONLY public.vulnerability_notification DROP CONSTRAINT vulnerability_notification_new_vulnerability_id_fkey;
ALTER TABLE ONLY public.vulnerability DROP CONSTRAINT vulnerability_namespace_id_fkey;
ALTER TABLE ONLY public.vulnerability_fixedin_feature DROP CONSTRAINT vulnerability_fixedin_feature_vulnerability_id_fkey;
ALTER TABLE ONLY public.vulnerability_fixedin_feature DROP CONSTRAINT vulnerability_fixedin_feature_feature_id_fkey;
ALTER TABLE ONLY public.vulnerability_affects_featureversion DROP CONSTRAINT vulnerability_affects_featureversion_vulnerability_id_fkey;
ALTER TABLE ONLY public.vulnerability_affects_featureversion DROP CONSTRAINT vulnerability_affects_featureversion_fixedin_id_fkey;
ALTER TABLE ONLY public.vulnerability_affects_featureversion DROP CONSTRAINT vulnerability_affects_featureversion_featureversion_id_fkey;
ALTER TABLE ONLY public.layer DROP CONSTRAINT layer_parent_id_fkey;
ALTER TABLE ONLY public.layer DROP CONSTRAINT layer_namespace_id_fkey;
ALTER TABLE ONLY public.layer_diff_featureversion DROP CONSTRAINT layer_diff_featureversion_layer_id_fkey;
ALTER TABLE ONLY public.layer_diff_featureversion DROP CONSTRAINT layer_diff_featureversion_featureversion_id_fkey;
ALTER TABLE ONLY public.featureversion DROP CONSTRAINT featureversion_feature_id_fkey;
ALTER TABLE ONLY public.feature DROP CONSTRAINT feature_namespace_id_fkey;
DROP INDEX public.vulnerability_notification_notified_at_idx;
DROP INDEX public.vulnerability_notification_deleted_at_idx;
DROP INDEX public.vulnerability_namespace_id_name_idx;
DROP INDEX public.vulnerability_name_idx;
DROP INDEX public.vulnerability_fixedin_feature_feature_id_vulnerability_id_idx;
DROP INDEX public.vulnerability_affects_featureversion_fixedin_id_idx;
DROP INDEX public.vulnerability_affects_feature_featureversion_id_vulnerabili_idx;
DROP INDEX public.namespace_name_key;
DROP INDEX public.lock_owner_idx;
DROP INDEX public.layer_parent_id_idx;
DROP INDEX public.layer_namespace_id_idx;
DROP INDEX public.layer_diff_featureversion_layer_id_modification_idx;
DROP INDEX public.layer_diff_featureversion_layer_id_idx;
DROP INDEX public.layer_diff_featureversion_featureversion_id_layer_id_idx;
DROP INDEX public.layer_diff_featureversion_featureversion_id_idx;
DROP INDEX public.featureversion_feature_id_version_key;
DROP INDEX public.featureversion_feature_id_idx;
ALTER TABLE ONLY public.vulnerability DROP CONSTRAINT vulnerability_pkey;
ALTER TABLE ONLY public.vulnerability_notification DROP CONSTRAINT vulnerability_notification_pkey;
ALTER TABLE ONLY public.vulnerability_notification DROP CONSTRAINT vulnerability_notification_name_key;
ALTER TABLE ONLY public.vulnerability_fixedin_feature DROP CONSTRAINT vulnerability_fixedin_feature_vulnerability_id_feature_id_key;
ALTER TABLE ONLY public.vulnerability_fixedin_feature DROP CONSTRAINT vulnerability_fixedin_feature_pkey;
ALTER TABLE ONLY public.vulnerability_affects_featureversion DROP CONSTRAINT vulnerability_affects_featureversion_pkey;
ALTER TABLE ONLY public.vulnerability_affects_featureversion DROP CONSTRAINT vulnerability_affects_feature_vulnerability_id_featureversi_key;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.namespace DROP CONSTRAINT namespace_pkey;
ALTER TABLE ONLY public.lock DROP CONSTRAINT lock_pkey;
ALTER TABLE ONLY public.lock DROP CONSTRAINT lock_name_key;
ALTER TABLE ONLY public.layer DROP CONSTRAINT layer_pkey;
ALTER TABLE ONLY public.layer DROP CONSTRAINT layer_name_key;
ALTER TABLE ONLY public.layer_diff_featureversion DROP CONSTRAINT layer_diff_featureversion_pkey;
ALTER TABLE ONLY public.layer_diff_featureversion DROP CONSTRAINT layer_diff_featureversion_layer_id_featureversion_id_key;
ALTER TABLE ONLY public.keyvalue DROP CONSTRAINT keyvalue_pkey;
ALTER TABLE ONLY public.keyvalue DROP CONSTRAINT keyvalue_key_key;
ALTER TABLE ONLY public.featureversion DROP CONSTRAINT featureversion_pkey;
ALTER TABLE ONLY public.feature DROP CONSTRAINT feature_pkey;
ALTER TABLE ONLY public.feature DROP CONSTRAINT feature_namespace_id_name_key;
ALTER TABLE public.vulnerability_notification ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.vulnerability_fixedin_feature ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.vulnerability_affects_featureversion ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.vulnerability ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.namespace ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.lock ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.layer_diff_featureversion ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.layer ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.keyvalue ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.featureversion ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.feature ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.vulnerability_notification_id_seq;
DROP TABLE public.vulnerability_notification;
DROP SEQUENCE public.vulnerability_id_seq;
DROP SEQUENCE public.vulnerability_fixedin_feature_id_seq;
DROP TABLE public.vulnerability_fixedin_feature;
DROP SEQUENCE public.vulnerability_affects_featureversion_id_seq;
DROP TABLE public.vulnerability_affects_featureversion;
DROP TABLE public.vulnerability;
DROP TABLE public.schema_migrations;
DROP SEQUENCE public.namespace_id_seq;
DROP TABLE public.namespace;
DROP SEQUENCE public.lock_id_seq;
DROP TABLE public.lock;
DROP SEQUENCE public.layer_id_seq;
DROP SEQUENCE public.layer_diff_featureversion_id_seq;
DROP TABLE public.layer_diff_featureversion;
DROP TABLE public.layer;
DROP SEQUENCE public.keyvalue_id_seq;
DROP TABLE public.keyvalue;
DROP SEQUENCE public.featureversion_id_seq;
DROP TABLE public.featureversion;
DROP SEQUENCE public.feature_id_seq;
DROP TABLE public.feature;
DROP TYPE public.severity;
DROP TYPE public.modification;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: modification; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.modification AS ENUM (
    'add',
    'del'
);


ALTER TYPE public.modification OWNER TO postgres;

--
-- Name: severity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.severity AS ENUM (
    'Unknown',
    'Negligible',
    'Low',
    'Medium',
    'High',
    'Critical',
    'Defcon1'
);


ALTER TYPE public.severity OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature (
    id integer NOT NULL,
    namespace_id integer NOT NULL,
    name character varying(128) NOT NULL
);


ALTER TABLE public.feature OWNER TO postgres;

--
-- Name: feature_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feature_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feature_id_seq OWNER TO postgres;

--
-- Name: feature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feature_id_seq OWNED BY public.feature.id;


--
-- Name: featureversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.featureversion (
    id integer NOT NULL,
    feature_id integer NOT NULL,
    version character varying(128) NOT NULL
);


ALTER TABLE public.featureversion OWNER TO postgres;

--
-- Name: featureversion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.featureversion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.featureversion_id_seq OWNER TO postgres;

--
-- Name: featureversion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.featureversion_id_seq OWNED BY public.featureversion.id;


--
-- Name: keyvalue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keyvalue (
    id integer NOT NULL,
    key character varying(128) NOT NULL,
    value text
);


ALTER TABLE public.keyvalue OWNER TO postgres;

--
-- Name: keyvalue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.keyvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.keyvalue_id_seq OWNER TO postgres;

--
-- Name: keyvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keyvalue_id_seq OWNED BY public.keyvalue.id;


--
-- Name: layer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.layer (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    engineversion smallint NOT NULL,
    parent_id integer,
    namespace_id integer,
    created_at timestamp with time zone
);


ALTER TABLE public.layer OWNER TO postgres;

--
-- Name: layer_diff_featureversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.layer_diff_featureversion (
    id integer NOT NULL,
    layer_id integer NOT NULL,
    featureversion_id integer NOT NULL,
    modification public.modification NOT NULL
);


ALTER TABLE public.layer_diff_featureversion OWNER TO postgres;

--
-- Name: layer_diff_featureversion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.layer_diff_featureversion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layer_diff_featureversion_id_seq OWNER TO postgres;

--
-- Name: layer_diff_featureversion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.layer_diff_featureversion_id_seq OWNED BY public.layer_diff_featureversion.id;


--
-- Name: layer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.layer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layer_id_seq OWNER TO postgres;

--
-- Name: layer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.layer_id_seq OWNED BY public.layer.id;


--
-- Name: lock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lock (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    owner character varying(64) NOT NULL,
    until timestamp with time zone
);


ALTER TABLE public.lock OWNER TO postgres;

--
-- Name: lock_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lock_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lock_id_seq OWNER TO postgres;

--
-- Name: lock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lock_id_seq OWNED BY public.lock.id;


--
-- Name: namespace; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.namespace (
    id integer NOT NULL,
    name character varying(128),
    version_format character varying(128)
);


ALTER TABLE public.namespace OWNER TO postgres;

--
-- Name: namespace_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.namespace_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.namespace_id_seq OWNER TO postgres;

--
-- Name: namespace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.namespace_id_seq OWNED BY public.namespace.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version integer NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: vulnerability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vulnerability (
    id integer NOT NULL,
    namespace_id integer NOT NULL,
    name character varying(128) NOT NULL,
    description text,
    link character varying(128),
    severity public.severity NOT NULL,
    metadata text,
    created_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.vulnerability OWNER TO postgres;

--
-- Name: vulnerability_affects_featureversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vulnerability_affects_featureversion (
    id integer NOT NULL,
    vulnerability_id integer NOT NULL,
    featureversion_id integer NOT NULL,
    fixedin_id integer NOT NULL
);


ALTER TABLE public.vulnerability_affects_featureversion OWNER TO postgres;

--
-- Name: vulnerability_affects_featureversion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vulnerability_affects_featureversion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vulnerability_affects_featureversion_id_seq OWNER TO postgres;

--
-- Name: vulnerability_affects_featureversion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vulnerability_affects_featureversion_id_seq OWNED BY public.vulnerability_affects_featureversion.id;


--
-- Name: vulnerability_fixedin_feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vulnerability_fixedin_feature (
    id integer NOT NULL,
    vulnerability_id integer NOT NULL,
    feature_id integer NOT NULL,
    version character varying(128) NOT NULL
);


ALTER TABLE public.vulnerability_fixedin_feature OWNER TO postgres;

--
-- Name: vulnerability_fixedin_feature_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vulnerability_fixedin_feature_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vulnerability_fixedin_feature_id_seq OWNER TO postgres;

--
-- Name: vulnerability_fixedin_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vulnerability_fixedin_feature_id_seq OWNED BY public.vulnerability_fixedin_feature.id;


--
-- Name: vulnerability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vulnerability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vulnerability_id_seq OWNER TO postgres;

--
-- Name: vulnerability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vulnerability_id_seq OWNED BY public.vulnerability.id;


--
-- Name: vulnerability_notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vulnerability_notification (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    created_at timestamp with time zone,
    notified_at timestamp with time zone,
    deleted_at timestamp with time zone,
    old_vulnerability_id integer,
    new_vulnerability_id integer
);


ALTER TABLE public.vulnerability_notification OWNER TO postgres;

--
-- Name: vulnerability_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vulnerability_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vulnerability_notification_id_seq OWNER TO postgres;

--
-- Name: vulnerability_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vulnerability_notification_id_seq OWNED BY public.vulnerability_notification.id;


--
-- Name: feature id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature ALTER COLUMN id SET DEFAULT nextval('public.feature_id_seq'::regclass);


--
-- Name: featureversion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.featureversion ALTER COLUMN id SET DEFAULT nextval('public.featureversion_id_seq'::regclass);


--
-- Name: keyvalue id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyvalue ALTER COLUMN id SET DEFAULT nextval('public.keyvalue_id_seq'::regclass);


--
-- Name: layer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer ALTER COLUMN id SET DEFAULT nextval('public.layer_id_seq'::regclass);


--
-- Name: layer_diff_featureversion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer_diff_featureversion ALTER COLUMN id SET DEFAULT nextval('public.layer_diff_featureversion_id_seq'::regclass);


--
-- Name: lock id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lock ALTER COLUMN id SET DEFAULT nextval('public.lock_id_seq'::regclass);


--
-- Name: namespace id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.namespace ALTER COLUMN id SET DEFAULT nextval('public.namespace_id_seq'::regclass);


--
-- Name: vulnerability id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_id_seq'::regclass);


--
-- Name: vulnerability_affects_featureversion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_affects_featureversion ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_affects_featureversion_id_seq'::regclass);


--
-- Name: vulnerability_fixedin_feature id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_fixedin_feature ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_fixedin_feature_id_seq'::regclass);


--
-- Name: vulnerability_notification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_notification ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_notification_id_seq'::regclass);


--
-- Name: feature feature_namespace_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT feature_namespace_id_name_key UNIQUE (namespace_id, name);


--
-- Name: feature feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT feature_pkey PRIMARY KEY (id);


--
-- Name: featureversion featureversion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.featureversion
    ADD CONSTRAINT featureversion_pkey PRIMARY KEY (id);


--
-- Name: keyvalue keyvalue_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyvalue
    ADD CONSTRAINT keyvalue_key_key UNIQUE (key);


--
-- Name: keyvalue keyvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyvalue
    ADD CONSTRAINT keyvalue_pkey PRIMARY KEY (id);


--
-- Name: layer_diff_featureversion layer_diff_featureversion_layer_id_featureversion_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer_diff_featureversion
    ADD CONSTRAINT layer_diff_featureversion_layer_id_featureversion_id_key UNIQUE (layer_id, featureversion_id);


--
-- Name: layer_diff_featureversion layer_diff_featureversion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer_diff_featureversion
    ADD CONSTRAINT layer_diff_featureversion_pkey PRIMARY KEY (id);


--
-- Name: layer layer_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer
    ADD CONSTRAINT layer_name_key UNIQUE (name);


--
-- Name: layer layer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer
    ADD CONSTRAINT layer_pkey PRIMARY KEY (id);


--
-- Name: lock lock_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lock
    ADD CONSTRAINT lock_name_key UNIQUE (name);


--
-- Name: lock lock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lock
    ADD CONSTRAINT lock_pkey PRIMARY KEY (id);


--
-- Name: namespace namespace_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.namespace
    ADD CONSTRAINT namespace_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: vulnerability_affects_featureversion vulnerability_affects_feature_vulnerability_id_featureversi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_affects_featureversion
    ADD CONSTRAINT vulnerability_affects_feature_vulnerability_id_featureversi_key UNIQUE (vulnerability_id, featureversion_id);


--
-- Name: vulnerability_affects_featureversion vulnerability_affects_featureversion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_affects_featureversion
    ADD CONSTRAINT vulnerability_affects_featureversion_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_fixedin_feature vulnerability_fixedin_feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_fixedin_feature
    ADD CONSTRAINT vulnerability_fixedin_feature_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_fixedin_feature vulnerability_fixedin_feature_vulnerability_id_feature_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_fixedin_feature
    ADD CONSTRAINT vulnerability_fixedin_feature_vulnerability_id_feature_id_key UNIQUE (vulnerability_id, feature_id);


--
-- Name: vulnerability_notification vulnerability_notification_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_notification
    ADD CONSTRAINT vulnerability_notification_name_key UNIQUE (name);


--
-- Name: vulnerability_notification vulnerability_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_notification
    ADD CONSTRAINT vulnerability_notification_pkey PRIMARY KEY (id);


--
-- Name: vulnerability vulnerability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability
    ADD CONSTRAINT vulnerability_pkey PRIMARY KEY (id);


--
-- Name: featureversion_feature_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX featureversion_feature_id_idx ON public.featureversion USING btree (feature_id);


--
-- Name: featureversion_feature_id_version_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX featureversion_feature_id_version_key ON public.featureversion USING btree (feature_id, version);


--
-- Name: layer_diff_featureversion_featureversion_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX layer_diff_featureversion_featureversion_id_idx ON public.layer_diff_featureversion USING btree (featureversion_id);


--
-- Name: layer_diff_featureversion_featureversion_id_layer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX layer_diff_featureversion_featureversion_id_layer_id_idx ON public.layer_diff_featureversion USING btree (featureversion_id, layer_id);


--
-- Name: layer_diff_featureversion_layer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX layer_diff_featureversion_layer_id_idx ON public.layer_diff_featureversion USING btree (layer_id);


--
-- Name: layer_diff_featureversion_layer_id_modification_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX layer_diff_featureversion_layer_id_modification_idx ON public.layer_diff_featureversion USING btree (layer_id, modification);


--
-- Name: layer_namespace_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX layer_namespace_id_idx ON public.layer USING btree (namespace_id);


--
-- Name: layer_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX layer_parent_id_idx ON public.layer USING btree (parent_id);


--
-- Name: lock_owner_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lock_owner_idx ON public.lock USING btree (owner);


--
-- Name: namespace_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX namespace_name_key ON public.namespace USING btree (name);


--
-- Name: vulnerability_affects_feature_featureversion_id_vulnerabili_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_affects_feature_featureversion_id_vulnerabili_idx ON public.vulnerability_affects_featureversion USING btree (featureversion_id, vulnerability_id);


--
-- Name: vulnerability_affects_featureversion_fixedin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_affects_featureversion_fixedin_id_idx ON public.vulnerability_affects_featureversion USING btree (fixedin_id);


--
-- Name: vulnerability_fixedin_feature_feature_id_vulnerability_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_fixedin_feature_feature_id_vulnerability_id_idx ON public.vulnerability_fixedin_feature USING btree (feature_id, vulnerability_id);


--
-- Name: vulnerability_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_name_idx ON public.vulnerability USING btree (name);


--
-- Name: vulnerability_namespace_id_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_namespace_id_name_idx ON public.vulnerability USING btree (namespace_id, name);


--
-- Name: vulnerability_notification_deleted_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_notification_deleted_at_idx ON public.vulnerability_notification USING btree (deleted_at);


--
-- Name: vulnerability_notification_notified_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vulnerability_notification_notified_at_idx ON public.vulnerability_notification USING btree (notified_at);


--
-- Name: feature feature_namespace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT feature_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES public.namespace(id);


--
-- Name: featureversion featureversion_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.featureversion
    ADD CONSTRAINT featureversion_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES public.feature(id);


--
-- Name: layer_diff_featureversion layer_diff_featureversion_featureversion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer_diff_featureversion
    ADD CONSTRAINT layer_diff_featureversion_featureversion_id_fkey FOREIGN KEY (featureversion_id) REFERENCES public.featureversion(id);


--
-- Name: layer_diff_featureversion layer_diff_featureversion_layer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer_diff_featureversion
    ADD CONSTRAINT layer_diff_featureversion_layer_id_fkey FOREIGN KEY (layer_id) REFERENCES public.layer(id) ON DELETE CASCADE;


--
-- Name: layer layer_namespace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer
    ADD CONSTRAINT layer_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES public.namespace(id);


--
-- Name: layer layer_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.layer
    ADD CONSTRAINT layer_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.layer(id) ON DELETE CASCADE;


--
-- Name: vulnerability_affects_featureversion vulnerability_affects_featureversion_featureversion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_affects_featureversion
    ADD CONSTRAINT vulnerability_affects_featureversion_featureversion_id_fkey FOREIGN KEY (featureversion_id) REFERENCES public.featureversion(id);


--
-- Name: vulnerability_affects_featureversion vulnerability_affects_featureversion_fixedin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_affects_featureversion
    ADD CONSTRAINT vulnerability_affects_featureversion_fixedin_id_fkey FOREIGN KEY (fixedin_id) REFERENCES public.vulnerability_fixedin_feature(id) ON DELETE CASCADE;


--
-- Name: vulnerability_affects_featureversion vulnerability_affects_featureversion_vulnerability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_affects_featureversion
    ADD CONSTRAINT vulnerability_affects_featureversion_vulnerability_id_fkey FOREIGN KEY (vulnerability_id) REFERENCES public.vulnerability(id) ON DELETE CASCADE;


--
-- Name: vulnerability_fixedin_feature vulnerability_fixedin_feature_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_fixedin_feature
    ADD CONSTRAINT vulnerability_fixedin_feature_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES public.feature(id);


--
-- Name: vulnerability_fixedin_feature vulnerability_fixedin_feature_vulnerability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_fixedin_feature
    ADD CONSTRAINT vulnerability_fixedin_feature_vulnerability_id_fkey FOREIGN KEY (vulnerability_id) REFERENCES public.vulnerability(id) ON DELETE CASCADE;


--
-- Name: vulnerability vulnerability_namespace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability
    ADD CONSTRAINT vulnerability_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES public.namespace(id);


--
-- Name: vulnerability_notification vulnerability_notification_new_vulnerability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_notification
    ADD CONSTRAINT vulnerability_notification_new_vulnerability_id_fkey FOREIGN KEY (new_vulnerability_id) REFERENCES public.vulnerability(id) ON DELETE CASCADE;


--
-- Name: vulnerability_notification vulnerability_notification_old_vulnerability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vulnerability_notification
    ADD CONSTRAINT vulnerability_notification_old_vulnerability_id_fkey FOREIGN KEY (old_vulnerability_id) REFERENCES public.vulnerability(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

