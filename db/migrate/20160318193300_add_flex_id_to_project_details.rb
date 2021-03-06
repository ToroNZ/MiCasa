class AddFlexIdToProjectDetails < ActiveRecord::Migration
  def change
    execute "drop view \"1\".project_details;"
    execute <<-SQL
    create view "1".project_details as SELECT p.id AS project_id,
    p.id,
    p.user_id,
    fp.id as flex_id,
    p.name,
    p.headline,
    p.budget,
    p.goal,
    p.about_html,
    p.permalink,
    p.video_embed_url,
    p.video_url,
    c.name_es AS category_name,
    c.id AS category_id,
    original_image(p.*) AS original_image,
    thumbnail_image(p.*, 'thumb'::text) AS thumb_image,
    thumbnail_image(p.*, 'small'::text) AS small_image,
    thumbnail_image(p.*, 'large'::text) AS large_image,
    thumbnail_image(p.*, 'video_cover'::text) AS video_cover_image,
    COALESCE(pt.progress, 0::numeric) AS progress,
    COALESCE(pt.pledged, 0::numeric) AS pledged,
    COALESCE(pt.total_contributions, 0::bigint) AS total_contributions,
    COALESCE(pt.total_contributors, 0::bigint) AS total_contributors,
    COALESCE(fp.state, p.state::text) AS state,
    mode(p.*) AS mode,
    state_order(p.*) AS state_order,
    p.expires_at,
    zone_timestamp(p.expires_at) AS zone_expires_at,
    online_at(p.*) AS online_date,
    zone_timestamp(online_at(p.*)) AS zone_online_date,
    zone_timestamp(in_analysis_at(p.*)) AS sent_to_analysis_at,
    is_published(p.*) AS is_published,
    is_expired(p.*) AS is_expired,
    open_for_contributions(p.*) AS open_for_contributions,
    p.online_days,
    remaining_time_json(p.*) AS remaining_time,
    elapsed_time_json(p.*) AS elapsed_time,
    ( SELECT count(pp_1.*) AS count
           FROM project_posts pp_1
          WHERE pp_1.project_id = p.id) AS posts_count,
    json_build_object('city', COALESCE(ct.name, u.address_city), 'state_acronym', COALESCE(st.acronym, u.address_state::character varying), 'state', COALESCE(st.name, u.address_state::character varying)) AS address,
    json_build_object('id', u.id, 'name', u.name) AS "user",
    count(DISTINCT pr.user_id) AS reminder_count,
    is_owner_or_admin(p.user_id) AS is_owner_or_admin,
    user_signed_in() AS user_signed_in,
    current_user_already_in_reminder(p.*) AS in_reminder,
    count(pp.*) AS total_posts,
    "current_user"() = 'admin'::name AS is_admin_role
   FROM projects p
     JOIN categories c ON c.id = p.category_id
     JOIN users u ON u.id = p.user_id
     LEFT JOIN flexible_projects fp ON fp.project_id = p.id
     LEFT JOIN project_posts pp ON pp.project_id = p.id
     LEFT JOIN "1".project_totals pt ON pt.project_id = p.id
     LEFT JOIN cities ct ON ct.id = p.city_id
     LEFT JOIN states st ON st.id = ct.state_id
     LEFT JOIN project_reminders pr ON pr.project_id = p.id
  GROUP BY p.id, fp.id, c.id, u.id, c.name_es, ct.name, u.address_city, st.acronym, u.address_state, st.name, pt.progress, pt.pledged, pt.total_contributions, p.state, p.expires_at, pt.total_payment_service_fee, fp.state, pt.total_contributors;

  SQL
  execute "GRANT SELECT ON \"1\".project_details TO admin, anonymous, web_user;"
  end
end
