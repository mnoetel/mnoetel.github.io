---
layout: base
title: "Michael Noetel PhD"
css:
  - /assets/css/custom-styles.css # Use the streamlined CSS below
ext-css:
  - //fonts.googleapis.com/css?family=Roboto:400,700 # Kept Roboto as it's used in streamlined CSS
  - //fonts.googleapis.com/css?family=Open+Sans # Added Open Sans as it's used in streamlined CSS
# Removed particles.js as its CSS/JS seemed unused in the core content
---

<style>
  /* force header text colour */
  #header-inner h1, #header-inner h2, #header-inner h3, #header-inner h4{
    color:#053C45 !important;
  }

  /* Style for publication list to remove default bullets/numbers */
  .publication-list {
    list-style-type: none;
    padding-left: 0;
  }
  .publication-list li {
    margin-bottom: 0.8rem; /* Add some space between items */
    padding-left: 1.2rem; /* Indent text slightly */
    position: relative;
  }
   /* Optional: Add a custom marker if desired */
  .publication-list li::before {
    content: "\f02d"; /* FontAwesome book icon, adjust as needed */
    font-family: "Font Awesome 5 Free"; /* Ensure you load FontAwesome */
    font-weight: 900;
    position: absolute;
    left: 0;
    top: 0.1em; /* Adjust vertical alignment */
    color: #0C869B; /* Teal color */
  }

</style>

<div id="header" class="cut1" style="background:#FFFFFF; color:#053C45;">
  <div id="header-inner" markdown="1">
    # Michael Noetel {#title}
    ## Associate Professor, The University of Queensland {#subtitle}
    #### Psychology & AI Governance {#sub-subtitle}
  </div>
</div>

