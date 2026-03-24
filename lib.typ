#import "@preview/a2c-nums:0.0.1": int-to-cn-simple-num
#import "@preview/cuti:0.4.0": show-cn-fakebold
#show: show-cn-fakebold
#import "@preview/modern-nju-thesis:0.4.0": bilingual-bibliography

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

// tablem包: 允许使用类markdown语法绘制表格
#import "@preview/tablem:0.3.0": tablem

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
  |#text(red)[【`#biaoge(...)` 使用方法】]|<|
  | -------------- | -------------- |
  | caption:       | [表题]          |
  | body:          | [Markdown表格]  | 
  | label:         | \<标签\>，可不填  |
  | 合并单元格       | `^`或`<`        |
]
#let biaoge(caption:text(red)[【未命名表格】], body: biaogeHint, label: none) = {
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

#let daima(body:daimaHint, caption:text(red)[【未命名代码块】], label: none) = {
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



#let conf(

字体: (
  仿宋: ("Times New Roman", "FangSong"),
  宋体: ("Times New Roman", "SimSun"),
  黑体: ("Arial","SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("DejaVu Sans Mono"),
),

文章类型: "Theis", //"Thesis"或"Dissertation"

作者名: "某某某",

作者_英: "Some Guy",

论文题目:[
  
  清华大学研究生学位论文
  
  Typst模板
],

论文题目_英: "Tsinghua Thesis Typst Template",

副标题: "申请清华大学医学博士学位论文",

院系: "基础医学系",

英文学位名: "Doctor of Medicine",

专业: "基础医学",

专业_英: "Basic Medical Sciences",

导师: "某某某 教授",

导师_英: "Professor Some Prof",

副导师: "某某某 教授", //前往template.typ搜索变量名以调整

副导师_英: "Professor Some Prof",

日期: datetime.today(), //默认为当前日期

参考文献格式: "cell", // https://typst.app/docs/reference/model/bibliography/#parameters-style

文献库: "文献库.bib",

目录深度: 3,

盲审版本: false,

插图清单: true,

附表清单: true,

代码清单: false, // 尚未调整

另页右页: false, // 目前有bug

others: none,

doc: none

) = {


set page("a4",
    header: context {
      //let currentPage = here().page()
      let nextFooterLoc = query(selector(<__footer__>).after(here())).first().location()
      let chaptersBefore = query(selector(heading.where(level:1)).before(nextFooterLoc))
      let currentChapNumber = chaptercounter.at(nextFooterLoc).first()
      if chaptersBefore != (){
        [
          #set align(center)
          #set text(字号.五号, font: 字体.宋体)
          #if currentChapNumber > 0 and chaptersBefore.last().numbering != none {chinesenumbering(currentChapNumber)+h(1em)}
          #chaptersBefore.last().body
          #v(-5pt)
          #line(length: 100%)
          #v(-18pt)
        ]
      }
    },
    
    footer: context [
        #set align(center)
        #set text(字号.五号, font: 字体.宋体)
        #if query(selector(heading).before(here())) != () [
          #move(dy:-12pt,counter(page).display())
        ]#label("__footer__")
      ]
  )

  set text(字号.一号, font: 字体.宋体, lang: "zh")
  set align(center + horizon)
  set heading(numbering: chinesenumbering)
  set figure(
    numbering: (..nums) => context { let loc = here()
      if appendixcounter.at(loc).first() < 10 {
        numbering("1.1", chaptercounter.at(loc).first(), ..nums)
      } else {
        numbering("A.1", chaptercounter.at(loc).first(), ..nums)
      }
    }
  )
  set math.equation(
    numbering: (..nums) => context { let loc = here()
      set text(font: 字体.宋体)
      if appendixcounter.at(loc).first() < 10 {
        numbering("（1.1）", chaptercounter.at(loc).first(), ..nums)
      } else {
        numbering("（A.1）", chaptercounter.at(loc).first(), ..nums)
      }
    }
  )
  set list(indent: 2em)
  set enum(indent: 2em)

  //show strong: it => text(font: 字体.黑体, weight: "semibold", it.body)
  show emph: it => text(font: 字体.楷体, style: "italic", it.body)
  set par(first-line-indent: (amount: 2em, all: true))
  show raw: set text(font: 字体.代码)

  show heading: it => {
    set text(font: 字体.黑体, weight: "medium")
    set par(first-line-indent: 0em)
    let showHeading(it, size, above: 0em, below: 0em, hard_above: 0em, hard_below: 0em) = {
    set text(size)
      block(
        above: above, below: below,
        {
          v(hard_above)
          if it.numbering != none {
            counter(heading).display()
            h(1em)
          }
          it.body
          v(hard_below)
        }
      )
    }
    
    if it.level == 1 {
      
      pagebreak(weak: true)
      
      //locate(loc => {
        context { let loc = here()
          if it.body.text == "摘　　要" {
            partcounter.update(10)
            //counter(page).update(1)
          } else if it.numbering != none and partcounter.at(loc).first() < 20 {
            partcounter.update(20)
            //counter(page).update(1)
          } 
        }
      
      if it.numbering != none {
        chaptercounter.step()
      }
      

      
      footnotecounter.update(())
      imagecounter.update(())
      tablecounter.update(())
      rawcounter.update(())
      equationcounter.update(())

      set align(center)

      // 设置heading样式
      showHeading(it, 字号.三号, hard_above: 27pt, below: 29pt)
    } else {
      
      if it.level == 2 {
        showHeading(it, 字号.四号, above: 32pt, below: 16pt)
      } else if it.level == 3 {
        showHeading(it, 字号.中四, above: 21pt, below: 16pt)
      } else {
        showHeading(it, 字号.小四, above: 21pt, below: 16pt)
      }
      
    }
  }
  
  show figure: it => [
    #set align(center)
    #if not it.has("kind") {
      it
    } else if it.kind == image {
      it.body
      [
        #set text(11pt)
        #v(-2pt)
        #it.caption
        #v(11pt)
      ]
    } else if it.kind == table {
      [
        #set text(11pt)
        //#it.caption
      ]
      it.body
    } else if it.kind == "code" {
      it.body
      [
        #set text(11pt)
        #it.caption
      ]
    }
  ]

  show ref: it => {
    if it.element == none {
      // Keep citations as is
      it
    } else {
      // Remove prefix spacing
      h(0em, weak: true)

      let el = it.element
      let el_loc = el.location()
      if el.func() == math.equation {
        // Handle equations
        link(el_loc, [
          式（#chinesenumbering(chaptercounter.at(el_loc).first(), equationcounter.at(el_loc).first(), location: el_loc)）
        ])
      } else if el.func() == figure {
        // Handle figures
        if el.kind == image {
          link(el_loc, [
            图#chinesenumbering(chaptercounter.at(el_loc).first(), imagecounter.at(el_loc).first(), location: el_loc)
          ])
        } else if el.kind == table {
          link(el_loc, [
            表#chinesenumbering(chaptercounter.at(el_loc).first(), tablecounter.at(el_loc).first(), location: el_loc)
          ])
        } else if el.kind == "code" {
          link(el_loc, [
            代码#chinesenumbering(chaptercounter.at(el_loc).first(), rawcounter.at(el_loc).first(), location: el_loc)
          ])
        }
      } else if el.func() == heading {
        // Handle headings
        if el.level == 1 {
          link(el_loc, chinesenumbering(..counter(heading).at(el_loc), location: el_loc))
        } else {
          link(el_loc, [
            第#chinesenumbering(..counter(heading).at(el_loc), location: el_loc)
            节
          ])
        }
      }

      // Remove suffix spacing
      h(0em, weak: true)
    }
  }

  show: it => show-cn-fakebold(it)


  // let fieldvalue(value) = [
  //   #set align(left)
  //   #grid(
  //     rows: (auto, auto),
  //     row-gutter: 0.2em,
  //     value,
  //   )
  // ]



  
