--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.9
-- Dumped by pg_dump version 9.5.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Administrator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Administrator" (
    adm_id character varying(32) NOT NULL,
    type_admin_id character varying(32) NOT NULL,
    adm_date timestamp(6) without time zone NOT NULL,
    user_id character varying(32) NOT NULL
);


ALTER TABLE "Administrator" OWNER TO postgres;

--
-- Name: Community; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Community" (
    com_id character varying(32) NOT NULL,
    type_com_id character varying(32) NOT NULL,
    com_date timestamp(6) without time zone NOT NULL,
    user_id character varying(32) NOT NULL
);


ALTER TABLE "Community" OWNER TO postgres;

--
-- Name: Institution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Institution" (
    ins_id character varying(32) NOT NULL,
    ins_name text NOT NULL,
    ins_img text NOT NULL,
    ins_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Institution" OWNER TO postgres;

--
-- Name: Option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Option" (
    opt_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    opt_name text NOT NULL,
    opt_date timestamp(6) without time zone NOT NULL,
    opt_state boolean NOT NULL
);


ALTER TABLE "Option" OWNER TO postgres;

--
-- Name: Request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Request" (
    req_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    user_id character varying(32) NOT NULL,
    req_date timestamp(6) without time zone NOT NULL,
    time_id character varying(32) NOT NULL,
    req_description text NOT NULL,
    type_req_id character varying(32) NOT NULL,
    req_dependent boolean NOT NULL,
    req_state boolean NOT NULL
);


ALTER TABLE "Request" OWNER TO postgres;

--
-- Name: Request_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Request_option" (
    req_opt_id character varying(32) NOT NULL,
    req_id character varying(32) NOT NULL,
    opt_id character varying(32) NOT NULL,
    req_opt_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Request_option" OWNER TO postgres;

--
-- Name: Schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Schedule" (
    sch_id character varying(32) NOT NULL,
    adm_id character varying(32) NOT NULL,
    com_id character varying(32) NOT NULL,
    sch_date timestamp(6) without time zone NOT NULL,
    time_id character varying(32) NOT NULL,
    spa_id character varying(32) NOT NULL,
    sch_description text NOT NULL,
    type_sch_id character varying(32) NOT NULL,
    sch_capacity integer NOT NULL,
    ins_id character varying(32) NOT NULL,
    sch_state boolean NOT NULL
);


ALTER TABLE "Schedule" OWNER TO postgres;

--
-- Name: Schedule_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Schedule_option" (
    sch_opt_id character varying(32) NOT NULL,
    sch_id character varying(32) NOT NULL,
    opt_id character varying(32) NOT NULL,
    sch_opt_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Schedule_option" OWNER TO postgres;

--
-- Name: Space; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Space" (
    spa_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    spa_name text NOT NULL,
    spa_date timestamp(6) without time zone NOT NULL,
    spa_reference text,
    spa_description text,
    type_spa_id character varying(32) NOT NULL,
    spa_capacity integer NOT NULL,
    spa_state boolean NOT NULL
);


ALTER TABLE "Space" OWNER TO postgres;

--
-- Name: Space_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Space_option" (
    spa_opt_id character varying(32) NOT NULL,
    spa_id character varying(32) NOT NULL,
    opt_id character varying(32) NOT NULL,
    spa_opt_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Space_option" OWNER TO postgres;

--
-- Name: Space_time; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Space_time" (
    spa_time_id character varying(32) NOT NULL,
    spa_id character varying(32) NOT NULL,
    time_id character varying(32) NOT NULL,
    spa_time_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Space_time" OWNER TO postgres;

--
-- Name: Time_interval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Time_interval" (
    time_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    time_name text NOT NULL,
    time_begin timestamp(6) without time zone NOT NULL,
    time_end timestamp(6) without time zone NOT NULL,
    time_state boolean NOT NULL
);


ALTER TABLE "Time_interval" OWNER TO postgres;

--
-- Name: Type_administrator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Type_administrator" (
    type_adm_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    type_adm_date timestamp(6) without time zone NOT NULL,
    type_adm_name text NOT NULL
);


ALTER TABLE "Type_administrator" OWNER TO postgres;

--
-- Name: Type_community; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Type_community" (
    type_com_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    type_com_date timestamp(6) without time zone NOT NULL,
    type_com_name text NOT NULL
);


ALTER TABLE "Type_community" OWNER TO postgres;

--
-- Name: Type_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Type_request" (
    type_req_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    type_req_name text NOT NULL,
    type_req_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Type_request" OWNER TO postgres;

--
-- Name: Type_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Type_schedule" (
    ins_id character varying(32) NOT NULL,
    type_sch_name text NOT NULL,
    type_sch_id character varying(32) NOT NULL,
    type_sch_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Type_schedule" OWNER TO postgres;

