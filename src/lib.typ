#let meta = toml("template/info.toml")
#import meta.import.tabler_icons: *
#import meta.import.octicons: *
#import meta.import.fontawesome: *
#import meta.import.academicons: *

#let iconify(icon, ..attributes) = {
  let fetcher = (
    tabler: tabler-icon,
    octicon: octique,
    awesome: fa-icon,
    academicon: ai-icon,
  )

  for (name, fetch) in fetcher {
    let icon = fetch(icon)
    if not icon == none {
      return text(icon, ..attributes)
    }
  }
}
#let section-title-style(str, color, ..attributes) = {
  text(
    ..arguments(
      size: 12pt,
      weight: "bold",
      fill: rgb(color),
      ..attributes,
    ),
    str,
  )
}

#let name-block(
  header-name,
  color,
  ..attributes,
) = {
  text(
    ..arguments(
      fill: rgb(color),
      size: 30pt,
      weight: "extrabold",
      ..attributes,
    ),
    header-name,
  )
}

#let title-block(
  title,
  color,
  ..attributes,
) = {
  text(
    ..arguments(
      size: 12pt,
      style: "italic",
      fill: rgb(color),
      ..attributes,
    ),
    title,
  )
}

#let info-block-style(
  icon,
  txt,
  color,
  include-icons,
  ..attributes,
) = {
  text(
    ..arguments(
      size: 10pt,
      fill: rgb(color),
      weight: "medium",
      ..attributes,
    ),
    if include-icons {
      iconify(icon) + h(6pt) + txt
    } else {
      txt
    },
  )
}

#let info-value(val, ..attributes) = {
  if type(val) == str {
    text(
      ..attributes,
      val,
    )
  } else if type(val) == dictionary {
    link(..arguments(
      val.link,
      val.label,
      ..attributes,
    ))
  }
}

#let info-block(
  metadata,
  ..attributes,
) = {
  let info = metadata.personal.info
  let icons = metadata.personal.icon
  let color = metadata.layout.text.color.medium
  let include-icons = metadata.personal.include_icons
  table(
    ..arguments(
      columns: (auto, auto, auto, auto, auto),
      stroke: none,
      ..attributes,
    ),
    ..info.pairs().map(
      ((key, val)) => info-block-style(
        icons.at(key),
        info-value(val, ..attributes),
        color,
        include-icons,
        ..attributes,
      ),
    )
  )
}

#let make-info-table(
  metadata,
  ..attributes,
) = {
  let color = metadata.layout.text.color.medium
  let info = metadata.personal.info
  let icons = metadata.personal.icon
  let include-icons = metadata.personal.include_icons
  table(
    ..arguments(
      columns: 1fr,
      align: right,
      stroke: none,
      ..attributes,
    ),
    ..info.pairs().map(
      ((key, val)) => info-block-style(
        icons.at(key),
        info-value(val, ..attributes),
        color,
        include-icons,
        ..attributes,
      ),
    )
  )
}

#let header-table(
  metadata,
  ..attributes,
) = {
  let lang = metadata.personal.language
  let subtitle = metadata.language.at(lang).at("subtitle")
  table(
    ..arguments(
      columns: 1fr,
      inset: 0pt,
      stroke: none,
      row-gutter: 3mm,
      ..attributes,
    ),
    [#name-block(
      metadata.personal.first_name + " " + metadata.personal.last_name,
      metadata.layout.text.color.dark,
      ..attributes,
    )],
    [#title-block(
      subtitle,
      metadata.layout.text.color.dark,
      ..attributes,
    )],
    [#info-block(
      metadata,
      ..attributes,
    )],
  )
}

#let cover-header-table(
  metadata,
  ..attributes,
) = {
  let lang = metadata.personal.language
  let subtitle = metadata.language.at(lang).at("subtitle")
  table(
    ..arguments(
      columns: 1fr,
      inset: 0pt,
      stroke: none,
      row-gutter: 2mm,
      ..attributes,
    ),
    [#name-block(
      metadata.personal.first_name + " " + metadata.personal.last_name,
      metadata.layout.text.color.dark,
      ..attributes,
    )],
    [#title-block(
      subtitle,
      metadata.layout.text.color.dark,
      ..attributes,
    )],
  )
}

#let make-header-photo(
  photo,
  profile-photo,
  ..attributes,
) = {
  if profile-photo != false {
    box(
      ..arguments(
        clip: true,
        ..attributes,
      ),
      photo,
    )
  } else {
    box(..arguments(
      clip: true,
      ..attributes,
    ))
  }
}

