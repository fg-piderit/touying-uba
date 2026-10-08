#import "@preview/touying:0.7.3": *

/* Slide -------------------------------------------------------------------- */
#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  if title != auto {
    self.store.title = title
  }

  let header(self) = {
    set align(top)
    set text(style: "italic", weight: "bold", fill: self.colors.primary)
    grid(
      columns: (1fr, auto),
      rows: 100%,
      fill: (self.colors.primary-lightest, self.colors.primary),
      align: (horizon + left, horizon + right),
      inset: (x: 2em),
      if self.store.title != none {
        utils.call-or-display(self, self.store.title)
      } else {
        utils.display-current-heading(level: 2)
      },
      image("svg/logo_sociales_b.svg", height: 0.75em)
    )
  }

  let footer(self) = {
    set align(bottom)
    stack(
      dir: ttb,
      components.progress-bar(
        height: 100%,
        self.colors.secondary,
        self.colors.secondary-light,
      ),
      {
        show: block.with(
          width: 100%,
          height: 90%,
          above: 0pt,
          below: 0pt,
          inset: (x: 2em),
          breakable: false,
          fill: self.colors.primary,
        )
        set align(horizon)
        set text(fill: self.colors.neutral-lightest, size: .8em)
        utils.display-current-heading(level: 1)
        h(1fr)
        context utils.slide-counter.display() + " de " + utils.last-slide-number
      },
    )
  }

  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer
    ),
  )

  let new-setting = body => {
    set align(horizon)
    body
  }

  touying-slide(self: self, setting: new-setting, ..args)
})

/* Title slide -------------------------------------------------------------- */
#let title-slide(..args) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  let header = {
    set text(size: 0.9em)
    grid(
      columns: (auto, 1fr),
      rows: 100%,
      fill: (self.colors.primary, self.colors.primary-light),
      inset: (x: 2em),
      align: (horizon, horizon),
      text(fill: self.colors.neutral-lightest, style: "italic", utils.display-info-date(self)),
      text(fill: self.colors.primary, [~]),
    )
  }
  let footer = grid(
    columns: (1fr, 1fr),
    rows: 100%,
    fill: self.colors.secondary,
    align: (horizon + center, horizon),
    image("svg/logo_sociales_ba.svg", height: 45%),
    image("svg/sep_triangulos_pres_3s4.svg", height: 100%)
  )
  let body = {
    block(
      width: 100%,
      height: auto,
      inset: (y: 2em, x: 2em),
      fill: self.colors.primary-lightest,
      {
        set text(fill: self.colors.primary)
        set align(horizon)
        text(size: 1.75em, weight: "black", info.title)
        if info.subtitle != none {
          linebreak()
          text(size: 1.25em, weight: "bold", info.subtitle)
        }
      }
    )

    set text(fill: self.colors.neutral-darkest, size: 0.9em)
    show: block.with(
      width: 100%,
      above: 2em,
      inset: (x: 2em)
    )
    grid(
      columns: (1fr, 1fr),
      {
        if info.author != none { block(info.author) }
        if info.contact != none { block(info.contact) }
      },
      {
        if info.tipo-materia != none {
          block[
            #text(weight: "bold", info.tipo-materia)
            #linebreak()
            #if info.nombre-materia != none { info.nombre-materia}
          ]
        }
        if info.titular != none {
          block[
            #text(weight: "bold")[Titular de cátedra]
            #linebreak()
            #info.titular
          ]
        }
      }
    )
  }

  self = utils.merge-dicts(
    self,
    config-page(
      margin: (y: 2.5em, x: 0em),
      header-ascent: 0pt,
      footer-descent: 0pt,
      header: header,
      footer: footer,
    ),
  )

  touying-slide(self: self, body)
})

/* Section slide ------------------------------------------------------------ */
#let new-section-slide(self: none, body) = touying-slide-wrapper(self => {
  let main-body = {
    set align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em)

    stack(
      dir: ttb,
      spacing: 1em,
      text(weight: "black", fill: self.colors.primary,
        utils.display-current-heading(level: 1, numbered: false)),
      block(
        height: 3pt,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(
          height: 3pt,
          self.colors.secondary,
          self.colors.secondary-light,
        ),
      ),
    )
  }

  touying-slide(self: self, main-body)
})

/* Focus slide -------------------------------------------------------------- */
#let focus-slide(self: none, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.primary,
      margin: 2em,
    ),
  )
  set text(fill: self.colors.neutral-lightest, size: 2em)

  touying-slide(self: self, align(horizon + center, body))
})

/* Outline slide ------------------------------------------------------------ */
#let outline-slide(title: [Contenidos], depth: 2, ..args) = touying-slide-wrapper(self => {
  let info = self.info + args.named()

  let main-body = {
    set align(horizon)
    show: pad.with(10%)

    if title != none {
      block(
        height: 2em,
        width: 100%,
        stroke: (bottom: 3pt + self.colors.secondary),
        text(size: 1.5em, weight: "black", fill: self.colors.primary, title),
      )
    }

    outline(title: none, depth: depth)
  }

  touying-slide(self: self, main-body)
})

/* Register ----------------------------------------------------------------- */
#let uba-slides(
  aspect-ratio: "16-9",
  footer: none,
  ..args,
  body,
) = {
  set text(size: 20pt, font: "Bitter Pro", number-type: "old-style")
  show heading.where(level: 1): set heading(numbering: "1.1.")
  show raw.where(block: true): it => block(width: 100%, stroke: black, inset: 1em, it)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 3.5em, bottom: 2em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-colors(
      primary: rgb("#1D2554"),
      primary-light: rgb("#91BDE0"),
      primary-lightest: rgb("#BBD7ED"),
      secondary: rgb("#3BC3AD"),
      secondary-light: rgb("#A6E4DA"),
      neutral-darkest: rgb("#000000"),
      neutral-lightest: rgb("#ffffff"),
    ),
    config-methods(
      alert: (self: none, it) => text(fill: self.colors.secondary, it)
    ),
    config-store(
      title: none,
      footer: footer,
    ),
    ..args,
  )

  body
}
