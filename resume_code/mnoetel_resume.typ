#import "@preview/modern-cv:0.9.0": *

#show: resume.with(
  author: (
    firstname: "Michael",
    lastname: "Noetel",
    email: "m.noetel@uq.edu.au",
    phone: "(+61) 414 822 353",
    linkedin: "mnoetel",
    positions: (
      "Associate Professor",
      "The University of Queensland",
    ),
  ),
  profile-picture: image("mnoetel_circle.png"),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  language: "en",
  colored-headers: true,
  font: "Source Sans Pro",
  header-font: "Roboto",
  paper-size: "a4",
  accent-color: rgb("#053C45"),
)

// ── Add breathing room around section headings ──
#show heading.where(level: 1): it => {
  v(0.6em)
  it
  v(0.4em)
}

// ── Style links: accent colour + underline ──
#show link: it => {
  set text(fill: rgb("#053C45"))
  underline(it)
}

// ── Load dynamic data ──
#let data = json("publications.json")
#let metrics = data.metrics
#let pubs = data.publications

// ── Title-case helper (lowercase small words except first) ──
#let small-words = ("a", "an", "and", "as", "at", "but", "by", "for", "if", "in", "nor", "of", "on", "or", "so", "the", "to", "up", "yet")
#let title-case(s) = {
  // Preserve already-lowercase short tokens (e.g., "bmj")
  if s == lower(s) and s.len() < 10 {
    s
  } else {
    let words = lower(s).split(" ")
    words.enumerate().map(((i, w)) => {
      if i == 0 or w not in small-words {
        upper(w.first()) + w.slice(1)
      } else {
        w
      }
    }).join(" ")
  }
}

// ── Custom publication entry ──
#let pub-entry(pub) = {
  // Extract surname only
  let author = pub.first_author
  let surname = if "," in author { author.split(",").at(0) } else { author.split(" ").at(0) }
  let author_display = surname + ", et al."

  // Build DOI link
  let doi_url = if pub.doi != "" and pub.doi != none { "https://doi.org/" + pub.doi } else { none }

  // Metrics line: only show cites > 10, only show CNCI > 1
  let parts = ()
  if pub.cites > 10 {
    let cite_word = if pub.cites == 1 { "citation" } else { "citations" }
    parts.push(strong(str(pub.cites) + " " + cite_word))
  }
  if pub.cnci != none and pub.cnci > 1 {
    parts.push(strong("CNCI: " + str(pub.cnci)))
  }
  let metrics_line = parts.join(" | ")

  block(above: 0.8em, below: 0.4em)[
    #text(size: 0.85em)[
      #if doi_url != none [
        #link(doi_url)[#author_display (#str(pub.year)). #pub.title]
      ] else [
        #author_display (#str(pub.year)). #pub.title
      ]
      #linebreak()
      #text(fill: luma(80), style: "italic")[#title-case(pub.journal)]
      #if parts.len() > 0 {
        text(fill: luma(80))[ --- ]
        metrics_line
      }
    ]
  ]
}

// ── Custom grant entry (grantor below title) ──
#let grant-entry(title, grantor, date, amount) = {
  block(above: 1em, below: 0.6em)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      text(weight: "bold")[#title],
      text[#date],
    )
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      text(size: 0.9em, fill: luma(80))[#grantor],
      text(size: 0.9em)[#amount],
    )
  ]
}

// ── Custom award entry (compact, no location) ──
#let award-entry(title, org, year) = {
  block(above: 0.8em, below: 0.4em)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      text(weight: "bold")[#title],
      text[#year],
    )
    #if org != "" [
      #text(size: 0.9em, fill: luma(80))[#org]
    ]
  ]
}

#v(0.5em)

= Summary

#resume-item[
  I work to reduce catastrophic risks from advanced AI while helping others do the most good they can. My work integrates consensus-building, evidence synthesis, and scalable public communication to deliver policy-ready guidance at the pace of frontier AI.
]

= Select AI Governance Contributions

#resume-item[
  - *SARA Project*: Led the Survey of Assessing Risks from AI, which informed Australia's Safe and Responsible AI in Australia discussion paper.
  - *AI Risk Repository*: Co-authored repository of AI risk pathways (airisk.mit.edu), cited in the International AI Safety Report (2024).
  - *Field-building*: Facilitated three cohorts of the AGI Safety Fundamentals Governance Course (BlueDot Impact) and supervise graduate research on frontier evals, AI literacy, AI consciousness, and public risk perception.
]

= Teaching & Engagement Impact

