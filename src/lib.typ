#import "lib/settings.typ" as settings
#import "lib/pages.typ" as pages
#import "lib/util.typ" as util
#import "lib/abbr.typ" as abbr
#import "lib/global.typ" as global
#import "lib/bubble.typ" as bubble
#import "lib/validate.typ": validate
#import "lib/font.typ": check-missing-fonts
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#let author = util.author
#let fspace = util.fspace
#let code = util.code
#let code-file = util.code-file

#let short = abbr.short
#let shortpl = abbr.shortpl
#let long = abbr.long
#let longpl = abbr.longpl

#let todo = bubble.todo
#let info = bubble.info
#let warn = bubble.warn

// TODO: fix bug with page counter not updating correctly after body
#let diplomarbeit(
  title: none,
  subtitle: none,
  department: none,
  school-year: none,
  authors: none,
  supervisor-incl-ac-degree: none,
  sponsors: none,
  date: none,
  abstract-german: none,
  abstract-english: none,
  generative-ai-clause: [Es wurden keine Hilfsmittel generativer KI-Tools für die Erstellung der Arbeit verwendet.],
  abbreviation: none,
  bibliography: none,
  print-ref: true,
  disable-cover: false,
  body,
) = context {
  // validate fonts
  let missing-fonts = check-missing-fonts()
  if missing-fonts.len() != 0 {
    panic(
      "The following fonts couldn't be found on the system: "
        + missing-fonts.map(it => "'" + it + "'").join(", ", last: " and ")
        + "! "
        + "You may be able to download them from Google Fonts (https://fonts.google.com/).",
    )
  }

  // validate arguments
  if not disable-cover {
    validate("title", title)
    validate("subtitle", subtitle)
    validate("department", department)
    validate("school-year", school-year)
    validate("authors", authors)
    validate("supervisor-incl-ac-degree", supervisor-incl-ac-degree)
    validate("sponsors", sponsors)
    validate("date", date)
    validate("abstract-german", abstract-german)
    validate("abstract-english", abstract-english)
    validate("generative-ai-clause", generative-ai-clause)
    validate("abbreviation", abbreviation)
    validate("bibliography", bibliography)
    validate("print-ref", print-ref)
    validate("disable-cover", disable-cover)
  }

  // state
  global.abbr.update(abbreviation)

  // document
  set footnote(numbering: "[1]")
  set footnote.entry(
    clearance: 0cm,
    indent: 0em,
    separator: move(dy: 0.8cm, line(length: 30% + 0pt, stroke: 0.5pt)),
  )
  show footnote.entry: set text(size: settings.FONT_SIZE_FOOTNOTE)
  show footnote.entry: set par(hanging-indent: 1em, justify: true)
  show footnote.entry: it => {
    move(dy: 0.8cm, it)
  }
  show: codly-init.with()
  codly(
    display-icon: false,
    zebra-fill: none,
    number-align: left + top,
    lang-format: none,
    breakable: true,
    header-cell-args: (align: left, fill: luma(240)),
    header-repeat: true,
  )
  set document(
    title: title,
    author: if disable-cover and authors == none { () } else {
      authors.map(v => v.name)
    },
  )
  show heading: h => {
    set text(
      font: settings.FONT_TEXT_DISPLAY,
      size: settings.HEADING_SIZES.at(h.level - 1).size,
    )
    if h.level == 1 {
      pagebreak(weak: true)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: "code")).update(0)
    }
    v(settings.HEADING_SIZES.at(h.level - 1).top)
    h
    v(settings.HEADING_SIZES.at(h.level - 1).bottom)
  }
  set par(justify: true)
  show raw: set text(font: settings.FONT_TEXT_RAW)
  set text(
    font: settings.FONT_TEXT_BODY,
    size: settings.FONT_SIZE,
    lang: "de",
  )
  set figure(
    numbering: (..num) => numbering(
      "1.1",
      counter(heading).get().first(),
      num.pos().first(),
    ),
  )
  show figure: set block(breakable: true)
  // show link: underline
  if not disable-cover {
    set page(
      paper: "a4",
      margin: (
        top: settings.PAGE_MARGIN_VERTICAL,
        bottom: settings.PAGE_MARGIN_VERTICAL,
        inside: settings.PAGE_MARGIN_OUTER,
        outside: settings.PAGE_MARGIN_OUTER,
      ),
    )
    pages.cover.create-page(
      title: title,
      subtitle: subtitle,
      department: department,
      school-year: school-year,
      authors: authors,
      date: date,
    )
    util.insert-blank-page()
  }
  set page(
    paper: "a4",
    margin: (
      top: settings.PAGE_MARGIN_VERTICAL,
      bottom: settings.PAGE_MARGIN_VERTICAL,
      inside: if disable-cover { settings.PAGE_MARGIN_OUTER } else {
        settings.PAGE_MARGIN_OUTER
      },
      outside: settings.PAGE_MARGIN_OUTER,
    ),
  )
  set page(
    header-ascent: 1cm,
    header: context {
      counter(footnote).update(0)
      let page-number = here().page()
      let after = query(heading.where(level: 1).after(here()))
      let before-l1 = query(heading.where(level: 1).before(here()))
      let before-l2 = query(heading.where(level: 2).before(here()))
      let before = (..before-l1, ..before-l2).sorted(
        key: it => it.location().page(),
      )
      let reference = none
      if after.len() > 0 and after.first().location().page() == page-number {
        reference = after.first()
      } else if before.len() > 0 {
        reference = before.last()
      }

      let current = box(height: 28pt, align(left + horizon, reference.body))
      if calc.odd(page-number) or disable-cover {
        [#current #h(1fr) #box(
            height: 28pt,
            image("lib/assets/htl3r-logo.svg"),
          )]
      } else {
        [#box(
            height: 28pt,
            image("lib/assets/htl3r-logo.svg"),
          ) #h(1fr) #current]
      }
      v(-5pt)
      line(length: 100%, stroke: 0.5pt)
    },
    footer-descent: 1cm,
    footer: context {
      let counter = counter(page)
      let is-odd = calc.odd(counter.at(here()).first())
      let aln = if is-odd {
        right
      } else {
        left
      }
      line(length: 100%, stroke: 0.5pt)
      v(-5pt)
      [#align(aln)[#counter.display("i")]]
    },
  )
  show page: p => {
    let i = counter(page).at(here()).first()
    let is-odd = calc.odd(i)
    set page(binding: if is-odd { right } else { left })
  }
  if not disable-cover {
    pages.abstract.create-page(abstract-german, abstract-english)
    util.insert-blank-page()
    pages.preamble.create-page(supervisor-incl-ac-degree, sponsors)
    util.insert-blank-page()
    pages.sworn-statement.create-page(authors, date, generative-ai-clause)
    util.insert-blank-page()
    pages.create-tables()
    util.insert-blank-page()
  }
  counter(page).update(1)
  set page(
    footer: context {
      let page-text = counter(page).display("1")
      let is-odd = calc.odd(counter(page).get().first())
      let author = global.author.get()
      line(length: 100%, stroke: 0.5pt)
      v(-5pt)
      if is-odd or disable-cover [
        #if author != none [
          Autor: #author
        ]
        #h(1fr)
        #page-text
      ] else [
        #page-text
        #h(1fr)
        #if author != none [
          Autor: #author
        ]
      ]
    },
  )
  set heading(numbering: "1.1")
  body
  if not disable-cover {
    util.insert-blank-page()
    set heading(numbering: none)
    if abbreviation != none {
      pages.abbreviation.create-page()
      util.insert-blank-page()
      pages.glossary.create-page()
      util.insert-blank-page()
    }
    if bibliography != none {
      pages.bibliography.create-page(bibliography: bibliography)
      util.insert-blank-page()
    }
  }
  if print-ref {
    pages.printref.create-page()
  } else if not disable-cover {
    util.blank-page()
  }
}
