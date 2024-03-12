Plan.create!(stripe_id: "basic-monthly", name: "Monthly", price: 2, price_tier: 1)
Plan.create!(stripe_id: "basic-yearly", name: "Yearly", price: 20, price_tier: 1)
Plan.create!(stripe_id: "basic-monthly-2", name: "Monthly", price: 3, price_tier: 2)
Plan.create!(stripe_id: "basic-yearly-2", name: "Yearly", price: 30, price_tier: 2)
Plan.create!(stripe_id: "basic-monthly-3", name: "Monthly", price: 5, price_tier: 3)
Plan.create!(stripe_id: "basic-yearly-3", name: "Yearly", price: 50, price_tier: 3)

Plan.create!(stripe_id: "free", name: "Free", price: 0, price_tier: 3)
Plan.create!(stripe_id: "timed", name: "Timed", price: 0, price_tier: 3)
Plan.create!(stripe_id: "timed", name: "Timed", price: 0, price_tier: 2)
Plan.create!(stripe_id: "app-subscription", name: "App Subscription", price: 0, price_tier: 3)
Plan.create!(stripe_id: "podcast-subscription", name: "Podcast Subscription", price: 0, price_tier: 3)
plan = Plan.create!(stripe_id: FREE_TRIAL_PLAN_ID, name: "Trial", price: 0, price_tier: 3)

SuggestedCategory.create!(name: "Popular")
SuggestedCategory.create!(name: "Tech")
SuggestedCategory.create!(name: "Design")
SuggestedCategory.create!(name: "Arts & Entertainment")
SuggestedCategory.create!(name: "Sports")
SuggestedCategory.create!(name: "Business")
SuggestedCategory.create!(name: "Food")
SuggestedCategory.create!(name: "News")
SuggestedCategory.create!(name: "Gaming")

if Rails.env.development?

end

u = User.new(email: "admin@atalisfunding.com", password: "admin", password_confirmation: "admin", admin: true)
u.plan = plan
u.plan_id = FREE_TRIAL_PLAN_ID
u.update_auth_token = true
u.save

#u1 = User.new(email: "customer1@atalisfunding.com", password: "admin", password_confirmation: "admin", admin: false)
#plan1 = Plan.create!(stripe_id: "trial", name: "Trial", price: 0, price_tier: 3)
#u1.plan = plan1
#u1.update_auth_token = true
#u1.save

Profile.create!(profile_name: "Periodista", created_at: Time.now, updated_at: Time.now)
Tag.create!(name: "La liga", created_at: Time.now, updated_at: Time.now)
Tag.create!(name: "Motor", created_at: Time.now, updated_at: Time.now)
Tag.create!(name: "Basket", created_at: Time.now, updated_at: Time.now)

RProfilesTag.create!(profile_id: Profile.find_by(profile_name:"Periodista").id, tag_id: Tag.find_by(name:"La liga").id)
RProfilesTag.create!(profile_id: Profile.find_by(profile_name:"Periodista").id, tag_id: Tag.find_by(name:"Motor").id)
RProfilesTag.create!(profile_id: Profile.find_by(profile_name:"Periodista").id, tag_id: Tag.find_by(name:"Basket").id)

Feed.create!(
  title: "ACB Liga Endesa // marca",
  feed_url: "https://e00-marca.uecdn.es/rss/baloncesto/acb.xml",
  site_url: "http://www.marca.com",
  created_at: Time.now,
  updated_at: Time.now,
  subscriptions_count: 1,
  protected: false,
  push_expiration: nil,
  last_published_entry: Time.now,
  host: "www.marca.com",
  self_url: "https://e00-marca.uecdn.es/rss/baloncesto/acb.xml",
  feed_type: "xml",
  active: true,
  options:
   {"description"=>"ACB Liga Endesa // marca",
    "itunes_categories"=>[],
    "itunes_owners"=>[],
    "image"=>
     {"url"=>"http://estaticos.marca.com/imagen/canalima144.gif",
      "description"=>"marca.com",
      "height"=>"24",
      "link"=>"https://www.marca.com",
      "title"=>"ACB Liga Endesa // marca",
      "width"=>"144"}},
  hubs: [],
  settings: {},
  standalone_request_at: nil,
  last_change_check: nil
)

