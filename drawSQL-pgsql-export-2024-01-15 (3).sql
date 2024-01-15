-- Baratov Otabek g33  v2
-- https://drawsql.app/teams/josuslar/diagrams/social-media-platform


CREATE TABLE "commit"(
    "comit_user_id" BIGINT NOT NULL,
    "commit_post_id" BIGINT NOT NULL,
    "id" BIGINT NOT NULL
);
CREATE TABLE "like"(
    "liked_post_id" BIGINT NOT NULL,
    "liked_user_id" BIGINT NOT NULL,
    "id" BIGINT NOT NULL
);
CREATE TABLE "post"(
    "post_id" bigserial NOT NULL,
    "post_title" VARCHAR(255) NOT NULL,
    "post_user_id" BIGINT NOT NULL,
    "like" BIGINT NOT NULL,
    "commit" BIGINT NOT NULL,
    "date" DATE NOT NULL
);
ALTER TABLE
    "post" ADD PRIMARY KEY("post_id");
CREATE TABLE "user_profile"(
    "user_id" bigserial NOT NULL,
    "full_name" VARCHAR(255) NOT NULL,
    "phone_number" VARCHAR(255) NOT NULL,
    "column_4" BIGINT NOT NULL
);
ALTER TABLE
    "user_profile" ADD PRIMARY KEY("user_id");
ALTER TABLE
    "like" ADD CONSTRAINT "like_liked_post_id_foreign" FOREIGN KEY("liked_post_id") REFERENCES "post"("post_id");
ALTER TABLE
    "post" ADD CONSTRAINT "post_post_user_id_foreign" FOREIGN KEY("post_user_id") REFERENCES "user_profile"("user_id");
ALTER TABLE
    "commit" ADD CONSTRAINT "commit_commit_post_id_foreign" FOREIGN KEY("commit_post_id") REFERENCES "post"("post_id");
ALTER TABLE
    "commit" ADD CONSTRAINT "commit_comit_user_id_foreign" FOREIGN KEY("comit_user_id") REFERENCES "user_profile"("user_id");
ALTER TABLE
    "like" ADD CONSTRAINT "like_liked_user_id_foreign" FOREIGN KEY("liked_user_id") REFERENCES "user_profile"("user_id");

CREATE OR REPLACE FUNCTION fn_search_post(
    s_post_name varchar(255)
)
    returns table(
                     post_title  varchar,
                     book_user_id bigint,
                     like bigint,
                     commit bigint
                 )
    language plpgsql
as
$$
begin
return query
select * from post where post_title like '%'s_post_name'%';
end
$$;


CREATE OR REPLACE procedure delete_post(
    post1_id bigint,
    post_title
)
    language plpgsql
as
$$
begin
 delete from post where post.id=post1_id;
end;
$$;



create view as
select user_id,full_name,count(post_id)
inner join post using(user_id);

CREATE MATERIALIZED VIEW number_of_post
as
select post_id, post_title, count(like) from post
where extract(year from date) = extract(year from now())-1;
