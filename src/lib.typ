#let meta = toml("template/info.toml")
#import meta.import.tabler_icons: *
#import meta.import.octicons: *
#import meta.import.fontawesome: *
#import meta.import.academicons: *

#let iconify(icon, ..attributes) = {

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
    ..arguments(size: 12pt, style: "italic", fill: rgb(color), ..attributes),
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
      fa-icon(icon) + h(10pt) + txt
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
      columns: (1fr, 1fr),
      stroke: none,
      ..attributes,
    ),
    ..info.pairs().map(((key, val)) => info-block-style(
      icons.at(key),
      info-value(val, ..attributes),
      color,
      include-icons,
      ..attributes,
    ))
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
    ..info.pairs().map(((key, val)) => info-block-style(
      icons.at(key),
      info-value(val, ..attributes),
      color,
      include-icons,
      ..attributes,
    ))
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
      row-gutter: 4mm,
      ..attributes,
    ),
    [#name-block(
      metadata.personal.first_name + " " +
      metadata.personal.last_name,
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
      row-gutter: 4mm,
      ..attributes,
    ),
    [#name-block(
      metadata.personal.first_name + " " +
      metadata.personal.last_name,
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
        radius: 50%,
        ..attributes,
      ),
      photo,
    )
  } else {
    box(..arguments(
      clip: true,
      stroke: 5pt + yellow,
      radius: 50%,
      fill: yellow,
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
      column-gutter: 10pt,
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
  cv-header(
    header-table(metadata, ..attributes),
    make-header-photo(photo, use-photo, ..attributes),
    (74%, 20%),
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
  let spacer = attributes.at("spacer", h(4pt))
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
      radius: 3pt,
      tag-style(tag),
    )
    h(5pt)
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
    row-gutter: 3mm,
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
    row-gutter: 3mm,
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
) = {
  table(
    columns: (1fr, 1fr),
    inset: 0pt,
    stroke: none,
    row-gutter: 3mm,
    [#degree-style(title)], [#date-style(date)],
    table.cell(colspan: 2)[#institution-style(company), #location-style(location)],
  )
  v(5pt)
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
    radius: 3pt,
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

#let language-entry(
  language: "Language",
  proficiency: "Proficiency",
) = {
  table(
    columns: (1fr, 1fr),
    inset: 0pt,
    stroke: none,
    row-gutter: 3mm,
    align: left,
    table.cell(
      text(
        weight: "bold",
        language,
      ),
    ), table.cell(
      align: right,
      text(
        weight: "medium",
        proficiency,
      ),
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
    row-gutter: 3mm,
    align: left,
    recipient-style(name),
    recipient-style(title),
    recipient-style(company),
    recipient-style(address),
  )
}

#let create-panes(left, right, proportion) = {
  grid(
    columns: (proportion, 96% - proportion),
    column-gutter: 20pt,
    stack(
      spacing: 20pt,
      left,
    ),
    stack(
      spacing: 20pt,
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
  left-pane-proportion: 71%,
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