Feed.create!(
  title: "Fórmula 1 // marca",
  feed_url: "https://e00-marca.uecdn.es/rss/motor/formula1.xml",
  site_url: "http://www.marca.com",
  created_at: Time.now,
  updated_at: Time.now,
  subscriptions_count: 1,
  protected: false,
  push_expiration: nil,
  last_published_entry: Time.now,
  host: "www.marca.com",
  self_url: "https://e00-marca.uecdn.es/rss/motor/formula1.xml",
  feed_type: "xml",
  active: true,
  options:
   {"description"=>"Fórmula 1 // marca",
    "itunes_categories"=>[],
    "itunes_owners"=>[],
    "image"=>
     {"url"=>"http://estaticos.marca.com/imagen/canalima144.gif",
      "description"=>"marca.com",
      "height"=>"24",
      "link"=>"https://www.marca.com",
      "title"=>"Fórmula 1 // marca",
      "width"=>"144"}},
  hubs: [],
  settings: {},
  standalone_request_at: nil,
  last_change_check: nil,
)

Feed.create!(title: "RCD Mallorca",
  feed_url: "https://e00-marca.uecdn.es/rss/futbol/mallorca.xml",
  site_url: "http://www.marca.com",
  created_at: Time.now,
  updated_at: Time.now,
  subscriptions_count: 1,
  protected: false,
  push_expiration: nil,
  last_published_entry: Time.now,
  host: "www.marca.com",
  self_url: "https://e00-marca.uecdn.es/rss/futbol/mallorca.xml",
  feed_type: "xml",
  active: true,
  options:
   {"description"=>"Mallorca // marca",
    "itunes_categories"=>[],
    "itunes_owners"=>[],
    "image"=>
     {"url"=>"http://estaticos.marca.com/imagen/canalima144.gif",
      "description"=>"marca.com",
      "height"=>"24",
      "link"=>"https://www.marca.com",
      "title"=>"Mallorca // marca",
      "width"=>"144"}}
  )

Feed.create!(
  title: "Albacete // marca",
  feed_url: "https://e00-marca.uecdn.es/rss/futbol/albacete.xml",
  site_url: "http://www.marca.com",
  created_at: Time.now,
  updated_at: Time.now,
  subscriptions_count: 1,
  protected: false,
  push_expiration: nil,
  last_published_entry: Time.now,
  host: "www.marca.com",
  self_url: "https://e00-marca.uecdn.es/rss/futbol/albacete.xml",
  feed_type: "xml",
  active: true,
  options:
   {"description"=>"Albacete // marca",
    "itunes_categories"=>[],
    "itunes_owners"=>[],
    "image"=>
     {"url"=>"http://estaticos.marca.com/imagen/canalima144.gif",
      "description"=>"marca.com",
      "height"=>"24",
      "link"=>"https://www.marca.com",
      "title"=>"Albacete // marca",
      "width"=>"144"}},
  hubs: [],
  settings: {},
  standalone_request_at: nil,
  last_change_check: nil
)

Entry.create!(
  feed_id: Feed.find_by(title:"ACB Liga Endesa // marca").id,
  title: "Willy y Brizuela dan el estirón definitivo del Barcelona ante un combativo Joventut",
  url: "https://www.marca.com/baloncesto/acb/2023/09/24/6510522c46163f2ab78b4582.html",
  author: "José Luis Martínez",
  summary:
   "Willy Hernangómez (10) y Brizuela (10), dos de los fichajes azulgranas, aparecen entre el tercer y el último cuarto para romper el partido. Leer",
  content:
   "Willy Hernangómez (10) y Brizuela (10), dos de los fichajes azulgranas, aparecen entre el tercer y el último cuarto para romper el partido.&nbsp;<a href=\"https://www.marca.com/baloncesto/acb/2023/09/24/6510522c46163f2ab78b4582.html\"> Leer </a><img src=\"http://secure-uk.imrworldwide.com/cgi-bin/m?cid=es-widgetueditorial&amp;cg=rss-marca&amp;ci=es-widgetueditorial&amp;si=https://e00-marca.uecdn.es/rss/baloncesto/acb.xml\" alt=\"\"/>",
  published: Time.now,
  updated: nil,
  created_at: Time.now,
  updated_at: Time.now,
  entry_id: "https://www.marca.com/baloncesto/acb/2023/09/24/6510522c46163f2ab78b4582.html",
  public_id: "38c9ceda27ac3d9e53e6e88b2fbdc57061187033",
  old_public_id: nil,
  starred_entries_count: 0,
  data: {"public_id_alt"=>"1bd0683729d9b62d7b746e2062f37dd87a692f48"},
  original: nil,
  source: nil,
  image_url: nil,
  processed_image_url: nil,
  image: nil,
  recently_played_entries_count: 0,
  thread_id: nil,
  settings: {},
  main_tweet_id: nil,
  queued_entries_count: 0,
  fingerprint: "f4cdc273-9c01-4f8f-d759-b12394d184b6",
  guid: "4744f1a4-5fed-3ec5-a8fc-58d48323d3fb",
  provider: nil,
  provider_id: nil,
  provider_parent_id: nil
)