// 封面

  set page(margin: (x: 4cm, y: 6cm))
  set align(top)
  set par(spacing: 1em)
  // place(rect( width: 100%,height: 100%,)) //显示页边距
  v(5pt)
  text(字号.一号, font: 字体.黑体)[#论文题目]

  v(7pt)
  text(字号.小二, font: 字体.宋体, tracking: 1pt)[（#副标题）]
  
  set text(字号.三号, font: 字体.仿宋)


  set align(bottom)
  let coverInfoKeyWidth = 5em
  grid(
    rows: 12pt,
    columns: (5em,2em, auto),
    row-gutter: 1.2em,
    scatterChars("培养单位", width: coverInfoKeyWidth),h(0.5em)+"：",
    scatterChars(院系),
    
    scatterChars("学科", width: coverInfoKeyWidth),h(0.5em)+"：",
    scatterChars(专业),
    
    scatterChars("研究生", width: coverInfoKeyWidth),h(0.5em)+"：",
    scatterChars(作者名, width: 4em),
    
    scatterChars("指导教师", width: coverInfoKeyWidth),h(0.5em)+"：",
    scatterChars(导师, width: 8em),

    if 副导师 != none{
      grid(
        rows: 12pt,
        columns: (5em,2em, auto),
        row-gutter: 1.2em,
        scatterChars("副指导教师", width: coverInfoKeyWidth),h(0.5em)+"：",
        scatterChars(副导师, width: 8em), 
      )
   }
  )
  
  
  v(55pt)
   text(字号.三号, font: 字体.宋体)[
    #str(int-to-cn-simple-num(日期.year())+"年"+chinesenumber(日期.month(),standalone: true)+"月")
  ]
  v(15pt)




// 书脊
pagebreak()
set align(top + left)
set text(字号.小四, font: 字体.宋体)
[
  #set page(margin: (x: 1cm, y: 5.5cm))
  //#place(rect( width: 100%,height: 100%,)) //显示页边距
  #set text(字号.小三, font: 字体.仿宋)
  #set align(top + left)
  
  #let r(c) = if (c.contains(regex("[[:ascii:]]"))) {
    c
  } else {
    rotate(-90deg,c)
  }

  // 将论文题目由Markup转换为字符串并添加空格
  #let spine-format(markup) = {
    let space = [ ].func()
    let extract(it) = {
      if type(it) == str { it }
      else if type(it) == array { it.map(extract).join() }
      else if type(it) == content {
        if it.func() in (text, raw) { it.text }
        else if it.has("children") { it.children.map(extract).join() }
        else if it.has("body") { extract(it.body) }
        else if it.func() in (space, parbreak, linebreak) { " " }
        else if it.func() == smartquote { "\"" }
        else { "" }
      } else { "" }
    }
    let s = extract(markup).replace(regex("[\r\n]+"), " ")
    s = s.replace(regex("([\x00-\x7F])([^\x00-\x7F])"), m => m.captures.at(0) + " " + m.captures.at(1))
    s = s.replace(regex("([^\x00-\x7F])([\x00-\x7F])"), m => m.captures.at(0) + " " + m.captures.at(1))
    s.replace(regex("\s+"), " ").trim()
  }
  
  #move(dx: 18.45cm,dy: -0.7em,
  rotate(90deg, origin: (left+bottom))[
    #set align(left)
    #stack(
      dir:ltr,
      ..spine-format(论文题目).clusters().map(
          c => r(c)
      )
    )
  ])
  #set align(bottom + right)
  #move(dx: -0.5cm,dy: 0em,
  rotate(90deg, origin: (right+bottom))[
    #set align(left)
    #box(width: 5em,
    stack(
      dir:ltr,
      ..作者名.clusters().map(
          c => r(c)
      ).intersperse(1fr),
    ))
  ])
]