#let cv-header(
  left-comp,
  right-comp,
  cols,
  align,
  ..attributes,
) = {
  table(
    ..arguments(
      columns: cols,
      inset: 0pt,
      stroke: none,
      column-gutter: 8pt,
      align: top,
      ..attributes,
    ),
    {
      left-comp
    },
    {
      right-comp
    }
  )
}

#let create-header(
  metadata,
  photo,
  use-photo: false,
  ..attributes,
) = {
  let header-width
  let photo-width
  if use-photo {
    header_width = 74%
    photo-width = 20%
  } else {
    header-width = 96%
    photo-width = 0%
  }
  cv-header(
    header-table(metadata, ..attributes),
    make-header-photo(photo, use-photo, ..attributes),
    (header-width, photo-width),
    left,
    ..attributes,
  )
}

#let create-cover-header(
  metadata,
  ..attributes,
) = {
  cv-header(
    cover-header-table(metadata, ..attributes),
    make-info-table(metadata, ..attributes),
    (65%, 34%),
    left,
    ..attributes,
  )
}

#let cv-section(title, ..attributes) = {
  let spacer = attributes.at("spacer", h(2pt))
  section-title-style(title, ..attributes)
  spacer
}

#let date-style(date, ..attributes) = (
table.cell(
  align: right,
  text(
    ..arguments(
      size: 9pt,
      weight: "bold",
      style: "italic",
      ..attributes,
    ),
    date,
  ),
)
)

#let company-name-style(company, ..attributes) = {
  table.cell(
    align: right,
    text(
      ..arguments(
        size: 9pt,
        weight: "bold",
        style: "italic",
        ..attributes,
      ),
      company,
    ),
  )
}

#let degree-style(degree, ..attributes) = (
text(
  ..arguments(
    weight: "bold",
    ..attributes,
  ),
  degree,
)
)

#let reference-name-style(name, ..attributes) = (
text(
  ..arguments(
    weight: "bold",
    ..attributes,
  ),
  name,
)
)

#let phonenumber-style(phone, ..attributes) = (
text(
  ..arguments(
    size: 9pt,
    style: "italic",
    weight: "medium",
    ..attributes,
  ),
  phone,
)
)

#let institution-style(institution) = (
table.cell(
  text(
    style: "italic",
    weight: "medium",
    institution,
  ),
)
)

#let location-style(location) = (
table.cell(
  text(
    style: "italic",
    weight: "medium",
    location,
  ),
)
)

#let email-style(email) = (
text(
  size: 9pt,
  style: "italic",
  weight: "medium",
  email,
)
)

#let tag-style(str) = {
  align(
    right,
    text(
      weight: "regular",
      str,
    ),
  )
}

#let tag-list-style(color, tags) = {
  for tag in tags {
    box(
      inset: (x: 0.4em),
      outset: (y: 0.3em),
      fill: rgb(color),
      radius: 1pt,
      tag-style(tag),
    )
    h(4pt)
  }
}

#let profile-entry(str) = {
  text(
    size: text-size,
    weight: "medium",
    str,
  )
}

#let reference-entry(
  name: "Name",
  title: "Title",
  company: "Company",
  telephone: "Telephone",
  email: "Email",
) = {
  table(
    columns: (3fr, 2fr),
    inset: 0pt,
    stroke: none,
    row-gutter: 2mm,
    [#reference-name-style(name)], [#company-name-style(company)],
    table.cell(colspan: 2)[#phonenumber-style(telephone), #email-style(email)],
  )
  v(2pt)
}

#let education-entry(
  degree: "Degree",
  date: "Date",
  institution: "Institution",
  location: "Location",
  description: "",
  highlights: (),
) = {
  table(
    columns: (3fr, 1fr),
    inset: 0pt,
    stroke: none,
    row-gutter: 2mm,
    [#degree-style(degree)],                                      [#date-style(date)],
    [#institution-style(institution), #location-style(location)],
  )
  v(2pt)
}

#let experience-entry(
  title: "Title",
  date: "Date",
  company: "Company",
  location: "Location",
  description: none,
  itemized: none,
) = {
  table(
    columns: (1fr, 1fr),
    inset: 0pt,
    stroke: none,
    row-gutter: 2mm,
    [#degree-style(title)], [#date-style(date)],
    table.cell(colspan: 2)[#institution-style(company),
    #location-style(location)],
    table.cell(colspan: 2)[#text(size: 10pt, description) #text(size: 9pt, itemized)]
  )
}

#let skill-style(skill) = {
  text(
    weight: "bold",
    skill,
  )
}

#let skill-tag(color, skill) = {
  box(
    inset: (x: 0.3em),
    outset: (y: 0.2em),
    fill: rgb(color),
    radius: 1pt,
    skill-style(skill),
  )
}

#let skill-entry(
  color,
  cols,
  align,
  skills: (),
) = {
  table(
    columns: if cols == true { (1fr, 1fr) } else { 1fr },
    inset: 0pt,
    stroke: none,
    row-gutter: 3mm,
    column-gutter: 3mm,
    align: align,
    ..skills.map(sk => skill-tag(color, sk))
  )
}
#let personality-style(trait) = {
  text(
    weight: "medium",
    emph(trait),
  )
}

#let personality-tag(color, trait) = {
  box(
    inset: (x: 0.3em),
    outset: (y: 0.2em),
    fill: rgb(color),
    radius: 1pt,
    personality-style(trait),
  )
}