Entry.create!(
  feed_id: Feed.find_by(title:"Fórmula 1 // marca").id,
  title: "Monumental cabreo de Gasly por tener que dejar pasar a Ocon: surtido de peinetas al aire",
  url: "https://www.marca.com/motor/formula1/gp-japon/2023/09/24/650ff7cc22601d017d8b458b.html",
  author: "RAMÓN GARCÍA",
  summary:
   "Alpine pidió al piloto francés que intercambiara posición con su compañero y acabó la carrera totalmente desquiciado por la decisión Leer",
  content:
   "Alpine pidió al piloto francés que intercambiara posición con su compañero y acabó la carrera totalmente desquiciado por la decisión&nbsp;<a href=\"https://www.marca.com/motor/formula1/gp-japon/2023/09/24/650ff7cc22601d017d8b458b.html\"> Leer </a><img src=\"http://secure-uk.imrworldwide.com/cgi-bin/m?cid=es-widgetueditorial&amp;cg=rss-marca&amp;ci=es-widgetueditorial&amp;si=https://e00-marca.uecdn.es/rss/motor/formula1.xml\" alt=\"\"/>",
  published: Time.now,
  updated: nil,
  created_at: Time.now,
  updated_at: Time.now,
  entry_id: "https://www.marca.com/motor/formula1/gp-japon/2023/09/24/650ff7cc22601d017d8b458b.html",
  public_id: "a55ffa1646a095022d2bb97ae59f20cf21e89443",
  old_public_id: nil,
  starred_entries_count: 0,
  data: {"public_id_alt"=>"830f0318bdf31aedf6014e1c2d2186c92e1107f3"},
  original: nil,
  source: nil,
  image_url: nil,
  processed_image_url: nil,
  image: nil,
  recently_played_entries_count: 0,
  thread_id: nil,
  settings: {},
  main_tweet_id: nil,
  queued_entries_count: 0,
  fingerprint: "17ac4496-e1c9-ec43-2d37-d3faa82a66fc",
  guid: "6f1c425d-9d41-503b-4313-e0b40ca250ae",
  provider: nil,
  provider_id: nil,
  provider_parent_id: nil
)

Entry.create!(
  feed_id: Feed.find_by(title:"Albacete // marca").id,
  title: "El Alba cede a Juan María al Mirandés y da la baja a Montes",
  url: "https://www.marca.com/futbol/mirandes/2023/07/10/64abb52c22601de30f8b45b1.html",
  author: "LUIS CASTELO",
  summary: "El lateral zurdo del Alba refuerza al equipo burgalés Leer",
  content:
   "El lateral zurdo del Alba refuerza al equipo burgalés&nbsp;<a href=\"https://www.marca.com/futbol/mirandes/2023/07/10/64abb52c22601de30f8b45b1.html\"> Leer </a><img src=\"http://secure-uk.imrworldwide.com/cgi-bin/m?cid=es-widgetueditorial&amp;cg=rss-marca&amp;ci=es-widgetueditorial&amp;si=https://e00-marca.uecdn.es/rss/futbol/albacete.xml\" alt=\"\"/>",
  published: Time.now,
  updated: nil,
  created_at: Time.now,
  updated_at: Time.now,
  entry_id: "https://www.marca.com/futbol/mirandes/2023/07/10/64abb52c22601de30f8b45b1.html",
  public_id: "c77fe94f8b28418c7c663904b275de28bc673ed8",
  old_public_id: nil,
  starred_entries_count: 0,
  data: {"public_id_alt"=>"d847a4470b675262203350cacde262a76139cbbc"},
  original: nil,
  source: nil,
  image_url: nil,
  processed_image_url: nil,
  image: nil,
  recently_played_entries_count: 0,
  thread_id: nil,
  settings: {},
  main_tweet_id: nil,
  queued_entries_count: 0,
  fingerprint: "5c3a641e-4802-cd5f-ac6c-92c58b3d0bbc",
  guid: "4f0fa545-3b0d-3cb6-373b-271e2b3d034d",
  provider: nil,
  provider_id: nil,
  provider_parent_id: nil
)