--
-- Name: Type_space; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Type_space" (
    type_spa_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    type_spa_name text NOT NULL,
    type_spa_date timestamp(6) without time zone NOT NULL
);


ALTER TABLE "Type_space" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "User" (
    user_id character varying(32) NOT NULL,
    ins_id character varying(32) NOT NULL,
    user_name text NOT NULL,
    user_lastname text NOT NULL,
    user_password character varying(32) NOT NULL,
    user_mail text NOT NULL,
    user_date timestamp(6) without time zone NOT NULL,
    user_state boolean NOT NULL
);


ALTER TABLE "User" OWNER TO postgres;

--
-- Name: User_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "User_session" (
    ses_id character varying(32) NOT NULL,
    user_id character varying(32) NOT NULL,
    ses_date timestamp(6) without time zone NOT NULL,
    ses_expiration timestamp(6) without time zone NOT NULL,
    ses_state boolean NOT NULL
);


ALTER TABLE "User_session" OWNER TO postgres;

--
-- Data for Name: Administrator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Administrator" (adm_id, type_admin_id, adm_date, user_id) FROM stdin;
1	1	1999-09-19 00:00:00	1
\.


--
-- Data for Name: Community; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Community" (com_id, type_com_id, com_date, user_id) FROM stdin;
\.


--
-- Data for Name: Institution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Institution" (ins_id, ins_name, ins_img, ins_date) FROM stdin;
1	usach	www.google.cl	1999-08-01 00:00:00
2	UTFSM	www.facebook.com	1999-08-11 00:00:00
\.


--
-- Data for Name: Option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Option" (opt_id, ins_id, opt_name, opt_date, opt_state) FROM stdin;
\.


--
-- Data for Name: Request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Request" (req_id, ins_id, user_id, req_date, time_id, req_description, type_req_id, req_dependent, req_state) FROM stdin;
\.


--
-- Data for Name: Request_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Request_option" (req_opt_id, req_id, opt_id, req_opt_date) FROM stdin;
\.


--
-- Data for Name: Schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Schedule" (sch_id, adm_id, com_id, sch_date, time_id, spa_id, sch_description, type_sch_id, sch_capacity, ins_id, sch_state) FROM stdin;
\.


--
-- Data for Name: Schedule_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Schedule_option" (sch_opt_id, sch_id, opt_id, sch_opt_date) FROM stdin;
\.


--
-- Data for Name: Space; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Space" (spa_id, ins_id, spa_name, spa_date, spa_reference, spa_description, type_spa_id, spa_capacity, spa_state) FROM stdin;
\.


--
-- Data for Name: Space_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Space_option" (spa_opt_id, spa_id, opt_id, spa_opt_date) FROM stdin;
\.


--
-- Data for Name: Space_time; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Space_time" (spa_time_id, spa_id, time_id, spa_time_date) FROM stdin;
\.


--
-- Data for Name: Time_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Time_interval" (time_id, ins_id, time_name, time_begin, time_end, time_state) FROM stdin;
\.


--
-- Data for Name: Type_administrator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Type_administrator" (type_adm_id, ins_id, type_adm_date, type_adm_name) FROM stdin;
1	1	1999-09-19 00:00:00	Super Usuario
\.


--
-- Data for Name: Type_community; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Type_community" (type_com_id, ins_id, type_com_date, type_com_name) FROM stdin;
\.


--
-- Data for Name: Type_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Type_request" (type_req_id, ins_id, type_req_name, type_req_date) FROM stdin;
\.


--
-- Data for Name: Type_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Type_schedule" (ins_id, type_sch_name, type_sch_id, type_sch_date) FROM stdin;
\.


--
-- Data for Name: Type_space; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Type_space" (type_spa_id, ins_id, type_spa_name, type_spa_date) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "User" (user_id, ins_id, user_name, user_lastname, user_password, user_mail, user_date, user_state) FROM stdin;
1	1	mauricio	del rio	qqqqqq	mauricio.delrio@usach.cl	1999-09-19 00:00:00	t
2	2	user	user	qqqqqq	user@user.user	1999-09-19 00:00:00	t
\.


--
-- Data for Name: User_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "User_session" (ses_id, user_id, ses_date, ses_expiration, ses_state) FROM stdin;
\.


--
-- Name: Administrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Administrator"
    ADD CONSTRAINT "Administrator_pkey" PRIMARY KEY (adm_id);


--
-- Name: Community_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Community"
    ADD CONSTRAINT "Community_pkey" PRIMARY KEY (com_id);


--
-- Name: Institution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Institution"
    ADD CONSTRAINT "Institution_pkey" PRIMARY KEY (ins_id);


