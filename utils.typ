#import "@preview/tablem:0.3.0": tablem

#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)

#let lengthceil(len, unit: 字号.小四) = calc.ceil(len / unit) * unit
#let partcounter = counter("part")
#let chaptercounter = counter("chapter")
#let appendixcounter = counter("appendix")
#let footnotecounter = counter(footnote)
#let rawcounter = counter(figure.where(kind: "code"))
#let imagecounter = counter(figure.where(kind: image))
#let tablecounter = counter(figure.where(kind: table))
#let equationcounter = counter(math.equation)
#let appendix() = {
  appendixcounter.update(50)
  chaptercounter.update(0)
  counter(heading).update(0)
}
#let skippedstate = state("skipped", false)

#let chinesenumber(num, standalone: false) = if num < 11 {
  ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
  if calc.rem(num, 10) == 0 {
    chinesenumber(calc.floor(num / 10)) + "十"
  } else if num < 20 and standalone {
    "十" + chinesenumber(calc.rem(num, 10))
  } else {
    chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.rem(num, 10))
  }
} else if num < 1000 {
  let left = chinesenumber(calc.floor(num / 100)) + "百"
  if calc.rem(num, 100) == 0 {
    left
  } else if calc.rem(num, 100) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 100))
  } else {
    left + chinesenumber(calc.rem(num, 100))
  }
} else {
  let left = chinesenumber(calc.floor(num / 1000)) + "千"
  if calc.rem(num, 1000) == 0 {
    left
  } else if calc.rem(num, 1000) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else if calc.rem(num, 1000) < 100 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else {
    left + chinesenumber(calc.rem(num, 1000))
  }
}

#let chinesenumbering(..nums, location: none, brackets: false) = context {
  let actual_loc = if location == none { here() } else { location }
  if appendixcounter.at(actual_loc).first() < 50 {
    if nums.pos().len() == 1 {
      "第" + [#nums.pos().first()] + "章"
    } else {
      numbering(if brackets { "(1.1)" } else { "1.1" }, ..nums)
    }
  } else {
    if nums.pos().len() == 1 {
      "附录 " + numbering("A.1", ..nums)
    } else {
      numbering(if brackets { "(A.1)" } else { "A.1" }, ..nums)
    }
  }
}

#let chineseunderline(s, width: 300pt, bold: false) = {
  let chars = s.clusters()
  let n = chars.len()
  style(styles => {
    let i = 0
    let now = ""
    let ret = ()

    while i < n {
      let c = chars.at(i)
      let nxt = now + c

      if measure(nxt, styles).width > width or c == "\n" {
        if bold {
          ret.push(strong(now))
        } else {
          ret.push(now)
        }
        ret.push(v(-1em))
        ret.push(line(length: 100%))
        if c == "\n" {
          now = ""
        } else {
          now = c
        }
      } else {
        now = nxt
      }

      i = i + 1
    }

    if now.len() > 0 {
      if bold {
        ret.push(strong(now))
      } else {
        ret.push(now)
      }
      ret.push(v(-0.9em))
      ret.push(line(length: 100%))
    }

    ret.join()
  })
}

#let chineseoutline(title: "目　　录", depth: none, indent: false) = {
  heading(title, numbering: none, outlined: false)
  context{
    let it = here()
    let elements = query(heading.where(outlined: true).after(it))

    for el in elements {
      // Skip list of images and list of tables
      if partcounter.at(el.location()).first() < 20 and el.numbering == none { continue }

      // Skip headings that are too deep
      if depth != none and el.level > depth { continue }

      let maybe_number = if el.numbering != none {
        if el.numbering == chinesenumbering {
          chinesenumbering(..counter(heading).at(el.location()), location: el.location())
        } else {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        }
        h(0.5em)
      }

      let line = {
        if indent {
          h(1em * (el.level - 1 ))
        }

        if el.level == 1 {
          v(0.5em, weak: true)
        }

        if maybe_number != none {
          //style(styles => {
          //  let width = measure(maybe_number, styles).width
            box(
              width: auto,//lengthceil(width),
              link(el.location(), if el.level == 1 {
                strong(maybe_number)
              } else {
                maybe_number
              })
            )
          //})
        }

        link(el.location(), if el.level == 1 {
          strong(el.body)
        } else {
          el.body
        })

        // Filler dots
        // if el.level == 1 {
        //   box(width: 1fr, h(10pt) + box(width: 1fr) + h(10pt))
        // } else {
           box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))
        // }

        // Page number
        let footer = query(selector(<__footer__>).after(el.location()))
        let page_number = if footer == () {
          0
        } else {
          counter(page).at(footer.first().location()).first()
        }
        
        link(el.location(), if el.level == 1 {
          strong(str(page_number))
        } else {
          str(page_number)
        })

        linebreak()
        v(-0.2em)
      }

      line
    }
  }
}