Entry.create!(
  feed_id: Feed.find_by(title:"RCD Mallorca").id,
  title: "Goleada del Mallorca en la segunda prueba de la pretemporada",
  url: "https://www.marca.com/futbol/mallorca/2023/07/17/64b582c422601d3f268b458d.html",
  author: "JUAN MIGUEL SÁNCHEZ",
  summary: "Triunfo 0-9 ante el filial del SV Ried en un choque de muchas probaturas para adquirir ritmo de competición Leer",
  content:
   "Triunfo 0-9 ante el filial del SV Ried en un choque de muchas probaturas para adquirir ritmo de competición&nbsp;<a href=\"https://www.marca.com/futbol/mallorca/2023/07/17/64b582c422601d3f268b458d.html\"> Leer </a><img src=\"http://secure-uk.imrworldwide.com/cgi-bin/m?cid=es-widgetueditorial&amp;cg=rss-marca&amp;ci=es-widgetueditorial&amp;si=https://e00-marca.uecdn.es/rss/futbol/mallorca.xml\" alt=\"\"/>",
  published: Time.now,
  updated: nil,
  created_at: Time.now,
  updated_at: Time.now,
  entry_id: "https://www.marca.com/futbol/mallorca/2023/07/17/64b582c422601d3f268b458d.html",
  public_id: "09ccf11a2b24de0d2b8299aa072006b4fbb31fe8",
  old_public_id: nil,
  starred_entries_count: 0,
  data: {"public_id_alt"=>"14a2c083e51a70f4319a7edac0daedaf061db19b"},
  original: nil,
  source: nil,
  image_url: nil,
  processed_image_url: nil,
  image: nil,
  recently_played_entries_count: 0,
  thread_id: nil,
  settings: {}
)

Subscription.create!(
  user_id: 1,
  feed_id: Feed.find_by(title:"ACB Liga Endesa // marca").id,
  created_at: Time.now,
  updated_at: Time.now,
  title: "ACB Liga Endesa // marca",
  view_inline: false,
  active: true,
  push: false,
  show_updates: true,
  muted: false,
  show_retweets: true,
  media_only: nil,
  kind: "default",
  view_mode: "article",
  show_status: "not_show"
)

Subscription.create!(
 user_id: 1,
 feed_id: Feed.find_by(title:"Fórmula 1 // marca").id,
 created_at: Time.now,
 updated_at: Time.now,
 title: "Fórmula 1 // marca",
 view_inline: false,
 active: true,
 push: false,
 show_updates: true,
 muted: false,
 show_retweets: true,
 media_only: nil,
 kind: "default",
 view_mode: "article",
 show_status: "not_show"
)

Subscription.create!(
  user_id: 1,
  feed_id: Feed.find_by(title:"RCD Mallorca").id,
  created_at: Time.now,
  updated_at: Time.now,
  title: "RCD Mallorca",
  view_inline: false,
  active: true,
  push: false,
  show_updates: true,
  muted: false,
  show_retweets: true,
  media_only: nil,
  kind: "default",
  view_mode: "article"
)

Subscription.create!(
  user_id: 1,
  feed_id: Feed.find_by(title:"Albacete // marca").id,
  created_at: Time.now,
  updated_at: Time.now,
  title: "Albacete // marca",
  view_inline: false,
  active: true,
  push: false,
  show_updates: true,
  muted: false,
  show_retweets: true,
  media_only: nil,
  kind: "default",
  view_mode: "article",
  show_status: "not_show"
)

Tagging.create!(
  feed_id: Feed.find_by(title:"ACB Liga Endesa // marca").id,
  user_id: 1,
  tag_id: Tag.find_by(name:"Basket").id,
  created_at: Time.now,
  updated_at: Time.now
)

Tagging.create!(
  feed_id: Feed.find_by(title:"Fórmula 1 // marca").id,
  user_id: 1,
  tag_id: Tag.find_by(name:"Motor").id,
  created_at: Time.now,
  updated_at: Time.now
)

Tagging.create!(
  feed_id: Feed.find_by(title:"RCD Mallorca").id,
  user_id: 1,
  tag_id: Tag.find_by(name:"La liga").id,
  created_at: Time.now,
  updated_at: Time.now
)

Tagging.create!(
  feed_id: Feed.find_by(title:"Albacete // marca").id,
  user_id: 1,
  tag_id: Tag.find_by(name:"La liga").id,
  created_at: Time.now,
  updated_at: Time.now
)

RUsersProfile.create!(user_id: 1, profile_id: Profile.find_by(profile_name:"Periodista").id)