--
-- Name: Option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Option"
    ADD CONSTRAINT "Option_pkey" PRIMARY KEY (opt_id);


--
-- Name: Request_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request_option"
    ADD CONSTRAINT "Request_option_pkey" PRIMARY KEY (req_opt_id);


--
-- Name: Request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request"
    ADD CONSTRAINT "Request_pkey" PRIMARY KEY (req_id);


--
-- Name: Schedule_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule_option"
    ADD CONSTRAINT "Schedule_option_pkey" PRIMARY KEY (sch_opt_id);


--
-- Name: Schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule"
    ADD CONSTRAINT "Schedule_pkey" PRIMARY KEY (sch_id);


--
-- Name: Space_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space_option"
    ADD CONSTRAINT "Space_option_pkey" PRIMARY KEY (spa_opt_id);


--
-- Name: Space_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space"
    ADD CONSTRAINT "Space_pkey" PRIMARY KEY (spa_id);


--
-- Name: Space_time_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space_time"
    ADD CONSTRAINT "Space_time_pkey" PRIMARY KEY (spa_time_id);


--
-- Name: Time_interval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Time_interval"
    ADD CONSTRAINT "Time_interval_pkey" PRIMARY KEY (time_id);


--
-- Name: Type_administrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_administrator"
    ADD CONSTRAINT "Type_administrator_pkey" PRIMARY KEY (type_adm_id);


--
-- Name: Type_community_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_community"
    ADD CONSTRAINT "Type_community_pkey" PRIMARY KEY (type_com_id);


--
-- Name: Type_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_request"
    ADD CONSTRAINT "Type_request_pkey" PRIMARY KEY (type_req_id);


--
-- Name: Type_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_schedule"
    ADD CONSTRAINT "Type_schedule_pkey" PRIMARY KEY (type_sch_id);


--
-- Name: Type_space_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_space"
    ADD CONSTRAINT "Type_space_pkey" PRIMARY KEY (type_spa_id);


--
-- Name: User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);


--
-- Name: User_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "User_session"
    ADD CONSTRAINT "User_session_pkey" PRIMARY KEY (ses_id);


--
-- Name: fki_admin_schedule; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_admin_schedule ON "Schedule" USING btree (adm_id);


--
-- Name: fki_admin_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_admin_user ON "Administrator" USING btree (user_id);


--
-- Name: fki_community_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_community_user ON "Community" USING btree (user_id);


--
-- Name: fki_institution_opt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_institution_opt ON "Option" USING btree (ins_id);


--
-- Name: fki_institution_req; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_institution_req ON "Request" USING btree (ins_id);


--
-- Name: fki_option_req_op; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_option_req_op ON "Request_option" USING btree (opt_id);


--
-- Name: fki_option_schedule_option; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_option_schedule_option ON "Schedule_option" USING btree (opt_id);


--
-- Name: fki_option_space_option; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_option_space_option ON "Space_option" USING btree (opt_id);


--
-- Name: fki_req_req_op; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_req_req_op ON "Request_option" USING btree (req_id);


--
-- Name: fki_schedule_schedule_option; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_schedule_schedule_option ON "Schedule_option" USING btree (sch_id);


--
-- Name: fki_space_institution; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_space_institution ON "Space" USING btree (ins_id);


--
-- Name: fki_space_schedule; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_space_schedule ON "Schedule" USING btree (spa_id);


--
-- Name: fki_space_space_opt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_space_space_opt ON "Space_option" USING btree (spa_id);


--
-- Name: fki_space_space_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_space_space_time ON "Space_time" USING btree (spa_id);


--
-- Name: fki_t_sch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_t_sch ON "Schedule" USING btree (type_sch_id);


--
-- Name: fki_time_institution; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_time_institution ON "Time_interval" USING btree (ins_id);


--
-- Name: fki_time_sch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_time_sch ON "Request" USING btree (time_id);


--
-- Name: fki_time_schedule; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_time_schedule ON "Schedule" USING btree (time_id);


--
-- Name: fki_time_space_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_time_space_time ON "Space_time" USING btree (time_id);


--
-- Name: fki_type_adm_ins; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_adm_ins ON "Type_administrator" USING btree (ins_id);


--
-- Name: fki_type_com_ins; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_com_ins ON "Type_community" USING btree (ins_id);


--
-- Name: fki_type_req_ins; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_req_ins ON "Type_request" USING btree (ins_id);


--
-- Name: fki_type_req_req; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_req_req ON "Request" USING btree (type_req_id);


--
-- Name: fki_type_sch_ins; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_sch_ins ON "Type_schedule" USING btree (ins_id);