#let personality-entry(
  color,
  cols,
  align,
  traits: (),
) = {
  table(
    columns: if cols == true { (1fr, 1fr) } else { 1fr },
    inset: 0pt,
    stroke: none,
    row-gutter: 3mm,
    column-gutter: 3mm,
    align: align,
    ..traits.map(hb => personality-tag(color, hb))
  )
}
#let hobby-style(hobby) = {
  text(
    weight: "bold",
    hobby,
  )
}

#let hobby-tag(color, hobby) = {
  box(
    inset: (x: 0.3em),
    outset: (y: 0.2em),
    fill: rgb(color),
    radius: 1pt,
    hobby-style(hobby),
  )
}

#let hobby-entry(
  color,
  cols,
  align,
  hobbies: (),
) = {
  table(
    columns: if cols == true { (1fr, 1fr) } else { 1fr },
    inset: 0pt,
    stroke: none,
    row-gutter: 3mm,
    column-gutter: 3mm,
    align: align,
    ..hobbies.map(hb => hobby-tag(color, hb))
  )
}

#let language-entry(
  color,
  entries: { },
) = {
  table(
    columns: (auto, auto),
    align: (left, right),
    inset: 0pt,
    stroke: none,
    ..entries.pairs().map(
      (language, proficiency) => table.cell(colspan: 2, [#box(
        fill: rgb(color),
        inset: (x: 0.3em),
        outset: (y: 0.2em),
        radius: 1pt,
        text(weight: "bold", language),
      )], [#box(
        fill: rgb(color),
        inset: (x: 0.3em),
        outset: (y: 0.2em),
        radius: 1pt,
        text(weight: "medium", proficiency),
      )]),
    )
  )
}

#let recipient-style(str) = {
  text(
    style: "italic",
    str,
  )
}

#let recipient-entry(
  name: "Name",
  title: "Title",
  company: "Company",
  address: "Address",
  city: "City",
) = {
  table(
    columns: 1fr,
    inset: 0pt,
    stroke: none,
    row-gutter: 2mm,
    align: left,
    recipient-style(name),
    recipient-style(title),
    recipient-style(company),
    recipient-style(address),
  )
}

#let create-panes(left, right, proportion) = {
  grid(
    columns: (proportion, 98% - proportion),
    column-gutter: 20pt,
    stack(
      spacing: 16pt,
      left,
    ),
    stack(
      spacing: 16pt,
      right,
    ),
  )
}

#let cv(
  metadata,
  photo: "",
  use-photo: false,
  left-pane: (),
  right-pane: (),
  left-pane-proportion: 72%,
  doc,
) = {
  set text(
    fill: rgb(metadata.layout.text.color.dark),
    font: metadata.layout.text.font,
    size: eval(metadata.layout.text.size),
  )
  set align(left)
  set page(
    fill: rgb(metadata.layout.fill_color),
    paper: metadata.layout.paper_size,
    margin: (
      left: 1.2cm,
      right: 1.2cm,
      top: 1.6cm,
      bottom: 1.2cm,
    ),
  )
  set list(marker: [‣])
  create-header(metadata, photo, use-photo: use-photo)
  create-panes(left-pane, right-pane, left-pane-proportion)
  doc
}

#let cover-letter(
  metadata,
  doc,
) = {
  set text(
    fill: rgb(metadata.layout.text.color.dark),
    font: metadata.layout.text.font,
    size: eval(metadata.layout.text.size),
  )
  set align(left)
  set page(
    fill: rgb(metadata.layout.fill_color),
    paper: metadata.layout.paper_size,
    margin: (
      left: 1.2cm,
      right: 1.2cm,
      top: 1.6cm,
      bottom: 1.2cm,
    ),
  )
  set list(marker: [‣])
  create-cover-header(metadata)
  doc
}
