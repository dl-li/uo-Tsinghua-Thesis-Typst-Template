#import "../lib.typ": *
#import "设置与其他.typ": *
#show: this_doc => conf(..settings, doc: this_doc, others: other_contents)






= 简要教程

#emoji.face.monocle 建议将本教程的源码和PDF预览结合食用

== 初始化

论文的基础信息设置与正文以外的内容请前往 `设置与其他.typ`填写。开始前请务必在此处配置字体，消除字体相关警告。

== 标题

使用等号衔接空格标记标题，等号数量对应标题层级，例如：`= 一级标题（章节标题）`、`== 二级标题`，以此类推。

== 正文

普通文本（Regular Text）。
两侧添加星号显示为*加粗文本（Bold text）*。
两侧添加下划线将中文显示为_楷体_，西文显示为斜体/意大利体（_Italic Text_）。
两侧添加反单引号显示为行内代码（`Inline Code`）样式。
两侧添加Dollar符号显示为数学公式 $dot(z) = 6$ 。
两侧添加斜杠和星号，不显示/*被包含在其中的*/文本。 //在文本前添加双斜杠也可以做到。

分段应空行，而不是简单换行。

上下标使用`#super[]`和`#sub[]`实现，例如：#super[上标] #sub[下标]

特殊符号使用`#sym.xxx`输入，详见https://typst.app/docs/reference/symbols/sym/

== 脚注

使用`#footnote[]`可以在添加脚注。#footnote[脚注处序号“①，……，⑩”的字体是“正文”，不是“上标”，序号与脚注内容文字之间空半个汉字符，脚注的段落格式为：单倍行距，段前空0磅，段后空0磅，悬挂缩进1.5字符；字号为小五号字，汉字用宋体，外文用Times New Roman体。]


== 图片

简单图片可以使用 `#tupian()` 添加，如 @图片示例 所示。该函数支持便捷地添加图注（description），且图片本体与图题、图注不会跨页。

写作时，直接打出`#tupian()`，即可在预览界面看到该函数的用法提示。

#tupian(
  body: none, // body: image("/path/to/image.png")
  width: 70%,
  caption: [图题],
  description: [#lorem(30)],
  label: <图片示例>
) // width, description 和 label可以不填

更复杂的图片排版请使用原生的`#figure()`函数搭配`#image()`函数实现，详见 https://typst.app/docs/reference/model/figure/。两种方式添加的图片编号互通。

== 表格

简单表格片可以使用 `#biaoge()` 添加，如@表格示例 所示。该函数支持使用Markdown语法便捷地生成三线表（Powered by `tablem`），且跨页自动生成续表题。

写作时，直接打出`#bioage()`，即可在预览界面看到该函数的用法提示。

#biaoge(
  caption: [表题],
  body:[
      | *`#biaoge()` 参数名*          | *示例*                   |
      | ---------------------------- | ----------------------- |
      | `caption:`                   | `[Some caption]`        |
      | `body:`                      | `[Markdown-like table]` |
      | `label:`                     | `<Some_Label>`          |
      | ^/*垂直(^)或水平(<)合并单元格*/  | or no label             |
  ],
  label: <表格示例>
)

更复杂的表格排版请使用原生的`#figure()`函数搭配`#table()`函数实现。两种方式添加的表格编号互通。

== 表达式

@米氏方程 是一个表达式示例，其中$K_m$为米氏常数。

$
 v_0 = ( V_max [S] ) / ( K_m + [S] )
$ <米氏方程>

== 代码块

代码块可以使用 `#daima()` 添加，如 @冒泡排序 所示。写作时，接打出`#daima()`即可在预览界面看到该函数的用法提示。

#daima(
  body:```python
    def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        swapped = False
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr
  ```,
  caption: [使用Python实现冒泡排序的代码],
  label: <冒泡排序>
)

《指南》中未对代码样式及编号规则作要求。故本模板对代码块作了简单的格式调整，并单独编号。


== 引用

=== 内部交叉引用 <交叉引用教程> 

为了防止编号与实际内容不对应的情况发生，行文时提及被编号的内容应当避免直接输入其编号，应进行交叉引用。

具体为：首先在被提及的内容后使用尖括号 `< >` 添加标签，然后在提及他们的地方使用 `@` 来引用该标签。表格、图片、表达式、代码、章节、小标题都可以添加标签。例如：本节是 @交叉引用教程。本模板的更新日志参见@更新日志。//附录在`设置与其他.typ`

=== 引用参考文献

在文献管理软件（推荐Zotero，搭配Better BibTeX插件）中将文献库导出为BibLaTeX格式，粘贴到 `文献库.bib` 中（也支持自定义文献库路径），然后在正文中使用 `@` 来引用即可。例如：我在此引用两篇AlphaFold的论文 @AF2 @AF3。

Zotero导出时，如果引文期刊名称需要缩写，请勾选“使用缩写的期刊名”。

引用文献的格式可以在 `论文信息设置.typ` 中设置。详见 https://typst.app/docs/reference/model/bibliography/#parameters-style


== 特殊名词格式

对于一些需要特殊格式或包含特殊字符的名词，逐个调整或输入费时费力。可以使用`#show`规则来统一设置格式，简化输入。例如：
#[
  #set align(center)

  *Before*: Drosophila melanogaster, EcoRI, NF-κB, Lgr5Δ/+

  #show "Dmel": [_Drosophila melanogaster_]
  #show "EcoRI": [#emph[Eco]RI] // 不能直接使用形如 _Eco_RI 的方法来使一个词的一部分斜体
  #show "NF-kappaB": [NF-]+sym.kappa+[B] // κ不方便直接输入
  #show regex("(?i)Lgr5-del"): [_Lgr5_#super[#sym.Delta/+]] // 使用正则表达式 regex("(?i)xxxxx") 来不区分大小写地匹配字符串 

  *After*: Dmel, EcoRI, NF-kappaB, lgr5-del
]

=== 进阶用法

可以通过定义函数，实现根据特定规则来自动调整格式的效果。
#[
  #let enzyme(name) = {
    let m = name.match(regex("^([^A-Z]*[A-Z][^A-Z]*)([A-Z].*)$"))
    if m != none {
      emph(m.captures.at(0)) + m.captures.at(1)
    } else {
      name
    }
  }
  
  此处定义了`#enzyme()`函数，可以自动调整酶名称的格式：#enzyme("BamHI"), #enzyme("EcoRI"), #enzyme("PspOMI")
]










// 参考文献。请前往`设置与其他.typ`进行配置，勿在此处配置
#bilingual-bibliography(
  bibliography: bibliography.with(settings.文献库),
  style: settings.参考文献格式
)