#resume-item[
  - *Award-winning educator*: 9 national & institutional awards, incl. Australian Award for University Teaching & Vice-Chancellor's Award for Excellence. Mean student rating 4.8/5 across 2,390 students.
  - *Public science communicator*: 10 _Conversation_ articles (250K+ reads); media interviews for CNN, BBC, ABC, PBS NewsHour, The Times, including TV and live radio; invited to brief federal parliamentarians.
  - *Chair*, Effective Altruism Australia since 2021 – stewarding AU\$7.5M+/yr to cost-effective global-health and climate programs.
]

= Research Excellence

#resume-item[
  - *High-impact evidence synthesis*: Lead author, network meta-analysis of exercise for depression (_BMJ_, Altmetric > 1,400; 100M+ media reach). Publications in my fields' top journals: _Nature Human Behaviour_, _Psychological Bulletin_, _Review of Educational Research_.
  - *Competitive funding*: Chief Investigator on AU\$3.7M Category 1 grants (NHMRC, MRFF, ARC).
  - *Transparent & truth-seeking*: Embed pre-registration, open data/code; lead multi-institution teams using Agile & Scrum.
  - *Metrics of excellence* (Web of Science): h-index *#metrics.h_index*; m-index *#metrics.m_index* (>2 = 'outstanding scientist'); *#str(metrics.pct_top10)%* of papers in top-10% most-cited; mean CNCI *#metrics.mean_cnci* — my work is cited almost #calc.round(metrics.mean_cnci, digits: 0)× the world average (1.0).
]

= Skills

#resume-skill-item(
  "Evidence synthesis",
  (
    "Systematic reviews",
    "Meta-analyses",
    "Expert elicitation (e.g., Delphi)",
  ),
)
#resume-skill-item(
  "Leadership",
  (
    "Agile project leadership",
    "Stakeholder engagement",
    "Board governance"
  ),
)
#resume-skill-item(
  "Communication",
  (
    "Video production",
    "Media engagement",
    "Policy briefs",
    "Knowledge translation",
  ),
)
#resume-skill-item(
  "Technical",
  (
    "R",
    "Agentic AI",
    "Git",
    "OSF",
    "Data analysis",
    "Reproducible workflows",
  ),
)

= Education

#resume-entry(
  title: "Doctor of Philosophy",
  location: "Australian Catholic University",
  date: "2019",
  description: "Institute for Positive Psychology and Education",
)
#resume-entry(
  title: "Masters of Applied Psychology",
  location: "The University of Queensland",
  date: "2010",
  description: "",
)
#resume-entry(
  title: "Bachelor of Science (Advanced, Honours)",
  location: "University of Sydney",
  date: "2008",
  description: "Double Major: Psychology; Computational Science",
)

= Academic Experience

#resume-entry(
  title: "Associate Professor",
  location: "The University of Queensland",
  date: "2025–Present",
  description: "School of Psychology",
)
#resume-entry(
  title: "Affiliate Researcher",
  location: "Massachusetts Institute of Technology",
  date: "2025–Present",
  description: "FutureTech",
)
#resume-entry(
  title: "Senior Lecturer",
  location: "The University of Queensland",
  date: "2022–2024",
  description: "School of Psychology",
)
#resume-entry(
  title: "Senior Lecturer",
  location: "Australian Catholic University",
  date: "2020–2022",
  description: "School of Health and Behavioural Sciences",
)
#resume-entry(
  title: "Research Fellow (Secondment; .4 FTE)",
  location: "Australian Catholic University",
  date: "2018–2019",
  description: "Institute for Positive Psychology and Education",
)
#resume-entry(
  title: "Lecturer",
  location: "Australian Catholic University",
  date: "2015–2019",
  description: "School of Health and Behavioural Sciences",
)

= Accreditations

#resume-entry(
  title: "Senior Fellow, Higher Education Academy (SFHEA)",
  location: "AdvanceHE",
  date: "2020–Present",
  description: "",
)
#resume-entry(
  title: "Registered Psychologist",
  location: "AHPRA",
  date: "2012–Present",
  description: "",
)
#resume-entry(
  title: "Board Approved Supervisor",
  location: "AHPRA",
  date: "2015–Present",
  description: "",
)

= Awards

