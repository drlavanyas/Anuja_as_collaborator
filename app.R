# Resume website – Anuja Nandini Bose
# Run:  install.packages(c("shiny", "bslib"))  then  shiny::runApp("resume-site")

library(shiny)
library(bslib)

LINKEDIN_URL <- "#"  # <- paste your LinkedIn profile link here

# ---------- Content ----------
skill_groups <- list(
  Research  = c("Field-based research", "Community research", "Quantitative & qualitative methods",
                "Literature-based research", "Research documentation"),
  Data      = c("MS Excel", "Data organization", "Interpreting findings",
                "Statistical computing (seminar-trained)"),
  Reporting = c("Report writing", "Academic presentations", "MS Word", "MS PowerPoint"),
  Technical = c("PGDCA", "HTML", "DOS", "Tally", "Basic Java", "Photoshop", "After Effects", "Premiere")
)
skills <- data.frame(
  group = rep(names(skill_groups), lengths(skill_groups)),
  item  = unlist(skill_groups, use.names = FALSE),
  stringsAsFactors = FALSE
)

education <- list(
  list(when = "2024 – 2026", what = "Master of Public Health (MPH)",
       where = "ICMR-NIHR, Bhubaneswar", note = "Continuing"),
  list(when = "2021 – 2023", what = "M.Sc. Anthropology",
       where = "Sambalpur University, Burla", note = "GPA 7.80"),
  list(when = "2017 – 2020", what = "B.Sc. Zoology",
       where = "Utkal University", note = "CGPA 8.14")
)

projects <- list(
  list(id = "menstrual",
       title = "Menstruation among adolescent girls, Gambhari Panchayat",
       meta = "Master's research · Sambalpur University · 2021–2023",
       body = c(
         "Studied changes and management practices related to menstruation among adolescent girls in Gambhari Panchayat, Balangir District, Odisha.",
         "Worked with community-level information on adolescent and menstrual health practices.",
         "Organized and interpreted the information to identify patterns, then wrote it up and presented the findings."
       )),
  list(id = "reptiles",
       title = "Habitat and ecological behaviour of reptiles",
       meta = "Undergraduate research · Utkal University · 2017–2020",
       body = c(
         "Studied reptiles at Nandankanan Zoological Park, Bhubaneswar.",
         "Used systematic observation and documentation to organize field findings."
       )),
  list(id = "forensic",
       title = "Hands-on workshop in forensic anthropology",
       meta = "University of Calcutta · RUSA 2.0 · 2023",
       body = c(
         "Practical training in structured observation, documentation and anthropological methods."
       ))
)

