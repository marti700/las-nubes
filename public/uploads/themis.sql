--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: addnote(text, timestamp with time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addnote(incontenttext text, increationdate timestamp with time zone, inownedby integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Notas(contentText, createdDate, ownedby) values (inContentText, inCreationDate, inOwnedBy);
END
$$;


ALTER FUNCTION public.addnote(incontenttext text, increationdate timestamp with time zone, inownedby integer) OWNER TO postgres;

--
-- Name: editclient(character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION editclient(innames character varying, inlastnames character varying, innationality character varying, inmaritalstatus character varying, injob character varying, inidpassport character varying, inaddress character varying, inid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE clientes
	SET names = inNames, lastnames = inLastNames, nationality = inNationality, maritalstatus = inMaritalStatus, 
			job = inJob, idpassport = inIdPassport,address=inAddress
	WHERE id = inId;
END
$$;


ALTER FUNCTION public.editclient(innames character varying, inlastnames character varying, innationality character varying, inmaritalstatus character varying, injob character varying, inidpassport character varying, inaddress character varying, inid integer) OWNER TO postgres;

--
-- Name: editnote(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION editnote(inid integer, incontenttext text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE Notas
	SET contenttext = inContentText
	WHERE id = inId;
END
$$;


ALTER FUNCTION public.editnote(inid integer, incontenttext text) OWNER TO postgres;

--
-- Name: insertclient(character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertclient(innames character varying, inlastnames character varying, innationality character varying, inmaritalstatus character varying, injob character varying, inidpassport character varying, inaddress character varying, infirstvisit timestamp with time zone, inlastvisit timestamp with time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO clientes(names, lastnames,nationality,maritalstatus,job,idpassport,address,firstvisit,lastvisit)
	VALUES(inNames, inLastNames, inNationality, inMaritalStatus, inJob, inIdPassport, inAddress, inFirstVisit, inLastVisit);
END
$$;


ALTER FUNCTION public.insertclient(innames character varying, inlastnames character varying, innationality character varying, inmaritalstatus character varying, injob character varying, inidpassport character varying, inaddress character varying, infirstvisit timestamp with time zone, inlastvisit timestamp with time zone) OWNER TO postgres;

--
-- Name: insertdocument(character varying, character varying, character varying, timestamp with time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertdocument(inname character varying, intype character varying, inpath character varying, increationdate timestamp with time zone, inowner integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN 
	INSERT INTO documentos(name,type,path,creationdate,ownedby)
	VALUES (inName, inType, inPath, inCreationDate, inOwner); 
END
$$;


ALTER FUNCTION public.insertdocument(inname character varying, intype character varying, inpath character varying, increationdate timestamp with time zone, inowner integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE clientes (
    id integer NOT NULL,
    names character varying(30),
    lastnames character varying(30),
    nationality character varying(30),
    maritalstatus character varying(8),
    job character varying(50),
    idpassport character varying(50),
    address character varying(255),
    firstvisit timestamp with time zone,
    lastvisit timestamp with time zone
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE clientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_id_seq OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE clientes_id_seq OWNED BY clientes.id;


--
-- Name: documentos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE documentos (
    id integer NOT NULL,
    name character varying(200),
    type character varying(150),
    path character varying(300),
    creationdate timestamp with time zone,
    ownedby integer
);


ALTER TABLE public.documentos OWNER TO postgres;

--
-- Name: documentos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE documentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documentos_id_seq OWNER TO postgres;

--
-- Name: documentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE documentos_id_seq OWNED BY documentos.id;


--
-- Name: notas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE notas (
    id integer NOT NULL,
    contenttext text,
    createddate timestamp with time zone,
    ownedby integer
);


ALTER TABLE public.notas OWNER TO postgres;

--
-- Name: notas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE notas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notas_id_seq OWNER TO postgres;

--
-- Name: notas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE notas_id_seq OWNED BY notas.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY clientes ALTER COLUMN id SET DEFAULT nextval('clientes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY documentos ALTER COLUMN id SET DEFAULT nextval('documentos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notas ALTER COLUMN id SET DEFAULT nextval('notas_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY clientes (id, names, lastnames, nationality, maritalstatus, job, idpassport, address, firstvisit, lastvisit) FROM stdin;
1	Ichigo	Kurosaki	Japanese	Single	Shinigami	4687528	Shin No.840	2014-12-06 10:16:07-04	2014-12-06 10:16:07-04
2	Sophia	VanHossen	French	Maried	Warior	7853117	Sop No. 750	2014-12-06 10:26:02-04	2014-12-06 10:26:02-04
4	Kakashi	Hatake	Konohan	Single	Ninja	74DER84W-9	Prip No. 10	2014-12-06 10:33:38-04	2014-12-06 10:33:38-04
3	Byakuya	Kuchiki	Japanese	Single	Shinigami	7823647	Vya No.450	2014-12-06 10:27:39-04	2014-12-06 10:27:39-04
5	Arima	Teppei	Japanese	Maried	Samurai	456EW8-9	Arima Building No.99	2014-12-09 18:19:30-04	2014-12-09 18:19:30-04
6	Genrusai	Shigekuni Yamamoto	Japanese	Single	Captain of Gotei 13	456H87-867	First Division Tower, Gotei 13, Soul Socity	2014-12-26 17:21:57-04	2014-12-26 17:21:57-04
14	Ban	Ki-Moon	Korean	Maried	ONU Secretary	87Z338-WZ14	The ONU Building	2014-12-26 18:53:07-04	2014-12-26 18:53:07-04
\.


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('clientes_id_seq', 24, true);


--
-- Data for Name: documentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY documentos (id, name, type, path, creationdate, ownedby) FROM stdin;
1	Acto.de.Venta.Sophia-16-12-2014.11:35:45	Acto de Venta	../Documents/7853117/Acto.de.Venta.Sophia-16-12-2014.11:35:45	2014-12-16 11:35:45-04	2
2	Acto.de.Venta.Arima-16-12-2014/11:36:36	Acto de Venta	../Documents/456EW8-9/Acto.de.Venta.Arima-16-12-2014/11:36:36	2014-12-16 11:36:36-04	5
3	Acto.de.Venta.Kakashi-16-12-2014/18:26:10	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/18:26:10	2014-12-16 18:26:10-04	4
4	Acto.de.Venta.Kakashi-16-12-2014/18:30:38	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/18:30:38	2014-12-16 18:30:38-04	4
5	Acto.de.Venta.Kakashi-16-12-2014/18:33:18	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/18:33:18	2014-12-16 18:33:18-04	4
6	Acto.de.Venta.Kakashi-16-12-2014/18:37:01	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/18:37:01	2014-12-16 18:37:01-04	4
7	Acto.de.Venta.Kakashi-16-12-2014/18:54:25	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/18:54:25	2014-12-16 18:54:25-04	4
8	Acto.de.Venta.Kakashi-16-12-2014/18:59:24	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/18:59:24	2014-12-16 18:59:24-04	4
9	Acto.de.Venta.Kakashi-16-12-2014/19:00:20	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/19:00:20	2014-12-16 19:00:20-04	4
10	Acto.de.Venta.Kakashi-16-12-2014/19:07:02	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/19:07:02	2014-12-16 19:07:02-04	4
11	Acto.de.Venta.Kakashi-16-12-2014/19:20:30	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014/19:20:30	2014-12-16 19:20:30-04	4
12	Acto.de.Venta.Kakashi-16-12-2014[19:22:14]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014[19:22:14]	2014-12-16 19:22:14-04	4
13	Acto.de.Venta.Kakashi-16-12-2014[19:27:43]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014[19:27:43]	2014-12-16 19:27:43-04	4
14	Acto.de.Venta.Kakashi-16-12-2014[19:28:55]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014[19:28:55]	2014-12-16 19:28:55-04	4
15	Acto.de.Venta.Kakashi-16-12-2014[19:30:25]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-16-12-2014[19:30:25]	2014-12-16 19:30:25-04	4
16	Acto.de.Venta.Kakashi-17-12-2014[20:58:20]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-17-12-2014[20:58:20]	2014-12-17 20:58:20-04	4
17	Acto.de.Venta.Kakashi-17-12-2014[20:58:29]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/74DER84W-9/Acto.de.Venta.Kakashi-17-12-2014[20:58:29]	2014-12-17 20:58:29-04	4
18	Acto.de.Venta.Genrusai-28-12-2014[18:22:06]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[18:22:06]	2014-12-28 18:22:06-04	6
19	Acto.de.Venta.Genrusai-28-12-2014[18:24:12]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[18:24:12]	2014-12-28 18:24:12-04	6
20	Acto.de.Venta.Genrusai-28-12-2014[18:32:28]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[18:32:28]	2014-12-28 18:32:28-04	6
21	Acto.de.Venta.Genrusai-28-12-2014[19:02:58]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[19:02:58]	2014-12-28 19:02:58-04	6
22	Acto.de.Venta.Genrusai-28-12-2014[19:03:46]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[19:03:46]	2014-12-28 19:03:46-04	6
23	Acto.de.Venta.Genrusai-28-12-2014[19:03:58]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[19:03:58]	2014-12-28 19:03:58-04	6
24	Acto.de.Venta.Ban-28-12-2014[19:43:37]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[19:43:37]	2014-12-28 19:43:37-04	14
25	Acto.de.Venta.Ban-28-12-2014[19:45:20]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[19:45:20]	2014-12-28 19:45:20-04	14
26	Acto.de.Venta.Ban-28-12-2014[19:48:48]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[19:48:48]	2014-12-28 19:48:48-04	14
27	Acto.de.Venta.Genrusai-28-12-2014[19:56:02]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[19:56:02]	2014-12-28 19:56:02-04	6
28	Acto.de.Venta.Ban-28-12-2014[20:03:09]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[20:03:09]	2014-12-28 20:03:09-04	14
29	Acto.de.Venta.Ban-28-12-2014[20:04:24]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[20:04:24]	2014-12-28 20:04:24-04	14
30	Acto.de.Venta.Ban-28-12-2014[20:08:06]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[20:08:06]	2014-12-28 20:08:06-04	14
31	Acto.de.Venta.Arima-28-12-2014[20:08:59]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456EW8-9/Acto.de.Venta.Arima-28-12-2014[20:08:59]	2014-12-28 20:08:59-04	5
32	Acto.de.Venta.Ban-28-12-2014[20:09:46]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-28-12-2014[20:09:46]	2014-12-28 20:09:46-04	14
33	Acto.de.Venta.Genrusai-28-12-2014[20:19:11]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-28-12-2014[20:19:11]	2014-12-28 20:19:11-04	6
34	Acto.de.Venta.Genrusai-29-12-2014[20:12:59]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-29-12-2014[20:12:59]	2014-12-29 20:12:59-04	6
35	Acto.de.Venta.Ban-30-12-2014[12:50:24]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/87Z338-WZ14/Acto.de.Venta.Ban-30-12-2014[12:50:24]	2014-12-30 12:50:24-04	14
36	Acto.de.Venta.Genrusai-30-12-2014[12:51:08]	Acto de Venta	/home/teodoro/Documents/Projects/JavaProjects/themis/src/Documents/456H87-867/Acto.de.Venta.Genrusai-30-12-2014[12:51:08]	2014-12-30 12:51:08-04	6
\.


--
-- Name: documentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('documentos_id_seq', 36, true);


--
-- Data for Name: notas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY notas (id, contenttext, createddate, ownedby) FROM stdin;
2	Kakashi's First Note, Yay!!!!	2014-12-24 18:38:40-04	4
5	Sophia's First Note, write notes is so exciting	2014-12-24 19:01:09-04	2
6	My second Note, Yahooooo!!!!	2014-12-24 19:02:12-04	2
3	Kakashi's Second Note, Awsome!!!!	2014-12-24 18:47:00-04	4
4	Ichigo's First Note, Awsome!!!!	2014-12-24 18:52:34-04	1
7	La verdadera Nota	2014-12-28 20:19:36-04	6
9	La verdadera Nota	2014-12-28 20:19:56-04	6
10	La Segunda Verdadera Nota	2014-12-28 20:20:30-04	6
11	,xzmNCZX<>MCNz<XMCNNNNNNNNNNNNNNNNNNNNNNNNNNNnkjhsadkjflk;sadjflsa;kfdjals;kdjfla;skdjflas;kdjfals;kjflsa;kdjfla;sdkjfals;kdjfls;akjdfl;sakjdfl;sakjdfl;sakjdfl;sakjdfl;sakdjflsa;kdfjsal;kdfjsaldkfjasld;kfj	2014-12-29 19:22:57-04	6
12	Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las Palabras Las PalabrasLas Palabras 	2014-12-29 19:51:33-04	6
13	Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos Segundos 	2014-12-29 19:55:06-04	6
14	Nota Nueva	2014-12-29 20:19:24-04	6
15	Mi nota	2014-12-30 14:00:11-04	3
16	La nota	2014-12-30 14:08:50-04	2
17	La verdadera nota	2014-12-30 14:10:06-04	3
18	La verdadera nota	2014-12-30 14:10:09-04	3
19	La otra nota	2014-12-30 14:11:08-04	3
20	grawww	2014-12-30 14:11:52-04	3
21	roarrrr!!!	2014-12-30 14:13:34-04	3
22	El Mayor, Weyyy!!!!!	2014-12-30 17:02:30-04	14
23	Mi nota Nueva, ya es vieja, vieja	2014-12-30 17:04:54-04	6
8	La verdadera segunda Nota	2014-12-28 20:19:54-04	6
\.


--
-- Name: notas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notas_id_seq', 23, true);


--
-- Name: clientes_idpassport_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY clientes
    ADD CONSTRAINT clientes_idpassport_key UNIQUE (idpassport);


--
-- Name: clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: documentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY documentos
    ADD CONSTRAINT documentos_pkey PRIMARY KEY (id);


--
-- Name: notas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY notas
    ADD CONSTRAINT notas_pkey PRIMARY KEY (id);


--
-- Name: find_client_by_name_or_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX find_client_by_name_or_id ON clientes USING btree (names, lastnames, idpassport);


--
-- Name: documentos_ownedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY documentos
    ADD CONSTRAINT documentos_ownedby_fkey FOREIGN KEY (ownedby) REFERENCES clientes(id);


--
-- Name: notas_ownedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notas
    ADD CONSTRAINT notas_ownedby_fkey FOREIGN KEY (ownedby) REFERENCES clientes(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