#award-entry("Alumni Excellence Award", "Emmanuel College, The University of Queensland", "2025")
#award-entry("Vice-Chancellor's Award for Excellence in Teaching", "Australian Catholic University", "2021")
#award-entry("Vice-Chancellor's Staff Excellence Award: Research & Research Partnership", "Australian Catholic University – iPLAY Team", "2021")
#award-entry("Excellence and Innovation in Public Health Education and Research (Team)", "CAPHIA – iPLAY Team", "2021")
#award-entry("Citation for Outstanding Contributions to Student Learning", "Australian Awards for University Teaching", "2020")
#award-entry("Best Presentation in Educational Technology", "CQUniversity", "2020")
#award-entry("Citations for Outstanding Contributions to Student Learning", "Australian Catholic University", "2019")
#award-entry("Citations (Early Career) for Outstanding Contributions to Student Learning", "Australian Catholic University", "2015")

// ── Dynamic Publications ──

= Publications (#str(metrics.n_pubs) total; #str(metrics.total_citations) citations; h-index: #str(metrics.h_index))

#for pub in pubs {
  pub-entry(pub)
}

= Research Grants

#grant-entry("AI Risk Index: Assessing influential organizations' responses to risks from AI", "Subaward with MIT", "2025–2027", [\$663,766])
#grant-entry("Seeing the Bigger Picture: Exploring Children's Screen Time", "NSW Dept of Education", "2025–2026", [\$341,307])
#grant-entry("Promotion of evidence-based physical activity for older adults and people with disabilities", "NHMRC (PRC1: 2011157)", "2022–2025", [\$1,440,375])
#grant-entry("Prototyping a co-designed effective altruism program", "Open Philanthropy", "2022–2023", [\$58,000])
#grant-entry("Effectiveness of school-based physical activity for adolescents with disability", "MRFF (2007095)", "2021–2023", [\$736,399])
#grant-entry("Meta-review of institutional decision-making", "EA Infrastructure Fund", "2021–2022", [\$39,654])
#grant-entry("Square eyes or all lies? Understanding children's exposure to screens", "ARC Discovery (DP200101912)", "2020–2023", [\$658,544])
#grant-entry("PLAY for Inclusion – Teachers working with children with intellectual disability", "Move It AUS", "2019–2020", [\$268,802])
#grant-entry("Engaging students during the early years of secondary school (iTEACH)", "ARC Discovery (DP160102625)", "2016–2020", [\$590,000])
#grant-entry("Other grants", "Sport Australia / NSW DoE / QAS", "2018–2019", [\$188,744])

= Media Coverage

#block(above: 1em, below: 0.6em)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(weight: "bold")[Screen use and socio-emotional problems],
    text[2025],
  )
  #text(size: 0.9em, fill: luma(80))[#link("https://www.msn.com/en-au/news/australia/researchers-warn-screen-time-fuels-behaviour-issues-in-vicious-cycle/vi-AA1GsWUt")[ABC News 24], #link("https://www.goodmorningamerica.com/wellness/story/increased-screen-time-linked-aggression-anxiety-low-esteem-122699364")[Good Morning America], #link("https://drive.google.com/file/d/1AXGr8wyFTwqphhSKTezwgE9LT8ms_M7w/view")[Nine News], #link("https://www.heraldsun.com.au/victoria-education/advice/screen-time-warning-the-bad-habit-driving-increasing-rates-of-childhood-anxiety-aggression/news-story/d5059e61cb9edd390b966f2ff33074f3")[National Newscorp]]
]

#block(above: 1em, below: 0.6em)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(weight: "bold")[Risks from advanced artificial intelligence],
    text[2024],
  )
  #text(size: 0.9em, fill: luma(80))[#link("https://news.uq.edu.au/2026-01-australias-ai-safety-gap-4000-times-bigger-you-think")[The Courier-Mail], #link("https://www.youtube.com/watch?v=sykH8buTxYY")[Ten News], #link("https://www.smartcompany.com.au/artificial-intelligence/aussies-concerned-ai-risk-government/")[SmartCompany], #link("https://theconversation.com/if-we-dont-control-the-ai-industry-it-could-end-up-controlling-us-warn-two-chilling-new-books-266067")[The Conversation], #link("https://theconversation.com/80-of-australians-think-ai-risk-is-a-global-priority-the-government-needs-to-step-up-225175")[The Conversation]]
]