# ---------- Styling ----------
css <- "
:root{--ink:#10302F;--teal:#0F5257;--mist:#EEF4F2;--sun:#F0A500;--line:#C9D8D4;--paper:#FAFCFB}
html{scroll-behavior:smooth}
body{background:var(--paper);color:var(--ink);font-family:'Literata',Georgia,serif;line-height:1.7;font-size:17px}
h1,h2,h3,h4,.navbar,.btn,.chip,.tab-btn{font-family:'Bricolage Grotesque',system-ui,sans-serif}
.navbar{background:var(--ink)!important;border:0}
.navbar .nav-link{color:#CFE3DE!important;font-weight:500}
.navbar .nav-link.active,.navbar .nav-link:hover{color:#fff!important;box-shadow:inset 0 -3px 0 var(--sun)}
.navbar-brand{color:#fff!important;font-weight:700}
.wrap{max-width:900px;margin:0 auto;padding:48px 20px 72px}
.hero{background:var(--ink);color:#fff;padding:72px 20px 64px;position:relative;overflow:hidden}
.hero:after{content:'';position:absolute;right:-90px;top:-90px;width:320px;height:320px;border-radius:50%;
  border:28px solid var(--sun);opacity:.9}
.hero .inner{max-width:900px;margin:0 auto;position:relative;z-index:1}
.hero h1{font-size:clamp(2.6rem,7vw,4.6rem);font-weight:800;line-height:1.02;letter-spacing:-.02em;margin:0 0 18px}
.hero p{font-size:1.15rem;max-width:36em;color:#D6E8E3;margin:0 0 26px}
.btn-sun{background:var(--sun);color:var(--ink);font-weight:700;border:0;border-radius:6px;padding:10px 20px;margin:0 8px 8px 0}
.btn-sun:hover{background:#ffbb1f;color:var(--ink)}
.btn-ghost{border:2px solid #7FA6A0;color:#fff;border-radius:6px;padding:8px 18px;margin:0 8px 8px 0;font-weight:600}
.btn-ghost:hover{border-color:#fff;color:#fff}
h2{font-weight:700;font-size:1.9rem;margin:0 0 22px}
.lead-p{font-size:1.1rem}
.facts{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:14px;margin-top:30px}
.fact{background:var(--mist);padding:16px 18px;border-left:5px solid var(--teal);border-radius:0 8px 8px 0}
.fact b{display:block;font-family:'Bricolage Grotesque',sans-serif;font-size:1.05rem}
.fact span{font-size:.92rem}
.tl{border-left:3px solid var(--teal);margin-left:6px;padding-left:26px}
.tl-item{position:relative;padding-bottom:30px}
.tl-item:before{content:'';position:absolute;left:-36px;top:7px;width:16px;height:16px;border-radius:50%;
  background:var(--sun);border:3px solid var(--paper);box-shadow:0 0 0 2px var(--teal)}
.tl-item h3{font-size:1.25rem;font-weight:700;margin:0}
.tl-item .when{font-family:'Bricolage Grotesque',sans-serif;color:var(--teal);font-weight:600;font-size:.95rem}
.badge-note{background:var(--sun);color:var(--ink);font-family:'Bricolage Grotesque',sans-serif;font-weight:700;
  font-size:.8rem;border-radius:20px;padding:2px 10px;margin-left:8px}
.proj{border:1px solid var(--line);border-radius:10px;margin-bottom:14px;background:#fff}
.proj summary{cursor:pointer;padding:16px 20px;list-style:none}
.proj summary::-webkit-details-marker{display:none}
.proj summary h3{font-size:1.15rem;font-weight:700;margin:0 0 2px}
.proj summary small{color:var(--teal);font-family:'Bricolage Grotesque',sans-serif}
.proj[open] summary{border-bottom:1px solid var(--line);background:var(--mist);border-radius:10px 10px 0 0}
.proj ul{margin:0;padding:16px 20px 16px 40px}
.filters .shiny-options-group{display:flex;flex-wrap:wrap;gap:8px}
.filters .radio-inline,.filters .radio{margin:0;padding:0}
.filters input{position:absolute;opacity:0}
.filters label{cursor:pointer}
.filters .radio-inline span,.filters .radio span{display:inline-block;padding:7px 16px;border:2px solid var(--teal);
  border-radius:30px;font-family:'Bricolage Grotesque',sans-serif;font-weight:600;color:var(--teal)}
.filters input:checked+span{background:var(--teal);color:#fff}
.filters input:focus-visible+span{outline:3px solid var(--sun);outline-offset:2px}
.chips{display:flex;flex-wrap:wrap;gap:10px;margin-top:22px;min-height:120px;align-content:flex-start}
.chip{background:var(--mist);border:1px solid var(--line);padding:8px 16px;border-radius:6px;font-weight:600}
.lang{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:12px;margin-top:34px}
.lang div{border-top:4px solid var(--sun);background:var(--mist);padding:12px 14px}
.lang b{font-family:'Bricolage Grotesque',sans-serif;display:block}
.contact a{color:var(--teal);font-weight:600}
.contact p{margin:6px 0}
footer{text-align:center;padding:24px;color:#5C7571;font-size:.9rem}
@media (prefers-reduced-motion:reduce){html{scroll-behavior:auto}}
"

fonts <- tags$link(
  rel = "stylesheet",
  href = paste0("https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@500;600;700;800",
                "&family=Literata:ital,wght@0,400;0,600;1,400&display=swap")
)

# ---------- UI ----------
about_ui <- tagList(
  div(class = "hero", div(class = "inner",
                          h1("Anuja Nandini Bose"),
                          p("Public health researcher and anthropologist from Odisha, studying adolescent and community health, ",
                            "and building skills in monitoring, evaluation and implementation research."),
                          tags$a(class = "btn btn-sun", href = "mailto:bose.anuja123@gmail.com", "Email me"),
                          tags$a(class = "btn btn-ghost", href = LINKEDIN_URL, target = "_blank", "LinkedIn")
  )),
  div(class = "wrap",
      h2("About"),
      p(class = "lead-p",
        "I hold an M.Sc. in Anthropology and am completing an MPH at ICMR-NIHR, Bhubaneswar. ",
        "My research looked at menstrual health and management among adolescent girls in rural Odisha, ",
        "from collecting field information to organizing, interpreting and presenting it."),
      p("I want to work on evidence generation and data-driven improvement of public health and development programs."),
      div(class = "facts",
          div(class = "fact", tags$b("Focus"), span("Adolescent, menstrual and community health")),
          div(class = "fact", tags$b("Looking for"), span("Monitoring, evaluation and implementation research")),
          div(class = "fact", tags$b("Field context"), span("Balangir District, Odisha")),
          div(class = "fact", tags$b("Tools"), span("MS Excel, Word, PowerPoint"))
      )
  )
)

education_ui <- div(class = "wrap",
                    h2("Education"),
                    div(class = "tl",
                        lapply(education, function(e) div(class = "tl-item",
                                                          span(class = "when", e$when),
                                                          h3(e$what, span(class = "badge-note", e$note)),
                                                          p(e$where)
                        ))
                    ),
                    h2(style = "margin-top:36px", "Training"),
                    div(class = "tl",
                        div(class = "tl-item", span(class = "when", "2017 – 2018"), h3("Post Graduate Diploma in Computer Applications"),
                            p("MS Office, HTML, DOS and computer applications.")),
                        div(class = "tl-item", span(class = "when", "2017 – 2018"), h3("Computer Accounting, Tally 9.0")),
                        div(class = "tl-item", span(class = "when", "2018 – 2019"), h3("Motion Graphics Pro"),
                            p("Photoshop, Adobe After Effects and Adobe Premiere.")),
                        div(class = "tl-item", span(class = "when", "2022 – 2023"), h3("Seminars on data and statistics"),
                            p("Statistical Computing and Data Analytics (2022); Statistics and Artificial Intelligence in Emerging Scenarios (2023)."))
                    )
)

research_ui <- div(class = "wrap",
                   h2("Research and experience"),
                   p("Select a project to read more."),
                   lapply(projects, function(p_) tags$details(class = "proj", open = if (p_$id == "menstrual") NA else NULL,
                                                              tags$summary(h3(p_$title), tags$small(p_$meta)),
                                                              tags$ul(lapply(p_$body, tags$li))
                   ))
)

skills_ui <- div(class = "wrap",
                 h2("Skills"),
                 div(class = "filters",
                     radioButtons("grp", NULL, inline = TRUE,
                                  choices = c("All", "Research", "Data", "Reporting", "Technical"))
                 ),
                 uiOutput("chips"),
                 div(class = "lang",
                     div(tags$b("Odia"), "Fluent"), div(tags$b("English"), "Fluent"),
                     div(tags$b("Hindi"), "Working proficiency"), div(tags$b("Bengali"), "Working proficiency")
                 )
)

contact_ui <- div(class = "wrap contact",
                  h2("Contact"),
                  p("Khordha, Odisha, India"),
                  p(tags$a(href = "mailto:bose.anuja123@gmail.com", "bose.anuja123@gmail.com")),
                  p(tags$a(href = "tel:+918895520622", "8895520622"), " / ", tags$a(href = "tel:+917008969214", "7008969214")),
                  p(tags$a(href = LINKEDIN_URL, target = "_blank", "LinkedIn profile")),
                  hr(),
                  p("Outside work: reading, travelling, debating, cooking, movies and dancing.")
)

ui <- page_navbar(
  title = "Anuja N. Bose",
  theme = bs_theme(version = 5, bg = "#FAFCFB", fg = "#10302F", primary = "#0F5257"),
  header = tagList(fonts, tags$style(HTML(css)), tags$title("Anuja Nandini Bose – Resume")),
  nav_panel("About", about_ui),
  nav_panel("Education", education_ui),
  nav_panel("Research", research_ui),
  nav_panel("Skills", skills_ui),
  nav_panel("Contact", contact_ui)
)

# ---------- Server ----------
server <- function(input, output, session) {
  output$chips <- renderUI({
    d <- if (is.null(input$grp) || input$grp == "All") skills else skills[skills$group == input$grp, ]
    div(class = "chips", lapply(d$item, function(x) span(class = "chip", x)))
  })
}

shinyApp(ui, server)