<div id="main-sections">

  <div id="about-out" class="page-section grey-section cut2">
    <div id="about" class="content-container">
      <h2 class="section-title"><span class="fa fa-user-circle"></span> About</h2>
      
      <div class="layout-text-image">
        <div class="layout-text">
          <p>I’m an academic working at the intersection of <strong>psychology, evidence synthesis, and AI governance</strong>. My mission is to reduce the worst risks from advanced AI and help people do the most good they can.</p>
          <ul class="fa-ul">
            <li><span class="fa-li fa fa-bullseye"></span><strong>Research & policy:</strong> Track record of <a href = "https://www.scopus.com/authid/detail.uri?authorId=57190857713">highly cited research</a> that influences policy; expert in systematic reviews, meta-analyses, and Delphi studies.</li>
            <li><span class="fa-li fa fa-chalkboard-teacher"></span><strong>Teaching & mentorship:</strong> 3,000+ learners including 50+ postgraduate researchers, eight teaching awards, average rating 4.8 / 5.</li>
            <li><span class="fa-li fa fa-globe"></span><strong>Impact:</strong> Chair and Director of <a href = "https://eaa.org.au">Effective Altruism Australia</a>, Cited in Australia’s <em>Safe & Responsible AI</em> report, the 2024 <em>International AI Safety Report</em>, and WHO guidelines.</li>
          </ul>
          <p>Originally from Sydney but fell in love with a Queenslander. Proud dad of three gorgeous boys.</p>
        </div>
        <div class="layout-image">
          <img src="/assets/img/your-profile-photo.jpg" alt="Michael Noetel headshot or relevant image">
        </div>
      </div>

    </div>
  </div>

  <div id="ai-out" class="page-section cut2">
    <div id="ai" class="content-container">
      <h2 class="section-title"><span class="fa fa-shield-alt"></span> AI Governance Highlights</h2>

      <table class="responsive-table ai-table">
        <tr>
          <td style="vertical-align:top;">
            <h3><span class="fa fa-poll-h"></span> <a href="https://stories.uq.edu.au/contact-magazine/80-per-cent-of-australians-think-ai-risk-is-a-global-priority/index.html" target="_blank">SARA Survey</a></h3>
            <p>Largest survey of Australian attitudes to AI risks (cited in <em>Safe & Responsible AI</em>).</p>
          </td>
          <td style="vertical-align:top;">
            <h3><span class="fa fa-database"></span> <a href="https://airisk.mit.edu/" target="_blank">AI Risk Repository</a></h3>
            <p>Open catalogue of risks from AI. Presented at Paris AI Action Summit and cited in the 2024 <em>International AI Safety Report</em>.</p>
          </td>
          <td style="vertical-align:top;">
             <h3><span class="fa fa-university"></span> Affiliations</h3>
             <ul class="fa-ul">
               <li><span class="fa-li fa fa-award"></span>Faculty Member, <strong>FLI AI Existential Safety Community</strong></li>
               <li><span class="fa-li fa fa-university"></span>Affiliate Researcher, <strong>MIT FutureTech</strong></li>
               <li><span class="fa-li fa fa-user-graduate"></span>Facilitator, <strong>AGI Safety Governance Fundamentals</strong></li>
             </ul>
          </td>
        </tr>
      </table>
    </div>
  </div>

  <div class="cut-buffer"></div>

  <div id="skills-out" class="page-section grey-section cut2">
    <div id="skills" class="content-container">
      <h2 class="section-title"><span class="fa fa-toolbox"></span> Core Skills</h2>
      <ul class="fa-ul">
        <li><span class="fa-li fa fa-layer-group"></span><strong>Evidence synthesis:</strong> systematic reviews, network meta‑analysis, rapid reviews</li>
        <li><span class="fa-li fa fa-code"></span><strong>Data & tooling:</strong> R, tidyverse, R Markdown, GitHub, OSF</li>
        <li><span class="fa-li fa fa-project-diagram"></span><strong>Project leadership:</strong> Agile, Scrum, Asana — CI on AU$3.7M competitive grants</li>
        <li><span class="fa-li fa fa-hand-holding-usd"></span><strong>Non‑profit governance:</strong> Chair, Effective Altruism Australia (AU$6M granted annually)</li>
        <li><span class="fa-li fa fa-bullhorn"></span><strong>Science communication:</strong> policy briefs, explainer videos, tier‑1 media</li>
        <li><span class="fa-li fa fa-chalkboard"></span><strong>Pedagogy:</strong> instructional design, online learning at scale</li>
      </ul>
    </div>
  </div>

  <div class="cut-buffer"></div>

  <div id="publications-out" class="page-section grey-section cut2">
    <div id="publications" class="content-container">
      <h2 class="section-title"><span class="fa fa-book-open"></span> Selected Publications</h2>
      <ul class="publication-list">
        <li><strong>Noetel M.</strong> et al. (2024). <a href="https://www.bmj.com/content/384/bmj-2023-075847" target="_blank"><em>Effect of exercise for depression: systematic review & network meta‑analysis</em>. <em>BMJ</em>.</a></li>
        <li>Sanders T., <strong>Noetel M.</strong> et al. (2024). <a href="https://www.nature.com/articles/s41562-023-01712-8" target="_blank"><em>Benefits & risks of youth screen use</em>. <em>Nature Human Behaviour</em>.</a></li>
        <li><strong>Noetel M.</strong> et al. (2023). <a href="https://link.springer.com/article/10.1007/s10648-023-09786-6" target="_blank"><em>Prediction vs explanation in educational psychology</em>. <em>Educational Psychology Review</em>.</a></li>
        <li><strong>Noetel M.</strong> et al. (2022). <a href="https://journals.sagepub.com/doi/10.3102/00346543211052329" target="_blank"><em>Multimedia design for learning</em>. <em>Review of Educational Research</em>.</a></li>
        <li><strong>Noetel M.</strong> et al. (2021). <a href="https://journals.sagepub.com/doi/10.3102/0034654321990713" target="_blank"><em>Video improves learning in higher education</em>. <em>Review of Educational Research</em>.</a></li>
       </ul>
     </div>
   </div>

   <div class="cut-buffer"></div>

   <div id="media-out" class="page-section">
     <div id="media" class="content-container">
       <h2 class="section-title"><span class="fa fa-tv"></span> Media & Talks</h2>

       <p style="text-align: center; line-height: 1.8;">
         My research and views have been featured in various media outlets, including:
         <a href="https://www.cnn.com/2024/02/14/health/exercise-treat-depression-wellness/index.html" target="_blank">CNN</a>,
         BBC,
         <a href="https://www.thetimes.co.uk/article/d1236a53-6ab4-4f32-bc64-730823dbbfaf" target="_blank">The Times</a>,
         Good Morning America,
         <a href="https://www.theaustralian.com.au/nation/worlds-biggest-study-shows-exercise-can-be-five-times-as-effective-as-ssris/news-story/e1bb1699c0019674aa98047d1c431efa" target="_blank">The Australian</a>,
         <a href="https://theconversation.com/running-or-yoga-can-help-beat-depression-research-shows-even-if-exercise-is-the-last-thing-you-feel-like-223441" target="_blank">The Conversation</a> (Exercise),
         <a href="https://www.abc.net.au/listen/programs/healthreport/how-good-is-exercise-for-depression/103521102" target="_blank">ABC Radio National</a> (Exercise),
         <a href="https://www.abc.net.au/religion/the-case-for-effective-altruism/13359912" target="_blank">ABC Religion & Ethics</a> (EA),
         <a href="https://www.abc.net.au/news/2022-01-09/are-we-making-a-difference-when-we-donate-to-charity/100722158" target="_blank">ABC Radio National</a> (EA),
         <a href="https://www.forbes.com/sites/nickmorrison/2021/02/17/students-get-better-grades-if-you-replace-their-teachers-with-videos/?sh=3f5256385079" target="_blank">Forbes</a> (Education), and
         <a href="https://theconversation.com/videos-wont-kill-the-uni-lecture-but-they-will-improve-student-learning-and-their-marks-142282" target="_blank">The Conversation</a> (Education).
         <br>I also brief policymakers and present at conferences. My YouTube channel <a href = "https://www.youtube.com/@noetel">@noetel</a> covers evidence-based teaching.
       </p>
     </div>
   </div>

</div>