//英文封面

pagebreak()
set text(top-edge: "ascender")
[
  #set page(margin: (top: 5.5cm, bottom:5cm, x: 3.6cm))
  //#place(rect( width: 100%,height: 100%,)) //显示页边距
  #set align(top + center)
  #[
    #v(5pt)
    #set par(spacing: 0.7em)
    #set text(20pt, font: 字体.黑体)
    #strong[#论文题目_英]
  ]

  #set align(bottom)
  #set text(字号.三号, font: 字体.宋体)
  #set par(spacing: 1.02em)
  
  #文章类型 submitted to
  
  *Tsinghua University*
  
  in partial fulfillment of the requirement
  
  for the degree of
  
  #text(font: 字体.黑体)[*#英文学位名*] 
  
  in
  
  #text(font: 字体.黑体)[*#专业_英*]
  
  \
  
  #text(font: 字体.黑体)[by]

  #text(font: 字体.黑体)[*#作者_英*]
  
  \
  
  #text(字号.小三)[
    #grid(
      columns: (12em,1em,20em),
      align: (right,left,left),
      [#文章类型 Supervisor],":  ",导师_英
    )
    
    #if 副导师_英 != none{
      grid(
        columns: (12em,1em,20em),
        align: (right,left,left),
        [Associate Supervisor],":  ",副导师_英
      )
    }
  ]
  #v(25pt)
  #text(font: 字体.黑体)[*#日期.display("[month repr:long], [year]")*]
  #v(4pt)
]