#let listoffigures(title: "插图清单", kind: image) = {
  heading(title, numbering: none, outlined: true)
  context{
    let it = here()
    let elements = query(figure.where(kind: kind).after(it))
    set par(spacing: 12pt)

    for el in elements {
      let maybe_number = {
        let el_loc = el.location()
        if kind == image {
          [图]
        } else if kind == table {
          [表]
        } else if kind == "code" {
          [代码]
        }
        chinesenumbering(chaptercounter.at(el_loc).first(), counter(figure.where(kind: kind)).at(el_loc).first(), location: el_loc)
        h(0.5em)
      }
      let line = {
        //style(styles => {
        //let width = measure(maybe_number, styles).width
          box(
            width: auto,//lengthceil(width),
            link(el.location(), maybe_number)
        //  )}
        )

        link(el.location(), el.caption.body)

        // Filler dots
        box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

        // Page number
        let footers = query(selector(<__footer__>).after(el.location()))
        let page_number = if footers == () {
          0
        } else {
          counter(page).at(footers.first().location()).first()
        }
        link(el.location(), str(page_number))
        linebreak()
        v(-0.2em)
      }

      line
    }
  }
}



#let scatterChars(str, width: none) = {
  set align(left)
  if width == none{
    str
  } else {
    box(
    width: width,
    stack(
      dir: ltr,
      ..str.clusters().map(x => [#x]).intersperse(1fr),
    ),
  )
  }
}

#let default-tupian-caption = highlight(
  fill:black, 
  radius:1pt, 
  extent: 3pt, 
  top-edge: 1.2em, 
  bottom-edge: -0.5em, 
  text(white)[*`未命名图片`*]
)

#let tupian(body: image("/assets/tupianHint.png"), width:70%, caption: default-tupian-caption, description: none, label: none)={  
  align(center)[
    #block(breakable: false)[
      #set image(width: width)
      #if body == none { body = image("/assets/tupianHint.png")}
      #figure(
        body,
        caption: caption
      ) #label
      #if description != none{
        v(-12pt)
        set align(left)
        set par(justify: true)
        text(10.5pt)[#description]
        v(12pt)
      }
    ]
  ]
}




// 可以自动显示续表题的三线表
#let three-line-table = tablem.with(
  render: (caption, columns: auto, headline,..cells) => {
    [
      #let firstHeader = state("fh",true)//标记是否是第一个表头的状态
      #table(
        columns: columns,
        column-gutter: 1.5em,
        inset: (
          x: 1em,
          y: 0.6em,
        ),
        stroke: none,
        align: center + horizon,
        table.hline(y: 1, stroke: 1.5pt),
        table.hline(y: 2, stroke: 1pt),
        table.header(
          // 自动“续表”的实现方式：利用表格的header跨页会重复显示的特性，不显示原有figure默认的caption，而是手动把它放到表格的header中表头的上一行（合并一整行），再根据是否首次显示判定是“表”还是“续表”
          table.cell(colspan: columns,[
            #set text(11pt)
            #context{
              if firstHeader.get(){
                [表]
                firstHeader.update(false)
              }else{
                [续表]
              }
              let loc = query(selector(figure.where(kind:table)).before(here())).last().location()
              chinesenumbering(chaptercounter.at(loc).first(),
              counter(figure.where(kind: table)).at(loc).first()) //手动生成表的编号
            }
            ~~
            #caption //表题本体
            #v(3pt)
          ]),
          ..headline.children //表头
        ),
        ..cells, //表格的其余部分
        table.hline(stroke: 1.5pt),
      )
      #firstHeader.update(true)
    ]
  }
)

// biaoge: 可以生成带有标签和表题的三线表
#let biaogeHint = [
  |*`#biaoge(...)` 使用方法*| < |
  | -------------- | -------------- |
  | caption:       | [表题]          |
  | body:          | [Markdown表格]  | 
  | label:         | \<标签\>，可不填  |
  | 合并单元格       | `^`或`<`        |
]

#let default-biaoge-caption = highlight(
  fill: black, 
  radius:1pt, 
  extent: 3pt, 
  top-edge: 1.2em, 
  bottom-edge: -0.5em, 
  text(white)[*`未命名表格`*]
)

#let biaoge(caption: default-biaoge-caption, body: biaogeHint, label: none) = {
  align(center)[
    #show figure: set block(breakable: true)
    #figure(
      caption: caption,
      three-line-table(caption, body),
    ) #label
  ]
}

#let daimaHint=````typst
  #daima(
    body:```python
    INSERT YOUR CODE HERE
    ```,
    caption: [代码标题]，
    label: <标签>,
  )
  ````

#let default-daima-caption = highlight(
  fill:black, 
  radius:1pt, 
  extent: 3pt, 
  top-edge: 1.2em, 
  bottom-edge: -0.5em, 
  text(white)[*`未命名代码`*]
)

#let daima(body:daimaHint, caption:default-daima-caption, label: none) = {
  align(center)[
    #block(breakable: false)[
      #figure(
        rect(width: auto, inset: 0.7em, stroke: 0.7pt)[
          #set par(leading: 0.5em)
          #body
        ],
        caption: caption, 
        kind: "code", 
        supplement: "代码",
      ) #label
    ]
  ]
}

#[
  #set align(center+horizon)
  #set text(size: 30pt, fill: white)
  #set page(fill: eastern)
  
  您现在正在预览"utils.typ"

  \

  请预览template目录下的
  
  "正文.typ"

]