#block(above: 1em, below: 0.6em)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(weight: "bold")[Exercise for depression],
    text[2024],
  )
  #text(size: 0.9em, fill: luma(80))[#link("https://bmj.altmetric.com/details/159533224/")[Altmetric: 95 news outlets, 1,500+ X posts, 15 YouTube creators, 5 Wikipedia pages]. #link("https://www.cnn.com/2024/02/14/health/exercise-treat-depression-wellness/index.html")[CNN], #link("https://www.goodmorningamerica.com/video/107264638")[Good Morning America], #link("https://www.youtube.com/watch?v=ClZOcT1wPWw")[PBS NewsHour], #link("https://www.thetimes.co.uk/article/d1236a53-6ab4-4f32-bc64-730823dbbfaf")[The Times], #link("https://www.abc.net.au/listen/programs/healthreport/how-good-is-exercise-for-depression/103521102")[ABC Radio], #link("https://www.theaustralian.com.au/nation/worlds-biggest-study-shows-exercise-can-be-five-times-as-effective-as-ssris/news-story/e1bb1699c0019674aa98047d1c431efa")[The Australian], #link("https://theconversation.com/running-or-yoga-can-help-beat-depression-research-shows-even-if-exercise-is-the-last-thing-you-feel-like-223441")[The Conversation], #link("https://natgeo.nikkeibp.co.jp//atcl/news/25/101700570/")[National Geographic]]
]

#block(above: 1em, below: 0.6em)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(weight: "bold")[Effective altruism],
    text[2021],
  )
  #text(size: 0.9em, fill: luma(80))[#link("https://www.abc.net.au/religion/the-case-for-effective-altruism/13359912")[ABC Religion & Ethics], #link("https://www.abc.net.au/news/2022-01-09/are-we-making-a-difference-when-we-donate-to-charity/100722158")[ABC Radio National], #link("https://theconversation.com/what-do-we-owe-future-generations-and-what-can-we-do-to-make-their-world-a-better-place-189591")[The Conversation]]
]

#block(above: 1em, below: 0.6em)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(weight: "bold")[Videos in higher education],
    text[2020],
  )
  #text(size: 0.9em, fill: luma(80))[#link("https://www.forbes.com/sites/nickmorrison/2021/02/17/students-get-better-grades-if-you-replace-their-teachers-with-videos/")[Forbes], #link("https://theconversation.com/videos-wont-kill-the-uni-lecture-but-they-will-improve-student-learning-and-their-marks-142282")[The Conversation]]
]


= Invited Talks & Government Briefings

#resume-item[
  - *Government briefings*: Indonesian Ministry of Communication and Digital Affairs (2026); Ministry of Education, Republic of China – Taiwan (2025); Australian Depts of Industry, Science and Resources (2025), Education (2025), and Health, Disability and Ageing (2024).
  - *Invited talks*: University of Pennsylvania, Master of Behavioral and Decision Sciences (2026); Universitas Indonesia (2025, 2026); EAGxAustralia keynotes/workshops (2019, 2022, 2023, 2025); Berkeley Effective Altruism (2022); HERDSA (2023); NASPSPA, Hawaii (2022); Prevention of Falls CRE (2022); Sports Medicine Australia (2020); AdvanceHE Teaching and Learning Conference (2021).
]

= Research Supervision

#resume-entry(
  title: "PhD Primary Supervisor",
  location: "",
  date: "2019–Present",
  description: "A. Ahmadi, R. Vasconcellos, S. Griffith, G. Swaryandini, G. Hassed, M. Veron",
)
#resume-entry(
  title: "PhD Associate Supervisor",
  location: "",
  date: "2021–Present",
  description: "B. Gibson, L. Hall, A. Urooj, E. Tremaine, D. Venini",
)
#resume-entry(
  title: "Honours Primary Supervisor",
  location: "",
  date: "2023–2026",
  description: "43 Honours students from 2023–2026",
)

= Service & Engagement

#resume-entry(
  title: "Program Director (Academic), Master of Psychology",
  location: "UQ School of Psychology",
  date: "2023–2026",
  description: "",
)
#resume-entry(
  title: "Director and Chairperson",
  location: "Effective Altruism Australia",
  date: "2021–Present",
  description: [Stewarding AU\$7.5M+/yr to cost-effective programs],
)
#resume-entry(
  title: "Co-Lead, AI and Digital Psychology Stream",
  location: link("https://psychologyevents.org.au/icp-2028/")[34th International Congress of Psychology],
  date: "2026–2028",
  description: "Scientific Committee",
)
#resume-entry(
  title: "Editorial Board Member",
  location: "Sport, Exercise and Performance Psychology (APA)",
  date: "2025–Present",
  description: "",
)
#resume-entry(
  title: "College of Sport and Exercise Psychologists",
  location: "Australian Psychological Society",
  date: "2015–2021",
  description: "National Treasurer (2015–2017; 2019–2021); NSW Chair (2015–2017); QLD Chair (2019–2021)",
)