--
-- Name: fki_type_spa_ins; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_spa_ins ON "Type_space" USING btree (ins_id);


--
-- Name: fki_type_spa_spa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_type_spa_spa ON "Space" USING btree (type_spa_id);


--
-- Name: fki_user_institution; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_institution ON "User" USING btree (ins_id);


--
-- Name: fki_user_req; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_req ON "Request" USING btree (user_id);


--
-- Name: fki_user_schedule; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_schedule ON "Schedule" USING btree (com_id);


--
-- Name: fki_user_user_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_user_session ON "User_session" USING btree (user_id);


--
-- Name: admin_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule"
    ADD CONSTRAINT admin_schedule FOREIGN KEY (adm_id) REFERENCES "Administrator"(adm_id);


--
-- Name: admin_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Administrator"
    ADD CONSTRAINT admin_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);


--
-- Name: com_sch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule"
    ADD CONSTRAINT com_sch FOREIGN KEY (com_id) REFERENCES "Community"(com_id);


--
-- Name: community_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Community"
    ADD CONSTRAINT community_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);


--
-- Name: institution_opt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Option"
    ADD CONSTRAINT institution_opt FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: institution_req; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request"
    ADD CONSTRAINT institution_req FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: option_req_op; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request_option"
    ADD CONSTRAINT option_req_op FOREIGN KEY (opt_id) REFERENCES "Option"(opt_id);


--
-- Name: option_schedule_option; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule_option"
    ADD CONSTRAINT option_schedule_option FOREIGN KEY (opt_id) REFERENCES "Option"(opt_id);


--
-- Name: option_space_option; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space_option"
    ADD CONSTRAINT option_space_option FOREIGN KEY (opt_id) REFERENCES "Option"(opt_id);


--
-- Name: req_req_op; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request_option"
    ADD CONSTRAINT req_req_op FOREIGN KEY (req_id) REFERENCES "Request"(req_id);


--
-- Name: schedule_schedule_option; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule_option"
    ADD CONSTRAINT schedule_schedule_option FOREIGN KEY (sch_id) REFERENCES "Schedule"(sch_id);


--
-- Name: space_institution; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space"
    ADD CONSTRAINT space_institution FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: space_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule"
    ADD CONSTRAINT space_schedule FOREIGN KEY (spa_id) REFERENCES "Space"(spa_id);


--
-- Name: space_space_opt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space_option"
    ADD CONSTRAINT space_space_opt FOREIGN KEY (spa_id) REFERENCES "Space"(spa_id);


--
-- Name: space_space_time; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space_time"
    ADD CONSTRAINT space_space_time FOREIGN KEY (spa_id) REFERENCES "Space"(spa_id);


--
-- Name: t_sch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule"
    ADD CONSTRAINT t_sch FOREIGN KEY (type_sch_id) REFERENCES "Type_schedule"(type_sch_id);


--
-- Name: time_institution; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Time_interval"
    ADD CONSTRAINT time_institution FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: time_sch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request"
    ADD CONSTRAINT time_sch FOREIGN KEY (time_id) REFERENCES "Time_interval"(time_id);


--
-- Name: time_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Schedule"
    ADD CONSTRAINT time_schedule FOREIGN KEY (time_id) REFERENCES "Time_interval"(time_id);


--
-- Name: time_space_time; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space_time"
    ADD CONSTRAINT time_space_time FOREIGN KEY (time_id) REFERENCES "Time_interval"(time_id);


--
-- Name: type_adm_ins; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_administrator"
    ADD CONSTRAINT type_adm_ins FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: type_com_ins; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_community"
    ADD CONSTRAINT type_com_ins FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: type_req_ins; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_request"
    ADD CONSTRAINT type_req_ins FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: type_req_req; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request"
    ADD CONSTRAINT type_req_req FOREIGN KEY (type_req_id) REFERENCES "Type_request"(type_req_id);


--
-- Name: type_sch_ins; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_schedule"
    ADD CONSTRAINT type_sch_ins FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: type_spa_ins; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Type_space"
    ADD CONSTRAINT type_spa_ins FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: type_spa_spa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Space"
    ADD CONSTRAINT type_spa_spa FOREIGN KEY (type_spa_id) REFERENCES "Type_space"(type_spa_id);


--
-- Name: user_institution; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "User"
    ADD CONSTRAINT user_institution FOREIGN KEY (ins_id) REFERENCES "Institution"(ins_id);


--
-- Name: user_req; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Request"
    ADD CONSTRAINT user_req FOREIGN KEY (user_id) REFERENCES "User"(user_id);


--
-- Name: user_user_session; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "User_session"
    ADD CONSTRAINT user_user_session FOREIGN KEY (user_id) REFERENCES "User"(user_id);


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

