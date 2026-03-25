#import "utils.typ": *
#import "@preview/a2c-nums:0.0.1": int-to-cn-simple-num
#import "@preview/modern-nju-thesis:0.4.0": bilingual-bibliography
#import "@preview/cuti:0.4.0": show-cn-fakebold
#show: show-cn-fakebold

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