set page(margin:3cm)



// 学位论文指导小组、公开评阅人和答辩委员会名单

pagebreak()
[
  //#place(rect(width: 100%,height: 100%,)) //显示页边距
  #set align(top+center)
  #set text(字号.小四, font: 字体.宋体)
  #show strong: it => text(字号.四号, font: 字体.黑体, it.body)
  #v(26pt)
  #if others.指导小组名单!=none{
    text(字号.三号, font: 字体.黑体)[学位论文指导小组、公开评阅人和答辩委员会名单]
  } else{
    text(字号.三号, font: 字体.黑体)[学位论文公开评阅人和答辩委员会名单]
  }
  
  #v(33pt)
  
  #if others.指导小组名单!=none [
    *指导小组名单*
    #v(-4pt)
    #grid(
      inset: (y: 2pt),
      columns: (20%, 20%, 60%), row-gutter: 0.6em, align: (center + horizon), ..others.指导小组名单
    )
    #v(16pt)
  ]

  *公开评阅人名单*
  #v(-4pt)
  #if others.公开评阅人名单 != none{
    grid(
      inset: (y: 2pt),
      columns: (20%, 20%, 60%), row-gutter: 0.6em, align: (center + horizon), ..others.公开评阅人名单
    )
  } else [
    无（全隐名评阅）
  ]
  
  #v(16pt)


  *答辩委员会名单*
  #v(-4pt)
  #grid(
    inset: (y: 2pt),
    columns: (20%, 20%, 20%, 40%), rows: auto, row-gutter: 0.6em, align: (center + horizon), ..others.答辩委员会名单
    )
]



// 关于学位论文使用授权的说明
set par(justify: true)
pagebreak()
[
  #set align(left + top)
  //#show heading: set text(字号.二号, font: 字体.黑体)
  #[
    #set align(center)
    #v(39pt)
    #text(字号.二号, font: 字体.黑体)[关于学位论文使用授权的说明]
    #v(25pt)
  ]
  
  #set text(字号.四号)
  #set par(justify: true, leading: 1em, spacing: 14pt)
  
  #others.授权
  
  #v(23pt)
  #set text(字号.小四)
  #h(32pt) 作者签名：\_\_\_\_\_\_\_\_\_\_\_\_　　　　导师签名：\_\_\_\_\_\_\_\_\_\_\_\_
  #v(16pt)
  #h(32pt) 日　　期：\_\_\_\_\_\_\_\_\_\_\_\_　　　　日　　期：\_\_\_\_\_\_\_\_\_\_\_\_
]

// 博士生对本论文系统性和创新性的总结 

