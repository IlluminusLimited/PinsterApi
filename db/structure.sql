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
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_with_oids = false;

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
-- Name: assortments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assortments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    images_count integer DEFAULT 0 NOT NULL,
    published boolean DEFAULT false NOT NULL
);


--
-- Name: collectable_collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collectable_collections (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    collectable_type character varying,
    collectable_id uuid,
    collection_id uuid,
    count integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid,
    name character varying NOT NULL,
    description text,
    public boolean DEFAULT true NOT NULL,
    collectable_collections_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    images_count integer DEFAULT 0 NOT NULL
);


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    imageable_type character varying,
    imageable_id uuid,
    name character varying,
    description text,
    storage_location_uri text NOT NULL,
    base_file_name text NOT NULL,
    featured timestamp without time zone,
    thumbnailable boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pin_assortments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pin_assortments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    pin_id uuid,
    assortment_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pins (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    year integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    images_count integer DEFAULT 0 NOT NULL,
    published boolean DEFAULT false NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    display_name character varying,
    bio text,
    verified timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    images_count integer DEFAULT 0 NOT NULL,
    external_user_id text NOT NULL
);


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit uuid,
    object jsonb,
    created_at timestamp without time zone,
    object_changes jsonb
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assortments assortments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assortments
    ADD CONSTRAINT assortments_pkey PRIMARY KEY (id);


--
-- Name: collectable_collections collectable_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collectable_collections
    ADD CONSTRAINT collectable_collections_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: pin_assortments pin_assortments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pin_assortments
    ADD CONSTRAINT pin_assortments_pkey PRIMARY KEY (id);


--
-- Name: pins pins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pins
    ADD CONSTRAINT pins_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_assortments_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assortments_on_created_at ON public.assortments USING btree (created_at DESC);


--
-- Name: index_assortments_on_images_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assortments_on_images_count ON public.assortments USING btree (images_count);


--
-- Name: index_collectable_collections_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collectable_collections_on_collection_id ON public.collectable_collections USING btree (collection_id);


--
-- Name: index_collections_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_created_at ON public.collections USING btree (created_at DESC);


--
-- Name: index_collections_on_images_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_images_count ON public.collections USING btree (images_count);


--
-- Name: index_collections_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_user_id ON public.collections USING btree (user_id);


--
-- Name: index_images_on_featured; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_featured ON public.images USING btree (featured DESC);


--
-- Name: index_images_on_imageable_type_and_imageable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_imageable_type_and_imageable_id ON public.images USING btree (imageable_type, imageable_id);


--
-- Name: index_on_collectable_collection_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_on_collectable_collection_unique ON public.collectable_collections USING btree (collectable_type, collectable_id, collection_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_pin_assortments_on_assortment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pin_assortments_on_assortment_id ON public.pin_assortments USING btree (assortment_id);


--
-- Name: index_pin_assortments_on_pin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pin_assortments_on_pin_id ON public.pin_assortments USING btree (pin_id);


--
-- Name: index_pins_on_images_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pins_on_images_count ON public.pins USING btree (images_count);


--
-- Name: index_pins_on_year_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pins_on_year_and_created_at ON public.pins USING btree (year DESC, created_at DESC);


--
-- Name: index_users_on_external_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_external_user_id ON public.users USING btree (external_user_id);


--
-- Name: index_users_on_images_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_images_count ON public.users USING btree (images_count);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180422194549'),
('20180422195742'),
('20180422200053'),
('20180422200433'),
('20180422201635'),
('20180422225107'),
('20180422230439'),
('20180422231052'),
('20180422231140'),
('20180513050417'),
('20180517015010'),
('20180517015251'),
('20180520205650'),
('20180521145523'),
('20180825192310'),
('20190501020226'),
('20190505170435'),
('20190523015608'),
('20190523015609'),
('20190523022015');