if others.系统性创新性 != none {
  let empty-footer = [#sym.zws #label("__footer__")]
  set page(
    footer: empty-footer, 
    header: [
      #set align(center)
      #set text(字号.五号, font: 字体.宋体)
      博士生对本论文系统性和创新性的总结
      #v(-5pt)
      #line(length: 100%)
      #v(-18pt)
    ])
    
  [
    #set align(center)
    #v(27pt)
    #text(字号.三号, font: 字体.黑体)[博士生对本论文系统性和创新性的总结]
    #v(29pt)
  ]
  others.系统性创新性
}


// 中文摘要
  
  set page(numbering: "I")
  counter(page).update(1)
  set par(leading: 10pt, spacing: 10pt)
  
  heading(numbering: none, outlined: true, "摘　　要")
  
  others.摘要
  
  set par(first-line-indent: 0em)
  linebreak()
  text(font: 字体.黑体)[关键词：]
  others.关键词.join("；")




// English abstract

  heading(numbering: none, outlined: true, "Abstract")

  set par(first-line-indent: (amount: 2em,all: true),justify: true)

  
  others.摘要_英

  linebreak()
  set par(first-line-indent: 0em)
  [*Keywords:* ]
  others.关键词_英.join("; ")


  
// 目录

show outline.entry.where(level: 1):it=>{
  set par(spacing: 15pt)
  set text(字号.小四, font: 字体.黑体)
  //it.prefix()
  let loc = it.element.location()
  let actual_loc=query(selector(<__footer__>).after(loc)).first().location()
  let chap = counter("chapter").at(actual_loc).last()
  if chap > 0 and it.element.numbering != none{
    chinesenumbering(chap,location: loc)+h(1em)
  }
  
  it.body()
  set text(font: 字体.宋体)
  box(width: 1fr, it.fill)
  it.page()
  parbreak();
}
show outline.entry.where(level:2): set block(above: 0.8em)
show outline.entry.where(level:3): set block(above: 0.8em)

outline(
  title: "目　　录",
  depth: 目录深度,
  indent: 1em,
)



// 图表清单

show outline.entry.where(level: 1):it=>{
  box({
    [
      #set text(字号.小四, font: 字体.宋体)
      #it.prefix()
      #it.body()
      #set text(font: 字体.宋体)
      #box(width: 1fr, it.fill)
      #it.page()
    ]
  })
} 


if 插图清单 {
   listoffigures(title: "插图清单", kind: image)
  // outline(
  //   title: "插图清单",
  //   target: figure.where(kind: image),
  // )

}


if 附表清单 {

  listoffigures(title: "附表清单", kind: table)
}


if 代码清单 {

  listoffigures(title: "代码清单", kind: "code")
}



// 符号和缩略语说明

heading(numbering: none, outlined: true, "符号和缩略语说明")
show terms.item: it=>{
  grid(
    columns: (8em, auto),

    it.term,
    it.description,
  )
}

others.符号和缩略语

if 另页右页 == true {
  pagebreak(to: "odd")
} else {
  pagebreak(weak: true)
}
  

// 正文内容
  
set align(left + top)
set par(first-line-indent: (amount: 2em, all: true))
set text(字号.小四, font: 字体.宋体)
set page(numbering: "1")
counter(page).update(1)
 

doc



// 附录

appendix()
pagebreak()
others.附录



  // 致谢
  
  heading(numbering: none, outlined: true, "致　　谢")
  others.致谢
  
  
  
  // 声明
  
  heading(numbering: none, outlined: true, "声　　明")
  [
    #others.声明
    #v(3em)
    #set align(right)
    签　名：\_\_\_\_\_\_\_\_\_\_\_\_　日　期：\_\_\_\_\_\_\_\_\_\_\_\_
  ]
  
  
  
  // 简历、成果
  
  heading(numbering: none, outlined: true, "个人简历、在学期间完成的相关学术成果")
  {
    set heading(outlined: false)
    show heading.where(level: 2): it=>{
      
      set align(center)
      set text(字号.四号, font:字体.黑体, weight: "medium")
      v(24pt)
      it.body
      v(6pt)
    }
    show heading.where(level: 3): it=>{
      
      set par(first-line-indent: 0em)
      set align(left)
      set text(字号.小四, font:字体.黑体, weight: "medium")
      v(24pt)
      it.body
    }
    set enum(
      numbering: "[1]",
      indent: 0em,
      body-indent: 1em,
      number-align: start + top
    )
      others.简历和成果
  }
  
  
  
  // 指导教师评语
  
  heading(numbering: none, outlined: true, "指导教师评语")
  others.指导教师评语
  
  
  
  // 答辩委员会决议书
  
  heading(numbering: none, outlined: true, "答辩委员会决议书")
  others.答辩委员会决议书

  if others.其他材料 != none {
    heading(numbering: none, outlined: true, "其他材料")
    others.其他材料
  }
  
}

#[
  #set align(center+horizon)
  #set text(size: 30pt, fill: white)
  #set page(fill: eastern)
  
  您现在正在预览"lib.typ"

  \

  请预览template目录下的
  
  "正文.typ"

]
